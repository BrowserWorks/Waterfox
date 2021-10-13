# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Neues privates Fenster öffnen
    .accesskey = F
about-private-browsing-search-placeholder = Das Web durchsuchen
about-private-browsing-info-title = Dies ist ein privates Fenster
about-private-browsing-info-myths = Häufige Missverständnisse über das Surfen im Privaten Modus
about-private-browsing-search-btn =
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
about-private-browsing-info-description-private-window = Privates Fenster: { -brand-short-name } leert die eingegebenen Suchbegriffe und besuchten Webseiten, wenn alle privaten Fenster geschlossen wurden. Das macht Sie nicht anonym.
about-private-browsing-info-description-simplified = { -brand-short-name } leert die eingegebenen Suchbegriffe und besuchten Webseiten, wenn alle privaten Fenster geschlossen wurden, aber das macht Sie nicht anonym.
about-private-browsing-learn-more-link = Weitere Informationen
about-private-browsing-hide-activity = Verbergen Sie Ihre Aktivitäten und Ihren Standort, wo immer Sie surfen
about-private-browsing-get-privacy = Lassen Sie Ihre Privatsphäre schützen, wo immer Sie surfen
about-private-browsing-hide-activity-1 = Verstecken Sie die Surfaktivität und den Standort mit { -mozilla-vpn-brand-name }. Ein Klick stellt eine sichere Verbindung her, auch über öffentliches WLAN.
about-private-browsing-prominent-cta = Schützen Sie Ihre Privatsphäre mit { -mozilla-vpn-brand-name }
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
