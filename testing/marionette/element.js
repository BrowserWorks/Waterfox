/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";
/* global XPCNativeWrapper */

const {classes: Cc, interfaces: Ci, utils: Cu} = Components;

Cu.import("resource://gre/modules/Log.jsm");

Cu.import("chrome://marionette/content/assert.js");
Cu.import("chrome://marionette/content/atom.js");
const {
  error,
  InvalidSelectorError,
  JavaScriptError,
  NoSuchElementError,
  StaleElementReferenceError,
} = Cu.import("chrome://marionette/content/error.js", {});
Cu.import("chrome://marionette/content/wait.js");

const logger = Log.repository.getLogger("Marionette");

this.EXPORTED_SYMBOLS = ["element"];

const DOCUMENT_POSITION_DISCONNECTED = 1;
const XMLNS = "http://www.w3.org/1999/xhtml";

const uuidGen = Cc["@mozilla.org/uuid-generator;1"]
    .getService(Ci.nsIUUIDGenerator);

/**
 * This module provides shared functionality for dealing with DOM-
 * and web elements in Marionette.
 *
 * A web element is an abstraction used to identify an element when it
 * is transported across the protocol, between remote- and local ends.
 *
 * Each element has an associated web element reference (a UUID) that
 * uniquely identifies the the element across all browsing contexts. The
 * web element reference for every element representing the same element
 * is the same.
 *
 * The {@link element.Store} provides a mapping between web element
 * references and DOM elements for each browsing context.  It also provides
 * functionality for looking up and retrieving elements.
 *
 * @namespace
 */
this.element = {};

element.Key = "element-6066-11e4-a52e-4f735466cecf";
element.LegacyKey = "ELEMENT";

element.Strategy = {
  ClassName: "class name",
  Selector: "css selector",
  ID: "id",
  Name: "name",
  LinkText: "link text",
  PartialLinkText: "partial link text",
  TagName: "tag name",
  XPath: "xpath",
  Anon: "anon",
  AnonAttribute: "anon attribute",
};

/**
 * Stores known/seen elements and their associated web element
 * references.
 *
 * Elements are added by calling |add(el)| or |addAll(elements)|, and
 * may be queried by their web element reference using |get(element)|.
 *
 * @class
 * @memberof element
 */
element.Store = class {
  constructor() {
    this.els = {};
    this.timer = Cc["@mozilla.org/timer;1"].createInstance(Ci.nsITimer);
  }

  clear() {
    this.els = {};
  }

  /**
   * Make a collection of elements seen.
   *
   * The oder of the returned web element references is guaranteed to
   * match that of the collection passed in.
   *
   * @param {NodeList} els
   *     Sequence of elements to add to set of seen elements.
   *
   * @return {Array.<WebElement>}
   *     List of the web element references associated with each element
   *     from |els|.
   */
  addAll(els) {
    let add = this.add.bind(this);
    return [...els].map(add);
  }

  /**
   * Make an element seen.
   *
   * @param {nsIDOMElement} el
   *    Element to add to set of seen elements.
   *
   * @return {string}
   *     Web element reference associated with element.
   */
  add(el) {
    for (let i in this.els) {
      let foundEl;
      try {
        foundEl = this.els[i].get();
      } catch (e) {}

      if (foundEl) {
        if (new XPCNativeWrapper(foundEl) == new XPCNativeWrapper(el)) {
          return i;
        }

      // cleanup reference to gc'd element
      } else {
        delete this.els[i];
      }
    }

    let id = element.generateUUID();
    this.els[id] = Cu.getWeakReference(el);
    return id;
  }

  /**
   * Determine if the provided web element reference has been seen
   * before/is in the element store.
   *
   * @param {string} uuid
   *     Element's associated web element reference.
   *
   * @return {boolean}
   *     True if element is in the store, false otherwise.
   */
  has(uuid) {
    return Object.keys(this.els).includes(uuid);
  }

  /**
   * Retrieve a DOM element by its unique web element reference/UUID.
   *
   * @param {string} uuid
   *     Web element reference, or UUID.
   * @param {(nsIDOMWindow|ShadowRoot)} container
   * Window and an optional shadow root that contains the element.
   *
   * @returns {nsIDOMElement}
   *     Element associated with reference.
   *
   * @throws {JavaScriptError}
   *     If the provided reference is unknown.
   * @throws {StaleElementReferenceError}
   *     If element has gone stale, indicating it is no longer attached to
   *     the DOM provided in the container.
   */
  get(uuid, container) {
    let el = this.els[uuid];
    if (!el) {
      throw new JavaScriptError(`Element reference not seen before: ${uuid}`);
    }

    try {
      el = el.get();
    } catch (e) {
      el = null;
      delete this.els[uuid];
    }

    // use XPCNativeWrapper to compare elements (see bug 834266)
    let wrappedFrame = new XPCNativeWrapper(container.frame);
    let wrappedShadowRoot;
    if (container.shadowRoot) {
      wrappedShadowRoot = new XPCNativeWrapper(container.shadowRoot);
    }
    let wrappedEl = new XPCNativeWrapper(el);
    let wrappedContainer = {
      frame: wrappedFrame,
      shadowRoot: wrappedShadowRoot,
    };
    if (!el ||
        !(wrappedEl.ownerDocument == wrappedFrame.document) ||
        element.isDisconnected(wrappedEl, wrappedContainer)) {
      throw new StaleElementReferenceError(
          error.pprint`The element reference of ${el} stale: ` +
              "either the element is no longer attached to the DOM " +
              "or the page has been refreshed");
    }

    return el;
  }
};

