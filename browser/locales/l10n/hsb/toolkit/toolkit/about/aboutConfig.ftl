# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Přez to móžeće swoju garantiju zhubić!
config-about-warning-text = Hdyž tute rozšěrjene nastajenja změniće, móže so to škódnje na stabilitu, wěstotu a wukon tutoho nałoženja wuskutkować. Wy měł jenož z tym pokročować, jeli sće sej wěsty, štož činiće.
config-about-warning-button =
    .label = Akceptuju riziko!
config-about-warning-checkbox =
    .label = Tute warnowanje přichodny raz pokazać

config-search-prefs =
    .value = Pytać:
    .accesskey = t

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Mjeno nastajenja
config-lock-column =
    .label = Status
config-type-column =
    .label = Typ
config-value-column =
    .label = Hódnota

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Klikńće, zo byšće sortěrował
config-column-chooser =
    .tooltip = Klikńće, zo byšće wubrane špalty zwobraznił

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Kopěrować
    .accesskey = K

config-copy-name =
    .label = Mjeno kopěrować
    .accesskey = M

config-copy-value =
    .label = Hódnotu kopěrować
    .accesskey = H

config-modify =
    .label = Změnić
    .accesskey = Z

config-toggle =
    .label = Přešaltować
    .accesskey = P

config-reset =
    .label = Wróćo stajić
    .accesskey = r

config-new =
    .label = Nowy
    .accesskey = N

config-string =
    .label = String
    .accesskey = S

config-integer =
    .label = Integer
    .accesskey = I

config-boolean =
    .label = Boolean
    .accesskey = B

config-default = standard
config-modified = změnjeny
config-locked = zawrjeny

config-property-string = string
config-property-int = integer
config-property-bool = boolean

config-new-prompt = Zapodajće mjeno nastajenja

config-nan-title = Njepłaćiwa hódnota
config-nan-text = Tekst, kotryž sće zapodał, ličba njeje.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Nowa hódnota { $type }

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Zapodajće hódnotu { $type }
