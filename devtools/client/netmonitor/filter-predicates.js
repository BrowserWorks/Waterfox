"use strict";

/**
 * Predicates used when filtering items.
 *
 * @param object item
 *        The filtered item.
 * @return boolean
 *         True if the item should be visible, false otherwise.
 */
function all() {
  return true;
}

function isHtml({ mimeType }) {
  return mimeType && mimeType.includes("/html");
}

function isCss({ mimeType }) {
  return mimeType && mimeType.includes("/css");
}

function isJs({ mimeType }) {
  return mimeType && (
    mimeType.includes("/ecmascript") ||
    mimeType.includes("/javascript") ||
    mimeType.includes("/x-javascript"));
}

function isXHR(item) {
  // Show the request it is XHR, except if the request is a WS upgrade
  return item.isXHR && !isWS(item);
}

function isFont({ url, mimeType }) {
  // Fonts are a mess.
  return (mimeType && (
      mimeType.includes("font/") ||
      mimeType.includes("/font"))) ||
    url.includes(".eot") ||
    url.includes(".ttf") ||
    url.includes(".otf") ||
    url.includes(".woff");
}

function isImage({ mimeType }) {
  return mimeType && mimeType.includes("image/");
}

function isMedia({ mimeType }) {
  // Not including images.
  return mimeType && (
    mimeType.includes("audio/") ||
    mimeType.includes("video/") ||
    mimeType.includes("model/"));
}

function isFlash({ url, mimeType }) {
  // Flash is a mess.
  return (mimeType && (
      mimeType.includes("/x-flv") ||
      mimeType.includes("/x-shockwave-flash"))) ||
    url.includes(".swf") ||
    url.includes(".flv");
}

function isWS({ requestHeaders, responseHeaders }) {
  // Detect a websocket upgrade if request has an Upgrade header with value 'websocket'
  if (!requestHeaders || !Array.isArray(requestHeaders.headers)) {
    return false;
  }

  // Find the 'upgrade' header.
  let upgradeHeader = requestHeaders.headers.find(header => {
    return (header.name == "Upgrade");
  });

  // If no header found on request, check response - mainly to get
  // something we can unit test, as it is impossible to set
  // the Upgrade header on outgoing XHR as per the spec.
  if (!upgradeHeader && responseHeaders &&
      Array.isArray(responseHeaders.headers)) {
    upgradeHeader = responseHeaders.headers.find(header => {
      return (header.name == "Upgrade");
    });
  }

  // Return false if there is no such header or if its value isn't 'websocket'.
  if (!upgradeHeader || upgradeHeader.value != "websocket") {
    return false;
  }

  return true;
}

function isOther(item) {
  let tests = [isHtml, isCss, isJs, isXHR, isFont, isImage, isMedia, isFlash, isWS];
  return tests.every(is => !is(item));
}

function isFreetextMatch({ url }, text) {
  let lowerCaseUrl = url.toLowerCase();
  let lowerCaseText = text.toLowerCase();
  let textLength = text.length;
  // Support negative filtering
  if (text.startsWith("-") && textLength > 1) {
    lowerCaseText = lowerCaseText.substring(1, textLength);
    return !lowerCaseUrl.includes(lowerCaseText);
  }

  // no text is a positive match
  return !text || lowerCaseUrl.includes(lowerCaseText);
}

exports.Filters = {
  all: all,
  html: isHtml,
  css: isCss,
  js: isJs,
  xhr: isXHR,
  fonts: isFont,
  images: isImage,
  media: isMedia,
  flash: isFlash,
  ws: isWS,
  other: isOther,
};

exports.isFreetextMatch = isFreetextMatch;
