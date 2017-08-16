/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

define(function (require, exports, module) {
  const { render } = require("devtools/client/shared/vendor/react-dom");
  const { createFactories } = require("devtools/client/shared/react-utils");
  const { MainTabbedArea } = createFactories(require("./components/main-tabbed-area"));

  const json = document.getElementById("json");

  let jsonData;
  let prettyURL;

  try {
    jsonData = JSON.parse(json.textContent);
  } catch (err) {
    jsonData = err + "";
  }

  // Application state object.
  let input = {
    jsonText: json.textContent,
    jsonPretty: null,
    json: jsonData,
    headers: window.headers,
    tabActive: 0,
    prettified: false
  };

  json.remove();

  /**
   * Application actions/commands. This list implements all commands
   * available for the JSON viewer.
   */
  input.actions = {
    onCopyJson: function () {
      dispatchEvent("copy", input.prettified ? input.jsonPretty : input.jsonText);
    },

    onSaveJson: function () {
      if (input.prettified && !prettyURL) {
        prettyURL = URL.createObjectURL(new window.Blob([input.jsonPretty]));
      }
      dispatchEvent("save", input.prettified ? prettyURL : null);
    },

    onCopyHeaders: function () {
      dispatchEvent("copy-headers", input.headers);
    },

    onSearch: function (value) {
      theApp.setState({searchFilter: value});
    },

    onPrettify: function (data) {
      if (input.prettified) {
        theApp.setState({jsonText: input.jsonText});
      } else {
        if (!input.jsonPretty) {
          input.jsonPretty = JSON.stringify(jsonData, null, "  ");
        }
        theApp.setState({jsonText: input.jsonPretty});
      }

      input.prettified = !input.prettified;
    },
  };

  /**
   * Helper for dispatching an event. It's handled in chrome scope.
   *
   * @param {String} type Event detail type
   * @param {Object} value Event detail value
   */
  function dispatchEvent(type, value) {
    let data = {
      detail: {
        type,
        value,
      }
    };

    let contentMessageEvent = new CustomEvent("contentMessage", data);
    window.dispatchEvent(contentMessageEvent);
  }

  /**
   * Render the main application component. It's the main tab bar displayed
   * at the top of the window. This component also represents ReacJS root.
   */
  let content = document.getElementById("content");
  let theApp = render(MainTabbedArea(input), content);

  // Send notification event to the window. Can be useful for
  // tests as well as extensions.
  let event = new CustomEvent("JSONViewInitialized", {});
  window.jsonViewInitialized = true;
  window.dispatchEvent(event);
});
