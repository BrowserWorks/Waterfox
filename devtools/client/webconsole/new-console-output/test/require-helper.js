/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
"use strict";

const requireHacker = require("require-hacker");

requireHacker.global_hook("default", path => {
  switch (path) {
    // For Enzyme
    case "react-dom":
      return `const ReactDOM = require('devtools/client/shared/vendor/react-dom'); module.exports = ReactDOM`;
    case "react-dom/server":
      return `const ReactDOMServer = require('devtools/client/shared/vendor/react-dom-server'); module.exports = ReactDOMServer`;
    case "react-addons-test-utils":
      return `const React = require('devtools/client/shared/vendor/react-dev'); module.exports = React.addons.TestUtils`;
    case "react-redux":
      return `const ReactRedux = require('devtools/client/shared/vendor/react-redux'); module.exports = ReactRedux`;
    // Use react-dev. This would be handled by browserLoader in Firefox.
    case "react":
    case "devtools/client/shared/vendor/react":
      return `const React = require('devtools/client/shared/vendor/react-dev'); module.exports = React`;
    // For Rep's use of AMD
    case "devtools/client/shared/vendor/react.default":
      return `const React = require('devtools/client/shared/vendor/react-dev'); module.exports = React`;
  }

  // Some modules depend on Chrome APIs which don't work in mocha. When such a module
  // is required, replace it with a mock version.
  switch (path) {
    case "devtools/shared/l10n":
      return `module.exports = require("devtools/client/webconsole/new-console-output/test/fixtures/LocalizationHelper")`;
    case "devtools/shared/plural-form":
      return `module.exports = require("devtools/client/webconsole/new-console-output/test/fixtures/PluralForm")`;
    case "Services":
    case "Services.default":
      return `module.exports = require("devtools/client/webconsole/new-console-output/test/fixtures/Services")`;
    case "devtools/shared/client/main":
      return `module.exports = require("devtools/client/webconsole/new-console-output/test/fixtures/ObjectClient")`;
  }
  return undefined;
});
