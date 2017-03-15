/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

Components.utils.import("resource://gre/modules/AppConstants.jsm");
Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");
Components.utils.import("resource://gre/modules/Services.jsm");

/**
 * The base view implements everything that's common to the toolbar and
 * menu views.
 */
function PlacesViewBase(aPlace, aOptions) {
  this.place = aPlace;
  this.options = aOptions;
  this._controller = new PlacesController(this);
  this._viewElt.controllers.appendController(this._controller);
}

PlacesViewBase.prototype = {
  // The xul element that holds the entire view.
  _viewElt: null,
  get viewElt() {
    return this._viewElt;
  },

  get associatedElement() {
    return this._viewElt;
  },

  get controllers() {
    return this._viewElt.controllers;
  },

  // The xul element that represents the root container.
  _rootElt: null,

  // Set to true for views that are represented by native widgets (i.e.
  // the native mac menu).
  _nativeView: false,

  QueryInterface: XPCOMUtils.generateQI(
    [Components.interfaces.nsINavHistoryResultObserver,
     Components.interfaces.nsISupportsWeakReference]),

  _place: "",
  get place() {
    return this._place;
  },
  set place(val) {
    this._place = val;

    let history = PlacesUtils.history;
    let queries = { }, options = { };
    history.queryStringToQueries(val, queries, { }, options);
    if (!queries.value.length)
      queries.value = [history.getNewQuery()];

    let result = history.executeQueries(queries.value, queries.value.length,
                                        options.value);
    result.addObserver(this, false);
    return val;
  },

  _result: null,
  get result() {
    return this._result;
  },
  set result(val) {
    if (this._result == val)
      return val;

    if (this._result) {
      this._result.removeObserver(this);
      this._resultNode.containerOpen = false;
    }

    if (this._rootElt.localName == "menupopup")
      this._rootElt._built = false;

    this._result = val;
    if (val) {
      this._resultNode = val.root;
      this._rootElt._placesNode = this._resultNode;
      this._domNodes = new Map();
      this._domNodes.set(this._resultNode, this._rootElt);

      // This calls _rebuild through invalidateContainer.
      this._resultNode.containerOpen = true;
    }
    else {
      this._resultNode = null;
      delete this._domNodes;
    }

    return val;
  },

  _options: null,
  get options() {
    return this._options;
  },
  set options(val) {
    if (!val)
      val = {};

    if (!("extraClasses" in val))
      val.extraClasses = {};
    this._options = val;

    return val;
  },

  /**
   * Gets the DOM node used for the given places node.
   *
   * @param aPlacesNode
   *        a places result node.
   * @throws if there is no DOM node set for aPlacesNode.
   */
  _getDOMNodeForPlacesNode:
  function PVB__getDOMNodeForPlacesNode(aPlacesNode) {
    let node = this._domNodes.get(aPlacesNode, null);
    if (!node) {
      throw new Error("No DOM node set for aPlacesNode.\nnode.type: " +
                      aPlacesNode.type + ". node.parent: " + aPlacesNode);
    }
    return node;
  },

  get controller() {
    return this._controller;
  },

  get selType() {
    return "single";
  },
  selectItems: function() { },
  selectAll: function() { },

  get selectedNode() {
    if (this._contextMenuShown) {
      let anchor = this._contextMenuShown.triggerNode;
      if (!anchor)
        return null;

      if (anchor._placesNode)
        return this._rootElt == anchor ? null : anchor._placesNode;

      anchor = anchor.parentNode;
      return this._rootElt == anchor ? null : (anchor._placesNode || null);
    }
    return null;
  },

  get hasSelection() {
    return this.selectedNode != null;
  },

  get selectedNodes() {
    let selectedNode = this.selectedNode;
    return selectedNode ? [selectedNode] : [];
  },

  get removableSelectionRanges() {
    // On static content the current selectedNode would be the selection's
    // parent node. We don't want to allow removing a node when the
    // selection is not explicit.
    if (document.popupNode &&
        (document.popupNode == "menupopup" || !document.popupNode._placesNode))
      return [];

    return [this.selectedNodes];
  },

  get draggableSelection() {
    return [this._draggedElt];
  },

  get insertionPoint() {
    // There is no insertion point for history queries, so bail out now and
    // save a lot of work when updating commands.
    let resultNode = this._resultNode;
    if (PlacesUtils.nodeIsQuery(resultNode) &&
        PlacesUtils.asQuery(resultNode).queryOptions.queryType ==
          Ci.nsINavHistoryQueryOptions.QUERY_TYPE_HISTORY)
      return null;

    // By default, the insertion point is at the top level, at the end.
    let index = PlacesUtils.bookmarks.DEFAULT_INDEX;
    let container = this._resultNode;
    let orientation = Ci.nsITreeView.DROP_BEFORE;
    let tagName = null;

    let selectedNode = this.selectedNode;
    if (selectedNode) {
      let popup = document.popupNode;
      if (!popup._placesNode || popup._placesNode == this._resultNode ||
          popup._placesNode.itemId == -1 || !selectedNode.parent) {
        // If a static menuitem is selected, or if the root node is selected,
        // the insertion point is inside the folder, at the end.
        container = selectedNode;
        orientation = Ci.nsITreeView.DROP_ON;
      }
      else {
        // In all other cases the insertion point is before that node.
        container = selectedNode.parent;
        index = container.getChildIndex(selectedNode);
        if (PlacesUtils.nodeIsTagQuery(container)) {
          tagName = container.title;
          // TODO (Bug 1160193): properly support dropping on a tag root.
          if (!tagName)
            return null;
        }
      }
    }

    if (PlacesControllerDragHelper.disallowInsertion(container))
      return null;

    return new InsertionPoint(PlacesUtils.getConcreteItemId(container),
                              index, orientation, tagName);
  },

  buildContextMenu: function PVB_buildContextMenu(aPopup) {
    this._contextMenuShown = aPopup;
    window.updateCommands("places");
    return this.controller.buildContextMenu(aPopup);
  },

  destroyContextMenu: function PVB_destroyContextMenu(aPopup) {
    this._contextMenuShown = null;
  },

  _cleanPopup: function PVB_cleanPopup(aPopup, aDelay) {
    // Remove Places nodes from the popup.
    let child = aPopup._startMarker;
    while (child.nextSibling != aPopup._endMarker) {
      let sibling = child.nextSibling;
      if (sibling._placesNode && !aDelay) {
        aPopup.removeChild(sibling);
      }
      else if (sibling._placesNode && aDelay) {
        // HACK (bug 733419): the popups originating from the OS X native
        // menubar don't live-update while open, thus we don't clean it
        // until the next popupshowing, to avoid zombie menuitems.
        if (!aPopup._delayedRemovals)
          aPopup._delayedRemovals = [];
        aPopup._delayedRemovals.push(sibling);
        child = child.nextSibling;
      }
      else {
        child = child.nextSibling;
      }
    }
  },

  _rebuildPopup: function PVB__rebuildPopup(aPopup) {
    let resultNode = aPopup._placesNode;
    if (!resultNode.containerOpen)
      return;

    if (this.controller.hasCachedLivemarkInfo(resultNode)) {
      this._setEmptyPopupStatus(aPopup, false);
      aPopup._built = true;
      this._populateLivemarkPopup(aPopup);
      return;
    }

    this._cleanPopup(aPopup);

    let cc = resultNode.childCount;
    if (cc > 0) {
      this._setEmptyPopupStatus(aPopup, false);

      for (let i = 0; i < cc; ++i) {
        let child = resultNode.getChild(i);
        this._insertNewItemToPopup(child, aPopup, null);
      }
    }
    else {
      this._setEmptyPopupStatus(aPopup, true);
    }
    aPopup._built = true;
  },

  _removeChild: function PVB__removeChild(aChild) {
    // If document.popupNode pointed to this child, null it out,
    // otherwise controller's command-updating may rely on the removed
    // item still being "selected".
    if (document.popupNode == aChild)
      document.popupNode = null;

    aChild.parentNode.removeChild(aChild);
  },

  _setEmptyPopupStatus:
  function PVB__setEmptyPopupStatus(aPopup, aEmpty) {
    if (!aPopup._emptyMenuitem) {
      let label = PlacesUIUtils.getString("bookmarksMenuEmptyFolder");
      aPopup._emptyMenuitem = document.createElement("menuitem");
      aPopup._emptyMenuitem.setAttribute("label", label);
      aPopup._emptyMenuitem.setAttribute("disabled", true);
      aPopup._emptyMenuitem.className = "bookmark-item";
      if (typeof this.options.extraClasses.entry == "string")
        aPopup._emptyMenuitem.classList.add(this.options.extraClasses.entry);
    }

    if (aEmpty) {
      aPopup.setAttribute("emptyplacesresult", "true");
      // Don't add the menuitem if there is static content.
      if (!aPopup._startMarker.previousSibling &&
          !aPopup._endMarker.nextSibling)
        aPopup.insertBefore(aPopup._emptyMenuitem, aPopup._endMarker);
    }
    else {
      aPopup.removeAttribute("emptyplacesresult");
      try {
        aPopup.removeChild(aPopup._emptyMenuitem);
      } catch (ex) {}
    }
  },

  _createMenuItemForPlacesNode:
  function PVB__createMenuItemForPlacesNode(aPlacesNode) {
    this._domNodes.delete(aPlacesNode);

    let element;
    let type = aPlacesNode.type;
    if (type == Ci.nsINavHistoryResultNode.RESULT_TYPE_SEPARATOR) {
      element = document.createElement("menuseparator");
      element.setAttribute("class", "small-separator");
    }
    else {
      let itemId = aPlacesNode.itemId;
      if (type == Ci.nsINavHistoryResultNode.RESULT_TYPE_URI) {
        element = document.createElement("menuitem");
        element.className = "menuitem-iconic bookmark-item menuitem-with-favicon";
        element.setAttribute("scheme",
                             PlacesUIUtils.guessUrlSchemeForUI(aPlacesNode.uri));
      }
      else if (PlacesUtils.containerTypes.includes(type)) {
        element = document.createElement("menu");
        element.setAttribute("container", "true");

        if (aPlacesNode.type == Ci.nsINavHistoryResultNode.RESULT_TYPE_QUERY) {
          element.setAttribute("query", "true");
          if (PlacesUtils.nodeIsTagQuery(aPlacesNode))
            element.setAttribute("tagContainer", "true");
          else if (PlacesUtils.nodeIsDay(aPlacesNode))
            element.setAttribute("dayContainer", "true");
          else if (PlacesUtils.nodeIsHost(aPlacesNode))
            element.setAttribute("hostContainer", "true");
        }
        else if (itemId != -1) {
          PlacesUtils.livemarks.getLivemark({ id: itemId })
            .then(aLivemark => {
              element.setAttribute("livemark", "true");
              if (AppConstants.platform === "macosx") {
                // OS X native menubar doesn't track list-style-images since
                // it doesn't have a frame (bug 733415).  Thus enforce updating.
                element.setAttribute("image", "");
                element.removeAttribute("image");
              }
              this.controller.cacheLivemarkInfo(aPlacesNode, aLivemark);
            }, () => undefined);
        }

        let popup = document.createElement("menupopup");
        popup._placesNode = PlacesUtils.asContainer(aPlacesNode);

        if (!this._nativeView) {
          popup.setAttribute("placespopup", "true");
        }

        element.appendChild(popup);
        element.className = "menu-iconic bookmark-item";
        if (typeof this.options.extraClasses.entry == "string") {
          element.classList.add(this.options.extraClasses.entry);
        }

        this._domNodes.set(aPlacesNode, popup);
      }
      else
        throw "Unexpected node";

      element.setAttribute("label", PlacesUIUtils.getBestTitle(aPlacesNode));

      let icon = aPlacesNode.icon;
      if (icon)
        element.setAttribute("image", icon);
    }

    element._placesNode = aPlacesNode;
    if (!this._domNodes.has(aPlacesNode))
      this._domNodes.set(aPlacesNode, element);

    return element;
  },

  _insertNewItemToPopup:
  function PVB__insertNewItemToPopup(aNewChild, aPopup, aBefore) {
    let element = this._createMenuItemForPlacesNode(aNewChild);
    let before = aBefore || aPopup._endMarker;

    if (element.localName == "menuitem" || element.localName == "menu") {
      if (typeof this.options.extraClasses.entry == "string")
        element.classList.add(this.options.extraClasses.entry);
    }

    aPopup.insertBefore(element, before);
    return element;
  },

  _setLivemarkSiteURIMenuItem:
  function PVB__setLivemarkSiteURIMenuItem(aPopup) {
    let livemarkInfo = this.controller.getCachedLivemarkInfo(aPopup._placesNode);
    let siteUrl = livemarkInfo && livemarkInfo.siteURI ?
                  livemarkInfo.siteURI.spec : null;
    if (!siteUrl && aPopup._siteURIMenuitem) {
      aPopup.removeChild(aPopup._siteURIMenuitem);
      aPopup._siteURIMenuitem = null;
      aPopup.removeChild(aPopup._siteURIMenuseparator);
      aPopup._siteURIMenuseparator = null;
    }
    else if (siteUrl && !aPopup._siteURIMenuitem) {
      // Add "Open (Feed Name)" menuitem.
      aPopup._siteURIMenuitem = document.createElement("menuitem");
      aPopup._siteURIMenuitem.className = "openlivemarksite-menuitem";
      if (typeof this.options.extraClasses.entry == "string") {
        aPopup._siteURIMenuitem.classList.add(this.options.extraClasses.entry);
      }
      aPopup._siteURIMenuitem.setAttribute("targetURI", siteUrl);
      aPopup._siteURIMenuitem.setAttribute("oncommand",
        "openUILink(this.getAttribute('targetURI'), event);");

      // If a user middle-clicks this item we serve the oncommand event.
      // We are using checkForMiddleClick because of Bug 246720.
      // Note: stopPropagation is needed to avoid serving middle-click
      // with BT_onClick that would open all items in tabs.
      aPopup._siteURIMenuitem.setAttribute("onclick",
        "checkForMiddleClick(this, event); event.stopPropagation();");
      let label =
        PlacesUIUtils.getFormattedString("menuOpenLivemarkOrigin.label",
                                         [aPopup.parentNode.getAttribute("label")])
      aPopup._siteURIMenuitem.setAttribute("label", label);
      aPopup.insertBefore(aPopup._siteURIMenuitem, aPopup._startMarker);

      aPopup._siteURIMenuseparator = document.createElement("menuseparator");
      aPopup.insertBefore(aPopup._siteURIMenuseparator, aPopup._startMarker);
    }
  },

  /**
   * Add, update or remove the livemark status menuitem.
   * @param aPopup
   *        The livemark container popup
   * @param aStatus
   *        The livemark status
   */
  _setLivemarkStatusMenuItem:
  function PVB_setLivemarkStatusMenuItem(aPopup, aStatus) {
    let statusMenuitem = aPopup._statusMenuitem;
    if (!statusMenuitem) {
      // Create the status menuitem and cache it in the popup object.
      statusMenuitem = document.createElement("menuitem");
      statusMenuitem.className = "livemarkstatus-menuitem";
      if (typeof this.options.extraClasses.entry == "string") {
        statusMenuitem.classList.add(this.options.extraClasses.entry);
      }
      statusMenuitem.setAttribute("disabled", true);
      aPopup._statusMenuitem = statusMenuitem;
    }

    if (aStatus == Ci.mozILivemark.STATUS_LOADING ||
        aStatus == Ci.mozILivemark.STATUS_FAILED) {
      // Status has changed, update the cached status menuitem.
      let stringId = aStatus == Ci.mozILivemark.STATUS_LOADING ?
                       "bookmarksLivemarkLoading" : "bookmarksLivemarkFailed";
      statusMenuitem.setAttribute("label", PlacesUIUtils.getString(stringId));
      if (aPopup._startMarker.nextSibling != statusMenuitem)
        aPopup.insertBefore(statusMenuitem, aPopup._startMarker.nextSibling);
    }
    else if (aPopup._statusMenuitem.parentNode == aPopup) {
      // The livemark has finished loading.
      aPopup.removeChild(aPopup._statusMenuitem);
    }
  },

  toggleCutNode: function PVB_toggleCutNode(aPlacesNode, aValue) {
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);

    // We may get the popup for menus, but we need the menu itself.
    if (elt.localName == "menupopup")
      elt = elt.parentNode;
    if (aValue)
      elt.setAttribute("cutting", "true");
    else
      elt.removeAttribute("cutting");
  },

  nodeURIChanged: function PVB_nodeURIChanged(aPlacesNode, aURIString) {
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);

    // Here we need the <menu>.
    if (elt.localName == "menupopup")
      elt = elt.parentNode;

    elt.setAttribute("scheme", PlacesUIUtils.guessUrlSchemeForUI(aURIString));
  },

  nodeIconChanged: function PVB_nodeIconChanged(aPlacesNode) {
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);

    // There's no UI representation for the root node, thus there's nothing to
    // be done when the icon changes.
    if (elt == this._rootElt)
      return;

    // Here we need the <menu>.
    if (elt.localName == "menupopup")
      elt = elt.parentNode;

    let icon = aPlacesNode.icon;
    if (!icon)
      elt.removeAttribute("image");
    else if (icon != elt.getAttribute("image"))
      elt.setAttribute("image", icon);
  },

  nodeAnnotationChanged:
  function PVB_nodeAnnotationChanged(aPlacesNode, aAnno) {
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);

    // All livemarks have a feedURI, so use it as our indicator of a livemark
    // being modified.
    if (aAnno == PlacesUtils.LMANNO_FEEDURI) {
      let menu = elt.parentNode;
      if (!menu.hasAttribute("livemark")) {
        menu.setAttribute("livemark", "true");
        if (AppConstants.platform === "macosx") {
          // OS X native menubar doesn't track list-style-images since
          // it doesn't have a frame (bug 733415).  Thus enforce updating.
          menu.setAttribute("image", "");
          menu.removeAttribute("image");
        }
      }

      PlacesUtils.livemarks.getLivemark({ id: aPlacesNode.itemId })
        .then(aLivemark => {
          // Controller will use this to build the meta data for the node.
          this.controller.cacheLivemarkInfo(aPlacesNode, aLivemark);
          this.invalidateContainer(aPlacesNode);
        }, () => undefined);
    }
  },

  nodeTitleChanged:
  function PVB_nodeTitleChanged(aPlacesNode, aNewTitle) {
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);

    // There's no UI representation for the root node, thus there's
    // nothing to be done when the title changes.
    if (elt == this._rootElt)
      return;

    // Here we need the <menu>.
    if (elt.localName == "menupopup")
      elt = elt.parentNode;

    if (!aNewTitle && elt.localName != "toolbarbutton") {
      // Many users consider toolbars as shortcuts containers, so explicitly
      // allow empty labels on toolbarbuttons.  For any other element try to be
      // smarter, guessing a title from the uri.
      elt.setAttribute("label", PlacesUIUtils.getBestTitle(aPlacesNode));
    }
    else {
      elt.setAttribute("label", aNewTitle);
    }
  },

  nodeRemoved:
  function PVB_nodeRemoved(aParentPlacesNode, aPlacesNode, aIndex) {
    let parentElt = this._getDOMNodeForPlacesNode(aParentPlacesNode);
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);

    // Here we need the <menu>.
    if (elt.localName == "menupopup")
      elt = elt.parentNode;

    if (parentElt._built) {
      parentElt.removeChild(elt);

      // Figure out if we need to show the "<Empty>" menu-item.
      // TODO Bug 517701: This doesn't seem to handle the case of an empty
      // root.
      if (parentElt._startMarker.nextSibling == parentElt._endMarker)
        this._setEmptyPopupStatus(parentElt, true);
    }
  },

  nodeHistoryDetailsChanged:
  function PVB_nodeHistoryDetailsChanged(aPlacesNode, aTime, aCount) {
    if (aPlacesNode.parent &&
        this.controller.hasCachedLivemarkInfo(aPlacesNode.parent)) {
      // Find the node in the parent.
      let popup = this._getDOMNodeForPlacesNode(aPlacesNode.parent);
      for (let child = popup._startMarker.nextSibling;
           child != popup._endMarker;
           child = child.nextSibling) {
        if (child._placesNode && child._placesNode.uri == aPlacesNode.uri) {
          if (aCount)
            child.setAttribute("visited", "true");
          else
            child.removeAttribute("visited");
          break;
        }
      }
    }
  },

  nodeTagsChanged: function() { },
  nodeDateAddedChanged: function() { },
  nodeLastModifiedChanged: function() { },
  nodeKeywordChanged: function() { },
  sortingChanged: function() { },
  batching: function() { },

  nodeInserted:
  function PVB_nodeInserted(aParentPlacesNode, aPlacesNode, aIndex) {
    let parentElt = this._getDOMNodeForPlacesNode(aParentPlacesNode);
    if (!parentElt._built)
      return;

    let index = Array.prototype.indexOf.call(parentElt.childNodes, parentElt._startMarker) +
                aIndex + 1;
    this._insertNewItemToPopup(aPlacesNode, parentElt,
                               parentElt.childNodes[index]);
    this._setEmptyPopupStatus(parentElt, false);
  },

  nodeMoved:
  function PBV_nodeMoved(aPlacesNode,
                         aOldParentPlacesNode, aOldIndex,
                         aNewParentPlacesNode, aNewIndex) {
    // Note: the current implementation of moveItem does not actually
    // use this notification when the item in question is moved from one
    // folder to another.  Instead, it calls nodeRemoved and nodeInserted
    // for the two folders.  Thus, we can assume old-parent == new-parent.
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);

    // Here we need the <menu>.
    if (elt.localName == "menupopup")
      elt = elt.parentNode;

    // If our root node is a folder, it might be moved. There's nothing
    // we need to do in that case.
    if (elt == this._rootElt)
      return;

    let parentElt = this._getDOMNodeForPlacesNode(aNewParentPlacesNode);
    if (parentElt._built) {
      // Move the node.
      parentElt.removeChild(elt);
      let index = Array.prototype.indexOf.call(parentElt.childNodes, parentElt._startMarker) +
                  aNewIndex + 1;
      parentElt.insertBefore(elt, parentElt.childNodes[index]);
    }
  },

  containerStateChanged:
  function PVB_containerStateChanged(aPlacesNode, aOldState, aNewState) {
    if (aNewState == Ci.nsINavHistoryContainerResultNode.STATE_OPENED ||
        aNewState == Ci.nsINavHistoryContainerResultNode.STATE_CLOSED) {
      this.invalidateContainer(aPlacesNode);

      if (PlacesUtils.nodeIsFolder(aPlacesNode)) {
        let queryOptions = PlacesUtils.asQuery(this._result.root).queryOptions;
        if (queryOptions.excludeItems) {
          return;
        }

        PlacesUtils.livemarks.getLivemark({ id: aPlacesNode.itemId })
          .then(aLivemark => {
            let shouldInvalidate =
              !this.controller.hasCachedLivemarkInfo(aPlacesNode);
            this.controller.cacheLivemarkInfo(aPlacesNode, aLivemark);
            if (aNewState == Ci.nsINavHistoryContainerResultNode.STATE_OPENED) {
              aLivemark.registerForUpdates(aPlacesNode, this);
              // Prioritize the current livemark.
              aLivemark.reload();
              PlacesUtils.livemarks.reloadLivemarks();
              if (shouldInvalidate)
                this.invalidateContainer(aPlacesNode);
            }
            else {
              aLivemark.unregisterForUpdates(aPlacesNode);
            }
          }, () => undefined);
      }
    }
  },

  _populateLivemarkPopup: function PVB__populateLivemarkPopup(aPopup)
  {
    this._setLivemarkSiteURIMenuItem(aPopup);
    // Show the loading status only if there are no entries yet.
    if (aPopup._startMarker.nextSibling == aPopup._endMarker)
      this._setLivemarkStatusMenuItem(aPopup, Ci.mozILivemark.STATUS_LOADING);

    PlacesUtils.livemarks.getLivemark({ id: aPopup._placesNode.itemId })
      .then(aLivemark => {
        let placesNode = aPopup._placesNode;
        if (!placesNode.containerOpen)
          return;

        if (aLivemark.status != Ci.mozILivemark.STATUS_LOADING)
          this._setLivemarkStatusMenuItem(aPopup, aLivemark.status);
        this._cleanPopup(aPopup,
          this._nativeView && aPopup.parentNode.hasAttribute("open"));

        let children = aLivemark.getNodesForContainer(placesNode);
        for (let i = 0; i < children.length; i++) {
          let child = children[i];
          this.nodeInserted(placesNode, child, i);
          if (child.accessCount)
            this._getDOMNodeForPlacesNode(child).setAttribute("visited", true);
          else
            this._getDOMNodeForPlacesNode(child).removeAttribute("visited");
        }
      }, Components.utils.reportError);
  },

  invalidateContainer: function PVB_invalidateContainer(aPlacesNode) {
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);
    elt._built = false;

    // If the menupopup is open we should live-update it.
    if (elt.parentNode.open)
      this._rebuildPopup(elt);
  },

  uninit: function PVB_uninit() {
    if (this._result) {
      this._result.removeObserver(this);
      this._resultNode.containerOpen = false;
      this._resultNode = null;
      this._result = null;
    }

    if (this._controller) {
      this._controller.terminate();
      // Removing the controller will fail if it is already no longer there.
      // This can happen if the view element was removed/reinserted without
      // our knowledge. There is no way to check for that having happened
      // without the possibility of an exception. :-(
      try {
        this._viewElt.controllers.removeController(this._controller);
      } catch (ex) {
      } finally {
        this._controller = null;
      }
    }

    delete this._viewElt._placesView;
  },

  get isRTL() {
    if ("_isRTL" in this)
      return this._isRTL;

    return this._isRTL = document.defaultView
                                 .getComputedStyle(this.viewElt, "")
                                 .direction == "rtl";
  },

  get ownerWindow() {
    return window;
  },

  /**
   * Adds an "Open All in Tabs" menuitem to the bottom of the popup.
   * @param aPopup
   *        a Places popup.
   */
  _mayAddCommandsItems: function PVB__mayAddCommandsItems(aPopup) {
    // The command items are never added to the root popup.
    if (aPopup == this._rootElt)
      return;

    let hasMultipleURIs = false;

    // Check if the popup contains at least 2 menuitems with places nodes.
    // We don't currently support opening multiple uri nodes when they are not
    // populated by the result.
    if (aPopup._placesNode.childCount > 0) {
      let currentChild = aPopup.firstChild;
      let numURINodes = 0;
      while (currentChild) {
        if (currentChild.localName == "menuitem" && currentChild._placesNode) {
          if (++numURINodes == 2)
            break;
        }
        currentChild = currentChild.nextSibling;
      }
      hasMultipleURIs = numURINodes > 1;
    }

    let isLiveMark = false;
    if (this.controller.hasCachedLivemarkInfo(aPopup._placesNode)) {
      hasMultipleURIs = true;
      isLiveMark = true;
    }

    if (!hasMultipleURIs) {
      aPopup.setAttribute("singleitempopup", "true");
    } else {
      aPopup.removeAttribute("singleitempopup");
    }

    if (!hasMultipleURIs) {
      // We don't have to show any option.
      if (aPopup._endOptOpenAllInTabs) {
        aPopup.removeChild(aPopup._endOptOpenAllInTabs);
        aPopup._endOptOpenAllInTabs = null;

        aPopup.removeChild(aPopup._endOptSeparator);
        aPopup._endOptSeparator = null;
      }
    }
    else if (!aPopup._endOptOpenAllInTabs) {
      // Create a separator before options.
      aPopup._endOptSeparator = document.createElement("menuseparator");
      aPopup._endOptSeparator.className = "bookmarks-actions-menuseparator";
      aPopup.appendChild(aPopup._endOptSeparator);

      // Add the "Open All in Tabs" menuitem.
      aPopup._endOptOpenAllInTabs = document.createElement("menuitem");
      aPopup._endOptOpenAllInTabs.className = "openintabs-menuitem";

      if (typeof this.options.extraClasses.entry == "string")
        aPopup._endOptOpenAllInTabs.classList.add(this.options.extraClasses.entry);
      if (typeof this.options.extraClasses.footer == "string")
        aPopup._endOptOpenAllInTabs.classList.add(this.options.extraClasses.footer);

      if (isLiveMark) {
        aPopup._endOptOpenAllInTabs.setAttribute("oncommand",
          "PlacesUIUtils.openLiveMarkNodesInTabs(this.parentNode._placesNode, event, " +
                                                 "PlacesUIUtils.getViewForNode(this));");
      } else {
        aPopup._endOptOpenAllInTabs.setAttribute("oncommand",
          "PlacesUIUtils.openContainerNodeInTabs(this.parentNode._placesNode, event, " +
                                                 "PlacesUIUtils.getViewForNode(this));");
      }
      aPopup._endOptOpenAllInTabs.setAttribute("onclick",
        "checkForMiddleClick(this, event); event.stopPropagation();");
      aPopup._endOptOpenAllInTabs.setAttribute("label",
        gNavigatorBundle.getString("menuOpenAllInTabs.label"));
      aPopup.appendChild(aPopup._endOptOpenAllInTabs);
    }
  },

  _ensureMarkers: function PVB__ensureMarkers(aPopup) {
    if (aPopup._startMarker)
      return;

    // _startMarker is an hidden menuseparator that lives before places nodes.
    aPopup._startMarker = document.createElement("menuseparator");
    aPopup._startMarker.hidden = true;
    aPopup.insertBefore(aPopup._startMarker, aPopup.firstChild);

    // _endMarker is a DOM node that lives after places nodes, specified with
    // the 'insertionPoint' option or will be a hidden menuseparator.
    let node = ("insertionPoint" in this.options) ?
               aPopup.querySelector(this.options.insertionPoint) : null;
    if (node) {
      aPopup._endMarker = node;
    } else {
      aPopup._endMarker = document.createElement("menuseparator");
      aPopup._endMarker.hidden = true;
    }
    aPopup.appendChild(aPopup._endMarker);

    // Move the markers to the right position.
    let firstNonStaticNodeFound = false;
    for (let i = 0; i < aPopup.childNodes.length; i++) {
      let child = aPopup.childNodes[i];
      // Menus that have static content at the end, but are initially empty,
      // use a special "builder" attribute to figure out where to start
      // inserting places nodes.
      if (child.getAttribute("builder") == "end") {
        aPopup.insertBefore(aPopup._endMarker, child);
        break;
      }

      if (child._placesNode && !child.hasAttribute("simulated-places-node") &&
          !firstNonStaticNodeFound) {
        firstNonStaticNodeFound = true;
        aPopup.insertBefore(aPopup._startMarker, child);
      }
    }
    if (!firstNonStaticNodeFound) {
      aPopup.insertBefore(aPopup._startMarker, aPopup._endMarker);
    }
  },

  _onPopupShowing: function PVB__onPopupShowing(aEvent) {
    // Avoid handling popupshowing of inner views.
    let popup = aEvent.originalTarget;

    this._ensureMarkers(popup);

    // Remove any delayed element, see _cleanPopup for details.
    if ("_delayedRemovals" in popup) {
      while (popup._delayedRemovals.length > 0) {
        popup.removeChild(popup._delayedRemovals.shift());
      }
    }

    if (popup._placesNode && PlacesUIUtils.getViewForNode(popup) == this) {
      if (!popup._placesNode.containerOpen)
        popup._placesNode.containerOpen = true;
      if (!popup._built)
        this._rebuildPopup(popup);

      this._mayAddCommandsItems(popup);
    }
  },

  _addEventListeners:
  function PVB__addEventListeners(aObject, aEventNames, aCapturing) {
    for (let i = 0; i < aEventNames.length; i++) {
      aObject.addEventListener(aEventNames[i], this, aCapturing);
    }
  },

  _removeEventListeners:
  function PVB__removeEventListeners(aObject, aEventNames, aCapturing) {
    for (let i = 0; i < aEventNames.length; i++) {
      aObject.removeEventListener(aEventNames[i], this, aCapturing);
    }
  },
};

