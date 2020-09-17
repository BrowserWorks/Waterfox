# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Isto pode invalidar sua garantia!
config-about-warning-text = Alterar essas configurações avançadas pode prejudicar a estabilidade, segurança e desempenho desta aplicação. Você só deve continuar se estiver seguro do que está fazendo.
config-about-warning-button =
    .label = Eu aceito o risco!
config-about-warning-checkbox =
    .label = Sempre mostrar este aviso

config-search-prefs =
    .value = Procurar:
    .accesskey = o

config-focus-search =
    .key = R

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Nome
config-lock-column =
    .label = Status
config-type-column =
    .label = Tipo
config-value-column =
    .label = Valor

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Clique para ordenar
config-column-chooser =
    .tooltip = Clique para selecionar quais colunas mostrar

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Copiar
    .accesskey = C

config-copy-name =
    .label = Copiar nome
    .accesskey = o

config-copy-value =
    .label = Copiar valor
    .accesskey = v

config-modify =
    .label = Editar…
    .accesskey = E

config-toggle =
    .label = Inverter valor
    .accesskey = I

config-reset =
    .label = Redefinir
    .accesskey = R

config-new =
    .label = Nova preferência
    .accesskey = N

config-string =
    .label = Texto…
    .accesskey = T

config-integer =
    .label = Número inteiro…
    .accesskey = N

config-boolean =
    .label = Booleano…
    .accesskey = B

config-default = padrão
config-modified = modificado
config-locked = bloqueado

config-property-string = texto
config-property-int = número inteiro
config-property-bool = booleano

config-new-prompt = Digite o nome da preferência

config-nan-title = Valor inválido
config-nan-text = O texto digitado não é um número.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Nova preferência do tipo { $type }

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Informar valor { $type }
