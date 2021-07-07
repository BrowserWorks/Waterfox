# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

permissions-window =
    .title = Exceções
    .style = width: 45em
permissions-close-key =
    .key = w
permissions-address = Endereço do site
    .accesskey = d
permissions-block =
    .label = Bloquear
    .accesskey = B
permissions-session =
    .label = Permitir para a sessão
    .accesskey = e
permissions-allow =
    .label = Permitir
    .accesskey = P
permissions-button-off =
    .label = Desligar
    .accesskey = D
permissions-button-off-temporarily =
    .label = Desligar temporariamente
    .accesskey = t
permissions-site-name =
    .label = Site
permissions-status =
    .label = Estado
permissions-remove =
    .label = Remover site
    .accesskey = R
permissions-remove-all =
    .label = Remover todos os sites
    .accesskey = e
permissions-button-cancel =
    .label = Cancelar
    .accesskey = C
permissions-button-ok =
    .label = Guardar alterações
    .accesskey = G
permission-dialog =
    .buttonlabelaccept = Guardar alterações
    .buttonaccesskeyaccept = G
permissions-autoplay-menu = Predefinição para todos os sites:
permissions-searchbox =
    .placeholder = Pesquisar site
permissions-capabilities-autoplay-allow =
    .label = Permitir áudio e vídeo
permissions-capabilities-autoplay-block =
    .label = Bloquear áudio
permissions-capabilities-autoplay-blockall =
    .label = Bloquear áudio e vídeo
permissions-capabilities-allow =
    .label = Permitir
permissions-capabilities-block =
    .label = Bloquear
permissions-capabilities-prompt =
    .label = Perguntar sempre
permissions-capabilities-listitem-allow =
    .value = Permitir
permissions-capabilities-listitem-block =
    .value = Bloquear
permissions-capabilities-listitem-allow-session =
    .value = Permitir para a sessão
permissions-capabilities-listitem-off =
    .value = Desligado
permissions-capabilities-listitem-off-temporarily =
    .value = Temporariamente desligado

## Invalid Hostname Dialog

permissions-invalid-uri-title = Nome de servidor inválido introduzido
permissions-invalid-uri-label = Por favor introduza um nome de servidor válido

## Exceptions - Tracking Protection

permissions-exceptions-etp-window =
    .title = Exceções para a Proteção melhorada contra a monitorização
    .style = { permissions-window.style }
permissions-exceptions-etp-desc = Desativou as proteções nestes sites.

## Exceptions - Cookies

permissions-exceptions-cookie-window =
    .title = Exceções - Cookies e dados de sites
    .style = { permissions-window.style }
permissions-exceptions-cookie-desc = Pode especificar quais os sites que podem, sempre ou nunca, utilizar cookies e dados de sites.  Escreva o endereço exato do site que pretende gerir e depois clique em Bloquear, Permitir para a sessão ou Permitir.

## Exceptions - HTTPS-Only Mode

permissions-exceptions-https-only-window =
    .title = Exceções - modo apenas HTTPS
    .style = { permissions-window.style }
permissions-exceptions-https-only-desc = Pode desativar o modo apenas HTTPS para sites específicos. O { -brand-short-name } não tentará atualizar a ligação para HTTPS seguro  para estes sites. As exceções não se aplicam a janelas privadas.

## Exceptions - Pop-ups

permissions-exceptions-popup-window =
    .title = Sites permitidos - Pop-ups
    .style = { permissions-window.style }
permissions-exceptions-popup-desc = Pode especificar quais os sites que têm permissão para abrir janelas pop-up. Introduza o endereço exato do site que pretende permitir e depois clique em Permitir.

## Exceptions - Saved Logins

permissions-exceptions-saved-logins-window =
    .title = Exceções - Credenciais guardadas
    .style = { permissions-window.style }
permissions-exceptions-saved-logins-desc = Não serão guardadas as credenciais para os seguintes sites

## Exceptions - Add-ons

permissions-exceptions-addons-window =
    .title = Sites permitidos - Instalação de Extras
    .style = { permissions-window.style }
