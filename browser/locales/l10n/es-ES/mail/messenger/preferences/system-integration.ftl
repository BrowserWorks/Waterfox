# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integración con el sistema

system-integration-dialog =
    .buttonlabelaccept = Definir como predet.
    .buttonlabelcancel = Omitir integración
    .buttonlabelcancel2 = Cancelar

default-client-intro = Usar { -brand-short-name } como cliente predeterminado para:

unset-default-tooltip = No es posible eliminar { -brand-short-name } como cliente predeterminado desde el propio { -brand-short-name }. Para que otra aplicación sea la predeterminada debe usar su diálogo 'Establecer como predeterminada'.

checkbox-email-label =
    .label = Correo-e
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Grupos de noticias
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
    .label = Permitir que { system-search-engine-name } busque en los mensajes
    .accesskey = P

check-on-startup-label =
    .label = Hacer siempre esta comprobación al iniciar { -brand-short-name }
    .accesskey = H
