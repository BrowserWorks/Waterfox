# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Waterfox"
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
# "default" - "Waterfox"
# "private" - "Mozilla Firefox — (Private Browsing)"
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
    .tooltiptext = Abrir painel de requisição de localização
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

urlbar-search-tips-onboard = Digite menos, encontre mais. Pesquise no { $engineName } direto na barra de endereços.
urlbar-search-tips-redirect-2 = Inicie sua pesquisa na barra de endereços para ver sugestões do { $engineName } e do histórico de navegação.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Selecione este atalho para encontrar mais rápido o que você precisa.

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

# This string prompts the user to use the list of search shortcuts in
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
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = Adicionar “{ $engineName }”
    .tooltiptext = Adicionar mecanismo de pesquisa “{ $engineName }”
    .aria-label = Adicionar mecanismo de pesquisa “{ $engineName }”
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Adicionar mecanismo de pesquisa

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

bookmarks-add-bookmark = Adicionar favorito
bookmarks-edit-bookmark = Editar favorito
bookmark-panel-cancel =
    .label = Cancelar
    .accesskey = C
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label =
        { $count ->
            [one] Remover favorito
           *[other] Remover { $count } favoritos
        }
    .accesskey = E
bookmark-panel-show-editor-checkbox =
    .label = Exibir este painel ao adicionar um favorito
    .accesskey = x
bookmark-panel-done-button =
    .label = Concluído
bookmark-panel-save-button =
    .label = Salvar
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Informações do site { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = Segurança da conexão de { $host }
identity-connection-not-secure = Conexão não segura
identity-connection-secure = Conexão segura
identity-connection-failure = Falha na conexão
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
identity-https-only-connection-upgraded = (promovido a HTTPS)
identity-https-only-label = Modo somente HTTPS
identity-https-only-dropdown-on =
    .label = Ativado
identity-https-only-dropdown-off =
    .label = Desativado
identity-https-only-dropdown-off-temporarily =
    .label = Desativado temporariamente
identity-https-only-info-turn-on2 = Ative o modo somente HTTPS neste site se quiser que o { -brand-short-name } promova a conexão quando possível.
identity-https-only-info-turn-off2 = Se a página parecer não funcionar, você pode desativar o modo somente HTTPS neste site para recarregar usando HTTP não seguro.
identity-https-only-info-no-upgrade = Não foi possível promover a conexão de HTTP.
identity-permissions-storage-access-header = Cookies entre sites
identity-permissions-storage-access-hint = Essas partes podem usar cookies entre sites e dados do site enquanto você estiver nesse site.
identity-permissions-storage-access-learn-more = Saiba mais
identity-permissions-reload-hint = Pode ser necessário recarregar a página para que as alterações sejam aplicadas.
identity-permissions-empty = Você não concedeu permissões especiais a este site.
identity-clear-site-data =
    .label = Limpar cookies e dados de sites…
identity-connection-not-secure-security-view = Você não está conectado com segurança a este site.
identity-connection-verified = Você está conectado com segurança a este site.
identity-ev-owner-label = Certificado emitido para:
identity-description-custom-root = A Mozilla não reconhece esta entidade certificadora. Ela pode ter sido adicionada pelo seu sistema operacional ou por um administrador. <label data-l10n-name="link">Saiba mais</label>
identity-remove-cert-exception =
    .label = Remover exceção
    .accesskey = R
identity-description-insecure = Sua conexão com este site não é privativa. As informações que enviar (como senhas, mensagens, cartões de créditos, etc.) podem ser vistas por outros.
identity-description-insecure-login-forms = As informações de acesso que você inserir nesta página não estão seguras e podem ser comprometidas.
identity-description-weak-cipher-intro = Sua conexão com este site usa criptografia fraca e não é privativa.
identity-description-weak-cipher-risk = Outras pessoas podem ver as suas informações ou modificar o comportamento do site.
identity-description-active-blocked = O { -brand-short-name } bloqueou partes não seguras desta página. <label data-l10n-name="link">Saiba mais</label>
identity-description-passive-loaded = Sua conexão não é privativa e as informações que compartilhar com o site podem ser vistas por outros.
identity-description-passive-loaded-insecure = Este site tem conteúdo que não é seguro (como imagens). <label data-l10n-name="link">Saiba mais</label>
identity-description-passive-loaded-mixed = Apesar do { -brand-short-name } ter bloqueado algum conteúdo, ainda há elementos na página que não são seguros (como imagens). <label data-l10n-name="link">Saiba mais</label>
identity-description-active-loaded = Este site tem conteúdo que não é seguro (como scripts) e sua conexão com ele não é privativa.
identity-description-active-loaded-insecure = Informações que você compartilhar com este site (como senhas, mensagens, cartões de créditos, etc.) podem ser vistas por terceiros.
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

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = REPRODUZINDO
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = SEM SOM
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = REPRODUÇÃO AUTOMÁTICA BLOQUEADA
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = PICTURE-IN-PICTURE

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] SILENCIAR ABA
       *[other] SILENCIAR { $count } ABAS
    }
browser-tab-unmute =
    { $count ->
        [1] ATIVAR SOM DA ABA
       *[other] ATIVAR SOM DE { $count } ABAS
    }
