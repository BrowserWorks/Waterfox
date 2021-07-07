# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = Baixando atualização do { -brand-shorter-name }
    .label-update-available = Atualização disponível — baixar agora
    .label-update-manual = Atualização disponível — baixar agora
    .label-update-unsupported = Não foi possível atualizar — sistema incompatível
    .label-update-restart = Atualização disponível — reiniciar agora
appmenuitem-protection-dashboard-title = Painel de proteções
appmenuitem-customize-mode =
    .label = Personalizar…

## Zoom Controls

appmenuitem-new-tab =
    .label = Nova aba
appmenuitem-new-window =
    .label = Nova janela
appmenuitem-new-private-window =
    .label = Nova janela privativa
appmenuitem-passwords =
    .label = Senhas
appmenuitem-addons-and-themes =
    .label = Extensões e temas
appmenuitem-find-in-page =
    .label = Procurar na página…
appmenuitem-more-tools =
    .label = Mais ferramentas
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Sair
           *[other] Sair
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Abrir menu do aplicativo
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Fechar menu do aplicativo
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Configurações

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Ampliar
appmenuitem-zoom-reduce =
    .label = Reduzir
appmenuitem-fullscreen =
    .label = Tela inteira

## Firefox Account toolbar button and Sync panel in App menu.

fxa-toolbar-sync-now =
    .label = Sincronizar agora
appmenu-remote-tabs-sign-into-sync =
    .label = Entrar no Sync…
appmenu-remote-tabs-turn-on-sync =
    .label = Ativar o Sync…
appmenuitem-fxa-toolbar-sync-now2 = Sincronizar agora
appmenuitem-fxa-manage-account = Gerenciar conta
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Última sincronização: { $time }
    .label = Última sincronização: { $time }
appmenu-fxa-sync-and-save-data2 = Sincronizar e salvar dados
appmenu-fxa-signed-in-label = Entrar
appmenu-fxa-setup-sync =
    .label = Ativar sincronização…
appmenu-fxa-show-more-tabs = Mostrar mais abas
appmenuitem-save-page =
    .label = Salvar página como…

## What's New panel in App menu.

whatsnew-panel-header = Novidades
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Me notificar sobre novos recursos
    .accesskey = f

## The Firefox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Revelar mais informações
profiler-popup-description-title =
    .value = Grave, analise, compartilhe
profiler-popup-description = Colabore em questões de desempenho publicando profiles para compartilhar com sua equipe.
profiler-popup-learn-more = Saiba mais
profiler-popup-settings =
    .value = Configurações
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = Editar configurações…
profiler-popup-disabled = O profiler está desativado no momento, provavelmente devido a estar aberta uma janela de navegação privativa.
profiler-popup-recording-screen = Gravando…
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

## History panel

appmenu-manage-history =
    .label = Gerenciar histórico
appmenu-reopen-all-tabs = Reabrir todas as abas
appmenu-reopen-all-windows = Reabrir todas as janelas
appmenu-restore-session =
    .label = Restaurar sessão anterior
appmenu-clear-history =
    .label = Limpar histórico recente…
appmenu-recent-history-subheader = Histórico recente
appmenu-recently-closed-tabs =
    .label = Abas fechadas recentemente
appmenu-recently-closed-windows =
    .label = Janelas fechadas recentemente

## Help panel

appmenu-help-header =
    .title = Ajuda do { -brand-shorter-name }
appmenu-about =
    .label = Sobre o { -brand-shorter-name }
    .accesskey = S
appmenu-get-help =
    .label = Obter ajuda
    .accesskey = a
appmenu-help-more-troubleshooting-info =
    .label = Mais informações técnicas
    .accesskey = i
appmenu-help-report-site-issue =
    .label = Relatar problema no site…
appmenu-help-feedback-page =
    .label = Enviar opinião…
    .accesskey = n

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Modo de solução de problemas…
    .accesskey = M
appmenu-help-exit-troubleshoot-mode =
    .label = Desativar modo de solução de problemas
    .accesskey = m

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Denunciar site enganoso…
    .accesskey = r
appmenu-help-not-deceptive =
    .label = Este não é um site enganoso…
    .accesskey = E

## More Tools

appmenu-customizetoolbar =
    .label = Personalizar barra de ferramentas…
appmenu-taskmanager =
    .label = Gerenciador de tarefas
appmenu-developer-tools-subheader = Ferramentas do navegador
appmenu-developer-tools-extensions =
    .label = Extensões para desenvolvedores
