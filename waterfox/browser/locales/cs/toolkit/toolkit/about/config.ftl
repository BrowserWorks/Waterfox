# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Tady pozor
about-config-intro-warning-text =
    { -brand-short-name.case-status ->
        [with-cases] Změny v pokročilé konfiguraci mohou negativně ovlivnit výkon a bezpečnost { -brand-short-name(case: "gen") }.
       *[no-cases] Změny v pokročilé konfiguraci mohou negativně ovlivnit výkon a bezpečnost aplikace { -brand-short-name }.
    }
about-config-intro-warning-checkbox = Varovat při otevření této pokročilé konfigurace
about-config-intro-warning-button = Beru na vědomí a chci pokračovat

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text =
    { -brand-short-name.case-status ->
        [with-cases] Změny v těchto předvolbách mohou negativně ovlivnit výkon a bezpečnost { -brand-short-name(case: "gen") }.
       *[no-cases] Změny v těchto předvolbách mohou negativně ovlivnit výkon a bezpečnost aplikace { -brand-short-name }.
    }

about-config-page-title = Pokročilá konfigurace

about-config-search-input1 =
    .placeholder = Hledat podle názvu předvolby
about-config-show-all = Zobrazit vše

about-config-show-only-modified = Zobrazit pouze změněné předvolby

about-config-pref-add-button =
    .title = Přidat
about-config-pref-toggle-button =
    .title = Přepnout
about-config-pref-edit-button =
    .title = Upravit
about-config-pref-save-button =
    .title = Uložit
about-config-pref-reset-button =
    .title = Obnovit
about-config-pref-delete-button =
    .title = Odstranit

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Logická hodnota
about-config-pref-add-type-number = Číslo
about-config-pref-add-type-string = Textový řetězec

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (výchozí)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (vlastní)
