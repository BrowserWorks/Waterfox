/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";
/* globals Localization */

const { XPCOMUtils } = ChromeUtils.importESModule(
  "resource://gre/modules/XPCOMUtils.sys.mjs"
);
const { AppConstants } = ChromeUtils.importESModule(
  "resource://gre/modules/AppConstants.sys.mjs"
);
const { FeatureCalloutMessages } = ChromeUtils.importESModule(
  "resource://activity-stream/lib/FeatureCalloutMessages.sys.mjs"
);

const lazy = {};

ChromeUtils.defineESModuleGetters(lazy, {
  BrowserUtils: "resource://gre/modules/BrowserUtils.sys.mjs",
  NimbusFeatures: "resource://nimbus/ExperimentAPI.sys.mjs",
  ShellService: "resource:///modules/ShellService.sys.mjs",
});

XPCOMUtils.defineLazyPreferenceGetter(
  lazy,
  "usesFirefoxSync",
  "services.sync.username"
);

XPCOMUtils.defineLazyPreferenceGetter(
  lazy,
  "mobileDevices",
  "services.sync.clients.devices.mobile",
  0
);

XPCOMUtils.defineLazyPreferenceGetter(
  lazy,
  "hidePrivatePin",
  "browser.startup.upgradeDialog.pinPBM.disabled",
  false
);

const L10N = new Localization([
  "branding/brand.ftl",
  "browser/newtab/onboarding.ftl",
  "toolkit/branding/brandings.ftl",
  "toolkit/branding/accounts.ftl",
]);

const HOMEPAGE_PREF = "browser.startup.homepage";
const NEWTAB_PREF = "browser.newtabpage.enabled";

