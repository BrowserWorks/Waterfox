/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const { DOM, PropTypes } = require("devtools/client/shared/vendor/react");
const { L10N } = require("../utils/l10n");
const { getNetMonitorTimingsURL } = require("../utils/mdn-utils");

// Components
const MDNLink = require("./mdn-link");

const { div, span } = DOM;
const types = ["blocked", "dns", "connect", "ssl", "send", "wait", "receive"];
const TIMINGS_END_PADDING = "80px";

/*
 * Timings panel component
 * Display timeline bars that shows the total wait time for various stages
 */
function TimingsPanel({ request }) {
  if (!request.eventTimings) {
    return null;
  }

  const { timings, totalTime } = request.eventTimings;
  const timelines = types.map((type, idx) => {
    // Determine the relative offset for each timings box. For example, the
    // offset of third timings box will be 0 + blocked offset + dns offset
    const offset = types
      .slice(0, idx)
      .reduce((acc, cur) => (acc + timings[cur] || 0), 0);
    const offsetScale = offset / totalTime || 0;
    const timelineScale = timings[type] / totalTime || 0;

    return div({
      key: type,
      id: `timings-summary-${type}`,
      className: "tabpanel-summary-container timings-container",
    },
      span({ className: "tabpanel-summary-label timings-label" },
        L10N.getStr(`netmonitor.timings.${type}`)
      ),
      div({ className: "requests-list-timings-container" },
        span({
          className: "requests-list-timings-offset",
          style: {
            width: `calc(${offsetScale} * (100% - ${TIMINGS_END_PADDING})`,
          },
        }),
        span({
          className: `requests-list-timings-box ${type}`,
          style: {
            width: `calc(${timelineScale} * (100% - ${TIMINGS_END_PADDING}))`,
          },
        }),
        span({ className: "requests-list-timings-total" },
          L10N.getFormatStr("networkMenu.totalMS", timings[type])
        )
      ),
    );
  });

  return (
    div({ className: "panel-container" },
      timelines,
      MDNLink({
        url: getNetMonitorTimingsURL(),
      }),
    )
  );
}

TimingsPanel.displayName = "TimingsPanel";

TimingsPanel.propTypes = {
  request: PropTypes.object.isRequired,
};

module.exports = TimingsPanel;