function PlacesToolbar(aPlace) {
  let startTime = Date.now();
  // Add some smart getters for our elements.
  let thisView = this;
  [
    ["_viewElt",              "PlacesToolbar"],
    ["_rootElt",              "PlacesToolbarItems"],
    ["_dropIndicator",        "PlacesToolbarDropIndicator"],
    ["_chevron",              "PlacesChevron"],
    ["_chevronPopup",         "PlacesChevronPopup"]
  ].forEach(function (elementGlobal) {
    let [name, id] = elementGlobal;
    thisView.__defineGetter__(name, function () {
      let element = document.getElementById(id);
      if (!element)
        return null;

      delete thisView[name];
      return thisView[name] = element;
    });
  });

  this._viewElt._placesView = this;

  this._addEventListeners(this._viewElt, this._cbEvents, false);
  this._addEventListeners(this._rootElt, ["popupshowing", "popuphidden"], true);
  this._addEventListeners(this._rootElt, ["overflow", "underflow"], true);
  this._addEventListeners(window, ["resize", "unload"], false);

  // If personal-bookmarks has been dragged to the tabs toolbar,
  // we have to track addition and removals of tabs, to properly
  // recalculate the available space for bookmarks.
  // TODO (bug 734730): Use a performant mutation listener when available.
  if (this._viewElt.parentNode.parentNode == document.getElementById("TabsToolbar")) {
    this._addEventListeners(gBrowser.tabContainer, ["TabOpen", "TabClose"], false);
  }

  PlacesViewBase.call(this, aPlace);

  Services.telemetry.getHistogramById("FX_BOOKMARKS_TOOLBAR_INIT_MS")
                    .add(Date.now() - startTime);
}