const BASE_MESSAGES = () => [
  {
    id: "FXA_ACCOUNTS_BADGE",
    template: "toolbar_badge",
    content: {
      delay: 10000, // delay for 10 seconds
      target: "fxa-toolbar-menu-button",
    },
    targeting: "false",
    trigger: { id: "toolbarBadgeUpdate" },
  },
  {
    id: "PROTECTIONS_PANEL_1",
    template: "protections_panel",
    content: {
      title: { string_id: "cfr-protections-panel-header" },
      body: { string_id: "cfr-protections-panel-body" },
      link_text: { string_id: "cfr-protections-panel-link-text" },
      cta_url: `${Services.urlFormatter.formatURLPref(
        "app.support.baseURL"
      )}etp-promotions?as=u&utm_source=inproduct`,
      cta_type: "OPEN_URL",
    },
    trigger: { id: "protectionsPanelOpen" },
  },
  {
    id: "CFR_FIREFOX_VIEW",
    groups: ["cfr"],
    template: "cfr_doorhanger",
    //If Firefox View button has been moved to the overflow menu, we want to change the anchor element
    content: {
      bucket_id: "CFR_FIREFOX_VIEW",
      anchor_id: "firefox-view-button",
      alt_anchor_id: "nav-bar-overflow-button",
      layout: "icon_and_message",
      icon: "chrome://browser/content/cfr-lightning.svg",
      icon_dark_theme: "chrome://browser/content/cfr-lightning-dark.svg",
      icon_class: "cfr-doorhanger-small-icon",
      heading_text: {
        string_id: "firefoxview-cfr-header-v2",
      },
      text: {
        string_id: "firefoxview-cfr-body-v2",
      },
      buttons: {
        primary: {
          label: {
            string_id: "firefoxview-cfr-primarybutton",
          },
          action: {
            type: "OPEN_FIREFOX_VIEW",
            navigate: true,
          },
        },
        secondary: [
          {
            label: {
              string_id: "firefoxview-cfr-secondarybutton",
            },
            action: {
              type: "CANCEL",
            },
          },
        ],
      },
      skip_address_bar_notifier: true,
    },
    frequency: {
      lifetime: 1,
    },
    trigger: {
      id: "nthTabClosed",
    },
    // Avoid breaking existing tests that close tabs for now.
    targeting: `!inMr2022Holdback && fxViewButtonAreaType != null && (currentDate|date - profileAgeCreated) / 86400000 >= 2 && tabsClosedCount >= 3 && 'browser.firefox-view.view-count'|preferenceValue == 0 && !'browser.newtabpage.activity-stream.asrouter.providers.cfr'|preferenceIsUserSet`,
  },
  {
    id: "FX_MR_106_UPGRADE",
    template: "spotlight",
    targeting: "true",
    content: {
      template: "multistage",
      id: "FX_MR_106_UPGRADE",
      transitions: true,
      modal: "tab",
      screens: [
        {
          id: "UPGRADE_PIN_FIREFOX",
          content: {
            position: "split",
            split_narrow_bkg_position: "-155px",
            image_alt_text: {
              string_id: "mr2022-onboarding-pin-image-alt",
            },
            progress_bar: "true",
            background:
              "url('chrome://onboarding/content/assets/loving-doodle.svg') var(--mr-secondary-position) no-repeat var(--mr-screen-background-color)",
            logo: {},
            title: {
              string_id: "mr2022-onboarding-existing-pin-header",
            },
            subtitle: {
              string_id: "mr2022-onboarding-existing-pin-subtitle",
            },
            primary_button: {
              label: {
                string_id: "mr2022-onboarding-pin-primary-button-label",
              },
              action: {
                navigate: true,
                type: "PIN_FIREFOX_TO_TASKBAR",
              },
            },
            checkbox: {
              label: {
                string_id: "mr2022-onboarding-existing-pin-checkbox-label",
              },
              defaultValue: true,
              action: {
                type: "MULTI_ACTION",
                navigate: true,
                data: {
                  actions: [
                    {
                      type: "PIN_FIREFOX_TO_TASKBAR",
                      data: {
                        privatePin: true,
                      },
                    },
                    {
                      type: "PIN_FIREFOX_TO_TASKBAR",
                    },
                  ],
                },
              },
            },
            secondary_button: {
              label: {
                string_id: "mr2022-onboarding-secondary-skip-button-label",
              },
              action: {
                navigate: true,
              },
              has_arrow_icon: true,
            },
          },
        },
        {
          id: "UPGRADE_SET_DEFAULT",
          content: {
            position: "split",
            split_narrow_bkg_position: "-60px",
            image_alt_text: {
              string_id: "mr2022-onboarding-default-image-alt",
            },
            progress_bar: "true",
            background:
              "url('chrome://onboarding/content/assets/loving-doodle.svg') var(--mr-secondary-position) no-repeat var(--mr-screen-background-color)",
            logo: {},
            title: {
              string_id: "mr2022-onboarding-set-default-title",
            },
            subtitle: {
              string_id: "mr2022-onboarding-set-default-subtitle",
            },
            primary_button: {
              label: {
                string_id: "mr2022-onboarding-set-default-primary-button-label",
              },
              action: {
                navigate: true,
                type: "SET_DEFAULT_BROWSER",
              },
            },
            secondary_button: {
              label: {
                string_id: "mr2022-onboarding-secondary-skip-button-label",
              },
              action: {
                navigate: true,
              },
              has_arrow_icon: true,
            },
          },
        },
        {
          id: "UPGRADE_IMPORT_SETTINGS",
          content: {
            position: "split",
            split_narrow_bkg_position: "-42px",
            image_alt_text: {
              string_id: "mr2022-onboarding-import-image-alt",
            },
            progress_bar: "true",
            background:
              "url('chrome://activity-stream/content/data/content/assets/mr-import.svg') var(--mr-secondary-position) no-repeat var(--mr-screen-background-color)",
            logo: {},
            title: {
              string_id: "mr2022-onboarding-import-header",
            },
            subtitle: {
              string_id: "mr2022-onboarding-import-subtitle",
            },
            primary_button: {
              label: {
                string_id:
                  "mr2022-onboarding-import-primary-button-label-no-attribution",
              },
              action: {
                type: "SHOW_MIGRATION_WIZARD",
                data: {},
                navigate: true,
              },
            },
            secondary_button: {
              label: {
                string_id: "mr2022-onboarding-secondary-skip-button-label",
              },
              action: {
                navigate: true,
              },
              has_arrow_icon: true,
            },
          },
        },
        {
          id: "UPGRADE_MOBILE_DOWNLOAD",
          content: {
            position: "split",
            split_narrow_bkg_position: "-160px",
            image_alt_text: {
              string_id: "mr2022-onboarding-mobile-download-image-alt",
            },
            background:
              "url('chrome://activity-stream/content/data/content/assets/mr-mobilecrosspromo.svg') var(--mr-secondary-position) no-repeat var(--mr-screen-background-color)",
            progress_bar: true,
            logo: {},
            title: {
              string_id: "mr2022-onboarding-mobile-download-title",
            },
            subtitle: {
              string_id: "mr2022-onboarding-mobile-download-subtitle",
            },
            hero_image: {
              url: "chrome://activity-stream/content/data/content/assets/mobile-download-qr-existing-user.svg",
            },
            cta_paragraph: {
              text: {
                string_id: "mr2022-onboarding-mobile-download-cta-text",
                string_name: "download-label",
              },
              action: {
                type: "OPEN_URL",
                data: {
                  args: "https://www.waterfox.net/download/",
                  where: "tab",
                },
              },
            },
            secondary_button: {
              label: {
                string_id: "mr2022-onboarding-secondary-skip-button-label",
              },
              action: {
                navigate: true,
              },
              has_arrow_icon: true,
            },
          },
        },
        {
          id: "UPGRADE_PIN_PRIVATE_WINDOW",
          content: {
            position: "split",
            split_narrow_bkg_position: "-100px",
            image_alt_text: {
              string_id: "mr2022-onboarding-pin-private-image-alt",
            },
            progress_bar: "true",
            background:
              "url('chrome://activity-stream/content/data/content/assets/mr-pinprivate.svg') var(--mr-secondary-position) no-repeat var(--mr-screen-background-color)",
            logo: {},
            title: {
              string_id: "mr2022-upgrade-onboarding-pin-private-window-header",
            },
            subtitle: {
              string_id:
                "mr2022-upgrade-onboarding-pin-private-window-subtitle",
            },
            primary_button: {
              label: {
                string_id:
                  "mr2022-upgrade-onboarding-pin-private-window-primary-button-label",
              },
              action: {
                type: "PIN_FIREFOX_TO_TASKBAR",
                data: {
                  privatePin: true,
                },
                navigate: true,
              },
            },
            secondary_button: {
              label: {
                string_id: "mr2022-onboarding-secondary-skip-button-label",
              },
              action: {
                navigate: true,
              },
              has_arrow_icon: true,
            },
          },
        },
        {
          id: "UPGRADE_DATA_RECOMMENDATION",
          content: {
            position: "split",
            split_narrow_bkg_position: "-80px",
            image_alt_text: {
              string_id: "mr2022-onboarding-privacy-segmentation-image-alt",
            },
            progress_bar: "true",
            background:
              "url('chrome://activity-stream/content/data/content/assets/mr-privacysegmentation.svg') var(--mr-secondary-position) no-repeat var(--mr-screen-background-color)",
            logo: {},
            title: {
              string_id: "mr2022-onboarding-privacy-segmentation-title",
            },
            subtitle: {
              string_id: "mr2022-onboarding-privacy-segmentation-subtitle",
            },
            cta_paragraph: {
              text: {
                string_id: "mr2022-onboarding-privacy-segmentation-text-cta",
              },
            },
            primary_button: {
              label: {
                string_id:
                  "mr2022-onboarding-privacy-segmentation-button-primary-label",
              },
              action: {
                type: "SET_PREF",
                data: {
                  pref: {
                    name: "browser.dataFeatureRecommendations.enabled",
                    value: true,
                  },
                },
                navigate: true,
              },
            },
            additional_button: {
              label: {
                string_id:
                  "mr2022-onboarding-privacy-segmentation-button-secondary-label",
              },
              style: "secondary",
              action: {
                type: "SET_PREF",
                data: {
                  pref: {
                    name: "browser.dataFeatureRecommendations.enabled",
                    value: false,
                  },
                },
                navigate: true,
              },
            },
          },
        },
        {
          id: "UPGRADE_GRATITUDE",
          content: {
            position: "split",
            progress_bar: "true",
            split_narrow_bkg_position: "-228px",
            image_alt_text: {
              string_id: "mr2022-onboarding-gratitude-image-alt",
            },
            background:
              "url('chrome://onboarding/content/assets/plant-doodle.svg') var(--mr-secondary-position) no-repeat var(--mr-screen-background-color)",
            logo: {},
            title: {
              string_id: "mr2022-onboarding-gratitude-title",
            },
            subtitle: {
              string_id: "mr2022-onboarding-gratitude-subtitle",
            },
            primary_button: {
              label: {
                string_id: "mr2022-onboarding-gratitude-primary-button-label",
              },
              action: {
                type: "OPEN_FIREFOX_VIEW",
                navigate: true,
              },
            },
            secondary_button: {
              label: {
                string_id: "mr2022-onboarding-gratitude-secondary-button-label",
              },
              action: {
                navigate: true,
              },
            },
          },
        },
      ],
    },
  },
  {
    id: "FX_100_UPGRADE",
    template: "spotlight",
    targeting: "false",
    content: {
      template: "multistage",
      id: "FX_100_UPGRADE",
      transitions: true,
      screens: [
        {
          id: "UPGRADE_PIN_FIREFOX",
          content: {
            logo: {
              imageURL:
                "chrome://activity-stream/content/data/content/assets/heart.webp",
              height: "73px",
            },
            has_noodles: true,
            title: {
              fontSize: "36px",
              string_id: "fx100-upgrade-thanks-header",
            },
            title_style: "fancy shine",
            background:
              "url('chrome://activity-stream/content/data/content/assets/confetti.svg') top / 100% no-repeat var(--in-content-page-background)",
            subtitle: {
              string_id: "fx100-upgrade-thanks-keep-body",
            },
            primary_button: {
              label: {
                string_id: "fx100-thank-you-pin-primary-button-label",
              },
              action: {
                navigate: true,
                type: "PIN_FIREFOX_TO_TASKBAR",
              },
            },
            secondary_button: {
              label: {
                string_id: "onboarding-not-now-button-label",
              },
              action: {
                navigate: true,
              },
            },
          },
        },
      ],
    },
  },
  {
    id: "PB_NEWTAB_FOCUS_PROMO",
    type: "default",
    template: "pb_newtab",
    groups: ["pbNewtab"],
    content: {
      infoBody: "fluent:about-private-browsing-info-description-simplified",
      infoEnabled: true,
      infoIcon: "chrome://global/skin/icons/indicator-private-browsing.svg",
      infoLinkText: "fluent:about-private-browsing-learn-more-link",
      infoTitle: "",
      infoTitleEnabled: false,
      promoEnabled: true,
      promoType: "FOCUS",
      promoHeader: "fluent:about-private-browsing-focus-promo-header-c",
      promoImageLarge: "chrome://browser/content/assets/focus-promo.png",
      promoLinkText: "fluent:about-private-browsing-focus-promo-cta",
      promoLinkType: "button",
      promoSectionStyle: "below-search",
      promoTitle: "fluent:about-private-browsing-focus-promo-text-c",
      promoTitleEnabled: true,
      promoButton: {
        action: {
          type: "SHOW_SPOTLIGHT",
          data: {
            content: {
              id: "FOCUS_PROMO",
              template: "multistage",
              modal: "tab",
              backdrop: "transparent",
              screens: [
                {
                  id: "DEFAULT_MODAL_UI",
                  content: {
                    logo: {
                      imageURL:
                        "chrome://browser/content/assets/focus-logo.svg",
                      height: "48px",
                    },
                    title: {
                      string_id: "spotlight-focus-promo-title",
                    },
                    subtitle: {
                      string_id: "spotlight-focus-promo-subtitle",
                    },
                    dismiss_button: {
                      action: {
                        navigate: true,
                      },
                    },
                    ios: {
                      action: {
                        data: {
                          args: "https://app.adjust.com/167k4ih?campaign=firefox-desktop&adgroup=pb&creative=focus-omc172&redirect=https%3A%2F%2Fapps.apple.com%2Fus%2Fapp%2Ffirefox-focus-privacy-browser%2Fid1055677337",
                          where: "tabshifted",
                        },
                        type: "OPEN_URL",
                        navigate: true,
                      },
                    },
                    android: {
                      action: {
                        data: {
                          args: "https://app.adjust.com/167k4ih?campaign=firefox-desktop&adgroup=pb&creative=focus-omc172&redirect=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dorg.mozilla.focus",
                          where: "tabshifted",
                        },
                        type: "OPEN_URL",
                        navigate: true,
                      },
                    },
                    tiles: {
                      type: "mobile_downloads",
                      data: {
                        QR_code: {
                          image_url:
                            "chrome://browser/content/assets/focus-qr-code.svg",
                          alt_text: {
                            string_id: "spotlight-focus-promo-qr-code",
                          },
                        },
                        marketplace_buttons: ["ios", "android"],
                      },
                    },
                  },
                },
              ],
            },
          },
        },
      },
    },
    priority: 2,
    frequency: {
      custom: [
        {
          cap: 3,
          period: 604800000, // Max 3 per week
        },
      ],
      lifetime: 12,
    },
    // Exclude the next 2 messages: 1) Klar for en 2) Klar for de
    targeting:
      "!(region in [ 'DE', 'AT', 'CH'] && localeLanguageCode == 'en') && localeLanguageCode != 'de'",
  },
  {
    id: "PB_NEWTAB_KLAR_PROMO",
    type: "default",
    template: "pb_newtab",
    groups: ["pbNewtab"],
    content: {
      infoBody: "fluent:about-private-browsing-info-description-simplified",
      infoEnabled: true,
      infoIcon: "chrome://global/skin/icons/indicator-private-browsing.svg",
      infoLinkText: "fluent:about-private-browsing-learn-more-link",
      infoTitle: "",
      infoTitleEnabled: false,
      promoEnabled: true,
      promoType: "FOCUS",
      promoHeader: "fluent:about-private-browsing-focus-promo-header-c",
      promoImageLarge: "chrome://browser/content/assets/focus-promo.png",
      promoLinkText: "Download Firefox Klar",
      promoLinkType: "button",
      promoSectionStyle: "below-search",
      promoTitle:
        "Firefox Klar clears your history every time while blocking ads and trackers.",
      promoTitleEnabled: true,
      promoButton: {
        action: {
          type: "SHOW_SPOTLIGHT",
          data: {
            content: {
              id: "KLAR_PROMO",
              template: "multistage",
              modal: "tab",
              backdrop: "transparent",
              screens: [
                {
                  id: "DEFAULT_MODAL_UI",
                  order: 0,
                  content: {
                    logo: {
                      imageURL:
                        "chrome://browser/content/assets/focus-logo.svg",
                      height: "48px",
                    },
                    title: "Get Firefox Klar",
                    subtitle: {
                      string_id: "spotlight-focus-promo-subtitle",
                    },
                    dismiss_button: {
                      action: {
                        navigate: true,
                      },
                    },
                    ios: {
                      action: {
                        data: {
                          args: "https://app.adjust.com/a8bxj8j?campaign=firefox-desktop&adgroup=pb&creative=focus-omc172&redirect=https%3A%2F%2Fapps.apple.com%2Fde%2Fapp%2Fklar-by-firefox%2Fid1073435754",
                          where: "tabshifted",
                        },
                        type: "OPEN_URL",
                        navigate: true,
                      },
                    },
                    android: {
                      action: {
                        data: {
                          args: "https://app.adjust.com/a8bxj8j?campaign=firefox-desktop&adgroup=pb&creative=focus-omc172&redirect=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dorg.mozilla.klar",
                          where: "tabshifted",
                        },
                        type: "OPEN_URL",
                        navigate: true,
                      },
                    },
                    tiles: {
                      type: "mobile_downloads",
                      data: {
                        QR_code: {
                          image_url:
                            "chrome://browser/content/assets/klar-qr-code.svg",
                          alt_text: "Scan the QR code to get Firefox Klar",
                        },
                        marketplace_buttons: ["ios", "android"],
                      },
                    },
                  },
                },
              ],
            },
          },
        },
      },
    },
    priority: 2,
    frequency: {
      custom: [
        {
          cap: 3,
          period: 604800000, // Max 3 per week
        },
      ],
      lifetime: 12,
    },
    targeting: "region in [ 'DE', 'AT', 'CH'] && localeLanguageCode == 'en'",
  },
  {
    id: "PB_NEWTAB_KLAR_PROMO_DE",
    type: "default",
    template: "pb_newtab",
    groups: ["pbNewtab"],
    content: {
      infoBody: "fluent:about-private-browsing-info-description-simplified",
      infoEnabled: true,
      infoIcon: "chrome://global/skin/icons/indicator-private-browsing.svg",
      infoLinkText: "fluent:about-private-browsing-learn-more-link",
      infoTitle: "",
      infoTitleEnabled: false,
      promoEnabled: true,
      promoType: "FOCUS",
      promoHeader: "fluent:about-private-browsing-focus-promo-header-c",
      promoImageLarge: "chrome://browser/content/assets/focus-promo.png",
      promoLinkText: "fluent:about-private-browsing-focus-promo-cta",
      promoLinkType: "button",
      promoSectionStyle: "below-search",
      promoTitle: "fluent:about-private-browsing-focus-promo-text-c",
      promoTitleEnabled: true,
      promoButton: {
        action: {
          type: "SHOW_SPOTLIGHT",
          data: {
            content: {
              id: "FOCUS_PROMO",
              template: "multistage",
              modal: "tab",
              backdrop: "transparent",
              screens: [
                {
                  id: "DEFAULT_MODAL_UI",
                  content: {
                    logo: {
                      imageURL:
                        "chrome://browser/content/assets/focus-logo.svg",
                      height: "48px",
                    },
                    title: {
                      string_id: "spotlight-focus-promo-title",
                    },
                    subtitle: {
                      string_id: "spotlight-focus-promo-subtitle",
                    },
                    dismiss_button: {
                      action: {
                        navigate: true,
                      },
                    },
                    ios: {
                      action: {
                        data: {
                          args: "https://app.adjust.com/a8bxj8j?campaign=firefox-desktop&adgroup=pb&creative=focus-omc172&redirect=https%3A%2F%2Fapps.apple.com%2Fde%2Fapp%2Fklar-by-firefox%2Fid1073435754",
                          where: "tabshifted",
                        },
                        type: "OPEN_URL",
                        navigate: true,
                      },
                    },
                    android: {
                      action: {
                        data: {
                          args: "https://app.adjust.com/a8bxj8j?campaign=firefox-desktop&adgroup=pb&creative=focus-omc172&redirect=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dorg.mozilla.klar",
                          where: "tabshifted",
                        },
                        type: "OPEN_URL",
                        navigate: true,
                      },
                    },
                    tiles: {
                      type: "mobile_downloads",
                      data: {
                        QR_code: {
                          image_url:
                            "chrome://browser/content/assets/klar-qr-code.svg",
                          alt_text: {
                            string_id: "spotlight-focus-promo-qr-code",
                          },
                        },
                        marketplace_buttons: ["ios", "android"],
                      },
                    },
                  },
                },
              ],
            },
          },
        },
      },
    },
    priority: 2,
    frequency: {
      custom: [
        {
          cap: 3,
          period: 604800000, // Max 3 per week
        },
      ],
      lifetime: 12,
    },
    targeting: "localeLanguageCode == 'de'",
  },
  {
    id: "PB_NEWTAB_INFO_SECTION",
    template: "pb_newtab",
    content: {
      promoEnabled: false,
      infoEnabled: true,
      infoIcon: "",
      infoTitle: "",
      infoBody: "fluent:about-private-browsing-info-description-private-window",
      infoLinkText: "fluent:about-private-browsing-learn-more-link",
      infoTitleEnabled: false,
    },
    targeting: "true",
  },
  {
    id: "PB_NEWTAB_PIN_PROMO",
    template: "pb_newtab",
    type: "default",
    groups: ["pbNewtab"],
    content: {
      infoBody: "fluent:about-private-browsing-info-description-simplified",
      infoEnabled: true,
      infoIcon: "chrome://global/skin/icons/indicator-private-browsing.svg",
      infoLinkText: "fluent:about-private-browsing-learn-more-link",
      infoTitle: "",
      infoTitleEnabled: false,
      promoEnabled: true,
      promoType: "PIN",
      promoHeader: "fluent:about-private-browsing-pin-promo-header",
      promoImageLarge:
        "chrome://browser/content/assets/private-promo-asset.svg",
      promoLinkText: "fluent:about-private-browsing-pin-promo-link-text",
      promoLinkType: "button",
      promoSectionStyle: "below-search",
      promoTitle: "fluent:about-private-browsing-pin-promo-title",
      promoTitleEnabled: true,
      promoButton: {
        action: {
          type: "MULTI_ACTION",
          data: {
            actions: [
              {
                type: "SET_PREF",
                data: {
                  pref: {
                    name: "browser.privateWindowSeparation.enabled",
                    value: true,
                  },
                },
              },
              {
                type: "PIN_FIREFOX_TO_TASKBAR",
                data: {
                  privatePin: true,
                },
              },
              {
                type: "BLOCK_MESSAGE",
                data: {
                  id: "PB_NEWTAB_PIN_PROMO",
                },
              },
              {
                type: "OPEN_ABOUT_PAGE",
                data: { args: "privatebrowsing", where: "current" },
              },
            ],
          },
        },
      },
    },
    priority: 3,
    frequency: {
      custom: [
        {
          cap: 3,
          period: 604800000, // Max 3 per week
        },
      ],
      lifetime: 12,
    },
    targeting: "!inMr2022Holdback && doesAppNeedPrivatePin",
  },
  {
    id: "PB_NEWTAB_COOKIE_BANNERS_PROMO",
    template: "pb_newtab",
    type: "default",
    groups: ["pbNewtab"],
    content: {
      infoBody: "fluent:about-private-browsing-info-description-simplified",
      infoEnabled: true,
      infoIcon: "chrome://global/skin/icons/indicator-private-browsing.svg",
      infoLinkText: "fluent:about-private-browsing-learn-more-link",
      infoTitle: "",
      infoTitleEnabled: false,
      promoEnabled: true,
      promoType: "COOKIE_BANNERS",
      promoHeader: "fluent:about-private-browsing-cookie-banners-promo-header",
      promoImageLarge:
        "chrome://browser/content/assets/cookie-banners-begone.svg",
      promoLinkText:
        "fluent:about-private-browsing-cookie-banners-promo-button",
      promoLinkType: "button",
      promoSectionStyle: "below-search",
      promoTitle: "fluent:about-private-browsing-cookie-banners-promo-message",
      promoTitleEnabled: true,
      promoButton: {
        action: {
          type: "MULTI_ACTION",
          data: {
            actions: [
              {
                type: "SET_PREF",
                data: {
                  pref: {
                    name: "cookiebanners.service.mode",
                    value: Ci.nsICookieBannerService.MODE_REJECT,
                  },
                },
              },
              {
                // This pref may be removed (with the normal pref controlling
                // both modes), at which time we should remove this action.
                type: "SET_PREF",
                data: {
                  pref: {
                    name: "cookiebanners.service.mode.privateBrowsing",
                    value: Ci.nsICookieBannerService.MODE_REJECT,
                  },
                },
              },
              {
                // Reset this pref to default
                type: "SET_PREF",
                data: {
                  pref: {
                    name: "cookiebanners.service.detectOnly",
                  },
                },
              },
              {
                type: "BLOCK_MESSAGE",
                data: {
                  id: "PB_NEWTAB_COOKIE_BANNERS_PROMO",
                },
              },
              {
                type: "OPEN_ABOUT_PAGE",
                data: { args: "privatebrowsing", where: "current" },
              },
            ],
          },
        },
      },
    },
    priority: 4,
    frequency: {
      custom: [
        {
          cap: 3,
          period: 604800000, // Max 3 per week
        },
      ],
      lifetime: 12,
    },
    targeting: `!'cookiebanners.service.mode'|preferenceIsUserSet`,
  },
  {
    id: "CFR_COOKIEBANNER",
    groups: ["cfr"],
    template: "cfr_doorhanger",
    content: {
      bucket_id: "CFR_COOKIEBANNER",
      anchor_id: "tracking-protection-icon-container",
      layout: "icon_and_message",
      icon: "chrome://browser/skin/controlcenter/3rdpartycookies.svg",
      icon_class: "cfr-doorhanger-small-icon",
      persistent_doorhanger: true,
      show_in_private_browsing: true,
      heading_text: {
        string_id: "cfr-cbh-header",
      },
      text: {
        string_id: "cfr-cbh-body",
      },
      buttons: {
        primary: {
          label: {
            string_id: "cfr-cbh-confirm-button",
          },
          action: {
            type: "MULTI_ACTION",
            data: {
              actions: [
                {
                  type: "SET_PREF",
                  data: {
                    pref: {
                      name: "cookiebanners.service.mode",
                      value: 1,
                    },
                  },
                },
                {
                  type: "SET_PREF",
                  data: {
                    pref: {
                      name: "cookiebanners.service.mode.privateBrowsing",
                      value: 1,
                    },
                  },
                },
                {
                  type: "SET_PREF",
                  data: {
                    pref: {
                      name: "cookiebanners.service.detectOnly",
                      value: false,
                    },
                  },
                },
                {
                  type: "RELOAD_BROWSER",
                },
              ],
            },
          },
        },
        secondary: [
          {
            label: {
              string_id: "cfr-cbh-dismiss-button",
            },
            action: {
              type: "CANCEL",
            },
          },
        ],
      },
      skip_address_bar_notifier: true,
    },
    frequency: {
      custom: [{ period: 24 * 60 * 60 * 1000 * 2, cap: 1 }],
      lifetime: 2,
    },
    trigger: {
      id: "cookieBannerDetected",
    },
    targeting: `'cookiebanners.ui.desktop.enabled'|preferenceValue == true && 'cookiebanners.service.detectOnly'|preferenceValue == true`,
  },
];

