# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Vorsicht!
about-config-intro-warning-text = Das Ändern von erweiterten Konfigurationseinstellungen kann sich auf die Leistung und Sicherheit von { -brand-short-name } auswirken.
about-config-intro-warning-checkbox = Beim Aufruf dieser Einstellungen immer warnen
about-config-intro-warning-button = Risiko akzeptieren und fortfahren

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Das Ändern dieser Einstellungen kann sich auf die Leistung und Sicherheit von { -brand-short-name } auswirken.

about-config-page-title = Erweiterte Einstellungen

about-config-search-input1 =
    .placeholder = Einstellungsname suchen
about-config-show-all = Alle Einstellungen anzeigen

about-config-pref-add-button =
    .title = Hinzufügen
about-config-pref-toggle-button =
    .title = Umschalten
about-config-pref-edit-button =
    .title = Bearbeiten
about-config-pref-save-button =
    .title = Speichern
about-config-pref-reset-button =
    .title = Zurücksetzen
about-config-pref-delete-button =
    .title = Löschen

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolean
about-config-pref-add-type-number = Number
about-config-pref-add-type-string = String

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (Standard)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (benutzerdefiniert)
