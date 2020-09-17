# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Շարունակեք զգուշությամբ
about-config-intro-warning-text = Կազմաձևի առաջատար նախապատվությունների փոփոխումը կարող է ազդել { -brand-short-name } ֊ի կատարման կամ անվտանգության վրա:
about-config-intro-warning-checkbox = Զգուշացեք ինձ, երբ ես փորձում եմ մուտք գործել այս նախընտրություններ
about-config-intro-warning-button = Ընդունել վտանգը եւ շարունակել

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Այս նախասիրությունների փոփոխությունը կարող է ազդել { -brand-short-name } ֊ի աշխատանքի կամ անվտանգության վրա:

about-config-page-title = Ընդլայնված նախընտրություններ

about-config-search-input1 =
    .placeholder = Որոնել նախընտրանքի անուն
about-config-show-all = Ցուցադրել բոլորը

about-config-pref-add-button =
    .title = Ավելացնել
about-config-pref-toggle-button =
    .title = Փոփոխել
about-config-pref-edit-button =
    .title = Խմբագրել
about-config-pref-save-button =
    .title = Պահպանել
about-config-pref-reset-button =
    .title = Վերակայել
about-config-pref-delete-button =
    .title = Ջնջել

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Տրամաբանական
about-config-pref-add-type-number = Թիվ
about-config-pref-add-type-string = Տող

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (սկզբնադիր)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (հարմարեցված)
