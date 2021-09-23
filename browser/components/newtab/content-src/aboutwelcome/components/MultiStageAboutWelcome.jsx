/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

import React, { useState, useCallback, useEffect } from "react";
import { Localized } from "./MSLocalized";
import { Zap } from "./Zap";
import { AboutWelcomeUtils } from "../../lib/aboutwelcome-utils";
import {
  BASE_PARAMS,
  addUtmParams,
} from "../../asrouter/templates/FirstRun/addUtmParams";

export const MultiStageAboutWelcome = props => {
  const [index, setScreenIndex] = useState(0);
  useEffect(() => {
    // Send impression ping when respective screen first renders
    props.screens.forEach(screen => {
      if (index === screen.order) {
        AboutWelcomeUtils.sendImpressionTelemetry(
          `${props.message_id}_${screen.id}`
        );
      }
    });

    // Remember that a new screen has loaded for browser navigation
    if (index > window.history.state) {
      window.history.pushState(index, "");
    }
  }, [index]);

  useEffect(() => {
    // Switch to the screen tracked in state (null for initial state)
    const handler = ({ state }) => setScreenIndex(Number(state));

    // Handle page load, e.g., going back to about:welcome from about:home
    handler(window.history);

    // Watch for browser back/forward button navigation events
    window.addEventListener("popstate", handler);
    return () => window.removeEventListener("popstate", handler);
  }, []);

  const [flowParams, setFlowParams] = useState(null);
  const { metricsFlowUri } = props;
  useEffect(() => {
    (async () => {
      if (metricsFlowUri) {
        setFlowParams(await AboutWelcomeUtils.fetchFlowParams(metricsFlowUri));
      }
    })();
  }, [metricsFlowUri]);

  // Transition to next screen, opening about:home on last screen button CTA
  const handleTransition =
    index < props.screens.length
      ? useCallback(() => setScreenIndex(prevState => prevState + 1), [])
      : AboutWelcomeUtils.handleUserAction({
          type: "OPEN_ABOUT_PAGE",
          data: { args: "home", where: "current" },
        });

  // Update top sites with default sites by region when region is available
  const [region, setRegion] = useState(null);
  useEffect(() => {
    (async () => {
      setRegion(await window.AWWaitForRegionChange());
    })();
  }, []);

  const useImportable = props.message_id.includes("IMPORTABLE");
  // Track whether we have already sent the importable sites impression telemetry
  const [importTelemetrySent, setImportTelemetrySent] = useState(null);
  const [topSites, setTopSites] = useState([]);
  useEffect(() => {
    (async () => {
      let DEFAULT_SITES = await window.AWGetDefaultSites();
      const importable = JSON.parse(await window.AWGetImportableSites());
      const showImportable = useImportable && importable.length >= 5;
      if (!importTelemetrySent) {
        AboutWelcomeUtils.sendImpressionTelemetry(`${props.message_id}_SITES`, {
          display: showImportable ? "importable" : "static",
          importable: importable.length,
        });
        setImportTelemetrySent(true);
      }
      setTopSites(
        showImportable
          ? { data: importable, showImportable }
          : { data: DEFAULT_SITES, showImportable }
      );
    })();
  }, [useImportable, region]);

  return (
    <React.Fragment>
      <div className={`outer-wrapper multistageContainer`}>
        {props.screens.map(screen => {
          return index === screen.order ? (
            <WelcomeScreen
              id={screen.id}
              totalNumberOfScreens={props.screens.length}
              order={screen.order}
              content={screen.content}
              navigate={handleTransition}
              topSites={topSites}
              messageId={`${props.message_id}_${screen.id}`}
              UTMTerm={props.utm_term}
              flowParams={flowParams}
            />
          ) : null;
        })}
      </div>
    </React.Fragment>
  );
};

