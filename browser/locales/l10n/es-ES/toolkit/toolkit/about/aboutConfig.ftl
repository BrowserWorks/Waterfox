# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = ¡Zona hostil para manazas!
config-about-warning-text = Cambiar estas preferencias avanzadas puede ser perjudicial para la estabilidad, seguridad y rendimiento de esta aplicación. Sólo debería continuar si está seguro de lo que está haciendo.
config-about-warning-button =
    .label = ¡Acepto el riesgo!
config-about-warning-checkbox =
    .label = Mostrar esta advertencia la próxima vez

config-search-prefs =
    .value = Buscar:
    .accesskey = B

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Nombre de la preferencia
config-lock-column =
    .label = Estado
config-type-column =
    .label = Tipo
config-value-column =
    .label = Valor

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Pulse para ordenar
config-column-chooser =
    .tooltip = Pulse para seleccionar las columnas a mostrar

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Copiar
    .accesskey = C

config-copy-name =
    .label = Copiar nombre
    .accesskey = N

config-copy-value =
    .label = Copiar valor
    .accesskey = V

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
    .label = cadena
    .accesskey = C

config-integer =
    .label = entero
    .accesskey = E

config-boolean =
    .label = sí/no
    .accesskey = s

config-default = predeterminado
config-modified = modificado
config-locked = bloqueado

config-property-string = cadena
config-property-int = entero
config-property-bool = sí/no

config-new-prompt = Introduzca el nombre de preferencia

config-nan-title = Valor no válido
config-nan-text = El texto que ha introducido no es un número.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Nuevo valor { $type }

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Introducir valor { $type }
