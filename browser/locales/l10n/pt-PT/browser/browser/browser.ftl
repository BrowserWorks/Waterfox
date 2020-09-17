# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
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
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
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

page-action-add-to-urlbar =
    .label = Adicionar à barra de endereço
page-action-manage-extension =
    .label = Gerir extensão…
page-action-remove-from-urlbar =
    .label = Remover da barra de endereço
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

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Desta vez, pesquisar com:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Alterar definições de pesquisa
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

bookmark-panel-show-editor-checkbox =
    .label = Mostrar o editor ao guardar
    .accesskey = s
bookmark-panel-done-button =
    .label = Feito
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Ligação insegura
identity-connection-secure = Ligação segura
identity-connection-internal = Esta é uma página segura do { -brand-short-name }.
identity-connection-file = Esta página está armazenada no seu computador.
identity-extension-page = Esta página está carregada a partir de uma extensão.
identity-active-blocked = O { -brand-short-name } bloqueou partes desta página que não são seguras.
identity-custom-root = Ligação verificada por um emissor de certificados que não é reconhecido pela Mozilla.
identity-passive-loaded = Partes desta página não são seguras (tais como imagens).
identity-active-loaded = Desativou a proteção nesta página.
identity-weak-encryption = Esta página utiliza encriptação fraca.
identity-insecure-login-forms = Credenciais introduzidas nesta página podem ser comprometidas.
identity-permissions =
    .value = Permissões
identity-permissions-reload-hint = Poderá ter de recarregar a página para as alterações se aplicarem.
identity-permissions-empty = Não concedeu quaisquer permissões especiais a este site.
identity-clear-site-data =
    .label = Limpar cookies e dados de sites…
identity-connection-not-secure-security-view = Não está ligado(a) de forma segura a este site.
identity-connection-verified = Está ligado(a) de forma segura a este site.
identity-ev-owner-label = Certificado emitido para:
identity-description-custom-root = A Mozilla não reconhece este emissor de certificados. Este pode ter sido adicionado a partir do seu sistema operativo ou por um administrador. <label data-l10n-name="link">Saber mais</label>
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

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Câmara a partilhar:
    .accesskey = C
popup-select-microphone =
    .value = Microfone a partilhar:
    .accesskey = M
popup-all-windows-shared = Serão partilhadas todas as janelas visíveis no seu ecrã.
popup-screen-sharing-not-now =
    .label = Agora não
    .accesskey = g
popup-screen-sharing-never =
    .label = Nunca permitir
    .accesskey = N
popup-silence-notifications-checkbox = Desativar notificações do { -brand-short-name } ao partilhar
popup-silence-notifications-checkbox-warning = O { -brand-short-name } não irá apresentar notificações enquanto estiver a partilhar.

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

urlbar-default-placeholder =
    .defaultPlaceholder = Pesquisar ou introduzir um endereço
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
urlbar-remote-control-notification-anchor =
    .tooltiptext = O navegador está sob controlo remoto
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
urlbar-pocket-button =
    .tooltiptext = Guardar no { -pocket-brand-name }

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
