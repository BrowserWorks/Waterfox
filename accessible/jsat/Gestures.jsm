/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

/* exported GestureSettings, GestureTracker */

/******************************************************************************
  All gestures have the following pathways when being resolved(v)/rejected(x):
               Tap -> DoubleTap        (x)
                   -> Dwell            (x)
                   -> Swipe            (x)

         DoubleTap -> TripleTap        (x)
                   -> TapHold          (x)

         TripleTap -> DoubleTapHold    (x)

             Dwell -> DwellEnd         (v)

             Swipe -> Explore          (x)

           TapHold -> TapHoldEnd       (v)

     DoubleTapHold -> DoubleTapHoldEnd (v)

          DwellEnd -> Explore          (x)

        TapHoldEnd -> Explore          (x)

  DoubleTapHoldEnd -> Explore          (x)

        ExploreEnd -> Explore          (x)

           Explore -> ExploreEnd       (v)
******************************************************************************/

'use strict';

const Cu = Components.utils;

this.EXPORTED_SYMBOLS = ['GestureSettings', 'GestureTracker']; // jshint ignore:line

Cu.import('resource://gre/modules/XPCOMUtils.jsm');

XPCOMUtils.defineLazyModuleGetter(this, 'Utils', // jshint ignore:line
  'resource://gre/modules/accessibility/Utils.jsm');
XPCOMUtils.defineLazyModuleGetter(this, 'Logger', // jshint ignore:line
  'resource://gre/modules/accessibility/Utils.jsm');
XPCOMUtils.defineLazyModuleGetter(this, 'setTimeout', // jshint ignore:line
  'resource://gre/modules/Timer.jsm');
XPCOMUtils.defineLazyModuleGetter(this, 'clearTimeout', // jshint ignore:line
  'resource://gre/modules/Timer.jsm');
XPCOMUtils.defineLazyModuleGetter(this, 'Promise', // jshint ignore:line
  'resource://gre/modules/Promise.jsm');

// Default maximum duration of swipe
const SWIPE_MAX_DURATION = 200;
// Default maximum amount of time allowed for a gesture to be considered a
// multitouch
const MAX_MULTITOUCH = 125;
// Default maximum consecutive pointer event timeout
const MAX_CONSECUTIVE_GESTURE_DELAY = 200;
// Default delay before tap turns into dwell
const DWELL_THRESHOLD = 250;
// Minimal swipe distance in inches
const SWIPE_MIN_DISTANCE = 0.4;
// Maximum distance the pointer could move during a tap in inches
const TAP_MAX_RADIUS = 0.2;
// Directness coefficient. It is based on the maximum 15 degree angle between
// consequent pointer move lines.
const DIRECTNESS_COEFF = 1.44;
// Amount in inches from the edges of the screen for it to be an edge swipe
const EDGE = 0.1;
// Multiply timeouts by this constant, x2 works great too for slower users.
const TIMEOUT_MULTIPLIER = 1;
// A single pointer down/up sequence periodically precedes the tripple swipe
// gesture on Android. This delay acounts for that.
const IS_ANDROID = Utils.MozBuildApp === 'mobile/android' &&
  Utils.AndroidSdkVersion >= 14;

/**
 * A point object containing distance travelled data.
 * @param {Object} aPoint A point object that looks like: {
 *   x: x coordinate in pixels,
 *   y: y coordinate in pixels
 * }
 */
function Point(aPoint) {
  this.startX = this.x = aPoint.x;
  this.startY = this.y = aPoint.y;
  this.distanceTraveled = 0;
  this.totalDistanceTraveled = 0;
}

Point.prototype = {
  /**
   * Update the current point coordiates.
   * @param  {Object} aPoint A new point coordinates.
   */
  update: function Point_update(aPoint) {
    let lastX = this.x;
    let lastY = this.y;
    this.x = aPoint.x;
    this.y = aPoint.y;
    this.distanceTraveled = this.getDistanceToCoord(lastX, lastY);
    this.totalDistanceTraveled += this.distanceTraveled;
  },

  reset: function Point_reset() {
    this.distanceTraveled = 0;
    this.totalDistanceTraveled = 0;
  },

  /**
   * Get distance between the current point coordinates and the given ones.
   * @param  {Number} aX A pixel value for the x coordinate.
   * @param  {Number} aY A pixel value for the y coordinate.
   * @return {Number} A distance between point's current and the given
   * coordinates.
   */
  getDistanceToCoord: function Point_getDistanceToCoord(aX, aY) {
    return Math.hypot(this.x - aX, this.y - aY);
  },

  /**
   * Get the direct distance travelled by the point so far.
   */
  get directDistanceTraveled() {
    return this.getDistanceToCoord(this.startX, this.startY);
  }
};

