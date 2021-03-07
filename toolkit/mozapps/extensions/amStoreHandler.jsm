"use strict";

const { XPCOMUtils } = ChromeUtils.import("resource://gre/modules/XPCOMUtils.jsm");

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

XPCOMUtils.defineLazyModuleGetters(this, {
    AddonManager: "resource://gre/modules/AddonManager.jsm",
    FileUtils: "resource://gre/modules/FileUtils.jsm",
    OS: "resource://gre/modules/osfile.jsm",
    NetUtil: "resource://gre/modules/NetUtil.jsm"
});

const ZipReader = Components.Constructor(
    "@mozilla.org/libjar/zip-reader;1",
    "nsIZipReader",
    "open"
);

const zw = Components.classes["@mozilla.org/zipwriter;1"]
                .createInstance(Components.interfaces.nsIZipWriter);

const ReusableStreamInstance = Components.Constructor(
    "@mozilla.org/scriptableinputstream;1",
    "nsIScriptableInputStream",
    "init"
);

const uuidGenerator = Components.classes["@mozilla.org/uuid-generator;1"]
                    .getService(Components.interfaces.nsIUUIDGenerator);

var EXPORTED_SYMBOLS = ["StoreHandler"];

/**
 * API to handle manipulation of crx extensions to enable
 * installing into Waterfox
 * @class
 */
