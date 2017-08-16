/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const {Task} = require("devtools/shared/task");
const EventEmitter = require("devtools/shared/event-emitter");
const {
  createNode,
  findOptimalTimeInterval,
  getFormattedAnimationTitle,
  TimeScale,
  getCssPropertyName
} = require("devtools/client/animationinspector/utils");
const {AnimationDetails} = require("devtools/client/animationinspector/components/animation-details");
const {AnimationTargetNode} = require("devtools/client/animationinspector/components/animation-target-node");
const {AnimationTimeBlock} = require("devtools/client/animationinspector/components/animation-time-block");

const { LocalizationHelper } = require("devtools/shared/l10n");
const L10N =
  new LocalizationHelper("devtools/client/locales/animationinspector.properties");

// The minimum spacing between 2 time graduation headers in the timeline (px).
const TIME_GRADUATION_MIN_SPACING = 40;
// When the container window is resized, the timeline background gets refreshed,
// but only after a timer, and the timer is reset if the window is continuously
// resized.
const TIMELINE_BACKGROUND_RESIZE_DEBOUNCE_TIMER = 50;

/**
 * UI component responsible for displaying a timeline for animations.
 * The timeline is essentially a graph with time along the x axis and animations
 * along the y axis.
 * The time is represented with a graduation header at the top and a current
 * time play head.
 * Animations are organized by lines, with a left margin containing the preview
 * of the target DOM element the animation applies to.
 * The current time play head can be moved by clicking/dragging in the header.
 * when this happens, the component emits "current-data-changed" events with the
 * new time and state of the timeline.
 *
 * @param {InspectorPanel} inspector.
 * @param {Object} serverTraits The list of server-side capabilities.
 */
function AnimationsTimeline(inspector, serverTraits) {
  this.animations = [];
  this.tracksMap = new WeakMap();
  this.targetNodes = [];
  this.timeBlocks = [];
  this.inspector = inspector;
  this.serverTraits = serverTraits;

  this.onAnimationStateChanged = this.onAnimationStateChanged.bind(this);
  this.onScrubberMouseDown = this.onScrubberMouseDown.bind(this);
  this.onScrubberMouseUp = this.onScrubberMouseUp.bind(this);
  this.onScrubberMouseOut = this.onScrubberMouseOut.bind(this);
  this.onScrubberMouseMove = this.onScrubberMouseMove.bind(this);
  this.onAnimationSelected = this.onAnimationSelected.bind(this);
  this.onWindowResize = this.onWindowResize.bind(this);
  this.onTimelineDataChanged = this.onTimelineDataChanged.bind(this);
  this.onDetailCloseButtonClick = this.onDetailCloseButtonClick.bind(this);

  EventEmitter.decorate(this);
}

exports.AnimationsTimeline = AnimationsTimeline;

