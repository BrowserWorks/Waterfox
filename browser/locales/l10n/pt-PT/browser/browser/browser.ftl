# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Waterfox"
# private - "Waterfox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (Navegação privada)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Navegação privada)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Waterfox"
# "private" - "Waterfox — (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (Navegação privada)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Navegação privada)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Ver informação do site

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Abrir painel de mensagem de instalação
urlbar-web-notification-anchor =
    .tooltiptext = Alterar se pode ou não receber notificações do site
urlbar-midi-notification-anchor =
    .tooltiptext = Abrir painel MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Gerir utilização de software DRM
urlbar-web-authn-anchor =
    .tooltiptext = Abrir painel de Autenticação Web
urlbar-canvas-notification-anchor =
    .tooltiptext = Gerir permissão de extração da tela
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Gerir a partilha do seu microfone com o site
urlbar-default-notification-anchor =
    .tooltiptext = Abrir painel de mensagem
urlbar-geolocation-notification-anchor =
    .tooltiptext = Abrir painel de solicitação de localização
urlbar-xr-notification-anchor =
    .tooltiptext = Abrir painel de permissão da realidade virtual
urlbar-storage-access-anchor =
    .tooltiptext = Abrir o painel de permissões da atividade de navegação
urlbar-translate-notification-anchor =
    .tooltiptext = Traduzir esta página
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Gerir a partilha das suas janelas ou ecrã com o site
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Abrir painel de mensagem de armazenamento offline
urlbar-password-notification-anchor =
    .tooltiptext = Abrir painel de mensagem de guardar palavra-passe
urlbar-translated-notification-anchor =
    .tooltiptext = Gerir tradução de páginas
urlbar-plugins-notification-anchor =
    .tooltiptext = Gerir utilização de plugins
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Gerir a partilha da sua câmara e/ou microfone com o site
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = Gerir a partilha de outros altifalantes com o site
urlbar-autoplay-notification-anchor =
    .tooltiptext = Abri painel de reprodução automática
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Armazenar dados em armazenamento persistente
urlbar-addons-notification-anchor =
    .tooltiptext = Abrir painel de mensagem de instalação de extra
urlbar-tip-help-icon =
    .title = Obter ajuda
urlbar-search-tips-confirm = Ok, entendi
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Dica:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Escreva menos, encontre mais: Pesquise no { $engineName } diretamente da sua barra de endereço.
urlbar-search-tips-redirect-2 = Comece a sua pesquisa na barra de endereço para ver sugestões do { $engineName } e do seu histórico de navegação.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Selecione este atalho para encontrar mais rapidamente o que precisa.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Marcadores
urlbar-search-mode-tabs = Separadores
urlbar-search-mode-history = Histórico

##

urlbar-geolocation-blocked =
    .tooltiptext = Bloqueou a informação de localização para este site.
urlbar-xr-blocked =
    .tooltiptext = Bloqueou o acesso ao dispositivo de realidade virtual para este website.
urlbar-web-notifications-blocked =
    .tooltiptext = Bloqueou as notificações para este site.
urlbar-camera-blocked =
    .tooltiptext = Bloqueou a sua câmara para este site.
urlbar-microphone-blocked =
    .tooltiptext = Bloqueou o seu microfone para este site.
urlbar-screen-blocked =
    .tooltiptext = Impediu este site de partilhar o seu ecrã.
urlbar-persistent-storage-blocked =
    .tooltiptext = Impediu o armazenamento de dados para este site.
urlbar-popup-blocked =
    .tooltiptext = Bloqueou pop-ups para este site.
urlbar-autoplay-media-blocked =
    .tooltiptext = Bloqueou a reprodução automática de multimédia para este site.
urlbar-canvas-blocked =
    .tooltiptext = Bloqueou a extração de dados do canvas para este site.
urlbar-midi-blocked =
    .tooltiptext = Bloqueou o acesso MIDI para este site.
urlbar-install-blocked =
    .tooltiptext = Bloqueou a instalação de extras para este site.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Editar este marcador ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Adicionar esta página aos marcadores ({ $shortcut })

## Page Action Context Menu

page-action-manage-extension =
    .label = Gerir extensão…
page-action-remove-extension =
    .label = Remover extensão