/**
 * An externally accessible collection of settings used in gesture resolition.
 * @type {Object}
 */
this.GestureSettings = { // jshint ignore:line
  /**
   * Maximum duration of swipe
   * @type {Number}
   */
  swipeMaxDuration: SWIPE_MAX_DURATION * TIMEOUT_MULTIPLIER,

  /**
   * Maximum amount of time allowed for a gesture to be considered a multitouch.
   * @type {Number}
   */
  maxMultitouch: MAX_MULTITOUCH * TIMEOUT_MULTIPLIER,

  /**
   * Maximum consecutive pointer event timeout.
   * @type {Number}
   */
  maxConsecutiveGestureDelay:
    MAX_CONSECUTIVE_GESTURE_DELAY * TIMEOUT_MULTIPLIER,

  /**
   * A maximum time we wait for a next pointer down event to consider a sequence
   * a multi-action gesture.
   * @type {Number}
   */
  maxGestureResolveTimeout:
    MAX_CONSECUTIVE_GESTURE_DELAY * TIMEOUT_MULTIPLIER,

  /**
   * Delay before tap turns into dwell
   * @type {Number}
   */
  dwellThreshold: DWELL_THRESHOLD * TIMEOUT_MULTIPLIER,

  /**
   * Minimum distance that needs to be travelled for the pointer move to be
   * fired.
   * @type {Number}
   */
  travelThreshold: 0.025
};

/**
 * An interface that handles the pointer events and calculates the appropriate
 * gestures.
 * @type {Object}
 */
this.GestureTracker = { // jshint ignore:line
  /**
   * Reset GestureTracker to its initial state.
   * @return {[type]} [description]
   */
  reset: function GestureTracker_reset() {
    if (this.current) {
      this.current.clearTimer();
    }
    delete this.current;
  },

  /**
   * Create a new gesture object and attach resolution handler to it as well as
   * handle the incoming pointer event.
   * @param  {Object} aDetail A new pointer event detail.
   * @param  {Number} aTimeStamp A new pointer event timeStamp.
   * @param  {Function} aGesture A gesture constructor (default: Tap).
   */
  _init: function GestureTracker__init(aDetail, aTimeStamp, aGesture) {
    // Only create a new gesture on |pointerdown| event.
    if (aDetail.type !== 'pointerdown') {
      return;
    }
    let GestureConstructor = aGesture || (IS_ANDROID ? DoubleTap : Tap);
    this._create(GestureConstructor);
    this._update(aDetail, aTimeStamp);
  },

  /**
   * Handle the incoming pointer event with the existing gesture object(if
   * present) or with the newly created one.
   * @param  {Object} aDetail A new pointer event detail.
   * @param  {Number} aTimeStamp A new pointer event timeStamp.
   */
  handle: function GestureTracker_handle(aDetail, aTimeStamp) {
    Logger.gesture(() => {
      return ['Pointer event', Utils.dpi, 'at:', aTimeStamp, JSON.stringify(aDetail)];
    });
    this[this.current ? '_update' : '_init'](aDetail, aTimeStamp);
  },

  /**
   * Create a new gesture object and attach resolution handler to it.
   * @param  {Function} aGesture A gesture constructor.
   * @param  {Number} aTimeStamp An original pointer event timeStamp.
   * @param  {Array} aPoints All changed points associated with the new pointer
   * event.
   * @param {?String} aLastEvent Last pointer event type.
   */
  _create: function GestureTracker__create(aGesture, aTimeStamp, aPoints, aLastEvent) {
    this.current = new aGesture(aTimeStamp, aPoints, aLastEvent); /* A constructor name should start with an uppercase letter. */ // jshint ignore:line
    this.current.then(this._onFulfill.bind(this));
  },

  /**
   * Handle the incoming pointer event with the existing gesture object.
   * @param  {Object} aDetail A new pointer event detail.
   * @param  {Number} aTimeStamp A new pointer event timeStamp.
   */
  _update: function GestureTracker_update(aDetail, aTimeStamp) {
    this.current[aDetail.type](aDetail.points, aTimeStamp);
  },

  /**
   * A resolution handler function for the current gesture promise.
   * @param  {Object} aResult A resolution payload with the relevant gesture id
   * and an optional new gesture contructor.
   */
  _onFulfill: function GestureTracker__onFulfill(aResult) {
    let {id, gestureType} = aResult;
    let current = this.current;
    // Do nothing if there's no existing gesture or there's already a newer
    // gesture.
    if (!current || current.id !== id) {
      return;
    }
    // Only create a gesture if we got a constructor.
    if (gestureType) {
      this._create(gestureType, current.startTime, current.points,
        current.lastEvent);
    } else {
      this.current.clearTimer();
      delete this.current;
    }
  }
};

