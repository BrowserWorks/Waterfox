# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Definições para limpar histórico
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Limpar histórico
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Limpar todo o histórico
    .style = width: 34em

clear-data-settings-label = Quando fechado, o { -brand-short-name } deve limpar automaticamente todos(as)

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Intervalo de tempo a limpar:{ " " }
    .accesskey = t

clear-time-duration-value-last-hour =
    .label = da última hora

clear-time-duration-value-last-2-hours =
    .label = das últimas 2 horas

clear-time-duration-value-last-4-hours =
    .label = das últimas 4 horas

clear-time-duration-value-today =
    .label = de hoje

clear-time-duration-value-everything =
    .label = Tudo

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Histórico

item-history-and-downloads =
    .label = Histórico de navegação e de transferências
    .accesskey = H

item-cookies =
    .label = Cookies
    .accesskey = C

item-active-logins =
    .label = Inícios de sessão ativos
    .accesskey = I

item-cache =
    .label = Cache
    .accesskey = a

item-form-search-history =
    .label = Histórico de pesquisa
    .accesskey = q

data-section-label = Dados

item-site-preferences =
    .label = Preferências de sites
    .accesskey = s

item-site-settings =
    .label = Definições do site
    .accesskey = D

item-offline-apps =
    .label = Dados offline de sites
    .accesskey = o

sanitize-everything-undo-warning = Esta ação não pode ser desfeita.

window-close =
    .key = w

sanitize-button-ok =
    .label = Limpar agora

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = A limpar

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Todo o histórico será limpo.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Serão limpos todos os itens selecionados.
