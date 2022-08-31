# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = System Integration

system-integration-dialog =
    .buttonlabelaccept = Set as Default
    .buttonlabelcancel = Skip Integration
    .buttonlabelcancel2 = Cancel

default-client-intro = Use { -brand-short-name } as the default client for:

unset-default-tooltip = It is not possible to unset { -brand-short-name } as the default client within { -brand-short-name }. To make another application the default you must use its 'Set as default' dialog.

checkbox-email-label =
    .label = Email
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Newsgroups
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Feeds
    .tooltiptext = { unset-default-tooltip }

checkbox-calendar-label =
    .label = Calendar
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

system-search-integration-label =
    .label = Allow { system-search-engine-name } to search messages
    .accesskey = S

check-on-startup-label =
    .label = Always perform this check when starting { -brand-short-name }
    .accesskey = A
