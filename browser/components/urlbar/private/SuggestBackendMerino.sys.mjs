/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import { SuggestBackend } from "moz-src:///browser/components/urlbar/private/SuggestFeature.sys.mjs";

const lazy = {};

ChromeUtils.defineESModuleGetters(lazy, {
  MerinoClient: "moz-src:///browser/components/urlbar/MerinoClient.sys.mjs",
});

/**
 * @import {MerinoClient} from "moz-src:///browser/components/urlbar/MerinoClient.sys.mjs"
 */

/**
 * The Suggest Merino backend. This backend is enabled when online Suggest is
 * available to the user and enabled.
 */
export class SuggestBackendMerino extends SuggestBackend {
  get enablingPreferences() {
    return [
      "quickSuggestOnlineAvailable",

      // This pref corresponds to the online checkbox in the Suggest settings
      // UI.
      "quicksuggest.online.enabled",

      // This pref corresponds to the "Suggestions from Firefox" checkbox in the
      // Suggest settings UI. The online checkbox is nested underneath that
      // checkbox, so gate the backend on its pref.
      "suggest.quicksuggest.all",
    ];
  }

  /**
   * @returns {MerinoClient}
   *   The Merino client. The client is created lazily and isn't kept around
   *   when the backend is disabled, so this may return null.
   */
  get client() {
    return this.#client;
  }

  async enable(enabled) {
    if (!enabled) {
      this.#client = null;
    }
  }

  async query(searchString, { queryContext }) {
    if (!searchString || !queryContext.allowRemoteResults()) {
      return [];
    }

    this.logger.debug("Handling query", { searchString });

    if (!this.#client) {
      this.#client = new lazy.MerinoClient(this.name, { allowOhttp: true });
    }

    let suggestions = await this.#client.fetch({
      query: searchString,
    });

    this.logger.debug("Got suggestions", suggestions);

    return suggestions;
  }

  cancelQuery() {
    // Cancel the Merino timeout timer so it doesn't fire and record a timeout.
    // If it's already canceled or has fired, this is a no-op.
    this.#client?.cancelTimeoutTimer();

    // Don't abort the Merino fetch if one is ongoing. By design we allow
    // fetches to finish so we can record their latency.
  }

  onSearchSessionEnd(_queryContext, _controller, _details) {
    // Reset the Merino session ID when a session ends. By design for the user's
    // privacy, we don't keep it around between engagements.
    this.#client?.resetSession();
  }

  // `MerinoClient`
  #client = null;
}
