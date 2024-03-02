/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
/* globals browser */

"use-strict";

function uninit() {
  updateInstallClickHandlers(document.body, false);
  unwatchAddingInstallHandlers();
}

function init() {
  (function initInstallHandlers() {
    if (document.body) {
      updateInstallClickHandlers(document.body, true);
      watchForAddingInstallHandlers();
      replaceButtonText();
      return;
    }
    window.requestAnimationFrame(initInstallHandlers);
  })();
}

let gObserver;
const addExtensionButton = (document.querySelectorAll('main > div > section > section > div > div > button'))[0];
init();

function hideElements() {
  const elementsToHide = Array.from(document.querySelectorAll('[aria-labelledby="promo-header"], [aria-label="info"]'));

  for (const element of elementsToHide) {
    element.style.display = 'none';
  }
}

function replaceButtonText() {
  addExtensionButton.textContent = addExtensionButton.textContent = 'Add to Waterfox';
  addExtensionButton.style.color = 'white'; // Add this line
}

function updateInstallClickHandlers(node, addHandlers) {
  if (node.nodeType === Node.ELEMENT_NODE) {

    if (addHandlers) {
      addExtensionButton.removeAttribute('disabled');
      addExtensionButton.addEventListener("click", handleInstall, true);
    } else {
      addExtensionButton.setAttribute('disabled', '');
      addExtensionButton.removeEventListener("click", handleInstall, true);
    }
  }
}

function handleInstall(e) {
  e.preventDefault();
  e.stopPropagation();

  // Extract the extension ID from the URL of the page
  const urlParts = window.location.pathname.split('/');
  const extId = urlParts[urlParts.length - 1];

  if (!extId) {
    alert(
      "Addon Stores Compatibility encountered an error. Failed to determine extension ID."
    );
  } else {
    let downloadURL = buildDownloadURL(extId);
  }
}

function watchForAddingInstallHandlers() {
  gObserver = new MutationObserver(mutations => {
    for (const mutation of mutations) {
      if (mutation.type === "childList") {
        for (const node of mutation.addedNodes) {
          updateInstallClickHandlers(node, true);
          hideElements();
        }
      }
    }
  });

  gObserver.observe(document.body, {
    childList: true,
    subtree: true,
  });
}

function unwatchAddingInstallHandlers() {
  gObserver.disconnect();
}

function buildDownloadURL(extId) {
  let baseUrl =
    "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=49.0&acceptformat=crx3&x=id%3D***%26installsource%3Dondemand%26uc";
  return baseUrl.replace("***", extId);
}
