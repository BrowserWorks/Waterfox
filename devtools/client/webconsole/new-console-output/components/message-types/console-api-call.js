/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

// React & Redux
const {
  createFactory,
  DOM: dom,
  PropTypes
} = require("devtools/client/shared/vendor/react");
const GripMessageBody = createFactory(require("devtools/client/webconsole/new-console-output/components/grip-message-body"));
const ConsoleTable = createFactory(require("devtools/client/webconsole/new-console-output/components/console-table"));
const {isGroupType, l10n} = require("devtools/client/webconsole/new-console-output/utils/messages");

const Message = createFactory(require("devtools/client/webconsole/new-console-output/components/message"));

ConsoleApiCall.displayName = "ConsoleApiCall";

ConsoleApiCall.propTypes = {
  message: PropTypes.object.isRequired,
  open: PropTypes.bool,
  serviceContainer: PropTypes.object.isRequired,
  indent: PropTypes.number.isRequired,
};

ConsoleApiCall.defaultProps = {
  open: false,
  indent: 0,
};

function ConsoleApiCall(props) {
  const {
    dispatch,
    message,
    open,
    tableData,
    serviceContainer,
    indent,
  } = props;
  const {
    id: messageId,
    source,
    type,
    level,
    repeat,
    stacktrace,
    frame,
    parameters,
    messageText,
    userProvidedStyles,
  } = message;

  let messageBody;
  if (type === "trace") {
    messageBody = dom.span({className: "cm-variable"}, "console.trace()");
  } else if (type === "assert") {
    let reps = formatReps(parameters);
    messageBody = dom.span({ className: "cm-variable" }, "Assertion failed: ", reps);
  } else if (type === "table") {
    // TODO: Chrome does not output anything, see if we want to keep this
    messageBody = dom.span({className: "cm-variable"}, "console.table()");
  } else if (parameters) {
    messageBody = formatReps(parameters, userProvidedStyles, serviceContainer);
  } else {
    messageBody = messageText;
  }

  let attachment = null;
  if (type === "table") {
    attachment = ConsoleTable({
      dispatch,
      id: message.id,
      serviceContainer,
      parameters: message.parameters,
      tableData
    });
  }

  let collapseTitle = null;
  if (isGroupType(type)) {
    collapseTitle = l10n.getStr("groupToggle");
  }

  const collapsible = isGroupType(type)
    || (type === "error" && Array.isArray(stacktrace));
  const topLevelClasses = ["cm-s-mozilla"];

  return Message({
    messageId,
    open,
    collapsible,
    collapseTitle,
    source,
    type,
    level,
    topLevelClasses,
    messageBody,
    repeat,
    frame,
    stacktrace,
    attachment,
    serviceContainer,
    dispatch,
    indent,
  });
}

function formatReps(parameters, userProvidedStyles, serviceContainer) {
  return (
    parameters
      // Get all the grips.
      .map((grip, key) => GripMessageBody({
        grip,
        key,
        userProvidedStyle: userProvidedStyles ? userProvidedStyles[key] : null,
        serviceContainer
      }))
      // Interleave spaces.
      .reduce((arr, v, i) => {
        return i + 1 < parameters.length
          ? arr.concat(v, dom.span({}, " "))
          : arr.concat(v);
      }, [])
  );
}

module.exports = ConsoleApiCall;

