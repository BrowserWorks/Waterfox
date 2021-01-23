/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const { Component } = require("devtools/client/shared/vendor/react");
const dom = require("devtools/client/shared/vendor/react-dom-factories");
const PropTypes = require("devtools/client/shared/vendor/react-prop-types");
const {
  getUnicodeUrl,
  getUnicodeUrlPath,
  getUnicodeHostname,
} = require("devtools/client/shared/unicode-url");
const {
  getSourceNames,
  parseURL,
  getSourceMappedFile,
} = require("devtools/client/shared/source-utils");
const { LocalizationHelper } = require("devtools/shared/l10n");
const { MESSAGE_SOURCE } = require("devtools/client/webconsole/constants");

const l10n = new LocalizationHelper(
  "devtools/client/locales/components.properties"
);
const webl10n = new LocalizationHelper(
  "devtools/client/locales/webconsole.properties"
);

class Frame extends Component {
  static get propTypes() {
    return {
      // SavedFrame, or an object containing all the required properties.
      frame: PropTypes.shape({
        functionDisplayName: PropTypes.string,
        source: PropTypes.string.isRequired,
        line: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
        column: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
      }).isRequired,
      // Clicking on the frame link -- probably should link to the debugger.
      onClick: PropTypes.func,
      // Option to display a function name before the source link.
      showFunctionName: PropTypes.bool,
      // Option to display a function name even if it's anonymous.
      showAnonymousFunctionName: PropTypes.bool,
      // Option to display a host name after the source link.
      showHost: PropTypes.bool,
      // Option to display a host name if the filename is empty or just '/'
      showEmptyPathAsHost: PropTypes.bool,
      // Option to display a full source instead of just the filename.
      showFullSourceUrl: PropTypes.bool,
      // Service to enable the source map feature for console.
      sourceMapService: PropTypes.object,
      // The source of the message
      messageSource: PropTypes.string,
    };
  }

  static get defaultProps() {
    return {
      showFunctionName: false,
      showAnonymousFunctionName: false,
      showHost: false,
      showEmptyPathAsHost: false,
      showFullSourceUrl: false,
    };
  }

  constructor(props) {
    super(props);
    this._locationChanged = this._locationChanged.bind(this);
    this.getSourceForClick = this.getSourceForClick.bind(this);
  }

  componentWillMount() {
    if (this.props.sourceMapService) {
      const { source, line, column } = this.props.frame;
      this.unsubscribeSourceMapService = this.props.sourceMapService.subscribe(
        source,
        line,
        column,
        this._locationChanged
      );
    }
  }

  componentWillUnmount() {
    if (typeof this.unsubscribeSourceMapService === "function") {
      this.unsubscribeSourceMapService();
    }
  }

  _locationChanged(isSourceMapped, url, line, column) {
    const newState = {
      isSourceMapped,
    };
    if (isSourceMapped) {
      newState.frame = {
        source: url,
        line,
        column,
        functionDisplayName: this.props.frame.functionDisplayName,
      };
    }

    this.setState(newState);
  }

  /**
   * Utility method to convert the Frame object model to the
   * object model required by the onClick callback.
   * @param Frame frame
   * @returns {{url: *, line: *, column: *, functionDisplayName: *}}
   */
  getSourceForClick(frame) {
    const { source, line, column, sourceId } = frame;
    return {
      url: source,
      line,
      column,
      functionDisplayName: this.props.frame.functionDisplayName,
      sourceId,
    };
  }