## Auto-hide Context Menu

full-screen-autohide =
    .label = Ocultar barras de ferramentas
    .accesskey = e
full-screen-exit =
    .label = Sair do modo de ecrã completo
    .accesskey = e

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = Desta vez, pesquisar com:
search-one-offs-change-settings-compact-button =
    .tooltiptext = Alterar definições de pesquisa
search-one-offs-context-open-new-tab =
    .label = Pesquisar num novo separador
    .accesskey = P
search-one-offs-context-set-as-default =
    .label = Definir como motor de pesquisa predefinido
    .accesskey = d
search-one-offs-context-set-as-default-private =
    .label = Definir como motor de pesquisa predefinido para as janelas privadas
    .accesskey = p
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = Adicionar o “{ $engineName }”
    .tooltiptext = Adicionar o motor de pesquisa do “{ $engineName }”
    .aria-label = Adicionar o motor de pesquisa do “{ $engineName }”
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Adicionar motor de pesquisa

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Marcadores ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Separadores ({ $restrict })
search-one-offs-history =
    .tooltiptext = Histórico ({ $restrict })

## Bookmark Panel

bookmarks-add-bookmark = Adicionar marcador
bookmarks-edit-bookmark = Editar marcador
bookmark-panel-cancel =
    .label = Cancelar
    .accesskey = C
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label =
        { $count ->
            [one] Remover marcador
           *[other] Remover { $count } marcadores
        }
    .accesskey = R
bookmark-panel-show-editor-checkbox =
    .label = Mostrar o editor ao guardar
    .accesskey = s
bookmark-panel-save-button =
    .label = Guardar
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Informação de site para { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = Segurança da ligação para { $host }
identity-connection-not-secure = Ligação insegura
identity-connection-secure = Ligação segura
identity-connection-failure = Falha de ligação
identity-connection-internal = Esta é uma página segura do { -brand-short-name }.
identity-connection-file = Esta página está armazenada no seu computador.
identity-extension-page = Esta página está carregada a partir de uma extensão.
identity-active-blocked = O { -brand-short-name } bloqueou partes desta página que não são seguras.
identity-custom-root = Ligação verificada por um emissor de certificados que não é reconhecido pela Waterfox.
identity-passive-loaded = Partes desta página não são seguras (tais como imagens).
identity-active-loaded = Desativou a proteção nesta página.
identity-weak-encryption = Esta página utiliza encriptação fraca.
identity-insecure-login-forms = Credenciais introduzidas nesta página podem ser comprometidas.
identity-https-only-connection-upgraded = (atualizado para HTTPS)
identity-https-only-label = Modo apenas HTTPS
identity-https-only-dropdown-on =
    .label = Ligado
identity-https-only-dropdown-off =
    .label = Desligado
identity-https-only-dropdown-off-temporarily =
    .label = Temporariamente desligado
identity-https-only-info-turn-on2 = Ative o modo Apenas HTTPS para este site se quiser que o { -brand-short-name } atualize para uma ligação segura sempre que for possível.
identity-https-only-info-turn-off2 = Se o site parecer estragado, pode querer desativar o modo Apenas HTTPS para este site para recarregar utilizando o HTTP não-seguro.
identity-https-only-info-no-upgrade = Não foi possível atualizar a ligação de HTTP.
identity-permissions-storage-access-header = Cookies inter-sites
identity-permissions-storage-access-hint = Estas entidades podem utilizar cookies inter-sites e dados do site enquanto estiver neste site.
identity-permissions-storage-access-learn-more = Saber mais
identity-permissions-reload-hint = Poderá ter de recarregar a página para as alterações se aplicarem.
identity-clear-site-data =
    .label = Limpar cookies e dados de sites…
identity-connection-not-secure-security-view = Não está ligado(a) de forma segura a este site.
identity-connection-verified = Está ligado(a) de forma segura a este site.
identity-ev-owner-label = Certificado emitido para:
identity-description-custom-root = A Waterfox não reconhece este emissor de certificados. Este pode ter sido adicionado a partir do seu sistema operativo ou por um administrador. <label data-l10n-name="link">Saber mais</label>
identity-remove-cert-exception =
    .label = Remover exceção
    .accesskey = R
identity-description-insecure = A sua ligação a este site não é privada. A informação que submeter pode ser vista por outros (tal como palavras-passe, mensagens, cartões de crédito, etc.).
identity-description-insecure-login-forms = As credenciais que introduzir nesta página podem não ser seguras e poderão ser comprometidas.
identity-description-weak-cipher-intro = A sua ligação a este site utiliza uma encriptação fraca e não é privada.
identity-description-weak-cipher-risk = Outras pessoas podem ver a sua informação ou modificar o comportamento do site.
identity-description-active-blocked = O { -brand-short-name } bloqueou partes desta página que não são seguras. <label data-l10n-name="link">Saber mais</label>
identity-description-passive-loaded = A sua ligação não é privada e a informação que partilha com o site pode ser vista por outros.
identity-description-passive-loaded-insecure = Este site contém conteúdo que não é seguro (tais como imagens). <label data-l10n-name="link">Saber mais</label>
identity-description-passive-loaded-mixed = Embora o { -brand-short-name } tenha bloqueado algum conteúdo, ainda há conteúdo na página que não é seguro (tal como imagens). <label data-l10n-name="link">Saber mais</label>
identity-description-active-loaded = Este site contém conteúdo que não é seguro (tal como scripts) e a sua ligação ao mesmo não é privada.
identity-description-active-loaded-insecure = A informação que partilhar com este site pode ser vista por outros (tal como palavras-passe, mensagens, cartões de crédito, etc.).
identity-learn-more =
    .value = Saber mais
identity-disable-mixed-content-blocking =
    .label = Desativar proteção por agora
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Ativar proteção
    .accesskey = e
identity-more-info-link-text =
    .label = Mais informação

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimizar
browser-window-maximize-button =
    .tooltiptext = Maximizar
browser-window-restore-down-button =
    .tooltiptext = Restaurar para baixo
browser-window-close-button =
    .tooltiptext = Fechar

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = A REPRODUZIR
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = SILENCIADO
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = REPRODUÇÃO AUTOMÁTICA BLOQUEADA
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = IMAGEM NA IMAGEM

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] SILENCIAR SEPARADOR
        [one] SILENCIAR SEPARADOR
       *[other] SILENCIAR { $count } SEPARADORES
    }
