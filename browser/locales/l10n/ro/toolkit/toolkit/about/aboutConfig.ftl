# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Aceasta ți-ar putea invalida garanția!
config-about-warning-text = Schimbarea setărilor avansate poate dăuna stabilității, securității și performanței acestei aplicații. Ar trebui să continui numai dacă ești sigur de ceea ce faci.
config-about-warning-button =
    .label = Accept riscul!
config-about-warning-checkbox =
    .label = Afișează această avertizare data viitoare

config-search-prefs =
    .value = Căutare:
    .accesskey = r

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Numele preferinței
config-lock-column =
    .label = Stare
config-type-column =
    .label = Tip
config-value-column =
    .label = Valoare

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Clic pentru sortare
config-column-chooser =
    .tooltip = Clic pentru a selecta coloanele de afișat

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Copiază
    .accesskey = C

config-copy-name =
    .label = Copiază numele
    .accesskey = n

config-copy-value =
    .label = Copiază valoarea
    .accesskey = v

config-modify =
    .label = Modifică
    .accesskey = M

config-toggle =
    .label = Comută
    .accesskey = t

config-reset =
    .label = Resetează
    .accesskey = R

config-new =
    .label = Nou
    .accesskey = w

config-string =
    .label = Text
    .accesskey = S

config-integer =
    .label = Număr
    .accesskey = I

config-boolean =
    .label = Boolean
    .accesskey = B

config-default = implicită
config-modified = modificată
config-locked = blocată

config-property-string = text
config-property-int = număr
config-property-bool = boolean

config-new-prompt = Introdu numele preferinței

config-nan-title = Valoare nevalidă
config-nan-text = Textul introdus nu este un număr.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Valoare nouă pentru preferința de tip { $type }

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Introdu valoarea pentru preferința de tip { $type }