var StoreHandler = {

    /**
     * Remove dir if it exists
     * @param dir string absolute path to directory to remove
     */
    flushDir(dir) {
        return new Promise(resolve => {
            const nsiDir = this.getNsiFile(dir);
            if (nsiDir.exists()) {
                // remove all files
                nsiDir.remove(true);
            }
            resolve();
        })
    },

    /**
     * Return extension UUID, set and return if not already set
     */
    getUUID: function __getUUID() {
        if (!this._extensionUUID) {
            this._setUUID();
        };
        return this._extensionUUID;
    },

    /**
     * Set extension UUID
     */
    _setUUID: function __setUUID() {
        let uuid = uuidGenerator.generateUUID();
        let uuidString = uuid.toString();
        this._extensionUUID = uuidString;
    },

    /**
     * Reset extension UUID
     */
    _resetUUID: function __resetUUID() {
        return new Promise(resolve => {
            this._extensionUUID = undefined;
            resolve();
        })
    },

    /**
     * Display prompt in event of failed installation
     * @param msg string message to display
     */
    _installFailedMsg: function __installFailedMsg(msg="Encountered an error during extension installation") {
        Services.prompt.alert(
            null,
            "Extension Install Failure",
            msg
          )
    },

    /**
     * Get an nsiFile object from a given path
     * @param path string path to file
     */
    getNsiFile(path) {
        let nsiFile = new FileUtils.File(path);
        return nsiFile;
    },

    /**
     * Attempt to install a crx extension
     * @param uri object uri of request
     * @param xpiPath string path to tmp extension file
     * @param nsiFileXpi nsiFile tmp xpi file
     * @param nsiManifest nsiFile tmp manifest.json
     * @param retry bool is this a retry attempt or not
     */
    attemptInstall(uri, xpiPath, nsiFileXpi, nsiManifest, retry=false) {
        let channel = NetUtil.newChannel({uri: uri.spec, loadUsingSystemPrincipal: true});
        NetUtil.asyncFetch(channel, (aInputStream, aResult) => {
            // Check that we had success.
            if (!Components.isSuccessCode(aResult)) {
                if (retry == false) {this.attemptInstall(uri, xpiPath, nsiFileXpi, nsiManifest, true);return false;}
                this._installFailedMsg("Fetching resource failed");
                return false;
            };
            // write nsiInputStream to nsiOutputStream
            // this was originally in a separate function but had error
            // passing input stream between funcs
            let aOutputStream = FileUtils.openAtomicFileOutputStream(nsiFileXpi);
            NetUtil.asyncCopy(aInputStream, aOutputStream, async (aResult) => {
                // Check that we had success.
                if (!Components.isSuccessCode(aResult)) {
                    // delete any tmp files
                    this._cleanup(nsiFileXpi);
                    this._installFailedMsg("Writing to tmp failed");
                    return false;
                };
                try {
                    await this._removeChromeHeaders(xpiPath);
                    let manifest = this._amendManifest(nsiFileXpi);
                    if (manifest instanceof Array) {
                        this._cleanup(nsiFileXpi);
                        this._installFailedMsg(
                            "This addon requires use of the following unsupported APIs: " + manifest.join(",")
                            )
                        return false;
                    }
                    this._writeTmpManifest(nsiManifest, manifest);
                    this._replaceManifestInXpi(nsiFileXpi, nsiManifest);
                    await this._installXpi(nsiFileXpi);
                    this._cleanup(nsiFileXpi);
                    this._resetUUID();
                } catch(e) {
                    // delete any tmp files
                    this._cleanup(nsiFileXpi);
                    this._installFailedMsg("Issue installing extension :" + e);
                    return false;
                };
            });
        });
    },

    /**
     * Remove Chrome headers from crx addon
     * @param path string path to downloaded extension file
     */
    _removeChromeHeaders: async function __removeChromeHeaders(path) {
        try {
            // read using OS.File to enable data manipulation
            let arrayBuffer = await OS.File.read(path);
            // determine Chrome ext headers
            let locOfPk = arrayBuffer.slice(0, 3000);
            for (var i=0; i<locOfPk.length; i++) {
                if (locOfPk[i] == 80 && locOfPk[i+1] == 75 && locOfPk[i+2] == 3 && locOfPk[i+3] == 4) {
                    locOfPk = null;
                    break;
                }
            };
            if (i == 3000) {
                Services.console.logStringMessage("Magic not found");
                return false;
            };
            // remove Chrome ext headers
            let zipBuffer = arrayBuffer.slice(i);
            // overwite .zip with headers removed as ZipReader only compatible with nsiFile type, not Uint8Array
            await OS.File.writeAtomic(path, zipBuffer);
            return true;
        } catch(e) {
            Services.console.logStringMessage("Error removing Chrome headers");
            return false;
        }
    },

    /**
     * Check API compatability and maybe add id and remove update_url from manifest
     * @param file nsiFile tmp extension file
     */
    _amendManifest: function __amendManifest(file) {
        try {
            // unzip nsiFile object
            let zr = new ZipReader(file);
            let manifest = this._parseManifest(zr);
            // only manifest version 2 currently supported
            if (manifest.manifest_version != 2) {
                this._installFailedMsg("Manifest version not supported, must be manifest_version: 2");
                return false;
            }
            // ensure locale properties set correctly
            manifest = this._localeCheck(manifest, zr);
            // check API compatibility
            let unsupportedApis = this._manifestCompatCheck(manifest);
            if (unsupportedApis.length > 0) {
                return unsupportedApis;
            }
            manifest.applications = {
                gecko: {
                    id: this.getUUID()
                }
            };
            // cannot allow auto update of crx extensions
            delete manifest.update_url;
            manifest = JSON.stringify(manifest);
            // close zipReader
            zr.close();
            return manifest;
        } catch(e) {
            Services.console.logStringMessage("Error updating manifest: " + e);
            return false;
        }
    },

    /**
     * Parse manifest file into JS Object
     * @param zr nsiZipReader ZipReader object
     */
    _parseManifest: function __parseManifest(zr) {
        let entryPointer = "manifest.json";
        if (zr.hasEntry(entryPointer)) {
            let entry = zr.getEntry(entryPointer);
            let inputStream = zr.getInputStream(entryPointer);
            let rsi = new ReusableStreamInstance(inputStream);
            let fileContents = rsi.read(entry.realSize);
            let manifest = JSON.parse(fileContents);
            return manifest;
        }
    },

    /**
     * Check support for APIs in manifest
     * @param manifest Object manifest to compatibility check
     */
    _manifestCompatCheck: function __manifestCompatCheck(manifest) {
        let unsupported = {
            "externally_connectable":"",
            "storage":"",
            "chrome_settings_overrides":{
                "search_provider":{
                    "alternate_urls":"",
                    "image_url":"",
                    "image_url_post_params":"",
                    "instant_url":"",
                    "instant_url_post_params":"",
                    "prepopulated_id":""
                },
                "startup_pages":""
            },
            "chrome_url_overrides":{
                "bookmarks":"",
                "history":""
            },
            "commands":{
                "global":""
            },
            "incognito":"split",
            "offline_enabled":"",
            "optional_permissions":
                ["background",
                "contentSettings",
                "contextMenus",
                "debugger",
                "pageCapture",
                "tabCapture"
                ],
            "options_page":"",
            "permissions":
                ["background",
                "contentSettings",
                "debugger",
                "pageCapture",
                "tabCapture"
                ],
            "version_name":""
        }
        var unsupportedInManifest = [];
        Object.entries(manifest).forEach((arr) => {
            if (Object.keys(unsupported).includes(arr[0]) && unsupported[arr[0]] == "") {
                // if manifest key is in unsupported list and
                // no value associated with unsupported key
                // we know it's unsupported in it's entirety
                unsupportedInManifest.push(arr[0]);
            } else if (Object.keys(unsupported).includes(arr[0]) &&
            typeof unsupported[arr[0]] == "string" && unsupported[arr[0]] == arr[1]) {
                // if key is unsupported and value matches
                // value in unsupported, we know the kv pair
                // only is unsupported
                unsupportedInManifest.push(arr[0] + ": " + arr[1]);
            } else if (Object.keys(unsupported).includes(arr[0]) &&
            unsupported[arr[0]] instanceof Array && arr[1] instanceof Array) {
                // if value in unsupported is an array, we know
                // key is permissions related so we need to check
                // each permission against the unsupported array
                var permissionArr = [];
                arr[1].forEach((value) => {
                    if (unsupported[arr[0]].includes(value)) {permissionArr.push(value);}
                })
                if (permissionArr.length > 0) {
                    unsupportedInManifest.push(permissionArr.join(","));
                }
            } else if (Object.keys(unsupported).includes(arr[0]) &&
            typeof unsupported[arr[0]] == "object" && typeof arr[1] == "object") {
                // if value in unsupported is object we need to
                // identify if this is the final layer or if there
                // is another object for one of the keys here
                Object.keys(arr[1]).forEach((key) => {
                    if (Object.keys(unsupported[arr[0]]).includes(key) &&
                    typeof unsupported[arr[0]][key] == "string") {
                        // if object value in unsupported is string we know that
                        // it is unsupported in it's entirety
                        unsupportedInManifest.push(arr[0] + "." + key);
                        // TODO: need to rewrite this to be recursive so we don't have to go down the nesting
                    } else if (Object.keys(unsupported[arr[0]]).includes(key) &&
                    typeof unsupported[arr[0]][key] == "object" && typeof arr[1][key] == "object") {
                        // if object value in unsupported is another object
                        // we have to dig through the extra layer
                        Object.keys(arr[1][key]).forEach((value) => {
                            if (Object.keys(unsupported[arr[0]][key]).includes(value)) {
                                unsupportedInManifest.push(arr[0] + "." + key + "." + value);
                            }
                        })
                    }
                })
            }
        })
        return unsupportedInManifest;
    },

    /**
     * Ensure manifest compliance based on extension contents
     * @param manifest
     * @param zr
     */
    _localeCheck: function __localeCheck(manifest, zr) {
        let entryPointer = "_locales/";
        if (zr.hasEntry(entryPointer)) {
            if (!manifest.default_locale) {
                zr.hasEntry("_locales/en/") ? manifest.default_locale = "en" : manifest.default_locale = "en-US";
            }
        } else {
            if (manifest.default_locale) {
                delete manifest.default_locale;
            }
        }
        return manifest;
    },

    /**
     * Write amended manifest to temporary manifest.json
     * @param file nsiFile tmp manifest.json
     * @param manifest string JSON string of amended manifest
     */
    _writeTmpManifest: function __writeTmpManifest(file, manifest) {
        let manifestOutputStream = FileUtils.openAtomicFileOutputStream(file);
        manifestOutputStream.write(manifest, manifest.length);
    },

    /**
     * Replace the manifest in the tmp extension file with the amended version
     * @param xpiFile nsiFile tmp extension file
     * @param manifestFile nsiFile tmp manifest.json
     */
    _replaceManifestInXpi: function __replaceManifestInXpi(xpiFile, manifestFile) {
        try {
            let pr = {
                PR_RDONLY: 0x01, PR_WRONLY: 0x02, PR_RDWR: 0x04,
                PR_CREATE_FILE: 0x08, PR_APPEND: 0x10, PR_TRUNCATE: 0x20,
                PR_SYNC: 0x40, PR_EXCL: 0x80
            };
            zw.open(xpiFile, pr.PR_RDWR);
            zw.removeEntry("manifest.json", false)
            zw.addEntryFile("manifest.json", Ci.nsIZipWriter.COMPRESSION_NONE, manifestFile, false);
            zw.close();
        } catch(e) {
            Services.console.logStringMessage("Error replacing manifest")
            return false;
        }
    },

    /**
     * Silently install extension
     * @param xpiFile nsiFile tmp extension file to install
     */
    _installXpi: async function __installXpi(xpiFile) {
        let install = await AddonManager.getInstallForFile(xpiFile)
        await install.install(); //installs silently
            // let win = Services.wm.getMostRecentWindow("navigator:browser");
            // let browser = win.gBrowser;
            // let systemPrincipal = Services.scriptSecurityManager.getSystemPrincipal();
            // AddonManager.installAddonFromWebpage(
            //     "application/x-xpinstall",
            //     browser,
            //     systemPrincipal,
            //     install
            // );
    },

    /**
     * Remove tmp files
     * @param zipFile nsiFile tmp extension file
     */
    _cleanup: function __cleanup(zipFile) {
        return new Promise(resolve => {
            let parent = zipFile.parent;
            parent.remove(true);
            resolve();
        })

    }
}