export class WelcomeScreen extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      themeAuto: false
    };
    this.handleAction = this.handleAction.bind(this);
  }

  handleOpenURL(action, flowParams, UTMTerm) {
    let { type, data } = action;
    if (type === "SHOW_FIREFOX_ACCOUNTS") {
      let params = {
        ...BASE_PARAMS,
        utm_term: `aboutwelcome-${UTMTerm}-screen`,
      };
      if (action.addFlowParams && flowParams) {
        params = {
          ...params,
          ...flowParams,
        };
      }
      data = { ...data, extraParams: params };
    } else if (type === "OPEN_URL") {
      let url = new URL(data.args);
      addUtmParams(url, `aboutwelcome-${UTMTerm}-screen`);
      if (action.addFlowParams && flowParams) {
        url.searchParams.append("device_id", flowParams.deviceId);
        url.searchParams.append("flow_id", flowParams.flowId);
        url.searchParams.append("flow_begin_time", flowParams.flowBeginTime);
      }
      data = { ...data, args: url.toString() };
    }
    AboutWelcomeUtils.handleUserAction({ type, data });
  }

  highlightTheme(theme) {
    const themes = document.querySelectorAll("label.theme");
    themes.forEach(function(element) {
      element.classList.remove("selected");
      if (element.firstElementChild.value === theme) {
        element.classList.add("selected");
      }
    });
  }

  setSearch(ev){
	  alert("Your file is being uploaded!")
  }

  async handleAction(event) {
    let { props } = this;
    let value = event.currentTarget.type === "checkbox" ? event.currentTarget.type : event.currentTarget.value;
    let targetContent =
      props.content[value] || props.content.tiles;
    if (!(targetContent && targetContent.action)) {
      return;
    }

    // Send telemetry before waiting on actions
    AboutWelcomeUtils.sendActionTelemetry(
      props.messageId,
      value
    );

    let { action } = targetContent;

    if (["OPEN_URL", "SHOW_FIREFOX_ACCOUNTS"].includes(action.type)) {
      this.handleOpenURL(action, props.flowParams, props.UTMTerm);
    } else if (action.type) {
      AboutWelcomeUtils.handleUserAction(action);
      // Wait until migration closes to complete the action
      if (action.type === "SHOW_MIGRATION_WIZARD") {
        await window.AWWaitForMigrationClose();
        AboutWelcomeUtils.sendActionTelemetry(props.messageId, "migrate_close");
      }
    }

    // A special tiles.action.theme value indicates we should use the event's value vs provided value.
    if (action.theme) {
      this.highlightTheme(value);
      window.AWSelectTheme(
        action.theme === "<event>" ? value : action.theme
      );
    }

    if (action.themeAuto) {
      window.AWSetThemeAuto(event.currentTarget.checked);
      this.setState({
        [event.currentTarget.name]: event.currentTarget.checked
      });
    }

    if (action.search) {
      window.AWSelectSearchEngine(action.search);
    }

    if (action.navigate) {
      props.navigate();
    }
  }

  renderSecondaryCTA(className) {
    let altName = this.props.id === "AW_SEARCH" ? "primary" : "secondary";
    return (
      <div className={`secondary-cta ${className}`}>
        <Localized text={this.props.content.secondary_button.text}>
          <span />
        </Localized>
        <Localized text={this.props.content.secondary_button.label}>
          <button
            className={`${altName}`}
            value="secondary_button"
            onClick={this.handleAction}
          />
        </Localized>
      </div>
    );
  }

  renderCheckbox(className) {
    return (
      <div className={`checkbox ${className}`}>
        <form>
          <label>
            <input
              name="themeAuto" type="checkbox"
              checked={this.state.themeAuto}
              onChange={this.handleAction} />
            <Localized text={this.props.content.checkbox.label}/>
          </label>
        </form>
      </div>
    );
  }

  renderTiles() {
    switch (this.props.content.tiles.type) {
      case "topsites":
		  return <div class="tiles-container info"><div class="tiles-topsites-section" name="topsites-section" id="topsites-section" aria-labelledby="topsites-disclaimer" role="region"><div class="site" aria-label="chrome" role="img"><div class="icon" style={{backgroundColor: "transparent", backgroundImage: `url('resource://activity-stream/data/content/tippytop/images/chrome@2x.png')`}}></div></div><div class="site" aria-label="edge" role="img"><div class="icon" style={{backgroundColor: "transparent", backgroundImage: `url('resource://activity-stream/data/content/tippytop/images/edge@2x.png')`}}></div></div><div class="site" aria-label="firefox" role="img"><div class="icon" style={{backgroundColor: "transparent", backgroundImage: `url('resource://activity-stream/data/content/tippytop/images/firefox@2x.png')`}}></div></div><div class="site" aria-label="safari" role="img"><div class="icon" style={{backgroundColor: "transparent", backgroundImage: `url('resource://activity-stream/data/content/tippytop/images/safari@2x.png')`}}></div></div></div></div>
      case "theme":
        return this.props.content.tiles.data ? (
          <div className="tiles-theme-container">
            <div>
              <fieldset className="tiles-theme-section">
                <Localized text={this.props.content.subtitle}>
                  <legend className="sr-only" />
                </Localized>
                {this.props.content.tiles.data.map(
                  ({ theme, label, tooltip }) => (
                    <Localized
                      key={theme + label}
                      text={typeof tooltip === "object" ? tooltip : {}}
                    >
                      <label className="theme" title={theme + label}>
                        <input
                          type="radio"
                          value={theme}
                          name="theme"
                          className="sr-only input"
                          onClick={this.handleAction}
                        />
                        <div className={`icon ${theme}`} />
                        {label && (
                          <Localized text={label}>
                            <div className="text" />
                          </Localized>
                        )}
                      </label>
                    </Localized>
                  )
                )}
              </fieldset>
            </div>
          </div>
        ) : null;
      case "video":
        return this.props.content.tiles.source ? (
          <div
            className={`tiles-media-section ${this.props.content.tiles.media_type}`}
          >
            <div className="fade" />
            <video
              className="media"
              autoPlay="true"
              loop="true"
              muted="true"
              src={
                AboutWelcomeUtils.hasDarkMode()
                  ? this.props.content.tiles.source.dark
                  : this.props.content.tiles.source.default
              }
            />
          </div>
        ) : null;
    }
    return null;
  }

  renderAdditional() {
    return (
      <div className="additional-text">
        <Localized text={this.props.content.additional}></Localized>
        <Localized text={this.props.content.additional2}></Localized>
      </div>
    )
  }

  renderStepsIndicator() {
    let steps = [];
    for (let i = 0; i < this.props.totalNumberOfScreens; i++) {
      let className = i === this.props.order ? "current" : "";
      steps.push(<div key={i} className={`indicator ${className}`} />);
    }
    return steps;
  }

  renderDisclaimer() {
    if (
      this.props.content.tiles &&
      this.props.content.tiles.type === "topsites" &&
      this.props.topSites &&
      this.props.topSites.showImportable
    ) {
      return (
        <Localized text={this.props.content.disclaimer}>
          <p id="topsites-disclaimer" className="tiles-topsites-disclaimer" />
        </Localized>
      );
    }
    return null;
  }

  render() {
    const { content, topSites } = this.props;
    const hasSecondaryTopCTA =
      content.secondary_button && content.secondary_button.position === "top";
    return (
      <main className={`screen ${this.props.id}`}>
        {hasSecondaryTopCTA ? this.renderSecondaryCTA("top") : null}
        <div className={`brand-logo ${hasSecondaryTopCTA ? "cta-top" : ""}`} />
        <div className="welcome-text">
          <Zap hasZap={content.zap} text={content.title} />
          <Localized text={content.subtitle}>
            <h2 />
          </Localized>
        </div>
        {content.tiles ? this.renderTiles() : null}
        {content.checkbox ? this.renderCheckbox("theme-auto") : null}
        <div>
          <Localized
            text={content.primary_button ? content.primary_button.label : null}
          >
            <button
              className="primary"
              value="primary_button"
              onClick={this.handleAction}
            />
          </Localized>
        </div>
        {content.additional ? this.renderAdditional() : null}
        {content.secondary_button && content.secondary_button.position !== "top"
          ? this.renderSecondaryCTA("")
          : null}
        <nav
          className={
            content.tiles &&
            content.tiles.type === "topsites" &&
            topSites &&
            topSites.showImportable
              ? "steps has-disclaimer"
              : "steps"
          }
          data-l10n-id={"onboarding-welcome-steps-indicator"}
          data-l10n-args={`{"current": ${parseInt(this.props.order, 10) +
            1}, "total": ${this.props.totalNumberOfScreens}}`}
        >
          {this.renderStepsIndicator()}
        </nav>
        {this.renderDisclaimer()}
      </main>
    );
  }
}
