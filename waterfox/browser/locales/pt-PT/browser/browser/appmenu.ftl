# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-banner-update-downloading =
    .label = A transferir atualização do { -brand-shorter-name }

appmenuitem-banner-update-available =
    .label = Atualização disponível — transferir agora

appmenuitem-banner-update-manual =
    .label = Atualização disponível — transferir agora

appmenuitem-banner-update-unsupported =
    .label = Não foi possível atualizar — sistema incompatível

appmenuitem-banner-update-restart =
    .label = Atualização disponível — reiniciar agora

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
appmenuitem-translate =
    .label = Traduzir página…
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

profiler-popup-button-recording =
    .label = Profiler
    .tooltiptext = O profiler está a gravar um perfil

profiler-popup-button-capturing =
    .label = Profiler
    .tooltiptext = O profiler está a capturar um perfil

profiler-popup-header-text = { -profiler-brand-name }

profiler-popup-reveal-description-button =
    .aria-label = Revelar mais informação

profiler-popup-description-title =
    .value = Gravar, analisar, partilhar

profiler-popup-description = Colabore em problemas de desempenho publicando perfis para partilhar com a sua equipa.

profiler-popup-learn-more-button =
    .label = Saber mais

profiler-popup-settings =
    .value = Definições

# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Editar definições…

profiler-popup-recording-screen = A gravar…

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


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/shared/background.jsm.js
# Please take care that the same values are also defined in devtools' perftools.ftl.

profiler-popup-presets-web-developer-description = Predefinição recomendada para a maioria das depurações de aplicações web, com pouca sobrecarga.
profiler-popup-presets-web-developer-label =
    .label = Programador web

profiler-popup-presets-firefox-description = Predefinição recomendada para perfilar o { -brand-shorter-name }.
profiler-popup-presets-firefox-label =
    .label = { -brand-shorter-name }

profiler-popup-presets-graphics-description = Predefinição para investigar bugs gráficos no { -brand-shorter-name }.
profiler-popup-presets-graphics-label =
    .label = Gráficos

profiler-popup-presets-media-description2 = Predefinição para investigar bugs de áudio e vídeo no { -brand-shorter-name }.
profiler-popup-presets-media-label =
    .label = Multimédia

profiler-popup-presets-networking-description = Predefinição para investigar bugs de rede no { -brand-shorter-name }.
profiler-popup-presets-networking-label =
    .label = Rede

profiler-popup-presets-power-description = Predefinição para investigar bugs relacionados com a utilização de energia no { -brand-shorter-name }, com baixa sobrecarga.
# "Power" is used in the sense of energy (electricity used by the computer).
profiler-popup-presets-power-label =
    .label = Potência

profiler-popup-presets-custom-label =
    .label = Personalizada

## History panel

appmenu-manage-history =
    .label = Gerir Histórico
appmenu-restore-session =
    .label = Restaurar sessão anterior
appmenu-clear-history =
    .label = Limpar histórico recente…
appmenu-recent-history-subheader = Histórico recente
appmenu-recently-closed-tabs =
    .label = Separadores fechados recentemente
appmenu-recently-closed-windows =
    .label = Janelas fechadas recentemente
# This allows to search through the browser's history.
appmenu-search-history =
    .label = Pesquisar histórico

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
    .label = Reportar problema no site…
appmenu-help-share-ideas =
    .label = Partilhe ideias e comentários…
    .accesskey = h
appmenu-help-switch-device =
    .label = A mudar para um dispositivo novo

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

appmenu-developer-tools-subheader = Ferramentas do navegador
appmenu-developer-tools-extensions =
    .label = Extensões para Programadores
