/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var EXPORTED_SYMBOLS = ["PageInfoChild"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");
const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);

XPCOMUtils.defineLazyModuleGetters(this, {
  PrivateBrowsingUtils: "resource://gre/modules/PrivateBrowsingUtils.jsm",
  setTimeout: "resource://gre/modules/Timer.jsm",
});

class PageInfoChild extends JSWindowActorChild {
  async receiveMessage(message) {
    let strings = message.data.strings;

    let window = this.contentWindow;
    let document = window.document;

    //Handles two different types of messages: one for general info (PageInfo:getData)
    //and one for media info (PageInfo:getMediaData)
    switch (message.name) {
      case "PageInfo:getData": {
        return Promise.resolve({
          metaViewRows: this.getMetaInfo(document),
          docInfo: this.getDocumentInfo(document),
          windowInfo: this.getWindowInfo(window),
        });
      }
      case "PageInfo:getMediaData": {
        return Promise.resolve({
          mediaItems: await this.getDocumentMedia(document, strings),
        });
      }
    }

    return undefined;
  }

  getMetaInfo(document) {
    let metaViewRows = [];

    // Get the meta tags from the page.
    let metaNodes = document.getElementsByTagName("meta");

    for (let metaNode of metaNodes) {
      metaViewRows.push([
        metaNode.name ||
          metaNode.httpEquiv ||
          metaNode.getAttribute("property"),
        metaNode.content,
      ]);
    }

    return metaViewRows;
  }

  getWindowInfo(window) {
    let windowInfo = {};
    windowInfo.isTopWindow = window == window.top;

    let hostName = null;
    try {
      hostName = Services.io.newURI(window.location.href).displayHost;
    } catch (exception) {}

    windowInfo.hostName = hostName;
    return windowInfo;
  }

  getDocumentInfo(document) {
    let docInfo = {};
    docInfo.title = document.title;
    docInfo.location = document.location.toString();
    try {
      docInfo.location = Services.io.newURI(
        document.location.toString()
      ).displaySpec;
    } catch (exception) {}
    docInfo.referrer = document.referrer;
    try {
      if (document.referrer) {
        docInfo.referrer = Services.io.newURI(document.referrer).displaySpec;
      }
    } catch (exception) {}
    docInfo.compatMode = document.compatMode;
    docInfo.contentType = document.contentType;
    docInfo.characterSet = document.characterSet;
    docInfo.lastModified = document.lastModified;
    docInfo.principal = document.nodePrincipal;

    let documentURIObject = {};
    documentURIObject.spec = document.documentURIObject.spec;
    docInfo.documentURIObject = documentURIObject;

    docInfo.isContentWindowPrivate = PrivateBrowsingUtils.isContentWindowPrivate(
      document.ownerGlobal
    );

    return docInfo;
  }

  /**
   * Returns an array that stores all mediaItems found in the document
   * Calls getMediaItems for all nodes within the constructed tree walker and forms
   * resulting array.
   */
  async getDocumentMedia(document, strings) {
    let nodeCount = 0;
    let content = document.ownerGlobal;
    let iterator = document.createTreeWalker(
      document,
      content.NodeFilter.SHOW_ELEMENT
    );

    let totalMediaItems = [];

    while (iterator.nextNode()) {
      let mediaItems = this.getMediaItems(
        document,
        strings,
        iterator.currentNode
      );

      if (++nodeCount % 500 == 0) {
        // setTimeout every 500 elements so we don't keep blocking the content process.
        await new Promise(resolve => setTimeout(resolve, 10));
      }
      totalMediaItems.push(...mediaItems);
    }

    return totalMediaItems;
  }

