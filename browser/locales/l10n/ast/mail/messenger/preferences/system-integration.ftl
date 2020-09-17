# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integración col sistema

system-integration-dialog =
    .buttonlabelaccept = Definir como predet.
    .buttonlabelcancel = Omitir integración
    .buttonlabelcancel2 = Encaboxar

default-client-intro = Usar { -brand-short-name } como veceru por defeutu pa:

unset-default-tooltip = Nun ye dable desaniciar { -brand-short-name } como veceru predetermináu dende'l propiu { -brand-short-name }. Pa que otra aplicación seya la predeterminada, tienes d'usar el diálogu 'Afitar como predeterminada'.

checkbox-email-label =
    .label = Corréu-e
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Grupos de noticies
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Canales
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

system-search-integration-label =
    .label = Permitir que { system-search-engine-name } guete nos mensaxes
    .accesskey = P

check-on-startup-label =
    .label = Facer siempre esta comprobación al aniciar { -brand-short-name }
    .accesskey = F
