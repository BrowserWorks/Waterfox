# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Systemintegration

system-integration-dialog =
    .buttonlabelaccept = Als Standard festlegen
    .buttonlabelcancel = Integration überspringen
    .buttonlabelcancel2 = Abbrechen

default-client-intro = { -brand-short-name } als Standard-Anwendung verwenden für:

unset-default-tooltip = Die Festlegung { -brand-short-name } als Standard-Anwendung zu verwenden, kann nicht innerhalb { -brand-short-name }s aufgehoben werden. Um eine andere Anwendung als Standard festzulegen, muss deren 'Als Standard festlegen'-Einstellung verwendet werden.

checkbox-email-label =
    .label = E-Mail
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Newsgruppen
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Feeds
    .tooltiptext = { unset-default-tooltip }

checkbox-calendar-label =
    .label = Kalender
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows-Suche
       *[other] { "" }
    }

system-search-integration-label =
    .label = { system-search-engine-name } ermöglichen, Nachrichten zu durchsuchen
    .accesskey = S

check-on-startup-label =
    .label = Bei jedem Start von { -brand-short-name } überprüfen
    .accesskey = B