/**
 * Find a single element or a collection of elements starting at the
 * document root or a given node.
 *
 * If |timeout| is above 0, an implicit search technique is used.
 * This will wait for the duration of |timeout| for the element
 * to appear in the DOM.
 *
 * See the |element.Strategy| enum for a full list of supported
 * search strategies that can be passed to |strategy|.
 *
 * Available flags for |opts|:
 *
 *     |all|
 *       If true, a multi-element search selector is used and a sequence
 *       of elements will be returned.  Otherwise a single element.
 *
 *     |timeout|
 *       Duration to wait before timing out the search.  If |all| is
 *       false, a NoSuchElementError is thrown if unable to find
 *       the element within the timeout duration.
 *
 *     |startNode|
 *       Element to use as the root of the search.
 *
 * @param {Object.<string, Window>} container
 *     Window object and an optional shadow root that contains the
 *     root shadow DOM element.
 * @param {string} strategy
 *     Search strategy whereby to locate the element(s).
 * @param {string} selector
 *     Selector search pattern.  The selector must be compatible with
 *     the chosen search |strategy|.
 * @param {Object.<string, ?>} opts
 *     Options.
 *
 * @return {Promise.<(nsIDOMElement|Array.<nsIDOMElement>)>}
 *     Single element or a sequence of elements.
 *
 * @throws InvalidSelectorError
 *     If |strategy| is unknown.
 * @throws InvalidSelectorError
 *     If |selector| is malformed.
 * @throws NoSuchElementError
 *     If a single element is requested, this error will throw if the
 *     element is not found.
 */
element.find = function(container, strategy, selector, opts = {}) {
  opts.all = !!opts.all;
  opts.timeout = opts.timeout || 0;

  let searchFn;
  if (opts.all) {
    searchFn = findElements.bind(this);
  } else {
    searchFn = findElement.bind(this);
  }

  return new Promise((resolve, reject) => {
    let findElements = wait.until((resolve, reject) => {
      let res = find_(container, strategy, selector, searchFn, opts);
      if (res.length > 0) {
        resolve(Array.from(res));
      } else {
        reject([]);
      }
    }, opts.timeout);

    findElements.then(foundEls => {
      // the following code ought to be moved into findElement
      // and findElements when bug 1254486 is addressed
      if (!opts.all && (!foundEls || foundEls.length == 0)) {
        let msg;
        switch (strategy) {
          case element.Strategy.AnonAttribute:
            msg = "Unable to locate anonymous element: " +
                JSON.stringify(selector);
            break;

          default:
            msg = "Unable to locate element: " + selector;
        }

        reject(new NoSuchElementError(msg));
      }

      if (opts.all) {
        resolve(foundEls);
      }
      resolve(foundEls[0]);
    }, reject);
  });
};