permissions-exceptions-addons-desc = Pode especificar quais os sites que têm permissão para instalar extras. Digite o endereço exato do site que pretende permitir e depois clique em Permitir.

## Site Permissions - Autoplay

permissions-site-autoplay-window =
    .title = Definições - Reprodução automática
    .style = { permissions-window.style }
permissions-site-autoplay-desc = Pode gerir os sites que não seguem as suas definições predefinidas de reprodução automática aqui.

## Site Permissions - Notifications

permissions-site-notification-window =
    .title = Definições - Permissões de notificação
    .style = { permissions-window.style }
permissions-site-notification-desc = Os sites seguintes solicitaram o envio de notificações. Pode especificar quais os sites que têm permissão para enviar notificações. Pode também bloquear novos pedidos, solicitando que seja pedida autorização para permitir notificações.
permissions-site-notification-disable-label =
    .label = Bloquear novos pedidos de permissão de notificações
permissions-site-notification-disable-desc = Isto irá impedir quaisquer sites não listados acima de solicitar permissão para enviar notificações. Bloquear notificações pode quebrar algumas funcionalidades dos sites.

## Site Permissions - Location

permissions-site-location-window =
    .title = Definições - Permissões de localização
    .style = { permissions-window.style }
permissions-site-location-desc = Os sites seguintes solicitaram acesso à sua localização. Pode especificar quais os sites que têm permissão para aceder à sua localização. Pode também bloquear novos pedidos, solicitando que seja pedida autorização para aceder à sua localização.
permissions-site-location-disable-label =
    .label = Bloquear novos pedidos de acesso à sua localização
permissions-site-location-disable-desc = Isto irá impedir quaisquer sites não listados acima de solicitar permissão para aceder à sua localização. Bloquear o acesso à sua localização pode quebrar algumas funcionalidades dos sites.

## Site Permissions - Virtual Reality

permissions-site-xr-window =
    .title = Definições - Permissões de realidade virtual
    .style = { permissions-window.style }
permissions-site-xr-desc = Os seguintes sites solicitaram acesso aos seus dispositivos de realidade virtual. Pode especificar quais os sites que têm permissão para aceder aos seus dispositivos de realidade virtual. Pode também bloquear novos pedidos de acesso aos seus dispositivos de realidade virtual.
permissions-site-xr-disable-label =
    .label = Bloquear novos pedidos de acesso aos seus dispositivos de realidade virtual
permissions-site-xr-disable-desc = Isto irá impedir que quaisquer sites não listados acima possam solicitar permissão de acesso aos seus dispositivos de realidade virtual. O bloqueio de acesso aos seus dispositivos de realidade virtual impedir algumas funcionalidades dos sites.

## Site Permissions - Camera

permissions-site-camera-window =
    .title = Definições - Permissões de câmara
    .style = { permissions-window.style }
permissions-site-camera-desc = Os sites seguintes solicitaram acesso à sua câmara. Pode especificar quais os sites que têm permissão para aceder à sua câmara. Pode também bloquear novos pedidos, solicitando que seja pedida autorização para aceder à sua câmara.
permissions-site-camera-disable-label =
    .label = Bloquear novos pedidos de acesso à sua câmara
permissions-site-camera-disable-desc = Isto irá impedir quaisquer sites não listados acima de solicitar permissão para aceder à sua câmara. Bloquear o acesso à sua câmara pode quebrar algumas funcionalidades dos sites.

## Site Permissions - Microphone

permissions-site-microphone-window =
    .title = Definições - Permissões de microfone
    .style = { permissions-window.style }
permissions-site-microphone-desc = Os sites seguintes solicitaram acesso ao seu microfone. Pode especificar quais os sites que têm permissão para aceder ao seu microfone. Pode também bloquear novos pedidos, solicitando que seja pedida autorização para aceder ao seu microfone.
permissions-site-microphone-disable-label =
    .label = Bloquear novos pedidos de acesso ao seu microfone
permissions-site-microphone-disable-desc = Isto irá impedir quaisquer sites não listados acima de solicitar permissão para aceder ao seu microfone. Bloquear o acesso ao seu microfone pode quebrar algumas funcionalidades dos sites.
