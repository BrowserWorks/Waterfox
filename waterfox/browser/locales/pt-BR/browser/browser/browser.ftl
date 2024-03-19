# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
# default - "Waterfox"
# private - "Waterfox (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = Navegação privativa do { -brand-full-name }
    .data-content-title-default = { $content-title } — { -brand-full-name }
    .data-content-title-private = { $content-title } — Navegação privativa do { -brand-full-name }
# These are the default window titles on macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
#
# "default" - "Waterfox"
# "private" - "Waterfox — (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Do not use the brand name in these, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } — Navegação privativa
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } — Navegação privativa
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }
# The non-variable portion of this MUST match the translation of
# "PRIVATE_BROWSING_SHORTCUT_TITLE" in custom.properties
private-browsing-shortcut-text-2 = Navegação privativa do { -brand-shortcut-name }

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
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Gerenciar o compartilhamento de suas janelas ou tela com o site
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Abrir painel de mensagens de armazenamento local
urlbar-password-notification-anchor =
    .tooltiptext = Abrir painel de mensagem de senha salva
urlbar-plugins-notification-anchor =
    .tooltiptext = Gerenciar uso de plugins
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Gerenciar o compartilhamento da sua câmera e/ou microfone com o site
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = Gerenciar o compartilhamento de outros dispositivos de áudio com o site
urlbar-autoplay-notification-anchor =
    .tooltiptext = Abrir painel de reprodução automática
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Armazenar dados no armazenamento persistente
urlbar-addons-notification-anchor =
    .tooltiptext = Abrir painel de mensagem de instalação de extensões
urlbar-tip-help-icon =
    .title = Obter ajuda
urlbar-search-tips-confirm = OK, entendi
urlbar-search-tips-confirm-short = Entendi
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Dica:
urlbar-result-menu-button =
    .title = Abrir menu
urlbar-result-menu-button-feedback = Opinião
    .title = Abrir menu
urlbar-result-menu-learn-more =
    .label = Saiba mais
    .accesskey = S
urlbar-result-menu-remove-from-history =
    .label = Remover do histórico
    .accesskey = R
urlbar-result-menu-tip-get-help =
    .label = Obter ajuda
    .accesskey = O

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Digite menos, encontre mais. Pesquise no { $engineName } direto na barra de endereços.
urlbar-search-tips-redirect-2 = Inicie sua pesquisa na barra de endereços para ver sugestões do { $engineName } e do histórico de navegação.
# Make sure to match the name of the Search panel in settings.
urlbar-search-tips-persist = Pesquisar ficou ainda mais simples. Experimente tornar sua pesquisa mais específica aqui na barra de endereços. Para mostrar o endereço em vez disso, vá nas configurações de pesquisa.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Selecione este atalho para encontrar mais rápido o que você precisa.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Favoritos
urlbar-search-mode-tabs = Abas
urlbar-search-mode-history = Histórico
urlbar-search-mode-actions = Ações

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
    .tooltiptext = Você bloqueou abertura de janelas ou abas neste site.
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

page-action-manage-extension2 =
    .label = Gerenciar extensão…
    .accesskey = e
page-action-remove-extension2 =
    .label = Remover extensão
    .accesskey = v

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
search-one-offs-actions =
    .tooltiptext = Ações ({ $restrict })

## QuickActions are shown in the urlbar as the user types a matching string
## The -cmd- strings are comma separated list of keywords that will match
## the action.