PlacesToolbar.prototype = {
  __proto__: PlacesViewBase.prototype,

  _cbEvents: ["dragstart", "dragover", "dragexit", "dragend", "drop",
              "mousemove", "mouseover", "mouseout"],

  QueryInterface: function PT_QueryInterface(aIID) {
    if (aIID.equals(Ci.nsIDOMEventListener) ||
        aIID.equals(Ci.nsITimerCallback))
      return this;

    return PlacesViewBase.prototype.QueryInterface.apply(this, arguments);
  },

  uninit: function PT_uninit() {
    this._removeEventListeners(this._viewElt, this._cbEvents, false);
    this._removeEventListeners(this._rootElt, ["popupshowing", "popuphidden"],
                               true);
    this._removeEventListeners(this._rootElt, ["overflow", "underflow"], true);
    this._removeEventListeners(window, ["resize", "unload"], false);
    this._removeEventListeners(gBrowser.tabContainer, ["TabOpen", "TabClose"], false);

    if (this._chevron._placesView) {
      this._chevron._placesView.uninit();
    }

    PlacesViewBase.prototype.uninit.apply(this, arguments);
  },

  _openedMenuButton: null,
  _allowPopupShowing: true,

  _rebuild: function PT__rebuild() {
    // Clear out references to existing nodes, since they will be removed
    // and re-added.
    if (this._overFolder.elt)
      this._clearOverFolder();

    this._openedMenuButton = null;
    while (this._rootElt.hasChildNodes()) {
      this._rootElt.removeChild(this._rootElt.firstChild);
    }

    let cc = this._resultNode.childCount;
    for (let i = 0; i < cc; ++i) {
      this._insertNewItem(this._resultNode.getChild(i), null);
    }

    if (this._chevronPopup.hasAttribute("type")) {
      // Chevron has already been initialized, but since we are forcing
      // a rebuild of the toolbar, it has to be rebuilt.
      // Otherwise, it will be initialized when the toolbar overflows.
      this._chevronPopup.place = this.place;
    }
  },

  _insertNewItem:
  function PT__insertNewItem(aChild, aBefore) {
    this._domNodes.delete(aChild);

    let type = aChild.type;
    let button;
    if (type == Ci.nsINavHistoryResultNode.RESULT_TYPE_SEPARATOR) {
      button = document.createElement("toolbarseparator");
    }
    else {
      button = document.createElement("toolbarbutton");
      button.className = "bookmark-item";
      button.setAttribute("label", aChild.title || "");
      let icon = aChild.icon;
      if (icon)
        button.setAttribute("image", icon);

      if (PlacesUtils.containerTypes.includes(type)) {
        button.setAttribute("type", "menu");
        button.setAttribute("container", "true");

        if (PlacesUtils.nodeIsQuery(aChild)) {
          button.setAttribute("query", "true");
          if (PlacesUtils.nodeIsTagQuery(aChild))
            button.setAttribute("tagContainer", "true");
        }
        else if (PlacesUtils.nodeIsFolder(aChild)) {
          PlacesUtils.livemarks.getLivemark({ id: aChild.itemId })
            .then(aLivemark => {
              button.setAttribute("livemark", "true");
              this.controller.cacheLivemarkInfo(aChild, aLivemark);
            }, () => undefined);
        }

        let popup = document.createElement("menupopup");
        popup.setAttribute("placespopup", "true");
        button.appendChild(popup);
        popup._placesNode = PlacesUtils.asContainer(aChild);
        popup.setAttribute("context", "placesContext");

        this._domNodes.set(aChild, popup);
      }
      else if (PlacesUtils.nodeIsURI(aChild)) {
        button.setAttribute("scheme",
                            PlacesUIUtils.guessUrlSchemeForUI(aChild.uri));
      }
    }

    button._placesNode = aChild;
    if (!this._domNodes.has(aChild))
      this._domNodes.set(aChild, button);

    if (aBefore)
      this._rootElt.insertBefore(button, aBefore);
    else
      this._rootElt.appendChild(button);
  },

  _updateChevronPopupNodesVisibility:
  function PT__updateChevronPopupNodesVisibility() {
    for (let i = 0, node = this._chevronPopup._startMarker.nextSibling;
         node != this._chevronPopup._endMarker;
         i++, node = node.nextSibling) {
      node.hidden = this._rootElt.childNodes[i].style.visibility != "hidden";
    }
  },

  _onChevronPopupShowing:
  function PT__onChevronPopupShowing(aEvent) {
    // Handle popupshowing only for the chevron popup, not for nested ones.
    if (aEvent.target != this._chevronPopup)
      return;

    if (!this._chevron._placesView)
      this._chevron._placesView = new PlacesMenu(aEvent, this.place);

    this._updateChevronPopupNodesVisibility();
  },

  handleEvent: function PT_handleEvent(aEvent) {
    switch (aEvent.type) {
      case "unload":
        this.uninit();
        break;
      case "resize":
        // This handler updates nodes visibility in both the toolbar
        // and the chevron popup when a window resize does not change
        // the overflow status of the toolbar.
        this.updateChevron();
        break;
      case "overflow":
        if (!this._isOverflowStateEventRelevant(aEvent))
          return;
        this._onOverflow();
        break;
      case "underflow":
        if (!this._isOverflowStateEventRelevant(aEvent))
          return;
        this._onUnderflow();
        break;
      case "TabOpen":
      case "TabClose":
        this.updateChevron();
        break;
      case "dragstart":
        this._onDragStart(aEvent);
        break;
      case "dragover":
        this._onDragOver(aEvent);
        break;
      case "dragexit":
        this._onDragExit(aEvent);
        break;
      case "dragend":
        this._onDragEnd(aEvent);
        break;
      case "drop":
        this._onDrop(aEvent);
        break;
      case "mouseover":
        this._onMouseOver(aEvent);
        break;
      case "mousemove":
        this._onMouseMove(aEvent);
        break;
      case "mouseout":
        this._onMouseOut(aEvent);
        break;
      case "popupshowing":
        this._onPopupShowing(aEvent);
        break;
      case "popuphidden":
        this._onPopupHidden(aEvent);
        break;
      default:
        throw "Trying to handle unexpected event.";
    }
  },

  updateOverflowStatus: function() {
    if (this._rootElt.scrollLeftMin != this._rootElt.scrollLeftMax) {
      this._onOverflow();
    } else {
      this._onUnderflow();
    }
  },

  _isOverflowStateEventRelevant: function PT_isOverflowStateEventRelevant(aEvent) {
    // Ignore events not aimed at ourselves, as well as purely vertical ones:
    return aEvent.target == aEvent.currentTarget && aEvent.detail > 0;
  },

  _onOverflow: function PT_onOverflow() {
    // Attach the popup binding to the chevron popup if it has not yet
    // been initialized.
    if (!this._chevronPopup.hasAttribute("type")) {
      this._chevronPopup.setAttribute("place", this.place);
      this._chevronPopup.setAttribute("type", "places");
    }
    this._chevron.collapsed = false;
    this.updateChevron();
  },

  _onUnderflow: function PT_onUnderflow() {
    this.updateChevron();
    this._chevron.collapsed = true;
  },

  updateChevron: function PT_updateChevron() {
    // If the chevron is collapsed there's nothing to update.
    if (this._chevron.collapsed)
      return;

    // Update the chevron on a timer.  This will avoid repeated work when
    // lot of changes happen in a small timeframe.
    if (this._updateChevronTimer)
      this._updateChevronTimer.cancel();

    this._updateChevronTimer = this._setTimer(100);
  },

  _updateChevronTimerCallback: function PT__updateChevronTimerCallback() {
    let scrollRect = this._rootElt.getBoundingClientRect();
    let childOverflowed = false;
    for (let i = 0; i < this._rootElt.childNodes.length; i++) {
      let child = this._rootElt.childNodes[i];
      // Once a child overflows, all the next ones will.
      if (!childOverflowed) {
        let childRect = child.getBoundingClientRect();
        childOverflowed = this.isRTL ? (childRect.left < scrollRect.left)
                                     : (childRect.right > scrollRect.right);

      }
      child.style.visibility = childOverflowed ? "hidden" : "visible";
    }

    // We rebuild the chevron on popupShowing, so if it is open
    // we must update it.
    if (this._chevron.open)
      this._updateChevronPopupNodesVisibility();
  },

  nodeInserted:
  function PT_nodeInserted(aParentPlacesNode, aPlacesNode, aIndex) {
    let parentElt = this._getDOMNodeForPlacesNode(aParentPlacesNode);
    if (parentElt == this._rootElt) {
      let children = this._rootElt.childNodes;
      this._insertNewItem(aPlacesNode,
        aIndex < children.length ? children[aIndex] : null);
      this.updateChevron();
      return;
    }

    PlacesViewBase.prototype.nodeInserted.apply(this, arguments);
  },

  nodeRemoved:
  function PT_nodeRemoved(aParentPlacesNode, aPlacesNode, aIndex) {
    let parentElt = this._getDOMNodeForPlacesNode(aParentPlacesNode);
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);

    // Here we need the <menu>.
    if (elt.localName == "menupopup")
      elt = elt.parentNode;

    if (parentElt == this._rootElt) {
      this._removeChild(elt);
      this.updateChevron();
      return;
    }

    PlacesViewBase.prototype.nodeRemoved.apply(this, arguments);
  },

  nodeMoved:
  function PT_nodeMoved(aPlacesNode,
                        aOldParentPlacesNode, aOldIndex,
                        aNewParentPlacesNode, aNewIndex) {
    let parentElt = this._getDOMNodeForPlacesNode(aNewParentPlacesNode);
    if (parentElt == this._rootElt) {
      // Container is on the toolbar.

      // Move the element.
      let elt = this._getDOMNodeForPlacesNode(aPlacesNode);

      // Here we need the <menu>.
      if (elt.localName == "menupopup")
        elt = elt.parentNode;

      this._removeChild(elt);
      this._rootElt.insertBefore(elt, this._rootElt.childNodes[aNewIndex]);

      // The chevron view may get nodeMoved after the toolbar.  In such a case,
      // we should ensure (by manually swapping menuitems) that the actual nodes
      // are in the final position before updateChevron tries to updates their
      // visibility, or the chevron may go out of sync.
      // Luckily updateChevron runs on a timer, so, by the time it updates
      // nodes, the menu has already handled the notification.

      this.updateChevron();
      return;
    }

    PlacesViewBase.prototype.nodeMoved.apply(this, arguments);
  },

  nodeAnnotationChanged:
  function PT_nodeAnnotationChanged(aPlacesNode, aAnno) {
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);
    if (elt == this._rootElt)
      return;

    // We're notified for the menupopup, not the containing toolbarbutton.
    if (elt.localName == "menupopup")
      elt = elt.parentNode;

    if (elt.parentNode == this._rootElt) {
      // Node is on the toolbar.

      // All livemarks have a feedURI, so use it as our indicator.
      if (aAnno == PlacesUtils.LMANNO_FEEDURI) {
        elt.setAttribute("livemark", true);

        PlacesUtils.livemarks.getLivemark({ id: aPlacesNode.itemId })
          .then(aLivemark => {
            this.controller.cacheLivemarkInfo(aPlacesNode, aLivemark);
            this.invalidateContainer(aPlacesNode);
          }, Components.utils.reportError);
      }
    }
    else {
      // Node is in a submenu.
      PlacesViewBase.prototype.nodeAnnotationChanged.apply(this, arguments);
    }
  },

  nodeTitleChanged: function PT_nodeTitleChanged(aPlacesNode, aNewTitle) {
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);

    // There's no UI representation for the root node, thus there's
    // nothing to be done when the title changes.
    if (elt == this._rootElt)
      return;

    PlacesViewBase.prototype.nodeTitleChanged.apply(this, arguments);

    // Here we need the <menu>.
    if (elt.localName == "menupopup")
      elt = elt.parentNode;

    if (elt.parentNode == this._rootElt) {
      // Node is on the toolbar
      this.updateChevron();
    }
  },

  invalidateContainer: function PT_invalidateContainer(aPlacesNode) {
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);
    if (elt == this._rootElt) {
      // Container is the toolbar itself.
      this._rebuild();
      return;
    }

    PlacesViewBase.prototype.invalidateContainer.apply(this, arguments);
  },

  _overFolder: { elt: null,
                 openTimer: null,
                 hoverTime: 350,
                 closeTimer: null },

  _clearOverFolder: function PT__clearOverFolder() {
    // The mouse is no longer dragging over the stored menubutton.
    // Close the menubutton, clear out drag styles, and clear all
    // timers for opening/closing it.
    if (this._overFolder.elt && this._overFolder.elt.lastChild) {
      if (!this._overFolder.elt.lastChild.hasAttribute("dragover")) {
        this._overFolder.elt.lastChild.hidePopup();
      }
      this._overFolder.elt.removeAttribute("dragover");
      this._overFolder.elt = null;
    }
    if (this._overFolder.openTimer) {
      this._overFolder.openTimer.cancel();
      this._overFolder.openTimer = null;
    }
    if (this._overFolder.closeTimer) {
      this._overFolder.closeTimer.cancel();
      this._overFolder.closeTimer = null;
    }
  },

  /**
   * This function returns information about where to drop when dragging over
   * the toolbar.  The returned object has the following properties:
   * - ip: the insertion point for the bookmarks service.
   * - beforeIndex: child index to drop before, for the drop indicator.
   * - folderElt: the folder to drop into, if applicable.
   */
  _getDropPoint: function PT__getDropPoint(aEvent) {
    if (!PlacesUtils.nodeIsFolder(this._resultNode))
      return null;

    let dropPoint = { ip: null, beforeIndex: null, folderElt: null };
    let elt = aEvent.target;
    if (elt._placesNode && elt != this._rootElt &&
        elt.localName != "menupopup") {
      let eltRect = elt.getBoundingClientRect();
      let eltIndex = Array.prototype.indexOf.call(this._rootElt.childNodes, elt);
      if (PlacesUtils.nodeIsFolder(elt._placesNode) &&
          !PlacesUIUtils.isContentsReadOnly(elt._placesNode)) {
        // This is a folder.
        // If we are in the middle of it, drop inside it.
        // Otherwise, drop before it, with regards to RTL mode.
        let threshold = eltRect.width * 0.25;
        if (this.isRTL ? (aEvent.clientX > eltRect.right - threshold)
                       : (aEvent.clientX < eltRect.left + threshold)) {
          // Drop before this folder.
          dropPoint.ip =
            new InsertionPoint(PlacesUtils.getConcreteItemId(this._resultNode),
                               eltIndex, Ci.nsITreeView.DROP_BEFORE);
          dropPoint.beforeIndex = eltIndex;
        }
        else if (this.isRTL ? (aEvent.clientX > eltRect.left + threshold)
                            : (aEvent.clientX < eltRect.right - threshold)) {
          // Drop inside this folder.
          let tagName = PlacesUtils.nodeIsTagQuery(elt._placesNode) ?
                        elt._placesNode.title : null;
          dropPoint.ip =
            new InsertionPoint(PlacesUtils.getConcreteItemId(elt._placesNode),
                               -1, Ci.nsITreeView.DROP_ON,
                               tagName);
          dropPoint.beforeIndex = eltIndex;
          dropPoint.folderElt = elt;
        }
        else {
          // Drop after this folder.
          let beforeIndex =
            (eltIndex == this._rootElt.childNodes.length - 1) ?
            -1 : eltIndex + 1;

          dropPoint.ip =
            new InsertionPoint(PlacesUtils.getConcreteItemId(this._resultNode),
                               beforeIndex, Ci.nsITreeView.DROP_BEFORE);
          dropPoint.beforeIndex = beforeIndex;
        }
      }
      else {
        // This is a non-folder node or a read-only folder.
        // Drop before it with regards to RTL mode.
        let threshold = eltRect.width * 0.5;
        if (this.isRTL ? (aEvent.clientX > eltRect.left + threshold)
                       : (aEvent.clientX < eltRect.left + threshold)) {
          // Drop before this bookmark.
          dropPoint.ip =
            new InsertionPoint(PlacesUtils.getConcreteItemId(this._resultNode),
                               eltIndex, Ci.nsITreeView.DROP_BEFORE);
          dropPoint.beforeIndex = eltIndex;
        }
        else {
          // Drop after this bookmark.
          let beforeIndex =
            eltIndex == this._rootElt.childNodes.length - 1 ?
            -1 : eltIndex + 1;
          dropPoint.ip =
            new InsertionPoint(PlacesUtils.getConcreteItemId(this._resultNode),
                               beforeIndex, Ci.nsITreeView.DROP_BEFORE);
          dropPoint.beforeIndex = beforeIndex;
        }
      }
    }
    else {
      // We are most likely dragging on the empty area of the
      // toolbar, we should drop after the last node.
      dropPoint.ip =
        new InsertionPoint(PlacesUtils.getConcreteItemId(this._resultNode),
                           -1, Ci.nsITreeView.DROP_BEFORE);
      dropPoint.beforeIndex = -1;
    }

    return dropPoint;
  },

  _setTimer: function PT_setTimer(aTime) {
    let timer = Cc["@mozilla.org/timer;1"].createInstance(Ci.nsITimer);
    timer.initWithCallback(this, aTime, timer.TYPE_ONE_SHOT);
    return timer;
  },

  notify: function PT_notify(aTimer) {
    if (aTimer == this._updateChevronTimer) {
      this._updateChevronTimer = null;
      this._updateChevronTimerCallback();
    }

    // * Timer to turn off indicator bar.
    else if (aTimer == this._ibTimer) {
      this._dropIndicator.collapsed = true;
      this._ibTimer = null;
    }

    // * Timer to open a menubutton that's being dragged over.
    else if (aTimer == this._overFolder.openTimer) {
      // Set the autoopen attribute on the folder's menupopup so that
      // the menu will automatically close when the mouse drags off of it.
      this._overFolder.elt.lastChild.setAttribute("autoopened", "true");
      this._overFolder.elt.open = true;
      this._overFolder.openTimer = null;
    }

    // * Timer to close a menubutton that's been dragged off of.
    else if (aTimer == this._overFolder.closeTimer) {
      // Close the menubutton if we are not dragging over it or one of
      // its children.  The autoopened attribute will let the menu know to
      // close later if the menu is still being dragged over.
      let currentPlacesNode = PlacesControllerDragHelper.currentDropTarget;
      let inHierarchy = false;
      while (currentPlacesNode) {
        if (currentPlacesNode == this._rootElt) {
          inHierarchy = true;
          break;
        }
        currentPlacesNode = currentPlacesNode.parentNode;
      }
      // The _clearOverFolder() function will close the menu for
      // _overFolder.elt.  So null it out if we don't want to close it.
      if (inHierarchy)
        this._overFolder.elt = null;

      // Clear out the folder and all associated timers.
      this._clearOverFolder();
    }
  },

  _onMouseOver: function PT__onMouseOver(aEvent) {
    let button = aEvent.target;
    if (button.parentNode == this._rootElt && button._placesNode &&
        PlacesUtils.nodeIsURI(button._placesNode))
      window.XULBrowserWindow.setOverLink(aEvent.target._placesNode.uri, null);
  },

  _onMouseOut: function PT__onMouseOut(aEvent) {
    window.XULBrowserWindow.setOverLink("", null);
  },

  _cleanupDragDetails: function PT__cleanupDragDetails() {
    // Called on dragend and drop.
    PlacesControllerDragHelper.currentDropTarget = null;
    this._draggedElt = null;
    if (this._ibTimer)
      this._ibTimer.cancel();

    this._dropIndicator.collapsed = true;
  },

  _onDragStart: function PT__onDragStart(aEvent) {
    // Sub menus have their own d&d handlers.
    let draggedElt = aEvent.target;
    if (draggedElt.parentNode != this._rootElt || !draggedElt._placesNode)
      return;

    if (draggedElt.localName == "toolbarbutton" &&
        draggedElt.getAttribute("type") == "menu") {
      // If the drag gesture on a container is toward down we open instead
      // of dragging.
      let translateY = this._cachedMouseMoveEvent.clientY - aEvent.clientY;
      let translateX = this._cachedMouseMoveEvent.clientX - aEvent.clientX;
      if ((translateY) >= Math.abs(translateX/2)) {
        // Don't start the drag.
        aEvent.preventDefault();
        // Open the menu.
        draggedElt.open = true;
        return;
      }

      // If the menu is open, close it.
      if (draggedElt.open) {
        draggedElt.lastChild.hidePopup();
        draggedElt.open = false;
      }
    }

    // Activate the view and cache the dragged element.
    this._draggedElt = draggedElt._placesNode;
    this._rootElt.focus();

    this._controller.setDataTransfer(aEvent);
    aEvent.stopPropagation();
  },

  _onDragOver: function PT__onDragOver(aEvent) {
    // Cache the dataTransfer
    PlacesControllerDragHelper.currentDropTarget = aEvent.target;
    let dt = aEvent.dataTransfer;

    let dropPoint = this._getDropPoint(aEvent);
    if (!dropPoint || !dropPoint.ip ||
        !PlacesControllerDragHelper.canDrop(dropPoint.ip, dt)) {
      this._dropIndicator.collapsed = true;
      aEvent.stopPropagation();
      return;
    }

    if (this._ibTimer) {
      this._ibTimer.cancel();
      this._ibTimer = null;
    }

    if (dropPoint.folderElt || aEvent.originalTarget == this._chevron) {
      // Dropping over a menubutton or chevron button.
      // Set styles and timer to open relative menupopup.
      let overElt = dropPoint.folderElt || this._chevron;
      if (this._overFolder.elt != overElt) {
        this._clearOverFolder();
        this._overFolder.elt = overElt;
        this._overFolder.openTimer = this._setTimer(this._overFolder.hoverTime);
      }
      if (!this._overFolder.elt.hasAttribute("dragover"))
        this._overFolder.elt.setAttribute("dragover", "true");

      this._dropIndicator.collapsed = true;
    }
    else {
      // Dragging over a normal toolbarbutton,
      // show indicator bar and move it to the appropriate drop point.
      let ind = this._dropIndicator;
      ind.parentNode.collapsed = false;
      let halfInd = ind.clientWidth / 2;
      let translateX;
      if (this.isRTL) {
        halfInd = Math.ceil(halfInd);
        translateX = 0 - this._rootElt.getBoundingClientRect().right - halfInd;
        if (this._rootElt.firstChild) {
          if (dropPoint.beforeIndex == -1)
            translateX += this._rootElt.lastChild.getBoundingClientRect().left;
          else {
            translateX += this._rootElt.childNodes[dropPoint.beforeIndex]
                              .getBoundingClientRect().right;
          }
        }
      }
      else {
        halfInd = Math.floor(halfInd);
        translateX = 0 - this._rootElt.getBoundingClientRect().left +
                     halfInd;
        if (this._rootElt.firstChild) {
          if (dropPoint.beforeIndex == -1)
            translateX += this._rootElt.lastChild.getBoundingClientRect().right;
          else {
            translateX += this._rootElt.childNodes[dropPoint.beforeIndex]
                              .getBoundingClientRect().left;
          }
        }
      }

      ind.style.transform = "translate(" + Math.round(translateX) + "px)";
      ind.style.marginInlineStart = (-ind.clientWidth) + "px";
      ind.collapsed = false;

      // Clear out old folder information.
      this._clearOverFolder();
    }

    aEvent.preventDefault();
    aEvent.stopPropagation();
  },

  _onDrop: function PT__onDrop(aEvent) {
    PlacesControllerDragHelper.currentDropTarget = aEvent.target;

    let dropPoint = this._getDropPoint(aEvent);
    if (dropPoint && dropPoint.ip) {
      PlacesControllerDragHelper.onDrop(dropPoint.ip, aEvent.dataTransfer)
                                .then(null, Components.utils.reportError);
      aEvent.preventDefault();
    }

    this._cleanupDragDetails();
    aEvent.stopPropagation();
  },

  _onDragExit: function PT__onDragExit(aEvent) {
    PlacesControllerDragHelper.currentDropTarget = null;

    // Set timer to turn off indicator bar (if we turn it off
    // here, dragenter might be called immediately after, creating
    // flicker).
    if (this._ibTimer)
      this._ibTimer.cancel();
    this._ibTimer = this._setTimer(10);

    // If we hovered over a folder, close it now.
    if (this._overFolder.elt)
        this._overFolder.closeTimer = this._setTimer(this._overFolder.hoverTime);
  },

  _onDragEnd: function PT_onDragEnd(aEvent) {
    this._cleanupDragDetails();
  },

  _onPopupShowing: function PT__onPopupShowing(aEvent) {
    if (!this._allowPopupShowing) {
      this._allowPopupShowing = true;
      aEvent.preventDefault();
      return;
    }

    let parent = aEvent.target.parentNode;
    if (parent.localName == "toolbarbutton")
      this._openedMenuButton = parent;

    PlacesViewBase.prototype._onPopupShowing.apply(this, arguments);
  },

  _onPopupHidden: function PT__onPopupHidden(aEvent) {
    let popup = aEvent.target;
    let placesNode = popup._placesNode;
    // Avoid handling popuphidden of inner views
    if (placesNode && PlacesUIUtils.getViewForNode(popup) == this) {
      // UI performance: folder queries are cheap, keep the resultnode open
      // so we don't rebuild its contents whenever the popup is reopened.
      // Though, we want to always close feed containers so their expiration
      // status will be checked at next opening.
      if (!PlacesUtils.nodeIsFolder(placesNode) ||
          this.controller.hasCachedLivemarkInfo(placesNode)) {
        placesNode.containerOpen = false;
      }
    }

    let parent = popup.parentNode;
    if (parent.localName == "toolbarbutton") {
      this._openedMenuButton = null;
      // Clear the dragover attribute if present, if we are dragging into a
      // folder in the hierachy of current opened popup we don't clear
      // this attribute on clearOverFolder.  See Notify for closeTimer.
      if (parent.hasAttribute("dragover"))
        parent.removeAttribute("dragover");
    }
  },

  _onMouseMove: function PT__onMouseMove(aEvent) {
    // Used in dragStart to prevent dragging folders when dragging down.
    this._cachedMouseMoveEvent = aEvent;

    if (this._openedMenuButton == null ||
        PlacesControllerDragHelper.getSession())
      return;

    let target = aEvent.originalTarget;
    if (this._openedMenuButton != target &&
        target.localName == "toolbarbutton" &&
        target.type == "menu") {
      this._openedMenuButton.open = false;
      target.open = true;
    }
  }
};

