# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = { -brand-short-name } Probleemoplossingsmodus
    .style = width: 37em;

troubleshoot-mode-description = Gebruik de { -brand-short-name }-probleemoplossingsmodus om problemen te analyseren. Uw add-ons en aanpassingen worden tijdelijk uitgeschakeld.

troubleshoot-mode-description2 = U kunt alle of enkele van deze wijzigingen permanent maken:

troubleshoot-mode-disable-addons =
    .label = Alle add-ons uitschakelen
    .accesskey = u

troubleshoot-mode-reset-toolbars =
    .label = Werkbalken en bedieningselementen herinitialiseren
    .accesskey = h

troubleshoot-mode-change-and-restart =
    .label = Wijzigingen doorvoeren en herstarten
    .accesskey = d

troubleshoot-mode-continue =
    .label = Doorgaan in probleemoplossingsmodus
    .accesskey = D

troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] Afsluiten
           *[other] Afsluiten
        }
    .accesskey =
        { PLATFORM() ->
            [windows] s
           *[other] s
        }
