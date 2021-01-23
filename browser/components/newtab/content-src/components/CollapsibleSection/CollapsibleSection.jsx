/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

import { actionCreators as ac } from "common/Actions.jsm";
import { ErrorBoundary } from "content-src/components/ErrorBoundary/ErrorBoundary";
import { FluentOrText } from "content-src/components/FluentOrText/FluentOrText";
import React from "react";
import { SectionMenu } from "content-src/components/SectionMenu/SectionMenu";
import { SectionMenuOptions } from "content-src/lib/section-menu-options";
import { ContextMenuButton } from "content-src/components/ContextMenu/ContextMenuButton";

const VISIBLE = "visible";
const VISIBILITY_CHANGE_EVENT = "visibilitychange";

export class CollapsibleSection extends React.PureComponent {
  constructor(props) {
    super(props);
    this.onBodyMount = this.onBodyMount.bind(this);
    this.onHeaderClick = this.onHeaderClick.bind(this);
    this.onKeyPress = this.onKeyPress.bind(this);
    this.onTransitionEnd = this.onTransitionEnd.bind(this);
    this.enableOrDisableAnimation = this.enableOrDisableAnimation.bind(this);
    this.onMenuButtonMouseEnter = this.onMenuButtonMouseEnter.bind(this);
    this.onMenuButtonMouseLeave = this.onMenuButtonMouseLeave.bind(this);
    this.onMenuUpdate = this.onMenuUpdate.bind(this);
    this.state = {
      enableAnimation: true,
      isAnimating: false,
      menuButtonHover: false,
      showContextMenu: false,
    };
    this.setContextMenuButtonRef = this.setContextMenuButtonRef.bind(this);
  }

  componentWillMount() {
    this.props.document.addEventListener(
      VISIBILITY_CHANGE_EVENT,
      this.enableOrDisableAnimation
    );
  }

  componentWillUpdate(nextProps) {
    // Check if we're about to go from expanded to collapsed
    if (!this.props.collapsed && nextProps.collapsed) {
      // This next line forces a layout flush of the section body, which has a
      // max-height style set, so that the upcoming collapse animation can
      // animate from that height to the collapsed height. Without this, the
      // update is coalesced and there's no animation from no-max-height to 0.
      this.sectionBody.scrollHeight; // eslint-disable-line no-unused-expressions
    }
  }

  setContextMenuButtonRef(element) {
    this.contextMenuButtonRef = element;
  }

  componentDidMount() {
    this.contextMenuButtonRef.addEventListener(
      "mouseenter",
      this.onMenuButtonMouseEnter
    );
    this.contextMenuButtonRef.addEventListener(
      "mouseleave",
      this.onMenuButtonMouseLeave
    );
  }

  componentWillUnmount() {
    this.props.document.removeEventListener(
      VISIBILITY_CHANGE_EVENT,
      this.enableOrDisableAnimation
    );
    this.contextMenuButtonRef.removeEventListener(
      "mouseenter",
      this.onMenuButtonMouseEnter
    );
    this.contextMenuButtonRef.removeEventListener(
      "mouseleave",
      this.onMenuButtonMouseLeave
    );
  }

  enableOrDisableAnimation() {
    // Only animate the collapse/expand for visible tabs.
    const visible = this.props.document.visibilityState === VISIBLE;
    if (this.state.enableAnimation !== visible) {
      this.setState({ enableAnimation: visible });
    }
  }

  onBodyMount(node) {
    this.sectionBody = node;
  }

  onHeaderClick() {
    // If this.sectionBody is unset, it means that we're in some sort of error
    // state, probably displaying the error fallback, so we won't be able to
    // compute the height, and we don't want to persist the preference.
    // If props.collapsed is undefined handler shouldn't do anything.
    if (!this.sectionBody || this.props.collapsed === undefined) {
      return;
    }

    // Get the current height of the body so max-height transitions can work
    this.setState({
      isAnimating: true,
      maxHeight: `${this._getSectionBodyHeight()}px`,
    });
    const { action, userEvent } = SectionMenuOptions.CheckCollapsed(this.props);
    this.props.dispatch(action);
    this.props.dispatch(
      ac.UserEvent({
        event: userEvent,
        source: this.props.source,
      })
    );
  }

