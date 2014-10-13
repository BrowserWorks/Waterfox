/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// Whether or not app updates are enabled
pref("app.update.enabled", true);

// This preference turns on app.update.mode and allows automatic download and
// install to take place. We use a separate boolean toggle for this to make
// the UI easier to construct.
pref("app.update.auto", true);

// Defines how the Application Update Service notifies the user about updates:
//
// AUM Set to:        Minor Releases:     Major Releases:
// 0                  download no prompt  download no prompt
// 1                  download no prompt  download no prompt if no incompatibilities
// 2                  download no prompt  prompt
//
// See chart in nsUpdateService.js.in for more details
//
pref("app.update.mode", 1);

// If set to true, the Update Service will present no UI for any event.
pref("app.update.silent", false);

// Update service URL:
// You do not need to use all the %VAR% parameters. Use what you need, %PRODUCT%,%VERSION%,%BUILD_ID%,%CHANNEL% for example
pref("app.update.url", "https://www.waterfoxproject.org/update/osx64/%VERSION%/%LOCALE%/%CHANNEL%/update.xml");

// URL user can browse to manually if for some reason all update installation
// attempts fail.
pref("app.update.url.manual", "https://www.waterfoxproject.org/");

// A default value for the "More information about this update" link
// supplied in the "An update is available" page of the update wizard.
pref("app.update.url.details", "https://www.waterfoxproject.org/development.php");

// Interval: Time between checks for a new version (in seconds)
//           default=12 hours
pref("app.update.interval", 43200);

// The time interval between the downloading of mar file chunks in the
// background (in seconds)
pref("app.update.download.backgroundInterval", 60);

// Give the user x seconds to react before showing the big UI. default=48 hours
pref("app.update.promptWaitTime", 172800);

// Whether or not we show a dialog box informing the user that the update was
// successfully applied. This is off in Firefox by default since we show a
// upgrade start page instead! Other apps may wish to show this UI, and supply
// a whatsNewURL field in their brand.properties that contains a link to a page
// which tells users what's new in this new update.
pref("app.update.showInstalledUI", false);

// 0 = suppress prompting for incompatibilities if there are updates available
//     to newer versions of installed addons that resolve them.
// 1 = suppress prompting for incompatibilities only if there are VersionInfo
//     updates available to installed addons that resolve them, not newer
//     versions.
pref("app.update.incompatible.mode", 0);


// Search codes belong only in builds with official branding
pref("browser.search.param.yahoo-fr", "");
pref("browser.search.param.yahoo-fr-cjkt", ""); // now unused
pref("browser.search.param.yahoo-fr-ja", "");
pref("browser.search.param.yahoo-f-CN", "");

//Set compatibility with Firefox add-ons and extensions!
pref("general.useragent.compatMode.firefox", true);

pref("media.mediasource.enabled", true);
pref("browser.aboutHomeSnippets.updateUrl", "");
