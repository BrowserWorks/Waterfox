/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

this.EXPORTED_SYMBOLS = [ "BookmarkJSONUtils" ];

const Ci = Components.interfaces;
const Cc = Components.classes;
const Cu = Components.utils;
const Cr = Components.results;

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/osfile.jsm");
Cu.import("resource://gre/modules/PlacesUtils.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "NetUtil",
  "resource://gre/modules/NetUtil.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "PlacesBackups",
  "resource://gre/modules/PlacesBackups.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "Deprecated",
  "resource://gre/modules/Deprecated.jsm");

XPCOMUtils.defineLazyGetter(this, "gTextDecoder", () => new TextDecoder());
XPCOMUtils.defineLazyGetter(this, "gTextEncoder", () => new TextEncoder());

/**
 * Generates an hash for the given string.
 *
 * @note The generated hash is returned in base64 form.  Mind the fact base64
 * is case-sensitive if you are going to reuse this code.
 */
function generateHash(aString) {
  let cryptoHash = Cc["@mozilla.org/security/hash;1"]
                     .createInstance(Ci.nsICryptoHash);
  cryptoHash.init(Ci.nsICryptoHash.MD5);
  let stringStream = Cc["@mozilla.org/io/string-input-stream;1"]
                       .createInstance(Ci.nsIStringInputStream);
  stringStream.data = aString;
  cryptoHash.updateFromStream(stringStream, -1);
  // base64 allows the '/' char, but we can't use it for filenames.
  return cryptoHash.finish(true).replace(/\//g, "-");
}

this.BookmarkJSONUtils = Object.freeze({
  /**
   * Import bookmarks from a url.
   *
   * @param aSpec
   *        url of the bookmark data.
   * @param aReplace
   *        Boolean if true, replace existing bookmarks, else merge.
   *
   * @return {Promise}
   * @resolves When the new bookmarks have been created.
   * @rejects JavaScript exception.
   */
  importFromURL: function BJU_importFromURL(aSpec, aReplace) {
    return (async function() {
      notifyObservers(PlacesUtils.TOPIC_BOOKMARKS_RESTORE_BEGIN);
      try {
        let importer = new BookmarkImporter(aReplace);
        await importer.importFromURL(aSpec);

        notifyObservers(PlacesUtils.TOPIC_BOOKMARKS_RESTORE_SUCCESS);
      } catch (ex) {
        Cu.reportError("Failed to restore bookmarks from " + aSpec + ": " + ex);
        notifyObservers(PlacesUtils.TOPIC_BOOKMARKS_RESTORE_FAILED);
      }
    })();
  },

  /**
   * Restores bookmarks and tags from a JSON file.
   * @note any item annotated with "places/excludeFromBackup" won't be removed
   *       before executing the restore.
   *
   * @param aFilePath
   *        OS.File path string of bookmarks in JSON or JSONlz4 format to be restored.
   * @param aReplace
   *        Boolean if true, replace existing bookmarks, else merge.
   *
   * @return {Promise}
   * @resolves When the new bookmarks have been created.
   * @rejects JavaScript exception.
   * @deprecated passing an nsIFile is deprecated
   */
  importFromFile: function BJU_importFromFile(aFilePath, aReplace) {
    if (aFilePath instanceof Ci.nsIFile) {
      Deprecated.warning("Passing an nsIFile to BookmarksJSONUtils.importFromFile " +
                         "is deprecated. Please use an OS.File path string instead.",
                         "https://developer.mozilla.org/docs/JavaScript_OS.File");
      aFilePath = aFilePath.path;
    }

    return (async function() {
      notifyObservers(PlacesUtils.TOPIC_BOOKMARKS_RESTORE_BEGIN);
      try {
        if (!(await OS.File.exists(aFilePath)))
          throw new Error("Cannot restore from nonexisting json file");

        let importer = new BookmarkImporter(aReplace);
        if (aFilePath.endsWith("jsonlz4")) {
          await importer.importFromCompressedFile(aFilePath);
        } else {
          await importer.importFromURL(OS.Path.toFileURI(aFilePath));
        }
        notifyObservers(PlacesUtils.TOPIC_BOOKMARKS_RESTORE_SUCCESS);
      } catch (ex) {
        Cu.reportError("Failed to restore bookmarks from " + aFilePath + ": " + ex);
        notifyObservers(PlacesUtils.TOPIC_BOOKMARKS_RESTORE_FAILED);
        throw ex;
      }
    })();
  },

  /**
   * Serializes bookmarks using JSON, and writes to the supplied file path.
   *
   * @param aFilePath
   *        OS.File path string for the bookmarks file to be created.
   * @param [optional] aOptions
   *        Object containing options for the export:
   *         - failIfHashIs: if the generated file would have the same hash
   *                         defined here, will reject with ex.becauseSameHash
   *         - compress: if true, writes file using lz4 compression
   * @return {Promise}
   * @resolves once the file has been created, to an object with the
   *           following properties:
   *            - count: number of exported bookmarks
   *            - hash: file hash for contents comparison
   * @rejects JavaScript exception.
   * @deprecated passing an nsIFile is deprecated
   */
  exportToFile: function BJU_exportToFile(aFilePath, aOptions = {}) {
    if (aFilePath instanceof Ci.nsIFile) {
      Deprecated.warning("Passing an nsIFile to BookmarksJSONUtils.exportToFile " +
                         "is deprecated. Please use an OS.File path string instead.",
                         "https://developer.mozilla.org/docs/JavaScript_OS.File");
      aFilePath = aFilePath.path;
    }
    return (async function() {
      let [bookmarks, count] = await PlacesBackups.getBookmarksTree();
      let startTime = Date.now();
      let jsonString = JSON.stringify(bookmarks);
      // Report the time taken to convert the tree to JSON.
      try {
        Services.telemetry
                .getHistogramById("PLACES_BACKUPS_TOJSON_MS")
                .add(Date.now() - startTime);
      } catch (ex) {
        Components.utils.reportError("Unable to report telemetry.");
      }

      let hash = generateHash(jsonString);

      if (hash === aOptions.failIfHashIs) {
        let e = new Error("Hash conflict");
        e.becauseSameHash = true;
        throw e;
      }

      // Do not write to the tmp folder, otherwise if it has a different
      // filesystem writeAtomic will fail.  Eventual dangling .tmp files should
      // be cleaned up by the caller.
      let writeOptions = { tmpPath: OS.Path.join(aFilePath + ".tmp") };
      if (aOptions.compress)
        writeOptions.compression = "lz4";

      await OS.File.writeAtomic(aFilePath, jsonString, writeOptions);
      return { count, hash };
    })();
  }
});

function BookmarkImporter(aReplace) {
  this._replace = aReplace;
  // The bookmark change source, used to determine the sync status and change
  // counter.
  this._source = aReplace ? PlacesUtils.bookmarks.SOURCE_IMPORT_REPLACE :
                            PlacesUtils.bookmarks.SOURCE_IMPORT;
}
BookmarkImporter.prototype = {
  /**
   * Import bookmarks from a url.
   *
   * @param aSpec
   *        url of the bookmark data.
   *
   * @return {Promise}
   * @resolves When the new bookmarks have been created.
   * @rejects JavaScript exception.
   */
  importFromURL(spec) {
    return new Promise((resolve, reject) => {
      let streamObserver = {
        onStreamComplete: (aLoader, aContext, aStatus, aLength, aResult) => {
          let converter = Cc["@mozilla.org/intl/scriptableunicodeconverter"].
                          createInstance(Ci.nsIScriptableUnicodeConverter);
          converter.charset = "UTF-8";
          try {
            let jsonString = converter.convertFromByteArray(aResult,
                                                            aResult.length);
            resolve(this.importFromJSON(jsonString));
          } catch (ex) {
            Cu.reportError("Failed to import from URL: " + ex);
            reject(ex);
          }
        }
      };

      let uri = NetUtil.newURI(spec);
      let channel = NetUtil.newChannel({
        uri,
        loadUsingSystemPrincipal: true
      });
      let streamLoader = Cc["@mozilla.org/network/stream-loader;1"]
                           .createInstance(Ci.nsIStreamLoader);
      streamLoader.init(streamObserver);
      channel.asyncOpen2(streamLoader);
    });
  },

  /**
   * Import bookmarks from a compressed file.
   *
   * @param aFilePath
   *        OS.File path string of the bookmark data.
   *
   * @return {Promise}
   * @resolves When the new bookmarks have been created.
   * @rejects JavaScript exception.
   */
  importFromCompressedFile: async function BI_importFromCompressedFile(aFilePath) {
      let aResult = await OS.File.read(aFilePath, { compression: "lz4" });
      let converter = Cc["@mozilla.org/intl/scriptableunicodeconverter"].
                        createInstance(Ci.nsIScriptableUnicodeConverter);
      converter.charset = "UTF-8";
      let jsonString = converter.convertFromByteArray(aResult, aResult.length);
      await this.importFromJSON(jsonString);
  },

  /**
   * Import bookmarks from a JSON string.
   *
   * @param {String} aString JSON string of serialized bookmark data.
   * @return {Promise}
   * @resolves When the new bookmarks have been created.
   * @rejects JavaScript exception.
   */
  async importFromJSON(aString) {
    let nodes =
      PlacesUtils.unwrapNodes(aString, PlacesUtils.TYPE_X_MOZ_PLACE_CONTAINER);

    if (nodes.length == 0 || !nodes[0].children ||
        nodes[0].children.length == 0) {
      return;
    }

    // Change to nodes[0].children as we don't import the root, and also filter
    // out any obsolete "tagsFolder" sections.
    nodes = nodes[0].children.filter(node => !node.root || node.root != "tagsFolder");

    // If we're replacing, then erase existing bookmarks first.
    if (this._replace) {
      await PlacesBackups.eraseEverythingIncludingUserRoots({ source: this._source });
    }

    let folderIdToGuidMap = {};
    let searchGuids = [];

    // Now do some cleanup on the imported nodes so that the various guids
    // match what we need for insertTree, and we also have mappings of folders
    // so we can repair any searches after inserting the bookmarks (see bug 824502).
    for (let node of nodes) {
      if (!node.children || node.children.length == 0)
        continue;  // Nothing to restore for this root

      // Ensure we set the source correctly.
      node.source = this._source;

      // Translate the node for insertTree.
      let [folders, searches] = translateTreeTypes(node);

      folderIdToGuidMap = Object.assign(folderIdToGuidMap, folders);
      searchGuids = searchGuids.concat(searches);
    }

    // Now we can add the actual nodes to the database.
    for (let node of nodes) {
      // Drop any nodes without children, we can't insert them.
      if (!node.children || node.children.length == 0) {
        continue;
      }

      // Places is moving away from supporting user-defined folders at the top
      // of the tree, however, until we have a migration strategy we need to
      // ensure any non-built-in folders are created (xref bug 1310299).
      if (!PlacesUtils.bookmarks.userContentRoots.includes(node.guid)) {
        node.parentGuid = PlacesUtils.bookmarks.rootGuid;
        await PlacesUtils.bookmarks.insert(node);
      }

      await PlacesUtils.bookmarks.insertTree(node);

      // Now add any favicons.
      try {
        insertFaviconsForTree(node);
      } catch (ex) {
        Cu.reportError(`Failed to insert favicons: ${ex}`);
      }
    }

    // Now update any bookmarks with a place: search that contain an index to
    // a folder id.
    for (let guid of searchGuids) {
      let searchBookmark = await PlacesUtils.bookmarks.fetch(guid);
      let url = await fixupQuery(searchBookmark.url, folderIdToGuidMap);
      if (url != searchBookmark.url) {
        await PlacesUtils.bookmarks.update({ guid, url, source: this._source });
      }
    }
  },
};

function notifyObservers(topic) {
  Services.obs.notifyObservers(null, topic, "json");
}

/**
 * Replaces imported folder ids with their local counterparts in a place: URI.
 *
 * @param   {nsIURI} aQueryURI
 *          A place: URI with folder ids.
 * @param   {Object} aFolderIdMap
 *          An array mapping of old folder IDs to new folder GUIDs.
 * @return {String} the fixed up URI if all matched. If some matched, it returns
 *         the URI with only the matching folders included. If none matched
 *         it returns the input URI unchanged.
 */
async function fixupQuery(aQueryURI, aFolderIdMap) {
  const reGlobal = /folder=([0-9]+)/g;
  const re = /([0-9]+)/;

  // Unfortunately .replace can't handle async functions. Therefore,
  // we find the folder guids we need to know the ids for first, then
  // do the async request, and finally replace everything in one go.
  let uri = aQueryURI.href;
  let found = uri.match(reGlobal);
  if (!found) {
    return uri;
  }

  let queryFolderGuids = [];
  for (let folderString of found) {
    let existingFolderId = folderString.match(re)[0];
    queryFolderGuids.push(aFolderIdMap[existingFolderId])
  }

  let newFolderIds = await PlacesUtils.promiseManyItemIds(queryFolderGuids);
  let convert = function(str, p1) {
    return "folder=" + newFolderIds.get(aFolderIdMap[p1]);
  }
  return uri.replace(reGlobal, convert);
}

/**
 * A mapping of root folder names to Guids. To help fixupRootFolderGuid.
 */
const rootToFolderGuidMap = {
  "placesRoot": PlacesUtils.bookmarks.rootGuid,
  "bookmarksMenuFolder": PlacesUtils.bookmarks.menuGuid,
  "unfiledBookmarksFolder": PlacesUtils.bookmarks.unfiledGuid,
  "toolbarFolder": PlacesUtils.bookmarks.toolbarGuid,
  "mobileFolder": PlacesUtils.bookmarks.mobileGuid
};

/**
 * Updates a bookmark node from the json version to the places GUID. This
 * will only change GUIDs for the built-in folders. Other folders will remain
 * unchanged.
 *
 * @param {Object} A bookmark node that is updated with the new GUID if necessary.
 */
function fixupRootFolderGuid(node) {
  if (!node.guid && node.root && node.root in rootToFolderGuidMap) {
    node.guid = rootToFolderGuidMap[node.root];
  }
}

/**
 * Translates the JSON types for a node and its children into Places compatible
 * types. Also handles updating of other parameters e.g. dateAdded and lastModified.
 *
 * @param {Object} node A node to be updated. If it contains children, they will
 *                      be updated as well.
 * @return {Array} An array containing two items:
 *       - {Object} A map of current folder ids to GUIDS
 *       - {Array} An array of GUIDs for nodes that contain query URIs
 */
function translateTreeTypes(node) {
  let folderIdToGuidMap = {};
  let searchGuids = [];

  // Do the uri fixup first, so we can be consistent in this function.
  if (node.uri) {
    node.url = node.uri;
    delete node.uri;
  }

  switch (node.type) {
    case PlacesUtils.TYPE_X_MOZ_PLACE_CONTAINER:
      node.type = PlacesUtils.bookmarks.TYPE_FOLDER;

      // Older type mobile folders have a random guid with an annotation. We need
      // to make sure those go into the proper mobile folder.
      let isMobileFolder = node.annos &&
                           node.annos.some(anno => anno.name == PlacesUtils.MOBILE_ROOT_ANNO);
      if (isMobileFolder) {
        node.guid = PlacesUtils.bookmarks.mobileGuid;
      } else {
        // In case the Guid is broken, we need to fix it up.
        fixupRootFolderGuid(node);
      }

      // Record the current id and the guid so that we can update any search
      // queries later.
      folderIdToGuidMap[node.id] = node.guid;
      break;
    case PlacesUtils.TYPE_X_MOZ_PLACE:
      node.type = PlacesUtils.bookmarks.TYPE_BOOKMARK;

      if (node.url && node.url.substr(0, 6) == "place:") {
        searchGuids.push(node.guid);
      }

      break;
    case PlacesUtils.TYPE_X_MOZ_PLACE_SEPARATOR:
      node.type = PlacesUtils.bookmarks.TYPE_SEPARATOR;
      if ("title" in node) {
        delete node.title;
      }
      break;
    default:
      // TODO We should handle this in a more robust fashion, see bug 1373610.
      Cu.reportError(`Unexpected bookmark type ${node.type}`);
      break;
  }

  if (node.dateAdded) {
    node.dateAdded = PlacesUtils.toDate(node.dateAdded);
  }

  if (node.lastModified) {
    let lastModified = PlacesUtils.toDate(node.lastModified);
    // Ensure we get a last modified date that's later or equal to the dateAdded
    // so that we don't upset the Bookmarks API.
    if (lastModified >= node.dataAdded) {
      node.lastModified = lastModified;
    } else {
      delete node.lastModified;
    }
  }

  if (node.tags) {
     // Separate any tags into an array, and ignore any that are too long.
    node.tags = node.tags.split(",").filter(aTag =>
      aTag.length > 0 && aTag.length <= Ci.nsITaggingService.MAX_TAG_LENGTH);

    // If we end up with none, then delete the property completely.
    if (!node.tags.length) {
      delete node.tags;
    }
  }

  // Sometimes postData can be null, so delete it to make the validators happy.
  if (node.postData == null) {
    delete node.postData;
  }

  // Now handle any children.
  if (!node.children) {
    return [folderIdToGuidMap, searchGuids];
  }

  // First sort the children by index.
  node.children = node.children.sort((a, b) => {
    return a.index - b.index;
  });

  // Now do any adjustments required for the children.
  for (let child of node.children) {
    let [folders, searches] = translateTreeTypes(child);
    folderIdToGuidMap = Object.assign(folderIdToGuidMap, folders);
    searchGuids = searchGuids.concat(searches);
  }

  return [folderIdToGuidMap, searchGuids];
}

/**
 * Handles inserting favicons into the database for a bookmark node.
 * It is assumed the node has already been inserted into the bookmarks
 * database.
 *
 * @param {Object} node The bookmark node for icons to be inserted.
 */
function insertFaviconForNode(node) {
  if (node.icon) {
    try {
      // Create a fake faviconURI to use (FIXME: bug 523932)
      let faviconURI = Services.io.newURI("fake-favicon-uri:" + node.url);
      PlacesUtils.favicons.replaceFaviconDataFromDataURL(
        faviconURI, node.icon, 0,
        Services.scriptSecurityManager.getSystemPrincipal());
      PlacesUtils.favicons.setAndFetchFaviconForPage(
        Services.io.newURI(node.url), faviconURI, false,
        PlacesUtils.favicons.FAVICON_LOAD_NON_PRIVATE, null,
        Services.scriptSecurityManager.getSystemPrincipal());
    } catch (ex) {
      Components.utils.reportError("Failed to import favicon data:" + ex);
    }
  }

  if (!node.iconUri) {
    return;
  }

  try {
    PlacesUtils.favicons.setAndFetchFaviconForPage(
      Services.io.newURI(node.url), Services.io.newURI(node.iconUri), false,
      PlacesUtils.favicons.FAVICON_LOAD_NON_PRIVATE, null,
      Services.scriptSecurityManager.getSystemPrincipal());
  } catch (ex) {
    Components.utils.reportError("Failed to import favicon URI:" + ex);
  }
}

/**
 * Handles inserting favicons into the database for a bookmark tree - a node
 * and its children.
 *
 * It is assumed the nodes have already been inserted into the bookmarks
 * database.
 *
 * @param {Object} nodeTree The bookmark node tree for icons to be inserted.
 */
function insertFaviconsForTree(nodeTree) {
  insertFaviconForNode(nodeTree);

  if (nodeTree.children) {
    for (let child of nodeTree.children) {
      insertFaviconsForTree(child);
    }
  }
}
