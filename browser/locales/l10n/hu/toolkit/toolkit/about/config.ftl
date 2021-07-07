# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Óvatosan haladjon tovább
about-config-intro-warning-text = A speciális beállítások megváltoztatása befolyásolhatja a { -brand-short-name } teljesítményét vagy biztonságát.
about-config-intro-warning-checkbox = Figyelmeztetés ezen beállítások elérése előtt
about-config-intro-warning-button = Kockázat elfogadása és továbblépés

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Ezen beállítások megváltoztatása befolyásolhatja a { -brand-short-name } teljesítményét vagy biztonságát.

about-config-page-title = Speciális beállítások

about-config-search-input1 =
    .placeholder = Beállításnév keresése
about-config-show-all = Összes megjelenítése

about-config-show-only-modified = Csak a módosított beállítások megjelenítése

about-config-pref-add-button =
    .title = Hozzáadás
about-config-pref-toggle-button =
    .title = Ki/be
about-config-pref-edit-button =
    .title = Szerkesztés
about-config-pref-save-button =
    .title = Mentés
about-config-pref-reset-button =
    .title = Visszaállítás
about-config-pref-delete-button =
    .title = Törlés

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Logikai
about-config-pref-add-type-number = Szám
about-config-pref-add-type-string = Karakterlánc

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (alapértelmezett)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (egyéni)