  getMediaItems(document, strings, elem) {
    // Check for images defined in CSS (e.g. background, borders)
    let computedStyle = elem.ownerGlobal.getComputedStyle(elem);
    // A node can have multiple media items associated with it - for example,
    // multiple background images.
    let mediaItems = [];
    let content = document.ownerGlobal;

    let addImage = (url, type, alt, el, isBg) => {
      let element = this.serializeElementInfo(
        document,
        url,
        type,
        alt,
        el,
        isBg
      );
      mediaItems.push([url, type, alt, element, isBg]);
    };

    if (computedStyle) {
      let addImgFunc = (label, urls) => {
        for (let url of urls) {
          addImage(url, label, strings.notSet, elem, true);
        }
      };
      // FIXME: This is missing properties. See the implementation of
      // getCSSImageURLs for a list of properties.
      //
      // If you don't care about the message you can also pass "all" here and
      // get all the ones the browser knows about.
      addImgFunc(
        strings.mediaBGImg,
        computedStyle.getCSSImageURLs("background-image")
      );
      addImgFunc(
        strings.mediaBorderImg,
        computedStyle.getCSSImageURLs("border-image-source")
      );
      addImgFunc(
        strings.mediaListImg,
        computedStyle.getCSSImageURLs("list-style-image")
      );
      addImgFunc(strings.mediaCursor, computedStyle.getCSSImageURLs("cursor"));
    }

    // One swi^H^H^Hif-else to rule them all.
    if (elem instanceof content.HTMLImageElement) {
      addImage(
        elem.src,
        strings.mediaImg,
        elem.hasAttribute("alt") ? elem.alt : strings.notSet,
        elem,
        false
      );
    } else if (elem instanceof content.SVGImageElement) {
      try {
        // Note: makeURLAbsolute will throw if either the baseURI is not a valid URI
        //       or the URI formed from the baseURI and the URL is not a valid URI.
        if (elem.href.baseVal) {
          let href = Services.io.newURI(
            elem.href.baseVal,
            null,
            Services.io.newURI(elem.baseURI)
          ).spec;
          addImage(href, strings.mediaImg, "", elem, false);
        }
      } catch (e) {}
    } else if (elem instanceof content.HTMLVideoElement) {
      addImage(elem.currentSrc, strings.mediaVideo, "", elem, false);
    } else if (elem instanceof content.HTMLAudioElement) {
      addImage(elem.currentSrc, strings.mediaAudio, "", elem, false);
    } else if (elem instanceof content.HTMLLinkElement) {
      if (elem.rel && /\bicon\b/i.test(elem.rel)) {
        addImage(elem.href, strings.mediaLink, "", elem, false);
      }
    } else if (
      elem instanceof content.HTMLInputElement ||
      elem instanceof content.HTMLButtonElement
    ) {
      if (elem.type.toLowerCase() == "image") {
        addImage(
          elem.src,
          strings.mediaInput,
          elem.hasAttribute("alt") ? elem.alt : strings.notSet,
          elem,
          false
        );
      }
    } else if (elem instanceof content.HTMLObjectElement) {
      addImage(
        elem.data,
        strings.mediaObject,
        this.getValueText(elem),
        elem,
        false
      );
    } else if (elem instanceof content.HTMLEmbedElement) {
      addImage(elem.src, strings.mediaEmbed, "", elem, false);
    }

    return mediaItems;
  }

  /**
   * Set up a JSON element object with all the instanceOf and other infomation that
   * makePreview in pageInfo.js uses to figure out how to display the preview.
   */

