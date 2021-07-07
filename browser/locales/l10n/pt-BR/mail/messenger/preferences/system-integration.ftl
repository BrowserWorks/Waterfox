# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integração com o sistema
system-integration-dialog =
    .buttonlabelaccept = Definir como padrão
    .buttonlabelcancel = Pular integração
    .buttonlabelcancel2 = Cancelar
default-client-intro = Tornar o { -brand-short-name } o aplicativo padrão para:
unset-default-tooltip = Não é possível remover o { -brand-short-name } como o cliente padrão dentro do { -brand-short-name }. Para tornar outro aplicativo o cliente padrão você deve usar a configuração 'Tornar padrão' do próprio aplicativo.
checkbox-email-label =
    .label = Email
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Grupos de notícias
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = RSS
    .tooltiptext = { unset-default-tooltip }
checkbox-calendar-label =
    .label = Agenda
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
    .label = Permitir que o { system-search-engine-name } pesquise em mensagens
    .accesskey = P
check-on-startup-label =
    .label = Sempre verificar ao iniciar o { -brand-short-name }
    .accesskey = S