function find_(container, strategy, selector, searchFn, opts) {
  let rootNode = container.shadowRoot || container.frame.document;
  let startNode;

  if (opts.startNode) {
    startNode = opts.startNode;
  } else {
    switch (strategy) {
      // For anonymous nodes the start node needs to be of type
      // DOMElement, which will refer to :root in case of a DOMDocument.
      case element.Strategy.Anon:
      case element.Strategy.AnonAttribute:
        if (rootNode instanceof Ci.nsIDOMDocument) {
          startNode = rootNode.documentElement;
        }
        break;

      default:
        startNode = rootNode;
    }
  }

  let res;
  try {
    res = searchFn(strategy, selector, rootNode, startNode);
  } catch (e) {
    throw new InvalidSelectorError(
        `Given ${strategy} expression "${selector}" is invalid: ${e}`);
  }

  if (res) {
    if (opts.all) {
      return res;
    }
    return [res];
  }
  return [];
}

/**
 * Find a single element by XPath expression.
 *
 * @param {DOMElement} root
 *     Document root
 * @param {DOMElement} startNode
 *     Where in the DOM hiearchy to begin searching.
 * @param {string} expr
 *     XPath search expression.
 *
 * @return {DOMElement}
 *     First element matching expression.
 */
element.findByXPath = function(root, startNode, expr) {
  let iter = root.evaluate(expr, startNode, null,
      Ci.nsIDOMXPathResult.FIRST_ORDERED_NODE_TYPE, null);
  return iter.singleNodeValue;
};

/**
 * Find elements by XPath expression.
 *
 * @param {DOMElement} root
 *     Document root.
 * @param {DOMElement} startNode
 *     Where in the DOM hierarchy to begin searching.
 * @param {string} expr
 *     XPath search expression.
 *
 * @return {Array.<DOMElement>}
 *     Sequence of found elements matching expression.
 */
element.findByXPathAll = function(root, startNode, expr) {
  let rv = [];
  let iter = root.evaluate(expr, startNode, null,
      Ci.nsIDOMXPathResult.ORDERED_NODE_ITERATOR_TYPE, null);
  let el = iter.iterateNext();
  while (el) {
    rv.push(el);
    el = iter.iterateNext();
  }
  return rv;
};

/**
 * Find all hyperlinks dscendant of |node| which link text is |s|.
 *
 * @param {DOMElement} node
 *     Where in the DOM hierarchy to being searching.
 * @param {string} s
 *     Link text to search for.
 *
 * @return {Array.<DOMAnchorElement>}
 *     Sequence of link elements which text is |s|.
 */
element.findByLinkText = function(node, s) {
  return filterLinks(node, link => link.text.trim() === s);
};

/**
 * Find all hyperlinks descendant of |node| which link text contains |s|.
 *
 * @param {DOMElement} node
 *     Where in the DOM hierachy to begin searching.
 * @param {string} s
 *     Link text to search for.
 *
 * @return {Array.<DOMAnchorElement>}
 *     Sequence of link elements which text containins |s|.
 */
element.findByPartialLinkText = function(node, s) {
  return filterLinks(node, link => link.text.indexOf(s) != -1);
};

/**
 * Filters all hyperlinks that are descendant of |node| by |predicate|.
 *
 * @param {DOMElement} node
 *     Where in the DOM hierarchy to begin searching.
 * @param {function(DOMAnchorElement): boolean} predicate
 *     Function that determines if given link should be included in
 *     return value or filtered away.
 *
 * @return {Array.<DOMAnchorElement>}
 *     Sequence of link elements matching |predicate|.
 */
function filterLinks(node, predicate) {
  let rv = [];
  for (let link of node.getElementsByTagName("a")) {
    if (predicate(link)) {
      rv.push(link);
    }
  }
  return rv;
}

/**
 * Finds a single element.
 *
 * @param {element.Strategy} using
 *     Selector strategy to use.
 * @param {string} value
 *     Selector expression.
 * @param {DOMElement} rootNode
 *     Document root.
 * @param {DOMElement=} startNode
 *     Optional node from which to start searching.
 *
 * @return {DOMElement}
 *     Found elements.
 *
 * @throws {InvalidSelectorError}
 *     If strategy |using| is not recognised.
 * @throws {Error}
 *     If selector expression |value| is malformed.
 */
