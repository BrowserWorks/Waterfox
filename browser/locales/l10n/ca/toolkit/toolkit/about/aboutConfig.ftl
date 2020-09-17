# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Compte, que podríeu prendre mal!
config-about-warning-text = Canviar aquests paràmetres avançats pot ser perillós per a l'estabilitat, la seguretat i el rendiment de l'aplicació. Només hauríeu de continuar si sabeu què esteu fent.
config-about-warning-button =
    .label = Accepto el risc!
config-about-warning-checkbox =
    .label = Mostra'm aquest avís la propera vegada

config-search-prefs =
    .value = Cerca:
    .accesskey = r

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Nom de la preferència
config-lock-column =
    .label = Estat
config-type-column =
    .label = Tipus
config-value-column =
    .label = Valor

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Feu clic per ordenar
config-column-chooser =
    .tooltip = Feu un clic per seleccionar les columnes a visualitzar

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Copia
    .accesskey = C

config-copy-name =
    .label = Copia el nom
    .accesskey = n

config-copy-value =
    .label = Copia el valor
    .accesskey = v

config-modify =
    .label = Modifica
    .accesskey = M

config-toggle =
    .label = Commuta
    .accesskey = t

config-reset =
    .label = Reinicia
    .accesskey = R

config-new =
    .label = Nou
    .accesskey = u

config-string =
    .label = Cadena
    .accesskey = e

config-integer =
    .label = Enter
    .accesskey = r

config-boolean =
    .label = Booleà
    .accesskey = B

config-default = per defecte
config-modified = modificat
config-locked = blocat

config-property-string = cadena
config-property-int = enter
config-property-bool = booleà

config-new-prompt = Introduïu el nom de la preferència

config-nan-title = El valor no és vàlid
config-nan-text = El text que heu introduït no és un nombre.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Nou valor de { $type }

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Introduïu el valor { $type }
