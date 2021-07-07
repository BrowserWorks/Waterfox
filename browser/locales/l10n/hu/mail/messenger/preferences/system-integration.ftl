# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integrálódás a rendszerbe
system-integration-dialog =
    .buttonlabelaccept = Legyen ez az alapértelmezett
    .buttonlabelcancel = Integráció kihagyása
    .buttonlabelcancel2 = Mégse
default-client-intro = A { -brand-short-name } beállítása alapértelmezett kliensként:
unset-default-tooltip = Nem lehet a { -brand-short-name }ból törölni a { -brand-short-name } beállítását alapértelmezett kliensként. Másik alkalmazás alapértelmezetté tételéhez használja annak „Beállítás alapértelmezettként” ablakát.
checkbox-email-label =
    .label = Levelezés
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Hírcsoportok
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Hírforrások
    .tooltiptext = { unset-default-tooltip }
checkbox-calendar-label =
    .label = Naptár
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
    .label = A(z) { system-search-engine-name } kereshet az üzenetek között
    .accesskey = s
check-on-startup-label =
    .label = Ellenőrzés elvégzése a { -brand-short-name } minden indításakor
    .accesskey = E
