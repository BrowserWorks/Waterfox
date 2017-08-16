/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint no-unused-vars: [2, {"vars": "local"}] */
/* import-globals-from ../../test/head.js */
"use strict";

// Import the inspector's head.js first (which itself imports shared-head.js).
Services.scriptloader.loadSubScript(
  "chrome://mochitests/content/browser/devtools/client/inspector/test/head.js",
  this);

registerCleanupFunction(() => {
  Services.prefs.clearUserPref("devtools.defaultColorUnit");
});

/**
 * Dispatch the copy event on the given element
 */
function fireCopyEvent(element) {
  let evt = element.ownerDocument.createEvent("Event");
  evt.initEvent("copy", true, true);
  element.dispatchEvent(evt);
}

/**
 * Get references to the name and value span nodes corresponding to a given
 * property name in the computed-view
 *
 * @param {CssComputedView} view
 *        The instance of the computed view panel
 * @param {String} name
 *        The name of the property to retrieve
 * @return an object {nameSpan, valueSpan}
 */
function getComputedViewProperty(view, name) {
  let prop;
  for (let property of view.styleDocument.querySelectorAll(".property-view")) {
    let nameSpan = property.querySelector(".property-name");
    let valueSpan = property.querySelector(".property-value");

    if (nameSpan.firstChild.textContent === name) {
      prop = {nameSpan: nameSpan, valueSpan: valueSpan};
      break;
    }
  }
  return prop;
}

/**
 * Get an instance of PropertyView from the computed-view.
 *
 * @param {CssComputedView} view
 *        The instance of the computed view panel
 * @param {String} name
 *        The name of the property to retrieve
 * @return {PropertyView}
 */
function getComputedViewPropertyView(view, name) {
  let propView;
  for (let propertyView of view.propertyViews) {
    if (propertyView._propertyInfo.name === name) {
      propView = propertyView;
      break;
    }
  }
  return propView;
}

/**
 * Get a reference to the property-content element for a given property name in
 * the computed-view.
 * A property-content element always follows (nextSibling) the property itself
 * and is only shown when the twisty icon is expanded on the property.
 * A property-content element contains matched rules, with selectors,
 * properties, values and stylesheet links
 *
 * @param {CssComputedView} view
 *        The instance of the computed view panel
 * @param {String} name
 *        The name of the property to retrieve
 * @return {Promise} A promise that resolves to the property matched rules
 * container
 */
var getComputedViewMatchedRules = Task.async(function* (view, name) {
  let expander;
  let propertyContent;
  for (let property of view.styleDocument.querySelectorAll(".property-view")) {
    let nameSpan = property.querySelector(".property-name");
    if (nameSpan.firstChild.textContent === name) {
      expander = property.querySelector(".expandable");
      propertyContent = property.nextSibling;
      break;
    }
  }

  if (!expander.hasAttribute("open")) {
    // Need to expand the property
    let onExpand = view.inspector.once("computed-view-property-expanded");
    expander.click();
    yield onExpand;
  }

  return propertyContent;
});

/**
 * Get the text value of the property corresponding to a given name in the
 * computed-view
 *
 * @param {CssComputedView} view
 *        The instance of the computed view panel
 * @param {String} name
 *        The name of the property to retrieve
 * @return {String} The property value
 */
function getComputedViewPropertyValue(view, name, propertyName) {
  return getComputedViewProperty(view, name, propertyName)
    .valueSpan.textContent;
}

/**
 * Expand a given property, given its index in the current property list of
 * the computed view
 *
 * @param {CssComputedView} view
 *        The instance of the computed view panel
 * @param {Number} index
 *        The index of the property to be expanded
 * @return a promise that resolves when the property has been expanded, or
 * rejects if the property was not found
 */