/**
 * Compile a mozAccessFuGesture detail structure.
 * @param  {String} aType A gesture type.
 * @param  {Object} aPoints Gesture's points.
 * @param  {String} xKey A default key for the x coordinate. Default is
 * 'startX'.
 * @param  {String} yKey A default key for the y coordinate. Default is
 * 'startY'.
 * @return {Object} a mozAccessFuGesture detail structure.
 */
function compileDetail(aType, aPoints, keyMap = {x: 'startX', y: 'startY'}) {
  let touches = [];
  let maxDeltaX = 0;
  let maxDeltaY = 0;
  for (let identifier in aPoints) {
    let point = aPoints[identifier];
    let touch = {};
    for (let key in keyMap) {
      touch[key] = point[keyMap[key]];
    }
    touches.push(touch);
    let deltaX = point.x - point.startX;
    let deltaY = point.y - point.startY;
    // Determine the maximum x and y travel intervals.
    if (Math.abs(maxDeltaX) < Math.abs(deltaX)) {
      maxDeltaX = deltaX;
    }
    if (Math.abs(maxDeltaY) < Math.abs(deltaY)) {
      maxDeltaY = deltaY;
    }
    // Since the gesture is resolving, reset the points' distance information
    // since they are passed to the next potential gesture.
    point.reset();
  }
  return {
    type: aType,
    touches: touches,
    deltaX: maxDeltaX,
    deltaY: maxDeltaY
  };
}

/**
 * A general gesture object.
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * Default is an empty object.
 * @param {?String} aLastEvent Last pointer event type.
 */
function Gesture(aTimeStamp, aPoints = {}, aLastEvent = undefined) {
  this.startTime = Date.now();
  Logger.gesture('Creating', this.id, 'gesture.');
  this.points = aPoints;
  this.lastEvent = aLastEvent;
  this._deferred = Promise.defer();
  // Call this._handleResolve or this._handleReject when the promise is
  // fulfilled with either resolve or reject.
  this.promise = this._deferred.promise.then(this._handleResolve.bind(this),
    this._handleReject.bind(this));
  this.startTimer(aTimeStamp);
}

