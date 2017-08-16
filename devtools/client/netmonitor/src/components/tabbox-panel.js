/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const {
  createFactory,
  PropTypes,
} = require("devtools/client/shared/vendor/react");
const { connect } = require("devtools/client/shared/vendor/react-redux");
const Actions = require("../actions/index");
const { L10N } = require("../utils/l10n");
const { getSelectedRequest } = require("../selectors/index");

// Components
const Tabbar = createFactory(require("devtools/client/shared/components/tabs/tabbar"));
const TabPanel = createFactory(require("devtools/client/shared/components/tabs/tabs").TabPanel);
const CookiesPanel = createFactory(require("./cookies-panel"));
const HeadersPanel = createFactory(require("./headers-panel"));
const ParamsPanel = createFactory(require("./params-panel"));
const ResponsePanel = createFactory(require("./response-panel"));
const SecurityPanel = createFactory(require("./security-panel"));
const StackTracePanel = createFactory(require("./stack-trace-panel"));
const TimingsPanel = createFactory(require("./timings-panel"));

const COOKIES_TITLE = L10N.getStr("netmonitor.tab.cookies");
const HEADERS_TITLE = L10N.getStr("netmonitor.tab.headers");
const PARAMS_TITLE = L10N.getStr("netmonitor.tab.params");
const RESPONSE_TITLE = L10N.getStr("netmonitor.tab.response");
const SECURITY_TITLE = L10N.getStr("netmonitor.tab.security");
const STACK_TRACE_TITLE = L10N.getStr("netmonitor.tab.stackTrace");
const TIMINGS_TITLE = L10N.getStr("netmonitor.tab.timings");

/*
 * Tabbox panel component
 * Display the network request details
 */
function TabboxPanel({
  activeTabId,
  cloneSelectedRequest,
  request,
  selectTab,
  sourceMapService,
}) {
  if (!request) {
    return null;
  }

  return (
    Tabbar({
      activeTabId,
      onSelect: selectTab,
      renderOnlySelected: true,
      showAllTabsMenu: true,
    },
      TabPanel({
        id: "headers",
        title: HEADERS_TITLE,
      },
        HeadersPanel({ request, cloneSelectedRequest }),
      ),
      TabPanel({
        id: "cookies",
        title: COOKIES_TITLE,
      },
        CookiesPanel({ request }),
      ),
      TabPanel({
        id: "params",
        title: PARAMS_TITLE,
      },
        ParamsPanel({ request }),
      ),
      TabPanel({
        id: "response",
        title: RESPONSE_TITLE,
      },
        ResponsePanel({ request }),
      ),
      TabPanel({
        id: "timings",
        title: TIMINGS_TITLE,
      },
        TimingsPanel({ request }),
      ),
      request.cause && request.cause.stacktrace && request.cause.stacktrace.length > 0 &&
      TabPanel({
        id: "stack-trace",
        title: STACK_TRACE_TITLE,
      },
        StackTracePanel({ request, sourceMapService }),
      ),
      request.securityState && request.securityState !== "insecure" &&
      TabPanel({
        id: "security",
        title: SECURITY_TITLE,
      },
        SecurityPanel({ request }),
      ),
    )
  );
}

TabboxPanel.displayName = "TabboxPanel";

TabboxPanel.propTypes = {
  activeTabId: PropTypes.string,
  cloneSelectedRequest: PropTypes.func.isRequired,
  request: PropTypes.object,
  selectTab: PropTypes.func.isRequired,
  // Service to enable the source map feature.
  sourceMapService: PropTypes.object,
};

module.exports = connect(
  (state) => ({
    activeTabId: state.ui.detailsPanelSelectedTab,
    request: getSelectedRequest(state),
  }),
  (dispatch) => ({
    cloneSelectedRequest: () => dispatch(Actions.cloneSelectedRequest()),
    selectTab: (tabId) => dispatch(Actions.selectDetailsPanelTab(tabId)),
  }),
)(TabboxPanel);
