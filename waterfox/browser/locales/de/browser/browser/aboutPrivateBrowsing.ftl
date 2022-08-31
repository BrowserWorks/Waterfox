# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Neues privates Fenster öffnen
    .accesskey = F
about-private-browsing-search-placeholder = Das Web durchsuchen
about-private-browsing-info-title = Dies ist ein privates Fenster
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
about-private-browsing-info-description-private-window = Privates Fenster: { -brand-short-name } leert die eingegebenen Suchbegriffe und besuchten Webseiten, wenn alle privaten Fenster geschlossen wurden. Das macht Sie nicht anonym.
about-private-browsing-info-description-simplified = { -brand-short-name } leert die eingegebenen Suchbegriffe und besuchten Webseiten, wenn alle privaten Fenster geschlossen wurden, aber das macht Sie nicht anonym.
about-private-browsing-learn-more-link = Weitere Informationen
about-private-browsing-hide-activity = Verbergen Sie Ihre Aktivitäten und Ihren Standort, wo immer Sie surfen
about-private-browsing-get-privacy = Lassen Sie Ihre Privatsphäre schützen, wo immer Sie surfen
about-private-browsing-hide-activity-1 = Verstecken Sie die Surfaktivität und den Standort mit { -mozilla-vpn-brand-name }. Ein Klick stellt eine sichere Verbindung her, auch über öffentliches WLAN.
about-private-browsing-prominent-cta = Schützen Sie Ihre Privatsphäre mit { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = { -focus-brand-name } herunterladen
about-private-browsing-focus-promo-header = { -focus-brand-name }: Privates Surfen unterwegs
about-private-browsing-focus-promo-text = Unsere speziell für privates Surfen entwickelte mobile App löscht jedes Mal Ihre Chronik und Ihre Cookies.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Bringen Sie privates Surfen auf Ihr Telefon
about-private-browsing-focus-promo-text-b = Verwenden Sie { -focus-brand-name } für die privaten Suchanfragen, die Ihr Haupt-Mobilbrowser nicht sehen soll.
about-private-browsing-focus-promo-header-c = Privatsphäre der nächsten Stufe für Mobilgeräte
about-private-browsing-focus-promo-text-c = { -focus-brand-name } löscht jedes Mal Ihren Verlauf, und blockiert Werbung und Elemente zur Aktivitätenverfolgung.
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
about-private-browsing-promo-close-button =
    .title = Schließen

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = Die Freiheits des privaten Surfens mit einem Klick
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Im Dock behalten
       *[other] An die Taskleiste anheften
    }
about-private-browsing-pin-promo-title = Keine gespeicherten Cookies oder Chronik, direkt von Ihrem Desktop. Surfen Sie, als würde niemand zusehen.