Gesture.prototype = {
  /**
   * Get the gesture timeout delay.
   * @return {Number}
   */
  _getDelay: function Gesture__getDelay() {
    // If nothing happens withing the
    // GestureSettings.maxConsecutiveGestureDelay, we should not wait for any
    // more pointer events and consider them the part of the same gesture -
    // reject this gesture promise.
    return GestureSettings.maxConsecutiveGestureDelay;
  },

  /**
   * Clear the existing timer.
   */
  clearTimer: function Gesture_clearTimer() {
    Logger.gesture('clearTimeout', this.type);
    clearTimeout(this._timer);
    delete this._timer;
  },

  /**
   * Start the timer for gesture timeout.
   * @param {Number} aTimeStamp An original pointer event's timeStamp that
   * started the gesture resolution sequence.
   */
  startTimer: function Gesture_startTimer(aTimeStamp) {
    Logger.gesture('startTimer', this.type);
    this.clearTimer();
    let delay = this._getDelay(aTimeStamp);
    let handler = () => {
      Logger.gesture('timer handler');
      this.clearTimer();
      if (!this._inProgress) {
        this._deferred.reject();
      } else if (this._rejectToOnWait) {
        this._deferred.reject(this._rejectToOnWait);
      }
    };
    if (delay <= 0) {
      handler();
    } else {
      this._timer = setTimeout(handler, delay);
    }
  },

  /**
   * Add a gesture promise resolution callback.
   * @param  {Function} aCallback
   */
  then: function Gesture_then(aCallback) {
    this.promise.then(aCallback);
  },

  /**
   * Update gesture's points. Test the points set with the optional gesture test
   * function.
   * @param  {Array} aPoints An array with the changed points from the new
   * pointer event.
   * @param {String} aType Pointer event type.
   * @param  {Boolean} aCanCreate A flag that enables including the new points.
   * Default is false.
   * @param  {Boolean} aNeedComplete A flag that indicates that the gesture is
   * completing. Default is false.
   * @return {Boolean} Indicates whether the gesture can be complete (it is
   * set to true iff the aNeedComplete is true and there was a change to at
   * least one point that belongs to the gesture).
   */
  _update: function Gesture__update(aPoints, aType, aCanCreate = false, aNeedComplete = false) {
    let complete;
    let lastEvent;
    for (let point of aPoints) {
      let identifier = point.identifier;
      let gesturePoint = this.points[identifier];
      if (gesturePoint) {
        if (aType === 'pointerdown' && aCanCreate) {
          // scratch the previous pointer with that id.
          this.points[identifier] = new Point(point);
        } else {
          gesturePoint.update(point);
        }
        if (aNeedComplete) {
          // Since the gesture is completing and at least one of the gesture
          // points is updated, set the return value to true.
          complete = true;
        }
        lastEvent = lastEvent || aType;
      } else if (aCanCreate) {
        // Only create a new point if aCanCreate is true.
        this.points[identifier] =
          new Point(point);
        lastEvent = lastEvent || aType;
      }
    }
    this.lastEvent = lastEvent || this.lastEvent;
    // If test function is defined test the points.
    if (this.test) {
      this.test(complete);
    }
    return complete;
  },

  /**
   * Emit a mozAccessFuGesture (when the gesture is resolved).
   * @param  {Object} aDetail a compiled mozAccessFuGesture detail structure.
   */
  _emit: function Gesture__emit(aDetail) {
    let evt = new Utils.win.CustomEvent('mozAccessFuGesture', {
      bubbles: true,
      cancelable: true,
      detail: aDetail
    });
    Utils.win.dispatchEvent(evt);
  },

  /**
   * Handle the pointer down event.
   * @param  {Array} aPoints A new pointer down points.
   * @param  {Number} aTimeStamp A new pointer down timeStamp.
   */
  pointerdown: function Gesture_pointerdown(aPoints, aTimeStamp) {
    this._inProgress = true;
    this._update(aPoints, 'pointerdown',
      aTimeStamp - this.startTime < GestureSettings.maxMultitouch);
  },

  /**
   * Handle the pointer move event.
   * @param  {Array} aPoints A new pointer move points.
   */
  pointermove: function Gesture_pointermove(aPoints) {
    this._update(aPoints, 'pointermove');
  },

  /**
   * Handle the pointer up event.
   * @param  {Array} aPoints A new pointer up points.
   */
  pointerup: function Gesture_pointerup(aPoints) {
    let complete = this._update(aPoints, 'pointerup', false, true);
    if (complete) {
      this._deferred.resolve();
    }
  },

  /**
   * A subsequent gesture constructor to resolve the current one to. E.g.
   * tap->doubletap, dwell->dwellend, etc.
   * @type {Function}
   */
  resolveTo: null,

  /**
   * A unique id for the gesture. Composed of the type + timeStamp.
   */
  get id() {
    delete this._id;
    this._id = this.type + this.startTime;
    return this._id;
  },

  /**
   * A gesture promise resolve callback. Compile and emit the gesture.
   * @return {Object} Returns a structure to the gesture handler that looks like
   * this: {
   *   id: current gesture id,
   *   gestureType: an optional subsequent gesture constructor.
   * }
   */
  _handleResolve: function Gesture__handleResolve() {
    if (this.isComplete) {
      return;
    }
    Logger.gesture('Resolving', this.id, 'gesture.');
    this.isComplete = true;
    this.clearTimer();
    let detail = this.compile();
    if (detail) {
      this._emit(detail);
    }
    return {
      id: this.id,
      gestureType: this.resolveTo
    };
  },

  /**
   * A gesture promise reject callback.
   * @return {Object} Returns a structure to the gesture handler that looks like
   * this: {
   *   id: current gesture id,
   *   gestureType: an optional subsequent gesture constructor.
   * }
   */
  _handleReject: function Gesture__handleReject(aRejectTo) {
    if (this.isComplete) {
      return;
    }
    Logger.gesture('Rejecting', this.id, 'gesture.');
    this.isComplete = true;
    this.clearTimer();
    return {
      id: this.id,
      gestureType: aRejectTo
    };
  },

  /**
   * A default compilation function used to build the mozAccessFuGesture event
   * detail. The detail always includes the type and the touches associated
   * with the gesture.
   * @return {Object} Gesture event detail.
   */
  compile: function Gesture_compile() {
    return compileDetail(this.type, this.points);
  }
};

