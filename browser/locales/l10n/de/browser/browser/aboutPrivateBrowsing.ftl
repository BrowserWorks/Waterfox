# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Neues privates Fenster öffnen
    .accesskey = F
about-private-browsing-search-placeholder = Das Web durchsuchen
about-private-browsing-info-title = Dies ist ein privates Fenster
about-private-browsing-info-myths = Häufige Missverständnisse über das Surfen im Privaten Modus
about-private-browsing =
    .title = Das Web durchsuchen
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Mit { $engine } suchen oder Adresse eingeben
about-private-browsing-handoff-no-engine =
    .title = Suche oder Adresse eingeben
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Mit { $engine } suchen oder Adresse eingeben
about-private-browsing-handoff-text-no-engine = Suche oder Adresse eingeben
about-private-browsing-not-private = Sie befinden sich derzeit nicht in einem privaten Fenster.
about-private-browsing-info-description = { -brand-short-name } leert die eingegebenen Suchbegriffe und besuchten Webseiten beim Beenden der Anwendung oder wenn alle privaten Tabs und Fenster geschlossen wurden. Das macht Sie gegenüber Website-Betreibern und Internetanbietern nicht anonym, aber erleichtert es Ihnen, dass andere Nutzer des Computers Ihre Aktivitäten nicht einsehen können.
about-private-browsing-need-more-privacy = Benötigen Sie mehr Datenschutz?
about-private-browsing-turn-on-vpn = { -mozilla-vpn-brand-name } ausprobieren
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } ist Ihre Standardsuchmaschine in privaten Fenstern
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Eine andere Suchmaschine kann in den <a data-l10n-name="link-options">Einstellungen</a> festgelegt werden.
       *[other] Eine andere Suchmaschine kann in den <a data-l10n-name="link-options">Einstellungen</a> festgelegt werden.
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Schließen
