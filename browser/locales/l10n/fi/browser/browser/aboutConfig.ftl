# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Jatka varoen
about-config-intro-warning-text = Lisäasetusten muuttaminen voi vaikuttaa { -brand-short-name }in suorituskykyyn tai tietoturvaan.
about-config-intro-warning-checkbox = Varoita, kun yritän avata nämä asetukset
about-config-intro-warning-button = Hyväksy riski ja jatka



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Näiden asetusten muuttaminen voi vaikuttaa { -brand-short-name }in suorituskykyyn tai turvallisuuteen.

about-config-page-title = Lisäasetukset

about-config-search-input1 =
    .placeholder = Etsi asetuksen nimellä
about-config-show-all = Näytä kaikki

about-config-pref-add-button =
    .title = Lisää
about-config-pref-toggle-button =
    .title = Vaihda tilaa
about-config-pref-edit-button =
    .title = Muokkaa
about-config-pref-save-button =
    .title = Tallenna
about-config-pref-reset-button =
    .title = Nollaa
about-config-pref-delete-button =
    .title = Poista

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Totuusarvo
about-config-pref-add-type-number = Luku
about-config-pref-add-type-string = Merkkijono

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (oletus)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (muutettu)
