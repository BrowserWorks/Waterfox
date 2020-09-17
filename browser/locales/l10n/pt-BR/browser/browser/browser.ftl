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
    .data-title-private = { -brand-full-name } (Navegação privativa)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Navegação privativa)
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
    .data-title-private = { -brand-full-name } - (Navegação privativa)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Navegação privativa)
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
    .tooltiptext = Alterar o recebimento de notificações do site
urlbar-midi-notification-anchor =
    .tooltiptext = Abrir o painel MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Gerenciar o uso de software DRM
urlbar-web-authn-anchor =
    .tooltiptext = Abrir painel de autenticação Web
urlbar-canvas-notification-anchor =
    .tooltiptext = Gerenciar permissão de extração de tela
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Gerenciar o compartilhamento do seu microfone com o site
urlbar-default-notification-anchor =
    .tooltiptext = Abrir painel de mensagens
urlbar-geolocation-notification-anchor =
    .tooltiptext = Abrir painel de solicitação de local
urlbar-xr-notification-anchor =
    .tooltiptext = Abrir painel de permissão de realidade virtual
urlbar-storage-access-anchor =
    .tooltiptext = Abrir o painel de permissões de atividade de navegação
urlbar-translate-notification-anchor =
    .tooltiptext = Traduzir esta página
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Gerenciar o compartilhamento de suas janelas ou tela com o site
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Abrir painel de mensagens de armazenamento local
urlbar-password-notification-anchor =
    .tooltiptext = Abrir painel de mensagem de senha salva
urlbar-translated-notification-anchor =
    .tooltiptext = Gerenciar tradução da página
urlbar-plugins-notification-anchor =
    .tooltiptext = Gerenciar plugin em uso
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Gerenciar o compartilhamento da sua câmera e/ou microfone com o site
urlbar-autoplay-notification-anchor =
    .tooltiptext = Abrir painel de reprodução automática
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Armazenar dados no armazenamento persistente
urlbar-addons-notification-anchor =
    .tooltiptext = Abrir painel de mensagem de instalação de extensões
urlbar-tip-help-icon =
    .title = Obter ajuda
urlbar-search-tips-confirm = OK, entendi
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Dica:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Digite menos, encontre mais: Pesquise no { $engineName } direto na barra de endereços.
urlbar-search-tips-redirect-2 = Inicie sua pesquisa na barra de endereços para ver sugestões do { $engineName } e do histórico de navegação.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Favoritos
urlbar-search-mode-tabs = Abas
urlbar-search-mode-history = Histórico

##

urlbar-geolocation-blocked =
    .tooltiptext = Você bloqueou informações de localização neste site.
urlbar-xr-blocked =
    .tooltiptext = Você bloqueou o acesso do dispositivo de realidade virtual a este site.
urlbar-web-notifications-blocked =
    .tooltiptext = Você bloqueou notificações deste site.
urlbar-camera-blocked =
    .tooltiptext = Você bloqueou sua câmera neste site.
urlbar-microphone-blocked =
    .tooltiptext = Você bloqueou seu microfone neste site.
urlbar-screen-blocked =
    .tooltiptext = Você bloqueou o compartilhamento de tela neste site.
urlbar-persistent-storage-blocked =
    .tooltiptext = Você bloqueou o armazenamento persistente deste site.
urlbar-popup-blocked =
    .tooltiptext = Você bloqueou abertura de janelas neste site.
urlbar-autoplay-media-blocked =
    .tooltiptext = Você bloqueou a reprodução automática de mídia com som neste site.
urlbar-canvas-blocked =
    .tooltiptext = Você bloqueou a extração de dados da tela neste site.
urlbar-midi-blocked =
    .tooltiptext = Você bloqueou o acesso a MIDI neste site.
urlbar-install-blocked =
    .tooltiptext = Você bloqueou a instalação de extensões deste site.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Editar este favorito ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Adicionar aos favoritos ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Adicionar à barra de endereços
page-action-manage-extension =
    .label = Gerenciar extensão…
page-action-remove-from-urlbar =
    .label = Remover da barra de endereços
page-action-remove-extension =
    .label = Remover extensão

## Auto-hide Context Menu

full-screen-autohide =
    .label = Ocultar barras de ferramentas
    .accesskey = O
full-screen-exit =
    .label = Sair do modo de tela inteira
    .accesskey = S

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Desta vez, pesquisar com:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Alterar configurações de pesquisa
search-one-offs-change-settings-compact-button =
    .tooltiptext = Alterar configurações de pesquisa
search-one-offs-context-open-new-tab =
    .label = Pesquisar em nova aba
    .accesskey = P
search-one-offs-context-set-as-default =
    .label = Definir como mecanismo de pesquisa padrão
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = Definir como mecanismo de pesquisa padrão em janelas privativas
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
    .tooltiptext = Favoritos ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Abas ({ $restrict })
search-one-offs-history =
    .tooltiptext = Histórico ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Exibir editor ao salvar
    .accesskey = S
bookmark-panel-done-button =
    .label = Concluído
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Conexão insegura
identity-connection-secure = Conexão segura
identity-connection-internal = Esta é uma página segura do { -brand-short-name }.
identity-connection-file = Esta página está armazenada no seu computador.
identity-extension-page = Esta página é carregada a partir de uma extensão.
identity-active-blocked = O { -brand-short-name } bloqueou partes não seguras desta página.
identity-custom-root = Conexão homologada por uma entidade certificadora que não é reconhecida pela Mozilla.
identity-passive-loaded = Partes desta página não são seguras (como imagens).
identity-active-loaded = Você desativou a proteção nesta página.
identity-weak-encryption = Esta página usa criptografia fraca.
identity-insecure-login-forms = As contas de acesso inseridas nesta página podem ser comprometidas.
identity-permissions =
    .value = Permissões
