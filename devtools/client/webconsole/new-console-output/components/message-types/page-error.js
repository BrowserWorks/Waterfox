/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

// React & Redux
const {
  createFactory,
  PropTypes
} = require("devtools/client/shared/vendor/react");
const Message = createFactory(require("devtools/client/webconsole/new-console-output/components/message"));

PageError.displayName = "PageError";

PageError.propTypes = {
  message: PropTypes.object.isRequired,
  open: PropTypes.bool,
  indent: PropTypes.number.isRequired,
};

PageError.defaultProps = {
  open: false,
  indent: 0,
};

function PageError(props) {
  const {
    dispatch,
    message,
    open,
    serviceContainer,
    indent,
  } = props;
  const {
    id: messageId,
    source,
    type,
    level,
    messageText: messageBody,
    repeat,
    stacktrace,
    frame,
    exceptionDocURL,
  } = message;

  const childProps = {
    dispatch,
    messageId,
    open,
    collapsible: Array.isArray(stacktrace),
    source,
    type,
    level,
    topLevelClasses: [],
    indent,
    messageBody,
    repeat,
    frame,
    stacktrace,
    serviceContainer,
    exceptionDocURL,
  };
  return Message(childProps);
}

module.exports = PageError;
