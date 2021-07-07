# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Ga voorzichtig verder
about-config-intro-warning-text = Het wijzigen van geavanceerde configuratievoorkeuren kan de prestaties of veiligheid van { -brand-short-name } beïnvloeden.
about-config-intro-warning-checkbox = Mij waarschuwen als ik deze voorkeuren probeer te benaderen
about-config-intro-warning-button = Het risico aanvaarden en doorgaan

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Het wijzigen van deze voorkeuren kan de prestaties of veiligheid van { -brand-short-name } beïnvloeden.
about-config-page-title = Geavanceerde voorkeuren
about-config-search-input1 =
    .placeholder = Naam voorkeursinstelling zoeken
about-config-show-all = Alles tonen
about-config-show-only-modified = Alleen gewijzigde voorkeuren tonen
about-config-pref-add-button =
    .title = Toevoegen
about-config-pref-toggle-button =
    .title = Omschakelen
about-config-pref-edit-button =
    .title = Bewerken
about-config-pref-save-button =
    .title = Opslaan
about-config-pref-reset-button =
    .title = Herinitialiseren
about-config-pref-delete-button =
    .title = Verwijderen

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolean
about-config-pref-add-type-number = Getal
about-config-pref-add-type-string = String

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (standaard)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (aangepast)
