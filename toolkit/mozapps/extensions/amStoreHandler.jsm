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

var EXPORTED_SYMBOLS = ["StoreHandler"];

/**
 * API to handle manipulation of crx extensions to enable
 * installing into Waterfox
 * @class
 */
var StoreHandler = {

    /**
     * Open a channel to be used to fetch a resource
     * @param options
     *        options Object to create channel
     *        example:
     *        {uri: uri.spec, loadUsingSystemPrincipal: true}
     */
    getChannel(options) {
        return NetUtil.newChannel(options);
    },

    /**
     * 
     * @param path
     */
    getNsiFile(path) {
        let nsiFile = new FileUtils.File(path);
        return nsiFile;
    },

    /**
     * 
     * @param channel
     */
    attemptInstall(channel, xpiPath, nsiFileXpi, nsiManifest) {
        Services.console.logStringMessage("opens fs");
        NetUtil.asyncFetch(channel, function(aInputStream, aResult) {
            // Check that we had success.
            if (!Components.isSuccessCode(aResult)) {
                Services.console.logStringMessage("Fetching resource failed");
                return false;
            };
            // write nsiInputStream to nsiOutputStream
            // this was originally in a separate function but had error
            // passing input stream between funcs
            let aOutputStream = FileUtils.openAtomicFileOutputStream(nsiFileXpi);
            NetUtil.asyncCopy(aInputStream, aOutputStream, async function(aResult) {
                // Check that we had success.
                if (!Components.isSuccessCode(aResult)) {
                    Services.console.logStringMessage("Writing to tmp failed");
                    return false;
                };
                await StoreHandler.removeChromeHeaders(xpiPath);
                let manifest = StoreHandler.amendManifest(nsiFileXpi);
                StoreHandler.writeTmpManifest(nsiManifest, manifest);
                StoreHandler.replaceManifestInXpi(nsiFileXpi, nsiManifest);
                await StoreHandler.installXpi(nsiFileXpi);
            });
        });
    },

    /**
     * 
     * @param path
     */
    async removeChromeHeaders(path) {
        try {
            // read using OS.File to enable data manipulation
            let arrayBuffer = await OS.File.read(path);
            // determine Chrome ext headers
            let locOfPk = arrayBuffer.slice(0, 1500);
            for (var i=0; i<locOfPk.length; i++) {
                if (locOfPk[i] == 80 && locOfPk[i+1] == 75 && locOfPk[i+2] == 3 && locOfPk[i+3] == 4) {
                    locOfPk = null;
                    break;
                }
            };
            // remove Chrome ext headers
            let zipBuffer = arrayBuffer.slice(i);
            Services.console.logStringMessage(zipBuffer);
            // overwite .zip with headers removed as ZipReader only compatible with nsiFile type, not Uint8Array
            let writeFile = await OS.File.writeAtomic(path, zipBuffer);
            return true;
        } catch(e) {
            Services.console.logStringMessage("Error removing Chrome headers");
            return false;
        }
    },

    /**
     * 
     * @param file
     */
    amendManifest(file) {
        try {
            // unzip nsiFile object
            let zr = new ZipReader(file);
            let entryPointer = "manifest.json";
            let manifest = "";
            if (zr.hasEntry(entryPointer)) {
                let entry = zr.getEntry(entryPointer);
                Services.console.logStringMessage("entryPointer: " + entryPointer);
                let inputStream = zr.getInputStream(entryPointer);
                let rsi = new ReusableStreamInstance(inputStream);
                let fileContents = rsi.read(entry.realSize);
                manifest = JSON.parse(fileContents);
                // determine potential incompatibilties here, return installation error if found
                manifest.applications = {
                    gecko: {
                        id: "test" + "@waterfox-unsigned"
                    }
                };
                delete manifest.update_url;
                manifest = JSON.stringify(manifest);
            }
            // close zipReader
            zr.close();
            return manifest;
        } catch(e) {
            Services.console.logStringMessage("Error updating manifest");
            return false;
        }
    },

    /**
     *
     * @param file
     * @param manifest
     */
    writeTmpManifest(file, manifest) {
        // create new manifest
        let manifestOutputStream = FileUtils.openAtomicFileOutputStream(file);
        manifestOutputStream.write(manifest, manifest.length);
    },

    /**
     *
     * @param xpiFile
     * @param manifestFile
     */
    replaceManifestInXpi(xpiFile, manifestFile) {
        try {
            let pr = {PR_RDONLY: 0x01, PR_WRONLY: 0x02, PR_RDWR: 0x04, PR_CREATE_FILE: 0x08, PR_APPEND: 0x10, PR_TRUNCATE: 0x20, PR_SYNC: 0x40, PR_EXCL: 0x80};
            zw.open(xpiFile, pr.PR_RDWR);
            zw.removeEntry("manifest.json", false)
            zw.addEntryFile("manifest.json", Ci.nsIZipWriter.COMPRESSION_NONE, manifestFile, false); //NS_ERROR_FILE_NOT_FOUND
            zw.close();
        } catch(e) {
            Services.console.logStringMessage("Error replacing manifest")
            return false;
        }
    },

    /**
     * 
     * @param xpiFile
     */
    async installXpi(xpiFile) {
        // attempt to install the xpi
        let install = await AddonManager.getInstallForFile(xpiFile)
        install.install(); //installs silently
            // let win = Services.wm.getMostRecentWindow("navigator:browser");
            // let browser = win.gBrowser;
            // let systemPrincipal = Services.scriptSecurityManager.getSystemPrincipal();
            // AddonManager.installAddonFromWebpage(
            //     "application/x-xpinstall",
            //     browser,
            //     systemPrincipal,
            //     install
            // );
    }
}