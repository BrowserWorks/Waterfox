"use strict";

module.exports = { // eslint-disable-line no-undef
  // mochitest-chrome tests also exist in this directory, but don't appear to
  // use anything not also available to plain mochitests. Since plain mochitests
  // are the majority, we take the safer option and only extend the
  // mochitest-plain eslintrc file.
  "extends": "../../../../../../testing/mochitest/mochitest.eslintrc.js"
};