function expandComputedViewPropertyByIndex(view, index) {
  info("Expanding property " + index + " in the computed view");
  let expandos = view.styleDocument.querySelectorAll("#propertyContainer .expandable");
  if (!expandos.length || !expandos[index]) {
    return promise.reject();
  }

  let onExpand = view.inspector.once("computed-view-property-expanded");
  expandos[index].click();
  return onExpand;
}

/**
 * Get a rule-link from the computed-view given its index
 *
 * @param {CssComputedView} view
 *        The instance of the computed view panel
 * @param {Number} index
 *        The index of the link to be retrieved
 * @return {DOMNode} The link at the given index, if one exists, null otherwise
 */
function getComputedViewLinkByIndex(view, index) {
  let links = view.styleDocument.querySelectorAll(".rule-link .link");
  return links[index];
}

/**
 * Trigger the select all action in the computed view.
 *
 * @param {CssComputedView} view
 *        The instance of the computed view panel
 */
function selectAllText(view) {
  info("Selecting all the text");
  view._contextmenu._onSelectAll();
}

/**
 * Select all the text, copy it, and check the content in the clipboard.
 *
 * @param {CssComputedView} view
 *        The instance of the computed view panel
 * @param {String} expectedPattern
 *        A regular expression used to check the content of the clipboard
 */
function* copyAllAndCheckClipboard(view, expectedPattern) {
  selectAllText(view);
  let contentDoc = view.styleDocument;
  let prop = contentDoc.querySelector(".property-view");

  try {
    info("Trigger a copy event and wait for the clipboard content");
    yield waitForClipboardPromise(() => fireCopyEvent(prop),
                                  () => checkClipboard(expectedPattern));
  } catch (e) {
    failClipboardCheck(expectedPattern);
  }
}

/**
 * Select some text, copy it, and check the content in the clipboard.
 *
 * @param {CssComputedView} view
 *        The instance of the computed view panel
 * @param {Object} positions
 *        The start and end positions of the text to be selected. This must be an object
 *        like this:
 *        { start: {prop: 1, offset: 0}, end: {prop: 3, offset: 5} }
 * @param {String} expectedPattern
 *        A regular expression used to check the content of the clipboard
 */
function* copySomeTextAndCheckClipboard(view, positions, expectedPattern) {
  info("Testing selection copy");

  let contentDocument = view.styleDocument;
  let props = contentDocument.querySelectorAll(".property-view");

  info("Create the text selection range");
  let range = contentDocument.createRange();
  range.setStart(props[positions.start.prop], positions.start.offset);
  range.setEnd(props[positions.end.prop], positions.end.offset);
  contentDocument.defaultView.getSelection().addRange(range);

  try {
    info("Trigger a copy event and wait for the clipboard content");
    yield waitForClipboardPromise(() => fireCopyEvent(props[0]),
                                  () => checkClipboard(expectedPattern));
  } catch (e) {
    failClipboardCheck(expectedPattern);
  }
}

function checkClipboard(expectedPattern) {
  let actual = SpecialPowers.getClipboardData("text/unicode");
  let expectedRegExp = new RegExp(expectedPattern, "g");
  return expectedRegExp.test(actual);
}

function failClipboardCheck(expectedPattern) {
  // Format expected text for comparison
  let terminator = Services.appinfo.OS == "WINNT" ? "\r\n" : "\n";
  expectedPattern = expectedPattern.replace(/\[\\r\\n\][+*]/g, terminator);
  expectedPattern = expectedPattern.replace(/\\\(/g, "(");
  expectedPattern = expectedPattern.replace(/\\\)/g, ")");

  let actual = SpecialPowers.getClipboardData("text/unicode");

  // Trim the right hand side of our strings. This is because expectedPattern
  // accounts for windows sometimes adding a newline to our copied data.
  expectedPattern = expectedPattern.trimRight();
  actual = actual.trimRight();

  dump("TEST-UNEXPECTED-FAIL | Clipboard text does not match expected ... " +
    "results (escaped for accurate comparison):\n");
  info("Actual: " + escape(actual));
  info("Expected: " + escape(expectedPattern));
}
