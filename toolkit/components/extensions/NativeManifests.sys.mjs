/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import { AppConstants } from "resource://gre/modules/AppConstants.sys.mjs";

const lazy = {};

ChromeUtils.defineESModuleGetters(lazy, {
  Schemas: "resource://gre/modules/Schemas.sys.mjs",
  WindowsRegistry: "resource://gre/modules/WindowsRegistry.sys.mjs",
});

const DASHED = AppConstants.platform === "linux";

// Supported native manifest types, with platform-specific slugs.
const TYPES = {
  stdio: DASHED ? "native-messaging-hosts" : "NativeMessagingHosts",
  storage: DASHED ? "managed-storage" : "ManagedStorage",
  pkcs11: DASHED ? "pkcs11-modules" : "PKCS11Modules",
};

const NATIVE_MANIFEST_SCHEMA =
  "chrome://extensions/content/schemas/native_manifest.json";

// WATERFOX
// Future rebase take note: leave this so extensions
// can communicate with software without being
// made specifically for Waterfox.
const REGPATH = "Software\\Mozilla";

export var NativeManifests = {
  _initializePromise: null,
  _lookup: null,

  init() {
    if (!this._initializePromise) {
      let platform = AppConstants.platform;
      if (platform == "win") {
        this._lookup = this._winLookup;
      } else if (platform == "macosx" || platform == "linux") {
        let dirs = [
          Services.dirsvc
            .get("XREUserNativeManifests", Ci.nsIFile)
            .path.replace("Waterfox", "Mozilla"),
          Services.dirsvc
            .get("XRESysNativeManifests", Ci.nsIFile)
            .path.replace("Waterfox", "Mozilla"),
        ];
        this._lookup = (type, name, context) =>
          this._tryPaths(type, name, dirs, context);
      } else {
        throw new Error(
          `Native manifests are not supported on ${AppConstants.platform}`
        );
      }
      this._initializePromise = lazy.Schemas.load(NATIVE_MANIFEST_SCHEMA);
    }
    return this._initializePromise;
  },

  async _winLookup(type, name, context) {
    const REGISTRY = Ci.nsIWindowsRegKey;
    let regPath = `${REGPATH}\\${TYPES[type]}\\${name}`;
    let path = lazy.WindowsRegistry.readRegKey(
      REGISTRY.ROOT_KEY_CURRENT_USER,
      regPath,
      "",
      REGISTRY.WOW64_64
    );
    if (!path) {
      path = lazy.WindowsRegistry.readRegKey(
        REGISTRY.ROOT_KEY_LOCAL_MACHINE,
        regPath,
        "",
        REGISTRY.WOW64_32
      );
    }
    if (!path) {
      path = lazy.WindowsRegistry.readRegKey(
        REGISTRY.ROOT_KEY_LOCAL_MACHINE,
        regPath,
        "",
        REGISTRY.WOW64_64
      );
    }
    if (!path) {
      return null;
    }

    // Normalize in case the extension used / instead of \.
    path = path.replaceAll("/", "\\");

    let manifest = await this._tryPath(type, path, name, context, true);
    return manifest ? { path, manifest } : null;
  },

  _tryPath(type, path, name, context, logIfNotFound) {
    return Promise.resolve()
      .then(() => IOUtils.readUTF8(path))
      .then(data => {
        // The JSON files are provided externally and may contain a UTF-8 BOM.
        // IOUtils.readUTF8 does not strip them (bug 1836973), so do that here:
        if (data.charCodeAt(0) == 0xfeff) {
          data = data.slice(1);
        }
        let manifest;
        try {
          manifest = JSON.parse(data);
        } catch (ex) {
          Cu.reportError(
            `Error parsing native manifest ${path}: ${ex.message}`
          );
          return null;
        }

        let normalized = lazy.Schemas.normalize(
          manifest,
          "manifest.NativeManifest",
          context
        );
        if (normalized.error) {
          Cu.reportError(normalized.error);
          return null;
        }
        manifest = normalized.value;

        if (manifest.type !== type) {
          Cu.reportError(
            `Native manifest ${path} has type property ${manifest.type} (expected ${type})`
          );
          return null;
        }
        if (manifest.name !== name) {
          Cu.reportError(
            `Native manifest ${path} has name property ${manifest.name} (expected ${name})`
          );
          return null;
        }
        if (
          manifest.allowed_extensions &&
          !manifest.allowed_extensions.includes(context.extension.id)
        ) {
          Cu.reportError(
            `This extension does not have permission to use native manifest ${path}`
          );
          return null;
        }

        return manifest;
      })
      .catch(ex => {
        if (DOMException.isInstance(ex) && ex.name == "NotFoundError") {
          if (logIfNotFound) {
            Cu.reportError(
              `Error reading native manifest file ${path}: file is referenced in the registry but does not exist`
            );
          }
          return null;
        }
        throw ex;
      });
  },

  async _tryPaths(type, name, dirs, context) {
    for (let dir of dirs) {
      let path = PathUtils.join(dir, TYPES[type], `${name}.json`);
      let manifest = await this._tryPath(type, path, name, context, false);
      if (manifest) {
        return { path, manifest };
      }
    }
    return null;
  },

  /**
   * Search for a valid native manifest of the given type and name.
   * The directories searched and rules for manifest validation are all
   * detailed in the Native Manifests documentation.
   *
   * @param {string} type The type, one of: "pkcs11", "stdio" or "storage".
   * @param {string} name The name of the manifest to search for.
   * @param {object} context A context object as expected by Schemas.normalize.
   * @returns {object} The contents of the validated manifest, or null if
   *                   no valid manifest can be found for this type and name.
   */
  lookupManifest(type, name, context) {
    return this.init().then(() => this._lookup(type, name, context));
  },
};
