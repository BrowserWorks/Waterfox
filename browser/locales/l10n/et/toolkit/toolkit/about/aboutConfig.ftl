# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = See võib sinu garantii kehtetuks muuta!
config-about-warning-text = Nende edasijõudnud kasutajatele mõeldud sätete muutmine võib mõjuda kahjulikult rakenduse stabiilsusele, turvalisusele ja võimekusele. Sa peaksid jätkama ainult siis, kui tead, mida teed.
config-about-warning-button =
    .label = Ma võtan selle riski!
config-about-warning-checkbox =
    .label = Seda hoiatust näidatakse ka järgmine kord

config-search-prefs =
    .value = Otsi:
    .accesskey = i

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Eelistuse nimi
config-lock-column =
    .label = Olek
config-type-column =
    .label = Tüüp
config-value-column =
    .label = Väärtus

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Klõpsa sortimiseks
config-column-chooser =
    .tooltip = Klõpsa kuvatavate veergude valimiseks

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Kopeeri
    .accesskey = K

config-copy-name =
    .label = Kopeeri nimi
    .accesskey = o

config-copy-value =
    .label = Kopeeri väärtus
    .accesskey = v

config-modify =
    .label = Muuda
    .accesskey = M

config-toggle =
    .label = Vastanda
    .accesskey = d

config-reset =
    .label = Lähtesta
    .accesskey = L

config-new =
    .label = Uus
    .accesskey = U

config-string =
    .label = String
    .accesskey = S

config-integer =
    .label = Täisarv
    .accesskey = T

config-boolean =
    .label = Tõeväärtus
    .accesskey = v

config-default = vaikimisi
config-modified = muudetud
config-locked = lukustatud

config-property-string = string
config-property-int = täisarv
config-property-bool = tõeväärtus

config-new-prompt = Sisesta eelistuse nimi

config-nan-title = Vigane väärtus
config-nan-text = Tekst, mille sisestasid, ei ole number.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Uus { $type } tüüpi väärtus

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Väärtuse sisestamine ({ $type })
