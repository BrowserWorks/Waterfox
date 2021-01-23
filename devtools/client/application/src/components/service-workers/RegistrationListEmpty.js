/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const { openDocLink, openTrustedLink } = require("devtools/client/shared/link");
const {
  createFactory,
  PureComponent,
} = require("devtools/client/shared/vendor/react");
const {
  a,
  article,
  h1,
  li,
  p,
  ul,
} = require("devtools/client/shared/vendor/react-dom-factories");

const FluentReact = require("devtools/client/shared/vendor/fluent-react");
const Localized = createFactory(FluentReact.Localized);

const {
  services,
} = require("devtools/client/application/src/modules/application-services");

const DOC_URL =
  "https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers" +
  "?utm_source=devtools&utm_medium=sw-panel-blank";

/**
 * This component displays help information when no service workers are found for the
 * current target.
 */
class RegistrationListEmpty extends PureComponent {
  switchToConsole() {
    services.selectTool("webconsole");
  }

  switchToDebugger() {
    services.selectTool("jsdebugger");
  }

  openAboutDebugging() {
    openTrustedLink("about:debugging#workers");
  }

  openDocumentation() {
    openDocLink(DOC_URL);
  }

  render() {
    return article(
      { className: "registration-list-empty js-registration-list-empty" },
      Localized(
        {
          id: "serviceworker-empty-intro",
          a: a({
            className: "external-link",
            onClick: () => this.openDocumentation(),
          }),
        },
        h1({ className: "app-page__title" })
      ),
      Localized({ id: "serviceworker-empty-suggestions" }, p({})),
      ul(
        { className: "registration-list-empty__tips" },
        Localized(
          {
            id: "serviceworker-empty-suggestions-console",
            a: a({ className: "link", onClick: () => this.switchToConsole() }),
          },
          li({ className: "registration-list-empty__tips-item" })
        ),
        Localized(
          {
            id: "serviceworker-empty-suggestions-debugger",
            a: a({ className: "link", onClick: () => this.switchToDebugger() }),
          },
          li({ className: "registration-list-empty__tips-item" })
        ),
        Localized(
          {
            id: "serviceworker-empty-suggestions-aboutdebugging",
            a: a({
              className: "link js-trusted-link",
              onClick: () => this.openAboutDebugging(),
            }),
          },
          li({ className: "registration-list-empty__tips-item" })
        )
      )
    );
  }
}

// Exports
module.exports = RegistrationListEmpty;