  serializeElementInfo(document, url, type, alt, item, isBG) {
    let result = {};
    let content = document.ownerGlobal;

    let imageText;
    if (
      !isBG &&
      !(item instanceof content.SVGImageElement) &&
      !(document instanceof content.ImageDocument)
    ) {
      imageText = item.title || item.alt;

      if (!imageText && !(item instanceof content.HTMLImageElement)) {
        imageText = this.getValueText(item);
      }
    }

    result.imageText = imageText;
    result.longDesc = item.longDesc;
    result.numFrames = 1;

    if (
      item instanceof content.HTMLObjectElement ||
      item instanceof content.HTMLEmbedElement ||
      item instanceof content.HTMLLinkElement
    ) {
      result.mimeType = item.type;
    }

    if (
      !result.mimeType &&
      !isBG &&
      item instanceof Ci.nsIImageLoadingContent
    ) {
      // Interface for image loading content.
      let imageRequest = item.getRequest(
        Ci.nsIImageLoadingContent.CURRENT_REQUEST
      );
      if (imageRequest) {
        result.mimeType = imageRequest.mimeType;
        let image =
          !(imageRequest.imageStatus & imageRequest.STATUS_ERROR) &&
          imageRequest.image;
        if (image) {
          result.numFrames = image.numFrames;
        }
      }
    }

    // If we have a data url, get the MIME type from the url.
    if (!result.mimeType && url.startsWith("data:")) {
      let dataMimeType = /^data:(image\/[^;,]+)/i.exec(url);
      if (dataMimeType) {
        result.mimeType = dataMimeType[1].toLowerCase();
      }
    }

    result.HTMLLinkElement = item instanceof content.HTMLLinkElement;
    result.HTMLInputElement = item instanceof content.HTMLInputElement;
    result.HTMLImageElement = item instanceof content.HTMLImageElement;
    result.HTMLObjectElement = item instanceof content.HTMLObjectElement;
    result.SVGImageElement = item instanceof content.SVGImageElement;
    result.HTMLVideoElement = item instanceof content.HTMLVideoElement;
    result.HTMLAudioElement = item instanceof content.HTMLAudioElement;

    if (isBG) {
      // Items that are showing this image as a background
      // image might not necessarily have a width or height,
      // so we'll dynamically generate an image and send up the
      // natural dimensions.
      let img = content.document.createElement("img");
      img.src = url;
      result.naturalWidth = img.naturalWidth;
      result.naturalHeight = img.naturalHeight;
    } else if (!(item instanceof content.SVGImageElement)) {
      // SVG items do not have integer values for height or width,
      // so we must handle them differently in order to correctly
      // serialize

      // Otherwise, we can use the current width and height
      // of the image.
      result.width = item.width;
      result.height = item.height;
    }

    if (item instanceof content.SVGImageElement) {
      result.SVGImageElementWidth = item.width.baseVal.value;
      result.SVGImageElementHeight = item.height.baseVal.value;
    }

    result.baseURI = item.baseURI;

    return result;
  }

  // Other Misc Stuff
  // Modified from the Links Panel v2.3, http://segment7.net/mozilla/links/links.html
  // parse a node to extract the contents of the node
  getValueText(node) {
    let valueText = "";
    let content = node.ownerGlobal;

    // Form input elements don't generally contain information that is useful to our callers, so return nothing.
    if (
      node instanceof content.HTMLInputElement ||
      node instanceof content.HTMLSelectElement ||
      node instanceof content.HTMLTextAreaElement
    ) {
      return valueText;
    }

    // Otherwise recurse for each child.
    let length = node.childNodes.length;

    for (let i = 0; i < length; i++) {
      let childNode = node.childNodes[i];
      let nodeType = childNode.nodeType;

      // Text nodes are where the goods are.
      if (nodeType == content.Node.TEXT_NODE) {
        valueText += " " + childNode.nodeValue;
      } else if (nodeType == content.Node.ELEMENT_NODE) {
        // And elements can have more text inside them.
        // Images are special, we want to capture the alt text as if the image weren't there.
        if (childNode instanceof content.HTMLImageElement) {
          valueText += " " + this.getAltText(childNode);
        } else {
          valueText += " " + this.getValueText(childNode);
        }
      }
    }

    return this.stripWS(valueText);
  }

  // Copied from the Links Panel v2.3, http://segment7.net/mozilla/links/links.html.
  // Traverse the tree in search of an img or area element and grab its alt tag.
  getAltText(node) {
    let altText = "";

    if (node.alt) {
      return node.alt;
    }
    let length = node.childNodes.length;
    for (let i = 0; i < length; i++) {
      if ((altText = this.getAltText(node.childNodes[i]) != undefined)) {
        // stupid js warning...
        return altText;
      }
    }
    return "";
  }

  // Copied from the Links Panel v2.3, http://segment7.net/mozilla/links/links.html.
  // Strip leading and trailing whitespace, and replace multiple consecutive whitespace characters with a single space.
  stripWS(text) {
    let middleRE = /\s+/g;
    let endRE = /(^\s+)|(\s+$)/g;

    text = text.replace(middleRE, " ");
    return text.replace(endRE, "");
  }
}
