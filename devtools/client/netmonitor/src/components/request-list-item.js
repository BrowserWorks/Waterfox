/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const {
  createClass,
  createFactory,
  DOM,
  PropTypes,
} = require("devtools/client/shared/vendor/react");
const I = require("devtools/client/shared/vendor/immutable");
const { propertiesEqual } = require("../utils/request-utils");

// Components
const RequestListColumnCause = createFactory(require("./request-list-column-cause"));
const RequestListColumnContentSize = createFactory(require("./request-list-column-content-size"));
const RequestListColumnCookies = createFactory(require("./request-list-column-cookies"));
const RequestListColumnDomain = createFactory(require("./request-list-column-domain"));
const RequestListColumnDuration = createFactory(require("./request-list-column-duration"));
const RequestListColumnEndTime = createFactory(require("./request-list-column-end-time"));
const RequestListColumnFile = createFactory(require("./request-list-column-file"));
const RequestListColumnLatency = createFactory(require("./request-list-column-latency"));
const RequestListColumnMethod = createFactory(require("./request-list-column-method"));
const RequestListColumnProtocol = createFactory(require("./request-list-column-protocol"));
const RequestListColumnRemoteIP = createFactory(require("./request-list-column-remote-ip"));
const RequestListColumnResponseTime = createFactory(require("./request-list-column-response-time"));
const RequestListColumnScheme = createFactory(require("./request-list-column-scheme"));
const RequestListColumnSetCookies = createFactory(require("./request-list-column-set-cookies"));
const RequestListColumnStartTime = createFactory(require("./request-list-column-start-time"));
const RequestListColumnStatus = createFactory(require("./request-list-column-status"));
const RequestListColumnTransferredSize = createFactory(require("./request-list-column-transferred-size"));
const RequestListColumnType = createFactory(require("./request-list-column-type"));
const RequestListColumnWaterfall = createFactory(require("./request-list-column-waterfall"));

const { div } = DOM;

/**
 * Used by shouldComponentUpdate: compare two items, and compare only properties
 * relevant for rendering the RequestListItem. Other properties (like request and
 * response headers, cookies, bodies) are ignored. These are very useful for the
 * network details, but not here.
 */
const UPDATED_REQ_ITEM_PROPS = [
  "mimeType",
  "eventTimings",
  "securityState",
  "responseContentDataUri",
  "status",
  "statusText",
  "fromCache",
  "fromServiceWorker",
  "method",
  "url",
  "remoteAddress",
  "cause",
  "contentSize",
  "transferredSize",
  "startedMillis",
  "totalTime",
];

const UPDATED_REQ_PROPS = [
  "firstRequestStartedMillis",
  "index",
  "isSelected",
  "waterfallWidth",
];

/**
 * Render one row in the request list.
 */
const RequestListItem = createClass({
  displayName: "RequestListItem",

  propTypes: {
    columns: PropTypes.object.isRequired,
    item: PropTypes.object.isRequired,
    index: PropTypes.number.isRequired,
    isSelected: PropTypes.bool.isRequired,
    firstRequestStartedMillis: PropTypes.number.isRequired,
    fromCache: PropTypes.bool,
    onCauseBadgeMouseDown: PropTypes.func.isRequired,
    onContextMenu: PropTypes.func.isRequired,
    onFocusedNodeChange: PropTypes.func,
    onMouseDown: PropTypes.func.isRequired,
    onSecurityIconMouseDown: PropTypes.func.isRequired,
    onThumbnailMouseDown: PropTypes.func.isRequired,
    onWaterfallMouseDown: PropTypes.func.isRequired,
    waterfallWidth: PropTypes.number,
  },

  componentDidMount() {
    if (this.props.isSelected) {
      this.refs.listItem.focus();
    }
  },

  shouldComponentUpdate(nextProps) {
    return !propertiesEqual(UPDATED_REQ_ITEM_PROPS, this.props.item, nextProps.item) ||
      !propertiesEqual(UPDATED_REQ_PROPS, this.props, nextProps) ||
      !I.is(this.props.columns, nextProps.columns);
  },

  componentDidUpdate(prevProps) {
    if (!prevProps.isSelected && this.props.isSelected) {
      this.refs.listItem.focus();
      if (this.props.onFocusedNodeChange) {
        this.props.onFocusedNodeChange();
      }
    }
  },

  render() {
    let {
      columns,
      item,
      index,
      isSelected,
      firstRequestStartedMillis,
      fromCache,
      onContextMenu,
      onMouseDown,
      onCauseBadgeMouseDown,
      onSecurityIconMouseDown,
      onThumbnailMouseDown,
      onWaterfallMouseDown,
    } = this.props;

    let classList = ["request-list-item", index % 2 ? "odd" : "even"];
    isSelected && classList.push("selected");
    fromCache && classList.push("fromCache");

    return (
      div({
        ref: "listItem",
        className: classList.join(" "),
        "data-id": item.id,
        tabIndex: 0,
        onContextMenu,
        onMouseDown,
      },
        columns.get("status") && RequestListColumnStatus({ item }),
        columns.get("method") && RequestListColumnMethod({ item }),
        columns.get("file") && RequestListColumnFile({ item, onThumbnailMouseDown }),
        columns.get("protocol") && RequestListColumnProtocol({ item }),
        columns.get("scheme") && RequestListColumnScheme({ item }),
        columns.get("domain") && RequestListColumnDomain({ item,
                                                           onSecurityIconMouseDown }),
        columns.get("remoteip") && RequestListColumnRemoteIP({ item }),
        columns.get("cause") && RequestListColumnCause({ item, onCauseBadgeMouseDown }),
        columns.get("type") && RequestListColumnType({ item }),
        columns.get("cookies") && RequestListColumnCookies({ item }),
        columns.get("setCookies") && RequestListColumnSetCookies({ item }),
        columns.get("transferred") && RequestListColumnTransferredSize({ item }),
        columns.get("contentSize") && RequestListColumnContentSize({ item }),
        columns.get("startTime") &&
          RequestListColumnStartTime({ item, firstRequestStartedMillis }),
        columns.get("endTime") &&
          RequestListColumnEndTime({ item, firstRequestStartedMillis }),
        columns.get("responseTime") &&
          RequestListColumnResponseTime({ item, firstRequestStartedMillis }),
        columns.get("duration") && RequestListColumnDuration({ item }),
        columns.get("latency") && RequestListColumnLatency({ item }),
        columns.get("waterfall") &&
          RequestListColumnWaterfall({ item, firstRequestStartedMillis,
                                       onWaterfallMouseDown }),
      )
    );
  }
});

module.exports = RequestListItem;
