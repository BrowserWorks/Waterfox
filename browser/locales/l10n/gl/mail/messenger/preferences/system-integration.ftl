# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integración co sistema

system-integration-dialog =
    .buttonlabelaccept = Estabelecer como predeterminado
    .buttonlabelcancel = Saltar integración
    .buttonlabelcancel2 = Cancelar

default-client-intro = Usar o { -brand-short-name } como o cliente predeterminado para:

unset-default-tooltip = Non é posíbel quitar o { -brand-short-name } como cliente predeterminado desde o propio { -brand-short-name }. Para facer que outro aplicativo sexa o predeterminado debe usar o seu diálogo de 'Estabelecer como predeterminado'.

checkbox-email-label =
    .label = Correo
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Grupos de novas
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Fontes
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
    .label = Permitir que { system-search-engine-name } busque nas mensaxes
    .accesskey = P

check-on-startup-label =
    .label = Facer sempre esta comprobación ao iniciar { -brand-short-name }
    .accesskey = F