function findElement(using, value, rootNode, startNode) {
  switch (using) {
    case element.Strategy.ID:
      {
        if (startNode.getElementById) {
          return startNode.getElementById(value);
        }
        let expr = `.//*[@id="${value}"]`;
        return element.findByXPath( rootNode, startNode, expr);
      }

    case element.Strategy.Name:
      {
        if (startNode.getElementsByName) {
          return startNode.getElementsByName(value)[0];
        }
        let expr = `.//*[@name="${value}"]`;
        return element.findByXPath(rootNode, startNode, expr);
      }

    case element.Strategy.ClassName:
      // works for >= Firefox 3
      return startNode.getElementsByClassName(value)[0];

    case element.Strategy.TagName:
      // works for all elements
      return startNode.getElementsByTagName(value)[0];

    case element.Strategy.XPath:
      return element.findByXPath(rootNode, startNode, value);

    case element.Strategy.LinkText:
      for (let link of startNode.getElementsByTagName("a")) {
        if (link.text.trim() === value) {
          return link;
        }
      }
      return undefined;

    case element.Strategy.PartialLinkText:
      for (let link of startNode.getElementsByTagName("a")) {
        if (link.text.indexOf(value) != -1) {
          return link;
        }
      }
      return undefined;

    case element.Strategy.Selector:
      try {
        return startNode.querySelector(value);
      } catch (e) {
        throw new InvalidSelectorError(`${e.message}: "${value}"`);
      }

    case element.Strategy.Anon:
      return rootNode.getAnonymousNodes(startNode);

    case element.Strategy.AnonAttribute:
      let attr = Object.keys(value)[0];
      return rootNode.getAnonymousElementByAttribute(
          startNode, attr, value[attr]);
  }

  throw new InvalidSelectorError(`No such strategy: ${using}`);
}

/**
 * Find multiple elements.
 *
 * @param {element.Strategy} using
 *     Selector strategy to use.
 * @param {string} value
 *     Selector expression.
 * @param {DOMElement} rootNode
 *     Document root.
 * @param {DOMElement=} startNode
 *     Optional node from which to start searching.
 *
 * @return {DOMElement}
 *     Found elements.
 *
 * @throws {InvalidSelectorError}
 *     If strategy |using| is not recognised.
 * @throws {Error}
 *     If selector expression |value| is malformed.
 */
function findElements(using, value, rootNode, startNode) {
  switch (using) {
    case element.Strategy.ID:
      value = `.//*[@id="${value}"]`;

    // fall through
    case element.Strategy.XPath:
      return element.findByXPathAll(rootNode, startNode, value);

    case element.Strategy.Name:
      if (startNode.getElementsByName) {
        return startNode.getElementsByName(value);
      }
      return element.findByXPathAll(
          rootNode, startNode, `.//*[@name="${value}"]`);

    case element.Strategy.ClassName:
      return startNode.getElementsByClassName(value);

    case element.Strategy.TagName:
      return startNode.getElementsByTagName(value);

    case element.Strategy.LinkText:
      return element.findByLinkText(startNode, value);

    case element.Strategy.PartialLinkText:
      return element.findByPartialLinkText(startNode, value);

    case element.Strategy.Selector:
      return startNode.querySelectorAll(value);

    case element.Strategy.Anon:
      return rootNode.getAnonymousNodes(startNode);

    case element.Strategy.AnonAttribute:
      let attr = Object.keys(value)[0];
      let el = rootNode.getAnonymousElementByAttribute(
          startNode, attr, value[attr]);
      if (el) {
        return [el];
      }
      return [];

    default:
      throw new InvalidSelectorError(`No such strategy: ${using}`);
  }
}

/** Determines if |obj| is an HTML or JS collection. */
element.isCollection = function(seq) {
  switch (Object.prototype.toString.call(seq)) {
    case "[object Arguments]":
    case "[object Array]":
    case "[object FileList]":
    case "[object HTMLAllCollection]":
    case "[object HTMLCollection]":
    case "[object HTMLFormControlsCollection]":
    case "[object HTMLOptionsCollection]":
    case "[object NodeList]":
      return true;

    default:
      return false;
  }
};