AnimationsTimeline.prototype = {
  init: function (containerEl) {
    this.win = containerEl.ownerDocument.defaultView;
    this.rootWrapperEl = containerEl;

    this.setupSplitBox();
    this.setupAnimationTimeline();
    this.setupAnimationDetail();

    this.win.addEventListener("resize",
      this.onWindowResize);
  },

  setupSplitBox: function () {
    const browserRequire = this.win.BrowserLoader({
      window: this.win,
      useOnlyShared: true
    }).require;

    const React = browserRequire("devtools/client/shared/vendor/react");
    const ReactDOM = browserRequire("devtools/client/shared/vendor/react-dom");

    const SplitBox = React.createFactory(
      browserRequire("devtools/client/shared/components/splitter/split-box"));

    const splitter = SplitBox({
      className: "animation-root",
      splitterSize: 1,
      initialHeight: "50%",
      endPanelControl: true,
      startPanel: React.DOM.div({
        className: "animation-timeline"
      }),
      endPanel: React.DOM.div({
        className: "animation-detail"
      }),
      vert: false
    });

    ReactDOM.render(splitter, this.rootWrapperEl);

    this.animationRootEl = this.rootWrapperEl.querySelector(".animation-root");
  },

  setupAnimationTimeline: function () {
    const animationTimelineEl = this.rootWrapperEl.querySelector(".animation-timeline");

    let scrubberContainer = createNode({
      parent: animationTimelineEl,
      attributes: {"class": "scrubber-wrapper"}
    });

    this.scrubberEl = createNode({
      parent: scrubberContainer,
      attributes: {
        "class": "scrubber"
      }
    });

    this.scrubberHandleEl = createNode({
      parent: this.scrubberEl,
      attributes: {
        "class": "scrubber-handle"
      }
    });
    createNode({
      parent: this.scrubberHandleEl,
      attributes: {
        "class": "scrubber-line"
      }
    });
    this.scrubberHandleEl.addEventListener("mousedown",
                                           this.onScrubberMouseDown);

    this.headerWrapper = createNode({
      parent: animationTimelineEl,
      attributes: {
        "class": "header-wrapper"
      }
    });

    this.timeHeaderEl = createNode({
      parent: this.headerWrapper,
      attributes: {
        "class": "time-header track-container"
      }
    });

    this.timeHeaderEl.addEventListener("mousedown",
                                       this.onScrubberMouseDown);

    this.timeTickEl = createNode({
      parent: animationTimelineEl,
      attributes: {
        "class": "time-body track-container"
      }
    });

    this.animationsEl = createNode({
      parent: animationTimelineEl,
      nodeType: "ul",
      attributes: {
        "class": "animations"
      }
    });
  },

  setupAnimationDetail: function () {
    const animationDetailEl = this.rootWrapperEl.querySelector(".animation-detail");

    const animationDetailHeaderEl = createNode({
      parent: animationDetailEl,
      attributes: {
        "class": "animation-detail-header"
      }
    });

    const headerTitleEl = createNode({
      parent: animationDetailHeaderEl,
      attributes: {
        "class": "devtools-toolbar"
      }
    });

    createNode({
      parent: headerTitleEl,
      textContent: L10N.getStr("detail.headerTitle")
    });

    this.animationAnimationNameEl = createNode({
      parent: headerTitleEl
    });

    this.animationDetailCloseButton = createNode({
      parent: headerTitleEl,
      nodeType: "button",
      attributes: {
        "class": "devtools-button",
        title: L10N.getStr("detail.header.closeLabel"),
      }
    });
    this.animationDetailCloseButton.addEventListener("click",
                                                     this.onDetailCloseButtonClick);

    const animationDetailBodyEl = createNode({
      parent: animationDetailEl,
      attributes: {
        "class": "animation-detail-body"
      }
    });

    this.animatedPropertiesEl = createNode({
      parent: animationDetailBodyEl,
      attributes: {
        "class": "animated-properties"
      }
    });

    this.details = new AnimationDetails(this.serverTraits);
    this.details.init(this.animatedPropertiesEl);
  },

  destroy: function () {
    this.stopAnimatingScrubber();
    this.unrender();
    this.details.destroy();

    this.win.removeEventListener("resize",
      this.onWindowResize);
    this.timeHeaderEl.removeEventListener("mousedown",
      this.onScrubberMouseDown);
    this.scrubberHandleEl.removeEventListener("mousedown",
      this.onScrubberMouseDown);
    this.animationDetailCloseButton.removeEventListener("click",
      this.onDetailCloseButtonClick);

    this.rootWrapperEl.remove();
    this.animations = [];
    this.tracksMap = null;
    this.rootWrapperEl = null;
    this.timeHeaderEl = null;
    this.animationsEl = null;
    this.animatedPropertiesEl = null;
    this.scrubberEl = null;
    this.scrubberHandleEl = null;
    this.win = null;
    this.inspector = null;
    this.serverTraits = null;
    this.animationDetailEl = null;
    this.animationAnimationNameEl = null;
    this.animatedPropertiesEl = null;
    this.animationDetailCloseButton = null;
    this.animationRootEl = null;
    this.selectedAnimation = null;

    this.isDestroyed = true;
  },

  /**
   * Destroy sub-components that have been created and stored on this instance.
   * @param {String} name An array of components will be expected in this[name]
   * @param {Array} handlers An option list of event handlers information that
   * should be used to remove these handlers.
   */
  destroySubComponents: function (name, handlers = []) {
    for (let component of this[name]) {
      for (let {event, fn} of handlers) {
        component.off(event, fn);
      }
      component.destroy();
    }
    this[name] = [];
  },

  unrender: function () {
    this.unrenderButLeaveDetailsComponent();
    this.details.unrender();
  },

  unrenderButLeaveDetailsComponent: function () {
    for (let animation of this.animations) {
      animation.off("changed", this.onAnimationStateChanged);
    }
    this.stopAnimatingScrubber();
    TimeScale.reset();
    this.destroySubComponents("targetNodes");
    this.destroySubComponents("timeBlocks");
    this.animationsEl.innerHTML = "";
    this.off("timeline-data-changed", this.onTimelineDataChanged);
  },

  onWindowResize: function () {
    // Don't do anything if the root element has a width of 0
    if (this.rootWrapperEl.offsetWidth === 0) {
      return;
    }

    if (this.windowResizeTimer) {
      this.win.clearTimeout(this.windowResizeTimer);
    }

    this.windowResizeTimer = this.win.setTimeout(() => {
      this.drawHeaderAndBackground();
    }, TIMELINE_BACKGROUND_RESIZE_DEBOUNCE_TIMER);
  },

  onAnimationSelected: Task.async(function* (e, animation) {
    let index = this.animations.indexOf(animation);
    if (index === -1) {
      return;
    }

    // Unselect an animation which was selected.
    const animationEls = this.rootWrapperEl.querySelectorAll(".animation");
    for (let i = 0; i < animationEls.length; i++) {
      const animationEl = animationEls[i];
      if (!animationEl.classList.contains("selected")) {
        continue;
      }
      if (i === index) {
        // Already the animation is selected.
        this.emit("animation-already-selected", this.animations[i]);
        return;
      }
      animationEl.classList.remove("selected");
      this.emit("animation-unselected", this.animations[i]);
      break;
    }

    // Add class of animation type to animatedPropertiesEl to display the compositor sign.
    if (!this.animatedPropertiesEl.classList.contains(animation.state.type)) {
      this.animatedPropertiesEl.className =
        `animated-properties ${ animation.state.type }`;
    }

    // Select and render.
    const selectedAnimationEl = animationEls[index];
    selectedAnimationEl.classList.add("selected");
    this.animationRootEl.classList.add("animation-detail-visible");
    // Don't render if the detail displays same animation already.
    if (animation !== this.details.animation) {
      this.selectedAnimation = animation;
      yield this.details.render(animation, this.tracksMap.get(animation));
      this.animationAnimationNameEl.textContent = getFormattedAnimationTitle(animation);
    }
    this.onTimelineDataChanged(null, { time: this.currentTime || 0 });
    this.emit("animation-selected", animation);
  }),

  /**
   * When move the scrubber to the corresponding position
   */
  onScrubberMouseDown: function (e) {
    this.moveScrubberTo(e.pageX);
    this.win.addEventListener("mouseup", this.onScrubberMouseUp);
    this.win.addEventListener("mouseout", this.onScrubberMouseOut);
    this.win.addEventListener("mousemove", this.onScrubberMouseMove);

    // Prevent text selection while dragging.
    e.preventDefault();
  },

  onScrubberMouseUp: function () {
    this.cancelTimeHeaderDragging();
  },

  onScrubberMouseOut: function (e) {
    // Check that mouseout happened on the window itself, and if yes, cancel
    // the dragging.
    if (!this.win.document.contains(e.relatedTarget)) {
      this.cancelTimeHeaderDragging();
    }
  },

  cancelTimeHeaderDragging: function () {
    this.win.removeEventListener("mouseup", this.onScrubberMouseUp);
    this.win.removeEventListener("mouseout", this.onScrubberMouseOut);
    this.win.removeEventListener("mousemove", this.onScrubberMouseMove);
  },

  onScrubberMouseMove: function (e) {
    this.moveScrubberTo(e.pageX);
  },

  moveScrubberTo: function (pageX, noOffset) {
    this.stopAnimatingScrubber();

    // The offset needs to be in % and relative to the timeline's area (so we
    // subtract the scrubber's left offset, which is equal to the sidebar's
    // width).
    let offset = pageX;
    if (!noOffset) {
      offset -= this.timeHeaderEl.offsetLeft;
    }
    offset = offset * 100 / this.timeHeaderEl.offsetWidth;
    if (offset < 0) {
      offset = 0;
    }

    this.scrubberEl.style.left = offset + "%";

    let time = TimeScale.distanceToRelativeTime(offset);

    this.emit("timeline-data-changed", {
      isPaused: true,
      isMoving: false,
      isUserDrag: true,
      time: time
    });
  },

  getCompositorStatusClassName: function (state) {
    let className = state.isRunningOnCompositor
                    ? " fast-track"
                    : "";

    if (state.isRunningOnCompositor && state.propertyState) {
      className +=
        state.propertyState.some(propState => !propState.runningOnCompositor)
        ? " some-properties"
        : " all-properties";
    }

    return className;
  },

  render: Task.async(function* (animations, documentCurrentTime) {
    this.unrenderButLeaveDetailsComponent();

    this.animations = animations;
    if (!this.animations.length) {
      this.emit("animation-timeline-rendering-completed");
      return;
    }

    // Loop first to set the time scale for all current animations.
    for (let {state} of animations) {
      TimeScale.addAnimation(state);
    }

    this.drawHeaderAndBackground();

    for (let animation of this.animations) {
      animation.on("changed", this.onAnimationStateChanged);
      // Each line contains the target animated node and the animation time
      // block.
      let animationEl = createNode({
        parent: this.animationsEl,
        nodeType: "li",
        attributes: {
          "class": "animation " +
                   animation.state.type +
                   this.getCompositorStatusClassName(animation.state)
        }
      });

      // Left sidebar for the animated node.
      let animatedNodeEl = createNode({
        parent: animationEl,
        attributes: {
          "class": "target"
        }
      });

      // Draw the animated node target.
      let targetNode = new AnimationTargetNode(this.inspector, {compact: true});
      targetNode.init(animatedNodeEl);
      targetNode.render(animation);
      this.targetNodes.push(targetNode);

      // Right-hand part contains the timeline itself (called time-block here).
      let timeBlockEl = createNode({
        parent: animationEl,
        attributes: {
          "class": "time-block track-container"
        }
      });

      // Draw the animation time block.
      const tracks = yield this.getTracks(animation);
      // If we're destroyed by now, just give up.
      if (this.isDestroyed) {
        return;
      }

      let timeBlock = new AnimationTimeBlock();
      timeBlock.init(timeBlockEl);
      timeBlock.render(animation, tracks);
      this.timeBlocks.push(timeBlock);
      this.tracksMap.set(animation, tracks);

      timeBlock.on("selected", this.onAnimationSelected);
    }

    // Use the document's current time to position the scrubber (if the server
    // doesn't provide it, hide the scrubber entirely).
    // Note that because the currentTime was sent via the protocol, some time
    // may have gone by since then, and so the scrubber might be a bit late.
    if (!documentCurrentTime) {
      this.scrubberEl.style.display = "none";
    } else {
      this.scrubberEl.style.display = "block";
      this.startAnimatingScrubber(this.wasRewound()
                                  ? TimeScale.minStartTime
                                  : documentCurrentTime);
    }

    // To indicate the animation progress in AnimationDetails.
    this.on("timeline-data-changed", this.onTimelineDataChanged);

    if (this.animations.length === 1) {
      // Display animation's detail if there is only one animation,
      // even if the detail pane is closing.
      yield this.onAnimationSelected(null, this.animations[0]);
    } else if (this.animationRootEl.classList.contains("animation-detail-visible") &&
               this.animations.indexOf(this.selectedAnimation) >= 0) {
      // animation's detail displays in case of the previously displayed animation is
      // included in timeline list and the detail pane is not closing.
      yield this.onAnimationSelected(null, this.selectedAnimation);
    } else {
      // Otherwise, close detail pane.
      this.onDetailCloseButtonClick();
    }
    this.emit("animation-timeline-rendering-completed");
  }),

  isAtLeastOneAnimationPlaying: function () {
    return this.animations.some(({state}) => state.playState === "running");
  },

  wasRewound: function () {
    return !this.isAtLeastOneAnimationPlaying() &&
           this.animations.every(({state}) => state.currentTime === 0);
  },

  hasInfiniteAnimations: function () {
    return this.animations.some(({state}) => !state.iterationCount);
  },

  startAnimatingScrubber: function (time) {
    let isOutOfBounds = time < TimeScale.minStartTime ||
                        time > TimeScale.maxEndTime;
    let isAllPaused = !this.isAtLeastOneAnimationPlaying();
    let hasInfinite = this.hasInfiniteAnimations();

    let x = TimeScale.startTimeToDistance(time);
    if (x > 100 && !hasInfinite) {
      x = 100;
    }
    this.scrubberEl.style.left = x + "%";

    // Only stop the scrubber if it's out of bounds or all animations have been
    // paused, but not if at least an animation is infinite.
    if (isAllPaused || (isOutOfBounds && !hasInfinite)) {
      this.stopAnimatingScrubber();
      this.emit("timeline-data-changed", {
        isPaused: !this.isAtLeastOneAnimationPlaying(),
        isMoving: false,
        isUserDrag: false,
        time: TimeScale.distanceToRelativeTime(x)
      });
      return;
    }

    this.emit("timeline-data-changed", {
      isPaused: false,
      isMoving: true,
      isUserDrag: false,
      time: TimeScale.distanceToRelativeTime(x)
    });

    let now = this.win.performance.now();
    this.rafID = this.win.requestAnimationFrame(() => {
      if (!this.rafID) {
        // In case the scrubber was stopped in the meantime.
        return;
      }
      this.startAnimatingScrubber(time + this.win.performance.now() - now);
    });
  },

  stopAnimatingScrubber: function () {
    if (this.rafID) {
      this.win.cancelAnimationFrame(this.rafID);
      this.rafID = null;
    }
  },

  onAnimationStateChanged: function () {
    // For now, simply re-render the component. The animation front's state has
    // already been updated.
    this.render(this.animations);
  },

  drawHeaderAndBackground: function () {
    let width = this.timeHeaderEl.offsetWidth;
    let animationDuration = TimeScale.maxEndTime - TimeScale.minStartTime;
    let minTimeInterval = TIME_GRADUATION_MIN_SPACING *
                          animationDuration / width;
    let intervalLength = findOptimalTimeInterval(minTimeInterval);
    let intervalWidth = intervalLength * width / animationDuration;

    // And the time graduation header.
    this.timeHeaderEl.innerHTML = "";
    this.timeTickEl.innerHTML = "";

    for (let i = 0; i <= width / intervalWidth; i++) {
      let pos = 100 * i * intervalWidth / width;

      // This element is the header of time tick for displaying animation
      // duration time.
      createNode({
        parent: this.timeHeaderEl,
        nodeType: "span",
        attributes: {
          "class": "header-item",
          "style": `left:${pos}%`
        },
        textContent: TimeScale.formatTime(TimeScale.distanceToRelativeTime(pos))
      });

      // This element is displayed as a vertical line separator corresponding
      // the header of time tick for indicating time slice for animation
      // iterations.
      createNode({
        parent: this.timeTickEl,
        nodeType: "span",
        attributes: {
          "class": "time-tick",
          "style": `left:${pos}%`
        }
      });
    }
  },

  onTimelineDataChanged: function (e, { time }) {
    this.currentTime = time;
    const indicateTime =
      TimeScale.minStartTime === Infinity ? 0 : this.currentTime + TimeScale.minStartTime;
    this.details.indicateProgress(indicateTime);
  },

  onDetailCloseButtonClick: function (e) {
    if (!this.animationRootEl.classList.contains("animation-detail-visible")) {
      return;
    }
    this.animationRootEl.classList.remove("animation-detail-visible");
    this.emit("animation-detail-closed");
  },

  /**
   * Get a list of the tracks of the animation actor
   * @param {Object} animation
   * @return {Object} A list of tracks, one per animated property, each
   * with a list of keyframes
   */
  getTracks: Task.async(function* (animation) {
    let tracks = {};

    /*
     * getFrames is a AnimationPlayorActor method that returns data about the
     * keyframes of the animation.
     * In FF48, the data it returns change, and will hold only longhand
     * properties ( e.g. borderLeftWidth ), which does not match what we
     * want to display in the animation detail.
     * A new AnimationPlayerActor function, getProperties, is introduced,
     * that returns the animated css properties of the animation and their
     * keyframes values.
     * If the animation actor has the getProperties function, we use it, and if
     * not, we fall back to getFrames, which then returns values we used to
     * handle.
     */
    if (this.serverTraits.hasGetProperties) {
      let properties = [];
      try {
        properties = yield animation.getProperties();
      } catch (e) {
        // Expected if we've already been destroyed in the meantime.
        if (!this.isDestroyed) {
          throw e;
        }
      }

      for (let {name, values} of properties) {
        if (!tracks[name]) {
          tracks[name] = [];
        }

        for (let {value, offset, easing, distance} of values) {
          distance = distance ? distance : 0;
          tracks[name].push({value, offset, easing, distance});
        }
      }
    } else {
      let frames = [];
      try {
        frames = yield animation.getFrames();
      } catch (e) {
        // Expected if we've already been destroyed in the meantime.
        if (!this.isDestroyed) {
          throw e;
        }
      }

      for (let frame of frames) {
        for (let name in frame) {
          if (this.NON_PROPERTIES.indexOf(name) != -1) {
            continue;
          }

          // We have to change to CSS property name
          // since GetKeyframes returns JS property name.
          const propertyCSSName = getCssPropertyName(name);
          if (!tracks[propertyCSSName]) {
            tracks[propertyCSSName] = [];
          }

          tracks[propertyCSSName].push({
            value: frame[name],
            offset: frame.computedOffset,
            easing: frame.easing,
            distance: 0
          });
        }
      }
    }

    return tracks;
  })
};