/**
 * A mixin for an explore related object.
 */
function ExploreGesture() {
  this.compile = () => {
    // Unlike most of other gestures explore based gestures compile using the
    // current point position and not the start one.
    return compileDetail(this.type, this.points, {x: 'x', y: 'y'});
  };
}

/**
 * Check the in progress gesture for completion.
 */
function checkProgressGesture(aGesture) {
  aGesture._inProgress = true;
  if (aGesture.lastEvent === 'pointerup') {
    if (aGesture.test) {
      aGesture.test(true);
    }
    aGesture._deferred.resolve();
  }
}

/**
 * A common travel gesture. When the travel gesture is created, all subsequent
 * pointer events' points are tested for their total distance traveled. If that
 * distance exceeds the _threshold distance, the gesture will be rejected to a
 * _travelTo gesture.
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 * @param {Function} aTravelTo A contructor for the gesture to reject to when
 * travelling (default: Explore).
 * @param {Number} aThreshold Travel threshold (default:
 * GestureSettings.travelThreshold).
 */
function TravelGesture(aTimeStamp, aPoints, aLastEvent, aTravelTo = Explore, aThreshold = GestureSettings.travelThreshold) {
  Gesture.call(this, aTimeStamp, aPoints, aLastEvent);
  this._travelTo = aTravelTo;
  this._threshold = aThreshold;
}

TravelGesture.prototype = Object.create(Gesture.prototype);

/**
 * Test the gesture points for travel. The gesture will be rejected to
 * this._travelTo gesture iff at least one point crosses this._threshold.
 */
TravelGesture.prototype.test = function TravelGesture_test() {
  if (!this._travelTo) {
    return;
  }
  for (let identifier in this.points) {
    let point = this.points[identifier];
    if (point.totalDistanceTraveled / Utils.dpi > this._threshold) {
      this._deferred.reject(this._travelTo);
      return;
    }
  }
};

/**
 * DwellEnd gesture.
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 */
function DwellEnd(aTimeStamp, aPoints, aLastEvent) {
  this._inProgress = true;
  // If the pointer travels, reject to Explore.
  TravelGesture.call(this, aTimeStamp, aPoints, aLastEvent);
  checkProgressGesture(this);
}

DwellEnd.prototype = Object.create(TravelGesture.prototype);
DwellEnd.prototype.type = 'dwellend';

/**
 * TapHoldEnd gesture. This gesture can be represented as the following diagram:
 * pointerdown-pointerup-pointerdown-*wait*-pointerup.
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 */
function TapHoldEnd(aTimeStamp, aPoints, aLastEvent) {
  this._inProgress = true;
  // If the pointer travels, reject to Explore.
  TravelGesture.call(this, aTimeStamp, aPoints, aLastEvent);
  checkProgressGesture(this);
}

TapHoldEnd.prototype = Object.create(TravelGesture.prototype);
TapHoldEnd.prototype.type = 'tapholdend';

/**
 * DoubleTapHoldEnd gesture. This gesture can be represented as the following
 * diagram:
 * pointerdown-pointerup-pointerdown-pointerup-pointerdown-*wait*-pointerup.
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 */
function DoubleTapHoldEnd(aTimeStamp, aPoints, aLastEvent) {
  this._inProgress = true;
  // If the pointer travels, reject to Explore.
  TravelGesture.call(this, aTimeStamp, aPoints, aLastEvent);
  checkProgressGesture(this);
}

DoubleTapHoldEnd.prototype = Object.create(TravelGesture.prototype);
DoubleTapHoldEnd.prototype.type = 'doubletapholdend';

/**
 * A common tap gesture object.
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 * @param {Function} aRejectToOnWait A constructor for the next gesture to
 * reject to in case no pointermove or pointerup happens within the
 * GestureSettings.dwellThreshold.
 * @param {Function} aTravelTo An optional constuctor for the next gesture to
 * reject to in case the the TravelGesture test fails.
 * @param {Function} aRejectToOnPointerDown A constructor for the gesture to
 * reject to if a finger comes down immediately after the tap.
 */
