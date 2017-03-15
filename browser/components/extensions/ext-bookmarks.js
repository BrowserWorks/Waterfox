/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

const {classes: Cc, interfaces: Ci, utils: Cu} = Components;

Cu.import("resource://gre/modules/ExtensionUtils.jsm");
const {
  SingletonEventManager,
} = ExtensionUtils;

XPCOMUtils.defineLazyModuleGetter(this, "EventEmitter",
                                  "resource://devtools/shared/event-emitter.js");
XPCOMUtils.defineLazyModuleGetter(this, "PlacesUtils",
                                  "resource://gre/modules/PlacesUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "Task",
                                  "resource://gre/modules/Task.jsm");

let listenerCount = 0;

function getTree(rootGuid, onlyChildren) {
  function convert(node, parent) {
    let treenode = {
      id: node.guid,
      title: node.title || "",
      index: node.index,
      dateAdded: node.dateAdded / 1000,
    };

    if (parent && node.guid != PlacesUtils.bookmarks.rootGuid) {
      treenode.parentId = parent.guid;
    }

    if (node.type == PlacesUtils.TYPE_X_MOZ_PLACE) {
      // This isn't quite correct. Recently Bookmarked ends up here ...
      treenode.url = node.uri;
    } else {
      treenode.dateGroupModified = node.lastModified / 1000;

      if (node.children && !onlyChildren) {
        treenode.children = node.children.map(child => convert(child, node));
      }
    }

    return treenode;
  }

  return PlacesUtils.promiseBookmarksTree(rootGuid, {
    excludeItemsCallback: item => {
      if (item.type == PlacesUtils.TYPE_X_MOZ_PLACE_SEPARATOR) {
        return true;
      }
      return item.annos &&
             item.annos.find(a => a.name == PlacesUtils.EXCLUDE_FROM_BACKUP_ANNO);
    },
  }).then(root => {
    if (onlyChildren) {
      let children = root.children || [];
      return children.map(child => convert(child, root));
    }
    // It seems like the array always just contains the root node.
    return [convert(root, null)];
  }).catch(e => Promise.reject({message: e.message}));
}

function convert(result) {
  let node = {
    id: result.guid,
    title: result.title || "",
    index: result.index,
    dateAdded: result.dateAdded.getTime(),
  };

  if (result.guid != PlacesUtils.bookmarks.rootGuid) {
    node.parentId = result.parentGuid;
  }

  if (result.type == PlacesUtils.bookmarks.TYPE_BOOKMARK) {
    node.url = result.url.href; // Output is always URL object.
  } else {
    node.dateGroupModified = result.lastModified.getTime();
  }

  return node;
}

let observer = {
  skipTags: true,
  skipDescendantsOnItemRemoval: true,

  onBeginUpdateBatch() {},
  onEndUpdateBatch() {},

  onItemAdded(id, parentId, index, itemType, uri, title, dateAdded, guid, parentGuid, source) {
    if (itemType == PlacesUtils.bookmarks.TYPE_SEPARATOR) {
      return;
    }

    let bookmark = {
      id: guid,
      parentId: parentGuid,
      index,
      title,
      dateAdded: dateAdded / 1000,
    };

    if (itemType == PlacesUtils.bookmarks.TYPE_BOOKMARK) {
      bookmark.url = uri.spec;
    } else {
      bookmark.dateGroupModified = bookmark.dateAdded;
    }

    this.emit("created", bookmark);
  },

  onItemVisited() {},

  onItemMoved(id, oldParentId, oldIndex, newParentId, newIndex, itemType, guid, oldParentGuid, newParentGuid, source) {
    if (itemType == PlacesUtils.bookmarks.TYPE_SEPARATOR) {
      return;
    }

    let info = {
      parentId: newParentGuid,
      index: newIndex,
      oldParentId: oldParentGuid,
      oldIndex,
    };
    this.emit("moved", {guid, info});
  },

  onItemRemoved(id, parentId, index, itemType, uri, guid, parentGuid, source) {
    if (itemType == PlacesUtils.bookmarks.TYPE_SEPARATOR) {
      return;
    }

    let node = {
      id: guid,
      parentId: parentGuid,
      index,
    };

    if (itemType == PlacesUtils.bookmarks.TYPE_BOOKMARK) {
      node.url = uri.spec;
    }

    this.emit("removed", {guid, info: {parentId: parentGuid, index, node}});
  },

  onItemChanged(id, prop, isAnno, val, lastMod, itemType, parentId, guid, parentGuid, oldVal, source) {
    if (itemType == PlacesUtils.bookmarks.TYPE_SEPARATOR) {
      return;
    }

    let info = {};
    if (prop == "title") {
      info.title = val;
    } else if (prop == "uri") {
      info.url = val;
    } else {
      // Not defined yet.
      return;
    }

    this.emit("changed", {guid, info});
  },
};
EventEmitter.decorate(observer);

function decrementListeners() {
  listenerCount -= 1;
  if (!listenerCount) {
    PlacesUtils.bookmarks.removeObserver(observer);
  }
}

function incrementListeners() {
  listenerCount++;
  if (listenerCount == 1) {
    PlacesUtils.bookmarks.addObserver(observer, false);
  }
}

