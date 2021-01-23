/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

import React from "react";
import { Trailhead } from "../Trailhead/Trailhead";
import { ReturnToAMO } from "../ReturnToAMO/ReturnToAMO";
import { FullPageInterrupt } from "../FullPageInterrupt/FullPageInterrupt";
import { LocalizationProvider } from "fluent-react";
import { generateBundles } from "../../rich-text-strings";

export class Interrupt extends React.PureComponent {
  render() {
    const {
      cards,
      onDismiss,
      onNextScene,
      message,
      sendUserActionTelemetry,
      executeAction,
      dispatch,
      fxaEndpoint,
      UTMTerm,
      flowParams,
    } = this.props;

    switch (message.template) {
      case "return_to_amo_overlay":
        return (
          <LocalizationProvider
            bundles={generateBundles({ amo_html: message.content.text })}
          >
            <ReturnToAMO
              {...message}
              document={this.props.document}
              UISurface="NEWTAB_OVERLAY"
              onBlock={onDismiss}
              onAction={executeAction}
              sendUserActionTelemetry={sendUserActionTelemetry}
            />
          </LocalizationProvider>
        );
      case "full_page_interrupt":
        return (
          <FullPageInterrupt
            document={this.props.document}
            cards={cards}
            message={message}
            onBlock={onDismiss}
            onAction={executeAction}
            dispatch={dispatch}
            fxaEndpoint={fxaEndpoint}
            sendUserActionTelemetry={sendUserActionTelemetry}
            UTMTerm={UTMTerm}
            flowParams={flowParams}
            onBlockById={this.props.onBlockById}
          />
        );
      case "trailhead":
        return (
          <Trailhead
            document={this.props.document}
            message={message}
            onNextScene={onNextScene}
            onAction={executeAction}
            sendUserActionTelemetry={sendUserActionTelemetry}
            dispatch={dispatch}
            fxaEndpoint={fxaEndpoint}
            UTMTerm={UTMTerm}
            flowParams={flowParams}
          />
        );
      default:
        throw new Error(`${message.template} is not a valid FirstRun message`);
    }
  }
}
