# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = පද්ධති ඒකාබද්ධ කිරීම

system-integration-dialog =
    .buttonlabelaccept = Set as Default
    .buttonlabelcancel = Skip Integration
    .buttonlabelcancel2 = Cancel

default-client-intro = { -brand-short-name } පෙරනිමි සේවාග්‍රාහකය ලෙස භාවිතා කරන්න:

unset-default-tooltip = It is not possible to unset { -brand-short-name } as the default client within { -brand-short-name }. To make another application the default you must use its 'Set as default' dialog.

checkbox-email-label =
    .label = වි.තැපැල්
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = පුවත්සමූහ
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = පෝෂක
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] වින්ඩෝස් සෙවුම
       *[other] { "" }
    }

system-search-integration-label =
    .label = { system-search-engine-name } ට ලිපි සෙවීමට ඉඩදෙන්න
    .accesskey = S

check-on-startup-label =
    .label = { -brand-short-name } අරඹන විට මෙම පරීක්ෂාව කරන්න
    .accesskey = A