# Opens the about:addons page in the home / recommendations section
quickactions-addons = Ver extensões
quickactions-cmd-addons2 = extensões
# Opens the bookmarks library window
quickactions-bookmarks2 = Gerenciar favoritos
quickactions-cmd-bookmarks = favoritos
# Opens a SUMO article explaining how to clear history
quickactions-clearhistory = Limpar histórico
quickactions-cmd-clearhistory = limpar histórico
# Opens about:downloads page
quickactions-downloads2 = Ver arquivos baixados
quickactions-cmd-downloads = downloads
# Opens about:addons page in the extensions section
quickactions-extensions = Gerenciar extensões
quickactions-cmd-extensions = extensões
# Opens the devtools web inspector
quickactions-inspector2 = Abrir ferramentas de desenvolvimento
quickactions-cmd-inspector = inspetor, ferramentas de desenvolvimento
# Opens about:logins
quickactions-logins2 = Gerenciar senhas
quickactions-cmd-logins = contas, senhas
# Opens about:addons page in the plugins section
quickactions-plugins = Gerenciar plugins
quickactions-cmd-plugins = plugins
# Opens the print dialog
quickactions-print2 = Imprimir página
quickactions-cmd-print = imprimir
# Opens a new private browsing window
quickactions-private2 = Abrir janela privativa
quickactions-cmd-private = navegação privativa
# Opens a SUMO article explaining how to refresh
quickactions-refresh = Restaurar o { -brand-short-name }
quickactions-cmd-refresh = atualizar
# Restarts the browser
quickactions-restart = Reiniciar o { -brand-short-name }
quickactions-cmd-restart = reiniciar
# Opens the screenshot tool
quickactions-screenshot3 = Capturar tela
quickactions-cmd-screenshot = capturar tela
# Opens about:preferences
quickactions-settings2 = Gerenciar configurações
quickactions-cmd-settings = configurações, preferências, opções
# Opens about:addons page in the themes section
quickactions-themes = Gerenciar temas
quickactions-cmd-themes = temas
# Opens a SUMO article explaining how to update the browser
quickactions-update = Atualizar o { -brand-short-name }
quickactions-cmd-update = atualizar
# Opens the view-source UI with current pages source
quickactions-viewsource2 = Ver código-fonte da página
quickactions-cmd-viewsource = ver fonte, fonte
# Tooltip text for the help button shown in the result.
quickactions-learn-more =
    .title = Saiba mais sobre ações rápidas

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
    .title = Segurança da conexão com { $host }
identity-connection-not-secure = Conexão não segura
identity-connection-secure = Conexão segura
identity-connection-failure = Falha na conexão
identity-connection-internal = Esta é uma página segura do { -brand-short-name }.
identity-connection-file = Esta página está armazenada neste computador.
identity-extension-page = Esta página é carregada a partir de uma extensão.
identity-active-blocked = O { -brand-short-name } bloqueou partes não seguras desta página.
identity-custom-root = Conexão homologada por uma entidade certificadora que não é reconhecida pela BrowserWorks.
identity-passive-loaded = Partes desta página não são seguras (como imagens).
identity-active-loaded = Você desativou a proteção nesta página.
identity-weak-encryption = Esta página usa criptografia fraca.
identity-insecure-login-forms = As contas de acesso inseridas nesta página podem ser comprometidas.
identity-https-only-connection-upgraded = (promovido a HTTPS)
identity-https-only-label = Modo somente HTTPS
identity-https-only-label2 = Mudar automaticamente este site para uma conexão segura
identity-https-only-dropdown-on =
    .label = Ativado
identity-https-only-dropdown-off =
    .label = Desativado
identity-https-only-dropdown-off-temporarily =
    .label = Desativado temporariamente
identity-https-only-info-turn-on2 = Ative o modo somente HTTPS neste site se quiser que o { -brand-short-name } mude a conexão quando possível.
identity-https-only-info-turn-off2 = Se a página parecer não funcionar, você pode desativar o modo somente HTTPS neste site para recarregar usando HTTP não seguro.
identity-https-only-info-turn-on3 = Ative a mudança para HTTPS neste site se quiser que o { -brand-short-name } mude a conexão quando possível.
identity-https-only-info-turn-off3 = Se a página parecer não funcionar, você pode desativar a mudança para HTTPS para este site recarregar usando HTTP não seguro.
identity-https-only-info-no-upgrade = Não foi possível mudar a conexão de HTTP para HTTPS.
identity-permissions-storage-access-header = Cookies entre sites
identity-permissions-storage-access-hint = Essas partes podem usar cookies entre sites e dados do site enquanto você estiver nesse site.
identity-permissions-storage-access-learn-more = Saiba mais
identity-permissions-reload-hint = Pode ser necessário recarregar a página para que as alterações sejam aplicadas.
identity-clear-site-data =
    .label = Limpar cookies e dados de sites do domínio…
