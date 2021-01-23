/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// This file contains branding-specific prefs.

pref("startup.homepage_override_url", "https://www.waterfox.net/blog/waterfox-%DISPLAY_VERSION%/?update");
pref("startup.homepage_welcome_url", "about:welcome");
pref("startup.homepage_welcome_url.additional", "https://www.waterfox.net/blog/waterfox-%DISPLAY_VERSION%/?new");
// The time interval between checks for a new version (in seconds)
pref("app.update.interval", 28800); // 8 hours
// Give the user x seconds to react before showing the big UI. default=192 hours
pref("app.update.promptWaitTime", 691200);
// URL user can browse to manually if for some reason all update installation
// attempts fail.
pref("app.update.url.manual", "https://www.waterfox.net/downloads/");
// A default value for the "More information about this update" link
// supplied in the "An update is available" page of the update wizard.
pref("app.update.url.details", "https://www.waterfox.net/downloads/");

pref("app.releaseNotesURL", "https://www.waterfox.net/blog/waterfox-%DISPLAY_VERSION%/");

// The number of days a binary is permitted to be old
// without checking for an update.  This assumes that
// app.update.checkInstallTime is true.
pref("app.update.checkInstallTime.days", 2);

// Give the user x seconds to reboot before showing a badge on the hamburger
// button. default=4 days
pref("app.update.badgeWaitTime", 345600);

// Number of usages of the web console.
// If this is less than 5, then pasting code into the web console is disabled
pref("devtools.selfxss.count", 5);
