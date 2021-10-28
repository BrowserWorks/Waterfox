"use strict";

/**
 * This is used to prevent Bing from displaying Edge advertising banners.
 */

/* globals exportFunction Services */

const originalUA = navigator.userAgent;
const overrideUA =
  originalUA.substr(0, originalUA.indexOf(")") + 1) +
  " AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36 Edg/94.0.992.31";
Object.defineProperty(window.navigator.wrappedJSObject, "userAgent", {
  get: exportFunction(function() {
    return overrideUA;
  }, window),

  set: exportFunction(function() {}, window),
});

function setStyleSheet() {
  const styleSheet = document.createElement("style");
  styleSheet.setAttribute("id", "wf-bing-style");
  styleSheet.textContent = `
          #b_pole,
          #b_notificationContainer_bop {
            display: none !important;
          }
        }
      `;
  document.documentElement.insertBefore(
    styleSheet,
    document.documentElement.firstChild
  );
}

function removeStyleSheet() {
  let styleSheet = document.getElementById("wf-bing-style");
  if (styleSheet) {
    styleSheet.remove(styleSheet);
  }
}

document.addEventListener("DOMContentLoaded", event => {
  setStyleSheet();
});

document.addEventListener("unload", event => {
  removeStyleSheet();
});
