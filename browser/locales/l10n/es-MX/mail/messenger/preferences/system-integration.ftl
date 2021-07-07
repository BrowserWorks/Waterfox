# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integración con el sistema
system-integration-dialog =
    .buttonlabelaccept = Establecer como predeterminado
    .buttonlabelcancel = Saltar integración
    .buttonlabelcancel2 = Cancelar
default-client-intro = Usar { -brand-short-name } como el cliente predeterminado para:
unset-default-tooltip = No es posible quitar { -brand-short-name } como el cliente predeterminado dentro de { -brand-short-name }. Para hacer que otra aplicación sea la predeterminada debes usar el diálogo 'Establecer como predeterminada'.
checkbox-email-label =
    .label = Correo electrónico
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Grupos de noticias
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Canales
    .tooltiptext = { unset-default-tooltip }
checkbox-calendar-label =
    .label = Calendario
    .tooltiptext = { unset-default-tooltip }
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Destacar
        [windows] Ventana de búsqueda
       *[other] { "" }
    }
system-search-integration-label =
    .label = Permitir a { system-search-engine-name } buscar en los mensajes
    .accesskey = S
check-on-startup-label =
    .label = Siempre realizar la verificación al iniciar { -brand-short-name }
    .accesskey = A