identity-permissions-reload-hint = Pode ser necessário recarregar a página para que as alterações sejam aplicadas.
identity-permissions-empty = Você não concedeu permissões especiais a este site.
identity-clear-site-data =
    .label = Limpar os cookies e dados do site…
identity-connection-not-secure-security-view = Você não está conectado com segurança a este site.
identity-connection-verified = Você está conectado com segurança a este site.
identity-ev-owner-label = Certificado emitido para:
identity-description-custom-root = A Mozilla não reconhece esta entidade certificadora. Ela pode ter sido adicionada pelo seu sistema operacional ou por um administrador. <label data-l10n-name="link">Saiba mais</label>
identity-remove-cert-exception =
    .label = Remover exceção
    .accesskey = R
identity-description-insecure = Sua conexão com este site não é privativa. As informações que enviar (como senhas, mensagens, cartões de créditos, etc) podem ser vistas por outros.
identity-description-insecure-login-forms = As informações de acesso que você inserir nesta página não estão seguras e podem ser comprometidas.
identity-description-weak-cipher-intro = Sua conexão com este site usa criptografia fraca e não é privativa.
identity-description-weak-cipher-risk = Outras pessoas podem ver as suas informações ou modificar o comportamento do site.
identity-description-active-blocked = O { -brand-short-name } bloqueou partes não seguras desta página. <label data-l10n-name="link">Saiba mais</label>
identity-description-passive-loaded = Sua conexão não é privativa e as informações que compartilhar com o site podem ser vistas por outros.
identity-description-passive-loaded-insecure = Este site tem conteúdo que não é seguro (como imagens). <label data-l10n-name="link">Saiba mais</label>
identity-description-passive-loaded-mixed = Apesar do { -brand-short-name } ter bloqueado algum conteúdo, ainda há elementos na página que não são seguros (como imagens). <label data-l10n-name="link">Saiba mais</label>
identity-description-active-loaded = Este site tem conteúdo que não é seguro (como scripts) e sua conexão com ele não é privativa.
identity-description-active-loaded-insecure = Informações que você compartilhar com este site (como senhas, mensagens, cartões de créditos, etc) podem ser vistas por terceiros.
identity-learn-more =
    .value = Saiba mais
identity-disable-mixed-content-blocking =
    .label = Desativar proteção por enquanto
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Ativar proteção
    .accesskey = e
identity-more-info-link-text =
    .label = Mais informações

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimizar
browser-window-maximize-button =
    .tooltiptext = Maximizar
browser-window-restore-down-button =
    .tooltiptext = Restaurar tamanho
browser-window-close-button =
    .tooltiptext = Fechar

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Câmera a compartilhar:
    .accesskey = C
popup-select-microphone =
    .value = Microfone a compartilhar:
    .accesskey = M
popup-all-windows-shared = Todas as janelas visíveis na sua tela serão compartilhadas.
popup-screen-sharing-not-now =
    .label = Agora não
    .accesskey = A
popup-screen-sharing-never =
    .label = Nunca permitir
    .accesskey = N
popup-silence-notifications-checkbox = Desativar notificação do { -brand-short-name } ao compartilhar
popup-silence-notifications-checkbox-warning = O { -brand-short-name } não exibirá notificações enquanto você estiver compartilhando.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Você está compartilhando o { -brand-short-name }. Outras pessoas podem ver quando você muda para outra aba.
sharing-warning-screen = Você está compartilhando sua tela inteira. Outras pessoas podem ver quando você muda para outra aba.
sharing-warning-proceed-to-tab =
    .label = Prosseguir para a aba
sharing-warning-disable-for-session =
    .label = Desativar a proteção de compartilhamento nesta sessão

## DevTools F12 popup

enable-devtools-popup-description = Para usar o atalho F12, primeiro abra as ferramentas de desenvolvimento através do menu Desenvolvimento web.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Pesquisar ou abrir endereço
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Pesquisar ou abrir endereço
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Pesquise na web
    .aria-label = Pesquisar com { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Digite termos de pesquisa
    .aria-label = Pesquisar { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Digite termos de pesquisa
    .aria-label = Pesquisar nos favoritos
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Digite termos de pesquisa
    .aria-label = Pesquisar no histórico
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Digite termos de pesquisa
    .aria-label = Pesquisar nas abas
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Pesquise com { $name } ou digite um endereço
urlbar-remote-control-notification-anchor =
    .tooltiptext = O navegador está sob controle remoto
urlbar-permissions-granted =
    .tooltiptext = Você concedeu permissões adicionais a este site.
urlbar-switch-to-tab =
    .value = Alternar para a aba:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Extensão:
urlbar-go-button =
    .tooltiptext = Abrir a página
urlbar-page-action-button =
    .tooltiptext = Ações da página
urlbar-pocket-button =
    .tooltiptext = Salvar no { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> está em tela inteira
fullscreen-warning-no-domain = Este documento está agora em tela inteira
fullscreen-exit-button = Sair da tela inteira (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Sair da tela inteira (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> tem controle de seu ponteiro. Pressione Esc para retomar o controle.
pointerlock-warning-no-domain = Este documento tem o controle do seu ponteiro. Pressionar Esc para retomar o controle.
