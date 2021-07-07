# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-page-title = Add-ons-Verwaltung
search-header =
    .placeholder = Auf addons.mozilla.org suchen
    .searchbuttonlabel = Suchen
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = Holen Sie sich Erweiterungen und Themes auf <a data-l10n-name="get-extensions">{ $domain }</a>.
list-empty-installed =
    .value = Es sind keine Add-ons dieses Typs installiert
list-empty-available-updates =
    .value = Keine Updates gefunden
list-empty-recent-updates =
    .value = Sie haben in letzter Zeit keine Add-ons aktualisiert
list-empty-find-updates =
    .label = Nach Updates suchen
list-empty-button =
    .label = Mehr über Add-ons erfahren
help-button = Hilfe für Add-ons
sidebar-help-button-title =
    .title = Hilfe für Add-ons
addons-settings-button = { -brand-short-name } - Einstellungen
sidebar-settings-button-title =
    .title = { -brand-short-name } - Einstellungen
show-unsigned-extensions-button =
    .label = Einige Erweiterungen konnten nicht verifiziert werden.
show-all-extensions-button =
    .label = Alle Erweiterungen anzeigen
detail-version =
    .label = Version
detail-last-updated =
    .label = Zuletzt aktualisiert
detail-contributions-description = Der Entwickler dieses Add-ons bittet Sie, dass Sie die Entwicklung unterstützen, indem Sie einen kleinen Betrag spenden.
detail-contributions-button = Unterstützen
    .title = Die Entwicklung dieses Add-ons unterstützen
    .accesskey = U
detail-update-type =
    .value = Automatische Updates
detail-update-default =
    .label = Standard
    .tooltiptext = Updates nur dann automatisch installieren, wenn das der Standard ist
detail-update-automatic =
    .label = Ein
    .tooltiptext = Updates automatisch installieren
detail-update-manual =
    .label = Aus
    .tooltiptext = Updates nicht automatisch installieren
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = In privaten Fenstern ausführen
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = In privaten Fenstern nicht erlaubt
detail-private-disallowed-description2 = Die Erweiterung wird im Privaten Modus nicht ausgeführt. <a data-l10n-name="learn-more">Weitere Informationen</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Benötigt Zugriff auf private Fenster
detail-private-required-description2 = Die Erweiterung hat Zugriff auf Ihre Online-Aktivitäten im Privaten Modus. <a data-l10n-name="learn-more">Weitere Informationen</a>
detail-private-browsing-on =
    .label = Erlauben
    .tooltiptext = Aktivieren im privaten Modus
detail-private-browsing-off =
    .label = Nicht erlauben
    .tooltiptext = Deaktivieren im privaten Modus
detail-home =
    .label = Homepage
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Add-on-Profil
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Auf Updates prüfen
    .accesskey = U
    .tooltiptext = Auf verfügbare Updates für dieses Add-on prüfen
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Einstellungen
           *[other] Einstellungen
        }
    .accesskey =
        { PLATFORM() ->
            [windows] E
           *[other] E
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Die Einstellungen dieses Add-ons ändern
           *[other] Die Einstellungen dieses Add-ons ändern
        }
detail-rating =
    .value = Bewertung
addon-restart-now =
    .label = Jetzt neu starten
disabled-unsigned-heading =
    .value = Einige Add-ons wurden deaktiviert
disabled-unsigned-description = Die folgenden Add-ons wurden nicht für die Verwendung in { -brand-short-name } verifiziert. Sie können <label data-l10n-name="find-addons">nach Alternativen suchen</label> oder die Entwickler bitten, sie verifizieren zu lassen.
disabled-unsigned-learn-more = Erfahren Sie mehr über unsere Bestrebungen, Sie beim Surfen im Internet zu schützen.
disabled-unsigned-devinfo = An der Verifizierung ihrer Add-ons interessierte Entwickler können mehr dazu in unserer <label data-l10n-name="learn-more">Anleitung</label> erfahren.
plugin-deprecation-description = Fehlt etwas? Einige Plugins werden nicht mehr von { -brand-short-name } unterstützt. <label data-l10n-name="learn-more">Weitere Informationen</label>
legacy-warning-show-legacy = Erweiterungen des alten Add-on-Typs anzeigen
legacy-extensions =
    .value = Alter Add-on-Typ
legacy-extensions-description = Diese Erweiterungen erfüllen nicht die aktuellen Standards von { -brand-short-name } und wurden deshalb deaktiviert. <label data-l10n-name="legacy-learn-more">Weitere Informationen über Änderungen bei der Unterstützung von Add-ons für Waterfox</label>
private-browsing-description2 =
    { -brand-short-name } ändert die Verwendung von Erweiterungen im Privaten Modus.
    Neu in { -brand-short-name } installierte Erweiterungen werden standardmäßig in privaten Fenstern nicht ausgeführt und haben keinen Zugriff auf die Online-Aktivitäten in diesen, außer die Erweiterung wird in den Einstellungen für die Verwendung im Privaten Modus freigegeben.
    Diese Änderung dient Ihrem Datenschutz im Privaten Modus.
    <label data-l10n-name="private-browsing-learn-more">Weitere Informationen zur Verwaltung der Erweiterungseinstellungen</label>