identity-connection-not-secure-security-view = Você não está conectado com segurança a este site.
identity-connection-verified = Você está conectado com segurança a este site.
identity-ev-owner-label = Certificado emitido para:
identity-description-custom-root2 = A BrowserWorks não reconhece esta entidade certificadora. Ela pode ter sido adicionada pelo seu sistema operacional ou por um administrador.
identity-remove-cert-exception =
    .label = Remover exceção
    .accesskey = R
identity-description-insecure = Sua conexão com este site não é privativa. As informações que enviar (como senhas, mensagens, cartões de créditos, etc.) podem ser vistas por outros.
identity-description-insecure-login-forms = As informações de acesso que você inserir nesta página não estão seguras e podem ser comprometidas.
identity-description-weak-cipher-intro = Sua conexão com este site usa criptografia fraca e não é privativa.
identity-description-weak-cipher-risk = Outras pessoas podem ver as suas informações ou modificar o comportamento do site.
identity-description-active-blocked2 = O { -brand-short-name } bloqueou partes não seguras desta página.
identity-description-passive-loaded = Sua conexão não é privativa e as informações que compartilhar com o site podem ser vistas por outros.
identity-description-passive-loaded-insecure2 = Este site tem conteúdo que não é seguro (como imagens).
identity-description-passive-loaded-mixed2 = Apesar do { -brand-short-name } ter bloqueado algum conteúdo, ainda há elementos na página que não são seguros (como imagens).
identity-description-active-loaded = Este site tem conteúdo que não é seguro (como scripts) e sua conexão com ele não é privativa.
identity-description-active-loaded-insecure = Informações que você compartilhar com este site (como senhas, mensagens, cartões de créditos, etc.) podem ser vistas por terceiros.
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
popup-select-window-or-screen =
    .label = Janela ou tela:
    .accesskey = J
popup-all-windows-shared = Todas as janelas visíveis na sua tela serão compartilhadas.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Você está compartilhando o { -brand-short-name }. Outras pessoas podem ver quando você muda para outra aba.
sharing-warning-screen = Você está compartilhando sua tela inteira. Outras pessoas podem ver quando você muda para outra aba.
sharing-warning-proceed-to-tab =
    .label = Prosseguir para a aba
sharing-warning-disable-for-session =
    .label = Desativar a proteção de compartilhamento nesta sessão

## DevTools F12 popup

enable-devtools-popup-description2 = Para usar o atalho F12, primeiro abra as ferramentas de desenvolvimento através do menu 'Ferramentas do navegador'.

## URL Bar

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
# This placeholder is used when searching quick actions.
urlbar-placeholder-search-mode-other-actions =
    .placeholder = Digite termos de pesquisa
    .aria-label = Ações de pesquisa
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
    .tooltiptext = Você definiu permissões neste site.
urlbar-switch-to-tab =
    .value = Mudar para aba:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Extensão:
urlbar-go-button =
    .tooltiptext = Abrir a página
urlbar-page-action-button =
    .tooltiptext = Ações da página

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
urlbar-result-action-switch-tab = Mudar para aba
urlbar-result-action-visit = Visitar
# Allows the user to visit a URL that was previously copied to the clipboard.
urlbar-result-action-visit-from-your-clipboard = Abrir endereço da área de transferência
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
urlbar-result-action-search-actions = Ações de pesquisa

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use sentence case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = Sugestões do { $engine }
# A label shown above Quick Actions in the urlbar results.
urlbar-group-quickactions =
    .label = Ações rápidas

## Reader View toolbar buttons