element.makeWebElement = function(uuid) {
  return {
    [element.Key]: uuid,
    [element.LegacyKey]: uuid,
  };
};

/**
 * Checks if |ref| has either |element.Key| or |element.LegacyKey|
 * as properties.
 *
 * @param {Object.<string, string>} ref
 *     Object that represents a web element reference.
 * @return {boolean}
 *     True if |ref| has either expected property.
 */
element.isWebElementReference = function(ref) {
  let properties = Object.getOwnPropertyNames(ref);
  return properties.includes(element.Key) ||
      properties.includes(element.LegacyKey);
};

element.generateUUID = function() {
  let uuid = uuidGen.generateUUID().toString();
  return uuid.substring(1, uuid.length - 1);
};

/**
 * Check if the element is detached from the current frame as well as
 * the optional shadow root (when inside a Shadow DOM context).
 *
 * @param {nsIDOMElement} el
 *     Element to be checked.
 * @param {Container} container
 *     Container with |frame|, which is the window object that contains
 *     the element, and an optional |shadowRoot|.
 *
 * @return {boolean}
 *     Flag indicating that the element is disconnected.
 */
element.isDisconnected = function(el, container = {}) {
  const {frame, shadowRoot} = container;
  assert.defined(frame);

  // shadow DOM
  if (frame.ShadowRoot && shadowRoot) {
    if (el.compareDocumentPosition(shadowRoot) &
        DOCUMENT_POSITION_DISCONNECTED) {
      return true;
    }

    // looking for next possible ShadowRoot ancestor
    let parent = shadowRoot.host;
    while (parent && !(parent instanceof frame.ShadowRoot)) {
      parent = parent.parentNode;
    }
    return element.isDisconnected(
        shadowRoot.host,
        {frame, shadowRoot: parent});
  }

  // outside shadow DOM
  let docEl = frame.document.documentElement;
  return el.compareDocumentPosition(docEl) &
      DOCUMENT_POSITION_DISCONNECTED;
};

/**
 * This function generates a pair of coordinates relative to the viewport
 * given a target element and coordinates relative to that element's
 * top-left corner.
 *
 * @param {Node} node
 *     Target node.
 * @param {number=} xOffset
 *     Horizontal offset relative to target's top-left corner.
 *     Defaults to the centre of the target's bounding box.
 * @param {number=} yOffset
 *     Vertical offset relative to target's top-left corner.  Defaults to
 *     the centre of the target's bounding box.
 *
 * @return {Object.<string, number>}
 *     X- and Y coordinates.
 *
 * @throws TypeError
 *     If |xOffset| or |yOffset| are not numbers.
 */
element.coordinates = function(
    node, xOffset = undefined, yOffset = undefined) {

  let box = node.getBoundingClientRect();

  if (typeof xOffset == "undefined" || xOffset === null) {
    xOffset = box.width / 2.0;
  }
  if (typeof yOffset == "undefined" || yOffset === null) {
    yOffset = box.height / 2.0;
  }

  if (typeof yOffset != "number" || typeof xOffset != "number") {
    throw new TypeError("Offset must be a number");
  }

  return {
    x: box.left + xOffset,
    y: box.top + yOffset,
  };
};

/**
 * This function returns true if the node is in the viewport.
 *
 * @param {Element} el
 *     Target element.
 * @param {number=} x
 *     Horizontal offset relative to target.  Defaults to the centre of
 *     the target's bounding box.
 * @param {number=} y
 *     Vertical offset relative to target.  Defaults to the centre of
 *     the target's bounding box.
 *
 * @return {boolean}
 *     True if if |el| is in viewport, false otherwise.
 */
element.inViewport = function(el, x = undefined, y = undefined) {
  let win = el.ownerGlobal;
  let c = element.coordinates(el, x, y);
  let vp = {
    top: win.pageYOffset,
    left: win.pageXOffset,
    bottom: (win.pageYOffset + win.innerHeight),
    right: (win.pageXOffset + win.innerWidth),
  };

  return (vp.left <= c.x + win.pageXOffset &&
      c.x + win.pageXOffset <= vp.right &&
      vp.top <= c.y + win.pageYOffset &&
      c.y + win.pageYOffset <= vp.bottom);
};