/**
 * View for Places menus.  This object should be created during the first
 * popupshowing that's dispatched on the menu.
 */
function PlacesMenu(aPopupShowingEvent, aPlace, aOptions) {
  this._rootElt = aPopupShowingEvent.target; // <menupopup>
  this._viewElt = this._rootElt.parentNode;   // <menu>
  this._viewElt._placesView = this;
  this._addEventListeners(this._rootElt, ["popupshowing", "popuphidden"], true);
  this._addEventListeners(window, ["unload"], false);

  if (AppConstants.platform === "macosx") {
    // Must walk up to support views in sub-menus, like Bookmarks Toolbar menu.
    for (let elt = this._viewElt.parentNode; elt; elt = elt.parentNode) {
      if (elt.localName == "menubar") {
        this._nativeView = true;
        break;
      }
    }
  }

  PlacesViewBase.call(this, aPlace, aOptions);
  this._onPopupShowing(aPopupShowingEvent);
}

PlacesMenu.prototype = {
  __proto__: PlacesViewBase.prototype,

  QueryInterface: function PM_QueryInterface(aIID) {
    if (aIID.equals(Ci.nsIDOMEventListener))
      return this;

    return PlacesViewBase.prototype.QueryInterface.apply(this, arguments);
  },

  _removeChild: function PM_removeChild(aChild) {
    PlacesViewBase.prototype._removeChild.apply(this, arguments);
  },

  uninit: function PM_uninit() {
    this._removeEventListeners(this._rootElt, ["popupshowing", "popuphidden"],
                               true);
    this._removeEventListeners(window, ["unload"], false);

    PlacesViewBase.prototype.uninit.apply(this, arguments);
  },

  handleEvent: function PM_handleEvent(aEvent) {
    switch (aEvent.type) {
      case "unload":
        this.uninit();
        break;
      case "popupshowing":
        this._onPopupShowing(aEvent);
        break;
      case "popuphidden":
        this._onPopupHidden(aEvent);
        break;
    }
  },

  _onPopupHidden: function PM__onPopupHidden(aEvent) {
    // Avoid handling popuphidden of inner views.
    let popup = aEvent.originalTarget;
    let placesNode = popup._placesNode;
    if (!placesNode || PlacesUIUtils.getViewForNode(popup) != this)
      return;

    // UI performance: folder queries are cheap, keep the resultnode open
    // so we don't rebuild its contents whenever the popup is reopened.
    // Though, we want to always close feed containers so their expiration
    // status will be checked at next opening.
    if (!PlacesUtils.nodeIsFolder(placesNode) ||
        this.controller.hasCachedLivemarkInfo(placesNode))
      placesNode.containerOpen = false;

    // The autoopened attribute is set for folders which have been
    // automatically opened when dragged over.  Turn off this attribute
    // when the folder closes because it is no longer applicable.
    popup.removeAttribute("autoopened");
    popup.removeAttribute("dragstart");
  }
};

