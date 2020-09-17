# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Lean ar aghaidh go cúramach
about-config-intro-warning-text = D'fhéadfadh athrú sna hardroghanna seo drochthionchar a imirt ar fheidhmíocht nó ar shlándáil { -brand-short-name }.
about-config-intro-warning-checkbox = Tabhair rabhadh dom nuair a dhéanaim iarracht na sainroghanna seo a oscailt
about-config-intro-warning-button = Tuigim an Baol. Ar Aghaidh Linn!

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = D'fhéadfadh athrú sna hardroghanna seo drochthionchar a imirt ar fheidhmíocht nó ar shlándáil { -brand-short-name }.

about-config-page-title = Ardroghanna

about-config-search-input1 =
    .placeholder = Cuardach ar ainm na sainrogha
about-config-show-all = Taispeáin Uile

about-config-pref-add-button =
    .title = Cuir Leis
about-config-pref-toggle-button =
    .title = Scoránaigh
about-config-pref-edit-button =
    .title = Eagar
about-config-pref-save-button =
    .title = Sábháil
about-config-pref-reset-button =
    .title = Athshocraigh
about-config-pref-delete-button =
    .title = Scrios

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boole
about-config-pref-add-type-number = Uimhir
about-config-pref-add-type-string = Teaghrán

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (réamhshocrú)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (saincheaptha)
