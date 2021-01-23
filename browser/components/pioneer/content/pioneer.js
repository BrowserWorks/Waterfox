/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * MVP UI for Pioneer v2
 *
 * This is an experimental MVP for the Pioneer v2 project. It supports a
 * single study add-on, and the only entry point is the `about:pioneer` page.
 *
 * The purpose of this page is to demonstrate a fully-working Pioneer study
 * data collection pipeline, and also to potentially advertise to real users
 * in order to observe enrollment behavior.
 *
 * Results from the above will inform the next version of Pioneer UI.
 */

const { AddonManager } = ChromeUtils.import(
  "resource://gre/modules/AddonManager.jsm"
);
const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);

ChromeUtils.defineModuleGetter(
  this,
  "AddonRepository",
  "resource://gre/modules/addons/AddonRepository.jsm"
);

XPCOMUtils.defineLazyModuleGetters(this, {
  FileUtils: "resource://gre/modules/FileUtils.jsm",
});

const PREF_PIONEER_ID = "toolkit.telemetry.pioneerId";

// For the pilot program (Fx78), only allow a single add-on ID.
const STUDY_ADDON_WHITELIST = ["pioneer-v2-example@mozilla.org"];

function showEnrollmentStatus() {
  const pioneerId = Services.prefs.getStringPref(PREF_PIONEER_ID, null);

  const enrollmentButton = document.getElementById("enrollment-button");

  document.l10n.setAttributes(
    enrollmentButton,
    `pioneer-${pioneerId ? "un" : ""}enrollment-button`
  );
  enrollmentButton.classList.toggle("primary", !pioneerId);
}

async function showAvailableStudies(cachedAddons) {
  for (const cachedAddon of cachedAddons) {
    if (!cachedAddon) {
      console.error(
        `about:pioneer - Study addon ID not found in AMO cache: ${studyAddonId}`
      );
      return;
    }

    const studyAddonId = cachedAddon.id;

    const study = document.createElement("div");
    study.setAttribute("id", studyAddonId);
    study.setAttribute("class", "card card-no-hover");

    if (cachedAddon.icons && 32 in cachedAddon.icons) {
      const iconName = document.createElement("img");
      iconName.setAttribute("class", "card-icon");
      iconName.setAttribute("src", cachedAddon.icons[32]);
      study.appendChild(iconName);
    }

    const studyBody = document.createElement("div");
    studyBody.classList.add("card-body");
    study.appendChild(studyBody);

    const studyName = document.createElement("h3");
    studyName.setAttribute("class", "card-name");
    studyName.textContent = cachedAddon.name;
    studyBody.appendChild(studyName);

    const studyCreator = document.createElement("span");
    studyCreator.setAttribute("class", "card-creator");
    studyCreator.textContent = cachedAddon.creator;
    studyBody.appendChild(studyCreator);

    const actions = document.createElement("div");
    actions.classList.add("card-actions");
    study.appendChild(actions);

    const joinBtn = document.createElement("button");
    joinBtn.setAttribute("id", `${studyAddonId}-join-button`);
    joinBtn.classList.add("primary");
    joinBtn.classList.add("join-button");
    document.l10n.setAttributes(joinBtn, "pioneer-join-study");
    actions.appendChild(joinBtn);

    const enrollStudyBtn = document.createElement("input");
    enrollStudyBtn.setAttribute("id", `${studyAddonId}-toggle-button`);
    enrollStudyBtn.setAttribute("class", "toggle-button");
    enrollStudyBtn.setAttribute("type", "checkbox");
    actions.appendChild(enrollStudyBtn);

    const studyDesc = document.createElement("div");
    studyDesc.setAttribute("class", "card-description");
    study.appendChild(studyDesc);

    const shortDesc = document.createElement("p");
    shortDesc.textContent = cachedAddon.description;
    studyDesc.appendChild(shortDesc);

    const fullDesc = document.createElement("p");
    fullDesc.textContent = cachedAddon.fullDescription;
    studyDesc.appendChild(fullDesc);

    async function toggleEnrolled() {
      let addon;
      let install;

      if (Cu.isInAutomation) {
        if (
          Services.prefs.getBoolPref(
            "toolkit.pioneer.testAddonInstalled",
            false
          )
        ) {
          addon = { uninstall() {} };
        }

        install = { install() {} };
      } else {
        addon = await AddonManager.getAddonByID(studyAddonId);
        install = await AddonManager.getInstallForURL(
          cachedAddon.sourceURI.spec
        );
      }

      if (addon) {
        await addon.uninstall();
      } else {
        joinBtn.disabled = true;
        await install.install();
      }
      updateStudy(studyAddonId);
    }

    enrollStudyBtn.addEventListener("input", toggleEnrolled);
    joinBtn.addEventListener("click", toggleEnrolled);

    const availableStudies = document.getElementById("available-studies");
    availableStudies.appendChild(study);

    updateStudy(studyAddonId);
  }

  const availableStudies = document.getElementById("header-available-studies");
  document.l10n.setAttributes(availableStudies, "pioneer-available-studies");
}

