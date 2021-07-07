# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Fortsätt med försiktighet
about-config-intro-warning-text = Ändring av avancerade konfigurationsinställningar kan påverka { -brand-short-name } prestanda eller säkerhet.
about-config-intro-warning-checkbox = Varna mig när jag försöker komma åt dessa inställningar
about-config-intro-warning-button = Acceptera risken och fortsätt

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Att ändra dessa inställningar kan påverka { -brand-short-name } prestanda eller säkerhet.
about-config-page-title = Avancerade inställningar
about-config-search-input1 =
    .placeholder = Sök inställningsnamn
about-config-show-all = Visa allt
about-config-show-only-modified = Visa endast ändrade inställningar
about-config-pref-add-button =
    .title = Lägg till
about-config-pref-toggle-button =
    .title = Växla
about-config-pref-edit-button =
    .title = Redigera
about-config-pref-save-button =
    .title = Spara
about-config-pref-reset-button =
    .title = Återställ
about-config-pref-delete-button =
    .title = Ta bort

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolesk
about-config-pref-add-type-number = Nummer
about-config-pref-add-type-string = Sträng

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (standard)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (anpassad)