# This should match menu-view-enter-readerview in menubar.ftl
reader-view-enter-button =
    .aria-label = Ativar leitor
# This should match menu-view-close-readerview in menubar.ftl
reader-view-close-button =
    .aria-label = Desativar leitor

## Picture-in-Picture urlbar button
## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

picture-in-picture-urlbar-button-open =
    .tooltiptext = Abrir em picture-in-picture ({ $shortcut })
picture-in-picture-urlbar-button-close =
    .tooltiptext = Fechar picture-in-picture ({ $shortcut })
picture-in-picture-panel-header = Picture-in-Picture
picture-in-picture-panel-headline = Este site não recomenda usar picture-in-picture
picture-in-picture-panel-body = Os vídeos podem não ser exibidos como o desenvolvedor pretendia enquanto picture-in-picture estiver ativado.
picture-in-picture-enable-toggle =
    .label = Ativar assim mesmo

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

## Variables:
##   $isVisible (boolean): if the specific element (e.g. bookmarks sidebar,
##                         bookmarks toolbar, etc.) is visible or not.

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

##

bookmarks-search =
    .label = Procurar favoritos
bookmarks-tools =
    .label = Ferramentas de favoritos
bookmarks-subview-edit-bookmark =
    .label = Editar este favorito…
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
bookmarks-subview-bookmark-tab =
    .label = Adicionar aba atual aos favoritos…

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
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Configurações
    .tooltiptext =
        { PLATFORM() ->
            [macos] Abrir configurações ({ $shortcut })
           *[other] Abrir configurações
        }
toolbar-overflow-customize-button =
    .label = Personalizar barra de ferramentas…
    .accesskey = P
toolbar-button-email-link =
    .label = Enviar link por email
    .tooltiptext = Enviar link desta página por email
toolbar-button-logins =
    .label = Senhas
    .tooltiptext = Ver e gerenciar senhas salvas
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = Salvar página
    .tooltiptext = Salvar esta página ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = Abrir arquivo
    .tooltiptext = Abrir um arquivo ({ $shortcut })
toolbar-button-synced-tabs =
    .label = Abas sincronizadas
    .tooltiptext = Mostrar abas de outros dispositivos
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = Nova janela privativa
    .tooltiptext = Abrir uma nova janela de navegação privativa ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = Algum áudio ou vídeo neste site usa software DRM, o que pode limitar o que o { -brand-short-name } pode deixar você fazer com ele.
eme-notifications-drm-content-playing-manage = Gerenciar configurações
eme-notifications-drm-content-playing-manage-accesskey = G
eme-notifications-drm-content-playing-dismiss = Descartar
eme-notifications-drm-content-playing-dismiss-accesskey = D

## Password save/update panel

panel-save-update-username = Nome de usuário
panel-save-update-password = Senha

##

# "More" item in macOS share menu
menu-share-more =
    .label = Mais…
ui-tour-info-panel-close =
    .tooltiptext = Fechar

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = Permitir que { $uriHost } abra janelas ou abas
    .accesskey = P
popups-infobar-block =
    .label = Bloquear abertura de janelas ou abas de { $uriHost }
    .accesskey = B

##

popups-infobar-dont-show-message =
    .label = Não mostrar esta mensagem ao bloquear abertura de janelas ou abas
    .accesskey = N
edit-popup-settings =
    .label = Gerenciar configurações de abertura de janelas ou abas…
    .accesskey = G
picture-in-picture-hide-toggle =
    .label = Ocultar seletor de picture-in-picture
    .accesskey = O

## Since the default position for PiP controls does not change for RTL layout,
## right-to-left languages should use "Left" and "Right" as in the English strings,

picture-in-picture-move-toggle-right =
    .label = Mover o seletor de picture-in-picture para o lado direito
    .accesskey = d
picture-in-picture-move-toggle-left =
    .label = Mover o seletor de picture-in-picture para o lado esquerdo
    .accesskey = e

##


# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = Navegação
navbar-downloads =
    .label = Downloads
navbar-overflow =
    .tooltiptext = Menu expandido
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = Imprimir
    .tooltiptext = Imprimir esta página… ({ $shortcut })
navbar-home =
    .label = Página inicial
    .tooltiptext = Página inicial do { -brand-short-name }
navbar-library =
    .label = Biblioteca
    .tooltiptext = Ver histórico, favoritos salvos e muito mais
navbar-search =
    .title = Pesquisar
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = Abas do navegador
tabs-toolbar-new-tab =
    .label = Nova aba
tabs-toolbar-list-all-tabs =
    .label = Listar todas as abas
    .tooltiptext = Listar todas as abas

## Infobar shown at startup to suggest session-restore

# <img data-l10n-name="icon"/> will be replaced by the application menu icon
restore-session-startup-suggestion-message = <strong>Quer abrir abas anteriores?</strong> Você pode restaurar a sessão anterior através do menu <img data-l10n-name="icon"/> do { -brand-short-name }, em Histórico.
restore-session-startup-suggestion-button = Mostrar como fazer

## BrowserWorks data reporting notification (Telemetry, Waterfox Health Report, etc)

data-reporting-notification-message = O { -brand-short-name } envia alguns dados automaticamente para a { -vendor-short-name } para que possamos aprimorar sua experiência.
data-reporting-notification-button =
    .label = Escolher o que compartilhar
    .accesskey = E
# Label for the indicator shown in the private browsing window titlebar.
private-browsing-indicator-label = Navegação privativa

## Unified extensions (toolbar) button

unified-extensions-button =
    .label = Extensões
    .tooltiptext = Extensões

## Unified extensions button when permission(s) are needed.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-permissions-needed =
    .label = Extensões
    .tooltiptext =
        Extensões
        Permissões necessárias

## Unified extensions button when some extensions are quarantined.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-quarantined =
    .label = Extensões
    .tooltiptext =
        Extensões
        Algumas extensões não estão permitidas

## Autorefresh blocker

refresh-blocked-refresh-label = O { -brand-short-name } impediu que esta página fosse recarregada automaticamente.
refresh-blocked-redirect-label = O { -brand-short-name } impediu que esta página redirecionasse automaticamente para outra página.
refresh-blocked-allow =
    .label = Permitir
    .accesskey = P

## Waterfox Relay integration

firefox-relay-offer-why-to-use-relay = Nossas máscaras seguras e fáceis de usar protegem sua identidade e evitam spam, ocultando seu endereço de email.
# Variables:
#  $useremail (String): user email that will receive messages
firefox-relay-offer-what-relay-provides = Todos os emails enviados para suas máscaras de email são encaminhados para <strong>{ $useremail }</strong> (a menos que você decida bloquear).
firefox-relay-offer-legal-notice = Ao clicar em “Usar máscara de email”, você concorda com os <label data-l10n-name="tos-url">Termos do serviço</label> e o <label data-l10n-name="privacy-url">Aviso de privacidade </label>.

## Add-on Pop-up Notifications

popup-notification-addon-install-unsigned =
    .value = (Não verificado)
popup-notification-xpinstall-prompt-learn-more = Saiba mais sobre instalação de extensões com segurança

## Pop-up warning

# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-message =
    { $popupCount ->
        [one] O { -brand-short-name } impediu este site de abrir uma janela ou aba.
       *[other] O { -brand-short-name } impediu este site de abrir { $popupCount } janelas ou abas.
    }
# The singular form is left out for English, since the number of blocked pop-ups is always greater than 1.
# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-exceeded-message = O { -brand-short-name } impediu este site de abrir mais de { $popupCount } janelas ou abas.
popup-warning-button =
    .label =
        { PLATFORM() ->
            [windows] Opções
           *[other] Preferências
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
# Variables:
#   $popupURI (String): the URI for the pop-up window
popup-show-popup-menuitem =
    .label = Mostrar “{ $popupURI }”
