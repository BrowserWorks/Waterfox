/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

import React from "react";
import { Localized } from "./MSLocalized";
import { Themes } from "./Themes";
import { SecondaryCTA, StepsIndicator } from "./MultiStageAboutWelcome";

export class MultiStageProtonScreen extends React.PureComponent {
  componentDidMount() {
    this.mainContentHeader.focus();
  }

  render() {
    const { content, totalNumberOfScreens: total } = this.props;
    const isWelcomeScreen = this.props.order === 0;
    // Assign proton screen style 'screen-1' or 'screen-2' by checking
    // if screen order is even or odd.
    const screenClassName = isWelcomeScreen
      ? "screen-0"
      : `${this.props.order === 1 ? `dialog-initial` : ``} ${
          this.props.order === total ? `dialog-last` : ``
        } screen-${this.props.order % 2 !== 0 ? 1 : 2}`;

    return (
      <main className={`screen ${this.props.id} ${screenClassName}`}>
        {isWelcomeScreen ? (
          <div className="section-left">
            <div className="message-text">
              <div className="spacer-top" />
              <Localized text={content.subtitle}>
                <h1 />
              </Localized>
              <div className="spacer-bottom" />
            </div>
            {content.help_text && content.help_text.text ? (
              <Localized text={content.help_text.text}>
                <a href="https://flic.kr/p/AYfRz1" className="attrib-text" />
              </Localized>
            ) : null}
          </div>
        ) : null}
        <div className="section-main">
          {content.secondary_button_top ? (
            <SecondaryCTA
              content={content}
              handleAction={this.props.handleAction}
              position="top"
            />
          ) : null}
          <div className={`noodle orange-L`} />
          <div className={`noodle purple-C`} />
          {isWelcomeScreen ? <div className={`noodle solid-L`} /> : null}
          <div className={`noodle outline-L`} />
          <div className={`noodle yellow-circle`} />
          <div className="main-content">
            <div className="brand-logo" />
            <div className="welcome-text">
              <Localized text={content.title}>
                <h1
                  tabIndex="-1"
                  ref={input => {
                    this.mainContentHeader = input;
                  }}
                />
              </Localized>
              {!isWelcomeScreen ? (
                <Localized text={content.subtitle}>
                  <h2 />
                </Localized>
              ) : null}
            </div>
            {content.tiles &&
            content.tiles.type === "theme" &&
            content.tiles.data ? (
              <Themes
                content={content}
                activeTheme={this.props.activeTheme}
                handleAction={this.props.handleAction}
                design={this.props.design}
              />
            ) : null}
            <div>
              <Localized
                text={
                  content.primary_button ? content.primary_button.label : null
                }
              >
                <button
                  className="primary"
                  value="primary_button"
                  onClick={this.props.handleAction}
                />
              </Localized>
            </div>
            {content.secondary_button ? (
              <SecondaryCTA
                content={content}
                handleAction={this.props.handleAction}
              />
            ) : null}
            {!isWelcomeScreen ? (
              <nav
                className="steps"
                data-l10n-id={"onboarding-welcome-steps-indicator"}
                data-l10n-args={JSON.stringify({
                  current: this.props.order,
                  total,
                })}
              >
                {/* These empty elements are here to help trigger the nav for screen readers. */}
                <br />
                <p />
                <StepsIndicator
                  order={this.props.order - 1}
                  totalNumberOfScreens={total}
                />
              </nav>
            ) : null}
          </div>
        </div>
      </main>
    );
  }
}
