#ifdef 0
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */
#endif


/**
 * This class represents a site that is contained in a cell and can be pinned,
 * moved around or deleted.
 */
function Site(aNode, aLink) {
  this._node = aNode;
  this._node._newtabSite = this;

  this._link = aLink;

  this._render();
  this._addEventHandlers();
}

Site.prototype = {
  /**
   * The site's DOM node.
   */
  get node() { return this._node; },

  /**
   * The site's link.
   */
  get link() { return this._link; },

  /**
   * The url of the site's link.
   */
  get url() { return this.link.url; },

  /**
   * The title of the site's link.
   */
  get title() { return this.link.title || this.link.url; },

  /**
   * The site's parent cell.
   */
  get cell() {
    let parentNode = this.node.parentNode;
    return parentNode && parentNode._newtabCell;
  },

  /**
   * Pins the site on its current or a given index.
   * @param aIndex The pinned index (optional).
   * @return true if link changed type after pin
   */
  pin: function Site_pin(aIndex) {
    if (typeof aIndex == "undefined")
      aIndex = this.cell.index;

    this._updateAttributes(true);
    let changed = gPinnedLinks.pin(this._link, aIndex);
    if (changed) {
      // render site again to remove suggested/sponsored tags
      this._render();
    }
    return changed;
  },

  /**
   * Unpins the site and calls the given callback when done.
   */
  unpin: function Site_unpin() {
    if (this.isPinned()) {
      this._updateAttributes(false);
      gPinnedLinks.unpin(this._link);
      gUpdater.updateGrid();
    }
  },

  /**
   * Checks whether this site is pinned.
   * @return Whether this site is pinned.
   */
  isPinned: function Site_isPinned() {
    return gPinnedLinks.isPinned(this._link);
  },

  /**
   * Blocks the site (removes it from the grid) and calls the given callback
   * when done.
   */
  block: function Site_block() {
    if (!gBlockedLinks.isBlocked(this._link)) {
      gUndoDialog.show(this);
      gBlockedLinks.block(this._link);
      gUpdater.updateGrid();
    }
  },

  /**
   * Gets the DOM node specified by the given query selector.
   * @param aSelector The query selector.
   * @return The DOM node we found.
   */
  _querySelector: function Site_querySelector(aSelector) {
    return this.node.querySelector(aSelector);
  },

  /**
   * Updates attributes for all nodes which status depends on this site being
   * pinned or unpinned.
   * @param aPinned Whether this site is now pinned or unpinned.
   */
  _updateAttributes: function (aPinned) {
    let control = this._querySelector(".newtab-control-pin");

    if (aPinned) {
      this.node.setAttribute("pinned", true);
      control.setAttribute("title", newTabString("unpin"));
    } else {
      this.node.removeAttribute("pinned");
      control.setAttribute("title", newTabString("pin"));
    }
  },

  /**
   * Renders the site's data (fills the HTML fragment).
   */
  _render: function Site_render() {
    // first check for end time, as it may modify the link
    this._checkLinkEndTime();
    // setup display variables
    let url = this.url;
    let title = this.link.type == "history" ? this.link.baseDomain :
                this.title;
    let tooltip = (this.title == url ? this.title : this.title + "\n" + url);

    let link = this._querySelector(".newtab-link");
    link.setAttribute("title", tooltip);
    link.setAttribute("href", url);
    this.node.setAttribute("type", this.link.type);

    let titleNode = this._querySelector(".newtab-title");
    titleNode.textContent = title;
    if (this.link.titleBgColor) {
      titleNode.style.backgroundColor = this.link.titleBgColor;
    }

    if (this.isPinned())
      this._updateAttributes(true);
    // Capture the page if the thumbnail is missing, which will cause page.js
    // to be notified and call our refreshThumbnail() method.
    this.captureIfMissing();
    // but still display whatever thumbnail might be available now.
    this.refreshThumbnail();
  },

  /**
   * Called when the site's tab becomes visible for the first time.
   * Since the newtab may be preloaded long before it's displayed,
   * check for changed conditions and re-render if needed
   */
  onFirstVisible: function Site_onFirstVisible() {
    if (this.link.endTime && this.link.endTime < Date.now()) {
      // site needs to change landing url and background image
      this._render();
    }
    else {
      this.captureIfMissing();
    }
  },

  /**
   * Captures the site's thumbnail in the background, but only if there's no
   * existing thumbnail and the page allows background captures.
   */
  captureIfMissing: function Site_captureIfMissing() {
    if (!document.hidden && !this.link.imageURI) {
      BackgroundPageThumbs.captureIfMissing(this.url);
    }
  },

  /**
   * Refreshes the thumbnail for the site.
   */
  refreshThumbnail: function Site_refreshThumbnail() {
    let link = this.link;
    let thumbnail = this._querySelector(".newtab-thumbnail.thumbnail");
    if (link.bgColor) {
      thumbnail.style.backgroundColor = link.bgColor;
    }
    let uri = link.imageURI || PageThumbs.getThumbnailURL(this.url);
    thumbnail.style.backgroundImage = 'url("' + uri + '")';
  },

  /**
   * Adds event handlers for the site and its buttons.
   */
  _addEventHandlers: function Site_addEventHandlers() {
    // Register drag-and-drop event handlers.
    this._node.addEventListener("dragstart", this, false);
    this._node.addEventListener("dragend", this, false);
    this._node.addEventListener("mouseover", this, false);
  },

  /**
   * Speculatively opens a connection to the current site.
   */
  _speculativeConnect: function Site_speculativeConnect() {
    let sc = Services.io.QueryInterface(Ci.nsISpeculativeConnect);
    let uri = Services.io.newURI(this.url, null, null);
    try {
      // This can throw for certain internal URLs, when they wind up in
      // about:newtab. Be sure not to propagate the error.
      sc.speculativeConnect(uri, null);
    } catch (e) {}
  },

  /**
   * Handles site click events.
   */
  onClick: function Site_onClick(aEvent) {
    let action;
    let pinned = this.isPinned();
    let tileIndex = this.cell.index;
    let {button, target} = aEvent;

    // Handle tile/thumbnail link click
    if (target.classList.contains("newtab-link") ||
        target.parentElement.classList.contains("newtab-link")) {
      // Record for primary and middle clicks
      if (button == 0 || button == 1) {
        action = "click";
      }
    }
    // Only handle primary clicks for the remaining targets
    else if (button == 0) {
      aEvent.preventDefault();
      if (target.classList.contains("newtab-control-block")) {
        this.block();
        action = "block";
      }
      else if (pinned && target.classList.contains("newtab-control-pin")) {
        this.unpin();
        action = "unpin";
      }
      else if (!pinned && target.classList.contains("newtab-control-pin")) {
        if (this.pin()) {
          // suggested link has changed - update rest of the pages
          gAllPages.update(gPage);
        }
        action = "pin";
      }
    }
  },

  /**
   * Handles all site events.
   */
  handleEvent: function Site_handleEvent(aEvent) {
    switch (aEvent.type) {
      case "mouseover":
        this._node.removeEventListener("mouseover", this, false);
        this._speculativeConnect();
        break;
      case "dragstart":
        gDrag.start(this, aEvent);
        break;
      case "dragend":
        gDrag.end(this, aEvent);
        break;
    }
  }
};
