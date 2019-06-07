/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global pref */

pref("datareporting.policy.dataSubmissionEnabled", false, locked);
pref("datareporting.policy.dataSubmissionPolicyNotifiedTime", "0");
pref("datareporting.policy.dataSubmissionPolicyAcceptedVersion", 0);
pref("datareporting.policy.dataSubmissionPolicyBypassNotification", true, locked);
pref("datareporting.policy.currentPolicyVersion", 2);
pref("datareporting.policy.minimumPolicyVersion", 1);
pref("datareporting.policy.minimumPolicyVersion.channel-beta", 2);
pref("datareporting.policy.firstRunURL", "https://www.waterfox.net/privacy/");