/**
 * Gets the element's container element.
 *
 * An element container is defined by the WebDriver
 * specification to be an <option> element in a valid element context
 * (https://html.spec.whatwg.org/#concept-element-contexts), meaning
 * that it has an ancestral element that is either <datalist> or <select>.
 *
 * If the element does not have a valid context, its container element
 * is itself.
 *
 * @param {Element} el
 *     Element to get the container of.
 *
 * @return {Element}
 *     Container element of |el|.
 */
element.getContainer = function(el) {
  if (el.localName != "option") {
    return el;
  }

  function validContext(ctx) {
    return ctx.localName == "datalist" || ctx.localName == "select";
  }

  // does <option> have a valid context,
  // meaning is it a child of <datalist> or <select>?
  let parent = el;
  while (parent.parentNode && !validContext(parent)) {
    parent = parent.parentNode;
  }

  if (!validContext(parent)) {
    return el;
  }
  return parent;
};

/**
 * An element is in view if it is a member of its own pointer-interactable
 * paint tree.
 *
 * This means an element is considered to be in view, but not necessarily
 * pointer-interactable, if it is found somewhere in the
 * |elementsFromPoint| list at |el|'s in-view centre coordinates.
 *
 * Before running the check, we change |el|'s pointerEvents style property
 * to "auto", since elements without pointer events enabled do not turn
 * up in the paint tree we get from document.elementsFromPoint.  This is
 * a specialisation that is only relevant when checking if the element is
 * in view.
 *
 * @param {Element} el
 *     Element to check if is in view.
 *
 * @return {boolean}
 *     True if |el| is inside the viewport, or false otherwise.
 */
element.isInView = function(el) {
  let originalPointerEvents = el.style.pointerEvents;
  try {
    el.style.pointerEvents = "auto";
    const tree = element.getPointerInteractablePaintTree(el);
    return tree.includes(el);
  } finally {
    el.style.pointerEvents = originalPointerEvents;
  }
};

/**
 * This function throws the visibility of the element error if the element is
 * not displayed or the given coordinates are not within the viewport.
 *
 * @param {Element} el
 *     Element to check if visible.
 * @param {number=} x
 *     Horizontal offset relative to target.  Defaults to the centre of
 *     the target's bounding box.
 * @param {number=} y
 *     Vertical offset relative to target.  Defaults to the centre of
 *     the target's bounding box.
 *
 * @return {boolean}
 *     True if visible, false otherwise.
 */
element.isVisible = function(el, x = undefined, y = undefined) {
  let win = el.ownerGlobal;

  // Bug 1094246: webdriver's isShown doesn't work with content xul
  if (!element.isXULElement(el) && !atom.isElementDisplayed(el, win)) {
    return false;
  }

  if (el.tagName.toLowerCase() == "body") {
    return true;
  }

  if (!element.inViewport(el, x, y)) {
    element.scrollIntoView(el);
    if (!element.inViewport(el)) {
      return false;
    }
  }
  return true;
};

/**
 * A pointer-interactable element is defined to be the first
 * non-transparent element, defined by the paint order found at the centre
 * point of its rectangle that is inside the viewport, excluding the size
 * of any rendered scrollbars.
 *
 * An element is obscured if the pointer-interactable paint tree at its
 * centre point is empty, or the first element in this tree is not an
 * inclusive descendant of itself.
 *
 * @param {DOMElement} el
 *     Element determine if is pointer-interactable.
 *
 * @return {boolean}
 *     True if element is obscured, false otherwise.
 */
element.isObscured = function(el) {
  let tree = element.getPointerInteractablePaintTree(el);
  return !el.contains(tree[0]);
};

/**
 * Calculate the in-view centre point of the area of the given DOM client
 * rectangle that is inside the viewport.
 *
 * @param {DOMRect} rect
 *     Element off a DOMRect sequence produced by calling |getClientRects|
 *     on a |DOMElement|.
 * @param {nsIDOMWindow} win
 *     Current browsing context.
 *
 * @return {Map.<string, number>}
 *     X and Y coordinates that denotes the in-view centre point of |rect|.
 */
