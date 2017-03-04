#ifdef 0
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */
#endif

var gCustomize = {
  _nodeIDSuffixes: [
    "blank",
    "button",
    "classic",
    "panel",
    "overlay"
  ],

  _nodes: {},

  init: function() {
    for (let idSuffix of this._nodeIDSuffixes) {
      this._nodes[idSuffix] = document.getElementById("newtab-customize-" + idSuffix);
    }

    this._nodes.button.addEventListener("click", e => this.showPanel(e));
    this._nodes.blank.addEventListener("click", this);
    this._nodes.classic.addEventListener("click", this);

    this.updateSelected();
  },

  hidePanel: function() {
    this._nodes.overlay.addEventListener("transitionend", function onTransitionEnd() {
      gCustomize._nodes.overlay.removeEventListener("transitionend", onTransitionEnd);
      gCustomize._nodes.overlay.style.display = "none";
    });
    this._nodes.overlay.style.opacity = 0;
    this._nodes.button.removeAttribute("active");
    this._nodes.panel.removeAttribute("open");
    document.removeEventListener("click", this);
    document.removeEventListener("keydown", this);
  },

  showPanel: function(event) {
    if (this._nodes.panel.getAttribute("open") == "true") {
      return;
    }

    let {panel, button, overlay} = this._nodes;
    overlay.style.display = "block";
    panel.setAttribute("open", "true");
    button.setAttribute("active", "true");
    setTimeout(() => {
      // Wait for display update to take place, then animate.
      overlay.style.opacity = 0.8;
    }, 0);

    document.addEventListener("click", this);
    document.addEventListener("keydown", this);

    // Stop the event propogation to prevent panel from immediately closing
    // via the document click event that we just added.
    event.stopPropagation();
  },

  handleEvent: function(event) {
    switch (event.type) {
      case "click":
        this.onClick(event);
        break;
      case "keydown":
        this.onKeyDown(event);
        break;
    }
  },

  onClick: function(event) {
    if (event.currentTarget == document) {
      if (!this._nodes.panel.contains(event.target)) {
        this.hidePanel();
      }
    }
    switch (event.currentTarget.id) {
      case "newtab-customize-blank":
        sendAsyncMessage("NewTab:Customize", {enabled: false});
        break;
      case "newtab-customize-classic":
        sendAsyncMessage("NewTab:Customize", {enabled: true});
        break;
      case "newtab-customize-learn":
        this.showLearn();
        break;
    }
  },

  onKeyDown: function(event) {
    if (event.keyCode == event.DOM_VK_ESCAPE) {
      this.hidePanel();
    }
  },

  showLearn: function() {
    window.open(TILES_INTRO_LINK, 'new_window');
    this.hidePanel();
  },

  updateSelected: function() {
    let {enabled} = gAllPages;
    let selected = enabled ? "classic" : "blank";
    ["classic", "blank"].forEach(id => {
      let node = this._nodes[id];
      if (id == selected) {
        node.setAttribute("selected", true);
      }
      else {
        node.removeAttribute("selected");
      }
    });
  },
};