extensions.registerSchemaAPI("bookmarks", "addon_parent", context => {
  return {
    bookmarks: {
      get: function(idOrIdList) {
        let list = Array.isArray(idOrIdList) ? idOrIdList : [idOrIdList];

        return Task.spawn(function* () {
          let bookmarks = [];
          for (let id of list) {
            let bookmark = yield PlacesUtils.bookmarks.fetch({guid: id});
            if (!bookmark) {
              throw new Error("Bookmark not found");
            }
            bookmarks.push(convert(bookmark));
          }
          return bookmarks;
        }).catch(error => Promise.reject({message: error.message}));
      },

      getChildren: function(id) {
        // TODO: We should optimize this.
        return getTree(id, true);
      },

      getTree: function() {
        return getTree(PlacesUtils.bookmarks.rootGuid, false);
      },

      getSubTree: function(id) {
        return getTree(id, false);
      },

      search: function(query) {
        return PlacesUtils.bookmarks.search(query).then(result => result.map(convert));
      },

      getRecent: function(numberOfItems) {
        return PlacesUtils.bookmarks.getRecent(numberOfItems).then(result => result.map(convert));
      },

      create: function(bookmark) {
        let info = {
          title: bookmark.title || "",
        };

        // If url is NULL or missing, it will be a folder.
        if (bookmark.url !== null) {
          info.type = PlacesUtils.bookmarks.TYPE_BOOKMARK;
          info.url = bookmark.url || "";
        } else {
          info.type = PlacesUtils.bookmarks.TYPE_FOLDER;
        }

        if (bookmark.index !== null) {
          info.index = bookmark.index;
        }

        if (bookmark.parentId !== null) {
          info.parentGuid = bookmark.parentId;
        } else {
          info.parentGuid = PlacesUtils.bookmarks.unfiledGuid;
        }

        try {
          return PlacesUtils.bookmarks.insert(info).then(convert)
            .catch(error => Promise.reject({message: error.message}));
        } catch (e) {
          return Promise.reject({message: `Invalid bookmark: ${JSON.stringify(info)}`});
        }
      },

      move: function(id, destination) {
        let info = {
          guid: id,
        };

        if (destination.parentId !== null) {
          info.parentGuid = destination.parentId;
        }
        info.index = (destination.index === null) ?
          PlacesUtils.bookmarks.DEFAULT_INDEX : destination.index;

        try {
          return PlacesUtils.bookmarks.update(info).then(convert)
            .catch(error => Promise.reject({message: error.message}));
        } catch (e) {
          return Promise.reject({message: `Invalid bookmark: ${JSON.stringify(info)}`});
        }
      },

      update: function(id, changes) {
        let info = {
          guid: id,
        };

        if (changes.title !== null) {
          info.title = changes.title;
        }
        if (changes.url !== null) {
          info.url = changes.url;
        }

        try {
          return PlacesUtils.bookmarks.update(info).then(convert)
            .catch(error => Promise.reject({message: error.message}));
        } catch (e) {
          return Promise.reject({message: `Invalid bookmark: ${JSON.stringify(info)}`});
        }
      },

      remove: function(id) {
        let info = {
          guid: id,
        };

        // The API doesn't give you the old bookmark at the moment
        try {
          return PlacesUtils.bookmarks.remove(info, {preventRemovalOfNonEmptyFolders: true}).then(result => {})
            .catch(error => Promise.reject({message: error.message}));
        } catch (e) {
          return Promise.reject({message: `Invalid bookmark: ${JSON.stringify(info)}`});
        }
      },

      removeTree: function(id) {
        let info = {
          guid: id,
        };

        try {
          return PlacesUtils.bookmarks.remove(info).then(result => {})
            .catch(error => Promise.reject({message: error.message}));
        } catch (e) {
          return Promise.reject({message: `Invalid bookmark: ${JSON.stringify(info)}`});
        }
      },

      onCreated: new SingletonEventManager(context, "bookmarks.onCreated", fire => {
        let listener = (event, bookmark) => {
          context.runSafe(fire, bookmark.id, bookmark);
        };

        observer.on("created", listener);
        incrementListeners();
        return () => {
          observer.off("created", listener);
          decrementListeners();
        };
      }).api(),

      onRemoved: new SingletonEventManager(context, "bookmarks.onRemoved", fire => {
        let listener = (event, data) => {
          context.runSafe(fire, data.guid, data.info);
        };

        observer.on("removed", listener);
        incrementListeners();
        return () => {
          observer.off("removed", listener);
          decrementListeners();
        };
      }).api(),

      onChanged: new SingletonEventManager(context, "bookmarks.onChanged", fire => {
        let listener = (event, data) => {
          context.runSafe(fire, data.guid, data.info);
        };

        observer.on("changed", listener);
        incrementListeners();
        return () => {
          observer.off("changed", listener);
          decrementListeners();
        };
      }).api(),

      onMoved: new SingletonEventManager(context, "bookmarks.onMoved", fire => {
        let listener = (event, data) => {
          context.runSafe(fire, data.guid, data.info);
        };

        observer.on("moved", listener);
        incrementListeners();
        return () => {
          observer.off("moved", listener);
          decrementListeners();
        };
      }).api(),
    },
  };
});
