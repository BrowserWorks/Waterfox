// -*- Mode: js2; tab-width: 2; indent-tabs-mode: nil; js2-basic-offset: 2; js2-skip-preprocessor-directives: t; -*-
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

this.EXPORTED_SYMBOLS = ["MediaPlayerApp"];

const { classes: Cc, interfaces: Ci, utils: Cu } = Components;

Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/Messaging.jsm");
var log = Cu.import("resource://gre/modules/AndroidLog.jsm", {}).AndroidLog.d.bind(null, "MediaPlayerApp");

// Helper function for sending commands to Java.
function send(type, data, callback) {
  let msg = {
    type: type
  };

  for (let i in data) {
    msg[i] = data[i];
  }

  EventDispatcher.instance.sendRequestForResult(msg)
    .then(result => callback(result, null),
          error => callback(null, error));
}

/* These apps represent players supported natively by the platform. This class will proxy commands
 * to native controls */
function MediaPlayerApp(service) {
  this.service = service;
  this.location = service.location;
  this.id = service.uuid;
}

MediaPlayerApp.prototype = {
  start: function start(callback) {
    send("MediaPlayer:Start", { id: this.id }, (result, err) => {
      if (callback) {
        callback(err == null);
      }
    });
  },

  stop: function stop(callback) {
    send("MediaPlayer:Stop", { id: this.id }, (result, err) => {
      if (callback) {
        callback(err == null);
      }
    });
  },

  remoteMedia: function remoteMedia(callback, listener) {
    if (callback) {
      callback(new RemoteMedia(this.id, listener));
    }
  },

}

/* RemoteMedia provides a proxy to a native media player session.
 */
function RemoteMedia(id, listener) {
  this._id = id;
  this._listener = listener;

  if ("onRemoteMediaStart" in this._listener) {
    Services.tm.dispatchToMainThread(() => {
      this._listener.onRemoteMediaStart(this);
    });
  }
}

RemoteMedia.prototype = {
  shutdown: function shutdown() {
    EventDispatcher.instance.unregisterListener(this, [
      "MediaPlayer:Playing",
      "MediaPlayer:Paused",
    ]);

    this._send("MediaPlayer:End", {}, (result, err) => {
      this._status = "shutdown";
      if ("onRemoteMediaStop" in this._listener) {
        this._listener.onRemoteMediaStop(this);
      }
    });
  },

  play: function play() {
    this._send("MediaPlayer:Play", {}, (result, err) => {
      if (err) {
        Cu.reportError("Can't play " + err);
        this.shutdown();
        return;
      }

      this._status = "started";
    });
  },

  pause: function pause() {
    this._send("MediaPlayer:Pause", {}, (result, err) => {
      if (err) {
        Cu.reportError("Can't pause " + err);
        this.shutdown();
        return;
      }

      this._status = "paused";
    });
  },

  load: function load(aData) {
    this._send("MediaPlayer:Load", aData, (result, err) => {
      if (err) {
        Cu.reportError("Can't load " + err);
        this.shutdown();
        return;
      }

      EventDispatcher.instance.registerListener(this, [
        "MediaPlayer:Playing",
        "MediaPlayer:Paused",
      ]);
      this._status = "started";
    })
  },

  get status() {
    return this._status;
  },

  onEvent: function (event, message, callback) {
    switch (event) {
      case "MediaPlayer:Playing":
        if (this._status !== "started") {
          this._status = "started";
          if ("onRemoteMediaStatus" in this._listener) {
            this._listener.onRemoteMediaStatus(this);
          }
        }
        break;
      case "MediaPlayer:Paused":
        if (this._status !== "paused") {
          this._status = "paused";
          if ("onRemoteMediaStatus" in this._listener) {
            this._listener.onRemoteMediaStatus(this);
          }
        }
        break;
    }
  },

  _send: function(msg, data, callback) {
    data.id = this._id;
    send(msg, data, callback);
  }
}
