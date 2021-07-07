# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Questa operazione potrebbe invalidare la garanzia
config-about-warning-text = La modifica di queste impostazioni avanzate può compromettere la stabilità, la sicurezza e le prestazioni del browser. Si consiglia di proseguire solo se consapevoli delle proprie azioni.
config-about-warning-button =
    .label = Accetto i rischi
config-about-warning-checkbox =
    .label = Visualizza nuovamente questo avviso in futuro

config-search-prefs =
    .value = Cerca:
    .accesskey = C

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Nome parametro
config-lock-column =
    .label = Stato
config-type-column =
    .label = Tipo
config-value-column =
    .label = Valore

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Fare clic per riordinare
config-column-chooser =
    .tooltip = Fare clic per selezionare le colonne visualizzate

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Copia
    .accesskey = C

config-copy-name =
    .label = Copia nome
    .accesskey = o

config-copy-value =
    .label = Copia valore
    .accesskey = v

config-modify =
    .label = Modifica
    .accesskey = M

config-toggle =
    .label = Imposta
    .accesskey = s

config-reset =
    .label = Ripristina
    .accesskey = R

config-new =
    .label = Nuovo
    .accesskey = N

config-string =
    .label = Stringa
    .accesskey = r

config-integer =
    .label = Intero
    .accesskey = I

config-boolean =
    .label = Booleano
    .accesskey = B

config-default = predefinito
config-modified = modificato
config-locked = bloccato

config-property-string = stringa
config-property-int = intero
config-property-bool = booleano

config-new-prompt = Inserire il nome del parametro

config-nan-title = Valore non valido
config-nan-text = Il testo inserito non è un numero.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Nuovo valore { $type }

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Inserire un valore { $type }