addon-category-discover = Empfehlungen
addon-category-discover-title =
    .title = Empfehlungen
addon-category-extension = Erweiterungen
addon-category-extension-title =
    .title = Erweiterungen
addon-category-theme = Themes
addon-category-theme-title =
    .title = Themes
addon-category-plugin = Plugins
addon-category-plugin-title =
    .title = Plugins
addon-category-dictionary = Wörterbücher
addon-category-dictionary-title =
    .title = Wörterbücher
addon-category-locale = Sprachen
addon-category-locale-title =
    .title = Sprachen
addon-category-available-updates = Verfügbare Updates
addon-category-available-updates-title =
    .title = Verfügbare Updates
addon-category-recent-updates = Zuletzt durchgeführte Updates
addon-category-recent-updates-title =
    .title = Zuletzt durchgeführte Updates

## These are global warnings

extensions-warning-safe-mode = Alle Add-ons wurden durch den Abgesicherten Modus deaktiviert.
extensions-warning-check-compatibility = Die Addon-Kompatibilitäts-Prüfung ist deaktiviert. Sie könnten inkompatible Add-ons haben.
extensions-warning-check-compatibility-button = Aktivieren
    .title = Addon-Kompatibilitäts-Prüfung aktivieren
extensions-warning-update-security = Die Überprüfung der Sicherheit von Add-on-Updates ist deaktiviert. Ihre Sicherheit könnte durch Updates kompromittiert worden sein.
extensions-warning-update-security-button = Aktivieren
    .title = Überprüfung auf Sicherheitsupdates für Add-ons aktivieren

## Strings connected to add-on updates

addon-updates-check-for-updates = Auf Updates überprüfen
    .accesskey = A
addon-updates-view-updates = Kürzlich durchgeführte Updates anzeigen
    .accesskey = K

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Add-ons automatisch aktualisieren
    .accesskey = a

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Alle Add-ons umstellen auf automatische Aktualisierung
    .accesskey = u
addon-updates-reset-updates-to-manual = Alle Add-ons umstellen auf manuelle Aktualisierung
    .accesskey = u

## Status messages displayed when updating add-ons

addon-updates-updating = Add-ons werden aktualisiert
addon-updates-installed = Ihre Add-ons wurden aktualisiert.
addon-updates-none-found = Keine Updates gefunden
addon-updates-manual-updates-found = Verfügbare Updates anzeigen

## Add-on install/debug strings for page options menu

addon-install-from-file = Add-on aus Datei installieren…
    .accesskey = A
addon-install-from-file-dialog-title = Zu installierendes Add-on auswählen
addon-install-from-file-filter-name = Add-ons
addon-open-about-debugging = Add-ons debuggen
    .accesskey = b

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Tastenkombinationen von Erweiterungen verwalten
    .accesskey = T
shortcuts-no-addons = Es sind keine Erweiterungen aktiviert.
shortcuts-no-commands = Folgende Erweiterungen verfügen über keine Tastenkombinationen:
shortcuts-input =
    .placeholder = Tastenkombination drücken
shortcuts-browserAction2 = Schaltfläche für Symbolleiste aktivieren
shortcuts-pageAction = Aktion für Seite aktivieren
shortcuts-sidebarAction = Sidebar umschalten
shortcuts-modifier-mac = Mit Strg-, Alt- oder ⌘-Taste kombinieren
shortcuts-modifier-other = Mit Strg- oder Alt-Taste kombinieren
shortcuts-invalid = Ungültige Kombination
shortcuts-letter = Zeichen eingeben
shortcuts-system = { -brand-short-name }-Tastenkombinationen können nicht überschrieben werden.
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Doppelt verwendete Tastenkombination
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } wird mehrmals als Tastenkombination verwendet. Dies kann zu unerwartetem Verhalten führen.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Bereits durch { $addon } belegt
shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] { $numberToShow } weitere anzeigen
    }
shortcuts-card-collapse-button = Weniger anzeigen
header-back-button =
    .title = Zurück

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Erweiterungen und Themes sind wie Apps für den Browser und ermöglichen es zum Beispiel,
    Passwörter zu schützen, Videos herunterzuladen, keine Angebote zu verpassen, nervige Werbung zu blockieren,
    das Aussehen des Browsers zu verändern und viel mehr. Diese kleinen Software-Programme werden oft von
    Personen oder Organisationen entwickelt, die keine direkte Verbindung mit dem Browser-Entwickler haben.
    Hier ist eine Auswahl durch { -brand-product-name } von 
    <a data-l10n-name="learn-more-trigger">empfohlenen Add-ons</a>, welche für herausragende Sicherheit,
    Leistung und Funktionalität stehen.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Einige dieser Empfehlungen sind personalisiert, da sie auf Ihren bereits installierten Erweiterungen,
    Profileinstellungen und Nutzungsstatistiken basieren.
