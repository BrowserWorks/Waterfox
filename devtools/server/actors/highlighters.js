/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const { Ci, Cu } = require("chrome");

const ChromeUtils = require("ChromeUtils");
const EventEmitter = require("devtools/shared/event-emitter");
const protocol = require("devtools/shared/protocol");
const Services = require("Services");
const {
  highlighterSpec,
  customHighlighterSpec,
} = require("devtools/shared/specs/highlighters");

loader.lazyRequireGetter(
  this,
  "isWindowIncluded",
  "devtools/shared/layout/utils",
  true
);
loader.lazyRequireGetter(
  this,
  "isRemoteFrame",
  "devtools/shared/layout/utils",
  true
);
loader.lazyRequireGetter(
  this,
  "isXUL",
  "devtools/server/actors/highlighters/utils/markup",
  true
);
loader.lazyRequireGetter(
  this,
  "SimpleOutlineHighlighter",
  "devtools/server/actors/highlighters/simple-outline",
  true
);
loader.lazyRequireGetter(
  this,
  "BoxModelHighlighter",
  "devtools/server/actors/highlighters/box-model",
  true
);

const HIGHLIGHTER_PICKED_TIMER = 1000;
const IS_OSX = Services.appinfo.OS === "Darwin";

/**
 * The registration mechanism for highlighters provide a quick way to
 * have modular highlighters, instead of a hard coded list.
 * It allow us to split highlighers in sub modules, and add them dynamically
 * using add-on (useful for 3rd party developers, or prototyping)
 *
 * Note that currently, highlighters added using add-ons, can only work on
 * Firefox desktop, or Fennec if the same add-on is installed in both.
 */
const highlighterTypes = new Map();

/**
 * Returns `true` if a highlighter for the given `typeName` is registered,
 * `false` otherwise.
 */
const isTypeRegistered = typeName => highlighterTypes.has(typeName);
exports.isTypeRegistered = isTypeRegistered;

/**
 * Registers a given constructor as highlighter, for the `typeName` given.
 * If no `typeName` is provided, the `typeName` property on the constructor's prototype
 * is used, if one is found, otherwise the name of the constructor function is used.
 */
const register = (typeName, modulePath) => {
  if (highlighterTypes.has(typeName)) {
    throw Error(`${typeName} is already registered.`);
  }

  highlighterTypes.set(typeName, modulePath);
};
exports.register = register;

/**
 * The Highlighter is the server-side entry points for any tool that wishes to
 * highlight elements in some way in the content document.
 *
 * A little bit of vocabulary:
 * - <something>HighlighterActor classes are the actors that can be used from
 *   the client. They do very little else than instantiate a given
 *   <something>Highlighter and use it to highlight elements.
 * - <something>Highlighter classes aren't actors, they're just JS classes that
 *   know how to create and attach the actual highlighter elements on top of the
 *   content
 *
 * The most used highlighter actor is the HighlighterActor which can be
 * conveniently retrieved via the InspectorActor's 'getHighlighter' method.
 * The InspectorActor will always return the same instance of
 * HighlighterActor if asked several times and this instance is used in the
 * toolbox to highlighter elements's box-model from the markup-view,
 * box model view, console, debugger, ... as well as select elements with the
 * pointer (pick).
 *
 * Other types of highlighter actors exist and can be accessed via the
 * InspectorActor's 'getHighlighterByType' method.
 */

/**
 * The HighlighterActor class
 */
