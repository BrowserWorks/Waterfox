/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
/* import-globals-from ./netmonitor-controller.js */
/* globals $ */
"use strict";

const {PluralForm} = require("devtools/shared/plural-form");
const {Filters} = require("./filter-predicates");
const {L10N} = require("./l10n");
const Actions = require("./actions/index");

const REQUEST_TIME_DECIMALS = 2;
const CONTENT_SIZE_DECIMALS = 2;

// px
const NETWORK_ANALYSIS_PIE_CHART_DIAMETER = 200;

/**
 * Functions handling the performance statistics view.
 */
function PerformanceStatisticsView() {
}

PerformanceStatisticsView.prototype = {
  /**
   * Initialization function, called when the debugger is started.
   */
  initialize: function (store) {
    this.store = store;
  },

  /**
   * Initializes and displays empty charts in this container.
   */
  displayPlaceholderCharts: function () {
    this._createChart({
      id: "#primed-cache-chart",
      title: "charts.cacheEnabled"
    });
    this._createChart({
      id: "#empty-cache-chart",
      title: "charts.cacheDisabled"
    });
    window.emit(EVENTS.PLACEHOLDER_CHARTS_DISPLAYED);
  },

  /**
   * Populates and displays the primed cache chart in this container.
   *
   * @param array items
   *        @see this._sanitizeChartDataSource
   */
  createPrimedCacheChart: function (items) {
    this._createChart({
      id: "#primed-cache-chart",
      title: "charts.cacheEnabled",
      data: this._sanitizeChartDataSource(items),
      strings: this._commonChartStrings,
      totals: this._commonChartTotals,
      sorted: true
    });
    window.emit(EVENTS.PRIMED_CACHE_CHART_DISPLAYED);
  },

  /**
   * Populates and displays the empty cache chart in this container.
   *
   * @param array items
   *        @see this._sanitizeChartDataSource
   */
  createEmptyCacheChart: function (items) {
    this._createChart({
      id: "#empty-cache-chart",
      title: "charts.cacheDisabled",
      data: this._sanitizeChartDataSource(items, true),
      strings: this._commonChartStrings,
      totals: this._commonChartTotals,
      sorted: true
    });
    window.emit(EVENTS.EMPTY_CACHE_CHART_DISPLAYED);
  },

  /**
   * Common stringifier predicates used for items and totals in both the
   * "primed" and "empty" cache charts.
   */
  _commonChartStrings: {
    size: value => {
      let string = L10N.numberWithDecimals(value / 1024, CONTENT_SIZE_DECIMALS);
      return L10N.getFormatStr("charts.sizeKB", string);
    },
    time: value => {
      let string = L10N.numberWithDecimals(value / 1000, REQUEST_TIME_DECIMALS);
      return L10N.getFormatStr("charts.totalS", string);
    }
  },
  _commonChartTotals: {
    size: total => {
      let string = L10N.numberWithDecimals(total / 1024, CONTENT_SIZE_DECIMALS);
      return L10N.getFormatStr("charts.totalSize", string);
    },
    time: total => {
      let seconds = total / 1000;
      let string = L10N.numberWithDecimals(seconds, REQUEST_TIME_DECIMALS);
      return PluralForm.get(seconds,
        L10N.getStr("charts.totalSeconds")).replace("#1", string);
    },
    cached: total => {
      return L10N.getFormatStr("charts.totalCached", total);
    },
    count: total => {
      return L10N.getFormatStr("charts.totalCount", total);
    }
  },

  /**
   * Adds a specific chart to this container.
   *
   * @param object
   *        An object containing all or some the following properties:
   *          - id: either "#primed-cache-chart" or "#empty-cache-chart"
   *          - title/data/strings/totals/sorted: @see Chart.jsm for details
   */
  _createChart: function ({ id, title, data, strings, totals, sorted }) {
    let container = $(id);

    // Nuke all existing charts of the specified type.
    while (container.hasChildNodes()) {
      container.firstChild.remove();
    }

    // Create a new chart.
    let chart = Chart.PieTable(document, {
      diameter: NETWORK_ANALYSIS_PIE_CHART_DIAMETER,
      title: L10N.getStr(title),
      data: data,
      strings: strings,
      totals: totals,
      sorted: sorted
    });

    chart.on("click", (_, item) => {
      // Reset FilterButtons and enable one filter exclusively
      this.store.dispatch(Actions.enableFilterTypeOnly(item.label));
      NetMonitorView.showNetworkInspectorView();
    });

    container.appendChild(chart.node);
  },

  /**
   * Sanitizes the data source used for creating charts, to follow the
   * data format spec defined in Chart.jsm.
   *
   * @param array items
   *        A collection of request items used as the data source for the chart.
   * @param boolean emptyCache
   *        True if the cache is considered enabled, false for disabled.
   */
  _sanitizeChartDataSource: function (items, emptyCache) {
    let data = [
      "html", "css", "js", "xhr", "fonts", "images", "media", "flash", "ws", "other"
    ].map(e => ({
      cached: 0,
      count: 0,
      label: e,
      size: 0,
      time: 0
    }));

    for (let requestItem of items) {
      let details = requestItem.attachment;
      let type;

      if (Filters.html(details)) {
        // "html"
        type = 0;
      } else if (Filters.css(details)) {
        // "css"
        type = 1;
      } else if (Filters.js(details)) {
        // "js"
        type = 2;
      } else if (Filters.fonts(details)) {
        // "fonts"
        type = 4;
      } else if (Filters.images(details)) {
        // "images"
        type = 5;
      } else if (Filters.media(details)) {
        // "media"
        type = 6;
      } else if (Filters.flash(details)) {
        // "flash"
        type = 7;
      } else if (Filters.ws(details)) {
        // "ws"
        type = 8;
      } else if (Filters.xhr(details)) {
        // Verify XHR last, to categorize other mime types in their own blobs.
        // "xhr"
        type = 3;
      } else {
        // "other"
        type = 9;
      }

      if (emptyCache || !responseIsFresh(details)) {
        data[type].time += details.totalTime || 0;
        data[type].size += details.contentSize || 0;
      } else {
        data[type].cached++;
      }
      data[type].count++;
    }

    return data.filter(e => e.count > 0);
  },
};

/**
 * Checks if the "Expiration Calculations" defined in section 13.2.4 of the
 * "HTTP/1.1: Caching in HTTP" spec holds true for a collection of headers.
 *
 * @param object
 *        An object containing the { responseHeaders, status } properties.
 * @return boolean
 *         True if the response is fresh and loaded from cache.
 */
function responseIsFresh({ responseHeaders, status }) {
  // Check for a "304 Not Modified" status and response headers availability.
  if (status != 304 || !responseHeaders) {
    return false;
  }

  let list = responseHeaders.headers;
  let cacheControl = list.filter(e => {
    return e.name.toLowerCase() == "cache-control";
  })[0];

  let expires = list.filter(e => e.name.toLowerCase() == "expires")[0];

  // Check the "Cache-Control" header for a maximum age value.
  if (cacheControl) {
    let maxAgeMatch =
      cacheControl.value.match(/s-maxage\s*=\s*(\d+)/) ||
      cacheControl.value.match(/max-age\s*=\s*(\d+)/);

    if (maxAgeMatch && maxAgeMatch.pop() > 0) {
      return true;
    }
  }

  // Check the "Expires" header for a valid date.
  if (expires && Date.parse(expires.value)) {
    return true;
  }

  return false;
}

exports.PerformanceStatisticsView = PerformanceStatisticsView;