discopane-notice-learn-more = Weitere Informationen
privacy-policy = Datenschutzrichtlinie
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = von <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = { $dailyUsers } Nutzer
install-extension-button = Zu { -brand-product-name } hinzufügen
install-theme-button = Theme installieren
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Verwalten
find-more-addons = Mehr Add-ons ansehen
find-more-themes = Weitere Themes suchen
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Weitere Optionen

## Add-on actions

report-addon-button = Melden
remove-addon-button = Entfernen
# The link will always be shown after the other text.
remove-addon-disabled-button = <a data-l10n-name="link">Warum kann dies nicht entfernt werden?</a>
disable-addon-button = Deaktivieren
enable-addon-button = Aktivieren
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Aktivieren
preferences-addon-button =
    { PLATFORM() ->
        [windows] Einstellungen
       *[other] Einstellungen
    }
details-addon-button = Details
release-notes-addon-button = Versionshinweise
permissions-addon-button = Berechtigungen
extension-enabled-heading = Aktiviert
extension-disabled-heading = Deaktiviert
theme-enabled-heading = Aktiviert
theme-disabled-heading = Deaktiviert
theme-monochromatic-heading = Farbgebungen
theme-monochromatic-subheading = Lebendige neue Farbgebungen von { -brand-product-name }. Verfügbar für eine begrenzte Zeit.
plugin-enabled-heading = Aktiviert
plugin-disabled-heading = Deaktiviert
dictionary-enabled-heading = Aktiviert
dictionary-disabled-heading = Deaktiviert
locale-enabled-heading = Aktiviert
locale-disabled-heading = Deaktiviert
always-activate-button = Immer aktivieren
never-activate-button = Nie aktivieren
addon-detail-author-label = Autor
addon-detail-version-label = Version
addon-detail-last-updated-label = Zuletzt aktualisiert
addon-detail-homepage-label = Homepage
addon-detail-rating-label = Bewertung
# Message for add-ons with a staged pending update.
install-postponed-message = Diese Erweiterung wird beim Neustart von { -brand-short-name } aktualisiert.
install-postponed-button = Jetzt aktualisieren
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Bewertet mit { NUMBER($rating, maximumFractionDigits: 1) } von 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (deaktiviert)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } Bewertung
       *[other] { $numberOfReviews } Bewertungen
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> wurde entfernt.
pending-uninstall-undo-button = Rückgängig
addon-detail-updates-label = Automatische Updates erlauben
addon-detail-updates-radio-default = Standard
addon-detail-updates-radio-on = An
addon-detail-updates-radio-off = Aus
addon-detail-update-check-label = Nach Updates suchen
install-update-button = Aktualisieren
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = In privaten Fenstern erlaubt
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Falls erlaubt, hat die Erweiterung Zugriff auf Ihre Online-Aktivitäten im Privaten Modus. <a data-l10n-name="learn-more">Weitere Informationen</a>
addon-detail-private-browsing-allow = Erlauben
addon-detail-private-browsing-disallow = Nicht erlauben

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = { -brand-product-name } empfiehlt nur Erweiterungen, die unsere Standards für Sicherheit und Leistung erfüllen.
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Waterfox" in the string below because the extensions are built
# by Waterfox and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Offizielle Erweiterung von Waterfox. Erfüllt Sicherheits- und Leistungsstandards.
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = Diese Erweiterung wurde überprüft, um unsere Standards für Sicherheit und Leistung zu erfüllen.
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Verfügbare Updates
recent-updates-heading = Kürzlich durchgeführte Updates
release-notes-loading = Wird geladen…
release-notes-error = Es tut uns leid, beim Laden der Versionshinweise trat ein Fehler auf.
addon-permissions-empty = Diese Erweiterung benötigt keine Berechtigungen.
addon-permissions-required = Erforderliche Berechtigungen für die Kernfunktionalität:
addon-permissions-optional = Optionale Berechtigungen für zusätzliche Funktionalität:
addon-permissions-learnmore = Weitere Informationen zu Berechtigungen
recommended-extensions-heading = Empfohlene Erweiterungen
recommended-themes-heading = Empfohlene Themes
# A recommendation for the Waterfox Color theme shown at the bottom of the theme
# list view. The "Waterfox Color" name itself should not be translated.
recommended-theme-1 = Fühlen Sie sich inspiriert? <a data-l10n-name="link">Erstellen Sie eigene Themes mit Waterfox Color.</a>

## Page headings

extension-heading = Erweiterungen verwalten
theme-heading = Themes verwalten
plugin-heading = Plugins verwalten
dictionary-heading = Wörterbücher verwalten
locale-heading = Sprachen verwalten
updates-heading = Updates verwalten
discover-heading = { -brand-short-name } anpassen
shortcuts-heading = Tastenkombinationen von Erweiterungen verwalten
default-heading-search-label = Weitere Add-ons finden
addons-heading-search-input =
    .placeholder = Auf addons.mozilla.org suchen
addon-page-options-button =
    .title = Werkzeuge für alle Add-ons
