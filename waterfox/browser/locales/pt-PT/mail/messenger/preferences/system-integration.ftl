# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integração no sistema

system-integration-dialog =
    .buttonlabelaccept = Definir como predefinido
    .buttonlabelcancel = Ignorar integração
    .buttonlabelcancel2 = Cancelar

default-client-intro = Utilizar o { -brand-short-name } como aplicação predefinida para:

unset-default-tooltip = Não pode cancelar a seleção do { -brand-short-name } como aplicação predefinida no { -brand-short-name }. Para definir outra aplicação como predefinida tem de utilizar a janela 'Definir como predefinido'.

checkbox-email-label =
    .label = E-mail
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Grupos de notícias
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Fontes
    .tooltiptext = { unset-default-tooltip }

checkbox-calendar-label =
    .label = Calendário
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Pesquisa do Windows
       *[other] { "" }
    }

system-search-integration-label =
    .label = Permitir que { system-search-engine-name } pesquise as mensagens
    .accesskey = P

check-on-startup-label =
    .label = Realizar sempre esta verificação ao iniciar o { -brand-short-name }
    .accesskey = a