  onKeyPress(event) {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault();
      this.onHeaderClick();
    }
  }

  _getSectionBodyHeight() {
    const div = this.sectionBody;
    if (div.style.display === "none") {
      // If the div isn't displayed, we can't get it's height. So we display it
      // to get the height (it doesn't show up because max-height is set to 0px
      // in CSS). We don't undo this because we are about to expand the section.
      div.style.display = "block";
    }
    return div.scrollHeight;
  }

  onTransitionEnd(event) {
    // Only update the animating state for our own transition (not a child's)
    if (event.target === event.currentTarget) {
      this.setState({ isAnimating: false });
    }
  }

  renderIcon() {
    const { icon } = this.props;
    if (icon && icon.startsWith("moz-extension://")) {
      return (
        <span
          className="icon icon-small-spacer"
          style={{ backgroundImage: `url('${icon}')` }}
        />
      );
    }
    return (
      <span
        className={`icon icon-small-spacer icon-${icon || "webextension"}`}
      />
    );
  }

  onMenuButtonMouseEnter() {
    this.setState({ menuButtonHover: true });
  }

  onMenuButtonMouseLeave() {
    this.setState({ menuButtonHover: false });
  }

  onMenuUpdate(showContextMenu) {
    this.setState({ showContextMenu });
  }

  render() {
    const isCollapsible = this.props.collapsed !== undefined;
    const {
      enableAnimation,
      isAnimating,
      maxHeight,
      menuButtonHover,
      showContextMenu,
    } = this.state;
    const {
      id,
      eventSource,
      collapsed,
      learnMore,
      title,
      extraMenuOptions,
      showPrefName,
      privacyNoticeURL,
      dispatch,
      isFixed,
      isFirst,
      isLast,
      isWebExtension,
    } = this.props;
    const active = menuButtonHover || showContextMenu;
    let bodyStyle;
    if (isAnimating && !collapsed) {
      bodyStyle = { maxHeight };
    } else if (!isAnimating && collapsed) {
      bodyStyle = { display: "none" };
    }
    return (
      <section
        className={`collapsible-section ${this.props.className}${
          enableAnimation ? " animation-enabled" : ""
        }${collapsed ? " collapsed" : ""}${active ? " active" : ""}`}
        aria-expanded={!collapsed}
        // Note: data-section-id is used for web extension api tests in mozilla central
        data-section-id={id}
      >
        <div className="section-top-bar">
          <h3 className="section-title">
            <span className="click-target-container">
              {/* Click-targets that toggle a collapsible section should have an aria-expanded attribute; see bug 1553234 */}
              <span
                className="click-target"
                role="button"
                tabIndex="0"
                onKeyPress={this.onKeyPress}
                onClick={this.onHeaderClick}
              >
                {this.renderIcon()}
                <FluentOrText message={title} />
                {isCollapsible && (
                  <span
                    data-l10n-id={
                      collapsed
                        ? "newtab-section-expand-section-label"
                        : "newtab-section-collapse-section-label"
                    }
                    className={`collapsible-arrow icon ${
                      collapsed
                        ? "icon-arrowhead-forward-small"
                        : "icon-arrowhead-down-small"
                    }`}
                  />
                )}
              </span>
              <span className="learn-more-link-wrapper">
                {learnMore && (
                  <span className="learn-more-link">
                    <FluentOrText message={learnMore.link.message}>
                      <a href={learnMore.link.href} />
                    </FluentOrText>
                  </span>
                )}
              </span>
            </span>
          </h3>
          <div>
            <ContextMenuButton
              tooltip="newtab-menu-section-tooltip"
              onUpdate={this.onMenuUpdate}
              refFunction={this.setContextMenuButtonRef}
            >
              <SectionMenu
                id={id}
                extraOptions={extraMenuOptions}
                eventSource={eventSource}
                showPrefName={showPrefName}
                privacyNoticeURL={privacyNoticeURL}
                collapsed={collapsed}
                isFixed={isFixed}
                isFirst={isFirst}
                isLast={isLast}
                dispatch={dispatch}
                isWebExtension={isWebExtension}
              />
            </ContextMenuButton>
          </div>
        </div>
        <ErrorBoundary className="section-body-fallback">
          <div
            className={`section-body${isAnimating ? " animating" : ""}`}
            onTransitionEnd={this.onTransitionEnd}
            ref={this.onBodyMount}
            style={bodyStyle}
          >
            {this.props.children}
          </div>
        </ErrorBoundary>
      </section>
    );
  }
}

CollapsibleSection.defaultProps = {
  document: global.document || {
    addEventListener: () => {},
    removeEventListener: () => {},
    visibilityState: "hidden",
  },
  Prefs: { values: {} },
};