function PlacesPanelMenuView(aPlace, aViewId, aRootId, aOptions) {
  this._viewElt = document.getElementById(aViewId);
  this._rootElt = document.getElementById(aRootId);
  this._viewElt._placesView = this;
  this.options = aOptions;

  PlacesViewBase.call(this, aPlace, aOptions);
}

PlacesPanelMenuView.prototype = {
  __proto__: PlacesViewBase.prototype,

  QueryInterface: function PAMV_QueryInterface(aIID) {
    return PlacesViewBase.prototype.QueryInterface.apply(this, arguments);
  },

  uninit: function PAMV_uninit() {
    PlacesViewBase.prototype.uninit.apply(this, arguments);
  },

  _insertNewItem:
  function PAMV__insertNewItem(aChild, aBefore) {
    this._domNodes.delete(aChild);

    let type = aChild.type;
    let button;
    if (type == Ci.nsINavHistoryResultNode.RESULT_TYPE_SEPARATOR) {
      button = document.createElement("toolbarseparator");
      button.setAttribute("class", "small-separator");
    }
    else {
      button = document.createElement("toolbarbutton");
      button.className = "bookmark-item";
      if (typeof this.options.extraClasses.entry == "string")
        button.classList.add(this.options.extraClasses.entry);
      button.setAttribute("label", aChild.title || "");
      let icon = aChild.icon;
      if (icon)
        button.setAttribute("image", icon);

      if (PlacesUtils.containerTypes.includes(type)) {
        button.setAttribute("container", "true");

        if (PlacesUtils.nodeIsQuery(aChild)) {
          button.setAttribute("query", "true");
          if (PlacesUtils.nodeIsTagQuery(aChild))
            button.setAttribute("tagContainer", "true");
        }
        else if (PlacesUtils.nodeIsFolder(aChild)) {
          PlacesUtils.livemarks.getLivemark({ id: aChild.itemId })
            .then(aLivemark => {
              button.setAttribute("livemark", "true");
              this.controller.cacheLivemarkInfo(aChild, aLivemark);
            }, () => undefined);
        }
      }
      else if (PlacesUtils.nodeIsURI(aChild)) {
        button.setAttribute("scheme",
                            PlacesUIUtils.guessUrlSchemeForUI(aChild.uri));
      }
    }

    button._placesNode = aChild;
    if (!this._domNodes.has(aChild))
      this._domNodes.set(aChild, button);

    this._rootElt.insertBefore(button, aBefore);
  },

  nodeInserted:
  function PAMV_nodeInserted(aParentPlacesNode, aPlacesNode, aIndex) {
    let parentElt = this._getDOMNodeForPlacesNode(aParentPlacesNode);
    if (parentElt != this._rootElt)
      return;

    let children = this._rootElt.childNodes;
    this._insertNewItem(aPlacesNode,
      aIndex < children.length ? children[aIndex] : null);
  },

  nodeRemoved:
  function PAMV_nodeRemoved(aParentPlacesNode, aPlacesNode, aIndex) {
    let parentElt = this._getDOMNodeForPlacesNode(aParentPlacesNode);
    if (parentElt != this._rootElt)
      return;

    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);
    this._removeChild(elt);
  },

  nodeMoved:
  function PAMV_nodeMoved(aPlacesNode,
                          aOldParentPlacesNode, aOldIndex,
                          aNewParentPlacesNode, aNewIndex) {
    let parentElt = this._getDOMNodeForPlacesNode(aNewParentPlacesNode);
    if (parentElt != this._rootElt)
      return;

    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);
    this._removeChild(elt);
    this._rootElt.insertBefore(elt, this._rootElt.childNodes[aNewIndex]);
  },

  nodeAnnotationChanged:
  function PAMV_nodeAnnotationChanged(aPlacesNode, aAnno) {
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);
    // There's no UI representation for the root node.
    if (elt == this._rootElt)
      return;

    if (elt.parentNode != this._rootElt)
      return;

    // All livemarks have a feedURI, so use it as our indicator.
    if (aAnno == PlacesUtils.LMANNO_FEEDURI) {
      elt.setAttribute("livemark", true);

      PlacesUtils.livemarks.getLivemark({ id: aPlacesNode.itemId })
        .then(aLivemark => {
          this.controller.cacheLivemarkInfo(aPlacesNode, aLivemark);
          this.invalidateContainer(aPlacesNode);
        }, Components.utils.reportError);
    }
  },

  nodeTitleChanged: function PAMV_nodeTitleChanged(aPlacesNode, aNewTitle) {
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);

    // There's no UI representation for the root node.
    if (elt == this._rootElt)
      return;

    PlacesViewBase.prototype.nodeTitleChanged.apply(this, arguments);
  },

  invalidateContainer: function PAMV_invalidateContainer(aPlacesNode) {
    let elt = this._getDOMNodeForPlacesNode(aPlacesNode);
    if (elt != this._rootElt)
      return;

    // Container is the toolbar itself.
    while (this._rootElt.hasChildNodes()) {
      this._rootElt.removeChild(this._rootElt.firstChild);
    }

    for (let i = 0; i < this._resultNode.childCount; ++i) {
      this._insertNewItem(this._resultNode.getChild(i), null);
    }
  }
};
