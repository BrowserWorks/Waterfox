# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = A transferir atualização do { -brand-shorter-name }
    .label-update-available = Atualização disponível — transferir agora
    .label-update-manual = Atualização disponível — transferir agora
    .label-update-unsupported = Não foi possível atualizar — sistema incompatível
    .label-update-restart = Atualização disponível — reiniciar agora
appmenuitem-protection-dashboard-title = Painel das proteções
appmenuitem-new-tab =
    .label = Novo separador
appmenuitem-new-window =
    .label = Nova janela
appmenuitem-new-private-window =
    .label = Nova janela privada
appmenuitem-history =
    .label = Histórico
appmenuitem-downloads =
    .label = Transferências
appmenuitem-passwords =
    .label = Palavras-passe
appmenuitem-addons-and-themes =
    .label = Extras e temas
appmenuitem-print =
    .label = Imprimir…
appmenuitem-find-in-page =
    .label = Localizar na página…
appmenuitem-zoom =
    .value = Zoom
appmenuitem-more-tools =
    .label = Mais ferramentas
appmenuitem-help =
    .label = Ajuda
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Sair
           *[other] Sair
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Abrir menu da aplicação
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Fechar menu da aplicação
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Definições

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Ampliar
appmenuitem-zoom-reduce =
    .label = Reduzir
appmenuitem-fullscreen =
    .label = Ecrã completo

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = Iniciar sessão para sincronizar…
appmenu-remote-tabs-turn-on-sync =
    .label = Ativar a sincronização…
# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = Mostrar mais separadores
    .tooltiptext = Mostrar mais separadores deste dispositivo
# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = Nenhum separador aberto
# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = Ative a sincronização de separadores para ver uma lista de separadores dos seus outros dispositivos.
appmenu-remote-tabs-opensettings =
    .label = Definições
# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = Pretende ver os seus separadores de outros dispositivos aqui?
appmenu-remote-tabs-connectdevice =
    .label = Ligar outro dispositivo
appmenu-remote-tabs-welcome = Veja uma lista de separadores dos seus outros dispositivos.
appmenu-remote-tabs-unverified = A sua conta necessita de ser verificada.
appmenuitem-fxa-toolbar-sync-now2 = Sincronizar agora
appmenuitem-fxa-sign-in = Iniciar sessão no { -brand-product-name }
appmenuitem-fxa-manage-account = Gerir conta
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Última sincronização { $time }
    .label = Última sincronização { $time }
appmenu-fxa-sync-and-save-data2 = Sincronizar e guardar dados
appmenu-fxa-signed-in-label = Iniciar sessão
appmenu-fxa-setup-sync =
    .label = Ativar a sincronização ...
appmenu-fxa-show-more-tabs = Mostrar mais separadores
appmenuitem-save-page =
    .label = Guardar página como…

## What's New panel in App menu.

whatsnew-panel-header = Novidades
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Notificar sobre as novas funcionalidades
    .accesskey = f

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = Profiler
    .tooltiptext = Grave um perfil de desempenho
profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Revelar mais informação
profiler-popup-description-title =
    .value = Gravar, analisar, partilhar
profiler-popup-description = Colabore em problemas de desempenho publicando perfis para partilhar com a sua equipa.
profiler-popup-learn-more = Saber mais
profiler-popup-learn-more-button =
    .label = Saber mais
profiler-popup-settings =
    .value = Definições
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = Editar definições…
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Editar definições…
profiler-popup-disabled =
    Neste momento o profiler está, provavelmente, desativado devido a uma janela de navegação privada 
    que está a ser aberta.
profiler-popup-recording-screen = A gravar…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = Personalizado
profiler-popup-start-recording-button =
    .label = Iniciar gravação
profiler-popup-discard-button =
    .label = Descartar
profiler-popup-capture-button =
    .label = Capturar
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Shift+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Shift+2
    }

## Profiler presets
## They are shown in the popup's select box.


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# Please take care that the same values are also defined in devtools' perftools.ftl.


## History panel

appmenu-manage-history =
    .label = Gerir Histórico
appmenu-reopen-all-tabs = Reabrir todos os separadores
appmenu-reopen-all-windows = Reabrir todas as janelas
appmenu-restore-session =
    .label = Restaurar sessão anterior
appmenu-clear-history =
    .label = Limpar histórico recente…
appmenu-recent-history-subheader = Histórico recente
appmenu-recently-closed-tabs =
    .label = Separadores fechados recentemente
appmenu-recently-closed-windows =
    .label = Janelas fechadas recentemente

## Help panel

appmenu-help-header =
    .title = Ajuda do { -brand-shorter-name }
appmenu-about =
    .label = Acerca do { -brand-shorter-name }
    .accesskey = A
appmenu-get-help =
    .label = Obter ajuda
    .accesskey = j
appmenu-help-more-troubleshooting-info =
    .label = Mais informação para diagnóstico de problemas
    .accesskey = g
appmenu-help-report-site-issue =
    .label = Reportar problema do site…
appmenu-help-feedback-page =
    .label = Submeter feedback…
    .accesskey = S

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Modo de diagnóstico…
    .accesskey = M
appmenu-help-exit-troubleshoot-mode =
    .label = Desligar o modo de diagnóstico
    .accesskey = m

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Reportar site decetivo…
    .accesskey = d
appmenu-help-not-deceptive =
    .label = Este não é um site decetivo…
    .accesskey = d

## More Tools

appmenu-customizetoolbar =
    .label = Personalizar barra de ferramentas…
appmenu-taskmanager =
    .label = Gestor de tarefas
appmenu-developer-tools-subheader = Ferramentas do navegador
appmenu-developer-tools-extensions =
    .label = Extensões para Programadores