browser-tab-unmute =
    { $count ->
        [1] REPOR SOM NO SEPARADOR
        [one] REPOR SOM NO SEPARADOR
       *[other] REPOR SOM EM { $count } SEPARADORES
    }
browser-tab-unblock =
    { $count ->
        [1] REPRODUZIR SEPARADOR
        [one] REPRODUZIR SEPARADOR
       *[other] REPRODUZIR { $count } SEPARADORES
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = Importar marcadores…
    .tooltiptext = Importar marcadores de outro navegador para o { -brand-short-name }.
bookmarks-toolbar-empty-message = Para um acesso rápido, coloque os seus marcadores aqui, na barra de ferramentas de marcadores. <a data-l10n-name="manage-bookmarks">Gerir marcadores…</a>

## WebRTC Pop-up notifications

popup-select-camera-device =
    .value = Câmara:
    .accesskey = C
popup-select-camera-icon =
    .tooltiptext = Câmara
popup-select-microphone-device =
    .value = Microfone:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = Microfone
popup-select-speaker-icon =
    .tooltiptext = Colunas
popup-all-windows-shared = Serão partilhadas todas as janelas visíveis no seu ecrã.
popup-screen-sharing-block =
    .label = Bloquear
    .accesskey = B
popup-screen-sharing-always-block =
    .label = Bloquear sempre
    .accesskey = m
popup-mute-notifications-checkbox = Silenciar notificações de sites durante a partilha

## WebRTC window or screen share tab switch warning

sharing-warning-window = Está a partilhar o { -brand-short-name }. Outras pessoas podem ver quando muda para um novo separador.
sharing-warning-screen = Está a partilhar a totalidade do seu ecrã. Outras pessoas podem ver quando muda para um novo separador.
sharing-warning-proceed-to-tab =
    .label = Continuar para o separador
sharing-warning-disable-for-session =
    .label = Desativar a proteção da partilha para esta sessão

## DevTools F12 popup

enable-devtools-popup-description = Para utilizar o atalho F12, abra primeiro as DevTools via menu de Ferramentas de programação.

## URL Bar

# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Pesquisar ou introduzir um endereço
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Pesquisar na Internet
    .aria-label = Procurar com o { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Introduza os termos de pesquisa
    .aria-label = Procurar em { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Introduza os termos de pesquisa
    .aria-label = Procurar nos marcadores
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Introduza os termos de pesquisa
    .aria-label = Procurar no histórico
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Introduza os termos de pesquisa
    .aria-label = Procurar nos separadores
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Pesquisar com { $name } ou introduzir endereço
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = O navegador está sob controlo remoto (motivo: { $component })
urlbar-permissions-granted =
    .tooltiptext = Concedeu permissões adicionais a este site.
urlbar-switch-to-tab =
    .value = Mudar para o separador:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Extensão:
urlbar-go-button =
    .tooltiptext = Ir para o endereço da barra de localização
urlbar-page-action-button =
    .tooltiptext = Ações da página

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = Procurar com { $engine } numa Janela privada
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = Pesquisar numa janela privada
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = Pesquisar com { $engine }
urlbar-result-action-sponsored = Patrocinado
urlbar-result-action-switch-tab = Mudar para o separador
urlbar-result-action-visit = Visitar
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Pressione Tab para pesquisar com o { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Pressione Tab para pesquisar no { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = Pesquisar com o { $engine } diretamente da barra de endereço
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = Pesquisar o { $engine } diretamente da barra de endereço
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = Copiar
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = Pesquisar marcadores
urlbar-result-action-search-history = Pesquisar histórico
urlbar-result-action-search-tabs = Pesquisar separadores

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use title case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = Sugestões { $engine }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> está em ecrã completo
fullscreen-warning-no-domain = Este documento está no modo de ecrã completo
fullscreen-exit-button = Sair de ecrã completo (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Sair de ecrã completo (Esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> tem controlo do seu apontador. Pressione Esc para retomar o controlo.
pointerlock-warning-no-domain = Este documento tem controlo do seu apontador. Pressione Esc para retomar o controlo.

## Subframe crash notification

crashed-subframe-message = <strong>Uma parte desta página falhou.</strong> Para tornar o problema conhecido e ajudar a que o mesmo seja resolvido mais rapidamente no { -brand-product-name }, por favor submeta um relatório.
# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Uma parte desta página falhou. Para tornar o problema conhecido e ajudar a que o mesmo seja resolvido mais rapidamente no { -brand-product-name }, por favor submeta um relatório.
crashed-subframe-learnmore-link =
    .value = Saber mais
crashed-subframe-submit =
    .label = Submeter relatório
    .accesskey = S

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Gerir marcadores
bookmarks-recent-bookmarks-panel-subheader = Marcadores recentes
bookmarks-toolbar-chevron =
    .tooltiptext = Mostrar mais marcadores
bookmarks-sidebar-content =
    .aria-label = Marcadores
bookmarks-menu-button =
    .label = Menu de marcadores
bookmarks-other-bookmarks-menu =
    .label = Outros marcadores
bookmarks-mobile-bookmarks-menu =
    .label = Marcadores de dispositivo móvel
bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Ocultar barra lateral de marcadores
           *[other] Ver barra lateral de marcadores
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Ocultar barra de ferramentas de marcadores
           *[other] Ver barra de ferramentas de marcadores
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Ocultar barra de ferramentas de marcadores
           *[other] Mostrar barra de ferramentas de marcadores
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Remover menu de marcadores da barra de ferramentas
           *[other] Adicionar menu de marcadores à barra de ferramentas
        }
bookmarks-search =
    .label = Pesquisar marcadores
bookmarks-tools =
    .label = Ferramentas de marcadores
bookmarks-bookmark-edit-panel =
    .label = Editar este marcador
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Barra de ferramentas de marcadores
    .accesskey = B
    .aria-label = Marcadores
bookmarks-toolbar-menu =
    .label = Barra de ferramentas de marcadores
bookmarks-toolbar-placeholder =
    .title = Itens da barra de ferramentas marcadores
bookmarks-toolbar-placeholder-button =
    .label = Itens da barra de ferramentas marcadores
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-current-tab =
    .label = Adicionar separador aos marcadores

## Library Panel items

library-bookmarks-menu =
    .label = Marcadores
library-recent-activity-title =
    .value = Atividade recente

## Pocket toolbar button

save-to-pocket-button =
    .label = Guardar no { -pocket-brand-name }
    .tooltiptext = Guardar no { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Corrigir a codificação de texto
    .tooltiptext = Inferir a codificação de texto correta a partir do conteúdo da página

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = Extensões e temas
    .tooltiptext = Faça a gestão das suas extensões e temas ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Definições
    .tooltiptext =
        { PLATFORM() ->
            [macos] Abrir definições ({ $shortcut })
           *[other] Abrir definições
        }

## More items

more-menu-go-offline =
    .label = Trabalhar offline
    .accesskey = o
toolbar-overflow-customize-button =
    .label = Personalizar barra de ferramentas…
    .accesskey = P
toolbar-button-email-link =
    .label = Enviar por email
    .tooltiptext = Enviar ligação para esta página
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = Guardar página
    .tooltiptext = Guardar esta página ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = Abrir ficheiro
    .tooltiptext = Abrir um ficheiro ({ $shortcut })
toolbar-button-synced-tabs =
    .label = Separadores sincronizados
    .tooltiptext = Mostrar separadores de outros dispositivos
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = Nova janela privada
    .tooltiptext = Abrir uma nova janela de navegação privada ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = Algum áudio ou vídeo neste site utiliza software DRM, que poderá limitar as funcionalidades do que o { -brand-short-name } lhe pode deixar fazer com o mesmo.
eme-notifications-drm-content-playing-manage = Gerir definições
eme-notifications-drm-content-playing-manage-accesskey = M
eme-notifications-drm-content-playing-dismiss = Dispensar
eme-notifications-drm-content-playing-dismiss-accesskey = D

## Password save/update panel

panel-save-update-username = Nome de utilizador
panel-save-update-password = Palavra-passe

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Remover { $name }?
addon-removal-abuse-report-checkbox = Reportar esta extensão à { -vendor-short-name }

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = Gerir conta
remote-tabs-sync-now = Sincronizar agora

##

# "More" item in macOS share menu
menu-share-more =
    .label = Mais…
ui-tour-info-panel-close =
    .tooltiptext = Fechar

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = Permitir janelas de { $uriHost }
    .accesskey = p
popups-infobar-block =
    .label = Bloquear pop-ups de { $uriHost }
    .accesskey = p

##

popups-infobar-dont-show-message =
    .label = Não mostrar esta mensagem quando os pop-ups são bloqueados
    .accesskey = D
edit-popup-settings =
    .label = Gerir definições de popup
    .accesskey = G
picture-in-picture-hide-toggle =
    .label = Ocultar o comutador de vídeo em janela flutuante
    .accesskey = O

# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = Navegação
navbar-downloads =
    .label = Transferências
navbar-overflow =
    .tooltiptext = Mais ferramentas…
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = Imprimir
    .tooltiptext = Imprimir esta página… ({ $shortcut })
navbar-print-tab-modal-disabled =
    .label = Imprimir
    .tooltiptext = Imprimir esta página
navbar-home =
    .label = Início
    .tooltiptext = Página inicial do { -brand-short-name }
navbar-library =
    .label = Biblioteca
    .tooltiptext = Ver histórico, marcadores guardados, e mais
navbar-search =
    .title = Pesquisa
navbar-accessibility-indicator =
    .tooltiptext = Funcionalidades de acessibilidade ativadas
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = Separadores do navegador
tabs-toolbar-new-tab =
    .label = Novo separador
tabs-toolbar-list-all-tabs =
    .label = Listar todos os separadores
    .tooltiptext = Listar todos os separadores

## Infobar shown at startup to suggest session-restore

# <img data-l10n-name="icon"/> will be replaced by the application menu icon
restore-session-startup-suggestion-message = <strong>Reabrir os separadores anteriores?</strong> Pode restaurar a sua sessão antiga a partir do menu de aplicação do { -brand-short-name } <img data-l10n-name="icon"/>, em Histórico.
restore-session-startup-suggestion-button = Mostrar como