// Eventually, move Feature Callout messages to their own provider
const ONBOARDING_MESSAGES = () =>
  BASE_MESSAGES().concat(FeatureCalloutMessages.getMessages());

const OnboardingMessageProvider = {
  async getExtraAttributes() {
    const [header, button_label] = await L10N.formatMessages([
      { id: "onboarding-welcome-header" },
      { id: "onboarding-start-browsing-button-label" },
    ]);
    return { header: header.value, button_label: button_label.value };
  },
  async getMessages() {
    const messages = await this.translateMessages(await ONBOARDING_MESSAGES());
    return messages;
  },
  async getUntranslatedMessages() {
    // This is helpful for jsonSchema testing - since we are localizing in the provider
    const messages = await ONBOARDING_MESSAGES();
    return messages;
  },
  async translateMessages(messages) {
    let translatedMessages = [];
    for (const msg of messages) {
      let translatedMessage = { ...msg };

      // If the message has no content, do not attempt to translate it
      if (!translatedMessage.content) {
        translatedMessages.push(translatedMessage);
        continue;
      }

      // Translate any secondary buttons separately
      if (msg.content.secondary_button) {
        const [secondary_button_string] = await L10N.formatMessages([
          { id: msg.content.secondary_button.label.string_id },
        ]);
        translatedMessage.content.secondary_button.label =
          secondary_button_string.value;
      }
      if (msg.content.header) {
        const [header_string] = await L10N.formatMessages([
          { id: msg.content.header.string_id },
        ]);
        translatedMessage.content.header = header_string.value;
      }
      translatedMessages.push(translatedMessage);
    }
    return translatedMessages;
  },
  async _doesAppNeedPin(privateBrowsing = false) {
    const needPin = await lazy.ShellService.doesAppNeedPin(privateBrowsing);
    return needPin;
  },
  async _doesAppNeedDefault() {
    let checkDefault = Services.prefs.getBoolPref(
      "browser.shell.checkDefaultBrowser",
      false
    );
    let isDefault = await lazy.ShellService.isDefaultBrowser();
    return checkDefault && !isDefault;
  },
  _shouldShowPrivacySegmentationScreen() {
    // Fall back to pref: browser.privacySegmentation.preferences.show
    return lazy.NimbusFeatures.majorRelease2022.getVariable(
      "feltPrivacyShowPreferencesSection"
    );
  },
  _doesHomepageNeedReset() {
    return (
      Services.prefs.prefHasUserValue(HOMEPAGE_PREF) ||
      Services.prefs.prefHasUserValue(NEWTAB_PREF)
    );
  },

  async getUpgradeMessage() {
    let message = (await OnboardingMessageProvider.getMessages()).find(
      ({ id }) => id === "FX_MR_106_UPGRADE"
    );

    let { content } = message;
    // Helper to find screens and remove them where applicable.
    function removeScreens(check) {
      const { screens } = content;
      for (let i = 0; i < screens?.length; i++) {
        if (check(screens[i])) {
          screens.splice(i--, 1);
        }
      }
    }

    // Helper to prepare mobile download screen content
    function prepareMobileDownload() {
      let mobileContent = content.screens.find(
        screen => screen.id === "UPGRADE_MOBILE_DOWNLOAD"
      )?.content;

      if (!mobileContent) {
        return;
      }
      if (!lazy.BrowserUtils.sendToDeviceEmailsSupported()) {
        // If send to device emails are not supported for a user's locale,
        // remove the send to device link and update the screen text
        delete mobileContent.cta_paragraph.action;
        mobileContent.cta_paragraph.text = {
          string_id: "mr2022-onboarding-no-mobile-download-cta-text",
        };
      }
      // Update CN specific QRCode url
      if (AppConstants.isChinaRepack()) {
        mobileContent.hero_image.url = `${mobileContent.hero_image.url.slice(
          0,
          mobileContent.hero_image.url.indexOf(".svg")
        )}-cn.svg`;
      }
    }

    let pinScreen = content.screens?.find(
      screen => screen.id === "UPGRADE_PIN_FIREFOX"
    );
    const needPin = await this._doesAppNeedPin();
    const needDefault = await this._doesAppNeedDefault();
    const needPrivatePin =
      !lazy.hidePrivatePin && (await this._doesAppNeedPin(true));
    const showSegmentation = this._shouldShowPrivacySegmentationScreen();

    //If a user has Firefox as default remove import screen
    if (!needDefault) {
      removeScreens(screen => screen.id?.startsWith("UPGRADE_IMPORT_SETTINGS"));
    }

    // If already pinned, convert "pin" screen to "welcome" with desired action.
    let removeDefault = !needDefault;
    // If user doesn't need pin, update screen to set "default" or "get started" configuration
    if (!needPin && pinScreen) {
      // don't need to show the checkbox
      delete pinScreen.content.checkbox;

      removeDefault = true;
      let primary = pinScreen.content.primary_button;
      if (needDefault) {
        pinScreen.id = "UPGRADE_ONLY_DEFAULT";
        pinScreen.content.subtitle = {
          string_id: "mr2022-onboarding-existing-set-default-only-subtitle",
        };
        primary.label.string_id =
          "mr2022-onboarding-set-default-primary-button-label";

        // The "pin" screen will now handle "default" so remove other "default."
        primary.action.type = "SET_DEFAULT_BROWSER";
      } else {
        pinScreen.id = "UPGRADE_GET_STARTED";
        pinScreen.content.subtitle = {
          string_id: "mr2022-onboarding-get-started-primary-subtitle",
        };
        primary.label = {
          string_id: "mr2022-onboarding-get-started-primary-button-label",
        };
        delete primary.action.type;
      }
    }

    // If a user has Firefox private pinned remove pin private window screen
    // We also remove standalone pin private window screen if a user doesn't have
    // Firefox pinned in which case the option is shown as checkbox with UPGRADE_PIN_FIREFOX screen
    if (!needPrivatePin || needPin) {
      removeScreens(screen =>
        screen.id?.startsWith("UPGRADE_PIN_PRIVATE_WINDOW")
      );
    }

    if (!showSegmentation) {
      removeScreens(screen =>
        screen.id?.startsWith("UPGRADE_DATA_RECOMMENDATION")
      );
    }

    //If privatePin, remove checkbox from pinscreen
    if (!needPrivatePin) {
      delete content.screens?.find(
        screen => screen.id === "UPGRADE_PIN_FIREFOX"
      )?.content?.checkbox;
    }

    if (removeDefault) {
      removeScreens(screen => screen.id?.startsWith("UPGRADE_SET_DEFAULT"));
    }

    // Remove mobile download screen if user has sync enabled
    if (lazy.usesFirefoxSync && lazy.mobileDevices > 0) {
      removeScreens(screen => screen.id === "UPGRADE_MOBILE_DOWNLOAD");
    } else {
      removeScreens(screen => screen.id === "UPGRADE_MOBILE_DOWNLOAD");
    }

    // Remove screens we don't want to show
    removeScreens(screen => screen.id === "PB_NEWTAB_FOCUS_PROMO");
    removeScreens(screen => screen.id === "PB_NEWTAB_KLAR_PROMO");
    removeScreens(screen => screen.id === "PB_NEWTAB_KLAR_PROMO_DE");

    return message;
  },
};

const EXPORTED_SYMBOLS = ["OnboardingMessageProvider"];