  // eslint-disable-next-line complexity
  render() {
    let frame, isSourceMapped;
    const {
      onClick,
      showFunctionName,
      showAnonymousFunctionName,
      showHost,
      showEmptyPathAsHost,
      showFullSourceUrl,
      messageSource,
    } = this.props;

    if (this.state && this.state.isSourceMapped && this.state.frame) {
      frame = this.state.frame;
      isSourceMapped = this.state.isSourceMapped;
    } else {
      frame = this.props.frame;
    }

    const source = frame.source || "";
    const sourceId = frame.sourceId;
    const line = frame.line != void 0 ? Number(frame.line) : null;
    const column = frame.column != void 0 ? Number(frame.column) : null;

    const { short, long, host } = getSourceNames(source);
    const unicodeShort = getUnicodeUrlPath(short);
    const unicodeLong = getUnicodeUrl(long);
    const unicodeHost = host ? getUnicodeHostname(host) : "";

    // Reparse the URL to determine if we should link this; `getSourceNames`
    // has already cached this indirectly. We don't want to attempt to
    // link to "self-hosted" and "(unknown)".
    // Source mapped sources might not necessary linkable, but they
    // are still valid in the debugger.
    // If we have a source ID then we can show the source in the debugger.
    const isLinkable = !!parseURL(source) || isSourceMapped || sourceId;
    const elements = [];
    const sourceElements = [];
    let sourceEl;
    let tooltip = unicodeLong;

    // Exclude all falsy values, including `0`, as line numbers start with 1.
    if (line) {
      tooltip += `:${line}`;
      // Intentionally exclude 0
      if (column) {
        tooltip += `:${column}`;
      }
    }

    const attributes = {
      "data-url": long,
      className: "frame-link",
    };

    if (showFunctionName) {
      let functionDisplayName = frame.functionDisplayName;
      if (!functionDisplayName && showAnonymousFunctionName) {
        functionDisplayName = webl10n.getStr("stacktrace.anonymousFunction");
      }

      if (functionDisplayName) {
        elements.push(
          dom.span(
            {
              key: "function-display-name",
              className: "frame-link-function-display-name",
            },
            functionDisplayName
          ),
          " "
        );
      }
    }

    let displaySource = showFullSourceUrl ? unicodeLong : unicodeShort;
    if (isSourceMapped) {
      displaySource = getSourceMappedFile(displaySource);
    } else if (
      showEmptyPathAsHost &&
      (displaySource === "" || displaySource === "/")
    ) {
      displaySource = host;
    }

    sourceElements.push(
      dom.span(
        {
          key: "filename",
          className: "frame-link-filename",
        },
        displaySource
      )
    );

    // If we have a line number > 0.
    if (line) {
      let lineInfo = `:${line}`;
      // Add `data-line` attribute for testing
      attributes["data-line"] = line;

      // Intentionally exclude 0
      if (column) {
        lineInfo += `:${column}`;
        // Add `data-column` attribute for testing
        attributes["data-column"] = column;
      }

      sourceElements.push(
        dom.span(
          {
            key: "line",
            className: "frame-link-line",
          },
          lineInfo
        )
      );
    }

    // Inner el is useful for achieving ellipsis on the left and correct LTR/RTL
    // ordering. See CSS styles for frame-link-source-[inner] and bug 1290056.
    let tooltipMessage;
    if (messageSource && messageSource === MESSAGE_SOURCE.CSS) {
      tooltipMessage = l10n.getFormatStr(
        "frame.viewsourceinstyleeditor",
        tooltip
      );
    } else {
      tooltipMessage = l10n.getFormatStr("frame.viewsourceindebugger", tooltip);
    }

    const sourceInnerEl = dom.span(
      {
        key: "source-inner",
        className: "frame-link-source-inner",
        title: isLinkable ? tooltipMessage : tooltip,
      },
      sourceElements
    );

    // If source is not a URL (self-hosted, eval, etc.), don't make
    // it an anchor link, as we can't link to it.
    if (isLinkable) {
      sourceEl = dom.a(
        {
          onClick: e => {
            e.preventDefault();
            e.stopPropagation();
            onClick(this.getSourceForClick({ ...frame, source, sourceId }));
          },
          href: source,
          className: "frame-link-source",
          draggable: false,
        },
        sourceInnerEl
      );
    } else {
      sourceEl = dom.span(
        {
          key: "source",
          className: "frame-link-source",
        },
        sourceInnerEl
      );
    }
    elements.push(sourceEl);

    if (showHost && unicodeHost) {
      elements.push(" ");
      elements.push(
        dom.span(
          {
            key: "host",
            className: "frame-link-host",
          },
          unicodeHost
        )
      );
    }

    return dom.span(attributes, ...elements);
  }
}

module.exports = Frame;
