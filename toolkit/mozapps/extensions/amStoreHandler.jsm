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
     * Open a channel to be used to fetch a resource
     * @param options Object to create channel
     *        example:
     *        {uri: uri.spec, loadUsingSystemPrincipal: true}
     */
    getChannel(options) {
        return NetUtil.newChannel(options);
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
     * @param channel nsiChannel from download uri
     * @param xpiPath string path to tmp extension file
     * @param manifestPath string path to tmp manifest.json
     * @param nsiFileXpi nsiFile tmp xpi file
     * @param nsiManifest nsiFile tmp manifest.json
     */
    attemptInstall(channel, xpiPath, manifestPath, nsiFileXpi, nsiManifest) {
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
                StoreHandler.cleanup(xpiPath, manifestPath);
            });
        });
    },

    /**
     * Remove Chrome headers from crx addon
     * @param path string path to downloaded extension file
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
     * Add id and remove update_url from manifest
     * @param file nsiFile tmp extension file
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
                let uuid = uuidGenerator.generateUUID();
                let uuidString = uuid.toString().slice(1, -1);
                manifest.applications = {
                    gecko: {
                        id: uuidString + "@waterfox-unsigned"
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
     * Write amended manifest to temporary manifest.json
     * @param file nsiFile tmp manifest.json
     * @param manifest string JSON string of amended manifest
     */
    writeTmpManifest(file, manifest) {
        let manifestOutputStream = FileUtils.openAtomicFileOutputStream(file);
        manifestOutputStream.write(manifest, manifest.length);
    },

    /**
     * Replace the manifest in the tmp extension file with the amended version
     * @param xpiFile nsiFile tmp extension file
     * @param manifestFile nsiFile tmp manifest.json
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
     * Silently install extension
     * @param xpiFile nsiFile tmp extension file to install
     */
    async installXpi(xpiFile) {
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
     * @param zipPath nsiFile tmp extension file
     * @param manifestPath nsiFile tmp manifest.json
     */
    cleanup(zipPath, manifestPath) {
        OS.File.remove(zipPath);
        OS.File.remove(manifestPath);
    }
}