exports.HighlighterActor = protocol.ActorClassWithSpec(highlighterSpec, {
  initialize: function(inspector, autohide) {
    protocol.Actor.prototype.initialize.call(this, null);

    this._autohide = autohide;
    this._inspector = inspector;
    this._walker = this._inspector.walker;
    this._targetActor = this._inspector.targetActor;
    this._highlighterEnv = new HighlighterEnvironment();
    this._highlighterEnv.initFromTargetActor(this._targetActor);

    this._onNavigate = this._onNavigate.bind(this);

    const doc = this._targetActor.window.document;
    // Only try to create the highlighter when the document is loaded,
    // otherwise, wait for the navigate event to fire.
    if (doc.documentElement && doc.readyState != "uninitialized") {
      this._createHighlighter();
    }

    // Listen to navigation events to switch from the BoxModelHighlighter to the
    // SimpleOutlineHighlighter, and back, if the top level window changes.
    this._targetActor.on("navigate", this._onNavigate);
  },

  get conn() {
    return this._inspector && this._inspector.conn;
  },

  form: function() {
    return {
      actor: this.actorID,
    };
  },

  _createHighlighter: function() {
    this._isPreviousWindowXUL = isXUL(this._targetActor.window);

    if (!this._isPreviousWindowXUL) {
      this._highlighter = new BoxModelHighlighter(
        this._highlighterEnv,
        this._inspector
      );
    } else {
      this._highlighter = new SimpleOutlineHighlighter(this._highlighterEnv);
    }
  },

  _destroyHighlighter: function() {
    if (this._highlighter) {
      this._highlighter.destroy();
      this._highlighter = null;
    }
  },

  _onNavigate: function({ isTopLevel }) {
    // Skip navigation events for non top-level windows, or if the document
    // doesn't exist anymore.
    if (!isTopLevel || !this._targetActor.window.document.documentElement) {
      return;
    }

    // Only rebuild the highlighter if the window type changed.
    if (isXUL(this._targetActor.window) !== this._isPreviousWindowXUL) {
      this._destroyHighlighter();
      this._createHighlighter();
    }
  },

  destroy: function() {
    protocol.Actor.prototype.destroy.call(this);

    this.hideBoxModel();
    this.cancelPick();
    this._destroyHighlighter();
    this._targetActor.off("navigate", this._onNavigate);

    this._highlighterEnv.destroy();
    this._highlighterEnv = null;

    this._autohide = null;
    this._inspector = null;
    this._walker = null;
    this._targetActor = null;
  },

  /**
   * Display the box model highlighting on a given NodeActor.
   * There is only one instance of the box model highlighter, so calling this
   * method several times won't display several highlighters, it will just move
   * the highlighter instance to these nodes.
   *
   * @param NodeActor The node to be highlighted
   * @param Options See the request part for existing options. Note that not
   * all options may be supported by all types of highlighters.
   */
  showBoxModel: function(node, options = {}) {
    if (!node || !this._highlighter.show(node.rawNode, options)) {
      this._highlighter.hide();
    }
  },

  /**
   * Hide the box model highlighting if it was shown before
   */
  hideBoxModel: function() {
    if (this._highlighter) {
      this._highlighter.hide();
    }

    // Since the node-picker works independently in each remote frame, the inspector
    // front-end decides which highlighter to show and hide while picking.
    // If we're being asked to hide here, we should also reset the current hovered node so
    // we can start highlighting correctly again later.
    this._hoveredNode = null;
  },

  /**
   * Returns `true` if the event was dispatched from a window included in
   * the current highlighter environment; or if the highlighter environment has
   * chrome privileges
   *
   * The method is specifically useful on B2G, where we do not want that events
   * from app or main process are processed if we're inspecting the content.
   *
   * @param {Event} event
   *          The event to allow
   * @return {Boolean}
   */
  _isEventAllowed: function({ view }) {
    const { window } = this._highlighterEnv;

    return (
      window instanceof Ci.nsIDOMChromeWindow || isWindowIncluded(window, view)
    );
  },

  /**
   * Pick a node on click, and highlight hovered nodes in the process.
   *
   * This method doesn't respond anything interesting, however, it starts
   * mousemove, and click listeners on the content document to fire
   * events and let connected clients know when nodes are hovered over or
   * clicked.
   *
   * Once a node is picked, events will cease, and listeners will be removed.
   */
  _isPicking: false,
  _hoveredNode: null,
  _currentNode: null,

  pick: function() {
    if (this._targetActor.threadActor) {
      this._targetActor.threadActor.hideOverlay();
    }

    if (this._isPicking) {
      return null;
    }
    this._isPicking = true;

    // In most cases, we need to prevent content events from reaching the content. This is
    // needed to avoid triggering actions such as submitting forms or following links.
    // In the case where the event happens on a remote frame however, we do want to let it
    // through. That is because otherwise the pickers started in nested remote frames will
    // never have a chance of picking their own elements.
    this._preventContentEvent = event => {
      if (isRemoteFrame(event.target)) {
        return;
      }
      event.stopPropagation();
      event.preventDefault();
    };

    this._onPick = event => {
      // If the picked node is a remote frame, then we need to let the event through
      // since there's a highlighter actor in that sub-frame also picking.
      if (isRemoteFrame(event.target)) {
        return;
      }

      this._preventContentEvent(event);

      if (!this._isEventAllowed(event)) {
        return;
      }

      // If shift is pressed, this is only a preview click, send the event to
      // the client, but don't stop picking.
      if (event.shiftKey) {
        this._walker.emit(
          "picker-node-previewed",
          this._findAndAttachElement(event)
        );
        return;
      }
      this._stopPickerListeners();
      this._isPicking = false;
      if (this._autohide) {
        this._targetActor.window.setTimeout(() => {
          this._highlighter.hide();
        }, HIGHLIGHTER_PICKED_TIMER);
      }
      if (!this._currentNode) {
        this._currentNode = this._findAndAttachElement(event);
      }
      this._walker.emit("picker-node-picked", this._currentNode);
    };

    this._onHovered = event => {
      // If the hovered node is a remote frame, then we need to let the event through
      // since there's a highlighter actor in that sub-frame also picking.
      if (isRemoteFrame(event.target)) {
        return;
      }

      this._preventContentEvent(event);
      if (!this._isEventAllowed(event)) {
        return;
      }

      this._currentNode = this._findAndAttachElement(event);
      if (this._hoveredNode !== this._currentNode.node) {
        this._highlighter.show(this._currentNode.node.rawNode);
        this._walker.emit("picker-node-hovered", this._currentNode);
        this._hoveredNode = this._currentNode.node;
      }
    };

    this._onKey = event => {
      if (!this._currentNode || !this._isPicking) {
        return;
      }

      this._preventContentEvent(event);

      if (!this._isEventAllowed(event)) {
        return;
      }

      let currentNode = this._currentNode.node.rawNode;

      /**
       * KEY: Action/scope
       * LEFT_KEY: wider or parent
       * RIGHT_KEY: narrower or child
       * ENTER/CARRIAGE_RETURN: Picks currentNode
       * ESC/CTRL+SHIFT+C: Cancels picker, picks currentNode
       */
      switch (event.keyCode) {
        // Wider.
        case event.DOM_VK_LEFT:
          if (!currentNode.parentElement) {
            return;
          }
          currentNode = currentNode.parentElement;
          break;

        // Narrower.
        case event.DOM_VK_RIGHT:
          if (!currentNode.children.length) {
            return;
          }

          // Set firstElementChild by default
          let child = currentNode.firstElementChild;
          // If currentNode is parent of hoveredNode, then
          // previously selected childNode is set
          const hoveredNode = this._hoveredNode.rawNode;
          for (const sibling of currentNode.children) {
            if (sibling.contains(hoveredNode) || sibling === hoveredNode) {
              child = sibling;
            }
          }

          currentNode = child;
          break;

        // Select the element.
        case event.DOM_VK_RETURN:
          this._onPick(event);
          return;

        // Cancel pick mode.
        case event.DOM_VK_ESCAPE:
          this.cancelPick();
          this._walker.emit("picker-node-canceled");
          return;
        case event.DOM_VK_C:
          const { altKey, ctrlKey, metaKey, shiftKey } = event;

          if (
            (IS_OSX && metaKey && altKey | shiftKey) ||
            (!IS_OSX && ctrlKey && shiftKey)
          ) {
            this.cancelPick();
            this._walker.emit("picker-node-canceled");
          }
          return;
        default:
          return;
      }

      // Store currently attached element
      this._currentNode = this._walker.attachElement(currentNode);
      this._highlighter.show(this._currentNode.node.rawNode);
      this._walker.emit("picker-node-hovered", this._currentNode);
    };

    this._startPickerListeners();

    return null;
  },

  /**
   * This pick method also focuses the highlighter's target window.
   */
  pickAndFocus: function() {
    // Go ahead and pass on the results to help future-proof this method.
    const pickResults = this.pick();
    this._highlighterEnv.window.focus();
    return pickResults;
  },

  _findAndAttachElement: function(event) {
    // originalTarget allows access to the "real" element before any retargeting
    // is applied, such as in the case of XBL anonymous elements.  See also
    // https://developer.mozilla.org/docs/XBL/XBL_1.0_Reference/Anonymous_Content#Event_Flow_and_Targeting
    const node = event.originalTarget || event.target;
    return this._walker.attachElement(node);
  },

  _onSuppressedEvent(event) {
    if (event.type == "mousemove") {
      this._onHovered(event);
    } else if (event.type == "mouseup") {
      // Suppressed mousedown/mouseup events will be sent to us before they have
      // been converted into click events. Just treat any mouseup as a click.
      this._onPick(event);
    }
  },

  /**
   * When the debugger pauses execution in a page, events will not be delivered
   * to any handlers added to elements on that page. This method uses the
   * document's setSuppressedEventListener interface to bypass this restriction:
   * events will be delivered to the callback at times when they would
   * otherwise be suppressed. The set of events delivered this way is currently
   * limited to mouse events.
   *
   * @param callback The function to call with suppressed events, or null.
   */
  _setSuppressedEventListener(callback) {
    const document = this._targetActor.window.document;

    // Pass the callback to setSuppressedEventListener as an EventListener.
    document.setSuppressedEventListener(
      callback ? { handleEvent: callback } : null
    );
  },

  _startPickerListeners: function() {
    const target = this._highlighterEnv.pageListenerTarget;
    target.addEventListener("mousemove", this._onHovered, true);
    target.addEventListener("click", this._onPick, true);
    target.addEventListener("mousedown", this._preventContentEvent, true);
    target.addEventListener("mouseup", this._preventContentEvent, true);
    target.addEventListener("dblclick", this._preventContentEvent, true);
    target.addEventListener("keydown", this._onKey, true);
    target.addEventListener("keyup", this._preventContentEvent, true);

    this._setSuppressedEventListener(this._onSuppressedEvent.bind(this));
  },

  _stopPickerListeners: function() {
    const target = this._highlighterEnv.pageListenerTarget;

    if (!target) {
      return;
    }

    target.removeEventListener("mousemove", this._onHovered, true);
    target.removeEventListener("click", this._onPick, true);
    target.removeEventListener("mousedown", this._preventContentEvent, true);
    target.removeEventListener("mouseup", this._preventContentEvent, true);
    target.removeEventListener("dblclick", this._preventContentEvent, true);
    target.removeEventListener("keydown", this._onKey, true);
    target.removeEventListener("keyup", this._preventContentEvent, true);

    this._setSuppressedEventListener(null);
  },

  cancelPick: function() {
    if (this._targetActor.threadActor) {
      this._targetActor.threadActor.showOverlay();
    }

    if (this._isPicking) {
      if (this._highlighter) {
        this._highlighter.hide();
      }
      this._stopPickerListeners();
      this._isPicking = false;
      this._hoveredNode = null;
    }
  },
});

