/* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this file,
* You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

this.EXPORTED_SYMBOLS = ["PageStyle"];

const Ci = Components.interfaces;

/**
 * The external API exported by this module.
 */
this.PageStyle = Object.freeze({
  collect(docShell, frameTree) {
    return PageStyleInternal.collect(docShell, frameTree);
  },

  restoreTree(docShell, data) {
    PageStyleInternal.restoreTree(docShell, data);
  }
});

// Signifies that author style level is disabled for the page.
const NO_STYLE = "_nostyle";

var PageStyleInternal = {
  /**
   * Collects the selected style sheet sets for all reachable frames.
   */
  collect(docShell, frameTree) {
    let result = frameTree.map(({document: doc}) => {
      let style;

      if (doc) {
        // http://dev.w3.org/csswg/cssom/#persisting-the-selected-css-style-sheet-set
        style = doc.selectedStyleSheetSet || doc.lastStyleSheetSet;
      }

      return style ? {pageStyle: style} : null;
    });

    let markupDocumentViewer =
      docShell.contentViewer;

    if (markupDocumentViewer.authorStyleDisabled) {
      result = result || {};
      result.disabled = true;
    }

    return result && Object.keys(result).length ? result : null;
  },

  /**
   * Restores pageStyle data for the current frame hierarchy starting at the
   * |docShell's| current DOMWindow using the given pageStyle |data|.
   *
   * Warning: If the current frame hierarchy doesn't match that of the given
   * |data| object we will silently discard data for unreachable frames. We may
   * as well assign page styles to the wrong frames if some were reordered or
   * removed.
   *
   * @param docShell (nsIDocShell)
   * @param data (object)
   *        {
   *          disabled: true, // when true, author styles will be disabled
   *          pageStyle: "Dusk",
   *          children: [
   *            null,
   *            {pageStyle: "Mozilla", children: [ ... ]}
   *          ]
   *        }
   */
  restoreTree(docShell, data) {
    let disabled = data.disabled || false;
    let markupDocumentViewer =
      docShell.contentViewer;
    markupDocumentViewer.authorStyleDisabled = disabled;

    function restoreFrame(root, frameData) {
      if (frameData.hasOwnProperty("pageStyle")) {
        root.document.selectedStyleSheetSet = frameData.pageStyle;
      }

      if (!frameData.hasOwnProperty("children")) {
        return;
      }

      let frames = root.frames;
      frameData.children.forEach((child, index) => {
        if (child && index < frames.length) {
          restoreFrame(frames[index], child);
        }
      });
    }

    let ifreq = docShell.QueryInterface(Ci.nsIInterfaceRequestor);
    restoreFrame(ifreq.getInterface(Ci.nsIDOMWindow), data);
  }
};
