# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Isto pode violar a sua garantia!
config-about-warning-text = A alteração destas definições avançadas pode ser prejudicial para a estabilidade, segurança e desempenho desta aplicação. Apenas deve continuar se tem a certeza do que está a fazer.
config-about-warning-button =
    .label = Eu aceito o risco!
config-about-warning-checkbox =
    .label = Mostrar este aviso da próxima vez

config-search-prefs =
    .value = Pesquisar:
    .accesskey = r

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Nome da preferência
config-lock-column =
    .label = Estado
config-type-column =
    .label = Tipo
config-value-column =
    .label = Valor

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Clique para ordenar
config-column-chooser =
    .tooltip = Clique para selecionar as colunas a mostrar

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Copiar
    .accesskey = C

config-copy-name =
    .label = Copiar nome
    .accesskey = n

config-copy-value =
    .label = Copiar valor
    .accesskey = v

config-modify =
    .label = Modificar
    .accesskey = M

config-toggle =
    .label = Alternar
    .accesskey = t

config-reset =
    .label = Repor
    .accesskey = R

config-new =
    .label = Novo
    .accesskey = v

config-string =
    .label = String
    .accesskey = S

config-integer =
    .label = Inteiro
    .accesskey = I

config-boolean =
    .label = Booleano
    .accesskey = B

config-default = predefinição
config-modified = modificada
config-locked = bloqueada

config-property-string = string
config-property-int = inteiro
config-property-bool = booleano

config-new-prompt = Introduza o nome da preferência

config-nan-title = Valor inválido
config-nan-text = O texto que escreveu não é um número.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Novo valor { $type }

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Introduza o valor de { $type }