/**
 * A generic highlighter actor class that instantiate a highlighter given its
 * type name and allows to show/hide it.
 */
exports.CustomHighlighterActor = protocol.ActorClassWithSpec(
  customHighlighterSpec,
  {
    /**
     * Create a highlighter instance given its typename
     * The typename must be one of HIGHLIGHTER_CLASSES and the class must
     * implement constructor(targetActor), show(node), hide(), destroy()
     */
    initialize: function(parent, typeName) {
      protocol.Actor.prototype.initialize.call(this, null);

      this._parent = parent;

      const modulePath = highlighterTypes.get(typeName);
      if (!modulePath) {
        const list = [...highlighterTypes.keys()];

        throw new Error(
          `${typeName} isn't a valid highlighter class (${list})`
        );
      }

      const constructor = require("devtools/server/actors/highlighters/" +
        modulePath)[typeName];
      // The assumption is that custom highlighters either need the canvasframe
      // container to append their elements and thus a non-XUL window or they have
      // to define a static XULSupported flag that indicates that the highlighter
      // supports XUL windows. Otherwise, bail out.
      if (!isXUL(this._parent.targetActor.window) || constructor.XULSupported) {
        this._highlighterEnv = new HighlighterEnvironment();
        this._highlighterEnv.initFromTargetActor(parent.targetActor);
        this._highlighter = new constructor(this._highlighterEnv);
        if (this._highlighter.on) {
          this._highlighter.on(
            "highlighter-event",
            this._onHighlighterEvent.bind(this)
          );
        }
      } else {
        throw new Error(
          "Custom " + typeName + "highlighter cannot be created in a XUL window"
        );
      }
    },

    get conn() {
      return this._parent && this._parent.conn;
    },

    destroy: function() {
      protocol.Actor.prototype.destroy.call(this);
      this.finalize();
      this._parent = null;
    },

    release: function() {},

    /**
     * Get current instance of the highlighter object.
     */
    get instance() {
      return this._highlighter;
    },

    /**
     * Show the highlighter.
     * This calls through to the highlighter instance's |show(node, options)|
     * method.
     *
     * Most custom highlighters are made to highlight DOM nodes, hence the first
     * NodeActor argument (NodeActor as in
     * devtools/server/actor/inspector).
     * Note however that some highlighters use this argument merely as a context
     * node: The SelectHighlighter for instance uses it as a base node to run the
     * provided CSS selector on.
     *
     * @param {NodeActor} The node to be highlighted
     * @param {Object} Options for the custom highlighter
     * @return {Boolean} True, if the highlighter has been successfully shown
     * (FF41+)
     */
    show: function(node, options) {
      if (!this._highlighter) {
        return null;
      }

      const rawNode = node?.rawNode;

      return this._highlighter.show(rawNode, options);
    },

    /**
     * Hide the highlighter if it was shown before
     */
    hide: function() {
      if (this._highlighter) {
        this._highlighter.hide();
      }
    },

    /**
     * Upon receiving an event from the highlighter, forward it to the client.
     */
    _onHighlighterEvent: function(data) {
      this.emit("highlighter-event", data);
    },

    /**
     * Kill this actor. This method is called automatically just before the actor
     * is destroyed.
     */
    finalize: function() {
      if (this._highlighter) {
        if (this._highlighter.off) {
          this._highlighter.off(
            "highlighter-event",
            this._onHighlighterEvent.bind(this)
          );
        }
        this._highlighter.destroy();
        this._highlighter = null;
      }

      if (this._highlighterEnv) {
        this._highlighterEnv.destroy();
        this._highlighterEnv = null;
      }
    },
  }
);