function TapGesture(aTimeStamp, aPoints, aLastEvent, aRejectToOnWait, aTravelTo, aRejectToOnPointerDown) {
  this._rejectToOnWait = aRejectToOnWait;
  this._rejectToOnPointerDown = aRejectToOnPointerDown;
  // If the pointer travels, reject to aTravelTo.
  TravelGesture.call(this, aTimeStamp, aPoints, aLastEvent, aTravelTo,
    TAP_MAX_RADIUS);
}

TapGesture.prototype = Object.create(TravelGesture.prototype);
TapGesture.prototype._getDelay = function TapGesture__getDelay() {
  // If, for TapGesture, no pointermove or pointerup happens within the
  // GestureSettings.dwellThreshold, reject.
  // Note: the original pointer event's timeStamp is irrelevant here.
  return GestureSettings.dwellThreshold;
};

TapGesture.prototype.pointerup = function TapGesture_pointerup(aPoints) {
    if (this._rejectToOnPointerDown) {
      let complete = this._update(aPoints, 'pointerup', false, true);
      if (complete) {
        this.clearTimer();
        if (GestureSettings.maxGestureResolveTimeout) {
          this._pointerUpTimer = setTimeout(() => {
            clearTimeout(this._pointerUpTimer);
            delete this._pointerUpTimer;
            this._deferred.resolve();
          }, GestureSettings.maxGestureResolveTimeout);
        } else {
          this._deferred.resolve();
        }
      }
    } else {
      TravelGesture.prototype.pointerup.call(this, aPoints);
    }
};

TapGesture.prototype.pointerdown = function TapGesture_pointerdown(aPoints, aTimeStamp) {
  if (this._pointerUpTimer) {
    clearTimeout(this._pointerUpTimer);
    delete this._pointerUpTimer;
    this._deferred.reject(this._rejectToOnPointerDown);
  } else {
    TravelGesture.prototype.pointerdown.call(this, aPoints, aTimeStamp);
  }
};


/**
 * Tap gesture.
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 */
function Tap(aTimeStamp, aPoints, aLastEvent) {
  // If the pointer travels, reject to Swipe.
  TapGesture.call(this, aTimeStamp, aPoints, aLastEvent, Dwell, Swipe, DoubleTap);
}

Tap.prototype = Object.create(TapGesture.prototype);
Tap.prototype.type = 'tap';


/**
 * Double Tap gesture.
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 */
function DoubleTap(aTimeStamp, aPoints, aLastEvent) {
  this._inProgress = true;
  TapGesture.call(this, aTimeStamp, aPoints, aLastEvent, TapHold, null, TripleTap);
}

DoubleTap.prototype = Object.create(TapGesture.prototype);
DoubleTap.prototype.type = 'doubletap';

/**
 * Triple Tap gesture.
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 */
function TripleTap(aTimeStamp, aPoints, aLastEvent) {
  this._inProgress = true;
  TapGesture.call(this, aTimeStamp, aPoints, aLastEvent, DoubleTapHold, null, null);
}

TripleTap.prototype = Object.create(TapGesture.prototype);
TripleTap.prototype.type = 'tripletap';

/**
 * Common base object for gestures that are created as resolved.
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 */
function ResolvedGesture(aTimeStamp, aPoints, aLastEvent) {
  Gesture.call(this, aTimeStamp, aPoints, aLastEvent);
  // Resolve the guesture right away.
  this._deferred.resolve();
}

ResolvedGesture.prototype = Object.create(Gesture.prototype);

/**
 * Dwell gesture
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 */
function Dwell(aTimeStamp, aPoints, aLastEvent) {
  ResolvedGesture.call(this, aTimeStamp, aPoints, aLastEvent);
}

Dwell.prototype = Object.create(ResolvedGesture.prototype);
Dwell.prototype.type = 'dwell';
Dwell.prototype.resolveTo = DwellEnd;

/**
 * TapHold gesture
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 */
function TapHold(aTimeStamp, aPoints, aLastEvent) {
  ResolvedGesture.call(this, aTimeStamp, aPoints, aLastEvent);
}

TapHold.prototype = Object.create(ResolvedGesture.prototype);
TapHold.prototype.type = 'taphold';
TapHold.prototype.resolveTo = TapHoldEnd;