browser-tab-unblock =
    { $count ->
        [1] REPRODUZIR ABA
       *[other] REPRODUZIR { $count } ABAS
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = Importar favoritos…
    .tooltiptext = Importar favoritos de outro navegador para o { -brand-short-name }.
bookmarks-toolbar-empty-message = Para acesso rápido, coloque seus favoritos aqui na barra de favoritos. <a data-l10n-name="manage-bookmarks">Gerenciar favoritos…</a>

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Câmera a compartilhar:
    .accesskey = C
popup-select-microphone =
    .value = Microfone a compartilhar:
    .accesskey = M
popup-select-camera-device =
    .value = Câmera:
    .accesskey = C
popup-select-camera-icon =
    .tooltiptext = Câmera
popup-select-microphone-device =
    .value = Microfone:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = Microfone
popup-select-speaker-icon =
    .tooltiptext = Saídas de áudio
popup-all-windows-shared = Todas as janelas visíveis na sua tela serão compartilhadas.
popup-screen-sharing-not-now =
    .label = Agora não
    .accesskey = A
popup-screen-sharing-never =
    .label = Nunca permitir
    .accesskey = N
popup-silence-notifications-checkbox = Desativar notificação do { -brand-short-name } ao compartilhar
popup-silence-notifications-checkbox-warning = O { -brand-short-name } não exibe notificações enquanto você está compartilhando.
popup-screen-sharing-block =
    .label = Bloquear
    .accesskey = B
popup-screen-sharing-always-block =
    .label = Sempre bloquear
    .accesskey = m
popup-mute-notifications-checkbox = Silenciar notificações de sites durante o compartilhamento

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
urlbar-remote-control-notification-anchor =
    .tooltiptext = O navegador está sob controle remoto
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
    .placeholder = Digite termos de busca
    .aria-label = Procurar favoritos
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
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = O navegador está sob controle remoto (motivo: { $component })
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

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = Pesquisar com { $engine } em uma janela privativa
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = Pesquisar em uma janela privativa
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = Pesquisar com { $engine }
urlbar-result-action-sponsored = Patrocinado
urlbar-result-action-switch-tab = Alternar para a aba
urlbar-result-action-visit = Visitar
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Pressione a tecla Tab para pesquisar usando { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Pressione a tecla Tab para pesquisar { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = Pesquisar com { $engine } diretamente na barra de endereços
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = Pesquisar com { $engine } diretamente na barra de endereços
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

urlbar-result-action-search-bookmarks = Procurar favoritos
urlbar-result-action-search-history = Pesquisar no histórico
urlbar-result-action-search-tabs = Pesquisar nas abas

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
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> tem controle de seu ponteiro. Tecle Esc para retomar o controle.
pointerlock-warning-no-domain = Este documento tem o controle do seu ponteiro. Pressionar Esc para retomar o controle.

## Subframe crash notification

crashed-subframe-message = <strong>Parte desta página travou.</strong> Para deixar o { -brand-product-name } ter conhecimento deste problema e corrigir mais rápido, envie um relato.
# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Parte desta página travou. Envie um relato para o { -brand-product-name } tomar conhecimento deste problema e corrigir mais rápido.
crashed-subframe-learnmore-link =
    .value = Saiba mais
crashed-subframe-submit =
    .label = Enviar relato
    .accesskey = E

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Gerenciar favoritos
bookmarks-recent-bookmarks-panel-subheader = Favoritos recentes
bookmarks-toolbar-chevron =
    .tooltiptext = Mostrar mais favoritos
bookmarks-sidebar-content =
    .aria-label = Favoritos
bookmarks-menu-button =
    .label = Menu de favoritos
bookmarks-other-bookmarks-menu =
    .label = Outros favoritos
bookmarks-mobile-bookmarks-menu =
    .label = Favoritos do celular
bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Ocultar painel de favoritos
           *[other] Exibir painel de favoritos
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Ocultar Barra de Favoritos
           *[other] Ver barra de favoritos
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Ocultar barra de favoritos
           *[other] Mostrar barra de favoritos
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Remover menu de favoritos da barra de ferramentas
           *[other] Adicionar menu de favoritos à barra de ferramentas
        }
bookmarks-search =
    .label = Procurar favoritos
bookmarks-tools =
    .label = Ferramentas de favoritos
bookmarks-bookmark-edit-panel =
    .label = Editar este favorito
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Barra de favoritos
    .accesskey = r
    .aria-label = Favoritos
bookmarks-toolbar-menu =
    .label = Barra de favoritos
bookmarks-toolbar-placeholder =
    .title = Itens da barra de favoritos
bookmarks-toolbar-placeholder-button =
    .label = Itens da barra de favoritos
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-current-tab =
    .label = Adicionar aba atual aos favoritos

## Library Panel items

library-bookmarks-menu =
    .label = Favoritos
library-recent-activity-title =
    .value = Atividade recente

## Pocket toolbar button

save-to-pocket-button =
    .label = Salvar no { -pocket-brand-name }
    .tooltiptext = Salvar no { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Reparar codificação de texto
    .tooltiptext = Estimar codificação de texto correta a partir do conteúdo da página

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = Extensões e temas
    .tooltiptext = Gerenciar extensões e temas ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Configurações
    .tooltiptext =
        { PLATFORM() ->
            [macos] Abrir configurações ({ $shortcut })
           *[other] Abrir configurações
        }

## More items

more-menu-go-offline =
    .label = Trabalhar offline
    .accesskey = o

## EME notification panel

eme-notifications-drm-content-playing = Algum áudio ou vídeo neste site usa software DRM, o que pode limitar o que o { -brand-short-name } pode deixar você fazer com ele.
eme-notifications-drm-content-playing-manage = Gerenciar configurações
eme-notifications-drm-content-playing-manage-accesskey = G
eme-notifications-drm-content-playing-dismiss = Descartar
eme-notifications-drm-content-playing-dismiss-accesskey = D

## Password save/update panel

panel-save-update-username = Nome de usuário
panel-save-update-password = Senha

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Remover { $name }?
addon-removal-abuse-report-checkbox = Denunciar esta extensão para a { -vendor-short-name }

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = Gerenciar conta
remote-tabs-sync-now = Sincronizar agora