element.getInViewCentrePoint = function(rect, win) {
  const {max, min} = Math;

  let x = {
    left: max(0, min(rect.x, rect.x + rect.width)),
    right: min(win.innerWidth, max(rect.x, rect.x + rect.width)),
  };
  let y = {
    top: max(0, min(rect.y, rect.y + rect.height)),
    bottom: min(win.innerHeight, max(rect.y, rect.y + rect.height)),
  };

  return {
    x: (x.left + x.right) / 2,
    y: (y.top + y.bottom) / 2,
  };
};

/**
 * Produces a pointer-interactable elements tree from a given element.
 *
 * The tree is defined by the paint order found at the centre point of
 * the element's rectangle that is inside the viewport, excluding the size
 * of any rendered scrollbars.
 *
 * @param {DOMElement} el
 *     Element to determine if is pointer-interactable.
 *
 * @return {Array.<DOMElement>}
 *     Sequence of elements in paint order.
 */
element.getPointerInteractablePaintTree = function(el) {
  const doc = el.ownerDocument;
  const win = doc.defaultView;
  const container = {frame: win};
  const rootNode = el.getRootNode();

  // Include shadow DOM host only if the element's root node is not the
  // owner document.
  if (rootNode !== doc) {
    container.shadowRoot = rootNode;
  }

  // pointer-interactable elements tree, step 1
  if (element.isDisconnected(el, container)) {
    return [];
  }

  // steps 2-3
  let rects = el.getClientRects();
  if (rects.length == 0) {
    return [];
  }

  // step 4
  let centre = element.getInViewCentrePoint(rects[0], win);

  // step 5
  return doc.elementsFromPoint(centre.x, centre.y);
};

// TODO(ato): Not implemented.
// In fact, it's not defined in the spec.
element.isKeyboardInteractable = function(el) {
  return true;
};

/**
 * Attempts to scroll into view |el|.
 *
 * @param {DOMElement} el
 *     Element to scroll into view.
 */
element.scrollIntoView = function(el) {
  if (el.scrollIntoView) {
    el.scrollIntoView({block: "end", inline: "nearest", behavior: "instant"});
  }
};

element.isXULElement = function(el) {
  let ns = atom.getElementAttribute(el, "namespaceURI");
  return ns.indexOf("there.is.only.xul") >= 0;
};

const boolEls = {
  audio: ["autoplay", "controls", "loop", "muted"],
  button: ["autofocus", "disabled", "formnovalidate"],
  details: ["open"],
  dialog: ["open"],
  fieldset: ["disabled"],
  form: ["novalidate"],
  iframe: ["allowfullscreen"],
  img: ["ismap"],
  input: [
    "autofocus",
    "checked",
    "disabled",
    "formnovalidate",
    "multiple",
    "readonly",
    "required",
  ],
  keygen: ["autofocus", "disabled"],
  menuitem: ["checked", "default", "disabled"],
  object: ["typemustmatch"],
  ol: ["reversed"],
  optgroup: ["disabled"],
  option: ["disabled", "selected"],
  script: ["async", "defer"],
  select: ["autofocus", "disabled", "multiple", "required"],
  textarea: ["autofocus", "disabled", "readonly", "required"],
  track: ["default"],
  video: ["autoplay", "controls", "loop", "muted"],
};

/**
 * Tests if the attribute is a boolean attribute on element.
 *
 * @param {DOMElement} el
 *     Element to test if |attr| is a boolean attribute on.
 * @param {string} attr
 *     Attribute to test is a boolean attribute.
 *
 * @return {boolean}
 *     True if the attribute is boolean, false otherwise.
 */
element.isBooleanAttribute = function(el, attr) {
  if (el.namespaceURI !== XMLNS) {
    return false;
  }

  // global boolean attributes that apply to all HTML elements,
  // except for custom elements
  const customElement = !el.localName.includes("-");
  if ((attr == "hidden" || attr == "itemscope") && customElement) {
    return true;
  }

  if (!boolEls.hasOwnProperty(el.localName)) {
    return false;
  }
  return boolEls[el.localName].includes(attr);
};