/**
 * DoubleTapHold gesture
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 */
function DoubleTapHold(aTimeStamp, aPoints, aLastEvent) {
  ResolvedGesture.call(this, aTimeStamp, aPoints, aLastEvent);
}

DoubleTapHold.prototype = Object.create(ResolvedGesture.prototype);
DoubleTapHold.prototype.type = 'doubletaphold';
DoubleTapHold.prototype.resolveTo = DoubleTapHoldEnd;

/**
 * Explore gesture
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 */
function Explore(aTimeStamp, aPoints, aLastEvent) {
  ExploreGesture.call(this);
  ResolvedGesture.call(this, aTimeStamp, aPoints, aLastEvent);
}

Explore.prototype = Object.create(ResolvedGesture.prototype);
Explore.prototype.type = 'explore';
Explore.prototype.resolveTo = ExploreEnd;

/**
 * ExploreEnd gesture.
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 */
function ExploreEnd(aTimeStamp, aPoints, aLastEvent) {
  this._inProgress = true;
  ExploreGesture.call(this);
  // If the pointer travels, reject to Explore.
  TravelGesture.call(this, aTimeStamp, aPoints, aLastEvent);
  checkProgressGesture(this);
}

ExploreEnd.prototype = Object.create(TravelGesture.prototype);
ExploreEnd.prototype.type = 'exploreend';

/**
 * Swipe gesture.
 * @param {Number} aTimeStamp An original pointer event's timeStamp that started
 * the gesture resolution sequence.
 * @param {Object} aPoints An existing set of points (from previous events).
 * @param {?String} aLastEvent Last pointer event type.
 */
function Swipe(aTimeStamp, aPoints, aLastEvent) {
  this._inProgress = true;
  this._rejectToOnWait = Explore;
  Gesture.call(this, aTimeStamp, aPoints, aLastEvent);
  checkProgressGesture(this);
}

Swipe.prototype = Object.create(Gesture.prototype);
Swipe.prototype.type = 'swipe';
Swipe.prototype._getDelay = function Swipe__getDelay(aTimeStamp) {
  // Swipe should be completed within the GestureSettings.swipeMaxDuration from
  // the initial pointer down event.
  return GestureSettings.swipeMaxDuration - this.startTime + aTimeStamp;
};

/**
 * Determine wither the gesture was Swipe or Explore.
 * @param  {Booler} aComplete A flag that indicates whether the gesture is and
 * will be complete after the test.
 */
Swipe.prototype.test = function Swipe_test(aComplete) {
  if (!aComplete) {
    // No need to test if the gesture is not completing or can't be complete.
    return;
  }
  let reject = true;
  // If at least one point travelled for more than SWIPE_MIN_DISTANCE and it was
  // direct enough, consider it a Swipe.
  for (let identifier in this.points) {
    let point = this.points[identifier];
    let directDistance = point.directDistanceTraveled;
    if (directDistance / Utils.dpi >= SWIPE_MIN_DISTANCE ||
      directDistance * DIRECTNESS_COEFF >= point.totalDistanceTraveled) {
      reject = false;
    }
  }
  if (reject) {
    this._deferred.reject(Explore);
  }
};

/**
 * Compile a swipe related mozAccessFuGesture event detail.
 * @return {Object} A mozAccessFuGesture detail object.
 */
Swipe.prototype.compile = function Swipe_compile() {
  let type = this.type;
  let detail = compileDetail(type, this.points,
    {x1: 'startX', y1: 'startY', x2: 'x', y2: 'y'});
  let deltaX = detail.deltaX;
  let deltaY = detail.deltaY;
  let edge = EDGE * Utils.dpi;
  if (Math.abs(deltaX) > Math.abs(deltaY)) {
    // Horizontal swipe.
    let startPoints = detail.touches.map(touch => touch.x1);
    if (deltaX > 0) {
      detail.type = type + 'right';
      detail.edge = Math.min.apply(null, startPoints) <= edge;
    } else {
      detail.type = type + 'left';
      detail.edge =
        Utils.win.screen.width - Math.max.apply(null, startPoints) <= edge;
    }
  } else {
    // Vertical swipe.
    let startPoints = detail.touches.map(touch => touch.y1);
    if (deltaY > 0) {
      detail.type = type + 'down';
      detail.edge = Math.min.apply(null, startPoints) <= edge;
    } else {
      detail.type = type + 'up';
      detail.edge =
        Utils.win.screen.height - Math.max.apply(null, startPoints) <= edge;
    }
  }
  return detail;
};
