/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import { SuggestBackend } from "moz-src:///browser/components/urlbar/private/SuggestFeature.sys.mjs";

const lazy = {};

ChromeUtils.defineESModuleGetters(lazy, {
  MLSuggest: "moz-src:///browser/components/urlbar/private/MLSuggest.sys.mjs",
  QuickSuggest: "moz-src:///browser/components/urlbar/QuickSuggest.sys.mjs",
  SkippableTimer: "moz-src:///browser/components/urlbar/UrlbarUtils.sys.mjs",
  UrlbarPrefs: "moz-src:///browser/components/urlbar/UrlbarPrefs.sys.mjs",
});

/**
 * The Suggest ML backend. Both the ML and Rust backends can be enabled at the
 * same time. Features can support both backends and decide which one to use per
 * query.
 */
export class SuggestBackendMl extends SuggestBackend {
  get enablingPreferences() {
    return [
      "browser.ml.enable",
      "quickSuggestMlEnabled",
      "suggest.quicksuggest.all",
    ];
  }

  enable(enabled) {
    if (enabled) {
      this.#init();
    } else {
      this.#uninit();
    }
  }

  /**
   * Queries `MLSuggest` and returns the matching suggestion.
   *
   * @param {string} searchString
   *   The search string.
   * @param {object} options
   *   Options object.
   * @param {UrlbarQueryContext} options.queryContext
   *   The query context.
   * @returns {Promise<Array>}
   *   An array of matching suggestions. `MLSuggest` returns at most one
   *   suggestion.
   */
  async query(searchString, { queryContext }) {
    // `MLSuggest` requires the query to be trimmed and lowercase, which
    // the original `searchString` isn't necessarily.
    searchString = queryContext.trimmedLowerCaseSearchString;

    this.logger.debug("Handling query", { searchString });

    // Don't waste time calling into `MLSuggest` if no ML intents are enabled.
    if (
      lazy.QuickSuggest.mlFeatures
        .values()
        .every(f => !f.isEnabled || !f.isMlIntentEnabled)
    ) {
      this.logger.debug("No ML intents enabled, ignoring query");
      return [];
    }

    let suggestion = await lazy.MLSuggest.makeSuggestions(searchString);
    this.logger.debug("Got suggestion", suggestion);

    if (suggestion?.intent) {
      // `MLSuggest` doesn't have a way to return only enabled intents, so it
      // can return disabled ones and even ones we don't recognize. Discard the
      // suggestion in those cases.
      let feature = lazy.QuickSuggest.getFeatureByMlIntent(suggestion.intent);
      if (!feature?.isEnabled || !feature?.isMlIntentEnabled) {
        this.logger.debug("No ML feature for suggestion, ignoring query");
        return [];
      }
      suggestion.source = "ml";
      suggestion.provider = suggestion.intent;
      return [suggestion];
    }

    return [];
  }

  #init() {
    if (this.#initTimer) {
      return;
    }

    // Like all Suggest features, when this feature is enabled it's typically
    // enabled at startup. Initializing `MLSuggest` loads MB's worth of data,
    // which may slow down the system, so do it on a timer with a configurable
    // timeout.
    this.#initTimer = new lazy.SkippableTimer({
      name: `${this.name} init timer`,
      time: 1000 * lazy.UrlbarPrefs.get("quickSuggestMlInitDelaySeconds"),
      logger: this.logger,
      callback: async () => {
        this.logger.info("Init delay timer fired, initializing MLSuggest");
        await lazy.MLSuggest.initialize();
      },
    });
  }

  async #uninit() {
    this.#initTimer?.cancel();
    this.#initTimer = null;
    await lazy.MLSuggest.shutdown();
  }

  #initTimer;
}
