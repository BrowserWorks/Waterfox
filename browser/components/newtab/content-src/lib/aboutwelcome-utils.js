/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

export const AboutWelcomeUtils = {
  handleUserAction(action) {
    window.AWSendToParent("SPECIAL_ACTION", action);
  },
  sendImpressionTelemetry(messageId, context) {
    window.AWSendEventTelemetry({
      event: "IMPRESSION",
      event_context: context,
      message_id: messageId,
    });
  },
  sendActionTelemetry(messageId, elementId) {
    const ping = {
      event: "CLICK_BUTTON",
      event_context: {
        source: elementId,
        page: "about:welcome",
      },
      message_id: messageId,
    };
    window.AWSendEventTelemetry(ping);
  },
  async fetchFlowParams(metricsFlowUri) {
    let flowParams;
    try {
      const response = await fetch(metricsFlowUri, {
        credentials: "omit",
      });
      if (response.status === 200) {
        const { deviceId, flowId, flowBeginTime } = await response.json();
        flowParams = { deviceId, flowId, flowBeginTime };
      } else {
        console.error("Non-200 response", response); // eslint-disable-line no-console
      }
    } catch (e) {
      flowParams = null;
    }
    return flowParams;
  },
  sendEvent(type, detail) {
    document.dispatchEvent(
      new CustomEvent(`AWPage:${type}`, {
        bubbles: true,
        detail,
      })
    );
  },
  hasDarkMode() {
    return document.body.hasAttribute("lwt-newtab-brighttext");
  },
};

export const DEFAULT_WELCOME_CONTENT = {
  template: "multistage",
  screens: [
    {
      id: "AW_GET_STARTED",
      order: 0,
      content: {
        zap: true,
        title: "Welcome to Waterfox",
        subtitle: "The fast, safe, and private browser that’s built for YOU.",
        primary_button: {
          label: {
            string_id: "onboarding-multistage-welcome-primary-button-label",
          },
          action: {
            navigate: true,
          },
        },
        secondary_button: {
          text: {
            string_id: "onboarding-multistage-welcome-secondary-button-text",
          },
          label: {
            string_id: "onboarding-multistage-welcome-secondary-button-label",
          },
          position: "top",
          action: {
            type: "SHOW_FIREFOX_ACCOUNTS",
            addFlowParams: true,
            data: {
              entrypoint: "activity-stream-firstrun",
            },
          },
        },
      },
    },
    {
      id: "AW_IMPORT_SETTINGS",
      order: 1,
      content: {
        zap: true,
        disclaimer: { string_id: "onboarding-import-sites-disclaimer" },
        title: { string_id: "onboarding-multistage-import-header" },
        subtitle: { string_id: "onboarding-multistage-import-subtitle" },
        tiles: {
          type: "topsites",
          info: true,
        },
        primary_button: {
          label: {
            string_id: "onboarding-multistage-import-primary-button-label",
          },
          action: {
            type: "SHOW_MIGRATION_WIZARD",
            navigate: true,
          },
        },
        secondary_button: {
          label: {
            string_id: "onboarding-multistage-import-secondary-button-label",
          },
          action: {
            navigate: true,
          },
        },
      },
    },
    {
      id: "AW_CHOOSE_THEME",
      order: 2,
      content: {
        zap: true,
        title: { string_id: "onboarding-multistage-theme-header" },
        subtitle: { string_id: "onboarding-multistage-theme-subtitle" },
        tiles: {
          type: "theme",
          action: {
            theme: "<event>",
          },
          data: [
            {
              theme: "floe",
              label: "Floe",
              tooltip: "Floe, the light theme for Waterfox",
            },
            {
              theme: "abyss",
              label: "Abyss",
              tooltip: "Abyss, the dark theme for Waterfox",
            },
            {
              theme: "automatic",
              label: "Photon Dynamic",
              tooltip: "The familiar Photon theme",
            },
          ],
        },
        primary_button: {
          label: {
            string_id: "onboarding-multistage-theme-primary-button-label",
          },
          action: {
            navigate: true,
          },
        },
        secondary_button: {
          label: {
            string_id: "onboarding-multistage-theme-secondary-button-label",
          },
          action: {
            theme: "floe",
            navigate: true,
          },
        },
        checkbox: {
          label: {
            string_id: "onboarding-multistage-theme-checkbox-label"
          },
          action: {
            themeAuto: "<event>",
            navigate: false,
          },
        },
      },
    },
    {
      id: "AW_SEARCH",
      order: 3,
      content: {
        zap: true,
		    title: { string_id: "onboarding-multistage-search-header" },
        subtitle: { string_id: "onboarding-multistage-search-subtitle" },
        additional: { string_id: "onboarding-multistage-search-additional" },
        additional2: { string_id: "onboarding-multistage-search-additional2"},
        primary_button: {
          label: {
            string_id: "onboarding-multistage-search-primary-button-label",
          },
          action: {
			      search: "startpage",
            navigate: true,
          },
        },
        secondary_button: {
          label: {
            string_id: "onboarding-multistage-search-secondary-button-label",
          },
          action: {
            search: "bing",
            navigate: true,
          },
        },
      },
    },
    {
      id: "AW_DEFAULT",
      order: 4,
      content: {
        zap: true,
		    title: "Best as Default",
        subtitle: "Set Waterfox as your default web browser to get the best user experience.",
        primary_button: {
          label: "Make default...",
          action: {
			      type: "SET_DEFAULT_BROWSER",
            navigate: true,
          },
        },
        secondary_button: {
          label: {
            string_id: "onboarding-multistage-import-secondary-button-label",
          },
          action: {
            navigate: true,
          },
        },
      },
    },
    {
      id: "AW_PRIVACY",
      order: 5,
      content: {
        title: "Automatic Privacy",
        subtitle:
          "Waterfox automatically blocks trackers and malware, and keeps companies from secretly following you around. When you see the shield while browsing, Waterfox is protecting you.",
        tiles: {
          type: "video",
          media_type: "privacy",
          source: {
            default:
              "resource://activity-stream/data/content/assets/privacy-onboarding.webm",
            dark:
              "resource://activity-stream/data/content/assets/privacy-onboarding-dark.webm",
          },
        },
        primary_button: {
          label: "Start Browsing",
          action: {
            navigate: true,
          },
        },
      },
    },
  ],
};