/**
 * The HighlighterEnvironment is an object that holds all the required data for
 * highlighters to work: the window, docShell, event listener target, ...
 * It also emits "will-navigate", "navigate" and "window-ready" events,
 * similarly to the BrowsingContextTargetActor.
 *
 * It can be initialized either from a BrowsingContextTargetActor (which is the
 * most frequent way of using it, since highlighters are usually initialized by
 * the HighlighterActor or CustomHighlighterActor, which have a targetActor
 * reference). It can also be initialized just with a window object (which is
 * useful for when a highlighter is used outside of the devtools server context.
 */
function HighlighterEnvironment() {
  this.relayTargetActorWindowReady = this.relayTargetActorWindowReady.bind(
    this
  );
  this.relayTargetActorNavigate = this.relayTargetActorNavigate.bind(this);
  this.relayTargetActorWillNavigate = this.relayTargetActorWillNavigate.bind(
    this
  );

  EventEmitter.decorate(this);
}

exports.HighlighterEnvironment = HighlighterEnvironment;

HighlighterEnvironment.prototype = {
  initFromTargetActor: function(targetActor) {
    this._targetActor = targetActor;
    this._targetActor.on("window-ready", this.relayTargetActorWindowReady);
    this._targetActor.on("navigate", this.relayTargetActorNavigate);
    this._targetActor.on("will-navigate", this.relayTargetActorWillNavigate);
  },

  initFromWindow: function(win) {
    this._win = win;

    // We need a progress listener to know when the window will navigate/has
    // navigated.
    const self = this;
    this.listener = {
      QueryInterface: ChromeUtils.generateQI([
        Ci.nsIWebProgressListener,
        Ci.nsISupportsWeakReference,
      ]),

      onStateChange: function(progress, request, flag) {
        const isStart = flag & Ci.nsIWebProgressListener.STATE_START;
        const isStop = flag & Ci.nsIWebProgressListener.STATE_STOP;
        const isWindow = flag & Ci.nsIWebProgressListener.STATE_IS_WINDOW;
        const isDocument = flag & Ci.nsIWebProgressListener.STATE_IS_DOCUMENT;

        if (progress.DOMWindow !== win) {
          return;
        }

        if (isDocument && isStart) {
          // One of the earliest events that tells us a new URI is being loaded
          // in this window.
          self.emit("will-navigate", {
            window: win,
            isTopLevel: true,
          });
        }
        if (isWindow && isStop) {
          self.emit("navigate", {
            window: win,
            isTopLevel: true,
          });
        }
      },
    };

    this.webProgress.addProgressListener(
      this.listener,
      Ci.nsIWebProgress.NOTIFY_STATE_WINDOW |
        Ci.nsIWebProgress.NOTIFY_STATE_DOCUMENT
    );
  },

  get isInitialized() {
    return this._win || this._targetActor;
  },

  get isXUL() {
    return isXUL(this.window);
  },

  get window() {
    if (!this.isInitialized) {
      throw new Error(
        "Initialize HighlighterEnvironment with a targetActor " +
          "or window first"
      );
    }
    const win = this._targetActor ? this._targetActor.window : this._win;

    return Cu.isDeadWrapper(win) ? null : win;
  },

  get document() {
    return this.window && this.window.document;
  },

  get docShell() {
    return this.window && this.window.docShell;
  },

  get webProgress() {
    return (
      this.docShell &&
      this.docShell
        .QueryInterface(Ci.nsIInterfaceRequestor)
        .getInterface(Ci.nsIWebProgress)
    );
  },

  /**
   * Get the right target for listening to events on the page.
   * - If the environment was initialized from a BrowsingContextTargetActor
   *   *and* if we're in the Browser Toolbox (to inspect Firefox Desktop): the
   *   targetActor is the RootActor, in which case, the window property can be
   *   used to listen to events.
   * - With Firefox Desktop, the targetActor is a FrameTargetActor, and we use
   *   the chromeEventHandler which gives us a target we can use to listen to
   *   events, even from nested iframes.
   * - If the environment was initialized from a window, we also use the
   *   chromeEventHandler.
   */
  get pageListenerTarget() {
    if (this._targetActor && this._targetActor.isRootActor) {
      return this.window;
    }
    return this.docShell && this.docShell.chromeEventHandler;
  },

  relayTargetActorWindowReady: function(data) {
    this.emit("window-ready", data);
  },

  relayTargetActorNavigate: function(data) {
    this.emit("navigate", data);
  },

  relayTargetActorWillNavigate: function(data) {
    this.emit("will-navigate", data);
  },

  destroy: function() {
    if (this._targetActor) {
      this._targetActor.off("window-ready", this.relayTargetActorWindowReady);
      this._targetActor.off("navigate", this.relayTargetActorNavigate);
      this._targetActor.off("will-navigate", this.relayTargetActorWillNavigate);
    }

    // In case the environment was initialized from a window, we need to remove
    // the progress listener.
    if (this._win) {
      try {
        this.webProgress.removeProgressListener(this.listener);
      } catch (e) {
        // Which may fail in case the window was already destroyed.
      }
    }

    this._targetActor = null;
    this._win = null;
  },
};

register("BoxModelHighlighter", "box-model");
register("CssGridHighlighter", "css-grid");
register("CssTransformHighlighter", "css-transform");
register("EyeDropper", "eye-dropper");
register("FlexboxHighlighter", "flexbox");
register("FontsHighlighter", "fonts");
register("GeometryEditorHighlighter", "geometry-editor");
register("MeasuringToolHighlighter", "measuring-tool");
register("PausedDebuggerOverlay", "paused-debugger");
register("RulersHighlighter", "rulers");
register("SelectorHighlighter", "selector");
register("ShapesHighlighter", "shapes");
