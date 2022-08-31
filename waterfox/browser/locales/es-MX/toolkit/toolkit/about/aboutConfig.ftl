# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Configuración avanzada
config-about-warning-text = Esta página de configuración te permite modificar preferencias avanzadas, cambiar estos valores sin un conocimiento previo puede crear comportamientos no deseados. Te recomendamos no ingresar a menos que estés completamente seguro de lo que vas a hacer.
config-about-warning-button =
    .label = ¡Acepto el riesgo!
config-about-warning-checkbox =
    .label = Mostrar siempre esta advertencia.

config-search-prefs =
    .value = Buscar:
    .accesskey = r

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Nombre
config-lock-column =
    .label = Estado
config-type-column =
    .label = Tipo
config-value-column =
    .label = Valor

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Clic para ordenar
config-column-chooser =
    .tooltip = Clic para seleccionar las columnas a mostrar

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Copiar
    .accesskey = C

config-copy-name =
    .label = Copiar nombre
    .accesskey = n

config-copy-value =
    .label = Copiar valor
    .accesskey = v

config-modify =
    .label = Modificar
    .accesskey = M

config-toggle =
    .label = Modificar
    .accesskey = M

config-reset =
    .label = Restablecer
    .accesskey = R

config-new =
    .label = Nuevo
    .accesskey = o

config-string =
    .label = Cadena
    .accesskey = C

config-integer =
    .label = Entero
    .accesskey = E

config-boolean =
    .label = Lógico
    .accesskey = L

config-default = predeterminado
config-modified = modificado
config-locked = bloqueado

config-property-string = cadena
config-property-int = entero
config-property-bool = lógico

config-new-prompt = Ingresa el nombre de preferencia

config-nan-title = Valor inválido
config-nan-text = El texto proporcionado no es un número.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Nuevo valor { $type }

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Introducir valor { $type }
