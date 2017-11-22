/* Copyright 2017 Mozilla Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// identity function for calling harmony imports with the correct context
/******/ 	__webpack_require__.i = function(value) { return value; };
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 31);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.localized = exports.animationStarted = exports.normalizeWheelEventDelta = exports.binarySearchFirstItem = exports.watchScroll = exports.scrollIntoView = exports.getOutputScale = exports.approximateFraction = exports.roundToDivide = exports.getVisibleElements = exports.parseQueryString = exports.noContextMenuHandler = exports.getPDFFileNameFromURL = exports.ProgressBar = exports.EventBus = exports.NullL10n = exports.mozL10n = exports.RendererType = exports.cloneObj = exports.VERTICAL_PADDING = exports.SCROLLBAR_PADDING = exports.MAX_AUTO_SCALE = exports.UNKNOWN_SCALE = exports.MAX_SCALE = exports.MIN_SCALE = exports.DEFAULT_SCALE = exports.DEFAULT_SCALE_VALUE = exports.CSS_UNITS = undefined;

var _pdfjsLib = __webpack_require__(1);

const CSS_UNITS = 96.0 / 72.0;
const DEFAULT_SCALE_VALUE = 'auto';
const DEFAULT_SCALE = 1.0;
const MIN_SCALE = 0.25;
const MAX_SCALE = 10.0;
const UNKNOWN_SCALE = 0;
const MAX_AUTO_SCALE = 1.25;
const SCROLLBAR_PADDING = 40;
const VERTICAL_PADDING = 5;
const RendererType = {
  CANVAS: 'canvas',
  SVG: 'svg'
};
function formatL10nValue(text, args) {
  if (!args) {
    return text;
  }
  return text.replace(/\{\{\s*(\w+)\s*\}\}/g, (all, name) => {
    return name in args ? args[name] : '{{' + name + '}}';
  });
}
let NullL10n = {
  get(property, args, fallback) {
    return Promise.resolve(formatL10nValue(fallback, args));
  },
  translate(element) {
    return Promise.resolve();
  }
};
_pdfjsLib.PDFJS.disableFullscreen = _pdfjsLib.PDFJS.disableFullscreen === undefined ? false : _pdfjsLib.PDFJS.disableFullscreen;
_pdfjsLib.PDFJS.useOnlyCssZoom = _pdfjsLib.PDFJS.useOnlyCssZoom === undefined ? false : _pdfjsLib.PDFJS.useOnlyCssZoom;
_pdfjsLib.PDFJS.maxCanvasPixels = _pdfjsLib.PDFJS.maxCanvasPixels === undefined ? 16777216 : _pdfjsLib.PDFJS.maxCanvasPixels;
_pdfjsLib.PDFJS.disableHistory = _pdfjsLib.PDFJS.disableHistory === undefined ? false : _pdfjsLib.PDFJS.disableHistory;
_pdfjsLib.PDFJS.disableTextLayer = _pdfjsLib.PDFJS.disableTextLayer === undefined ? false : _pdfjsLib.PDFJS.disableTextLayer;
_pdfjsLib.PDFJS.ignoreCurrentPositionOnZoom = _pdfjsLib.PDFJS.ignoreCurrentPositionOnZoom === undefined ? false : _pdfjsLib.PDFJS.ignoreCurrentPositionOnZoom;
;
function getOutputScale(ctx) {
  let devicePixelRatio = window.devicePixelRatio || 1;
  let backingStoreRatio = ctx.webkitBackingStorePixelRatio || ctx.mozBackingStorePixelRatio || ctx.msBackingStorePixelRatio || ctx.oBackingStorePixelRatio || ctx.backingStorePixelRatio || 1;
  let pixelRatio = devicePixelRatio / backingStoreRatio;
  return {
    sx: pixelRatio,
    sy: pixelRatio,
    scaled: pixelRatio !== 1
  };
}
function scrollIntoView(element, spot, skipOverflowHiddenElements = false) {
  let parent = element.offsetParent;
  if (!parent) {
    console.error('offsetParent is not set -- cannot scroll');
    return;
  }
  let offsetY = element.offsetTop + element.clientTop;
  let offsetX = element.offsetLeft + element.clientLeft;
  while (parent.clientHeight === parent.scrollHeight || skipOverflowHiddenElements && getComputedStyle(parent).overflow === 'hidden') {
    if (parent.dataset._scaleY) {
      offsetY /= parent.dataset._scaleY;
      offsetX /= parent.dataset._scaleX;
    }
    offsetY += parent.offsetTop;
    offsetX += parent.offsetLeft;
    parent = parent.offsetParent;
    if (!parent) {
      return;
    }
  }
  if (spot) {
    if (spot.top !== undefined) {
      offsetY += spot.top;
    }
    if (spot.left !== undefined) {
      offsetX += spot.left;
      parent.scrollLeft = offsetX;
    }
  }
  parent.scrollTop = offsetY;
}
function watchScroll(viewAreaElement, callback) {
  let debounceScroll = function (evt) {
    if (rAF) {
      return;
    }
    rAF = window.requestAnimationFrame(function viewAreaElementScrolled() {
      rAF = null;
      let currentY = viewAreaElement.scrollTop;
      let lastY = state.lastY;
      if (currentY !== lastY) {
        state.down = currentY > lastY;
      }
      state.lastY = currentY;
      callback(state);
    });
  };
  let state = {
    down: true,
    lastY: viewAreaElement.scrollTop,
    _eventHandler: debounceScroll
  };
  let rAF = null;
  viewAreaElement.addEventListener('scroll', debounceScroll, true);
  return state;
}
function parseQueryString(query) {
  let parts = query.split('&');
  let params = Object.create(null);
  for (let i = 0, ii = parts.length; i < ii; ++i) {
    let param = parts[i].split('=');
    let key = param[0].toLowerCase();
    let value = param.length > 1 ? param[1] : null;
    params[decodeURIComponent(key)] = decodeURIComponent(value);
  }
  return params;
}
function binarySearchFirstItem(items, condition) {
  let minIndex = 0;
  let maxIndex = items.length - 1;
  if (items.length === 0 || !condition(items[maxIndex])) {
    return items.length;
  }
  if (condition(items[minIndex])) {
    return minIndex;
  }
  while (minIndex < maxIndex) {
    let currentIndex = minIndex + maxIndex >> 1;
    let currentItem = items[currentIndex];
    if (condition(currentItem)) {
      maxIndex = currentIndex;
    } else {
      minIndex = currentIndex + 1;
    }
  }
  return minIndex;
}
function approximateFraction(x) {
  if (Math.floor(x) === x) {
    return [x, 1];
  }
  let xinv = 1 / x;
  let limit = 8;
  if (xinv > limit) {
    return [1, limit];
  } else if (Math.floor(xinv) === xinv) {
    return [1, xinv];
  }
  let x_ = x > 1 ? xinv : x;
  let a = 0,
      b = 1,
      c = 1,
      d = 1;
  while (true) {
    let p = a + c,
        q = b + d;
    if (q > limit) {
      break;
    }
    if (x_ <= p / q) {
      c = p;
      d = q;
    } else {
      a = p;
      b = q;
    }
  }
  let result;
  if (x_ - a / b < c / d - x_) {
    result = x_ === x ? [a, b] : [b, a];
  } else {
    result = x_ === x ? [c, d] : [d, c];
  }
  return result;
}
function roundToDivide(x, div) {
  let r = x % div;
  return r === 0 ? x : Math.round(x - r + div);
}
function getVisibleElements(scrollEl, views, sortByVisibility = false) {
  let top = scrollEl.scrollTop,
      bottom = top + scrollEl.clientHeight;
  let left = scrollEl.scrollLeft,
      right = left + scrollEl.clientWidth;
  function isElementBottomBelowViewTop(view) {
    let element = view.div;
    let elementBottom = element.offsetTop + element.clientTop + element.clientHeight;
    return elementBottom > top;
  }
  let visible = [],
      view,
      element;
  let currentHeight, viewHeight, hiddenHeight, percentHeight;
  let currentWidth, viewWidth;
  let firstVisibleElementInd = views.length === 0 ? 0 : binarySearchFirstItem(views, isElementBottomBelowViewTop);
  for (let i = firstVisibleElementInd, ii = views.length; i < ii; i++) {
    view = views[i];
    element = view.div;
    currentHeight = element.offsetTop + element.clientTop;
    viewHeight = element.clientHeight;
    if (currentHeight > bottom) {
      break;
    }
    currentWidth = element.offsetLeft + element.clientLeft;
    viewWidth = element.clientWidth;
    if (currentWidth + viewWidth < left || currentWidth > right) {
      continue;
    }
    hiddenHeight = Math.max(0, top - currentHeight) + Math.max(0, currentHeight + viewHeight - bottom);
    percentHeight = (viewHeight - hiddenHeight) * 100 / viewHeight | 0;
    visible.push({
      id: view.id,
      x: currentWidth,
      y: currentHeight,
      view,
      percent: percentHeight
    });
  }
  let first = visible[0];
  let last = visible[visible.length - 1];
  if (sortByVisibility) {
    visible.sort(function (a, b) {
      let pc = a.percent - b.percent;
      if (Math.abs(pc) > 0.001) {
        return -pc;
      }
      return a.id - b.id;
    });
  }
  return {
    first,
    last,
    views: visible
  };
}
function noContextMenuHandler(evt) {
  evt.preventDefault();
}
function isDataSchema(url) {
  let i = 0,
      ii = url.length;
  while (i < ii && url[i].trim() === '') {
    i++;
  }
  return url.substr(i, 5).toLowerCase() === 'data:';
}
function getPDFFileNameFromURL(url, defaultFilename = 'document.pdf') {
  if (isDataSchema(url)) {
    console.warn('getPDFFileNameFromURL: ' + 'ignoring "data:" URL for performance reasons.');
    return defaultFilename;
  }
  const reURI = /^(?:(?:[^:]+:)?\/\/[^\/]+)?([^?#]*)(\?[^#]*)?(#.*)?$/;
  const reFilename = /[^\/?#=]+\.pdf\b(?!.*\.pdf\b)/i;
  let splitURI = reURI.exec(url);
  let suggestedFilename = reFilename.exec(splitURI[1]) || reFilename.exec(splitURI[2]) || reFilename.exec(splitURI[3]);
  if (suggestedFilename) {
    suggestedFilename = suggestedFilename[0];
    if (suggestedFilename.indexOf('%') !== -1) {
      try {
        suggestedFilename = reFilename.exec(decodeURIComponent(suggestedFilename))[0];
      } catch (ex) {}
    }
  }
  return suggestedFilename || defaultFilename;
}
function normalizeWheelEventDelta(evt) {
  let delta = Math.sqrt(evt.deltaX * evt.deltaX + evt.deltaY * evt.deltaY);
  let angle = Math.atan2(evt.deltaY, evt.deltaX);
  if (-0.25 * Math.PI < angle && angle < 0.75 * Math.PI) {
    delta = -delta;
  }
  const MOUSE_DOM_DELTA_PIXEL_MODE = 0;
  const MOUSE_DOM_DELTA_LINE_MODE = 1;
  const MOUSE_PIXELS_PER_LINE = 30;
  const MOUSE_LINES_PER_PAGE = 30;
  if (evt.deltaMode === MOUSE_DOM_DELTA_PIXEL_MODE) {
    delta /= MOUSE_PIXELS_PER_LINE * MOUSE_LINES_PER_PAGE;
  } else if (evt.deltaMode === MOUSE_DOM_DELTA_LINE_MODE) {
    delta /= MOUSE_LINES_PER_PAGE;
  }
  return delta;
}
function cloneObj(obj) {
  let result = Object.create(null);
  for (let i in obj) {
    if (Object.prototype.hasOwnProperty.call(obj, i)) {
      result[i] = obj[i];
    }
  }
  return result;
}
let animationStarted = new Promise(function (resolve) {
  window.requestAnimationFrame(resolve);
});
let mozL10n;
let localized = Promise.resolve();
class EventBus {
  constructor() {
    this._listeners = Object.create(null);
  }
  on(eventName, listener) {
    let eventListeners = this._listeners[eventName];
    if (!eventListeners) {
      eventListeners = [];
      this._listeners[eventName] = eventListeners;
    }
    eventListeners.push(listener);
  }
  off(eventName, listener) {
    let eventListeners = this._listeners[eventName];
    let i;
    if (!eventListeners || (i = eventListeners.indexOf(listener)) < 0) {
      return;
    }
    eventListeners.splice(i, 1);
  }
  dispatch(eventName) {
    let eventListeners = this._listeners[eventName];
    if (!eventListeners || eventListeners.length === 0) {
      return;
    }
    let args = Array.prototype.slice.call(arguments, 1);
    eventListeners.slice(0).forEach(function (listener) {
      listener.apply(null, args);
    });
  }
}
function clamp(v, min, max) {
  return Math.min(Math.max(v, min), max);
}
class ProgressBar {
  constructor(id, { height, width, units } = {}) {
    this.visible = true;
    this.div = document.querySelector(id + ' .progress');
    this.bar = this.div.parentNode;
    this.height = height || 100;
    this.width = width || 100;
    this.units = units || '%';
    this.div.style.height = this.height + this.units;
    this.percent = 0;
  }
  _updateBar() {
    if (this._indeterminate) {
      this.div.classList.add('indeterminate');
      this.div.style.width = this.width + this.units;
      return;
    }
    this.div.classList.remove('indeterminate');
    let progressSize = this.width * this._percent / 100;
    this.div.style.width = progressSize + this.units;
  }
  get percent() {
    return this._percent;
  }
  set percent(val) {
    this._indeterminate = isNaN(val);
    this._percent = clamp(val, 0, 100);
    this._updateBar();
  }
  setWidth(viewer) {
    if (!viewer) {
      return;
    }
    let container = viewer.parentNode;
    let scrollbarWidth = container.offsetWidth - viewer.offsetWidth;
    if (scrollbarWidth > 0) {
      this.bar.setAttribute('style', 'width: calc(100% - ' + scrollbarWidth + 'px);');
    }
  }
  hide() {
    if (!this.visible) {
      return;
    }
    this.visible = false;
    this.bar.classList.add('hidden');
    document.body.classList.remove('loadingInProgress');
  }
  show() {
    if (this.visible) {
      return;
    }
    this.visible = true;
    document.body.classList.add('loadingInProgress');
    this.bar.classList.remove('hidden');
  }
}
exports.CSS_UNITS = CSS_UNITS;
exports.DEFAULT_SCALE_VALUE = DEFAULT_SCALE_VALUE;
exports.DEFAULT_SCALE = DEFAULT_SCALE;
exports.MIN_SCALE = MIN_SCALE;
exports.MAX_SCALE = MAX_SCALE;
exports.UNKNOWN_SCALE = UNKNOWN_SCALE;
exports.MAX_AUTO_SCALE = MAX_AUTO_SCALE;
exports.SCROLLBAR_PADDING = SCROLLBAR_PADDING;
exports.VERTICAL_PADDING = VERTICAL_PADDING;
exports.cloneObj = cloneObj;
exports.RendererType = RendererType;
exports.mozL10n = mozL10n;
exports.NullL10n = NullL10n;
exports.EventBus = EventBus;
exports.ProgressBar = ProgressBar;
exports.getPDFFileNameFromURL = getPDFFileNameFromURL;
exports.noContextMenuHandler = noContextMenuHandler;
exports.parseQueryString = parseQueryString;
exports.getVisibleElements = getVisibleElements;
exports.roundToDivide = roundToDivide;
exports.approximateFraction = approximateFraction;
exports.getOutputScale = getOutputScale;
exports.scrollIntoView = scrollIntoView;
exports.watchScroll = watchScroll;
exports.binarySearchFirstItem = binarySearchFirstItem;
exports.normalizeWheelEventDelta = normalizeWheelEventDelta;
exports.animationStarted = animationStarted;
exports.localized = localized;

/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var pdfjsLib;
if (typeof window !== 'undefined' && window['pdfjs-dist/build/pdf']) {
  pdfjsLib = window['pdfjs-dist/build/pdf'];
} else {
  pdfjsLib = require('../build/pdf.js');
}
module.exports = pdfjsLib;

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getGlobalEventBus = exports.attachDOMEventsToEventBus = undefined;

var _ui_utils = __webpack_require__(0);

function attachDOMEventsToEventBus(eventBus) {
  eventBus.on('documentload', function () {
    let event = document.createEvent('CustomEvent');
    event.initCustomEvent('documentload', true, true, {});
    window.dispatchEvent(event);
  });
  eventBus.on('pagerendered', function (evt) {
    let event = document.createEvent('CustomEvent');
    event.initCustomEvent('pagerendered', true, true, {
      pageNumber: evt.pageNumber,
      cssTransform: evt.cssTransform
    });
    evt.source.div.dispatchEvent(event);
  });
  eventBus.on('textlayerrendered', function (evt) {
    let event = document.createEvent('CustomEvent');
    event.initCustomEvent('textlayerrendered', true, true, { pageNumber: evt.pageNumber });
    evt.source.textLayerDiv.dispatchEvent(event);
  });
  eventBus.on('pagechange', function (evt) {
    let event = document.createEvent('UIEvents');
    event.initUIEvent('pagechange', true, true, window, 0);
    event.pageNumber = evt.pageNumber;
    evt.source.container.dispatchEvent(event);
  });
  eventBus.on('pagesinit', function (evt) {
    let event = document.createEvent('CustomEvent');
    event.initCustomEvent('pagesinit', true, true, null);
    evt.source.container.dispatchEvent(event);
  });
  eventBus.on('pagesloaded', function (evt) {
    let event = document.createEvent('CustomEvent');
    event.initCustomEvent('pagesloaded', true, true, { pagesCount: evt.pagesCount });
    evt.source.container.dispatchEvent(event);
  });
  eventBus.on('scalechange', function (evt) {
    let event = document.createEvent('UIEvents');
    event.initUIEvent('scalechange', true, true, window, 0);
    event.scale = evt.scale;
    event.presetValue = evt.presetValue;
    evt.source.container.dispatchEvent(event);
  });
  eventBus.on('updateviewarea', function (evt) {
    let event = document.createEvent('UIEvents');
    event.initUIEvent('updateviewarea', true, true, window, 0);
    event.location = evt.location;
    evt.source.container.dispatchEvent(event);
  });
  eventBus.on('find', function (evt) {
    if (evt.source === window) {
      return;
    }
    let event = document.createEvent('CustomEvent');
    event.initCustomEvent('find' + evt.type, true, true, {
      query: evt.query,
      phraseSearch: evt.phraseSearch,
      caseSensitive: evt.caseSensitive,
      highlightAll: evt.highlightAll,
      findPrevious: evt.findPrevious
    });
    window.dispatchEvent(event);
  });
  eventBus.on('attachmentsloaded', function (evt) {
    let event = document.createEvent('CustomEvent');
    event.initCustomEvent('attachmentsloaded', true, true, { attachmentsCount: evt.attachmentsCount });
    evt.source.container.dispatchEvent(event);
  });
  eventBus.on('sidebarviewchanged', function (evt) {
    let event = document.createEvent('CustomEvent');
    event.initCustomEvent('sidebarviewchanged', true, true, { view: evt.view });
    evt.source.outerContainer.dispatchEvent(event);
  });
  eventBus.on('pagemode', function (evt) {
    let event = document.createEvent('CustomEvent');
    event.initCustomEvent('pagemode', true, true, { mode: evt.mode });
    evt.source.pdfViewer.container.dispatchEvent(event);
  });
  eventBus.on('namedaction', function (evt) {
    let event = document.createEvent('CustomEvent');
    event.initCustomEvent('namedaction', true, true, { action: evt.action });
    evt.source.pdfViewer.container.dispatchEvent(event);
  });
  eventBus.on('presentationmodechanged', function (evt) {
    let event = document.createEvent('CustomEvent');
    event.initCustomEvent('presentationmodechanged', true, true, {
      active: evt.active,
      switchInProgress: evt.switchInProgress
    });
    window.dispatchEvent(event);
  });
  eventBus.on('outlineloaded', function (evt) {
    let event = document.createEvent('CustomEvent');
    event.initCustomEvent('outlineloaded', true, true, { outlineCount: evt.outlineCount });
    evt.source.container.dispatchEvent(event);
  });
}
let globalEventBus = null;
function getGlobalEventBus() {
  if (globalEventBus) {
    return globalEventBus;
  }
  globalEventBus = new _ui_utils.EventBus();
  attachDOMEventsToEventBus(globalEventBus);
  return globalEventBus;
}
exports.attachDOMEventsToEventBus = attachDOMEventsToEventBus;
exports.getGlobalEventBus = getGlobalEventBus;

/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
const CLEANUP_TIMEOUT = 30000;
const RenderingStates = {
  INITIAL: 0,
  RUNNING: 1,
  PAUSED: 2,
  FINISHED: 3
};
class PDFRenderingQueue {
  constructor() {
    this.pdfViewer = null;
    this.pdfThumbnailViewer = null;
    this.onIdle = null;
    this.highestPriorityPage = null;
    this.idleTimeout = null;
    this.printing = false;
    this.isThumbnailViewEnabled = false;
  }
  setViewer(pdfViewer) {
    this.pdfViewer = pdfViewer;
  }
  setThumbnailViewer(pdfThumbnailViewer) {
    this.pdfThumbnailViewer = pdfThumbnailViewer;
  }
  isHighestPriority(view) {
    return this.highestPriorityPage === view.renderingId;
  }
  renderHighestPriority(currentlyVisiblePages) {
    if (this.idleTimeout) {
      clearTimeout(this.idleTimeout);
      this.idleTimeout = null;
    }
    if (this.pdfViewer.forceRendering(currentlyVisiblePages)) {
      return;
    }
    if (this.pdfThumbnailViewer && this.isThumbnailViewEnabled) {
      if (this.pdfThumbnailViewer.forceRendering()) {
        return;
      }
    }
    if (this.printing) {
      return;
    }
    if (this.onIdle) {
      this.idleTimeout = setTimeout(this.onIdle.bind(this), CLEANUP_TIMEOUT);
    }
  }
  getHighestPriority(visible, views, scrolledDown) {
    var visibleViews = visible.views;
    var numVisible = visibleViews.length;
    if (numVisible === 0) {
      return false;
    }
    for (var i = 0; i < numVisible; ++i) {
      var view = visibleViews[i].view;
      if (!this.isViewFinished(view)) {
        return view;
      }
    }
    if (scrolledDown) {
      var nextPageIndex = visible.last.id;
      if (views[nextPageIndex] && !this.isViewFinished(views[nextPageIndex])) {
        return views[nextPageIndex];
      }
    } else {
      var previousPageIndex = visible.first.id - 2;
      if (views[previousPageIndex] && !this.isViewFinished(views[previousPageIndex])) {
        return views[previousPageIndex];
      }
    }
    return null;
  }
  isViewFinished(view) {
    return view.renderingState === RenderingStates.FINISHED;
  }
  renderView(view) {
    switch (view.renderingState) {
      case RenderingStates.FINISHED:
        return false;
      case RenderingStates.PAUSED:
        this.highestPriorityPage = view.renderingId;
        view.resume();
        break;
      case RenderingStates.RUNNING:
        this.highestPriorityPage = view.renderingId;
        break;
      case RenderingStates.INITIAL:
        this.highestPriorityPage = view.renderingId;
        var continueRendering = () => {
          this.renderHighestPriority();
        };
        view.draw().then(continueRendering, continueRendering);
        break;
    }
    return true;
  }
}
exports.RenderingStates = RenderingStates;
exports.PDFRenderingQueue = PDFRenderingQueue;

/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFPrintServiceFactory = exports.DefaultExternalServices = exports.PDFViewerApplication = undefined;

var _ui_utils = __webpack_require__(0);

var _pdfjsLib = __webpack_require__(1);

var _pdf_cursor_tools = __webpack_require__(6);

var _pdf_rendering_queue = __webpack_require__(3);

var _pdf_sidebar = __webpack_require__(22);

var _pdf_viewer = __webpack_require__(25);

var _dom_events = __webpack_require__(2);

var _overlay_manager = __webpack_require__(13);

var _password_prompt = __webpack_require__(14);

var _pdf_attachment_viewer = __webpack_require__(15);

var _pdf_document_properties = __webpack_require__(16);

var _pdf_find_bar = __webpack_require__(17);

var _pdf_find_controller = __webpack_require__(7);

var _pdf_history = __webpack_require__(18);

var _pdf_link_service = __webpack_require__(5);

var _pdf_outline_viewer = __webpack_require__(19);

var _pdf_presentation_mode = __webpack_require__(21);

var _pdf_thumbnail_viewer = __webpack_require__(24);

var _secondary_toolbar = __webpack_require__(27);

var _toolbar = __webpack_require__(29);

var _view_history = __webpack_require__(30);

const DEFAULT_SCALE_DELTA = 1.1;
const DISABLE_AUTO_FETCH_LOADING_BAR_TIMEOUT = 5000;
function configure(PDFJS) {
  PDFJS.imageResourcesPath = './images/';
  PDFJS.workerSrc = '../build/pdf.worker.js';
  PDFJS.cMapUrl = '../web/cmaps/';
  PDFJS.cMapPacked = true;
}
const DefaultExternalServices = {
  updateFindControlState(data) {},
  initPassiveLoading(callbacks) {},
  fallback(data, callback) {},
  reportTelemetry(data) {},
  createDownloadManager() {
    throw new Error('Not implemented: createDownloadManager');
  },
  createPreferences() {
    throw new Error('Not implemented: createPreferences');
  },
  createL10n() {
    throw new Error('Not implemented: createL10n');
  },
  supportsIntegratedFind: false,
  supportsDocumentFonts: true,
  supportsDocumentColors: true,
  supportedMouseWheelZoomModifierKeys: {
    ctrlKey: true,
    metaKey: true
  }
};
let PDFViewerApplication = {
  initialBookmark: document.location.hash.substring(1),
  initialDestination: null,
  initialized: false,
  fellback: false,
  appConfig: null,
  pdfDocument: null,
  pdfLoadingTask: null,
  printService: null,
  pdfViewer: null,
  pdfThumbnailViewer: null,
  pdfRenderingQueue: null,
  pdfPresentationMode: null,
  pdfDocumentProperties: null,
  pdfLinkService: null,
  pdfHistory: null,
  pdfSidebar: null,
  pdfOutlineViewer: null,
  pdfAttachmentViewer: null,
  pdfCursorTools: null,
  store: null,
  downloadManager: null,
  overlayManager: null,
  preferences: null,
  toolbar: null,
  secondaryToolbar: null,
  eventBus: null,
  l10n: null,
  isInitialViewSet: false,
  downloadComplete: false,
  viewerPrefs: {
    sidebarViewOnLoad: _pdf_sidebar.SidebarView.NONE,
    pdfBugEnabled: false,
    showPreviousViewOnLoad: true,
    defaultZoomValue: '',
    disablePageMode: false,
    disablePageLabels: false,
    renderer: 'canvas',
    enhanceTextSelection: false,
    renderInteractiveForms: false,
    enablePrintAutoRotate: false
  },
  isViewerEmbedded: window.parent !== window,
  url: '',
  baseUrl: '',
  externalServices: DefaultExternalServices,
  _boundEvents: {},
  initialize(appConfig) {
    this.preferences = this.externalServices.createPreferences();
    configure(_pdfjsLib.PDFJS);
    this.appConfig = appConfig;
    return this._readPreferences().then(() => {
      return this._initializeL10n();
    }).then(() => {
      return this._initializeViewerComponents();
    }).then(() => {
      this.bindEvents();
      this.bindWindowEvents();
      let appContainer = appConfig.appContainer || document.documentElement;
      this.l10n.translate(appContainer).then(() => {
        this.eventBus.dispatch('localized');
      });
      if (this.isViewerEmbedded && !_pdfjsLib.PDFJS.isExternalLinkTargetSet()) {
        _pdfjsLib.PDFJS.externalLinkTarget = _pdfjsLib.PDFJS.LinkTarget.TOP;
      }
      this.initialized = true;
    });
  },
  _readPreferences() {
    let { preferences, viewerPrefs } = this;
    return Promise.all([preferences.get('enableWebGL').then(function resolved(value) {
      _pdfjsLib.PDFJS.disableWebGL = !value;
    }), preferences.get('sidebarViewOnLoad').then(function resolved(value) {
      viewerPrefs['sidebarViewOnLoad'] = value;
    }), preferences.get('pdfBugEnabled').then(function resolved(value) {
      viewerPrefs['pdfBugEnabled'] = value;
    }), preferences.get('showPreviousViewOnLoad').then(function resolved(value) {
      viewerPrefs['showPreviousViewOnLoad'] = value;
    }), preferences.get('defaultZoomValue').then(function resolved(value) {
      viewerPrefs['defaultZoomValue'] = value;
    }), preferences.get('enhanceTextSelection').then(function resolved(value) {
      viewerPrefs['enhanceTextSelection'] = value;
    }), preferences.get('disableTextLayer').then(function resolved(value) {
      if (_pdfjsLib.PDFJS.disableTextLayer === true) {
        return;
      }
      _pdfjsLib.PDFJS.disableTextLayer = value;
    }), preferences.get('disableRange').then(function resolved(value) {
      if (_pdfjsLib.PDFJS.disableRange === true) {
        return;
      }
      _pdfjsLib.PDFJS.disableRange = value;
    }), preferences.get('disableStream').then(function resolved(value) {
      if (_pdfjsLib.PDFJS.disableStream === true) {
        return;
      }
      _pdfjsLib.PDFJS.disableStream = value;
    }), preferences.get('disableAutoFetch').then(function resolved(value) {
      _pdfjsLib.PDFJS.disableAutoFetch = value;
    }), preferences.get('disableFontFace').then(function resolved(value) {
      if (_pdfjsLib.PDFJS.disableFontFace === true) {
        return;
      }
      _pdfjsLib.PDFJS.disableFontFace = value;
    }), preferences.get('useOnlyCssZoom').then(function resolved(value) {
      _pdfjsLib.PDFJS.useOnlyCssZoom = value;
    }), preferences.get('externalLinkTarget').then(function resolved(value) {
      if (_pdfjsLib.PDFJS.isExternalLinkTargetSet()) {
        return;
      }
      _pdfjsLib.PDFJS.externalLinkTarget = value;
    }), preferences.get('renderer').then(function resolved(value) {
      viewerPrefs['renderer'] = value;
    }), preferences.get('renderInteractiveForms').then(function resolved(value) {
      viewerPrefs['renderInteractiveForms'] = value;
    }), preferences.get('disablePageMode').then(function resolved(value) {
      viewerPrefs['disablePageMode'] = value;
    }), preferences.get('disablePageLabels').then(function resolved(value) {
      viewerPrefs['disablePageLabels'] = value;
    }), preferences.get('enablePrintAutoRotate').then(function resolved(value) {
      viewerPrefs['enablePrintAutoRotate'] = value;
    })]).catch(function (reason) {});
  },
  _initializeL10n() {
    this.l10n = this.externalServices.createL10n();
    return this.l10n.getDirection().then(dir => {
      document.getElementsByTagName('html')[0].dir = dir;
    });
  },
  _initializeViewerComponents() {
    let appConfig = this.appConfig;
    return new Promise((resolve, reject) => {
      this.overlayManager = new _overlay_manager.OverlayManager();
      let eventBus = appConfig.eventBus || (0, _dom_events.getGlobalEventBus)();
      this.eventBus = eventBus;
      let pdfRenderingQueue = new _pdf_rendering_queue.PDFRenderingQueue();
      pdfRenderingQueue.onIdle = this.cleanup.bind(this);
      this.pdfRenderingQueue = pdfRenderingQueue;
      let pdfLinkService = new _pdf_link_service.PDFLinkService({ eventBus });
      this.pdfLinkService = pdfLinkService;
      let downloadManager = this.externalServices.createDownloadManager();
      this.downloadManager = downloadManager;
      let container = appConfig.mainContainer;
      let viewer = appConfig.viewerContainer;
      this.pdfViewer = new _pdf_viewer.PDFViewer({
        container,
        viewer,
        eventBus,
        renderingQueue: pdfRenderingQueue,
        linkService: pdfLinkService,
        downloadManager,
        renderer: this.viewerPrefs['renderer'],
        l10n: this.l10n,
        enhanceTextSelection: this.viewerPrefs['enhanceTextSelection'],
        renderInteractiveForms: this.viewerPrefs['renderInteractiveForms'],
        enablePrintAutoRotate: this.viewerPrefs['enablePrintAutoRotate']
      });
      pdfRenderingQueue.setViewer(this.pdfViewer);
      pdfLinkService.setViewer(this.pdfViewer);
      let thumbnailContainer = appConfig.sidebar.thumbnailView;
      this.pdfThumbnailViewer = new _pdf_thumbnail_viewer.PDFThumbnailViewer({
        container: thumbnailContainer,
        renderingQueue: pdfRenderingQueue,
        linkService: pdfLinkService,
        l10n: this.l10n
      });
      pdfRenderingQueue.setThumbnailViewer(this.pdfThumbnailViewer);
      this.pdfHistory = new _pdf_history.PDFHistory({
        linkService: pdfLinkService,
        eventBus
      });
      pdfLinkService.setHistory(this.pdfHistory);
      this.findController = new _pdf_find_controller.PDFFindController({ pdfViewer: this.pdfViewer });
      this.findController.onUpdateResultsCount = matchCount => {
        if (this.supportsIntegratedFind) {
          return;
        }
        this.findBar.updateResultsCount(matchCount);
      };
      this.findController.onUpdateState = (state, previous, matchCount) => {
        if (this.supportsIntegratedFind) {
          this.externalServices.updateFindControlState({
            result: state,
            findPrevious: previous
          });
        } else {
          this.findBar.updateUIState(state, previous, matchCount);
        }
      };
      this.pdfViewer.setFindController(this.findController);
      let findBarConfig = Object.create(appConfig.findBar);
      findBarConfig.findController = this.findController;
      findBarConfig.eventBus = eventBus;
      this.findBar = new _pdf_find_bar.PDFFindBar(findBarConfig, this.l10n);
      this.pdfDocumentProperties = new _pdf_document_properties.PDFDocumentProperties(appConfig.documentProperties, this.overlayManager, this.l10n);
      this.pdfCursorTools = new _pdf_cursor_tools.PDFCursorTools({
        container,
        eventBus,
        preferences: this.preferences
      });
      this.toolbar = new _toolbar.Toolbar(appConfig.toolbar, container, eventBus, this.l10n);
      this.secondaryToolbar = new _secondary_toolbar.SecondaryToolbar(appConfig.secondaryToolbar, container, eventBus);
      if (this.supportsFullscreen) {
        this.pdfPresentationMode = new _pdf_presentation_mode.PDFPresentationMode({
          container,
          viewer,
          pdfViewer: this.pdfViewer,
          eventBus,
          contextMenuItems: appConfig.fullscreen
        });
      }
      this.passwordPrompt = new _password_prompt.PasswordPrompt(appConfig.passwordOverlay, this.overlayManager, this.l10n);
      this.pdfOutlineViewer = new _pdf_outline_viewer.PDFOutlineViewer({
        container: appConfig.sidebar.outlineView,
        eventBus,
        linkService: pdfLinkService
      });
      this.pdfAttachmentViewer = new _pdf_attachment_viewer.PDFAttachmentViewer({
        container: appConfig.sidebar.attachmentsView,
        eventBus,
        downloadManager
      });
      let sidebarConfig = Object.create(appConfig.sidebar);
      sidebarConfig.pdfViewer = this.pdfViewer;
      sidebarConfig.pdfThumbnailViewer = this.pdfThumbnailViewer;
      sidebarConfig.pdfOutlineViewer = this.pdfOutlineViewer;
      sidebarConfig.eventBus = eventBus;
      this.pdfSidebar = new _pdf_sidebar.PDFSidebar(sidebarConfig, this.l10n);
      this.pdfSidebar.onToggled = this.forceRendering.bind(this);
      resolve(undefined);
    });
  },
  run(config) {
    this.initialize(config).then(webViewerInitialized);
  },
  zoomIn(ticks) {
    let newScale = this.pdfViewer.currentScale;
    do {
      newScale = (newScale * DEFAULT_SCALE_DELTA).toFixed(2);
      newScale = Math.ceil(newScale * 10) / 10;
      newScale = Math.min(_ui_utils.MAX_SCALE, newScale);
    } while (--ticks > 0 && newScale < _ui_utils.MAX_SCALE);
    this.pdfViewer.currentScaleValue = newScale;
  },
  zoomOut(ticks) {
    let newScale = this.pdfViewer.currentScale;
    do {
      newScale = (newScale / DEFAULT_SCALE_DELTA).toFixed(2);
      newScale = Math.floor(newScale * 10) / 10;
      newScale = Math.max(_ui_utils.MIN_SCALE, newScale);
    } while (--ticks > 0 && newScale > _ui_utils.MIN_SCALE);
    this.pdfViewer.currentScaleValue = newScale;
  },
  get pagesCount() {
    return this.pdfDocument ? this.pdfDocument.numPages : 0;
  },
  get pageRotation() {
    return this.pdfViewer.pagesRotation;
  },
  set page(val) {
    this.pdfViewer.currentPageNumber = val;
  },
  get page() {
    return this.pdfViewer.currentPageNumber;
  },
  get printing() {
    return !!this.printService;
  },
  get supportsPrinting() {
    return PDFPrintServiceFactory.instance.supportsPrinting;
  },
  get supportsFullscreen() {
    let support;
    support = document.fullscreenEnabled === true || document.mozFullScreenEnabled === true;
    if (support && _pdfjsLib.PDFJS.disableFullscreen === true) {
      support = false;
    }
    return (0, _pdfjsLib.shadow)(this, 'supportsFullscreen', support);
  },
  get supportsIntegratedFind() {
    return this.externalServices.supportsIntegratedFind;
  },
  get supportsDocumentFonts() {
    return this.externalServices.supportsDocumentFonts;
  },
  get supportsDocumentColors() {
    return this.externalServices.supportsDocumentColors;
  },
  get loadingBar() {
    let bar = new _ui_utils.ProgressBar('#loadingBar');
    return (0, _pdfjsLib.shadow)(this, 'loadingBar', bar);
  },
  get supportedMouseWheelZoomModifierKeys() {
    return this.externalServices.supportedMouseWheelZoomModifierKeys;
  },
  initPassiveLoading() {
    this.externalServices.initPassiveLoading({
      onOpenWithTransport(url, length, transport) {
        PDFViewerApplication.open(url, { range: transport });
        if (length) {
          PDFViewerApplication.pdfDocumentProperties.setFileSize(length);
        }
      },
      onOpenWithData(data) {
        PDFViewerApplication.open(data);
      },
      onOpenWithURL(url, length, originalURL) {
        let file = url,
            args = null;
        if (length !== undefined) {
          args = { length };
        }
        if (originalURL !== undefined) {
          file = {
            file: url,
            originalURL
          };
        }
        PDFViewerApplication.open(file, args);
      },
      onError(err) {
        PDFViewerApplication.l10n.get('loading_error', null, 'An error occurred while loading the PDF.').then(msg => {
          PDFViewerApplication.error(msg, err);
        });
      },
      onProgress(loaded, total) {
        PDFViewerApplication.progress(loaded / total);
      }
    });
  },
  setTitleUsingUrl(url) {
    this.url = url;
    this.baseUrl = url.split('#')[0];
    let title = (0, _ui_utils.getPDFFileNameFromURL)(url, '');
    if (!title) {
      try {
        title = decodeURIComponent((0, _pdfjsLib.getFilenameFromUrl)(url)) || url;
      } catch (ex) {
        title = url;
      }
    }
    this.setTitle(title);
  },
  setTitle(title) {
    if (this.isViewerEmbedded) {
      return;
    }
    document.title = title;
  },
  close() {
    let errorWrapper = this.appConfig.errorWrapper.container;
    errorWrapper.setAttribute('hidden', 'true');
    if (!this.pdfLoadingTask) {
      return Promise.resolve();
    }
    let promise = this.pdfLoadingTask.destroy();
    this.pdfLoadingTask = null;
    if (this.pdfDocument) {
      this.pdfDocument = null;
      this.pdfThumbnailViewer.setDocument(null);
      this.pdfViewer.setDocument(null);
      this.pdfLinkService.setDocument(null, null);
      this.pdfDocumentProperties.setDocument(null, null);
    }
    this.store = null;
    this.isInitialViewSet = false;
    this.downloadComplete = false;
    this.pdfSidebar.reset();
    this.pdfOutlineViewer.reset();
    this.pdfAttachmentViewer.reset();
    this.findController.reset();
    this.findBar.reset();
    this.toolbar.reset();
    this.secondaryToolbar.reset();
    if (typeof PDFBug !== 'undefined') {
      PDFBug.cleanup();
    }
    return promise;
  },
  open(file, args) {
    if (this.pdfLoadingTask) {
      return this.close().then(() => {
        this.preferences.reload();
        return this.open(file, args);
      });
    }
    let parameters = Object.create(null),
        scale;
    if (typeof file === 'string') {
      this.setTitleUsingUrl(file);
      parameters.url = file;
    } else if (file && 'byteLength' in file) {
      parameters.data = file;
    } else if (file.url && file.originalUrl) {
      this.setTitleUsingUrl(file.originalUrl);
      parameters.url = file.url;
    }
    parameters.docBaseUrl = this.baseUrl;
    if (args) {
      for (let prop in args) {
        parameters[prop] = args[prop];
      }
      if (args.scale) {
        scale = args.scale;
      }
      if (args.length) {
        this.pdfDocumentProperties.setFileSize(args.length);
      }
    }
    let loadingTask = (0, _pdfjsLib.getDocument)(parameters);
    this.pdfLoadingTask = loadingTask;
    loadingTask.onPassword = (updateCallback, reason) => {
      this.passwordPrompt.setUpdateCallback(updateCallback, reason);
      this.passwordPrompt.open();
    };
    loadingTask.onProgress = ({ loaded, total }) => {
      this.progress(loaded / total);
    };
    loadingTask.onUnsupportedFeature = this.fallback.bind(this);
    return loadingTask.promise.then(pdfDocument => {
      this.load(pdfDocument, scale);
    }, exception => {
      let message = exception && exception.message;
      let loadingErrorMessage;
      if (exception instanceof _pdfjsLib.InvalidPDFException) {
        loadingErrorMessage = this.l10n.get('invalid_file_error', null, 'Invalid or corrupted PDF file.');
      } else if (exception instanceof _pdfjsLib.MissingPDFException) {
        loadingErrorMessage = this.l10n.get('missing_file_error', null, 'Missing PDF file.');
      } else if (exception instanceof _pdfjsLib.UnexpectedResponseException) {
        loadingErrorMessage = this.l10n.get('unexpected_response_error', null, 'Unexpected server response.');
      } else {
        loadingErrorMessage = this.l10n.get('loading_error', null, 'An error occurred while loading the PDF.');
      }
      return loadingErrorMessage.then(msg => {
        this.error(msg, { message });
        throw new Error(msg);
      });
    });
  },
  download() {
    function downloadByUrl() {
      downloadManager.downloadUrl(url, filename);
    }
    let url = this.baseUrl;
    let filename = (0, _ui_utils.getPDFFileNameFromURL)(this.url);
    let downloadManager = this.downloadManager;
    downloadManager.onerror = err => {
      this.error(`PDF failed to download: ${err}`);
    };
    if (!this.pdfDocument || !this.downloadComplete) {
      downloadByUrl();
      return;
    }
    this.pdfDocument.getData().then(function (data) {
      let blob = (0, _pdfjsLib.createBlob)(data, 'application/pdf');
      downloadManager.download(blob, url, filename);
    }).catch(downloadByUrl);
  },
  fallback(featureId) {
    if (this.fellback) {
      return;
    }
    this.fellback = true;
    this.externalServices.fallback({
      featureId,
      url: this.baseUrl
    }, function response(download) {
      if (!download) {
        return;
      }
      PDFViewerApplication.download();
    });
  },
  error(message, moreInfo) {
    let moreInfoText = [this.l10n.get('error_version_info', {
      version: _pdfjsLib.version || '?',
      build: _pdfjsLib.build || '?'
    }, 'PDF.js v{{version}} (build: {{build}})')];
    if (moreInfo) {
      moreInfoText.push(this.l10n.get('error_message', { message: moreInfo.message }, 'Message: {{message}}'));
      if (moreInfo.stack) {
        moreInfoText.push(this.l10n.get('error_stack', { stack: moreInfo.stack }, 'Stack: {{stack}}'));
      } else {
        if (moreInfo.filename) {
          moreInfoText.push(this.l10n.get('error_file', { file: moreInfo.filename }, 'File: {{file}}'));
        }
        if (moreInfo.lineNumber) {
          moreInfoText.push(this.l10n.get('error_line', { line: moreInfo.lineNumber }, 'Line: {{line}}'));
        }
      }
    }
    console.error(message + '\n' + moreInfoText);
    this.fallback();
  },
  progress(level) {
    if (this.downloadComplete) {
      return;
    }
    let percent = Math.round(level * 100);
    if (percent > this.loadingBar.percent || isNaN(percent)) {
      this.loadingBar.percent = percent;
      if (_pdfjsLib.PDFJS.disableAutoFetch && percent) {
        if (this.disableAutoFetchLoadingBarTimeout) {
          clearTimeout(this.disableAutoFetchLoadingBarTimeout);
          this.disableAutoFetchLoadingBarTimeout = null;
        }
        this.loadingBar.show();
        this.disableAutoFetchLoadingBarTimeout = setTimeout(() => {
          this.loadingBar.hide();
          this.disableAutoFetchLoadingBarTimeout = null;
        }, DISABLE_AUTO_FETCH_LOADING_BAR_TIMEOUT);
      }
    }
  },
  load(pdfDocument, scale) {
    scale = scale || _ui_utils.UNKNOWN_SCALE;
    this.pdfDocument = pdfDocument;
    pdfDocument.getDownloadInfo().then(() => {
      this.downloadComplete = true;
      this.loadingBar.hide();
      firstPagePromise.then(() => {
        this.eventBus.dispatch('documentload', { source: this });
      });
    });
    let pageModePromise = pdfDocument.getPageMode().catch(function () {});
    this.toolbar.setPagesCount(pdfDocument.numPages, false);
    this.secondaryToolbar.setPagesCount(pdfDocument.numPages);
    let id = this.documentFingerprint = pdfDocument.fingerprint;
    let store = this.store = new _view_history.ViewHistory(id);
    let baseDocumentUrl;
    baseDocumentUrl = this.baseUrl;
    this.pdfLinkService.setDocument(pdfDocument, baseDocumentUrl);
    this.pdfDocumentProperties.setDocument(pdfDocument, this.url);
    let pdfViewer = this.pdfViewer;
    pdfViewer.setDocument(pdfDocument);
    let firstPagePromise = pdfViewer.firstPagePromise;
    let pagesPromise = pdfViewer.pagesPromise;
    let onePageRendered = pdfViewer.onePageRendered;
    let pdfThumbnailViewer = this.pdfThumbnailViewer;
    pdfThumbnailViewer.setDocument(pdfDocument);
    firstPagePromise.then(pdfPage => {
      this.loadingBar.setWidth(this.appConfig.viewerContainer);
      if (!_pdfjsLib.PDFJS.disableHistory && !this.isViewerEmbedded) {
        if (!this.viewerPrefs['showPreviousViewOnLoad']) {
          this.pdfHistory.clearHistoryState();
        }
        this.pdfHistory.initialize(this.documentFingerprint);
        if (this.pdfHistory.initialDestination) {
          this.initialDestination = this.pdfHistory.initialDestination;
        } else if (this.pdfHistory.initialBookmark) {
          this.initialBookmark = this.pdfHistory.initialBookmark;
        }
      }
      let initialParams = {
        destination: this.initialDestination,
        bookmark: this.initialBookmark,
        hash: null
      };
      let storePromise = store.getMultiple({
        exists: false,
        page: '1',
        zoom: _ui_utils.DEFAULT_SCALE_VALUE,
        scrollLeft: '0',
        scrollTop: '0',
        sidebarView: _pdf_sidebar.SidebarView.NONE
      }).catch(() => {});
      Promise.all([storePromise, pageModePromise]).then(([values = {}, pageMode]) => {
        let hash = this.viewerPrefs['defaultZoomValue'] ? 'zoom=' + this.viewerPrefs['defaultZoomValue'] : null;
        let sidebarView = this.viewerPrefs['sidebarViewOnLoad'];
        if (values.exists && this.viewerPrefs['showPreviousViewOnLoad']) {
          hash = 'page=' + values.page + '&zoom=' + (this.viewerPrefs['defaultZoomValue'] || values.zoom) + ',' + values.scrollLeft + ',' + values.scrollTop;
          sidebarView = sidebarView || values.sidebarView | 0;
        }
        if (pageMode && !this.viewerPrefs['disablePageMode']) {
          sidebarView = sidebarView || apiPageModeToSidebarView(pageMode);
        }
        return {
          hash,
          sidebarView
        };
      }).then(({ hash, sidebarView }) => {
        this.setInitialView(hash, {
          sidebarView,
          scale
        });
        initialParams.hash = hash;
        if (!this.isViewerEmbedded) {
          pdfViewer.focus();
        }
        return pagesPromise;
      }).then(() => {
        if (!initialParams.destination && !initialParams.bookmark && !initialParams.hash) {
          return;
        }
        if (pdfViewer.hasEqualPageSizes) {
          return;
        }
        this.initialDestination = initialParams.destination;
        this.initialBookmark = initialParams.bookmark;
        pdfViewer.currentScaleValue = pdfViewer.currentScaleValue;
        this.setInitialView(initialParams.hash);
      }).then(function () {
        pdfViewer.update();
      });
    });
    pdfDocument.getPageLabels().then(labels => {
      if (!labels || this.viewerPrefs['disablePageLabels']) {
        return;
      }
      let i = 0,
          numLabels = labels.length;
      if (numLabels !== this.pagesCount) {
        console.error('The number of Page Labels does not match ' + 'the number of pages in the document.');
        return;
      }
      while (i < numLabels && labels[i] === (i + 1).toString()) {
        i++;
      }
      if (i === numLabels) {
        return;
      }
      pdfViewer.setPageLabels(labels);
      pdfThumbnailViewer.setPageLabels(labels);
      this.toolbar.setPagesCount(pdfDocument.numPages, true);
      this.toolbar.setPageNumber(pdfViewer.currentPageNumber, pdfViewer.currentPageLabel);
    });
    pagesPromise.then(() => {
      if (!this.supportsPrinting) {
        return;
      }
      pdfDocument.getJavaScript().then(javaScript => {
        if (javaScript.length) {
          console.warn('Warning: JavaScript is not supported');
          this.fallback(_pdfjsLib.UNSUPPORTED_FEATURES.javaScript);
        }
        let regex = /\bprint\s*\(/;
        for (let i = 0, ii = javaScript.length; i < ii; i++) {
          let js = javaScript[i];
          if (js && regex.test(js)) {
            setTimeout(function () {
              window.print();
            });
            return;
          }
        }
      });
    });
    Promise.all([onePageRendered, _ui_utils.animationStarted]).then(() => {
      pdfDocument.getOutline().then(outline => {
        this.pdfOutlineViewer.render({ outline });
      });
      pdfDocument.getAttachments().then(attachments => {
        this.pdfAttachmentViewer.render({ attachments });
      });
    });
    pdfDocument.getMetadata().then(({ info, metadata }) => {
      this.documentInfo = info;
      this.metadata = metadata;
      console.log('PDF ' + pdfDocument.fingerprint + ' [' + info.PDFFormatVersion + ' ' + (info.Producer || '-').trim() + ' / ' + (info.Creator || '-').trim() + ']' + ' (PDF.js: ' + (_pdfjsLib.version || '-') + (!_pdfjsLib.PDFJS.disableWebGL ? ' [WebGL]' : '') + ')');
      let pdfTitle;
      if (metadata && metadata.has('dc:title')) {
        let title = metadata.get('dc:title');
        if (title !== 'Untitled') {
          pdfTitle = title;
        }
      }
      if (!pdfTitle && info && info['Title']) {
        pdfTitle = info['Title'];
      }
      if (pdfTitle) {
        this.setTitle(pdfTitle + ' - ' + document.title);
      }
      if (info.IsAcroFormPresent) {
        console.warn('Warning: AcroForm/XFA is not supported');
        this.fallback(_pdfjsLib.UNSUPPORTED_FEATURES.forms);
      }
      let versionId = String(info.PDFFormatVersion).slice(-1) | 0;
      let generatorId = 0;
      const KNOWN_GENERATORS = ['acrobat distiller', 'acrobat pdfwriter', 'adobe livecycle', 'adobe pdf library', 'adobe photoshop', 'ghostscript', 'tcpdf', 'cairo', 'dvipdfm', 'dvips', 'pdftex', 'pdfkit', 'itext', 'prince', 'quarkxpress', 'mac os x', 'microsoft', 'openoffice', 'oracle', 'luradocument', 'pdf-xchange', 'antenna house', 'aspose.cells', 'fpdf'];
      if (info.Producer) {
        KNOWN_GENERATORS.some(function (generator, s, i) {
          if (generator.indexOf(s) < 0) {
            return false;
          }
          generatorId = i + 1;
          return true;
        }.bind(null, info.Producer.toLowerCase()));
      }
      let formType = !info.IsAcroFormPresent ? null : info.IsXFAPresent ? 'xfa' : 'acroform';
      this.externalServices.reportTelemetry({
        type: 'documentInfo',
        version: versionId,
        generator: generatorId,
        formType
      });
    });
  },
  setInitialView(storedHash, options = {}) {
    let { scale = 0, sidebarView = _pdf_sidebar.SidebarView.NONE } = options;
    this.isInitialViewSet = true;
    this.pdfSidebar.setInitialView(sidebarView);
    if (this.initialDestination) {
      this.pdfLinkService.navigateTo(this.initialDestination);
      this.initialDestination = null;
    } else if (this.initialBookmark) {
      this.pdfLinkService.setHash(this.initialBookmark);
      this.pdfHistory.push({ hash: this.initialBookmark }, true);
      this.initialBookmark = null;
    } else if (storedHash) {
      this.pdfLinkService.setHash(storedHash);
    } else if (scale) {
      this.pdfViewer.currentScaleValue = scale;
      this.page = 1;
    }
    this.toolbar.setPageNumber(this.pdfViewer.currentPageNumber, this.pdfViewer.currentPageLabel);
    this.secondaryToolbar.setPageNumber(this.pdfViewer.currentPageNumber);
    if (!this.pdfViewer.currentScaleValue) {
      this.pdfViewer.currentScaleValue = _ui_utils.DEFAULT_SCALE_VALUE;
    }
  },
  cleanup() {
    if (!this.pdfDocument) {
      return;
    }
    this.pdfViewer.cleanup();
    this.pdfThumbnailViewer.cleanup();
    if (this.pdfViewer.renderer !== _ui_utils.RendererType.SVG) {
      this.pdfDocument.cleanup();
    }
  },
  forceRendering() {
    this.pdfRenderingQueue.printing = this.printing;
    this.pdfRenderingQueue.isThumbnailViewEnabled = this.pdfSidebar.isThumbnailViewVisible;
    this.pdfRenderingQueue.renderHighestPriority();
  },
  beforePrint() {
    if (this.printService) {
      return;
    }
    if (!this.supportsPrinting) {
      this.l10n.get('printing_not_supported', null, 'Warning: Printing is not fully supported by ' + 'this browser.').then(printMessage => {
        this.error(printMessage);
      });
      return;
    }
    if (!this.pdfViewer.pageViewsReady) {
      this.l10n.get('printing_not_ready', null, 'Warning: The PDF is not fully loaded for printing.').then(notReadyMessage => {
        window.alert(notReadyMessage);
      });
      return;
    }
    let pagesOverview = this.pdfViewer.getPagesOverview();
    let printContainer = this.appConfig.printContainer;
    let printService = PDFPrintServiceFactory.instance.createPrintService(this.pdfDocument, pagesOverview, printContainer, this.l10n);
    this.printService = printService;
    this.forceRendering();
    printService.layout();
    this.externalServices.reportTelemetry({ type: 'print' });
  },
  afterPrint: function pdfViewSetupAfterPrint() {
    if (this.printService) {
      this.printService.destroy();
      this.printService = null;
    }
    this.forceRendering();
  },
  rotatePages(delta) {
    if (!this.pdfDocument) {
      return;
    }
    let { pdfViewer, pdfThumbnailViewer } = this;
    let pageNumber = pdfViewer.currentPageNumber;
    let newRotation = (pdfViewer.pagesRotation + 360 + delta) % 360;
    pdfViewer.pagesRotation = newRotation;
    pdfThumbnailViewer.pagesRotation = newRotation;
    this.forceRendering();
    pdfViewer.currentPageNumber = pageNumber;
  },
  requestPresentationMode() {
    if (!this.pdfPresentationMode) {
      return;
    }
    this.pdfPresentationMode.request();
  },
  bindEvents() {
    let { eventBus, _boundEvents } = this;
    _boundEvents.beforePrint = this.beforePrint.bind(this);
    _boundEvents.afterPrint = this.afterPrint.bind(this);
    eventBus.on('resize', webViewerResize);
    eventBus.on('hashchange', webViewerHashchange);
    eventBus.on('beforeprint', _boundEvents.beforePrint);
    eventBus.on('afterprint', _boundEvents.afterPrint);
    eventBus.on('pagerendered', webViewerPageRendered);
    eventBus.on('textlayerrendered', webViewerTextLayerRendered);
    eventBus.on('updateviewarea', webViewerUpdateViewarea);
    eventBus.on('pagechanging', webViewerPageChanging);
    eventBus.on('scalechanging', webViewerScaleChanging);
    eventBus.on('sidebarviewchanged', webViewerSidebarViewChanged);
    eventBus.on('pagemode', webViewerPageMode);
    eventBus.on('namedaction', webViewerNamedAction);
    eventBus.on('presentationmodechanged', webViewerPresentationModeChanged);
    eventBus.on('presentationmode', webViewerPresentationMode);
    eventBus.on('openfile', webViewerOpenFile);
    eventBus.on('print', webViewerPrint);
    eventBus.on('download', webViewerDownload);
    eventBus.on('firstpage', webViewerFirstPage);
    eventBus.on('lastpage', webViewerLastPage);
    eventBus.on('nextpage', webViewerNextPage);
    eventBus.on('previouspage', webViewerPreviousPage);
    eventBus.on('zoomin', webViewerZoomIn);
    eventBus.on('zoomout', webViewerZoomOut);
    eventBus.on('pagenumberchanged', webViewerPageNumberChanged);
    eventBus.on('scalechanged', webViewerScaleChanged);
    eventBus.on('rotatecw', webViewerRotateCw);
    eventBus.on('rotateccw', webViewerRotateCcw);
    eventBus.on('documentproperties', webViewerDocumentProperties);
    eventBus.on('find', webViewerFind);
    eventBus.on('findfromurlhash', webViewerFindFromUrlHash);
  },
  bindWindowEvents() {
    let { eventBus, _boundEvents } = this;
    _boundEvents.windowResize = () => {
      eventBus.dispatch('resize');
    };
    _boundEvents.windowHashChange = () => {
      eventBus.dispatch('hashchange', { hash: document.location.hash.substring(1) });
    };
    _boundEvents.windowBeforePrint = () => {
      eventBus.dispatch('beforeprint');
    };
    _boundEvents.windowAfterPrint = () => {
      eventBus.dispatch('afterprint');
    };
    window.addEventListener('wheel', webViewerWheel);
    window.addEventListener('click', webViewerClick);
    window.addEventListener('keydown', webViewerKeyDown);
    window.addEventListener('resize', _boundEvents.windowResize);
    window.addEventListener('hashchange', _boundEvents.windowHashChange);
    window.addEventListener('beforeprint', _boundEvents.windowBeforePrint);
    window.addEventListener('afterprint', _boundEvents.windowAfterPrint);
  },
  unbindEvents() {
    let { eventBus, _boundEvents } = this;
    eventBus.off('resize', webViewerResize);
    eventBus.off('hashchange', webViewerHashchange);
    eventBus.off('beforeprint', _boundEvents.beforePrint);
    eventBus.off('afterprint', _boundEvents.afterPrint);
    eventBus.off('pagerendered', webViewerPageRendered);
    eventBus.off('textlayerrendered', webViewerTextLayerRendered);
    eventBus.off('updateviewarea', webViewerUpdateViewarea);
    eventBus.off('pagechanging', webViewerPageChanging);
    eventBus.off('scalechanging', webViewerScaleChanging);
    eventBus.off('sidebarviewchanged', webViewerSidebarViewChanged);
    eventBus.off('pagemode', webViewerPageMode);
    eventBus.off('namedaction', webViewerNamedAction);
    eventBus.off('presentationmodechanged', webViewerPresentationModeChanged);
    eventBus.off('presentationmode', webViewerPresentationMode);
    eventBus.off('openfile', webViewerOpenFile);
    eventBus.off('print', webViewerPrint);
    eventBus.off('download', webViewerDownload);
    eventBus.off('firstpage', webViewerFirstPage);
    eventBus.off('lastpage', webViewerLastPage);
    eventBus.off('nextpage', webViewerNextPage);
    eventBus.off('previouspage', webViewerPreviousPage);
    eventBus.off('zoomin', webViewerZoomIn);
    eventBus.off('zoomout', webViewerZoomOut);
    eventBus.off('pagenumberchanged', webViewerPageNumberChanged);
    eventBus.off('scalechanged', webViewerScaleChanged);
    eventBus.off('rotatecw', webViewerRotateCw);
    eventBus.off('rotateccw', webViewerRotateCcw);
    eventBus.off('documentproperties', webViewerDocumentProperties);
    eventBus.off('find', webViewerFind);
    eventBus.off('findfromurlhash', webViewerFindFromUrlHash);
    _boundEvents.beforePrint = null;
    _boundEvents.afterPrint = null;
  },
  unbindWindowEvents() {
    let { _boundEvents } = this;
    window.removeEventListener('wheel', webViewerWheel);
    window.removeEventListener('click', webViewerClick);
    window.removeEventListener('keydown', webViewerKeyDown);
    window.removeEventListener('resize', _boundEvents.windowResize);
    window.removeEventListener('hashchange', _boundEvents.windowHashChange);
    window.removeEventListener('beforeprint', _boundEvents.windowBeforePrint);
    window.removeEventListener('afterprint', _boundEvents.windowAfterPrint);
    _boundEvents.windowResize = null;
    _boundEvents.windowHashChange = null;
    _boundEvents.windowBeforePrint = null;
    _boundEvents.windowAfterPrint = null;
  }
};
let validateFileURL;
;
function loadAndEnablePDFBug(enabledTabs) {
  return new Promise(function (resolve, reject) {
    let appConfig = PDFViewerApplication.appConfig;
    let script = document.createElement('script');
    script.src = appConfig.debuggerScriptPath;
    script.onload = function () {
      PDFBug.enable(enabledTabs);
      PDFBug.init({
        PDFJS: _pdfjsLib.PDFJS,
        OPS: _pdfjsLib.OPS
      }, appConfig.mainContainer);
      resolve();
    };
    script.onerror = function () {
      reject(new Error('Cannot load debugger at ' + script.src));
    };
    (document.getElementsByTagName('head')[0] || document.body).appendChild(script);
  });
}
function webViewerInitialized() {
  let appConfig = PDFViewerApplication.appConfig;
  let file;
  file = window.location.href.split('#')[0];
  let waitForBeforeOpening = [];
  appConfig.toolbar.openFile.setAttribute('hidden', 'true');
  appConfig.secondaryToolbar.openFileButton.setAttribute('hidden', 'true');
  if (PDFViewerApplication.viewerPrefs['pdfBugEnabled']) {
    let hash = document.location.hash.substring(1);
    let hashParams = (0, _ui_utils.parseQueryString)(hash);
    if ('disableworker' in hashParams) {
      _pdfjsLib.PDFJS.disableWorker = hashParams['disableworker'] === 'true';
    }
    if ('disablerange' in hashParams) {
      _pdfjsLib.PDFJS.disableRange = hashParams['disablerange'] === 'true';
    }
    if ('disablestream' in hashParams) {
      _pdfjsLib.PDFJS.disableStream = hashParams['disablestream'] === 'true';
    }
    if ('disableautofetch' in hashParams) {
      _pdfjsLib.PDFJS.disableAutoFetch = hashParams['disableautofetch'] === 'true';
    }
    if ('disablefontface' in hashParams) {
      _pdfjsLib.PDFJS.disableFontFace = hashParams['disablefontface'] === 'true';
    }
    if ('disablehistory' in hashParams) {
      _pdfjsLib.PDFJS.disableHistory = hashParams['disablehistory'] === 'true';
    }
    if ('webgl' in hashParams) {
      _pdfjsLib.PDFJS.disableWebGL = hashParams['webgl'] !== 'true';
    }
    if ('useonlycsszoom' in hashParams) {
      _pdfjsLib.PDFJS.useOnlyCssZoom = hashParams['useonlycsszoom'] === 'true';
    }
    if ('verbosity' in hashParams) {
      _pdfjsLib.PDFJS.verbosity = hashParams['verbosity'] | 0;
    }
    if ('ignorecurrentpositiononzoom' in hashParams) {
      _pdfjsLib.PDFJS.ignoreCurrentPositionOnZoom = hashParams['ignorecurrentpositiononzoom'] === 'true';
    }
    if ('textlayer' in hashParams) {
      switch (hashParams['textlayer']) {
        case 'off':
          _pdfjsLib.PDFJS.disableTextLayer = true;
          break;
        case 'visible':
        case 'shadow':
        case 'hover':
          let viewer = appConfig.viewerContainer;
          viewer.classList.add('textLayer-' + hashParams['textlayer']);
          break;
      }
    }
    if ('pdfbug' in hashParams) {
      _pdfjsLib.PDFJS.pdfBug = true;
      let pdfBug = hashParams['pdfbug'];
      let enabled = pdfBug.split(',');
      waitForBeforeOpening.push(loadAndEnablePDFBug(enabled));
    }
  }
  if (!PDFViewerApplication.supportsDocumentFonts) {
    _pdfjsLib.PDFJS.disableFontFace = true;
    PDFViewerApplication.l10n.get('web_fonts_disabled', null, 'Web fonts are disabled: unable to use embedded PDF fonts.').then(msg => {
      console.warn(msg);
    });
  }
  if (!PDFViewerApplication.supportsPrinting) {
    appConfig.toolbar.print.classList.add('hidden');
    appConfig.secondaryToolbar.printButton.classList.add('hidden');
  }
  if (!PDFViewerApplication.supportsFullscreen) {
    appConfig.toolbar.presentationModeButton.classList.add('hidden');
    appConfig.secondaryToolbar.presentationModeButton.classList.add('hidden');
  }
  if (PDFViewerApplication.supportsIntegratedFind) {
    appConfig.toolbar.viewFind.classList.add('hidden');
  }
  appConfig.sidebar.mainContainer.addEventListener('transitionend', function (evt) {
    if (evt.target === this) {
      PDFViewerApplication.eventBus.dispatch('resize');
    }
  }, true);
  appConfig.sidebar.toggleButton.addEventListener('click', function () {
    PDFViewerApplication.pdfSidebar.toggle();
  });
  Promise.all(waitForBeforeOpening).then(function () {
    webViewerOpenFileViaURL(file);
  }).catch(function (reason) {
    PDFViewerApplication.l10n.get('loading_error', null, 'An error occurred while opening.').then(msg => {
      PDFViewerApplication.error(msg, reason);
    });
  });
}
let webViewerOpenFileViaURL;
{
  webViewerOpenFileViaURL = function webViewerOpenFileViaURL(file) {
    PDFViewerApplication.setTitleUsingUrl(file);
    PDFViewerApplication.initPassiveLoading();
  };
}
function webViewerPageRendered(evt) {
  let pageNumber = evt.pageNumber;
  let pageIndex = pageNumber - 1;
  let pageView = PDFViewerApplication.pdfViewer.getPageView(pageIndex);
  if (pageNumber === PDFViewerApplication.page) {
    PDFViewerApplication.toolbar.updateLoadingIndicatorState(false);
  }
  if (!pageView) {
    return;
  }
  if (PDFViewerApplication.pdfSidebar.isThumbnailViewVisible) {
    let thumbnailView = PDFViewerApplication.pdfThumbnailViewer.getThumbnail(pageIndex);
    thumbnailView.setImage(pageView);
  }
  if (_pdfjsLib.PDFJS.pdfBug && Stats.enabled && pageView.stats) {
    Stats.add(pageNumber, pageView.stats);
  }
  if (pageView.error) {
    PDFViewerApplication.l10n.get('rendering_error', null, 'An error occurred while rendering the page.').then(msg => {
      PDFViewerApplication.error(msg, pageView.error);
    });
  }
  PDFViewerApplication.externalServices.reportTelemetry({ type: 'pageInfo' });
  PDFViewerApplication.pdfDocument.getStats().then(function (stats) {
    PDFViewerApplication.externalServices.reportTelemetry({
      type: 'documentStats',
      stats
    });
  });
}
function webViewerTextLayerRendered(evt) {
  if (evt.numTextDivs > 0 && !PDFViewerApplication.supportsDocumentColors) {
    PDFViewerApplication.l10n.get('document_colors_not_allowed', null, 'PDF documents are not allowed to use their own colors: ' + '\'Allow pages to choose their own colors\' ' + 'is deactivated in the browser.').then(msg => {
      console.error(msg);
    });
    PDFViewerApplication.fallback();
  }
}
function webViewerPageMode(evt) {
  let mode = evt.mode,
      view;
  switch (mode) {
    case 'thumbs':
      view = _pdf_sidebar.SidebarView.THUMBS;
      break;
    case 'bookmarks':
    case 'outline':
      view = _pdf_sidebar.SidebarView.OUTLINE;
      break;
    case 'attachments':
      view = _pdf_sidebar.SidebarView.ATTACHMENTS;
      break;
    case 'none':
      view = _pdf_sidebar.SidebarView.NONE;
      break;
    default:
      console.error('Invalid "pagemode" hash parameter: ' + mode);
      return;
  }
  PDFViewerApplication.pdfSidebar.switchView(view, true);
}
function webViewerNamedAction(evt) {
  let action = evt.action;
  switch (action) {
    case 'GoToPage':
      PDFViewerApplication.appConfig.toolbar.pageNumber.select();
      break;
    case 'Find':
      if (!PDFViewerApplication.supportsIntegratedFind) {
        PDFViewerApplication.findBar.toggle();
      }
      break;
  }
}
function webViewerPresentationModeChanged(evt) {
  let { active, switchInProgress } = evt;
  PDFViewerApplication.pdfViewer.presentationModeState = switchInProgress ? _pdf_viewer.PresentationModeState.CHANGING : active ? _pdf_viewer.PresentationModeState.FULLSCREEN : _pdf_viewer.PresentationModeState.NORMAL;
}
function webViewerSidebarViewChanged(evt) {
  PDFViewerApplication.pdfRenderingQueue.isThumbnailViewEnabled = PDFViewerApplication.pdfSidebar.isThumbnailViewVisible;
  let store = PDFViewerApplication.store;
  if (store && PDFViewerApplication.isInitialViewSet) {
    store.set('sidebarView', evt.view).catch(function () {});
  }
}
function webViewerUpdateViewarea(evt) {
  let location = evt.location,
      store = PDFViewerApplication.store;
  if (store && PDFViewerApplication.isInitialViewSet) {
    store.setMultiple({
      'exists': true,
      'page': location.pageNumber,
      'zoom': location.scale,
      'scrollLeft': location.left,
      'scrollTop': location.top
    }).catch(function () {});
  }
  let href = PDFViewerApplication.pdfLinkService.getAnchorUrl(location.pdfOpenParams);
  PDFViewerApplication.appConfig.toolbar.viewBookmark.href = href;
  PDFViewerApplication.appConfig.secondaryToolbar.viewBookmarkButton.href = href;
  PDFViewerApplication.pdfHistory.updateCurrentBookmark(location.pdfOpenParams, location.pageNumber);
  let currentPage = PDFViewerApplication.pdfViewer.getPageView(PDFViewerApplication.page - 1);
  let loading = currentPage.renderingState !== _pdf_rendering_queue.RenderingStates.FINISHED;
  PDFViewerApplication.toolbar.updateLoadingIndicatorState(loading);
}
function webViewerResize() {
  let { pdfDocument, pdfViewer } = PDFViewerApplication;
  if (!pdfDocument) {
    return;
  }
  let currentScaleValue = pdfViewer.currentScaleValue;
  if (currentScaleValue === 'auto' || currentScaleValue === 'page-fit' || currentScaleValue === 'page-width') {
    pdfViewer.currentScaleValue = currentScaleValue;
  }
  pdfViewer.update();
}
function webViewerHashchange(evt) {
  if (PDFViewerApplication.pdfHistory.isHashChangeUnlocked) {
    let hash = evt.hash;
    if (!hash) {
      return;
    }
    if (!PDFViewerApplication.isInitialViewSet) {
      PDFViewerApplication.initialBookmark = hash;
    } else {
      PDFViewerApplication.pdfLinkService.setHash(hash);
    }
  }
}
let webViewerFileInputChange;
;
function webViewerPresentationMode() {
  PDFViewerApplication.requestPresentationMode();
}
function webViewerOpenFile() {
  let openFileInputName = PDFViewerApplication.appConfig.openFileInputName;
  document.getElementById(openFileInputName).click();
}
function webViewerPrint() {
  window.print();
}
function webViewerDownload() {
  PDFViewerApplication.download();
}
function webViewerFirstPage() {
  if (PDFViewerApplication.pdfDocument) {
    PDFViewerApplication.page = 1;
  }
}
function webViewerLastPage() {
  if (PDFViewerApplication.pdfDocument) {
    PDFViewerApplication.page = PDFViewerApplication.pagesCount;
  }
}
function webViewerNextPage() {
  PDFViewerApplication.page++;
}
function webViewerPreviousPage() {
  PDFViewerApplication.page--;
}
function webViewerZoomIn() {
  PDFViewerApplication.zoomIn();
}
function webViewerZoomOut() {
  PDFViewerApplication.zoomOut();
}
function webViewerPageNumberChanged(evt) {
  let pdfViewer = PDFViewerApplication.pdfViewer;
  pdfViewer.currentPageLabel = evt.value;
  if (evt.value !== pdfViewer.currentPageNumber.toString() && evt.value !== pdfViewer.currentPageLabel) {
    PDFViewerApplication.toolbar.setPageNumber(pdfViewer.currentPageNumber, pdfViewer.currentPageLabel);
  }
}
function webViewerScaleChanged(evt) {
  PDFViewerApplication.pdfViewer.currentScaleValue = evt.value;
}
function webViewerRotateCw() {
  PDFViewerApplication.rotatePages(90);
}
function webViewerRotateCcw() {
  PDFViewerApplication.rotatePages(-90);
}
function webViewerDocumentProperties() {
  PDFViewerApplication.pdfDocumentProperties.open();
}
function webViewerFind(evt) {
  PDFViewerApplication.findController.executeCommand('find' + evt.type, {
    query: evt.query,
    phraseSearch: evt.phraseSearch,
    caseSensitive: evt.caseSensitive,
    highlightAll: evt.highlightAll,
    findPrevious: evt.findPrevious
  });
}
function webViewerFindFromUrlHash(evt) {
  PDFViewerApplication.findController.executeCommand('find', {
    query: evt.query,
    phraseSearch: evt.phraseSearch,
    caseSensitive: false,
    highlightAll: true,
    findPrevious: false
  });
}
function webViewerScaleChanging(evt) {
  PDFViewerApplication.toolbar.setPageScale(evt.presetValue, evt.scale);
  PDFViewerApplication.pdfViewer.update();
}
function webViewerPageChanging(evt) {
  let page = evt.pageNumber;
  PDFViewerApplication.toolbar.setPageNumber(page, evt.pageLabel || null);
  PDFViewerApplication.secondaryToolbar.setPageNumber(page);
  if (PDFViewerApplication.pdfSidebar.isThumbnailViewVisible) {
    PDFViewerApplication.pdfThumbnailViewer.scrollThumbnailIntoView(page);
  }
  if (_pdfjsLib.PDFJS.pdfBug && Stats.enabled) {
    let pageView = PDFViewerApplication.pdfViewer.getPageView(page - 1);
    if (pageView.stats) {
      Stats.add(page, pageView.stats);
    }
  }
}
let zoomDisabled = false,
    zoomDisabledTimeout;
function webViewerWheel(evt) {
  let pdfViewer = PDFViewerApplication.pdfViewer;
  if (pdfViewer.isInPresentationMode) {
    return;
  }
  if (evt.ctrlKey || evt.metaKey) {
    let support = PDFViewerApplication.supportedMouseWheelZoomModifierKeys;
    if (evt.ctrlKey && !support.ctrlKey || evt.metaKey && !support.metaKey) {
      return;
    }
    evt.preventDefault();
    if (zoomDisabled) {
      return;
    }
    let previousScale = pdfViewer.currentScale;
    let delta = (0, _ui_utils.normalizeWheelEventDelta)(evt);
    const MOUSE_WHEEL_DELTA_PER_PAGE_SCALE = 3.0;
    let ticks = delta * MOUSE_WHEEL_DELTA_PER_PAGE_SCALE;
    if (ticks < 0) {
      PDFViewerApplication.zoomOut(-ticks);
    } else {
      PDFViewerApplication.zoomIn(ticks);
    }
    let currentScale = pdfViewer.currentScale;
    if (previousScale !== currentScale) {
      let scaleCorrectionFactor = currentScale / previousScale - 1;
      let rect = pdfViewer.container.getBoundingClientRect();
      let dx = evt.clientX - rect.left;
      let dy = evt.clientY - rect.top;
      pdfViewer.container.scrollLeft += dx * scaleCorrectionFactor;
      pdfViewer.container.scrollTop += dy * scaleCorrectionFactor;
    }
  } else {
    zoomDisabled = true;
    clearTimeout(zoomDisabledTimeout);
    zoomDisabledTimeout = setTimeout(function () {
      zoomDisabled = false;
    }, 1000);
  }
}
function webViewerClick(evt) {
  if (!PDFViewerApplication.secondaryToolbar.isOpen) {
    return;
  }
  let appConfig = PDFViewerApplication.appConfig;
  if (PDFViewerApplication.pdfViewer.containsElement(evt.target) || appConfig.toolbar.container.contains(evt.target) && evt.target !== appConfig.secondaryToolbar.toggleButton) {
    PDFViewerApplication.secondaryToolbar.close();
  }
}
function webViewerKeyDown(evt) {
  if (PDFViewerApplication.overlayManager.active) {
    return;
  }
  let handled = false,
      ensureViewerFocused = false;
  let cmd = (evt.ctrlKey ? 1 : 0) | (evt.altKey ? 2 : 0) | (evt.shiftKey ? 4 : 0) | (evt.metaKey ? 8 : 0);
  let pdfViewer = PDFViewerApplication.pdfViewer;
  let isViewerInPresentationMode = pdfViewer && pdfViewer.isInPresentationMode;
  if (cmd === 1 || cmd === 8 || cmd === 5 || cmd === 12) {
    switch (evt.keyCode) {
      case 70:
        if (!PDFViewerApplication.supportsIntegratedFind) {
          PDFViewerApplication.findBar.open();
          handled = true;
        }
        break;
      case 71:
        if (!PDFViewerApplication.supportsIntegratedFind) {
          let findState = PDFViewerApplication.findController.state;
          if (findState) {
            PDFViewerApplication.findController.executeCommand('findagain', {
              query: findState.query,
              phraseSearch: findState.phraseSearch,
              caseSensitive: findState.caseSensitive,
              highlightAll: findState.highlightAll,
              findPrevious: cmd === 5 || cmd === 12
            });
          }
          handled = true;
        }
        break;
      case 61:
      case 107:
      case 187:
      case 171:
        if (!isViewerInPresentationMode) {
          PDFViewerApplication.zoomIn();
        }
        handled = true;
        break;
      case 173:
      case 109:
      case 189:
        if (!isViewerInPresentationMode) {
          PDFViewerApplication.zoomOut();
        }
        handled = true;
        break;
      case 48:
      case 96:
        if (!isViewerInPresentationMode) {
          setTimeout(function () {
            pdfViewer.currentScaleValue = _ui_utils.DEFAULT_SCALE_VALUE;
          });
          handled = false;
        }
        break;
      case 38:
        if (isViewerInPresentationMode || PDFViewerApplication.page > 1) {
          PDFViewerApplication.page = 1;
          handled = true;
          ensureViewerFocused = true;
        }
        break;
      case 40:
        if (isViewerInPresentationMode || PDFViewerApplication.page < PDFViewerApplication.pagesCount) {
          PDFViewerApplication.page = PDFViewerApplication.pagesCount;
          handled = true;
          ensureViewerFocused = true;
        }
        break;
    }
  }
  if (cmd === 3 || cmd === 10) {
    switch (evt.keyCode) {
      case 80:
        PDFViewerApplication.requestPresentationMode();
        handled = true;
        break;
      case 71:
        PDFViewerApplication.appConfig.toolbar.pageNumber.select();
        handled = true;
        break;
    }
  }
  if (handled) {
    if (ensureViewerFocused && !isViewerInPresentationMode) {
      pdfViewer.focus();
    }
    evt.preventDefault();
    return;
  }
  let curElement = document.activeElement || document.querySelector(':focus');
  let curElementTagName = curElement && curElement.tagName.toUpperCase();
  if (curElementTagName === 'INPUT' || curElementTagName === 'TEXTAREA' || curElementTagName === 'SELECT') {
    if (evt.keyCode !== 27) {
      return;
    }
  }
  if (cmd === 0) {
    switch (evt.keyCode) {
      case 38:
      case 33:
      case 8:
        if (!isViewerInPresentationMode && pdfViewer.currentScaleValue !== 'page-fit') {
          break;
        }
      case 37:
        if (pdfViewer.isHorizontalScrollbarEnabled) {
          break;
        }
      case 75:
      case 80:
        if (PDFViewerApplication.page > 1) {
          PDFViewerApplication.page--;
        }
        handled = true;
        break;
      case 27:
        if (PDFViewerApplication.secondaryToolbar.isOpen) {
          PDFViewerApplication.secondaryToolbar.close();
          handled = true;
        }
        if (!PDFViewerApplication.supportsIntegratedFind && PDFViewerApplication.findBar.opened) {
          PDFViewerApplication.findBar.close();
          handled = true;
        }
        break;
      case 40:
      case 34:
      case 32:
        if (!isViewerInPresentationMode && pdfViewer.currentScaleValue !== 'page-fit') {
          break;
        }
      case 39:
        if (pdfViewer.isHorizontalScrollbarEnabled) {
          break;
        }
      case 74:
      case 78:
        if (PDFViewerApplication.page < PDFViewerApplication.pagesCount) {
          PDFViewerApplication.page++;
        }
        handled = true;
        break;
      case 36:
        if (isViewerInPresentationMode || PDFViewerApplication.page > 1) {
          PDFViewerApplication.page = 1;
          handled = true;
          ensureViewerFocused = true;
        }
        break;
      case 35:
        if (isViewerInPresentationMode || PDFViewerApplication.page < PDFViewerApplication.pagesCount) {
          PDFViewerApplication.page = PDFViewerApplication.pagesCount;
          handled = true;
          ensureViewerFocused = true;
        }
        break;
      case 83:
        PDFViewerApplication.pdfCursorTools.switchTool(_pdf_cursor_tools.CursorTool.SELECT);
        break;
      case 72:
        PDFViewerApplication.pdfCursorTools.switchTool(_pdf_cursor_tools.CursorTool.HAND);
        break;
      case 82:
        PDFViewerApplication.rotatePages(90);
        break;
    }
  }
  if (cmd === 4) {
    switch (evt.keyCode) {
      case 32:
        if (!isViewerInPresentationMode && pdfViewer.currentScaleValue !== 'page-fit') {
          break;
        }
        if (PDFViewerApplication.page > 1) {
          PDFViewerApplication.page--;
        }
        handled = true;
        break;
      case 82:
        PDFViewerApplication.rotatePages(-90);
        break;
    }
  }
  if (!handled && !isViewerInPresentationMode) {
    if (evt.keyCode >= 33 && evt.keyCode <= 40 || evt.keyCode === 32 && curElementTagName !== 'BUTTON') {
      ensureViewerFocused = true;
    }
  }
  if (cmd === 2) {
    switch (evt.keyCode) {
      case 37:
        if (isViewerInPresentationMode) {
          PDFViewerApplication.pdfHistory.back();
          handled = true;
        }
        break;
      case 39:
        if (isViewerInPresentationMode) {
          PDFViewerApplication.pdfHistory.forward();
          handled = true;
        }
        break;
    }
  }
  if (ensureViewerFocused && !pdfViewer.containsElement(curElement)) {
    pdfViewer.focus();
  }
  if (handled) {
    evt.preventDefault();
  }
}
function apiPageModeToSidebarView(mode) {
  switch (mode) {
    case 'UseNone':
      return _pdf_sidebar.SidebarView.NONE;
    case 'UseThumbs':
      return _pdf_sidebar.SidebarView.THUMBS;
    case 'UseOutlines':
      return _pdf_sidebar.SidebarView.OUTLINE;
    case 'UseAttachments':
      return _pdf_sidebar.SidebarView.ATTACHMENTS;
    case 'UseOC':
  }
  return _pdf_sidebar.SidebarView.NONE;
}
let PDFPrintServiceFactory = {
  instance: {
    supportsPrinting: false,
    createPrintService() {
      throw new Error('Not implemented: createPrintService');
    }
  }
};
exports.PDFViewerApplication = PDFViewerApplication;
exports.DefaultExternalServices = DefaultExternalServices;
exports.PDFPrintServiceFactory = PDFPrintServiceFactory;

/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.SimpleLinkService = exports.PDFLinkService = undefined;

var _dom_events = __webpack_require__(2);

var _ui_utils = __webpack_require__(0);

class PDFLinkService {
  constructor({ eventBus } = {}) {
    this.eventBus = eventBus || (0, _dom_events.getGlobalEventBus)();
    this.baseUrl = null;
    this.pdfDocument = null;
    this.pdfViewer = null;
    this.pdfHistory = null;
    this._pagesRefCache = null;
  }
  setDocument(pdfDocument, baseUrl) {
    this.baseUrl = baseUrl;
    this.pdfDocument = pdfDocument;
    this._pagesRefCache = Object.create(null);
  }
  setViewer(pdfViewer) {
    this.pdfViewer = pdfViewer;
  }
  setHistory(pdfHistory) {
    this.pdfHistory = pdfHistory;
  }
  get pagesCount() {
    return this.pdfDocument ? this.pdfDocument.numPages : 0;
  }
  get page() {
    return this.pdfViewer.currentPageNumber;
  }
  set page(value) {
    this.pdfViewer.currentPageNumber = value;
  }
  navigateTo(dest) {
    let goToDestination = ({ namedDest, explicitDest }) => {
      let destRef = explicitDest[0],
          pageNumber;
      if (destRef instanceof Object) {
        pageNumber = this._cachedPageNumber(destRef);
        if (pageNumber === null) {
          this.pdfDocument.getPageIndex(destRef).then(pageIndex => {
            this.cachePageRef(pageIndex + 1, destRef);
            goToDestination({
              namedDest,
              explicitDest
            });
          }).catch(() => {
            console.error(`PDFLinkService.navigateTo: "${destRef}" is not ` + `a valid page reference, for dest="${dest}".`);
          });
          return;
        }
      } else if ((destRef | 0) === destRef) {
        pageNumber = destRef + 1;
      } else {
        console.error(`PDFLinkService.navigateTo: "${destRef}" is not ` + `a valid destination reference, for dest="${dest}".`);
        return;
      }
      if (!pageNumber || pageNumber < 1 || pageNumber > this.pagesCount) {
        console.error(`PDFLinkService.navigateTo: "${pageNumber}" is not ` + `a valid page number, for dest="${dest}".`);
        return;
      }
      this.pdfViewer.scrollPageIntoView({
        pageNumber,
        destArray: explicitDest
      });
      if (this.pdfHistory) {
        this.pdfHistory.push({
          dest: explicitDest,
          hash: namedDest,
          page: pageNumber
        });
      }
    };
    new Promise((resolve, reject) => {
      if (typeof dest === 'string') {
        this.pdfDocument.getDestination(dest).then(destArray => {
          resolve({
            namedDest: dest,
            explicitDest: destArray
          });
        });
        return;
      }
      resolve({
        namedDest: '',
        explicitDest: dest
      });
    }).then(data => {
      if (!(data.explicitDest instanceof Array)) {
        console.error(`PDFLinkService.navigateTo: "${data.explicitDest}" is` + ` not a valid destination array, for dest="${dest}".`);
        return;
      }
      goToDestination(data);
    });
  }
  getDestinationHash(dest) {
    if (typeof dest === 'string') {
      return this.getAnchorUrl('#' + escape(dest));
    }
    if (dest instanceof Array) {
      let str = JSON.stringify(dest);
      return this.getAnchorUrl('#' + escape(str));
    }
    return this.getAnchorUrl('');
  }
  getAnchorUrl(anchor) {
    return (this.baseUrl || '') + anchor;
  }
  setHash(hash) {
    let pageNumber, dest;
    if (hash.indexOf('=') >= 0) {
      let params = (0, _ui_utils.parseQueryString)(hash);
      if ('search' in params) {
        this.eventBus.dispatch('findfromurlhash', {
          source: this,
          query: params['search'].replace(/"/g, ''),
          phraseSearch: params['phrase'] === 'true'
        });
      }
      if ('nameddest' in params) {
        if (this.pdfHistory) {
          this.pdfHistory.updateNextHashParam(params.nameddest);
        }
        this.navigateTo(params.nameddest);
        return;
      }
      if ('page' in params) {
        pageNumber = params.page | 0 || 1;
      }
      if ('zoom' in params) {
        let zoomArgs = params.zoom.split(',');
        let zoomArg = zoomArgs[0];
        let zoomArgNumber = parseFloat(zoomArg);
        if (zoomArg.indexOf('Fit') === -1) {
          dest = [null, { name: 'XYZ' }, zoomArgs.length > 1 ? zoomArgs[1] | 0 : null, zoomArgs.length > 2 ? zoomArgs[2] | 0 : null, zoomArgNumber ? zoomArgNumber / 100 : zoomArg];
        } else {
          if (zoomArg === 'Fit' || zoomArg === 'FitB') {
            dest = [null, { name: zoomArg }];
          } else if (zoomArg === 'FitH' || zoomArg === 'FitBH' || zoomArg === 'FitV' || zoomArg === 'FitBV') {
            dest = [null, { name: zoomArg }, zoomArgs.length > 1 ? zoomArgs[1] | 0 : null];
          } else if (zoomArg === 'FitR') {
            if (zoomArgs.length !== 5) {
              console.error('PDFLinkService.setHash: Not enough parameters for "FitR".');
            } else {
              dest = [null, { name: zoomArg }, zoomArgs[1] | 0, zoomArgs[2] | 0, zoomArgs[3] | 0, zoomArgs[4] | 0];
            }
          } else {
            console.error(`PDFLinkService.setHash: "${zoomArg}" is not ` + 'a valid zoom value.');
          }
        }
      }
      if (dest) {
        this.pdfViewer.scrollPageIntoView({
          pageNumber: pageNumber || this.page,
          destArray: dest,
          allowNegativeOffset: true
        });
      } else if (pageNumber) {
        this.page = pageNumber;
      }
      if ('pagemode' in params) {
        this.eventBus.dispatch('pagemode', {
          source: this,
          mode: params.pagemode
        });
      }
    } else {
      dest = unescape(hash);
      try {
        dest = JSON.parse(dest);
        if (!(dest instanceof Array)) {
          dest = dest.toString();
        }
      } catch (ex) {}
      if (typeof dest === 'string' || isValidExplicitDestination(dest)) {
        if (this.pdfHistory) {
          this.pdfHistory.updateNextHashParam(dest);
        }
        this.navigateTo(dest);
        return;
      }
      console.error(`PDFLinkService.setHash: "${unescape(hash)}" is not ` + 'a valid destination.');
    }
  }
  executeNamedAction(action) {
    switch (action) {
      case 'GoBack':
        if (this.pdfHistory) {
          this.pdfHistory.back();
        }
        break;
      case 'GoForward':
        if (this.pdfHistory) {
          this.pdfHistory.forward();
        }
        break;
      case 'NextPage':
        if (this.page < this.pagesCount) {
          this.page++;
        }
        break;
      case 'PrevPage':
        if (this.page > 1) {
          this.page--;
        }
        break;
      case 'LastPage':
        this.page = this.pagesCount;
        break;
      case 'FirstPage':
        this.page = 1;
        break;
      default:
        break;
    }
    this.eventBus.dispatch('namedaction', {
      source: this,
      action
    });
  }
  onFileAttachmentAnnotation({ id, filename, content }) {
    this.eventBus.dispatch('fileattachmentannotation', {
      source: this,
      id,
      filename,
      content
    });
  }
  cachePageRef(pageNum, pageRef) {
    let refStr = pageRef.num + ' ' + pageRef.gen + ' R';
    this._pagesRefCache[refStr] = pageNum;
  }
  _cachedPageNumber(pageRef) {
    let refStr = pageRef.num + ' ' + pageRef.gen + ' R';
    return this._pagesRefCache && this._pagesRefCache[refStr] || null;
  }
}
function isValidExplicitDestination(dest) {
  if (!(dest instanceof Array)) {
    return false;
  }
  let destLength = dest.length,
      allowNull = true;
  if (destLength < 2) {
    return false;
  }
  let page = dest[0];
  if (!(typeof page === 'object' && typeof page.num === 'number' && (page.num | 0) === page.num && typeof page.gen === 'number' && (page.gen | 0) === page.gen) && !(typeof page === 'number' && (page | 0) === page && page >= 0)) {
    return false;
  }
  let zoom = dest[1];
  if (!(typeof zoom === 'object' && typeof zoom.name === 'string')) {
    return false;
  }
  switch (zoom.name) {
    case 'XYZ':
      if (destLength !== 5) {
        return false;
      }
      break;
    case 'Fit':
    case 'FitB':
      return destLength === 2;
    case 'FitH':
    case 'FitBH':
    case 'FitV':
    case 'FitBV':
      if (destLength !== 3) {
        return false;
      }
      break;
    case 'FitR':
      if (destLength !== 6) {
        return false;
      }
      allowNull = false;
      break;
    default:
      return false;
  }
  for (let i = 2; i < destLength; i++) {
    let param = dest[i];
    if (!(typeof param === 'number' || allowNull && param === null)) {
      return false;
    }
  }
  return true;
}
class SimpleLinkService {
  get page() {
    return 0;
  }
  set page(value) {}
  navigateTo(dest) {}
  getDestinationHash(dest) {
    return '#';
  }
  getAnchorUrl(hash) {
    return '#';
  }
  setHash(hash) {}
  executeNamedAction(action) {}
  onFileAttachmentAnnotation({ id, filename, content }) {}
  cachePageRef(pageNum, pageRef) {}
}
exports.PDFLinkService = PDFLinkService;
exports.SimpleLinkService = SimpleLinkService;

/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFCursorTools = exports.CursorTool = undefined;

var _grab_to_pan = __webpack_require__(12);

const CursorTool = {
  SELECT: 0,
  HAND: 1,
  ZOOM: 2
};
class PDFCursorTools {
  constructor({ container, eventBus, preferences }) {
    this.container = container;
    this.eventBus = eventBus;
    this.active = CursorTool.SELECT;
    this.activeBeforePresentationMode = null;
    this.handTool = new _grab_to_pan.GrabToPan({ element: this.container });
    this._addEventListeners();
    Promise.all([preferences.get('cursorToolOnLoad'), preferences.get('enableHandToolOnLoad')]).then(([cursorToolPref, handToolPref]) => {
      if (handToolPref === true) {
        preferences.set('enableHandToolOnLoad', false);
        if (cursorToolPref === CursorTool.SELECT) {
          cursorToolPref = CursorTool.HAND;
          preferences.set('cursorToolOnLoad', cursorToolPref).catch(() => {});
        }
      }
      this.switchTool(cursorToolPref);
    }).catch(() => {});
  }
  get activeTool() {
    return this.active;
  }
  switchTool(tool) {
    if (this.activeBeforePresentationMode !== null) {
      return;
    }
    if (tool === this.active) {
      return;
    }
    let disableActiveTool = () => {
      switch (this.active) {
        case CursorTool.SELECT:
          break;
        case CursorTool.HAND:
          this.handTool.deactivate();
          break;
        case CursorTool.ZOOM:
      }
    };
    switch (tool) {
      case CursorTool.SELECT:
        disableActiveTool();
        break;
      case CursorTool.HAND:
        disableActiveTool();
        this.handTool.activate();
        break;
      case CursorTool.ZOOM:
      default:
        console.error(`switchTool: "${tool}" is an unsupported value.`);
        return;
    }
    this.active = tool;
    this._dispatchEvent();
  }
  _dispatchEvent() {
    this.eventBus.dispatch('cursortoolchanged', {
      source: this,
      tool: this.active
    });
  }
  _addEventListeners() {
    this.eventBus.on('switchcursortool', evt => {
      this.switchTool(evt.tool);
    });
    this.eventBus.on('presentationmodechanged', evt => {
      if (evt.switchInProgress) {
        return;
      }
      let previouslyActive;
      if (evt.active) {
        previouslyActive = this.active;
        this.switchTool(CursorTool.SELECT);
        this.activeBeforePresentationMode = previouslyActive;
      } else {
        previouslyActive = this.activeBeforePresentationMode;
        this.activeBeforePresentationMode = null;
        this.switchTool(previouslyActive);
      }
    });
  }
}
exports.CursorTool = CursorTool;
exports.PDFCursorTools = PDFCursorTools;

/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFFindController = exports.FindState = undefined;

var _pdfjsLib = __webpack_require__(1);

var _ui_utils = __webpack_require__(0);

const FindState = {
  FOUND: 0,
  NOT_FOUND: 1,
  WRAPPED: 2,
  PENDING: 3
};
const FIND_SCROLL_OFFSET_TOP = -50;
const FIND_SCROLL_OFFSET_LEFT = -400;
const FIND_TIMEOUT = 250;
const CHARACTERS_TO_NORMALIZE = {
  '\u2018': '\'',
  '\u2019': '\'',
  '\u201A': '\'',
  '\u201B': '\'',
  '\u201C': '"',
  '\u201D': '"',
  '\u201E': '"',
  '\u201F': '"',
  '\u00BC': '1/4',
  '\u00BD': '1/2',
  '\u00BE': '3/4'
};
class PDFFindController {
  constructor({ pdfViewer }) {
    this.pdfViewer = pdfViewer;
    this.onUpdateResultsCount = null;
    this.onUpdateState = null;
    this.reset();
    let replace = Object.keys(CHARACTERS_TO_NORMALIZE).join('');
    this.normalizationRegex = new RegExp('[' + replace + ']', 'g');
  }
  reset() {
    this.startedTextExtraction = false;
    this.extractTextPromises = [];
    this.pendingFindMatches = Object.create(null);
    this.active = false;
    this.pageContents = [];
    this.pageMatches = [];
    this.pageMatchesLength = null;
    this.matchCount = 0;
    this.selected = {
      pageIdx: -1,
      matchIdx: -1
    };
    this.offset = {
      pageIdx: null,
      matchIdx: null
    };
    this.pagesToSearch = null;
    this.resumePageIdx = null;
    this.state = null;
    this.dirtyMatch = false;
    this.findTimeout = null;
    this._firstPagePromise = new Promise(resolve => {
      this.resolveFirstPage = resolve;
    });
  }
  normalize(text) {
    return text.replace(this.normalizationRegex, function (ch) {
      return CHARACTERS_TO_NORMALIZE[ch];
    });
  }
  _prepareMatches(matchesWithLength, matches, matchesLength) {
    function isSubTerm(matchesWithLength, currentIndex) {
      let currentElem = matchesWithLength[currentIndex];
      let nextElem = matchesWithLength[currentIndex + 1];
      if (currentIndex < matchesWithLength.length - 1 && currentElem.match === nextElem.match) {
        currentElem.skipped = true;
        return true;
      }
      for (let i = currentIndex - 1; i >= 0; i--) {
        let prevElem = matchesWithLength[i];
        if (prevElem.skipped) {
          continue;
        }
        if (prevElem.match + prevElem.matchLength < currentElem.match) {
          break;
        }
        if (prevElem.match + prevElem.matchLength >= currentElem.match + currentElem.matchLength) {
          currentElem.skipped = true;
          return true;
        }
      }
      return false;
    }
    matchesWithLength.sort(function (a, b) {
      return a.match === b.match ? a.matchLength - b.matchLength : a.match - b.match;
    });
    for (let i = 0, len = matchesWithLength.length; i < len; i++) {
      if (isSubTerm(matchesWithLength, i)) {
        continue;
      }
      matches.push(matchesWithLength[i].match);
      matchesLength.push(matchesWithLength[i].matchLength);
    }
  }
  calcFindPhraseMatch(query, pageIndex, pageContent) {
    let matches = [];
    let queryLen = query.length;
    let matchIdx = -queryLen;
    while (true) {
      matchIdx = pageContent.indexOf(query, matchIdx + queryLen);
      if (matchIdx === -1) {
        break;
      }
      matches.push(matchIdx);
    }
    this.pageMatches[pageIndex] = matches;
  }
  calcFindWordMatch(query, pageIndex, pageContent) {
    let matchesWithLength = [];
    let queryArray = query.match(/\S+/g);
    for (let i = 0, len = queryArray.length; i < len; i++) {
      let subquery = queryArray[i];
      let subqueryLen = subquery.length;
      let matchIdx = -subqueryLen;
      while (true) {
        matchIdx = pageContent.indexOf(subquery, matchIdx + subqueryLen);
        if (matchIdx === -1) {
          break;
        }
        matchesWithLength.push({
          match: matchIdx,
          matchLength: subqueryLen,
          skipped: false
        });
      }
    }
    if (!this.pageMatchesLength) {
      this.pageMatchesLength = [];
    }
    this.pageMatchesLength[pageIndex] = [];
    this.pageMatches[pageIndex] = [];
    this._prepareMatches(matchesWithLength, this.pageMatches[pageIndex], this.pageMatchesLength[pageIndex]);
  }
  calcFindMatch(pageIndex) {
    let pageContent = this.normalize(this.pageContents[pageIndex]);
    let query = this.normalize(this.state.query);
    let caseSensitive = this.state.caseSensitive;
    let phraseSearch = this.state.phraseSearch;
    let queryLen = query.length;
    if (queryLen === 0) {
      return;
    }
    if (!caseSensitive) {
      pageContent = pageContent.toLowerCase();
      query = query.toLowerCase();
    }
    if (phraseSearch) {
      this.calcFindPhraseMatch(query, pageIndex, pageContent);
    } else {
      this.calcFindWordMatch(query, pageIndex, pageContent);
    }
    this.updatePage(pageIndex);
    if (this.resumePageIdx === pageIndex) {
      this.resumePageIdx = null;
      this.nextPageMatch();
    }
    if (this.pageMatches[pageIndex].length > 0) {
      this.matchCount += this.pageMatches[pageIndex].length;
      this.updateUIResultsCount();
    }
  }
  extractText() {
    if (this.startedTextExtraction) {
      return;
    }
    this.startedTextExtraction = true;
    this.pageContents.length = 0;
    let promise = Promise.resolve();
    for (let i = 0, ii = this.pdfViewer.pagesCount; i < ii; i++) {
      let extractTextCapability = (0, _pdfjsLib.createPromiseCapability)();
      this.extractTextPromises[i] = extractTextCapability.promise;
      promise = promise.then(() => {
        return this.pdfViewer.getPageTextContent(i).then(textContent => {
          let textItems = textContent.items;
          let strBuf = [];
          for (let j = 0, jj = textItems.length; j < jj; j++) {
            strBuf.push(textItems[j].str);
          }
          this.pageContents[i] = strBuf.join('');
          extractTextCapability.resolve(i);
        }, reason => {
          console.error(`Unable to get page ${i + 1} text content`, reason);
          this.pageContents[i] = '';
          extractTextCapability.resolve(i);
        });
      });
    }
  }
  executeCommand(cmd, state) {
    if (this.state === null || cmd !== 'findagain') {
      this.dirtyMatch = true;
    }
    this.state = state;
    this.updateUIState(FindState.PENDING);
    this._firstPagePromise.then(() => {
      this.extractText();
      clearTimeout(this.findTimeout);
      if (cmd === 'find') {
        this.findTimeout = setTimeout(this.nextMatch.bind(this), FIND_TIMEOUT);
      } else {
        this.nextMatch();
      }
    });
  }
  updatePage(index) {
    if (this.selected.pageIdx === index) {
      this.pdfViewer.currentPageNumber = index + 1;
    }
    let page = this.pdfViewer.getPageView(index);
    if (page.textLayer) {
      page.textLayer.updateMatches();
    }
  }
  nextMatch() {
    let previous = this.state.findPrevious;
    let currentPageIndex = this.pdfViewer.currentPageNumber - 1;
    let numPages = this.pdfViewer.pagesCount;
    this.active = true;
    if (this.dirtyMatch) {
      this.dirtyMatch = false;
      this.selected.pageIdx = this.selected.matchIdx = -1;
      this.offset.pageIdx = currentPageIndex;
      this.offset.matchIdx = null;
      this.hadMatch = false;
      this.resumePageIdx = null;
      this.pageMatches = [];
      this.matchCount = 0;
      this.pageMatchesLength = null;
      for (let i = 0; i < numPages; i++) {
        this.updatePage(i);
        if (!(i in this.pendingFindMatches)) {
          this.pendingFindMatches[i] = true;
          this.extractTextPromises[i].then(pageIdx => {
            delete this.pendingFindMatches[pageIdx];
            this.calcFindMatch(pageIdx);
          });
        }
      }
    }
    if (this.state.query === '') {
      this.updateUIState(FindState.FOUND);
      return;
    }
    if (this.resumePageIdx) {
      return;
    }
    let offset = this.offset;
    this.pagesToSearch = numPages;
    if (offset.matchIdx !== null) {
      let numPageMatches = this.pageMatches[offset.pageIdx].length;
      if (!previous && offset.matchIdx + 1 < numPageMatches || previous && offset.matchIdx > 0) {
        this.hadMatch = true;
        offset.matchIdx = previous ? offset.matchIdx - 1 : offset.matchIdx + 1;
        this.updateMatch(true);
        return;
      }
      this.advanceOffsetPage(previous);
    }
    this.nextPageMatch();
  }
  matchesReady(matches) {
    let offset = this.offset;
    let numMatches = matches.length;
    let previous = this.state.findPrevious;
    if (numMatches) {
      this.hadMatch = true;
      offset.matchIdx = previous ? numMatches - 1 : 0;
      this.updateMatch(true);
      return true;
    }
    this.advanceOffsetPage(previous);
    if (offset.wrapped) {
      offset.matchIdx = null;
      if (this.pagesToSearch < 0) {
        this.updateMatch(false);
        return true;
      }
    }
    return false;
  }
  updateMatchPosition(pageIndex, matchIndex, elements, beginIdx) {
    if (this.selected.matchIdx === matchIndex && this.selected.pageIdx === pageIndex) {
      let spot = {
        top: FIND_SCROLL_OFFSET_TOP,
        left: FIND_SCROLL_OFFSET_LEFT
      };
      (0, _ui_utils.scrollIntoView)(elements[beginIdx], spot, true);
    }
  }
  nextPageMatch() {
    if (this.resumePageIdx !== null) {
      console.error('There can only be one pending page.');
    }
    let matches = null;
    do {
      let pageIdx = this.offset.pageIdx;
      matches = this.pageMatches[pageIdx];
      if (!matches) {
        this.resumePageIdx = pageIdx;
        break;
      }
    } while (!this.matchesReady(matches));
  }
  advanceOffsetPage(previous) {
    let offset = this.offset;
    let numPages = this.extractTextPromises.length;
    offset.pageIdx = previous ? offset.pageIdx - 1 : offset.pageIdx + 1;
    offset.matchIdx = null;
    this.pagesToSearch--;
    if (offset.pageIdx >= numPages || offset.pageIdx < 0) {
      offset.pageIdx = previous ? numPages - 1 : 0;
      offset.wrapped = true;
    }
  }
  updateMatch(found = false) {
    let state = FindState.NOT_FOUND;
    let wrapped = this.offset.wrapped;
    this.offset.wrapped = false;
    if (found) {
      let previousPage = this.selected.pageIdx;
      this.selected.pageIdx = this.offset.pageIdx;
      this.selected.matchIdx = this.offset.matchIdx;
      state = wrapped ? FindState.WRAPPED : FindState.FOUND;
      if (previousPage !== -1 && previousPage !== this.selected.pageIdx) {
        this.updatePage(previousPage);
      }
    }
    this.updateUIState(state, this.state.findPrevious);
    if (this.selected.pageIdx !== -1) {
      this.updatePage(this.selected.pageIdx);
    }
  }
  updateUIResultsCount() {
    if (this.onUpdateResultsCount) {
      this.onUpdateResultsCount(this.matchCount);
    }
  }
  updateUIState(state, previous) {
    if (this.onUpdateState) {
      this.onUpdateState(state, previous, this.matchCount);
    }
  }
}
exports.FindState = FindState;
exports.PDFFindController = PDFFindController;

/***/ }),
/* 8 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.FirefoxPrintService = undefined;

var _ui_utils = __webpack_require__(0);

var _app = __webpack_require__(4);

var _pdfjsLib = __webpack_require__(1);

function composePage(pdfDocument, pageNumber, size, printContainer) {
  var canvas = document.createElement('canvas');
  var PRINT_RESOLUTION = 150;
  var PRINT_UNITS = PRINT_RESOLUTION / 72.0;
  canvas.width = Math.floor(size.width * PRINT_UNITS);
  canvas.height = Math.floor(size.height * PRINT_UNITS);
  canvas.style.width = Math.floor(size.width * _ui_utils.CSS_UNITS) + 'px';
  canvas.style.height = Math.floor(size.height * _ui_utils.CSS_UNITS) + 'px';
  var canvasWrapper = document.createElement('div');
  canvasWrapper.appendChild(canvas);
  printContainer.appendChild(canvasWrapper);
  canvas.mozPrintCallback = function (obj) {
    var ctx = obj.context;
    ctx.save();
    ctx.fillStyle = 'rgb(255, 255, 255)';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.restore();
    pdfDocument.getPage(pageNumber).then(function (pdfPage) {
      var renderContext = {
        canvasContext: ctx,
        transform: [PRINT_UNITS, 0, 0, PRINT_UNITS, 0, 0],
        viewport: pdfPage.getViewport(1, size.rotation),
        intent: 'print'
      };
      return pdfPage.render(renderContext).promise;
    }).then(function () {
      obj.done();
    }, function (error) {
      console.error(error);
      if ('abort' in obj) {
        obj.abort();
      } else {
        obj.done();
      }
    });
  };
}
function FirefoxPrintService(pdfDocument, pagesOverview, printContainer) {
  this.pdfDocument = pdfDocument;
  this.pagesOverview = pagesOverview;
  this.printContainer = printContainer;
}
FirefoxPrintService.prototype = {
  layout() {
    var pdfDocument = this.pdfDocument;
    var printContainer = this.printContainer;
    var body = document.querySelector('body');
    body.setAttribute('data-pdfjsprinting', true);
    for (var i = 0, ii = this.pagesOverview.length; i < ii; ++i) {
      composePage(pdfDocument, i + 1, this.pagesOverview[i], printContainer);
    }
  },
  destroy() {
    this.printContainer.textContent = '';
  }
};
_app.PDFPrintServiceFactory.instance = {
  get supportsPrinting() {
    var canvas = document.createElement('canvas');
    var value = 'mozPrintCallback' in canvas;
    return (0, _pdfjsLib.shadow)(this, 'supportsPrinting', value);
  },
  createPrintService(pdfDocument, pagesOverview, printContainer) {
    return new FirefoxPrintService(pdfDocument, pagesOverview, printContainer);
  }
};
exports.FirefoxPrintService = FirefoxPrintService;

/***/ }),
/* 9 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.FirefoxCom = exports.DownloadManager = undefined;

__webpack_require__(10);

var _pdfjsLib = __webpack_require__(1);

var _preferences = __webpack_require__(26);

var _app = __webpack_require__(4);

;
var FirefoxCom = function FirefoxComClosure() {
  return {
    requestSync(action, data) {
      var request = document.createTextNode('');
      document.documentElement.appendChild(request);
      var sender = document.createEvent('CustomEvent');
      sender.initCustomEvent('pdf.js.message', true, false, {
        action,
        data,
        sync: true
      });
      request.dispatchEvent(sender);
      var response = sender.detail.response;
      document.documentElement.removeChild(request);
      return response;
    },
    request(action, data, callback) {
      var request = document.createTextNode('');
      if (callback) {
        document.addEventListener('pdf.js.response', function listener(event) {
          var node = event.target;
          var response = event.detail.response;
          document.documentElement.removeChild(node);
          document.removeEventListener('pdf.js.response', listener);
          return callback(response);
        });
      }
      document.documentElement.appendChild(request);
      var sender = document.createEvent('CustomEvent');
      sender.initCustomEvent('pdf.js.message', true, false, {
        action,
        data,
        sync: false,
        responseExpected: !!callback
      });
      return request.dispatchEvent(sender);
    }
  };
}();
var DownloadManager = function DownloadManagerClosure() {
  function DownloadManager() {}
  DownloadManager.prototype = {
    downloadUrl: function DownloadManager_downloadUrl(url, filename) {
      FirefoxCom.request('download', {
        originalUrl: url,
        filename
      });
    },
    downloadData: function DownloadManager_downloadData(data, filename, contentType) {
      var blobUrl = (0, _pdfjsLib.createObjectURL)(data, contentType, false);
      FirefoxCom.request('download', {
        blobUrl,
        originalUrl: blobUrl,
        filename,
        isAttachment: true
      });
    },
    download: function DownloadManager_download(blob, url, filename) {
      let blobUrl = window.URL.createObjectURL(blob);
      let onResponse = err => {
        if (err && this.onerror) {
          this.onerror(err);
        }
        window.URL.revokeObjectURL(blobUrl);
      };
      FirefoxCom.request('download', {
        blobUrl,
        originalUrl: url,
        filename
      }, onResponse);
    }
  };
  return DownloadManager;
}();
class FirefoxPreferences extends _preferences.BasePreferences {
  _writeToStorage(prefObj) {
    return new Promise(function (resolve) {
      FirefoxCom.request('setPreferences', prefObj, resolve);
    });
  }
  _readFromStorage(prefObj) {
    return new Promise(function (resolve) {
      FirefoxCom.request('getPreferences', prefObj, function (prefStr) {
        var readPrefs = JSON.parse(prefStr);
        resolve(readPrefs);
      });
    });
  }
}
class MozL10n {
  constructor(mozL10n) {
    this.mozL10n = mozL10n;
  }
  getDirection() {
    return Promise.resolve(this.mozL10n.getDirection());
  }
  get(property, args, fallback) {
    return Promise.resolve(this.mozL10n.get(property, args, fallback));
  }
  translate(element) {
    this.mozL10n.translate(element);
    return Promise.resolve();
  }
}
(function listenFindEvents() {
  var events = ['find', 'findagain', 'findhighlightallchange', 'findcasesensitivitychange'];
  var handleEvent = function (evt) {
    if (!_app.PDFViewerApplication.initialized) {
      return;
    }
    _app.PDFViewerApplication.eventBus.dispatch('find', {
      source: window,
      type: evt.type.substring('find'.length),
      query: evt.detail.query,
      phraseSearch: true,
      caseSensitive: !!evt.detail.caseSensitive,
      highlightAll: !!evt.detail.highlightAll,
      findPrevious: !!evt.detail.findPrevious
    });
  };
  for (var i = 0, len = events.length; i < len; i++) {
    window.addEventListener(events[i], handleEvent);
  }
})();
function FirefoxComDataRangeTransport(length, initialData) {
  _pdfjsLib.PDFDataRangeTransport.call(this, length, initialData);
}
FirefoxComDataRangeTransport.prototype = Object.create(_pdfjsLib.PDFDataRangeTransport.prototype);
FirefoxComDataRangeTransport.prototype.requestDataRange = function FirefoxComDataRangeTransport_requestDataRange(begin, end) {
  FirefoxCom.request('requestDataRange', {
    begin,
    end
  });
};
FirefoxComDataRangeTransport.prototype.abort = function FirefoxComDataRangeTransport_abort() {
  FirefoxCom.requestSync('abortLoading', null);
};
_app.PDFViewerApplication.externalServices = {
  updateFindControlState(data) {
    FirefoxCom.request('updateFindControlState', data);
  },
  initPassiveLoading(callbacks) {
    var pdfDataRangeTransport;
    window.addEventListener('message', function windowMessage(e) {
      if (e.source !== null) {
        console.warn('Rejected untrusted message from ' + e.origin);
        return;
      }
      var args = e.data;
      if (typeof args !== 'object' || !('pdfjsLoadAction' in args)) {
        return;
      }
      switch (args.pdfjsLoadAction) {
        case 'supportsRangedLoading':
          pdfDataRangeTransport = new FirefoxComDataRangeTransport(args.length, args.data);
          callbacks.onOpenWithTransport(args.pdfUrl, args.length, pdfDataRangeTransport);
          break;
        case 'range':
          pdfDataRangeTransport.onDataRange(args.begin, args.chunk);
          break;
        case 'rangeProgress':
          pdfDataRangeTransport.onDataProgress(args.loaded);
          break;
        case 'progressiveRead':
          pdfDataRangeTransport.onDataProgressiveRead(args.chunk);
          break;
        case 'progress':
          callbacks.onProgress(args.loaded, args.total);
          break;
        case 'complete':
          if (!args.data) {
            callbacks.onError(args.errorCode);
            break;
          }
          callbacks.onOpenWithData(args.data);
          break;
      }
    });
    FirefoxCom.requestSync('initPassiveLoading', null);
  },
  fallback(data, callback) {
    FirefoxCom.request('fallback', data, callback);
  },
  reportTelemetry(data) {
    FirefoxCom.request('reportTelemetry', JSON.stringify(data));
  },
  createDownloadManager() {
    return new DownloadManager();
  },
  createPreferences() {
    return new FirefoxPreferences();
  },
  createL10n() {
    var mozL10n = document.mozL10n;
    return new MozL10n(mozL10n);
  },
  get supportsIntegratedFind() {
    var support = FirefoxCom.requestSync('supportsIntegratedFind');
    return (0, _pdfjsLib.shadow)(this, 'supportsIntegratedFind', support);
  },
  get supportsDocumentFonts() {
    var support = FirefoxCom.requestSync('supportsDocumentFonts');
    return (0, _pdfjsLib.shadow)(this, 'supportsDocumentFonts', support);
  },
  get supportsDocumentColors() {
    var support = FirefoxCom.requestSync('supportsDocumentColors');
    return (0, _pdfjsLib.shadow)(this, 'supportsDocumentColors', support);
  },
  get supportedMouseWheelZoomModifierKeys() {
    var support = FirefoxCom.requestSync('supportedMouseWheelZoomModifierKeys');
    return (0, _pdfjsLib.shadow)(this, 'supportedMouseWheelZoomModifierKeys', support);
  }
};
document.mozL10n.setExternalLocalizerServices({
  getLocale() {
    return FirefoxCom.requestSync('getLocale', null);
  },
  getStrings(key) {
    return FirefoxCom.requestSync('getStrings', key);
  }
});
exports.DownloadManager = DownloadManager;
exports.FirefoxCom = FirefoxCom;

/***/ }),
/* 10 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


(function (window) {
  var gLanguage = "";
  var gExternalLocalizerServices = null;
  var gReadyState = "loading";
  function getL10nData(key) {
    var response = gExternalLocalizerServices.getStrings(key);
    var data = JSON.parse(response);
    if (!data) {
      console.warn("[l10n] #" + key + " missing for [" + gLanguage + "]");
    }
    return data;
  }
  function substArguments(text, args) {
    if (!args) {
      return text;
    }
    return text.replace(/\{\{\s*(\w+)\s*\}\}/g, function (all, name) {
      return name in args ? args[name] : "{{" + name + "}}";
    });
  }
  function translateString(key, args, fallback) {
    var i = key.lastIndexOf(".");
    var name, property;
    if (i >= 0) {
      name = key.substring(0, i);
      property = key.substring(i + 1);
    } else {
      name = key;
      property = "textContent";
    }
    var data = getL10nData(name);
    var value = data && data[property] || fallback;
    if (!value) {
      return "{{" + key + "}}";
    }
    return substArguments(value, args);
  }
  function translateElement(element) {
    if (!element || !element.dataset) {
      return;
    }
    var key = element.dataset.l10nId;
    var data = getL10nData(key);
    if (!data) {
      return;
    }
    var args;
    if (element.dataset.l10nArgs) {
      try {
        args = JSON.parse(element.dataset.l10nArgs);
      } catch (e) {
        console.warn("[l10n] could not parse arguments for #" + key + "");
      }
    }
    for (var k in data) {
      element[k] = substArguments(data[k], args);
    }
  }
  function translateFragment(element) {
    element = element || document.querySelector("html");
    var children = element.querySelectorAll("*[data-l10n-id]");
    var elementCount = children.length;
    for (var i = 0; i < elementCount; i++) {
      translateElement(children[i]);
    }
    if (element.dataset.l10nId) {
      translateElement(element);
    }
  }
  document.mozL10n = {
    get: translateString,
    getLanguage() {
      return gLanguage;
    },
    getDirection() {
      var rtlList = ["ar", "he", "fa", "ps", "ur"];
      var shortCode = gLanguage.split("-")[0];
      return rtlList.indexOf(shortCode) >= 0 ? "rtl" : "ltr";
    },
    getReadyState() {
      return gReadyState;
    },
    setExternalLocalizerServices(externalLocalizerServices) {
      gExternalLocalizerServices = externalLocalizerServices;
      gLanguage = gExternalLocalizerServices.getLocale();
      gReadyState = "complete";
    },
    translate: translateFragment
  };
})(undefined);

/***/ }),
/* 11 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.DefaultAnnotationLayerFactory = exports.AnnotationLayerBuilder = undefined;

var _pdfjsLib = __webpack_require__(1);

var _ui_utils = __webpack_require__(0);

var _pdf_link_service = __webpack_require__(5);

class AnnotationLayerBuilder {
  constructor({ pageDiv, pdfPage, linkService, downloadManager, renderInteractiveForms = false, l10n = _ui_utils.NullL10n }) {
    this.pageDiv = pageDiv;
    this.pdfPage = pdfPage;
    this.linkService = linkService;
    this.downloadManager = downloadManager;
    this.renderInteractiveForms = renderInteractiveForms;
    this.l10n = l10n;
    this.div = null;
  }
  render(viewport, intent = 'display') {
    this.pdfPage.getAnnotations({ intent }).then(annotations => {
      let parameters = {
        viewport: viewport.clone({ dontFlip: true }),
        div: this.div,
        annotations,
        page: this.pdfPage,
        renderInteractiveForms: this.renderInteractiveForms,
        linkService: this.linkService,
        downloadManager: this.downloadManager
      };
      if (this.div) {
        _pdfjsLib.AnnotationLayer.update(parameters);
      } else {
        if (annotations.length === 0) {
          return;
        }
        this.div = document.createElement('div');
        this.div.className = 'annotationLayer';
        this.pageDiv.appendChild(this.div);
        parameters.div = this.div;
        _pdfjsLib.AnnotationLayer.render(parameters);
        this.l10n.translate(this.div);
      }
    });
  }
  hide() {
    if (!this.div) {
      return;
    }
    this.div.setAttribute('hidden', 'true');
  }
}
class DefaultAnnotationLayerFactory {
  createAnnotationLayerBuilder(pageDiv, pdfPage, renderInteractiveForms = false, l10n = _ui_utils.NullL10n) {
    return new AnnotationLayerBuilder({
      pageDiv,
      pdfPage,
      renderInteractiveForms,
      linkService: new _pdf_link_service.SimpleLinkService(),
      l10n
    });
  }
}
exports.AnnotationLayerBuilder = AnnotationLayerBuilder;
exports.DefaultAnnotationLayerFactory = DefaultAnnotationLayerFactory;

/***/ }),
/* 12 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
function GrabToPan(options) {
  this.element = options.element;
  this.document = options.element.ownerDocument;
  if (typeof options.ignoreTarget === 'function') {
    this.ignoreTarget = options.ignoreTarget;
  }
  this.onActiveChanged = options.onActiveChanged;
  this.activate = this.activate.bind(this);
  this.deactivate = this.deactivate.bind(this);
  this.toggle = this.toggle.bind(this);
  this._onmousedown = this._onmousedown.bind(this);
  this._onmousemove = this._onmousemove.bind(this);
  this._endPan = this._endPan.bind(this);
  var overlay = this.overlay = document.createElement('div');
  overlay.className = 'grab-to-pan-grabbing';
}
GrabToPan.prototype = {
  CSS_CLASS_GRAB: 'grab-to-pan-grab',
  activate: function GrabToPan_activate() {
    if (!this.active) {
      this.active = true;
      this.element.addEventListener('mousedown', this._onmousedown, true);
      this.element.classList.add(this.CSS_CLASS_GRAB);
      if (this.onActiveChanged) {
        this.onActiveChanged(true);
      }
    }
  },
  deactivate: function GrabToPan_deactivate() {
    if (this.active) {
      this.active = false;
      this.element.removeEventListener('mousedown', this._onmousedown, true);
      this._endPan();
      this.element.classList.remove(this.CSS_CLASS_GRAB);
      if (this.onActiveChanged) {
        this.onActiveChanged(false);
      }
    }
  },
  toggle: function GrabToPan_toggle() {
    if (this.active) {
      this.deactivate();
    } else {
      this.activate();
    }
  },
  ignoreTarget: function GrabToPan_ignoreTarget(node) {
    return node[matchesSelector]('a[href], a[href] *, input, textarea, button, button *, select, option');
  },
  _onmousedown: function GrabToPan__onmousedown(event) {
    if (event.button !== 0 || this.ignoreTarget(event.target)) {
      return;
    }
    if (event.originalTarget) {
      try {
        event.originalTarget.tagName;
      } catch (e) {
        return;
      }
    }
    this.scrollLeftStart = this.element.scrollLeft;
    this.scrollTopStart = this.element.scrollTop;
    this.clientXStart = event.clientX;
    this.clientYStart = event.clientY;
    this.document.addEventListener('mousemove', this._onmousemove, true);
    this.document.addEventListener('mouseup', this._endPan, true);
    this.element.addEventListener('scroll', this._endPan, true);
    event.preventDefault();
    event.stopPropagation();
    var focusedElement = document.activeElement;
    if (focusedElement && !focusedElement.contains(event.target)) {
      focusedElement.blur();
    }
  },
  _onmousemove: function GrabToPan__onmousemove(event) {
    this.element.removeEventListener('scroll', this._endPan, true);
    if (isLeftMouseReleased(event)) {
      this._endPan();
      return;
    }
    var xDiff = event.clientX - this.clientXStart;
    var yDiff = event.clientY - this.clientYStart;
    var scrollTop = this.scrollTopStart - yDiff;
    var scrollLeft = this.scrollLeftStart - xDiff;
    if (this.element.scrollTo) {
      this.element.scrollTo({
        top: scrollTop,
        left: scrollLeft,
        behavior: 'instant'
      });
    } else {
      this.element.scrollTop = scrollTop;
      this.element.scrollLeft = scrollLeft;
    }
    if (!this.overlay.parentNode) {
      document.body.appendChild(this.overlay);
    }
  },
  _endPan: function GrabToPan__endPan() {
    this.element.removeEventListener('scroll', this._endPan, true);
    this.document.removeEventListener('mousemove', this._onmousemove, true);
    this.document.removeEventListener('mouseup', this._endPan, true);
    this.overlay.remove();
  }
};
var matchesSelector;
['webkitM', 'mozM', 'msM', 'oM', 'm'].some(function (prefix) {
  var name = prefix + 'atches';
  if (name in document.documentElement) {
    matchesSelector = name;
  }
  name += 'Selector';
  if (name in document.documentElement) {
    matchesSelector = name;
  }
  return matchesSelector;
});
var isNotIEorIsIE10plus = !document.documentMode || document.documentMode > 9;
var chrome = window.chrome;
var isChrome15OrOpera15plus = chrome && (chrome.webstore || chrome.app);
var isSafari6plus = /Apple/.test(navigator.vendor) && /Version\/([6-9]\d*|[1-5]\d+)/.test(navigator.userAgent);
function isLeftMouseReleased(event) {
  if ('buttons' in event && isNotIEorIsIE10plus) {
    return !(event.buttons & 1);
  }
  if (isChrome15OrOpera15plus || isSafari6plus) {
    return event.which === 0;
  }
}
exports.GrabToPan = GrabToPan;

/***/ }),
/* 13 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
class OverlayManager {
  constructor() {
    this._overlays = {};
    this._active = null;
    this._keyDownBound = this._keyDown.bind(this);
  }
  get active() {
    return this._active;
  }
  register(name, element, callerCloseMethod = null, canForceClose = false) {
    return new Promise(resolve => {
      let container;
      if (!name || !element || !(container = element.parentNode)) {
        throw new Error('Not enough parameters.');
      } else if (this._overlays[name]) {
        throw new Error('The overlay is already registered.');
      }
      this._overlays[name] = {
        element,
        container,
        callerCloseMethod,
        canForceClose
      };
      resolve();
    });
  }
  unregister(name) {
    return new Promise(resolve => {
      if (!this._overlays[name]) {
        throw new Error('The overlay does not exist.');
      } else if (this._active === name) {
        throw new Error('The overlay cannot be removed while it is active.');
      }
      delete this._overlays[name];
      resolve();
    });
  }
  open(name) {
    return new Promise(resolve => {
      if (!this._overlays[name]) {
        throw new Error('The overlay does not exist.');
      } else if (this._active) {
        if (this._overlays[name].canForceClose) {
          this._closeThroughCaller();
        } else if (this._active === name) {
          throw new Error('The overlay is already active.');
        } else {
          throw new Error('Another overlay is currently active.');
        }
      }
      this._active = name;
      this._overlays[this._active].element.classList.remove('hidden');
      this._overlays[this._active].container.classList.remove('hidden');
      window.addEventListener('keydown', this._keyDownBound);
      resolve();
    });
  }
  close(name) {
    return new Promise(resolve => {
      if (!this._overlays[name]) {
        throw new Error('The overlay does not exist.');
      } else if (!this._active) {
        throw new Error('The overlay is currently not active.');
      } else if (this._active !== name) {
        throw new Error('Another overlay is currently active.');
      }
      this._overlays[this._active].container.classList.add('hidden');
      this._overlays[this._active].element.classList.add('hidden');
      this._active = null;
      window.removeEventListener('keydown', this._keyDownBound);
      resolve();
    });
  }
  _keyDown(evt) {
    if (this._active && evt.keyCode === 27) {
      this._closeThroughCaller();
      evt.preventDefault();
    }
  }
  _closeThroughCaller() {
    if (this._overlays[this._active].callerCloseMethod) {
      this._overlays[this._active].callerCloseMethod();
    }
    if (this._active) {
      this.close(this._active);
    }
  }
}
exports.OverlayManager = OverlayManager;

/***/ }),
/* 14 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PasswordPrompt = undefined;

var _ui_utils = __webpack_require__(0);

var _pdfjsLib = __webpack_require__(1);

class PasswordPrompt {
  constructor(options, overlayManager, l10n = _ui_utils.NullL10n) {
    this.overlayName = options.overlayName;
    this.container = options.container;
    this.label = options.label;
    this.input = options.input;
    this.submitButton = options.submitButton;
    this.cancelButton = options.cancelButton;
    this.overlayManager = overlayManager;
    this.l10n = l10n;
    this.updateCallback = null;
    this.reason = null;
    this.submitButton.addEventListener('click', this.verify.bind(this));
    this.cancelButton.addEventListener('click', this.close.bind(this));
    this.input.addEventListener('keydown', e => {
      if (e.keyCode === 13) {
        this.verify();
      }
    });
    this.overlayManager.register(this.overlayName, this.container, this.close.bind(this), true);
  }
  open() {
    this.overlayManager.open(this.overlayName).then(() => {
      this.input.focus();
      let promptString;
      if (this.reason === _pdfjsLib.PasswordResponses.INCORRECT_PASSWORD) {
        promptString = this.l10n.get('password_invalid', null, 'Invalid password. Please try again.');
      } else {
        promptString = this.l10n.get('password_label', null, 'Enter the password to open this PDF file.');
      }
      promptString.then(msg => {
        this.label.textContent = msg;
      });
    });
  }
  close() {
    this.overlayManager.close(this.overlayName).then(() => {
      this.input.value = '';
    });
  }
  verify() {
    let password = this.input.value;
    if (password && password.length > 0) {
      this.close();
      return this.updateCallback(password);
    }
  }
  setUpdateCallback(updateCallback, reason) {
    this.updateCallback = updateCallback;
    this.reason = reason;
  }
}
exports.PasswordPrompt = PasswordPrompt;

/***/ }),
/* 15 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFAttachmentViewer = undefined;

var _pdfjsLib = __webpack_require__(1);

class PDFAttachmentViewer {
  constructor({ container, eventBus, downloadManager }) {
    this.attachments = null;
    this.container = container;
    this.eventBus = eventBus;
    this.downloadManager = downloadManager;
    this._renderedCapability = (0, _pdfjsLib.createPromiseCapability)();
    this.eventBus.on('fileattachmentannotation', this._appendAttachment.bind(this));
  }
  reset(keepRenderedCapability = false) {
    this.attachments = null;
    this.container.textContent = '';
    if (!keepRenderedCapability) {
      this._renderedCapability = (0, _pdfjsLib.createPromiseCapability)();
    }
  }
  _dispatchEvent(attachmentsCount) {
    this.eventBus.dispatch('attachmentsloaded', {
      source: this,
      attachmentsCount
    });
    this._renderedCapability.resolve();
  }
  _bindPdfLink(button, content, filename) {
    if (_pdfjsLib.PDFJS.disableCreateObjectURL) {
      throw new Error('bindPdfLink: ' + 'Unsupported "PDFJS.disableCreateObjectURL" value.');
    }
    let blobUrl;
    button.onclick = function () {
      if (!blobUrl) {
        blobUrl = (0, _pdfjsLib.createObjectURL)(content, 'application/pdf');
      }
      let viewerUrl;
      viewerUrl = blobUrl + '?' + encodeURIComponent(filename);
      window.open(viewerUrl);
      return false;
    };
  }
  _bindLink(button, content, filename) {
    button.onclick = () => {
      this.downloadManager.downloadData(content, filename, '');
      return false;
    };
  }
  render({ attachments, keepRenderedCapability = false }) {
    let attachmentsCount = 0;
    if (this.attachments) {
      this.reset(keepRenderedCapability === true);
    }
    this.attachments = attachments || null;
    if (!attachments) {
      this._dispatchEvent(attachmentsCount);
      return;
    }
    let names = Object.keys(attachments).sort(function (a, b) {
      return a.toLowerCase().localeCompare(b.toLowerCase());
    });
    attachmentsCount = names.length;
    for (let i = 0; i < attachmentsCount; i++) {
      let item = attachments[names[i]];
      let filename = (0, _pdfjsLib.removeNullCharacters)((0, _pdfjsLib.getFilenameFromUrl)(item.filename));
      let div = document.createElement('div');
      div.className = 'attachmentsItem';
      let button = document.createElement('button');
      button.textContent = filename;
      if (/\.pdf$/i.test(filename) && !_pdfjsLib.PDFJS.disableCreateObjectURL) {
        this._bindPdfLink(button, item.content, filename);
      } else {
        this._bindLink(button, item.content, filename);
      }
      div.appendChild(button);
      this.container.appendChild(div);
    }
    this._dispatchEvent(attachmentsCount);
  }
  _appendAttachment({ id, filename, content }) {
    this._renderedCapability.promise.then(() => {
      let attachments = this.attachments;
      if (!attachments) {
        attachments = Object.create(null);
      } else {
        for (let name in attachments) {
          if (id === name) {
            return;
          }
        }
      }
      attachments[id] = {
        filename,
        content
      };
      this.render({
        attachments,
        keepRenderedCapability: true
      });
    });
  }
}
exports.PDFAttachmentViewer = PDFAttachmentViewer;

/***/ }),
/* 16 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFDocumentProperties = undefined;

var _ui_utils = __webpack_require__(0);

var _pdfjsLib = __webpack_require__(1);

const DEFAULT_FIELD_CONTENT = '-';
class PDFDocumentProperties {
  constructor({ overlayName, fields, container, closeButton }, overlayManager, l10n = _ui_utils.NullL10n) {
    this.overlayName = overlayName;
    this.fields = fields;
    this.container = container;
    this.overlayManager = overlayManager;
    this.l10n = l10n;
    this._reset();
    if (closeButton) {
      closeButton.addEventListener('click', this.close.bind(this));
    }
    this.overlayManager.register(this.overlayName, this.container, this.close.bind(this));
  }
  open() {
    let freezeFieldData = data => {
      Object.defineProperty(this, 'fieldData', {
        value: Object.freeze(data),
        writable: false,
        enumerable: true,
        configurable: true
      });
    };
    Promise.all([this.overlayManager.open(this.overlayName), this._dataAvailableCapability.promise]).then(() => {
      if (this.fieldData) {
        this._updateUI();
        return;
      }
      this.pdfDocument.getMetadata().then(({ info, metadata }) => {
        return Promise.all([info, metadata, this._parseFileSize(this.maybeFileSize), this._parseDate(info.CreationDate), this._parseDate(info.ModDate)]);
      }).then(([info, metadata, fileSize, creationDate, modificationDate]) => {
        freezeFieldData({
          'fileName': (0, _ui_utils.getPDFFileNameFromURL)(this.url),
          'fileSize': fileSize,
          'title': info.Title,
          'author': info.Author,
          'subject': info.Subject,
          'keywords': info.Keywords,
          'creationDate': creationDate,
          'modificationDate': modificationDate,
          'creator': info.Creator,
          'producer': info.Producer,
          'version': info.PDFFormatVersion,
          'pageCount': this.pdfDocument.numPages
        });
        this._updateUI();
        return this.pdfDocument.getDownloadInfo();
      }).then(({ length }) => {
        return this._parseFileSize(length);
      }).then(fileSize => {
        let data = (0, _ui_utils.cloneObj)(this.fieldData);
        data['fileSize'] = fileSize;
        freezeFieldData(data);
        this._updateUI();
      });
    });
  }
  close() {
    this.overlayManager.close(this.overlayName);
  }
  setDocument(pdfDocument, url) {
    if (this.pdfDocument) {
      this._reset();
      this._updateUI(true);
    }
    if (!pdfDocument) {
      return;
    }
    this.pdfDocument = pdfDocument;
    this.url = url;
    this._dataAvailableCapability.resolve();
  }
  setFileSize(fileSize) {
    if (typeof fileSize === 'number' && fileSize > 0) {
      this.maybeFileSize = fileSize;
    }
  }
  _reset() {
    this.pdfDocument = null;
    this.url = null;
    this.maybeFileSize = 0;
    delete this.fieldData;
    this._dataAvailableCapability = (0, _pdfjsLib.createPromiseCapability)();
  }
  _updateUI(reset = false) {
    if (reset || !this.fieldData) {
      for (let id in this.fields) {
        this.fields[id].textContent = DEFAULT_FIELD_CONTENT;
      }
      return;
    }
    if (this.overlayManager.active !== this.overlayName) {
      return;
    }
    for (let id in this.fields) {
      let content = this.fieldData[id];
      this.fields[id].textContent = content || content === 0 ? content : DEFAULT_FIELD_CONTENT;
    }
  }
  _parseFileSize(fileSize = 0) {
    let kb = fileSize / 1024;
    if (!kb) {
      return Promise.resolve(undefined);
    } else if (kb < 1024) {
      return this.l10n.get('document_properties_kb', {
        size_kb: (+kb.toPrecision(3)).toLocaleString(),
        size_b: fileSize.toLocaleString()
      }, '{{size_kb}} KB ({{size_b}} bytes)');
    }
    return this.l10n.get('document_properties_mb', {
      size_mb: (+(kb / 1024).toPrecision(3)).toLocaleString(),
      size_b: fileSize.toLocaleString()
    }, '{{size_mb}} MB ({{size_b}} bytes)');
  }
  _parseDate(inputDate) {
    if (!inputDate) {
      return;
    }
    let dateToParse = inputDate;
    if (dateToParse.substring(0, 2) === 'D:') {
      dateToParse = dateToParse.substring(2);
    }
    let year = parseInt(dateToParse.substring(0, 4), 10);
    let month = parseInt(dateToParse.substring(4, 6), 10) - 1;
    let day = parseInt(dateToParse.substring(6, 8), 10);
    let hours = parseInt(dateToParse.substring(8, 10), 10);
    let minutes = parseInt(dateToParse.substring(10, 12), 10);
    let seconds = parseInt(dateToParse.substring(12, 14), 10);
    let utRel = dateToParse.substring(14, 15);
    let offsetHours = parseInt(dateToParse.substring(15, 17), 10);
    let offsetMinutes = parseInt(dateToParse.substring(18, 20), 10);
    if (utRel === '-') {
      hours += offsetHours;
      minutes += offsetMinutes;
    } else if (utRel === '+') {
      hours -= offsetHours;
      minutes -= offsetMinutes;
    }
    let date = new Date(Date.UTC(year, month, day, hours, minutes, seconds));
    let dateString = date.toLocaleDateString();
    let timeString = date.toLocaleTimeString();
    return this.l10n.get('document_properties_date_string', {
      date: dateString,
      time: timeString
    }, '{{date}}, {{time}}');
  }
}
exports.PDFDocumentProperties = PDFDocumentProperties;

/***/ }),
/* 17 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFFindBar = undefined;

var _pdf_find_controller = __webpack_require__(7);

var _ui_utils = __webpack_require__(0);

class PDFFindBar {
  constructor(options, l10n = _ui_utils.NullL10n) {
    this.opened = false;
    this.bar = options.bar || null;
    this.toggleButton = options.toggleButton || null;
    this.findField = options.findField || null;
    this.highlightAll = options.highlightAllCheckbox || null;
    this.caseSensitive = options.caseSensitiveCheckbox || null;
    this.findMsg = options.findMsg || null;
    this.findResultsCount = options.findResultsCount || null;
    this.findStatusIcon = options.findStatusIcon || null;
    this.findPreviousButton = options.findPreviousButton || null;
    this.findNextButton = options.findNextButton || null;
    this.findController = options.findController || null;
    this.eventBus = options.eventBus;
    this.l10n = l10n;
    if (this.findController === null) {
      throw new Error('PDFFindBar cannot be used without a ' + 'PDFFindController instance.');
    }
    this.toggleButton.addEventListener('click', () => {
      this.toggle();
    });
    this.findField.addEventListener('input', () => {
      this.dispatchEvent('');
    });
    this.bar.addEventListener('keydown', e => {
      switch (e.keyCode) {
        case 13:
          if (e.target === this.findField) {
            this.dispatchEvent('again', e.shiftKey);
          }
          break;
        case 27:
          this.close();
          break;
      }
    });
    this.findPreviousButton.addEventListener('click', () => {
      this.dispatchEvent('again', true);
    });
    this.findNextButton.addEventListener('click', () => {
      this.dispatchEvent('again', false);
    });
    this.highlightAll.addEventListener('click', () => {
      this.dispatchEvent('highlightallchange');
    });
    this.caseSensitive.addEventListener('click', () => {
      this.dispatchEvent('casesensitivitychange');
    });
    this.eventBus.on('resize', this._adjustWidth.bind(this));
  }
  reset() {
    this.updateUIState();
  }
  dispatchEvent(type, findPrev) {
    this.eventBus.dispatch('find', {
      source: this,
      type,
      query: this.findField.value,
      caseSensitive: this.caseSensitive.checked,
      phraseSearch: true,
      highlightAll: this.highlightAll.checked,
      findPrevious: findPrev
    });
  }
  updateUIState(state, previous, matchCount) {
    let notFound = false;
    let findMsg = '';
    let status = '';
    switch (state) {
      case _pdf_find_controller.FindState.FOUND:
        break;
      case _pdf_find_controller.FindState.PENDING:
        status = 'pending';
        break;
      case _pdf_find_controller.FindState.NOT_FOUND:
        findMsg = this.l10n.get('find_not_found', null, 'Phrase not found');
        notFound = true;
        break;
      case _pdf_find_controller.FindState.WRAPPED:
        if (previous) {
          findMsg = this.l10n.get('find_reached_top', null, 'Reached top of document, continued from bottom');
        } else {
          findMsg = this.l10n.get('find_reached_bottom', null, 'Reached end of document, continued from top');
        }
        break;
    }
    if (notFound) {
      this.findField.classList.add('notFound');
    } else {
      this.findField.classList.remove('notFound');
    }
    this.findField.setAttribute('data-status', status);
    Promise.resolve(findMsg).then(msg => {
      this.findMsg.textContent = msg;
      this._adjustWidth();
    });
    this.updateResultsCount(matchCount);
  }
  updateResultsCount(matchCount) {
    if (!this.findResultsCount) {
      return;
    }
    if (!matchCount) {
      this.findResultsCount.classList.add('hidden');
      this.findResultsCount.textContent = '';
    } else {
      this.findResultsCount.textContent = matchCount.toLocaleString();
      this.findResultsCount.classList.remove('hidden');
    }
    this._adjustWidth();
  }
  open() {
    if (!this.opened) {
      this.opened = true;
      this.toggleButton.classList.add('toggled');
      this.bar.classList.remove('hidden');
    }
    this.findField.select();
    this.findField.focus();
    this._adjustWidth();
  }
  close() {
    if (!this.opened) {
      return;
    }
    this.opened = false;
    this.toggleButton.classList.remove('toggled');
    this.bar.classList.add('hidden');
    this.findController.active = false;
  }
  toggle() {
    if (this.opened) {
      this.close();
    } else {
      this.open();
    }
  }
  _adjustWidth() {
    if (!this.opened) {
      return;
    }
    this.bar.classList.remove('wrapContainers');
    let findbarHeight = this.bar.clientHeight;
    let inputContainerHeight = this.bar.firstElementChild.clientHeight;
    if (findbarHeight > inputContainerHeight) {
      this.bar.classList.add('wrapContainers');
    }
  }
}
exports.PDFFindBar = PDFFindBar;

/***/ }),
/* 18 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFHistory = undefined;

var _dom_events = __webpack_require__(2);

function PDFHistory(options) {
  this.linkService = options.linkService;
  this.eventBus = options.eventBus || (0, _dom_events.getGlobalEventBus)();
  this.initialized = false;
  this.initialDestination = null;
  this.initialBookmark = null;
}
PDFHistory.prototype = {
  initialize: function pdfHistoryInitialize(fingerprint) {
    this.initialized = true;
    this.reInitialized = false;
    this.allowHashChange = true;
    this.historyUnlocked = true;
    this.isViewerInPresentationMode = false;
    this.previousHash = window.location.hash.substring(1);
    this.currentBookmark = '';
    this.currentPage = 0;
    this.updatePreviousBookmark = false;
    this.previousBookmark = '';
    this.previousPage = 0;
    this.nextHashParam = '';
    this.fingerprint = fingerprint;
    this.currentUid = this.uid = 0;
    this.current = {};
    var state = window.history.state;
    if (this._isStateObjectDefined(state)) {
      if (state.target.dest) {
        this.initialDestination = state.target.dest;
      } else {
        this.initialBookmark = state.target.hash;
      }
      this.currentUid = state.uid;
      this.uid = state.uid + 1;
      this.current = state.target;
    } else {
      if (state && state.fingerprint && this.fingerprint !== state.fingerprint) {
        this.reInitialized = true;
      }
      this._pushOrReplaceState({ fingerprint: this.fingerprint }, true);
    }
    var self = this;
    window.addEventListener('popstate', function pdfHistoryPopstate(evt) {
      if (!self.historyUnlocked) {
        return;
      }
      if (evt.state) {
        self._goTo(evt.state);
        return;
      }
      if (self.uid === 0) {
        var previousParams = self.previousHash && self.currentBookmark && self.previousHash !== self.currentBookmark ? {
          hash: self.currentBookmark,
          page: self.currentPage
        } : { page: 1 };
        replacePreviousHistoryState(previousParams, function () {
          updateHistoryWithCurrentHash();
        });
      } else {
        updateHistoryWithCurrentHash();
      }
    });
    function updateHistoryWithCurrentHash() {
      self.previousHash = window.location.hash.slice(1);
      self._pushToHistory({ hash: self.previousHash }, false, true);
      self._updatePreviousBookmark();
    }
    function replacePreviousHistoryState(params, callback) {
      self.historyUnlocked = false;
      self.allowHashChange = false;
      window.addEventListener('popstate', rewriteHistoryAfterBack);
      history.back();
      function rewriteHistoryAfterBack() {
        window.removeEventListener('popstate', rewriteHistoryAfterBack);
        window.addEventListener('popstate', rewriteHistoryAfterForward);
        self._pushToHistory(params, false, true);
        history.forward();
      }
      function rewriteHistoryAfterForward() {
        window.removeEventListener('popstate', rewriteHistoryAfterForward);
        self.allowHashChange = true;
        self.historyUnlocked = true;
        callback();
      }
    }
    function pdfHistoryBeforeUnload() {
      var previousParams = self._getPreviousParams(null, true);
      if (previousParams) {
        var replacePrevious = !self.current.dest && self.current.hash !== self.previousHash;
        self._pushToHistory(previousParams, false, replacePrevious);
        self._updatePreviousBookmark();
      }
      window.removeEventListener('beforeunload', pdfHistoryBeforeUnload);
    }
    window.addEventListener('beforeunload', pdfHistoryBeforeUnload);
    window.addEventListener('pageshow', function pdfHistoryPageShow(evt) {
      window.addEventListener('beforeunload', pdfHistoryBeforeUnload);
    });
    self.eventBus.on('presentationmodechanged', function (e) {
      self.isViewerInPresentationMode = e.active;
    });
  },
  clearHistoryState: function pdfHistory_clearHistoryState() {
    this._pushOrReplaceState(null, true);
  },
  _isStateObjectDefined: function pdfHistory_isStateObjectDefined(state) {
    return state && state.uid >= 0 && state.fingerprint && this.fingerprint === state.fingerprint && state.target && state.target.hash ? true : false;
  },
  _pushOrReplaceState: function pdfHistory_pushOrReplaceState(stateObj, replace) {
    if (replace) {
      window.history.replaceState(stateObj, '');
    } else {
      window.history.pushState(stateObj, '');
    }
  },
  get isHashChangeUnlocked() {
    if (!this.initialized) {
      return true;
    }
    return this.allowHashChange;
  },
  _updatePreviousBookmark: function pdfHistory_updatePreviousBookmark() {
    if (this.updatePreviousBookmark && this.currentBookmark && this.currentPage) {
      this.previousBookmark = this.currentBookmark;
      this.previousPage = this.currentPage;
      this.updatePreviousBookmark = false;
    }
  },
  updateCurrentBookmark: function pdfHistoryUpdateCurrentBookmark(bookmark, pageNum) {
    if (this.initialized) {
      this.currentBookmark = bookmark.substring(1);
      this.currentPage = pageNum | 0;
      this._updatePreviousBookmark();
    }
  },
  updateNextHashParam: function pdfHistoryUpdateNextHashParam(param) {
    if (this.initialized) {
      this.nextHashParam = param;
    }
  },
  push: function pdfHistoryPush(params, isInitialBookmark) {
    if (!(this.initialized && this.historyUnlocked)) {
      return;
    }
    if (params.dest && !params.hash) {
      params.hash = this.current.hash && this.current.dest && this.current.dest === params.dest ? this.current.hash : this.linkService.getDestinationHash(params.dest).split('#')[1];
    }
    if (params.page) {
      params.page |= 0;
    }
    if (isInitialBookmark) {
      var target = window.history.state.target;
      if (!target) {
        this._pushToHistory(params, false);
        this.previousHash = window.location.hash.substring(1);
      }
      this.updatePreviousBookmark = this.nextHashParam ? false : true;
      if (target) {
        this._updatePreviousBookmark();
      }
      return;
    }
    if (this.nextHashParam) {
      if (this.nextHashParam === params.hash) {
        this.nextHashParam = null;
        this.updatePreviousBookmark = true;
        return;
      }
      this.nextHashParam = null;
    }
    if (params.hash) {
      if (this.current.hash) {
        if (this.current.hash !== params.hash) {
          this._pushToHistory(params, true);
        } else {
          if (!this.current.page && params.page) {
            this._pushToHistory(params, false, true);
          }
          this.updatePreviousBookmark = true;
        }
      } else {
        this._pushToHistory(params, true);
      }
    } else if (this.current.page && params.page && this.current.page !== params.page) {
      this._pushToHistory(params, true);
    }
  },
  _getPreviousParams: function pdfHistory_getPreviousParams(onlyCheckPage, beforeUnload) {
    if (!(this.currentBookmark && this.currentPage)) {
      return null;
    } else if (this.updatePreviousBookmark) {
      this.updatePreviousBookmark = false;
    }
    if (this.uid > 0 && !(this.previousBookmark && this.previousPage)) {
      return null;
    }
    if (!this.current.dest && !onlyCheckPage || beforeUnload) {
      if (this.previousBookmark === this.currentBookmark) {
        return null;
      }
    } else if (this.current.page || onlyCheckPage) {
      if (this.previousPage === this.currentPage) {
        return null;
      }
    } else {
      return null;
    }
    var params = {
      hash: this.currentBookmark,
      page: this.currentPage
    };
    if (this.isViewerInPresentationMode) {
      params.hash = null;
    }
    return params;
  },
  _stateObj: function pdfHistory_stateObj(params) {
    return {
      fingerprint: this.fingerprint,
      uid: this.uid,
      target: params
    };
  },
  _pushToHistory: function pdfHistory_pushToHistory(params, addPrevious, overwrite) {
    if (!this.initialized) {
      return;
    }
    if (!params.hash && params.page) {
      params.hash = 'page=' + params.page;
    }
    if (addPrevious && !overwrite) {
      var previousParams = this._getPreviousParams();
      if (previousParams) {
        var replacePrevious = !this.current.dest && this.current.hash !== this.previousHash;
        this._pushToHistory(previousParams, false, replacePrevious);
      }
    }
    this._pushOrReplaceState(this._stateObj(params), overwrite || this.uid === 0);
    this.currentUid = this.uid++;
    this.current = params;
    this.updatePreviousBookmark = true;
  },
  _goTo: function pdfHistory_goTo(state) {
    if (!(this.initialized && this.historyUnlocked && this._isStateObjectDefined(state))) {
      return;
    }
    if (!this.reInitialized && state.uid < this.currentUid) {
      var previousParams = this._getPreviousParams(true);
      if (previousParams) {
        this._pushToHistory(this.current, false);
        this._pushToHistory(previousParams, false);
        this.currentUid = state.uid;
        window.history.back();
        return;
      }
    }
    this.historyUnlocked = false;
    if (state.target.dest) {
      this.linkService.navigateTo(state.target.dest);
    } else {
      this.linkService.setHash(state.target.hash);
    }
    this.currentUid = state.uid;
    if (state.uid > this.uid) {
      this.uid = state.uid;
    }
    this.current = state.target;
    this.updatePreviousBookmark = true;
    var currentHash = window.location.hash.substring(1);
    if (this.previousHash !== currentHash) {
      this.allowHashChange = false;
    }
    this.previousHash = currentHash;
    this.historyUnlocked = true;
  },
  back: function pdfHistoryBack() {
    this.go(-1);
  },
  forward: function pdfHistoryForward() {
    this.go(1);
  },
  go: function pdfHistoryGo(direction) {
    if (this.initialized && this.historyUnlocked) {
      var state = window.history.state;
      if (direction === -1 && state && state.uid > 0) {
        window.history.back();
      } else if (direction === 1 && state && state.uid < this.uid - 1) {
        window.history.forward();
      }
    }
  }
};
exports.PDFHistory = PDFHistory;

/***/ }),
/* 19 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFOutlineViewer = undefined;

var _pdfjsLib = __webpack_require__(1);

const DEFAULT_TITLE = '\u2013';
class PDFOutlineViewer {
  constructor({ container, linkService, eventBus }) {
    this.outline = null;
    this.lastToggleIsShow = true;
    this.container = container;
    this.linkService = linkService;
    this.eventBus = eventBus;
  }
  reset() {
    this.outline = null;
    this.lastToggleIsShow = true;
    this.container.textContent = '';
    this.container.classList.remove('outlineWithDeepNesting');
  }
  _dispatchEvent(outlineCount) {
    this.eventBus.dispatch('outlineloaded', {
      source: this,
      outlineCount
    });
  }
  _bindLink(element, item) {
    if (item.url) {
      (0, _pdfjsLib.addLinkAttributes)(element, {
        url: item.url,
        target: item.newWindow ? _pdfjsLib.PDFJS.LinkTarget.BLANK : undefined
      });
      return;
    }
    let destination = item.dest;
    element.href = this.linkService.getDestinationHash(destination);
    element.onclick = () => {
      if (destination) {
        this.linkService.navigateTo(destination);
      }
      return false;
    };
  }
  _setStyles(element, item) {
    let styleStr = '';
    if (item.bold) {
      styleStr += 'font-weight: bold;';
    }
    if (item.italic) {
      styleStr += 'font-style: italic;';
    }
    if (styleStr) {
      element.setAttribute('style', styleStr);
    }
  }
  _addToggleButton(div) {
    let toggler = document.createElement('div');
    toggler.className = 'outlineItemToggler';
    toggler.onclick = evt => {
      evt.stopPropagation();
      toggler.classList.toggle('outlineItemsHidden');
      if (evt.shiftKey) {
        let shouldShowAll = !toggler.classList.contains('outlineItemsHidden');
        this._toggleOutlineItem(div, shouldShowAll);
      }
    };
    div.insertBefore(toggler, div.firstChild);
  }
  _toggleOutlineItem(root, show) {
    this.lastToggleIsShow = show;
    let togglers = root.querySelectorAll('.outlineItemToggler');
    for (let i = 0, ii = togglers.length; i < ii; ++i) {
      togglers[i].classList[show ? 'remove' : 'add']('outlineItemsHidden');
    }
  }
  toggleOutlineTree() {
    if (!this.outline) {
      return;
    }
    this._toggleOutlineItem(this.container, !this.lastToggleIsShow);
  }
  render({ outline }) {
    let outlineCount = 0;
    if (this.outline) {
      this.reset();
    }
    this.outline = outline || null;
    if (!outline) {
      this._dispatchEvent(outlineCount);
      return;
    }
    let fragment = document.createDocumentFragment();
    let queue = [{
      parent: fragment,
      items: this.outline
    }];
    let hasAnyNesting = false;
    while (queue.length > 0) {
      let levelData = queue.shift();
      for (let i = 0, len = levelData.items.length; i < len; i++) {
        let item = levelData.items[i];
        let div = document.createElement('div');
        div.className = 'outlineItem';
        let element = document.createElement('a');
        this._bindLink(element, item);
        this._setStyles(element, item);
        element.textContent = (0, _pdfjsLib.removeNullCharacters)(item.title) || DEFAULT_TITLE;
        div.appendChild(element);
        if (item.items.length > 0) {
          hasAnyNesting = true;
          this._addToggleButton(div);
          let itemsDiv = document.createElement('div');
          itemsDiv.className = 'outlineItems';
          div.appendChild(itemsDiv);
          queue.push({
            parent: itemsDiv,
            items: item.items
          });
        }
        levelData.parent.appendChild(div);
        outlineCount++;
      }
    }
    if (hasAnyNesting) {
      this.container.classList.add('outlineWithDeepNesting');
    }
    this.container.appendChild(fragment);
    this._dispatchEvent(outlineCount);
  }
}
exports.PDFOutlineViewer = PDFOutlineViewer;

/***/ }),
/* 20 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFPageView = undefined;

var _ui_utils = __webpack_require__(0);

var _pdfjsLib = __webpack_require__(1);

var _dom_events = __webpack_require__(2);

var _pdf_rendering_queue = __webpack_require__(3);

class PDFPageView {
  constructor(options) {
    let container = options.container;
    let defaultViewport = options.defaultViewport;
    this.id = options.id;
    this.renderingId = 'page' + this.id;
    this.pdfPage = null;
    this.pageLabel = null;
    this.rotation = 0;
    this.scale = options.scale || _ui_utils.DEFAULT_SCALE;
    this.viewport = defaultViewport;
    this.pdfPageRotate = defaultViewport.rotation;
    this.hasRestrictedScaling = false;
    this.enhanceTextSelection = options.enhanceTextSelection || false;
    this.renderInteractiveForms = options.renderInteractiveForms || false;
    this.eventBus = options.eventBus || (0, _dom_events.getGlobalEventBus)();
    this.renderingQueue = options.renderingQueue;
    this.textLayerFactory = options.textLayerFactory;
    this.annotationLayerFactory = options.annotationLayerFactory;
    this.renderer = options.renderer || _ui_utils.RendererType.CANVAS;
    this.l10n = options.l10n || _ui_utils.NullL10n;
    this.paintTask = null;
    this.paintedViewportMap = new WeakMap();
    this.renderingState = _pdf_rendering_queue.RenderingStates.INITIAL;
    this.resume = null;
    this.error = null;
    this.onBeforeDraw = null;
    this.onAfterDraw = null;
    this.annotationLayer = null;
    this.textLayer = null;
    this.zoomLayer = null;
    let div = document.createElement('div');
    div.className = 'page';
    div.style.width = Math.floor(this.viewport.width) + 'px';
    div.style.height = Math.floor(this.viewport.height) + 'px';
    div.setAttribute('data-page-number', this.id);
    this.div = div;
    container.appendChild(div);
  }
  setPdfPage(pdfPage) {
    this.pdfPage = pdfPage;
    this.pdfPageRotate = pdfPage.rotate;
    let totalRotation = (this.rotation + this.pdfPageRotate) % 360;
    this.viewport = pdfPage.getViewport(this.scale * _ui_utils.CSS_UNITS, totalRotation);
    this.stats = pdfPage.stats;
    this.reset();
  }
  destroy() {
    this.reset();
    if (this.pdfPage) {
      this.pdfPage.cleanup();
    }
  }
  _resetZoomLayer(removeFromDOM = false) {
    if (!this.zoomLayer) {
      return;
    }
    let zoomLayerCanvas = this.zoomLayer.firstChild;
    this.paintedViewportMap.delete(zoomLayerCanvas);
    zoomLayerCanvas.width = 0;
    zoomLayerCanvas.height = 0;
    if (removeFromDOM) {
      this.zoomLayer.remove();
    }
    this.zoomLayer = null;
  }
  reset(keepZoomLayer = false, keepAnnotations = false) {
    this.cancelRendering();
    let div = this.div;
    div.style.width = Math.floor(this.viewport.width) + 'px';
    div.style.height = Math.floor(this.viewport.height) + 'px';
    let childNodes = div.childNodes;
    let currentZoomLayerNode = keepZoomLayer && this.zoomLayer || null;
    let currentAnnotationNode = keepAnnotations && this.annotationLayer && this.annotationLayer.div || null;
    for (let i = childNodes.length - 1; i >= 0; i--) {
      let node = childNodes[i];
      if (currentZoomLayerNode === node || currentAnnotationNode === node) {
        continue;
      }
      div.removeChild(node);
    }
    div.removeAttribute('data-loaded');
    if (currentAnnotationNode) {
      this.annotationLayer.hide();
    } else {
      this.annotationLayer = null;
    }
    if (!currentZoomLayerNode) {
      if (this.canvas) {
        this.paintedViewportMap.delete(this.canvas);
        this.canvas.width = 0;
        this.canvas.height = 0;
        delete this.canvas;
      }
      this._resetZoomLayer();
    }
    if (this.svg) {
      this.paintedViewportMap.delete(this.svg);
      delete this.svg;
    }
    this.loadingIconDiv = document.createElement('div');
    this.loadingIconDiv.className = 'loadingIcon';
    div.appendChild(this.loadingIconDiv);
  }
  update(scale, rotation) {
    this.scale = scale || this.scale;
    if (typeof rotation !== 'undefined') {
      this.rotation = rotation;
    }
    let totalRotation = (this.rotation + this.pdfPageRotate) % 360;
    this.viewport = this.viewport.clone({
      scale: this.scale * _ui_utils.CSS_UNITS,
      rotation: totalRotation
    });
    if (this.svg) {
      this.cssTransform(this.svg, true);
      this.eventBus.dispatch('pagerendered', {
        source: this,
        pageNumber: this.id,
        cssTransform: true
      });
      return;
    }
    let isScalingRestricted = false;
    if (this.canvas && _pdfjsLib.PDFJS.maxCanvasPixels > 0) {
      let outputScale = this.outputScale;
      if ((Math.floor(this.viewport.width) * outputScale.sx | 0) * (Math.floor(this.viewport.height) * outputScale.sy | 0) > _pdfjsLib.PDFJS.maxCanvasPixels) {
        isScalingRestricted = true;
      }
    }
    if (this.canvas) {
      if (_pdfjsLib.PDFJS.useOnlyCssZoom || this.hasRestrictedScaling && isScalingRestricted) {
        this.cssTransform(this.canvas, true);
        this.eventBus.dispatch('pagerendered', {
          source: this,
          pageNumber: this.id,
          cssTransform: true
        });
        return;
      }
      if (!this.zoomLayer && !this.canvas.hasAttribute('hidden')) {
        this.zoomLayer = this.canvas.parentNode;
        this.zoomLayer.style.position = 'absolute';
      }
    }
    if (this.zoomLayer) {
      this.cssTransform(this.zoomLayer.firstChild);
    }
    this.reset(true, true);
  }
  cancelRendering() {
    if (this.paintTask) {
      this.paintTask.cancel();
      this.paintTask = null;
    }
    this.renderingState = _pdf_rendering_queue.RenderingStates.INITIAL;
    this.resume = null;
    if (this.textLayer) {
      this.textLayer.cancel();
      this.textLayer = null;
    }
  }
  cssTransform(target, redrawAnnotations = false) {
    let width = this.viewport.width;
    let height = this.viewport.height;
    let div = this.div;
    target.style.width = target.parentNode.style.width = div.style.width = Math.floor(width) + 'px';
    target.style.height = target.parentNode.style.height = div.style.height = Math.floor(height) + 'px';
    let relativeRotation = this.viewport.rotation - this.paintedViewportMap.get(target).rotation;
    let absRotation = Math.abs(relativeRotation);
    let scaleX = 1,
        scaleY = 1;
    if (absRotation === 90 || absRotation === 270) {
      scaleX = height / width;
      scaleY = width / height;
    }
    let cssTransform = 'rotate(' + relativeRotation + 'deg) ' + 'scale(' + scaleX + ',' + scaleY + ')';
    _pdfjsLib.CustomStyle.setProp('transform', target, cssTransform);
    if (this.textLayer) {
      let textLayerViewport = this.textLayer.viewport;
      let textRelativeRotation = this.viewport.rotation - textLayerViewport.rotation;
      let textAbsRotation = Math.abs(textRelativeRotation);
      let scale = width / textLayerViewport.width;
      if (textAbsRotation === 90 || textAbsRotation === 270) {
        scale = width / textLayerViewport.height;
      }
      let textLayerDiv = this.textLayer.textLayerDiv;
      let transX, transY;
      switch (textAbsRotation) {
        case 0:
          transX = transY = 0;
          break;
        case 90:
          transX = 0;
          transY = '-' + textLayerDiv.style.height;
          break;
        case 180:
          transX = '-' + textLayerDiv.style.width;
          transY = '-' + textLayerDiv.style.height;
          break;
        case 270:
          transX = '-' + textLayerDiv.style.width;
          transY = 0;
          break;
        default:
          console.error('Bad rotation value.');
          break;
      }
      _pdfjsLib.CustomStyle.setProp('transform', textLayerDiv, 'rotate(' + textAbsRotation + 'deg) ' + 'scale(' + scale + ', ' + scale + ') ' + 'translate(' + transX + ', ' + transY + ')');
      _pdfjsLib.CustomStyle.setProp('transformOrigin', textLayerDiv, '0% 0%');
    }
    if (redrawAnnotations && this.annotationLayer) {
      this.annotationLayer.render(this.viewport, 'display');
    }
  }
  get width() {
    return this.viewport.width;
  }
  get height() {
    return this.viewport.height;
  }
  getPagePoint(x, y) {
    return this.viewport.convertToPdfPoint(x, y);
  }
  draw() {
    if (this.renderingState !== _pdf_rendering_queue.RenderingStates.INITIAL) {
      console.error('Must be in new state before drawing');
      this.reset();
    }
    if (!this.pdfPage) {
      this.renderingState = _pdf_rendering_queue.RenderingStates.FINISHED;
      return Promise.reject(new Error('Page is not loaded'));
    }
    this.renderingState = _pdf_rendering_queue.RenderingStates.RUNNING;
    let pdfPage = this.pdfPage;
    let div = this.div;
    let canvasWrapper = document.createElement('div');
    canvasWrapper.style.width = div.style.width;
    canvasWrapper.style.height = div.style.height;
    canvasWrapper.classList.add('canvasWrapper');
    if (this.annotationLayer && this.annotationLayer.div) {
      div.insertBefore(canvasWrapper, this.annotationLayer.div);
    } else {
      div.appendChild(canvasWrapper);
    }
    let textLayer = null;
    if (this.textLayerFactory) {
      let textLayerDiv = document.createElement('div');
      textLayerDiv.className = 'textLayer';
      textLayerDiv.style.width = canvasWrapper.style.width;
      textLayerDiv.style.height = canvasWrapper.style.height;
      if (this.annotationLayer && this.annotationLayer.div) {
        div.insertBefore(textLayerDiv, this.annotationLayer.div);
      } else {
        div.appendChild(textLayerDiv);
      }
      textLayer = this.textLayerFactory.createTextLayerBuilder(textLayerDiv, this.id - 1, this.viewport, this.enhanceTextSelection);
    }
    this.textLayer = textLayer;
    let renderContinueCallback = null;
    if (this.renderingQueue) {
      renderContinueCallback = cont => {
        if (!this.renderingQueue.isHighestPriority(this)) {
          this.renderingState = _pdf_rendering_queue.RenderingStates.PAUSED;
          this.resume = () => {
            this.renderingState = _pdf_rendering_queue.RenderingStates.RUNNING;
            cont();
          };
          return;
        }
        cont();
      };
    }
    let finishPaintTask = error => {
      if (paintTask === this.paintTask) {
        this.paintTask = null;
      }
      if (error instanceof _pdfjsLib.RenderingCancelledException) {
        this.error = null;
        return Promise.resolve(undefined);
      }
      this.renderingState = _pdf_rendering_queue.RenderingStates.FINISHED;
      if (this.loadingIconDiv) {
        div.removeChild(this.loadingIconDiv);
        delete this.loadingIconDiv;
      }
      this._resetZoomLayer(true);
      this.error = error;
      this.stats = pdfPage.stats;
      if (this.onAfterDraw) {
        this.onAfterDraw();
      }
      this.eventBus.dispatch('pagerendered', {
        source: this,
        pageNumber: this.id,
        cssTransform: false
      });
      if (error) {
        return Promise.reject(error);
      }
      return Promise.resolve(undefined);
    };
    let paintTask = this.renderer === _ui_utils.RendererType.SVG ? this.paintOnSvg(canvasWrapper) : this.paintOnCanvas(canvasWrapper);
    paintTask.onRenderContinue = renderContinueCallback;
    this.paintTask = paintTask;
    let resultPromise = paintTask.promise.then(function () {
      return finishPaintTask(null).then(function () {
        if (textLayer) {
          let readableStream = pdfPage.streamTextContent({ normalizeWhitespace: true });
          textLayer.setTextContentStream(readableStream);
          textLayer.render();
        }
      });
    }, function (reason) {
      return finishPaintTask(reason);
    });
    if (this.annotationLayerFactory) {
      if (!this.annotationLayer) {
        this.annotationLayer = this.annotationLayerFactory.createAnnotationLayerBuilder(div, pdfPage, this.renderInteractiveForms, this.l10n);
      }
      this.annotationLayer.render(this.viewport, 'display');
    }
    div.setAttribute('data-loaded', true);
    if (this.onBeforeDraw) {
      this.onBeforeDraw();
    }
    return resultPromise;
  }
  paintOnCanvas(canvasWrapper) {
    let renderCapability = (0, _pdfjsLib.createPromiseCapability)();
    let result = {
      promise: renderCapability.promise,
      onRenderContinue(cont) {
        cont();
      },
      cancel() {
        renderTask.cancel();
      }
    };
    let viewport = this.viewport;
    let canvas = document.createElement('canvas');
    canvas.id = this.renderingId;
    canvas.setAttribute('hidden', 'hidden');
    let isCanvasHidden = true;
    let showCanvas = function () {
      if (isCanvasHidden) {
        canvas.removeAttribute('hidden');
        isCanvasHidden = false;
      }
    };
    canvasWrapper.appendChild(canvas);
    this.canvas = canvas;
    canvas.mozOpaque = true;
    let ctx = canvas.getContext('2d', { alpha: false });
    let outputScale = (0, _ui_utils.getOutputScale)(ctx);
    this.outputScale = outputScale;
    if (_pdfjsLib.PDFJS.useOnlyCssZoom) {
      let actualSizeViewport = viewport.clone({ scale: _ui_utils.CSS_UNITS });
      outputScale.sx *= actualSizeViewport.width / viewport.width;
      outputScale.sy *= actualSizeViewport.height / viewport.height;
      outputScale.scaled = true;
    }
    if (_pdfjsLib.PDFJS.maxCanvasPixels > 0) {
      let pixelsInViewport = viewport.width * viewport.height;
      let maxScale = Math.sqrt(_pdfjsLib.PDFJS.maxCanvasPixels / pixelsInViewport);
      if (outputScale.sx > maxScale || outputScale.sy > maxScale) {
        outputScale.sx = maxScale;
        outputScale.sy = maxScale;
        outputScale.scaled = true;
        this.hasRestrictedScaling = true;
      } else {
        this.hasRestrictedScaling = false;
      }
    }
    let sfx = (0, _ui_utils.approximateFraction)(outputScale.sx);
    let sfy = (0, _ui_utils.approximateFraction)(outputScale.sy);
    canvas.width = (0, _ui_utils.roundToDivide)(viewport.width * outputScale.sx, sfx[0]);
    canvas.height = (0, _ui_utils.roundToDivide)(viewport.height * outputScale.sy, sfy[0]);
    canvas.style.width = (0, _ui_utils.roundToDivide)(viewport.width, sfx[1]) + 'px';
    canvas.style.height = (0, _ui_utils.roundToDivide)(viewport.height, sfy[1]) + 'px';
    this.paintedViewportMap.set(canvas, viewport);
    let transform = !outputScale.scaled ? null : [outputScale.sx, 0, 0, outputScale.sy, 0, 0];
    let renderContext = {
      canvasContext: ctx,
      transform,
      viewport: this.viewport,
      renderInteractiveForms: this.renderInteractiveForms
    };
    let renderTask = this.pdfPage.render(renderContext);
    renderTask.onContinue = function (cont) {
      showCanvas();
      if (result.onRenderContinue) {
        result.onRenderContinue(cont);
      } else {
        cont();
      }
    };
    renderTask.promise.then(function () {
      showCanvas();
      renderCapability.resolve(undefined);
    }, function (error) {
      showCanvas();
      renderCapability.reject(error);
    });
    return result;
  }
  paintOnSvg(wrapper) {
    return {
      promise: Promise.reject(new Error('SVG rendering is not supported.')),
      onRenderContinue(cont) {},
      cancel() {}
    };
  }
  setPageLabel(label) {
    this.pageLabel = typeof label === 'string' ? label : null;
    if (this.pageLabel !== null) {
      this.div.setAttribute('data-page-label', this.pageLabel);
    } else {
      this.div.removeAttribute('data-page-label');
    }
  }
}
exports.PDFPageView = PDFPageView;

/***/ }),
/* 21 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFPresentationMode = undefined;

var _ui_utils = __webpack_require__(0);

const DELAY_BEFORE_RESETTING_SWITCH_IN_PROGRESS = 1500;
const DELAY_BEFORE_HIDING_CONTROLS = 3000;
const ACTIVE_SELECTOR = 'pdfPresentationMode';
const CONTROLS_SELECTOR = 'pdfPresentationModeControls';
const MOUSE_SCROLL_COOLDOWN_TIME = 50;
const PAGE_SWITCH_THRESHOLD = 0.1;
const SWIPE_MIN_DISTANCE_THRESHOLD = 50;
const SWIPE_ANGLE_THRESHOLD = Math.PI / 6;
class PDFPresentationMode {
  constructor({ container, viewer = null, pdfViewer, eventBus, contextMenuItems = null }) {
    this.container = container;
    this.viewer = viewer || container.firstElementChild;
    this.pdfViewer = pdfViewer;
    this.eventBus = eventBus;
    this.active = false;
    this.args = null;
    this.contextMenuOpen = false;
    this.mouseScrollTimeStamp = 0;
    this.mouseScrollDelta = 0;
    this.touchSwipeState = null;
    if (contextMenuItems) {
      contextMenuItems.contextFirstPage.addEventListener('click', () => {
        this.contextMenuOpen = false;
        this.eventBus.dispatch('firstpage');
      });
      contextMenuItems.contextLastPage.addEventListener('click', () => {
        this.contextMenuOpen = false;
        this.eventBus.dispatch('lastpage');
      });
      contextMenuItems.contextPageRotateCw.addEventListener('click', () => {
        this.contextMenuOpen = false;
        this.eventBus.dispatch('rotatecw');
      });
      contextMenuItems.contextPageRotateCcw.addEventListener('click', () => {
        this.contextMenuOpen = false;
        this.eventBus.dispatch('rotateccw');
      });
    }
  }
  request() {
    if (this.switchInProgress || this.active || !this.viewer.hasChildNodes()) {
      return false;
    }
    this._addFullscreenChangeListeners();
    this._setSwitchInProgress();
    this._notifyStateChange();
    if (this.container.requestFullscreen) {
      this.container.requestFullscreen();
    } else if (this.container.mozRequestFullScreen) {
      this.container.mozRequestFullScreen();
    } else if (this.container.webkitRequestFullscreen) {
      this.container.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
    } else if (this.container.msRequestFullscreen) {
      this.container.msRequestFullscreen();
    } else {
      return false;
    }
    this.args = {
      page: this.pdfViewer.currentPageNumber,
      previousScale: this.pdfViewer.currentScaleValue
    };
    return true;
  }
  _mouseWheel(evt) {
    if (!this.active) {
      return;
    }
    evt.preventDefault();
    let delta = (0, _ui_utils.normalizeWheelEventDelta)(evt);
    let currentTime = new Date().getTime();
    let storedTime = this.mouseScrollTimeStamp;
    if (currentTime > storedTime && currentTime - storedTime < MOUSE_SCROLL_COOLDOWN_TIME) {
      return;
    }
    if (this.mouseScrollDelta > 0 && delta < 0 || this.mouseScrollDelta < 0 && delta > 0) {
      this._resetMouseScrollState();
    }
    this.mouseScrollDelta += delta;
    if (Math.abs(this.mouseScrollDelta) >= PAGE_SWITCH_THRESHOLD) {
      let totalDelta = this.mouseScrollDelta;
      this._resetMouseScrollState();
      let success = totalDelta > 0 ? this._goToPreviousPage() : this._goToNextPage();
      if (success) {
        this.mouseScrollTimeStamp = currentTime;
      }
    }
  }
  get isFullscreen() {
    return !!(document.fullscreenElement || document.mozFullScreen || document.webkitIsFullScreen || document.msFullscreenElement);
  }
  _goToPreviousPage() {
    let page = this.pdfViewer.currentPageNumber;
    if (page <= 1) {
      return false;
    }
    this.pdfViewer.currentPageNumber = page - 1;
    return true;
  }
  _goToNextPage() {
    let page = this.pdfViewer.currentPageNumber;
    if (page >= this.pdfViewer.pagesCount) {
      return false;
    }
    this.pdfViewer.currentPageNumber = page + 1;
    return true;
  }
  _notifyStateChange() {
    this.eventBus.dispatch('presentationmodechanged', {
      source: this,
      active: this.active,
      switchInProgress: !!this.switchInProgress
    });
  }
  _setSwitchInProgress() {
    if (this.switchInProgress) {
      clearTimeout(this.switchInProgress);
    }
    this.switchInProgress = setTimeout(() => {
      this._removeFullscreenChangeListeners();
      delete this.switchInProgress;
      this._notifyStateChange();
    }, DELAY_BEFORE_RESETTING_SWITCH_IN_PROGRESS);
  }
  _resetSwitchInProgress() {
    if (this.switchInProgress) {
      clearTimeout(this.switchInProgress);
      delete this.switchInProgress;
    }
  }
  _enter() {
    this.active = true;
    this._resetSwitchInProgress();
    this._notifyStateChange();
    this.container.classList.add(ACTIVE_SELECTOR);
    setTimeout(() => {
      this.pdfViewer.currentPageNumber = this.args.page;
      this.pdfViewer.currentScaleValue = 'page-fit';
    }, 0);
    this._addWindowListeners();
    this._showControls();
    this.contextMenuOpen = false;
    this.container.setAttribute('contextmenu', 'viewerContextMenu');
    window.getSelection().removeAllRanges();
  }
  _exit() {
    let page = this.pdfViewer.currentPageNumber;
    this.container.classList.remove(ACTIVE_SELECTOR);
    setTimeout(() => {
      this.active = false;
      this._removeFullscreenChangeListeners();
      this._notifyStateChange();
      this.pdfViewer.currentScaleValue = this.args.previousScale;
      this.pdfViewer.currentPageNumber = page;
      this.args = null;
    }, 0);
    this._removeWindowListeners();
    this._hideControls();
    this._resetMouseScrollState();
    this.container.removeAttribute('contextmenu');
    this.contextMenuOpen = false;
  }
  _mouseDown(evt) {
    if (this.contextMenuOpen) {
      this.contextMenuOpen = false;
      evt.preventDefault();
      return;
    }
    if (evt.button === 0) {
      let isInternalLink = evt.target.href && evt.target.classList.contains('internalLink');
      if (!isInternalLink) {
        evt.preventDefault();
        if (evt.shiftKey) {
          this._goToPreviousPage();
        } else {
          this._goToNextPage();
        }
      }
    }
  }
  _contextMenu() {
    this.contextMenuOpen = true;
  }
  _showControls() {
    if (this.controlsTimeout) {
      clearTimeout(this.controlsTimeout);
    } else {
      this.container.classList.add(CONTROLS_SELECTOR);
    }
    this.controlsTimeout = setTimeout(() => {
      this.container.classList.remove(CONTROLS_SELECTOR);
      delete this.controlsTimeout;
    }, DELAY_BEFORE_HIDING_CONTROLS);
  }
  _hideControls() {
    if (!this.controlsTimeout) {
      return;
    }
    clearTimeout(this.controlsTimeout);
    this.container.classList.remove(CONTROLS_SELECTOR);
    delete this.controlsTimeout;
  }
  _resetMouseScrollState() {
    this.mouseScrollTimeStamp = 0;
    this.mouseScrollDelta = 0;
  }
  _touchSwipe(evt) {
    if (!this.active) {
      return;
    }
    if (evt.touches.length > 1) {
      this.touchSwipeState = null;
      return;
    }
    switch (evt.type) {
      case 'touchstart':
        this.touchSwipeState = {
          startX: evt.touches[0].pageX,
          startY: evt.touches[0].pageY,
          endX: evt.touches[0].pageX,
          endY: evt.touches[0].pageY
        };
        break;
      case 'touchmove':
        if (this.touchSwipeState === null) {
          return;
        }
        this.touchSwipeState.endX = evt.touches[0].pageX;
        this.touchSwipeState.endY = evt.touches[0].pageY;
        evt.preventDefault();
        break;
      case 'touchend':
        if (this.touchSwipeState === null) {
          return;
        }
        let delta = 0;
        let dx = this.touchSwipeState.endX - this.touchSwipeState.startX;
        let dy = this.touchSwipeState.endY - this.touchSwipeState.startY;
        let absAngle = Math.abs(Math.atan2(dy, dx));
        if (Math.abs(dx) > SWIPE_MIN_DISTANCE_THRESHOLD && (absAngle <= SWIPE_ANGLE_THRESHOLD || absAngle >= Math.PI - SWIPE_ANGLE_THRESHOLD)) {
          delta = dx;
        } else if (Math.abs(dy) > SWIPE_MIN_DISTANCE_THRESHOLD && Math.abs(absAngle - Math.PI / 2) <= SWIPE_ANGLE_THRESHOLD) {
          delta = dy;
        }
        if (delta > 0) {
          this._goToPreviousPage();
        } else if (delta < 0) {
          this._goToNextPage();
        }
        break;
    }
  }
  _addWindowListeners() {
    this.showControlsBind = this._showControls.bind(this);
    this.mouseDownBind = this._mouseDown.bind(this);
    this.mouseWheelBind = this._mouseWheel.bind(this);
    this.resetMouseScrollStateBind = this._resetMouseScrollState.bind(this);
    this.contextMenuBind = this._contextMenu.bind(this);
    this.touchSwipeBind = this._touchSwipe.bind(this);
    window.addEventListener('mousemove', this.showControlsBind);
    window.addEventListener('mousedown', this.mouseDownBind);
    window.addEventListener('wheel', this.mouseWheelBind);
    window.addEventListener('keydown', this.resetMouseScrollStateBind);
    window.addEventListener('contextmenu', this.contextMenuBind);
    window.addEventListener('touchstart', this.touchSwipeBind);
    window.addEventListener('touchmove', this.touchSwipeBind);
    window.addEventListener('touchend', this.touchSwipeBind);
  }
  _removeWindowListeners() {
    window.removeEventListener('mousemove', this.showControlsBind);
    window.removeEventListener('mousedown', this.mouseDownBind);
    window.removeEventListener('wheel', this.mouseWheelBind);
    window.removeEventListener('keydown', this.resetMouseScrollStateBind);
    window.removeEventListener('contextmenu', this.contextMenuBind);
    window.removeEventListener('touchstart', this.touchSwipeBind);
    window.removeEventListener('touchmove', this.touchSwipeBind);
    window.removeEventListener('touchend', this.touchSwipeBind);
    delete this.showControlsBind;
    delete this.mouseDownBind;
    delete this.mouseWheelBind;
    delete this.resetMouseScrollStateBind;
    delete this.contextMenuBind;
    delete this.touchSwipeBind;
  }
  _fullscreenChange() {
    if (this.isFullscreen) {
      this._enter();
    } else {
      this._exit();
    }
  }
  _addFullscreenChangeListeners() {
    this.fullscreenChangeBind = this._fullscreenChange.bind(this);
    window.addEventListener('fullscreenchange', this.fullscreenChangeBind);
    window.addEventListener('mozfullscreenchange', this.fullscreenChangeBind);
  }
  _removeFullscreenChangeListeners() {
    window.removeEventListener('fullscreenchange', this.fullscreenChangeBind);
    window.removeEventListener('mozfullscreenchange', this.fullscreenChangeBind);
    delete this.fullscreenChangeBind;
  }
}
exports.PDFPresentationMode = PDFPresentationMode;

/***/ }),
/* 22 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFSidebar = exports.SidebarView = undefined;

var _ui_utils = __webpack_require__(0);

var _pdf_rendering_queue = __webpack_require__(3);

const UI_NOTIFICATION_CLASS = 'pdfSidebarNotification';
const SidebarView = {
  NONE: 0,
  THUMBS: 1,
  OUTLINE: 2,
  ATTACHMENTS: 3
};
class PDFSidebar {
  constructor(options, l10n = _ui_utils.NullL10n) {
    this.isOpen = false;
    this.active = SidebarView.THUMBS;
    this.isInitialViewSet = false;
    this.onToggled = null;
    this.pdfViewer = options.pdfViewer;
    this.pdfThumbnailViewer = options.pdfThumbnailViewer;
    this.pdfOutlineViewer = options.pdfOutlineViewer;
    this.mainContainer = options.mainContainer;
    this.outerContainer = options.outerContainer;
    this.eventBus = options.eventBus;
    this.toggleButton = options.toggleButton;
    this.thumbnailButton = options.thumbnailButton;
    this.outlineButton = options.outlineButton;
    this.attachmentsButton = options.attachmentsButton;
    this.thumbnailView = options.thumbnailView;
    this.outlineView = options.outlineView;
    this.attachmentsView = options.attachmentsView;
    this.disableNotification = options.disableNotification || false;
    this.l10n = l10n;
    this._addEventListeners();
  }
  reset() {
    this.isInitialViewSet = false;
    this._hideUINotification(null);
    this.switchView(SidebarView.THUMBS);
    this.outlineButton.disabled = false;
    this.attachmentsButton.disabled = false;
  }
  get visibleView() {
    return this.isOpen ? this.active : SidebarView.NONE;
  }
  get isThumbnailViewVisible() {
    return this.isOpen && this.active === SidebarView.THUMBS;
  }
  get isOutlineViewVisible() {
    return this.isOpen && this.active === SidebarView.OUTLINE;
  }
  get isAttachmentsViewVisible() {
    return this.isOpen && this.active === SidebarView.ATTACHMENTS;
  }
  setInitialView(view) {
    if (this.isInitialViewSet) {
      return;
    }
    this.isInitialViewSet = true;
    if (this.isOpen && view === SidebarView.NONE) {
      this._dispatchEvent();
      return;
    }
    let isViewPreserved = view === this.visibleView;
    this.switchView(view, true);
    if (isViewPreserved) {
      this._dispatchEvent();
    }
  }
  switchView(view, forceOpen = false) {
    if (view === SidebarView.NONE) {
      this.close();
      return;
    }
    let isViewChanged = view !== this.active;
    let shouldForceRendering = false;
    switch (view) {
      case SidebarView.THUMBS:
        this.thumbnailButton.classList.add('toggled');
        this.outlineButton.classList.remove('toggled');
        this.attachmentsButton.classList.remove('toggled');
        this.thumbnailView.classList.remove('hidden');
        this.outlineView.classList.add('hidden');
        this.attachmentsView.classList.add('hidden');
        if (this.isOpen && isViewChanged) {
          this._updateThumbnailViewer();
          shouldForceRendering = true;
        }
        break;
      case SidebarView.OUTLINE:
        if (this.outlineButton.disabled) {
          return;
        }
        this.thumbnailButton.classList.remove('toggled');
        this.outlineButton.classList.add('toggled');
        this.attachmentsButton.classList.remove('toggled');
        this.thumbnailView.classList.add('hidden');
        this.outlineView.classList.remove('hidden');
        this.attachmentsView.classList.add('hidden');
        break;
      case SidebarView.ATTACHMENTS:
        if (this.attachmentsButton.disabled) {
          return;
        }
        this.thumbnailButton.classList.remove('toggled');
        this.outlineButton.classList.remove('toggled');
        this.attachmentsButton.classList.add('toggled');
        this.thumbnailView.classList.add('hidden');
        this.outlineView.classList.add('hidden');
        this.attachmentsView.classList.remove('hidden');
        break;
      default:
        console.error('PDFSidebar_switchView: "' + view + '" is an unsupported value.');
        return;
    }
    this.active = view | 0;
    if (forceOpen && !this.isOpen) {
      this.open();
      return;
    }
    if (shouldForceRendering) {
      this._forceRendering();
    }
    if (isViewChanged) {
      this._dispatchEvent();
    }
    this._hideUINotification(this.active);
  }
  open() {
    if (this.isOpen) {
      return;
    }
    this.isOpen = true;
    this.toggleButton.classList.add('toggled');
    this.outerContainer.classList.add('sidebarMoving');
    this.outerContainer.classList.add('sidebarOpen');
    if (this.active === SidebarView.THUMBS) {
      this._updateThumbnailViewer();
    }
    this._forceRendering();
    this._dispatchEvent();
    this._hideUINotification(this.active);
  }
  close() {
    if (!this.isOpen) {
      return;
    }
    this.isOpen = false;
    this.toggleButton.classList.remove('toggled');
    this.outerContainer.classList.add('sidebarMoving');
    this.outerContainer.classList.remove('sidebarOpen');
    this._forceRendering();
    this._dispatchEvent();
  }
  toggle() {
    if (this.isOpen) {
      this.close();
    } else {
      this.open();
    }
  }
  _dispatchEvent() {
    this.eventBus.dispatch('sidebarviewchanged', {
      source: this,
      view: this.visibleView
    });
  }
  _forceRendering() {
    if (this.onToggled) {
      this.onToggled();
    } else {
      this.pdfViewer.forceRendering();
      this.pdfThumbnailViewer.forceRendering();
    }
  }
  _updateThumbnailViewer() {
    let { pdfViewer, pdfThumbnailViewer } = this;
    let pagesCount = pdfViewer.pagesCount;
    for (let pageIndex = 0; pageIndex < pagesCount; pageIndex++) {
      let pageView = pdfViewer.getPageView(pageIndex);
      if (pageView && pageView.renderingState === _pdf_rendering_queue.RenderingStates.FINISHED) {
        let thumbnailView = pdfThumbnailViewer.getThumbnail(pageIndex);
        thumbnailView.setImage(pageView);
      }
    }
    pdfThumbnailViewer.scrollThumbnailIntoView(pdfViewer.currentPageNumber);
  }
  _showUINotification(view) {
    if (this.disableNotification) {
      return;
    }
    this.l10n.get('toggle_sidebar_notification.title', null, 'Toggle Sidebar (document contains outline/attachments)').then(msg => {
      this.toggleButton.title = msg;
    });
    if (!this.isOpen) {
      this.toggleButton.classList.add(UI_NOTIFICATION_CLASS);
    } else if (view === this.active) {
      return;
    }
    switch (view) {
      case SidebarView.OUTLINE:
        this.outlineButton.classList.add(UI_NOTIFICATION_CLASS);
        break;
      case SidebarView.ATTACHMENTS:
        this.attachmentsButton.classList.add(UI_NOTIFICATION_CLASS);
        break;
    }
  }
  _hideUINotification(view) {
    if (this.disableNotification) {
      return;
    }
    let removeNotification = view => {
      switch (view) {
        case SidebarView.OUTLINE:
          this.outlineButton.classList.remove(UI_NOTIFICATION_CLASS);
          break;
        case SidebarView.ATTACHMENTS:
          this.attachmentsButton.classList.remove(UI_NOTIFICATION_CLASS);
          break;
      }
    };
    if (!this.isOpen && view !== null) {
      return;
    }
    this.toggleButton.classList.remove(UI_NOTIFICATION_CLASS);
    if (view !== null) {
      removeNotification(view);
      return;
    }
    for (view in SidebarView) {
      removeNotification(SidebarView[view]);
    }
    this.l10n.get('toggle_sidebar.title', null, 'Toggle Sidebar').then(msg => {
      this.toggleButton.title = msg;
    });
  }
  _addEventListeners() {
    this.mainContainer.addEventListener('transitionend', evt => {
      if (evt.target === this.mainContainer) {
        this.outerContainer.classList.remove('sidebarMoving');
      }
    });
    this.thumbnailButton.addEventListener('click', () => {
      this.switchView(SidebarView.THUMBS);
    });
    this.outlineButton.addEventListener('click', () => {
      this.switchView(SidebarView.OUTLINE);
    });
    this.outlineButton.addEventListener('dblclick', () => {
      this.pdfOutlineViewer.toggleOutlineTree();
    });
    this.attachmentsButton.addEventListener('click', () => {
      this.switchView(SidebarView.ATTACHMENTS);
    });
    this.eventBus.on('outlineloaded', evt => {
      let outlineCount = evt.outlineCount;
      this.outlineButton.disabled = !outlineCount;
      if (outlineCount) {
        this._showUINotification(SidebarView.OUTLINE);
      } else if (this.active === SidebarView.OUTLINE) {
        this.switchView(SidebarView.THUMBS);
      }
    });
    this.eventBus.on('attachmentsloaded', evt => {
      let attachmentsCount = evt.attachmentsCount;
      this.attachmentsButton.disabled = !attachmentsCount;
      if (attachmentsCount) {
        this._showUINotification(SidebarView.ATTACHMENTS);
      } else if (this.active === SidebarView.ATTACHMENTS) {
        this.switchView(SidebarView.THUMBS);
      }
    });
    this.eventBus.on('presentationmodechanged', evt => {
      if (!evt.active && !evt.switchInProgress && this.isThumbnailViewVisible) {
        this._updateThumbnailViewer();
      }
    });
  }
}
exports.SidebarView = SidebarView;
exports.PDFSidebar = PDFSidebar;

/***/ }),
/* 23 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFThumbnailView = undefined;

var _pdfjsLib = __webpack_require__(1);

var _ui_utils = __webpack_require__(0);

var _pdf_rendering_queue = __webpack_require__(3);

const MAX_NUM_SCALING_STEPS = 3;
const THUMBNAIL_CANVAS_BORDER_WIDTH = 1;
const THUMBNAIL_WIDTH = 98;
const TempImageFactory = function TempImageFactoryClosure() {
  let tempCanvasCache = null;
  return {
    getCanvas(width, height) {
      let tempCanvas = tempCanvasCache;
      if (!tempCanvas) {
        tempCanvas = document.createElement('canvas');
        tempCanvasCache = tempCanvas;
      }
      tempCanvas.width = width;
      tempCanvas.height = height;
      tempCanvas.mozOpaque = true;
      let ctx = tempCanvas.getContext('2d', { alpha: false });
      ctx.save();
      ctx.fillStyle = 'rgb(255, 255, 255)';
      ctx.fillRect(0, 0, width, height);
      ctx.restore();
      return tempCanvas;
    },
    destroyCanvas() {
      let tempCanvas = tempCanvasCache;
      if (tempCanvas) {
        tempCanvas.width = 0;
        tempCanvas.height = 0;
      }
      tempCanvasCache = null;
    }
  };
}();
class PDFThumbnailView {
  constructor({ container, id, defaultViewport, linkService, renderingQueue, disableCanvasToImageConversion = false, l10n = _ui_utils.NullL10n }) {
    this.id = id;
    this.renderingId = 'thumbnail' + id;
    this.pageLabel = null;
    this.pdfPage = null;
    this.rotation = 0;
    this.viewport = defaultViewport;
    this.pdfPageRotate = defaultViewport.rotation;
    this.linkService = linkService;
    this.renderingQueue = renderingQueue;
    this.renderTask = null;
    this.renderingState = _pdf_rendering_queue.RenderingStates.INITIAL;
    this.resume = null;
    this.disableCanvasToImageConversion = disableCanvasToImageConversion;
    this.pageWidth = this.viewport.width;
    this.pageHeight = this.viewport.height;
    this.pageRatio = this.pageWidth / this.pageHeight;
    this.canvasWidth = THUMBNAIL_WIDTH;
    this.canvasHeight = this.canvasWidth / this.pageRatio | 0;
    this.scale = this.canvasWidth / this.pageWidth;
    this.l10n = l10n;
    let anchor = document.createElement('a');
    anchor.href = linkService.getAnchorUrl('#page=' + id);
    this.l10n.get('thumb_page_title', { page: id }, 'Page {{page}}').then(msg => {
      anchor.title = msg;
    });
    anchor.onclick = function () {
      linkService.page = id;
      return false;
    };
    this.anchor = anchor;
    let div = document.createElement('div');
    div.className = 'thumbnail';
    div.setAttribute('data-page-number', this.id);
    this.div = div;
    if (id === 1) {
      div.classList.add('selected');
    }
    let ring = document.createElement('div');
    ring.className = 'thumbnailSelectionRing';
    let borderAdjustment = 2 * THUMBNAIL_CANVAS_BORDER_WIDTH;
    ring.style.width = this.canvasWidth + borderAdjustment + 'px';
    ring.style.height = this.canvasHeight + borderAdjustment + 'px';
    this.ring = ring;
    div.appendChild(ring);
    anchor.appendChild(div);
    container.appendChild(anchor);
  }
  setPdfPage(pdfPage) {
    this.pdfPage = pdfPage;
    this.pdfPageRotate = pdfPage.rotate;
    let totalRotation = (this.rotation + this.pdfPageRotate) % 360;
    this.viewport = pdfPage.getViewport(1, totalRotation);
    this.reset();
  }
  reset() {
    this.cancelRendering();
    this.pageWidth = this.viewport.width;
    this.pageHeight = this.viewport.height;
    this.pageRatio = this.pageWidth / this.pageHeight;
    this.canvasHeight = this.canvasWidth / this.pageRatio | 0;
    this.scale = this.canvasWidth / this.pageWidth;
    this.div.removeAttribute('data-loaded');
    let ring = this.ring;
    let childNodes = ring.childNodes;
    for (let i = childNodes.length - 1; i >= 0; i--) {
      ring.removeChild(childNodes[i]);
    }
    let borderAdjustment = 2 * THUMBNAIL_CANVAS_BORDER_WIDTH;
    ring.style.width = this.canvasWidth + borderAdjustment + 'px';
    ring.style.height = this.canvasHeight + borderAdjustment + 'px';
    if (this.canvas) {
      this.canvas.width = 0;
      this.canvas.height = 0;
      delete this.canvas;
    }
    if (this.image) {
      this.image.removeAttribute('src');
      delete this.image;
    }
  }
  update(rotation) {
    if (typeof rotation !== 'undefined') {
      this.rotation = rotation;
    }
    let totalRotation = (this.rotation + this.pdfPageRotate) % 360;
    this.viewport = this.viewport.clone({
      scale: 1,
      rotation: totalRotation
    });
    this.reset();
  }
  cancelRendering() {
    if (this.renderTask) {
      this.renderTask.cancel();
      this.renderTask = null;
    }
    this.renderingState = _pdf_rendering_queue.RenderingStates.INITIAL;
    this.resume = null;
  }
  _getPageDrawContext(noCtxScale = false) {
    let canvas = document.createElement('canvas');
    this.canvas = canvas;
    canvas.mozOpaque = true;
    let ctx = canvas.getContext('2d', { alpha: false });
    let outputScale = (0, _ui_utils.getOutputScale)(ctx);
    canvas.width = this.canvasWidth * outputScale.sx | 0;
    canvas.height = this.canvasHeight * outputScale.sy | 0;
    canvas.style.width = this.canvasWidth + 'px';
    canvas.style.height = this.canvasHeight + 'px';
    if (!noCtxScale && outputScale.scaled) {
      ctx.scale(outputScale.sx, outputScale.sy);
    }
    return ctx;
  }
  _convertCanvasToImage() {
    if (!this.canvas) {
      return;
    }
    if (this.renderingState !== _pdf_rendering_queue.RenderingStates.FINISHED) {
      return;
    }
    let id = this.renderingId;
    let className = 'thumbnailImage';
    if (this.disableCanvasToImageConversion) {
      this.canvas.id = id;
      this.canvas.className = className;
      this.l10n.get('thumb_page_canvas', { page: this.pageId }, 'Thumbnail of Page {{page}}').then(msg => {
        this.canvas.setAttribute('aria-label', msg);
      });
      this.div.setAttribute('data-loaded', true);
      this.ring.appendChild(this.canvas);
      return;
    }
    let image = document.createElement('img');
    image.id = id;
    image.className = className;
    this.l10n.get('thumb_page_canvas', { page: this.pageId }, 'Thumbnail of Page {{page}}').then(msg => {
      image.setAttribute('aria-label', msg);
    });
    image.style.width = this.canvasWidth + 'px';
    image.style.height = this.canvasHeight + 'px';
    image.src = this.canvas.toDataURL();
    this.image = image;
    this.div.setAttribute('data-loaded', true);
    this.ring.appendChild(image);
    this.canvas.width = 0;
    this.canvas.height = 0;
    delete this.canvas;
  }
  draw() {
    if (this.renderingState !== _pdf_rendering_queue.RenderingStates.INITIAL) {
      console.error('Must be in new state before drawing');
      return Promise.resolve(undefined);
    }
    this.renderingState = _pdf_rendering_queue.RenderingStates.RUNNING;
    let renderCapability = (0, _pdfjsLib.createPromiseCapability)();
    let finishRenderTask = error => {
      if (renderTask === this.renderTask) {
        this.renderTask = null;
      }
      if (error instanceof _pdfjsLib.RenderingCancelledException) {
        renderCapability.resolve(undefined);
        return;
      }
      this.renderingState = _pdf_rendering_queue.RenderingStates.FINISHED;
      this._convertCanvasToImage();
      if (!error) {
        renderCapability.resolve(undefined);
      } else {
        renderCapability.reject(error);
      }
    };
    let ctx = this._getPageDrawContext();
    let drawViewport = this.viewport.clone({ scale: this.scale });
    let renderContinueCallback = cont => {
      if (!this.renderingQueue.isHighestPriority(this)) {
        this.renderingState = _pdf_rendering_queue.RenderingStates.PAUSED;
        this.resume = () => {
          this.renderingState = _pdf_rendering_queue.RenderingStates.RUNNING;
          cont();
        };
        return;
      }
      cont();
    };
    let renderContext = {
      canvasContext: ctx,
      viewport: drawViewport
    };
    let renderTask = this.renderTask = this.pdfPage.render(renderContext);
    renderTask.onContinue = renderContinueCallback;
    renderTask.promise.then(function () {
      finishRenderTask(null);
    }, function (error) {
      finishRenderTask(error);
    });
    return renderCapability.promise;
  }
  setImage(pageView) {
    if (this.renderingState !== _pdf_rendering_queue.RenderingStates.INITIAL) {
      return;
    }
    let img = pageView.canvas;
    if (!img) {
      return;
    }
    if (!this.pdfPage) {
      this.setPdfPage(pageView.pdfPage);
    }
    this.renderingState = _pdf_rendering_queue.RenderingStates.FINISHED;
    let ctx = this._getPageDrawContext(true);
    let canvas = ctx.canvas;
    if (img.width <= 2 * canvas.width) {
      ctx.drawImage(img, 0, 0, img.width, img.height, 0, 0, canvas.width, canvas.height);
      this._convertCanvasToImage();
      return;
    }
    let reducedWidth = canvas.width << MAX_NUM_SCALING_STEPS;
    let reducedHeight = canvas.height << MAX_NUM_SCALING_STEPS;
    let reducedImage = TempImageFactory.getCanvas(reducedWidth, reducedHeight);
    let reducedImageCtx = reducedImage.getContext('2d');
    while (reducedWidth > img.width || reducedHeight > img.height) {
      reducedWidth >>= 1;
      reducedHeight >>= 1;
    }
    reducedImageCtx.drawImage(img, 0, 0, img.width, img.height, 0, 0, reducedWidth, reducedHeight);
    while (reducedWidth > 2 * canvas.width) {
      reducedImageCtx.drawImage(reducedImage, 0, 0, reducedWidth, reducedHeight, 0, 0, reducedWidth >> 1, reducedHeight >> 1);
      reducedWidth >>= 1;
      reducedHeight >>= 1;
    }
    ctx.drawImage(reducedImage, 0, 0, reducedWidth, reducedHeight, 0, 0, canvas.width, canvas.height);
    this._convertCanvasToImage();
  }
  get pageId() {
    return this.pageLabel !== null ? this.pageLabel : this.id;
  }
  setPageLabel(label) {
    this.pageLabel = typeof label === 'string' ? label : null;
    this.l10n.get('thumb_page_title', { page: this.pageId }, 'Page {{page}}').then(msg => {
      this.anchor.title = msg;
    });
    if (this.renderingState !== _pdf_rendering_queue.RenderingStates.FINISHED) {
      return;
    }
    this.l10n.get('thumb_page_canvas', { page: this.pageId }, 'Thumbnail of Page {{page}}').then(ariaLabel => {
      if (this.image) {
        this.image.setAttribute('aria-label', ariaLabel);
      } else if (this.disableCanvasToImageConversion && this.canvas) {
        this.canvas.setAttribute('aria-label', ariaLabel);
      }
    });
  }
  static cleanup() {
    TempImageFactory.destroyCanvas();
  }
}
exports.PDFThumbnailView = PDFThumbnailView;

/***/ }),
/* 24 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFThumbnailViewer = undefined;

var _ui_utils = __webpack_require__(0);

var _pdf_thumbnail_view = __webpack_require__(23);

const THUMBNAIL_SCROLL_MARGIN = -19;
class PDFThumbnailViewer {
  constructor({ container, linkService, renderingQueue, l10n = _ui_utils.NullL10n }) {
    this.container = container;
    this.linkService = linkService;
    this.renderingQueue = renderingQueue;
    this.l10n = l10n;
    this.scroll = (0, _ui_utils.watchScroll)(this.container, this._scrollUpdated.bind(this));
    this._resetView();
  }
  _scrollUpdated() {
    this.renderingQueue.renderHighestPriority();
  }
  getThumbnail(index) {
    return this._thumbnails[index];
  }
  _getVisibleThumbs() {
    return (0, _ui_utils.getVisibleElements)(this.container, this._thumbnails);
  }
  scrollThumbnailIntoView(page) {
    let selected = document.querySelector('.thumbnail.selected');
    if (selected) {
      selected.classList.remove('selected');
    }
    let thumbnail = document.querySelector('div.thumbnail[data-page-number="' + page + '"]');
    if (thumbnail) {
      thumbnail.classList.add('selected');
    }
    let visibleThumbs = this._getVisibleThumbs();
    let numVisibleThumbs = visibleThumbs.views.length;
    if (numVisibleThumbs > 0) {
      let first = visibleThumbs.first.id;
      let last = numVisibleThumbs > 1 ? visibleThumbs.last.id : first;
      if (page <= first || page >= last) {
        (0, _ui_utils.scrollIntoView)(thumbnail, { top: THUMBNAIL_SCROLL_MARGIN });
      }
    }
  }
  get pagesRotation() {
    return this._pagesRotation;
  }
  set pagesRotation(rotation) {
    if (!(typeof rotation === 'number' && rotation % 90 === 0)) {
      throw new Error('Invalid thumbnails rotation angle.');
    }
    if (!this.pdfDocument) {
      return;
    }
    this._pagesRotation = rotation;
    for (let i = 0, ii = this._thumbnails.length; i < ii; i++) {
      this._thumbnails[i].update(rotation);
    }
  }
  cleanup() {
    _pdf_thumbnail_view.PDFThumbnailView.cleanup();
  }
  _resetView() {
    this._thumbnails = [];
    this._pageLabels = null;
    this._pagesRotation = 0;
    this._pagesRequests = [];
    this.container.textContent = '';
  }
  setDocument(pdfDocument) {
    if (this.pdfDocument) {
      this._cancelRendering();
      this._resetView();
    }
    this.pdfDocument = pdfDocument;
    if (!pdfDocument) {
      return;
    }
    pdfDocument.getPage(1).then(firstPage => {
      let pagesCount = pdfDocument.numPages;
      let viewport = firstPage.getViewport(1.0);
      for (let pageNum = 1; pageNum <= pagesCount; ++pageNum) {
        let thumbnail = new _pdf_thumbnail_view.PDFThumbnailView({
          container: this.container,
          id: pageNum,
          defaultViewport: viewport.clone(),
          linkService: this.linkService,
          renderingQueue: this.renderingQueue,
          disableCanvasToImageConversion: false,
          l10n: this.l10n
        });
        this._thumbnails.push(thumbnail);
      }
    }).catch(reason => {
      console.error('Unable to initialize thumbnail viewer', reason);
    });
  }
  _cancelRendering() {
    for (let i = 0, ii = this._thumbnails.length; i < ii; i++) {
      if (this._thumbnails[i]) {
        this._thumbnails[i].cancelRendering();
      }
    }
  }
  setPageLabels(labels) {
    if (!this.pdfDocument) {
      return;
    }
    if (!labels) {
      this._pageLabels = null;
    } else if (!(labels instanceof Array && this.pdfDocument.numPages === labels.length)) {
      this._pageLabels = null;
      console.error('PDFThumbnailViewer_setPageLabels: Invalid page labels.');
    } else {
      this._pageLabels = labels;
    }
    for (let i = 0, ii = this._thumbnails.length; i < ii; i++) {
      let label = this._pageLabels && this._pageLabels[i];
      this._thumbnails[i].setPageLabel(label);
    }
  }
  _ensurePdfPageLoaded(thumbView) {
    if (thumbView.pdfPage) {
      return Promise.resolve(thumbView.pdfPage);
    }
    let pageNumber = thumbView.id;
    if (this._pagesRequests[pageNumber]) {
      return this._pagesRequests[pageNumber];
    }
    let promise = this.pdfDocument.getPage(pageNumber).then(pdfPage => {
      thumbView.setPdfPage(pdfPage);
      this._pagesRequests[pageNumber] = null;
      return pdfPage;
    }).catch(reason => {
      console.error('Unable to get page for thumb view', reason);
      this._pagesRequests[pageNumber] = null;
    });
    this._pagesRequests[pageNumber] = promise;
    return promise;
  }
  forceRendering() {
    let visibleThumbs = this._getVisibleThumbs();
    let thumbView = this.renderingQueue.getHighestPriority(visibleThumbs, this._thumbnails, this.scroll.down);
    if (thumbView) {
      this._ensurePdfPageLoaded(thumbView).then(() => {
        this.renderingQueue.renderView(thumbView);
      });
      return true;
    }
    return false;
  }
}
exports.PDFThumbnailViewer = PDFThumbnailViewer;

/***/ }),
/* 25 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PDFViewer = exports.PresentationModeState = undefined;

var _pdfjsLib = __webpack_require__(1);

var _ui_utils = __webpack_require__(0);

var _pdf_rendering_queue = __webpack_require__(3);

var _annotation_layer_builder = __webpack_require__(11);

var _dom_events = __webpack_require__(2);

var _pdf_page_view = __webpack_require__(20);

var _pdf_link_service = __webpack_require__(5);

var _text_layer_builder = __webpack_require__(28);

const PresentationModeState = {
  UNKNOWN: 0,
  NORMAL: 1,
  CHANGING: 2,
  FULLSCREEN: 3
};
const DEFAULT_CACHE_SIZE = 10;
function PDFPageViewBuffer(size) {
  let data = [];
  this.push = function cachePush(view) {
    let i = data.indexOf(view);
    if (i >= 0) {
      data.splice(i, 1);
    }
    data.push(view);
    if (data.length > size) {
      data.shift().destroy();
    }
  };
  this.resize = function (newSize) {
    size = newSize;
    while (data.length > size) {
      data.shift().destroy();
    }
  };
}
function isSameScale(oldScale, newScale) {
  if (newScale === oldScale) {
    return true;
  }
  if (Math.abs(newScale - oldScale) < 1e-15) {
    return true;
  }
  return false;
}
function isPortraitOrientation(size) {
  return size.width <= size.height;
}
class PDFViewer {
  constructor(options) {
    this.container = options.container;
    this.viewer = options.viewer || options.container.firstElementChild;
    this.eventBus = options.eventBus || (0, _dom_events.getGlobalEventBus)();
    this.linkService = options.linkService || new _pdf_link_service.SimpleLinkService();
    this.downloadManager = options.downloadManager || null;
    this.removePageBorders = options.removePageBorders || false;
    this.enhanceTextSelection = options.enhanceTextSelection || false;
    this.renderInteractiveForms = options.renderInteractiveForms || false;
    this.enablePrintAutoRotate = options.enablePrintAutoRotate || false;
    this.renderer = options.renderer || _ui_utils.RendererType.CANVAS;
    this.l10n = options.l10n || _ui_utils.NullL10n;
    this.defaultRenderingQueue = !options.renderingQueue;
    if (this.defaultRenderingQueue) {
      this.renderingQueue = new _pdf_rendering_queue.PDFRenderingQueue();
      this.renderingQueue.setViewer(this);
    } else {
      this.renderingQueue = options.renderingQueue;
    }
    this.scroll = (0, _ui_utils.watchScroll)(this.container, this._scrollUpdate.bind(this));
    this.presentationModeState = PresentationModeState.UNKNOWN;
    this._resetView();
    if (this.removePageBorders) {
      this.viewer.classList.add('removePageBorders');
    }
  }
  get pagesCount() {
    return this._pages.length;
  }
  getPageView(index) {
    return this._pages[index];
  }
  get pageViewsReady() {
    return this._pageViewsReady;
  }
  get currentPageNumber() {
    return this._currentPageNumber;
  }
  set currentPageNumber(val) {
    if ((val | 0) !== val) {
      throw new Error('Invalid page number.');
    }
    if (!this.pdfDocument) {
      return;
    }
    this._setCurrentPageNumber(val, true);
  }
  _setCurrentPageNumber(val, resetCurrentPageView = false) {
    if (this._currentPageNumber === val) {
      if (resetCurrentPageView) {
        this._resetCurrentPageView();
      }
      return;
    }
    if (!(0 < val && val <= this.pagesCount)) {
      console.error(`PDFViewer._setCurrentPageNumber: "${val}" is out of bounds.`);
      return;
    }
    let arg = {
      source: this,
      pageNumber: val,
      pageLabel: this._pageLabels && this._pageLabels[val - 1]
    };
    this._currentPageNumber = val;
    this.eventBus.dispatch('pagechanging', arg);
    this.eventBus.dispatch('pagechange', arg);
    if (resetCurrentPageView) {
      this._resetCurrentPageView();
    }
  }
  get currentPageLabel() {
    return this._pageLabels && this._pageLabels[this._currentPageNumber - 1];
  }
  set currentPageLabel(val) {
    let pageNumber = val | 0;
    if (this._pageLabels) {
      let i = this._pageLabels.indexOf(val);
      if (i >= 0) {
        pageNumber = i + 1;
      }
    }
    this.currentPageNumber = pageNumber;
  }
  get currentScale() {
    return this._currentScale !== _ui_utils.UNKNOWN_SCALE ? this._currentScale : _ui_utils.DEFAULT_SCALE;
  }
  set currentScale(val) {
    if (isNaN(val)) {
      throw new Error('Invalid numeric scale');
    }
    if (!this.pdfDocument) {
      return;
    }
    this._setScale(val, false);
  }
  get currentScaleValue() {
    return this._currentScaleValue;
  }
  set currentScaleValue(val) {
    if (!this.pdfDocument) {
      return;
    }
    this._setScale(val, false);
  }
  get pagesRotation() {
    return this._pagesRotation;
  }
  set pagesRotation(rotation) {
    if (!(typeof rotation === 'number' && rotation % 90 === 0)) {
      throw new Error('Invalid pages rotation angle.');
    }
    if (!this.pdfDocument) {
      return;
    }
    this._pagesRotation = rotation;
    for (let i = 0, ii = this._pages.length; i < ii; i++) {
      let pageView = this._pages[i];
      pageView.update(pageView.scale, rotation);
    }
    this._setScale(this._currentScaleValue, true);
    if (this.defaultRenderingQueue) {
      this.update();
    }
  }
  setDocument(pdfDocument) {
    if (this.pdfDocument) {
      this._cancelRendering();
      this._resetView();
    }
    this.pdfDocument = pdfDocument;
    if (!pdfDocument) {
      return;
    }
    let pagesCount = pdfDocument.numPages;
    let pagesCapability = (0, _pdfjsLib.createPromiseCapability)();
    this.pagesPromise = pagesCapability.promise;
    pagesCapability.promise.then(() => {
      this._pageViewsReady = true;
      this.eventBus.dispatch('pagesloaded', {
        source: this,
        pagesCount
      });
    });
    let isOnePageRenderedResolved = false;
    let onePageRenderedCapability = (0, _pdfjsLib.createPromiseCapability)();
    this.onePageRendered = onePageRenderedCapability.promise;
    let bindOnAfterAndBeforeDraw = pageView => {
      pageView.onBeforeDraw = () => {
        this._buffer.push(pageView);
      };
      pageView.onAfterDraw = () => {
        if (!isOnePageRenderedResolved) {
          isOnePageRenderedResolved = true;
          onePageRenderedCapability.resolve();
        }
      };
    };
    let firstPagePromise = pdfDocument.getPage(1);
    this.firstPagePromise = firstPagePromise;
    firstPagePromise.then(pdfPage => {
      let scale = this.currentScale;
      let viewport = pdfPage.getViewport(scale * _ui_utils.CSS_UNITS);
      for (let pageNum = 1; pageNum <= pagesCount; ++pageNum) {
        let textLayerFactory = null;
        if (!_pdfjsLib.PDFJS.disableTextLayer) {
          textLayerFactory = this;
        }
        let pageView = new _pdf_page_view.PDFPageView({
          container: this.viewer,
          eventBus: this.eventBus,
          id: pageNum,
          scale,
          defaultViewport: viewport.clone(),
          renderingQueue: this.renderingQueue,
          textLayerFactory,
          annotationLayerFactory: this,
          enhanceTextSelection: this.enhanceTextSelection,
          renderInteractiveForms: this.renderInteractiveForms,
          renderer: this.renderer,
          l10n: this.l10n
        });
        bindOnAfterAndBeforeDraw(pageView);
        this._pages.push(pageView);
      }
      onePageRenderedCapability.promise.then(() => {
        if (_pdfjsLib.PDFJS.disableAutoFetch) {
          pagesCapability.resolve();
          return;
        }
        let getPagesLeft = pagesCount;
        for (let pageNum = 1; pageNum <= pagesCount; ++pageNum) {
          pdfDocument.getPage(pageNum).then(pdfPage => {
            let pageView = this._pages[pageNum - 1];
            if (!pageView.pdfPage) {
              pageView.setPdfPage(pdfPage);
            }
            this.linkService.cachePageRef(pageNum, pdfPage.ref);
            if (--getPagesLeft === 0) {
              pagesCapability.resolve();
            }
          }, reason => {
            console.error(`Unable to get page ${pageNum} to initialize viewer`, reason);
            if (--getPagesLeft === 0) {
              pagesCapability.resolve();
            }
          });
        }
      });
      this.eventBus.dispatch('pagesinit', { source: this });
      if (this.defaultRenderingQueue) {
        this.update();
      }
      if (this.findController) {
        this.findController.resolveFirstPage();
      }
    }).catch(reason => {
      console.error('Unable to initialize viewer', reason);
    });
  }
  setPageLabels(labels) {
    if (!this.pdfDocument) {
      return;
    }
    if (!labels) {
      this._pageLabels = null;
    } else if (!(labels instanceof Array && this.pdfDocument.numPages === labels.length)) {
      this._pageLabels = null;
      console.error('PDFViewer.setPageLabels: Invalid page labels.');
    } else {
      this._pageLabels = labels;
    }
    for (let i = 0, ii = this._pages.length; i < ii; i++) {
      let pageView = this._pages[i];
      let label = this._pageLabels && this._pageLabels[i];
      pageView.setPageLabel(label);
    }
  }
  _resetView() {
    this._pages = [];
    this._currentPageNumber = 1;
    this._currentScale = _ui_utils.UNKNOWN_SCALE;
    this._currentScaleValue = null;
    this._pageLabels = null;
    this._buffer = new PDFPageViewBuffer(DEFAULT_CACHE_SIZE);
    this._location = null;
    this._pagesRotation = 0;
    this._pagesRequests = [];
    this._pageViewsReady = false;
    this.viewer.textContent = '';
  }
  _scrollUpdate() {
    if (this.pagesCount === 0) {
      return;
    }
    this.update();
  }
  _setScaleDispatchEvent(newScale, newValue, preset = false) {
    let arg = {
      source: this,
      scale: newScale,
      presetValue: preset ? newValue : undefined
    };
    this.eventBus.dispatch('scalechanging', arg);
    this.eventBus.dispatch('scalechange', arg);
  }
  _setScaleUpdatePages(newScale, newValue, noScroll = false, preset = false) {
    this._currentScaleValue = newValue.toString();
    if (isSameScale(this._currentScale, newScale)) {
      if (preset) {
        this._setScaleDispatchEvent(newScale, newValue, true);
      }
      return;
    }
    for (let i = 0, ii = this._pages.length; i < ii; i++) {
      this._pages[i].update(newScale);
    }
    this._currentScale = newScale;
    if (!noScroll) {
      let page = this._currentPageNumber,
          dest;
      if (this._location && !_pdfjsLib.PDFJS.ignoreCurrentPositionOnZoom && !(this.isInPresentationMode || this.isChangingPresentationMode)) {
        page = this._location.pageNumber;
        dest = [null, { name: 'XYZ' }, this._location.left, this._location.top, null];
      }
      this.scrollPageIntoView({
        pageNumber: page,
        destArray: dest,
        allowNegativeOffset: true
      });
    }
    this._setScaleDispatchEvent(newScale, newValue, preset);
    if (this.defaultRenderingQueue) {
      this.update();
    }
  }
  _setScale(value, noScroll = false) {
    let scale = parseFloat(value);
    if (scale > 0) {
      this._setScaleUpdatePages(scale, value, noScroll, false);
    } else {
      let currentPage = this._pages[this._currentPageNumber - 1];
      if (!currentPage) {
        return;
      }
      let hPadding = this.isInPresentationMode || this.removePageBorders ? 0 : _ui_utils.SCROLLBAR_PADDING;
      let vPadding = this.isInPresentationMode || this.removePageBorders ? 0 : _ui_utils.VERTICAL_PADDING;
      let pageWidthScale = (this.container.clientWidth - hPadding) / currentPage.width * currentPage.scale;
      let pageHeightScale = (this.container.clientHeight - vPadding) / currentPage.height * currentPage.scale;
      switch (value) {
        case 'page-actual':
          scale = 1;
          break;
        case 'page-width':
          scale = pageWidthScale;
          break;
        case 'page-height':
          scale = pageHeightScale;
          break;
        case 'page-fit':
          scale = Math.min(pageWidthScale, pageHeightScale);
          break;
        case 'auto':
          let isLandscape = currentPage.width > currentPage.height;
          let horizontalScale = isLandscape ? Math.min(pageHeightScale, pageWidthScale) : pageWidthScale;
          scale = Math.min(_ui_utils.MAX_AUTO_SCALE, horizontalScale);
          break;
        default:
          console.error(`PDFViewer._setScale: "${value}" is an unknown zoom value.`);
          return;
      }
      this._setScaleUpdatePages(scale, value, noScroll, true);
    }
  }
  _resetCurrentPageView() {
    if (this.isInPresentationMode) {
      this._setScale(this._currentScaleValue, true);
    }
    let pageView = this._pages[this._currentPageNumber - 1];
    (0, _ui_utils.scrollIntoView)(pageView.div);
  }
  scrollPageIntoView(params) {
    if (!this.pdfDocument) {
      return;
    }
    let pageNumber = params.pageNumber || 0;
    let dest = params.destArray || null;
    let allowNegativeOffset = params.allowNegativeOffset || false;
    if (this.isInPresentationMode || !dest) {
      this._setCurrentPageNumber(pageNumber, true);
      return;
    }
    let pageView = this._pages[pageNumber - 1];
    if (!pageView) {
      console.error('PDFViewer.scrollPageIntoView: Invalid "pageNumber" parameter.');
      return;
    }
    let x = 0,
        y = 0;
    let width = 0,
        height = 0,
        widthScale,
        heightScale;
    let changeOrientation = pageView.rotation % 180 === 0 ? false : true;
    let pageWidth = (changeOrientation ? pageView.height : pageView.width) / pageView.scale / _ui_utils.CSS_UNITS;
    let pageHeight = (changeOrientation ? pageView.width : pageView.height) / pageView.scale / _ui_utils.CSS_UNITS;
    let scale = 0;
    switch (dest[1].name) {
      case 'XYZ':
        x = dest[2];
        y = dest[3];
        scale = dest[4];
        x = x !== null ? x : 0;
        y = y !== null ? y : pageHeight;
        break;
      case 'Fit':
      case 'FitB':
        scale = 'page-fit';
        break;
      case 'FitH':
      case 'FitBH':
        y = dest[2];
        scale = 'page-width';
        if (y === null && this._location) {
          x = this._location.left;
          y = this._location.top;
        }
        break;
      case 'FitV':
      case 'FitBV':
        x = dest[2];
        width = pageWidth;
        height = pageHeight;
        scale = 'page-height';
        break;
      case 'FitR':
        x = dest[2];
        y = dest[3];
        width = dest[4] - x;
        height = dest[5] - y;
        let hPadding = this.removePageBorders ? 0 : _ui_utils.SCROLLBAR_PADDING;
        let vPadding = this.removePageBorders ? 0 : _ui_utils.VERTICAL_PADDING;
        widthScale = (this.container.clientWidth - hPadding) / width / _ui_utils.CSS_UNITS;
        heightScale = (this.container.clientHeight - vPadding) / height / _ui_utils.CSS_UNITS;
        scale = Math.min(Math.abs(widthScale), Math.abs(heightScale));
        break;
      default:
        console.error(`PDFViewer.scrollPageIntoView: "${dest[1].name}" ` + 'is not a valid destination type.');
        return;
    }
    if (scale && scale !== this._currentScale) {
      this.currentScaleValue = scale;
    } else if (this._currentScale === _ui_utils.UNKNOWN_SCALE) {
      this.currentScaleValue = _ui_utils.DEFAULT_SCALE_VALUE;
    }
    if (scale === 'page-fit' && !dest[4]) {
      (0, _ui_utils.scrollIntoView)(pageView.div);
      return;
    }
    let boundingRect = [pageView.viewport.convertToViewportPoint(x, y), pageView.viewport.convertToViewportPoint(x + width, y + height)];
    let left = Math.min(boundingRect[0][0], boundingRect[1][0]);
    let top = Math.min(boundingRect[0][1], boundingRect[1][1]);
    if (!allowNegativeOffset) {
      left = Math.max(left, 0);
      top = Math.max(top, 0);
    }
    (0, _ui_utils.scrollIntoView)(pageView.div, {
      left,
      top
    });
  }
  _updateLocation(firstPage) {
    let currentScale = this._currentScale;
    let currentScaleValue = this._currentScaleValue;
    let normalizedScaleValue = parseFloat(currentScaleValue) === currentScale ? Math.round(currentScale * 10000) / 100 : currentScaleValue;
    let pageNumber = firstPage.id;
    let pdfOpenParams = '#page=' + pageNumber;
    pdfOpenParams += '&zoom=' + normalizedScaleValue;
    let currentPageView = this._pages[pageNumber - 1];
    let container = this.container;
    let topLeft = currentPageView.getPagePoint(container.scrollLeft - firstPage.x, container.scrollTop - firstPage.y);
    let intLeft = Math.round(topLeft[0]);
    let intTop = Math.round(topLeft[1]);
    pdfOpenParams += ',' + intLeft + ',' + intTop;
    this._location = {
      pageNumber,
      scale: normalizedScaleValue,
      top: intTop,
      left: intLeft,
      pdfOpenParams
    };
  }
  update() {
    let visible = this._getVisiblePages();
    let visiblePages = visible.views;
    if (visiblePages.length === 0) {
      return;
    }
    let suggestedCacheSize = Math.max(DEFAULT_CACHE_SIZE, 2 * visiblePages.length + 1);
    this._buffer.resize(suggestedCacheSize);
    this.renderingQueue.renderHighestPriority(visible);
    let currentId = this._currentPageNumber;
    let firstPage = visible.first;
    let stillFullyVisible = false;
    for (let i = 0, ii = visiblePages.length; i < ii; ++i) {
      let page = visiblePages[i];
      if (page.percent < 100) {
        break;
      }
      if (page.id === currentId) {
        stillFullyVisible = true;
        break;
      }
    }
    if (!stillFullyVisible) {
      currentId = visiblePages[0].id;
    }
    if (!this.isInPresentationMode) {
      this._setCurrentPageNumber(currentId);
    }
    this._updateLocation(firstPage);
    this.eventBus.dispatch('updateviewarea', {
      source: this,
      location: this._location
    });
  }
  containsElement(element) {
    return this.container.contains(element);
  }
  focus() {
    this.container.focus();
  }
  get isInPresentationMode() {
    return this.presentationModeState === PresentationModeState.FULLSCREEN;
  }
  get isChangingPresentationMode() {
    return this.presentationModeState === PresentationModeState.CHANGING;
  }
  get isHorizontalScrollbarEnabled() {
    return this.isInPresentationMode ? false : this.container.scrollWidth > this.container.clientWidth;
  }
  _getVisiblePages() {
    if (!this.isInPresentationMode) {
      return (0, _ui_utils.getVisibleElements)(this.container, this._pages, true);
    }
    let visible = [];
    let currentPage = this._pages[this._currentPageNumber - 1];
    visible.push({
      id: currentPage.id,
      view: currentPage
    });
    return {
      first: currentPage,
      last: currentPage,
      views: visible
    };
  }
  cleanup() {
    for (let i = 0, ii = this._pages.length; i < ii; i++) {
      if (this._pages[i] && this._pages[i].renderingState !== _pdf_rendering_queue.RenderingStates.FINISHED) {
        this._pages[i].reset();
      }
    }
  }
  _cancelRendering() {
    for (let i = 0, ii = this._pages.length; i < ii; i++) {
      if (this._pages[i]) {
        this._pages[i].cancelRendering();
      }
    }
  }
  _ensurePdfPageLoaded(pageView) {
    if (pageView.pdfPage) {
      return Promise.resolve(pageView.pdfPage);
    }
    let pageNumber = pageView.id;
    if (this._pagesRequests[pageNumber]) {
      return this._pagesRequests[pageNumber];
    }
    let promise = this.pdfDocument.getPage(pageNumber).then(pdfPage => {
      if (!pageView.pdfPage) {
        pageView.setPdfPage(pdfPage);
      }
      this._pagesRequests[pageNumber] = null;
      return pdfPage;
    }).catch(reason => {
      console.error('Unable to get page for page view', reason);
      this._pagesRequests[pageNumber] = null;
    });
    this._pagesRequests[pageNumber] = promise;
    return promise;
  }
  forceRendering(currentlyVisiblePages) {
    let visiblePages = currentlyVisiblePages || this._getVisiblePages();
    let pageView = this.renderingQueue.getHighestPriority(visiblePages, this._pages, this.scroll.down);
    if (pageView) {
      this._ensurePdfPageLoaded(pageView).then(() => {
        this.renderingQueue.renderView(pageView);
      });
      return true;
    }
    return false;
  }
  getPageTextContent(pageIndex) {
    return this.pdfDocument.getPage(pageIndex + 1).then(function (page) {
      return page.getTextContent({ normalizeWhitespace: true });
    });
  }
  createTextLayerBuilder(textLayerDiv, pageIndex, viewport, enhanceTextSelection = false) {
    return new _text_layer_builder.TextLayerBuilder({
      textLayerDiv,
      eventBus: this.eventBus,
      pageIndex,
      viewport,
      findController: this.isInPresentationMode ? null : this.findController,
      enhanceTextSelection: this.isInPresentationMode ? false : enhanceTextSelection
    });
  }
  createAnnotationLayerBuilder(pageDiv, pdfPage, renderInteractiveForms = false, l10n = _ui_utils.NullL10n) {
    return new _annotation_layer_builder.AnnotationLayerBuilder({
      pageDiv,
      pdfPage,
      renderInteractiveForms,
      linkService: this.linkService,
      downloadManager: this.downloadManager,
      l10n
    });
  }
  setFindController(findController) {
    this.findController = findController;
  }
  get hasEqualPageSizes() {
    let firstPageView = this._pages[0];
    for (let i = 1, ii = this._pages.length; i < ii; ++i) {
      let pageView = this._pages[i];
      if (pageView.width !== firstPageView.width || pageView.height !== firstPageView.height) {
        return false;
      }
    }
    return true;
  }
  getPagesOverview() {
    let pagesOverview = this._pages.map(function (pageView) {
      let viewport = pageView.pdfPage.getViewport(1);
      return {
        width: viewport.width,
        height: viewport.height,
        rotation: viewport.rotation
      };
    });
    if (!this.enablePrintAutoRotate) {
      return pagesOverview;
    }
    let isFirstPagePortrait = isPortraitOrientation(pagesOverview[0]);
    return pagesOverview.map(function (size) {
      if (isFirstPagePortrait === isPortraitOrientation(size)) {
        return size;
      }
      return {
        width: size.height,
        height: size.width,
        rotation: (size.rotation + 90) % 360
      };
    });
  }
}
exports.PresentationModeState = PresentationModeState;
exports.PDFViewer = PDFViewer;

/***/ }),
/* 26 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.BasePreferences = undefined;

var _ui_utils = __webpack_require__(0);

var defaultPreferences = null;
function getDefaultPreferences() {
  if (!defaultPreferences) {
    defaultPreferences = Promise.resolve({
      "showPreviousViewOnLoad": true,
      "defaultZoomValue": "",
      "sidebarViewOnLoad": 0,
      "enableHandToolOnLoad": false,
      "cursorToolOnLoad": 0,
      "enableWebGL": false,
      "pdfBugEnabled": false,
      "disableRange": false,
      "disableStream": false,
      "disableAutoFetch": false,
      "disableFontFace": false,
      "disableTextLayer": false,
      "useOnlyCssZoom": false,
      "externalLinkTarget": 0,
      "enhanceTextSelection": false,
      "renderer": "canvas",
      "renderInteractiveForms": false,
      "enablePrintAutoRotate": false,
      "disablePageMode": false,
      "disablePageLabels": false
    });
  }
  return defaultPreferences;
}
class BasePreferences {
  constructor() {
    if (this.constructor === BasePreferences) {
      throw new Error('Cannot initialize BasePreferences.');
    }
    this.prefs = null;
    this._initializedPromise = getDefaultPreferences().then(defaults => {
      Object.defineProperty(this, 'defaults', {
        value: Object.freeze(defaults),
        writable: false,
        enumerable: true,
        configurable: false
      });
      this.prefs = (0, _ui_utils.cloneObj)(defaults);
      return this._readFromStorage(defaults);
    }).then(prefObj => {
      if (prefObj) {
        this.prefs = prefObj;
      }
    });
  }
  _writeToStorage(prefObj) {
    return Promise.reject(new Error('Not implemented: _writeToStorage'));
  }
  _readFromStorage(prefObj) {
    return Promise.reject(new Error('Not implemented: _readFromStorage'));
  }
  reset() {
    return this._initializedPromise.then(() => {
      this.prefs = (0, _ui_utils.cloneObj)(this.defaults);
      return this._writeToStorage(this.defaults);
    });
  }
  reload() {
    return this._initializedPromise.then(() => {
      return this._readFromStorage(this.defaults);
    }).then(prefObj => {
      if (prefObj) {
        this.prefs = prefObj;
      }
    });
  }
  set(name, value) {
    return this._initializedPromise.then(() => {
      if (this.defaults[name] === undefined) {
        throw new Error(`Set preference: "${name}" is undefined.`);
      } else if (value === undefined) {
        throw new Error('Set preference: no value is specified.');
      }
      var valueType = typeof value;
      var defaultType = typeof this.defaults[name];
      if (valueType !== defaultType) {
        if (valueType === 'number' && defaultType === 'string') {
          value = value.toString();
        } else {
          throw new Error(`Set preference: "${value}" is a ${valueType}, ` + `expected a ${defaultType}.`);
        }
      } else {
        if (valueType === 'number' && (value | 0) !== value) {
          throw new Error(`Set preference: "${value}" must be an integer.`);
        }
      }
      this.prefs[name] = value;
      return this._writeToStorage(this.prefs);
    });
  }
  get(name) {
    return this._initializedPromise.then(() => {
      var defaultValue = this.defaults[name];
      if (defaultValue === undefined) {
        throw new Error(`Get preference: "${name}" is undefined.`);
      } else {
        var prefValue = this.prefs[name];
        if (prefValue !== undefined) {
          return prefValue;
        }
      }
      return defaultValue;
    });
  }
}
exports.BasePreferences = BasePreferences;

/***/ }),
/* 27 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.SecondaryToolbar = undefined;

var _pdf_cursor_tools = __webpack_require__(6);

var _ui_utils = __webpack_require__(0);

class SecondaryToolbar {
  constructor(options, mainContainer, eventBus) {
    this.toolbar = options.toolbar;
    this.toggleButton = options.toggleButton;
    this.toolbarButtonContainer = options.toolbarButtonContainer;
    this.buttons = [{
      element: options.presentationModeButton,
      eventName: 'presentationmode',
      close: true
    }, {
      element: options.openFileButton,
      eventName: 'openfile',
      close: true
    }, {
      element: options.printButton,
      eventName: 'print',
      close: true
    }, {
      element: options.downloadButton,
      eventName: 'download',
      close: true
    }, {
      element: options.viewBookmarkButton,
      eventName: null,
      close: true
    }, {
      element: options.firstPageButton,
      eventName: 'firstpage',
      close: true
    }, {
      element: options.lastPageButton,
      eventName: 'lastpage',
      close: true
    }, {
      element: options.pageRotateCwButton,
      eventName: 'rotatecw',
      close: false
    }, {
      element: options.pageRotateCcwButton,
      eventName: 'rotateccw',
      close: false
    }, {
      element: options.cursorSelectToolButton,
      eventName: 'switchcursortool',
      eventDetails: { tool: _pdf_cursor_tools.CursorTool.SELECT },
      close: true
    }, {
      element: options.cursorHandToolButton,
      eventName: 'switchcursortool',
      eventDetails: { tool: _pdf_cursor_tools.CursorTool.HAND },
      close: true
    }, {
      element: options.documentPropertiesButton,
      eventName: 'documentproperties',
      close: true
    }];
    this.items = {
      firstPage: options.firstPageButton,
      lastPage: options.lastPageButton,
      pageRotateCw: options.pageRotateCwButton,
      pageRotateCcw: options.pageRotateCcwButton
    };
    this.mainContainer = mainContainer;
    this.eventBus = eventBus;
    this.opened = false;
    this.containerHeight = null;
    this.previousContainerHeight = null;
    this.reset();
    this._bindClickListeners();
    this._bindCursorToolsListener(options);
    this.eventBus.on('resize', this._setMaxHeight.bind(this));
  }
  get isOpen() {
    return this.opened;
  }
  setPageNumber(pageNumber) {
    this.pageNumber = pageNumber;
    this._updateUIState();
  }
  setPagesCount(pagesCount) {
    this.pagesCount = pagesCount;
    this._updateUIState();
  }
  reset() {
    this.pageNumber = 0;
    this.pagesCount = 0;
    this._updateUIState();
  }
  _updateUIState() {
    this.items.firstPage.disabled = this.pageNumber <= 1;
    this.items.lastPage.disabled = this.pageNumber >= this.pagesCount;
    this.items.pageRotateCw.disabled = this.pagesCount === 0;
    this.items.pageRotateCcw.disabled = this.pagesCount === 0;
  }
  _bindClickListeners() {
    this.toggleButton.addEventListener('click', this.toggle.bind(this));
    for (let button in this.buttons) {
      let { element, eventName, close, eventDetails } = this.buttons[button];
      element.addEventListener('click', evt => {
        if (eventName !== null) {
          let details = { source: this };
          for (let property in eventDetails) {
            details[property] = eventDetails[property];
          }
          this.eventBus.dispatch(eventName, details);
        }
        if (close) {
          this.close();
        }
      });
    }
  }
  _bindCursorToolsListener(buttons) {
    this.eventBus.on('cursortoolchanged', function (evt) {
      buttons.cursorSelectToolButton.classList.remove('toggled');
      buttons.cursorHandToolButton.classList.remove('toggled');
      switch (evt.tool) {
        case _pdf_cursor_tools.CursorTool.SELECT:
          buttons.cursorSelectToolButton.classList.add('toggled');
          break;
        case _pdf_cursor_tools.CursorTool.HAND:
          buttons.cursorHandToolButton.classList.add('toggled');
          break;
      }
    });
  }
  open() {
    if (this.opened) {
      return;
    }
    this.opened = true;
    this._setMaxHeight();
    this.toggleButton.classList.add('toggled');
    this.toolbar.classList.remove('hidden');
  }
  close() {
    if (!this.opened) {
      return;
    }
    this.opened = false;
    this.toolbar.classList.add('hidden');
    this.toggleButton.classList.remove('toggled');
  }
  toggle() {
    if (this.opened) {
      this.close();
    } else {
      this.open();
    }
  }
  _setMaxHeight() {
    if (!this.opened) {
      return;
    }
    this.containerHeight = this.mainContainer.clientHeight;
    if (this.containerHeight === this.previousContainerHeight) {
      return;
    }
    this.toolbarButtonContainer.setAttribute('style', 'max-height: ' + (this.containerHeight - _ui_utils.SCROLLBAR_PADDING) + 'px;');
    this.previousContainerHeight = this.containerHeight;
  }
}
exports.SecondaryToolbar = SecondaryToolbar;

/***/ }),
/* 28 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.DefaultTextLayerFactory = exports.TextLayerBuilder = undefined;

var _dom_events = __webpack_require__(2);

var _pdfjsLib = __webpack_require__(1);

const EXPAND_DIVS_TIMEOUT = 300;
class TextLayerBuilder {
  constructor({ textLayerDiv, eventBus, pageIndex, viewport, findController = null, enhanceTextSelection = false }) {
    this.textLayerDiv = textLayerDiv;
    this.eventBus = eventBus || (0, _dom_events.getGlobalEventBus)();
    this.textContent = null;
    this.textContentItemsStr = [];
    this.textContentStream = null;
    this.renderingDone = false;
    this.pageIdx = pageIndex;
    this.pageNumber = this.pageIdx + 1;
    this.matches = [];
    this.viewport = viewport;
    this.textDivs = [];
    this.findController = findController;
    this.textLayerRenderTask = null;
    this.enhanceTextSelection = enhanceTextSelection;
    this._bindMouse();
  }
  _finishRendering() {
    this.renderingDone = true;
    if (!this.enhanceTextSelection) {
      let endOfContent = document.createElement('div');
      endOfContent.className = 'endOfContent';
      this.textLayerDiv.appendChild(endOfContent);
    }
    this.eventBus.dispatch('textlayerrendered', {
      source: this,
      pageNumber: this.pageNumber,
      numTextDivs: this.textDivs.length
    });
  }
  render(timeout = 0) {
    if (!(this.textContent || this.textContentStream) || this.renderingDone) {
      return;
    }
    this.cancel();
    this.textDivs = [];
    let textLayerFrag = document.createDocumentFragment();
    this.textLayerRenderTask = (0, _pdfjsLib.renderTextLayer)({
      textContent: this.textContent,
      textContentStream: this.textContentStream,
      container: textLayerFrag,
      viewport: this.viewport,
      textDivs: this.textDivs,
      textContentItemsStr: this.textContentItemsStr,
      timeout,
      enhanceTextSelection: this.enhanceTextSelection
    });
    this.textLayerRenderTask.promise.then(() => {
      this.textLayerDiv.appendChild(textLayerFrag);
      this._finishRendering();
      this.updateMatches();
    }, function (reason) {});
  }
  cancel() {
    if (this.textLayerRenderTask) {
      this.textLayerRenderTask.cancel();
      this.textLayerRenderTask = null;
    }
  }
  setTextContentStream(readableStream) {
    this.cancel();
    this.textContentStream = readableStream;
  }
  setTextContent(textContent) {
    this.cancel();
    this.textContent = textContent;
  }
  convertMatches(matches, matchesLength) {
    let i = 0;
    let iIndex = 0;
    let textContentItemsStr = this.textContentItemsStr;
    let end = textContentItemsStr.length - 1;
    let queryLen = this.findController === null ? 0 : this.findController.state.query.length;
    let ret = [];
    if (!matches) {
      return ret;
    }
    for (let m = 0, len = matches.length; m < len; m++) {
      let matchIdx = matches[m];
      while (i !== end && matchIdx >= iIndex + textContentItemsStr[i].length) {
        iIndex += textContentItemsStr[i].length;
        i++;
      }
      if (i === textContentItemsStr.length) {
        console.error('Could not find a matching mapping');
      }
      let match = {
        begin: {
          divIdx: i,
          offset: matchIdx - iIndex
        }
      };
      if (matchesLength) {
        matchIdx += matchesLength[m];
      } else {
        matchIdx += queryLen;
      }
      while (i !== end && matchIdx > iIndex + textContentItemsStr[i].length) {
        iIndex += textContentItemsStr[i].length;
        i++;
      }
      match.end = {
        divIdx: i,
        offset: matchIdx - iIndex
      };
      ret.push(match);
    }
    return ret;
  }
  renderMatches(matches) {
    if (matches.length === 0) {
      return;
    }
    let textContentItemsStr = this.textContentItemsStr;
    let textDivs = this.textDivs;
    let prevEnd = null;
    let pageIdx = this.pageIdx;
    let isSelectedPage = this.findController === null ? false : pageIdx === this.findController.selected.pageIdx;
    let selectedMatchIdx = this.findController === null ? -1 : this.findController.selected.matchIdx;
    let highlightAll = this.findController === null ? false : this.findController.state.highlightAll;
    let infinity = {
      divIdx: -1,
      offset: undefined
    };
    function beginText(begin, className) {
      let divIdx = begin.divIdx;
      textDivs[divIdx].textContent = '';
      appendTextToDiv(divIdx, 0, begin.offset, className);
    }
    function appendTextToDiv(divIdx, fromOffset, toOffset, className) {
      let div = textDivs[divIdx];
      let content = textContentItemsStr[divIdx].substring(fromOffset, toOffset);
      let node = document.createTextNode(content);
      if (className) {
        let span = document.createElement('span');
        span.className = className;
        span.appendChild(node);
        div.appendChild(span);
        return;
      }
      div.appendChild(node);
    }
    let i0 = selectedMatchIdx,
        i1 = i0 + 1;
    if (highlightAll) {
      i0 = 0;
      i1 = matches.length;
    } else if (!isSelectedPage) {
      return;
    }
    for (let i = i0; i < i1; i++) {
      let match = matches[i];
      let begin = match.begin;
      let end = match.end;
      let isSelected = isSelectedPage && i === selectedMatchIdx;
      let highlightSuffix = isSelected ? ' selected' : '';
      if (this.findController) {
        this.findController.updateMatchPosition(pageIdx, i, textDivs, begin.divIdx);
      }
      if (!prevEnd || begin.divIdx !== prevEnd.divIdx) {
        if (prevEnd !== null) {
          appendTextToDiv(prevEnd.divIdx, prevEnd.offset, infinity.offset);
        }
        beginText(begin);
      } else {
        appendTextToDiv(prevEnd.divIdx, prevEnd.offset, begin.offset);
      }
      if (begin.divIdx === end.divIdx) {
        appendTextToDiv(begin.divIdx, begin.offset, end.offset, 'highlight' + highlightSuffix);
      } else {
        appendTextToDiv(begin.divIdx, begin.offset, infinity.offset, 'highlight begin' + highlightSuffix);
        for (let n0 = begin.divIdx + 1, n1 = end.divIdx; n0 < n1; n0++) {
          textDivs[n0].className = 'highlight middle' + highlightSuffix;
        }
        beginText(end, 'highlight end' + highlightSuffix);
      }
      prevEnd = end;
    }
    if (prevEnd) {
      appendTextToDiv(prevEnd.divIdx, prevEnd.offset, infinity.offset);
    }
  }
  updateMatches() {
    if (!this.renderingDone) {
      return;
    }
    let matches = this.matches;
    let textDivs = this.textDivs;
    let textContentItemsStr = this.textContentItemsStr;
    let clearedUntilDivIdx = -1;
    for (let i = 0, len = matches.length; i < len; i++) {
      let match = matches[i];
      let begin = Math.max(clearedUntilDivIdx, match.begin.divIdx);
      for (let n = begin, end = match.end.divIdx; n <= end; n++) {
        let div = textDivs[n];
        div.textContent = textContentItemsStr[n];
        div.className = '';
      }
      clearedUntilDivIdx = match.end.divIdx + 1;
    }
    if (this.findController === null || !this.findController.active) {
      return;
    }
    let pageMatches, pageMatchesLength;
    if (this.findController !== null) {
      pageMatches = this.findController.pageMatches[this.pageIdx] || null;
      pageMatchesLength = this.findController.pageMatchesLength ? this.findController.pageMatchesLength[this.pageIdx] || null : null;
    }
    this.matches = this.convertMatches(pageMatches, pageMatchesLength);
    this.renderMatches(this.matches);
  }
  _bindMouse() {
    let div = this.textLayerDiv;
    let expandDivsTimer = null;
    div.addEventListener('mousedown', evt => {
      if (this.enhanceTextSelection && this.textLayerRenderTask) {
        this.textLayerRenderTask.expandTextDivs(true);
        return;
      }
      let end = div.querySelector('.endOfContent');
      if (!end) {
        return;
      }
      end.classList.add('active');
    });
    div.addEventListener('mouseup', () => {
      if (this.enhanceTextSelection && this.textLayerRenderTask) {
        this.textLayerRenderTask.expandTextDivs(false);
        return;
      }
      let end = div.querySelector('.endOfContent');
      if (!end) {
        return;
      }
      end.classList.remove('active');
    });
  }
}
class DefaultTextLayerFactory {
  createTextLayerBuilder(textLayerDiv, pageIndex, viewport, enhanceTextSelection = false) {
    return new TextLayerBuilder({
      textLayerDiv,
      pageIndex,
      viewport,
      enhanceTextSelection
    });
  }
}
exports.TextLayerBuilder = TextLayerBuilder;
exports.DefaultTextLayerFactory = DefaultTextLayerFactory;

/***/ }),
/* 29 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.Toolbar = undefined;

var _ui_utils = __webpack_require__(0);

const PAGE_NUMBER_LOADING_INDICATOR = 'visiblePageIsLoading';
const SCALE_SELECT_CONTAINER_PADDING = 8;
const SCALE_SELECT_PADDING = 22;
class Toolbar {
  constructor(options, mainContainer, eventBus, l10n = _ui_utils.NullL10n) {
    this.toolbar = options.container;
    this.mainContainer = mainContainer;
    this.eventBus = eventBus;
    this.l10n = l10n;
    this.items = options;
    this._wasLocalized = false;
    this.reset();
    this._bindListeners();
  }
  setPageNumber(pageNumber, pageLabel) {
    this.pageNumber = pageNumber;
    this.pageLabel = pageLabel;
    this._updateUIState(false);
  }
  setPagesCount(pagesCount, hasPageLabels) {
    this.pagesCount = pagesCount;
    this.hasPageLabels = hasPageLabels;
    this._updateUIState(true);
  }
  setPageScale(pageScaleValue, pageScale) {
    this.pageScaleValue = pageScaleValue;
    this.pageScale = pageScale;
    this._updateUIState(false);
  }
  reset() {
    this.pageNumber = 0;
    this.pageLabel = null;
    this.hasPageLabels = false;
    this.pagesCount = 0;
    this.pageScaleValue = _ui_utils.DEFAULT_SCALE_VALUE;
    this.pageScale = _ui_utils.DEFAULT_SCALE;
    this._updateUIState(true);
  }
  _bindListeners() {
    let { eventBus, items } = this;
    let self = this;
    items.previous.addEventListener('click', function () {
      eventBus.dispatch('previouspage');
    });
    items.next.addEventListener('click', function () {
      eventBus.dispatch('nextpage');
    });
    items.zoomIn.addEventListener('click', function () {
      eventBus.dispatch('zoomin');
    });
    items.zoomOut.addEventListener('click', function () {
      eventBus.dispatch('zoomout');
    });
    items.pageNumber.addEventListener('click', function () {
      this.select();
    });
    items.pageNumber.addEventListener('change', function () {
      eventBus.dispatch('pagenumberchanged', {
        source: self,
        value: this.value
      });
    });
    items.scaleSelect.addEventListener('change', function () {
      if (this.value === 'custom') {
        return;
      }
      eventBus.dispatch('scalechanged', {
        source: self,
        value: this.value
      });
    });
    items.presentationModeButton.addEventListener('click', function () {
      eventBus.dispatch('presentationmode');
    });
    items.openFile.addEventListener('click', function () {
      eventBus.dispatch('openfile');
    });
    items.print.addEventListener('click', function () {
      eventBus.dispatch('print');
    });
    items.download.addEventListener('click', function () {
      eventBus.dispatch('download');
    });
    items.scaleSelect.oncontextmenu = _ui_utils.noContextMenuHandler;
    eventBus.on('localized', () => {
      this._localized();
    });
  }
  _localized() {
    this._wasLocalized = true;
    this._adjustScaleWidth();
    this._updateUIState(true);
  }
  _updateUIState(resetNumPages = false) {
    if (!this._wasLocalized) {
      return;
    }
    let { pageNumber, pagesCount, items } = this;
    let scaleValue = (this.pageScaleValue || this.pageScale).toString();
    let scale = this.pageScale;
    if (resetNumPages) {
      if (this.hasPageLabels) {
        items.pageNumber.type = 'text';
      } else {
        items.pageNumber.type = 'number';
        this.l10n.get('of_pages', { pagesCount }, 'of {{pagesCount}}').then(msg => {
          items.numPages.textContent = msg;
        });
      }
      items.pageNumber.max = pagesCount;
    }
    if (this.hasPageLabels) {
      items.pageNumber.value = this.pageLabel;
      this.l10n.get('page_of_pages', {
        pageNumber,
        pagesCount
      }, '({{pageNumber}} of {{pagesCount}})').then(msg => {
        items.numPages.textContent = msg;
      });
    } else {
      items.pageNumber.value = pageNumber;
    }
    items.previous.disabled = pageNumber <= 1;
    items.next.disabled = pageNumber >= pagesCount;
    items.zoomOut.disabled = scale <= _ui_utils.MIN_SCALE;
    items.zoomIn.disabled = scale >= _ui_utils.MAX_SCALE;
    let customScale = Math.round(scale * 10000) / 100;
    this.l10n.get('page_scale_percent', { scale: customScale }, '{{scale}}%').then(msg => {
      let options = items.scaleSelect.options;
      let predefinedValueFound = false;
      for (let i = 0, ii = options.length; i < ii; i++) {
        let option = options[i];
        if (option.value !== scaleValue) {
          option.selected = false;
          continue;
        }
        option.selected = true;
        predefinedValueFound = true;
      }
      if (!predefinedValueFound) {
        items.customScaleOption.textContent = msg;
        items.customScaleOption.selected = true;
      }
    });
  }
  updateLoadingIndicatorState(loading = false) {
    let pageNumberInput = this.items.pageNumber;
    if (loading) {
      pageNumberInput.classList.add(PAGE_NUMBER_LOADING_INDICATOR);
    } else {
      pageNumberInput.classList.remove(PAGE_NUMBER_LOADING_INDICATOR);
    }
  }
  _adjustScaleWidth() {
    let container = this.items.scaleSelectContainer;
    let select = this.items.scaleSelect;
    _ui_utils.animationStarted.then(function () {
      if (container.clientWidth === 0) {
        container.setAttribute('style', 'display: inherit;');
      }
      if (container.clientWidth > 0) {
        select.setAttribute('style', 'min-width: inherit;');
        let width = select.clientWidth + SCALE_SELECT_CONTAINER_PADDING;
        select.setAttribute('style', 'min-width: ' + (width + SCALE_SELECT_PADDING) + 'px;');
        container.setAttribute('style', 'min-width: ' + width + 'px; ' + 'max-width: ' + width + 'px;');
      }
    });
  }
}
exports.Toolbar = Toolbar;

/***/ }),
/* 30 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
const DEFAULT_VIEW_HISTORY_CACHE_SIZE = 20;
class ViewHistory {
  constructor(fingerprint, cacheSize = DEFAULT_VIEW_HISTORY_CACHE_SIZE) {
    this.fingerprint = fingerprint;
    this.cacheSize = cacheSize;
    this._initializedPromise = this._readFromStorage().then(databaseStr => {
      let database = JSON.parse(databaseStr || '{}');
      if (!('files' in database)) {
        database.files = [];
      }
      if (database.files.length >= this.cacheSize) {
        database.files.shift();
      }
      let index;
      for (let i = 0, length = database.files.length; i < length; i++) {
        let branch = database.files[i];
        if (branch.fingerprint === this.fingerprint) {
          index = i;
          break;
        }
      }
      if (typeof index !== 'number') {
        index = database.files.push({ fingerprint: this.fingerprint }) - 1;
      }
      this.file = database.files[index];
      this.database = database;
    });
  }
  _writeToStorage() {
    return new Promise(resolve => {
      let databaseStr = JSON.stringify(this.database);
      sessionStorage.setItem('pdfjs.history', databaseStr);
      resolve();
    });
  }
  _readFromStorage() {
    return new Promise(function (resolve) {
      resolve(sessionStorage.getItem('pdfjs.history'));
    });
  }
  set(name, val) {
    return this._initializedPromise.then(() => {
      this.file[name] = val;
      return this._writeToStorage();
    });
  }
  setMultiple(properties) {
    return this._initializedPromise.then(() => {
      for (let name in properties) {
        this.file[name] = properties[name];
      }
      return this._writeToStorage();
    });
  }
  get(name, defaultValue) {
    return this._initializedPromise.then(() => {
      let val = this.file[name];
      return val !== undefined ? val : defaultValue;
    });
  }
  getMultiple(properties) {
    return this._initializedPromise.then(() => {
      let values = Object.create(null);
      for (let name in properties) {
        let val = this.file[name];
        values[name] = val !== undefined ? val : properties[name];
      }
      return values;
    });
  }
}
exports.ViewHistory = ViewHistory;

/***/ }),
/* 31 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


let DEFAULT_URL = 'compressed.tracemonkey-pldi-09.pdf';
;
let pdfjsWebApp;
{
  pdfjsWebApp = __webpack_require__(4);
}
{
  __webpack_require__(9);
  __webpack_require__(8);
}
;
;
;
function getViewerConfiguration() {
  return {
    appContainer: document.body,
    mainContainer: document.getElementById('viewerContainer'),
    viewerContainer: document.getElementById('viewer'),
    eventBus: null,
    toolbar: {
      container: document.getElementById('toolbarViewer'),
      numPages: document.getElementById('numPages'),
      pageNumber: document.getElementById('pageNumber'),
      scaleSelectContainer: document.getElementById('scaleSelectContainer'),
      scaleSelect: document.getElementById('scaleSelect'),
      customScaleOption: document.getElementById('customScaleOption'),
      previous: document.getElementById('previous'),
      next: document.getElementById('next'),
      zoomIn: document.getElementById('zoomIn'),
      zoomOut: document.getElementById('zoomOut'),
      viewFind: document.getElementById('viewFind'),
      openFile: document.getElementById('openFile'),
      print: document.getElementById('print'),
      presentationModeButton: document.getElementById('presentationMode'),
      download: document.getElementById('download'),
      viewBookmark: document.getElementById('viewBookmark')
    },
    secondaryToolbar: {
      toolbar: document.getElementById('secondaryToolbar'),
      toggleButton: document.getElementById('secondaryToolbarToggle'),
      toolbarButtonContainer: document.getElementById('secondaryToolbarButtonContainer'),
      presentationModeButton: document.getElementById('secondaryPresentationMode'),
      openFileButton: document.getElementById('secondaryOpenFile'),
      printButton: document.getElementById('secondaryPrint'),
      downloadButton: document.getElementById('secondaryDownload'),
      viewBookmarkButton: document.getElementById('secondaryViewBookmark'),
      firstPageButton: document.getElementById('firstPage'),
      lastPageButton: document.getElementById('lastPage'),
      pageRotateCwButton: document.getElementById('pageRotateCw'),
      pageRotateCcwButton: document.getElementById('pageRotateCcw'),
      cursorSelectToolButton: document.getElementById('cursorSelectTool'),
      cursorHandToolButton: document.getElementById('cursorHandTool'),
      documentPropertiesButton: document.getElementById('documentProperties')
    },
    fullscreen: {
      contextFirstPage: document.getElementById('contextFirstPage'),
      contextLastPage: document.getElementById('contextLastPage'),
      contextPageRotateCw: document.getElementById('contextPageRotateCw'),
      contextPageRotateCcw: document.getElementById('contextPageRotateCcw')
    },
    sidebar: {
      mainContainer: document.getElementById('mainContainer'),
      outerContainer: document.getElementById('outerContainer'),
      toggleButton: document.getElementById('sidebarToggle'),
      thumbnailButton: document.getElementById('viewThumbnail'),
      outlineButton: document.getElementById('viewOutline'),
      attachmentsButton: document.getElementById('viewAttachments'),
      thumbnailView: document.getElementById('thumbnailView'),
      outlineView: document.getElementById('outlineView'),
      attachmentsView: document.getElementById('attachmentsView')
    },
    findBar: {
      bar: document.getElementById('findbar'),
      toggleButton: document.getElementById('viewFind'),
      findField: document.getElementById('findInput'),
      highlightAllCheckbox: document.getElementById('findHighlightAll'),
      caseSensitiveCheckbox: document.getElementById('findMatchCase'),
      findMsg: document.getElementById('findMsg'),
      findResultsCount: document.getElementById('findResultsCount'),
      findStatusIcon: document.getElementById('findStatusIcon'),
      findPreviousButton: document.getElementById('findPrevious'),
      findNextButton: document.getElementById('findNext')
    },
    passwordOverlay: {
      overlayName: 'passwordOverlay',
      container: document.getElementById('passwordOverlay'),
      label: document.getElementById('passwordText'),
      input: document.getElementById('password'),
      submitButton: document.getElementById('passwordSubmit'),
      cancelButton: document.getElementById('passwordCancel')
    },
    documentProperties: {
      overlayName: 'documentPropertiesOverlay',
      container: document.getElementById('documentPropertiesOverlay'),
      closeButton: document.getElementById('documentPropertiesClose'),
      fields: {
        'fileName': document.getElementById('fileNameField'),
        'fileSize': document.getElementById('fileSizeField'),
        'title': document.getElementById('titleField'),
        'author': document.getElementById('authorField'),
        'subject': document.getElementById('subjectField'),
        'keywords': document.getElementById('keywordsField'),
        'creationDate': document.getElementById('creationDateField'),
        'modificationDate': document.getElementById('modificationDateField'),
        'creator': document.getElementById('creatorField'),
        'producer': document.getElementById('producerField'),
        'version': document.getElementById('versionField'),
        'pageCount': document.getElementById('pageCountField')
      }
    },
    errorWrapper: {
      container: document.getElementById('errorWrapper'),
      errorMessage: document.getElementById('errorMessage'),
      closeButton: document.getElementById('errorClose'),
      errorMoreInfo: document.getElementById('errorMoreInfo'),
      moreInfoButton: document.getElementById('errorShowMore'),
      lessInfoButton: document.getElementById('errorShowLess')
    },
    printContainer: document.getElementById('printContainer'),
    openFileInputName: 'fileInput',
    debuggerScriptPath: './debugger.js',
    defaultUrl: DEFAULT_URL
  };
}
function webViewerLoad() {
  let config = getViewerConfiguration();
  window.PDFViewerApplication = pdfjsWebApp.PDFViewerApplication;
  pdfjsWebApp.PDFViewerApplication.run(config);
}
if (document.readyState === 'interactive' || document.readyState === 'complete') {
  webViewerLoad();
} else {
  document.addEventListener('DOMContentLoaded', webViewerLoad, true);
}

/***/ })
/******/ ]);