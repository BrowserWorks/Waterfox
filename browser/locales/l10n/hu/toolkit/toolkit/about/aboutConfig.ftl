# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Vigyázat, veszélyes terület!
config-about-warning-text = Ezeknek a szakértőknek szóló beállításoknak a megváltoztatása káros hatással lehet az alkalmazás stabilitására, biztonságára vagy teljesítményére. Csak akkor folytassa, ha tisztában van azzal, amit csinál.
config-about-warning-button =
    .label = Elfogadom a kockázatot!
config-about-warning-checkbox =
    .label = A figyelmeztetés megjelenítése legközelebb

config-search-prefs =
    .value = Keresés:
    .accesskey = r

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Beállítás neve
config-lock-column =
    .label = Állapot
config-type-column =
    .label = Típus
config-value-column =
    .label = Érték

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Kattintson ide az e szerint rendezéshez
config-column-chooser =
    .tooltip = Jelölje ki a megjelenítendő oszlopokat

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Másolás
    .accesskey = M

config-copy-name =
    .label = Név másolása
    .accesskey = N

config-copy-value =
    .label = Érték másolása
    .accesskey = r

config-modify =
    .label = Módosítás
    .accesskey = M

config-toggle =
    .label = Ki/be
    .accesskey = K

config-reset =
    .label = Visszaállítás
    .accesskey = V

config-new =
    .label = Új
    .accesskey = j

config-string =
    .label = Karakterlánc
    .accesskey = K

config-integer =
    .label = Egész
    .accesskey = E

config-boolean =
    .label = Logikai
    .accesskey = L

config-default = alapértelmezett
config-modified = módosítva
config-locked = zárolt

config-property-string = karakterlánc
config-property-int = egész
config-property-bool = logikai

config-new-prompt = Adja meg a beállítás nevét

config-nan-title = Érvénytelen érték
config-nan-text = A megadott szöveg nem szám.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Új { $type } érték

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Írja be az új { $type } értéket