async function updateStudy(studyAddonId) {
  let addon;
  if (Cu.isInAutomation) {
    if (
      Services.prefs.getBoolPref("toolkit.pioneer.testAddonInstalled", false)
    ) {
      addon = { uninstall() {} };
    }
  } else {
    addon = await AddonManager.getAddonByID(studyAddonId);
  }

  const study = document.querySelector(`.card[id="${studyAddonId}"`);

  const enrollStudyBtn = study.querySelector(".toggle-button");
  const joinBtn = study.querySelector(".join-button");

  const pioneerId = Services.prefs.getStringPref(PREF_PIONEER_ID, null);

  if (pioneerId) {
    study.style.opacity = 1;

    enrollStudyBtn.disabled = false;
    enrollStudyBtn.checked = !!addon;

    joinBtn.disabled = false;
    joinBtn.hidden = !!addon;
  } else {
    study.style.opacity = 0.5;

    enrollStudyBtn.disabled = true;
    enrollStudyBtn.checked = false;

    joinBtn.disabled = true;
    joinBtn.hidden = false;
  }
}

// equivalent to what we use for Telemetry IDs
// https://searchfox.org/mozilla-central/rev/9193635dca8cfdcb68f114306194ffc860456044/toolkit/components/telemetry/app/TelemetryUtils.jsm#222
function generateUUID() {
  let str = Cc["@mozilla.org/uuid-generator;1"]
    .getService(Ci.nsIUUIDGenerator)
    .generateUUID()
    .toString();
  return str.substring(1, str.length - 1);
}

function setup() {
  document
    .getElementById("enrollment-button")
    .addEventListener("click", async event => {
      const pioneerId = Services.prefs.getStringPref(PREF_PIONEER_ID, null);

      if (pioneerId) {
        Services.prefs.clearUserPref(PREF_PIONEER_ID);

        for (const studyAddonId of STUDY_ADDON_WHITELIST) {
          const study = document.getElementById(studyAddonId);
          if (study) {
            const addon = await AddonManager.getAddonByID(studyAddonId);
            if (addon) {
              await addon.uninstall();
            }
            updateStudy(studyAddonId);
          }
        }
      } else {
        let uuid = generateUUID();
        Services.prefs.setStringPref(PREF_PIONEER_ID, uuid);

        for (const studyAddonId of STUDY_ADDON_WHITELIST) {
          const study = document.getElementById(studyAddonId);
          if (study) {
            updateStudy(studyAddonId);
          }
        }
      }
      await showEnrollmentStatus();
    });

  const onAddonEvent = addon => {
    if (STUDY_ADDON_WHITELIST.includes(addon.id)) {
      updateStudy(addon.id);
    }
  };
  const addonsListener = {
    onEnabled: onAddonEvent,
    onDisabled: onAddonEvent,
    onInstalled: onAddonEvent,
    onUninstalled: onAddonEvent,
  };
  AddonManager.addAddonListener(addonsListener);

  window.addEventListener("unload", event => {
    AddonManager.removeAddonListener(addonsListener);
  });
}

document.addEventListener("DOMContentLoaded", async domEvent => {
  setup();
  showEnrollmentStatus();

  let cachedAddons;
  if (Cu.isInAutomation) {
    let testCachedAddons = Services.prefs.getStringPref(
      "toolkit.pioneer.testCachedAddons",
      null
    );
    if (testCachedAddons) {
      cachedAddons = JSON.parse(testCachedAddons);
    }
  } else {
    cachedAddons = await AddonRepository.cacheAddons(STUDY_ADDON_WHITELIST);
  }

  showAvailableStudies(cachedAddons);
});
