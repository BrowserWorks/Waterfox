# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Gerenciador de extensões
addons-page-title = Gerenciador de extensões
search-header =
    .placeholder = Pesquisar em addons.mozilla.org
    .searchbuttonlabel = Pesquisar
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = Obtenha extensões e temas em <a data-l10n-name="get-extensions">{ $domain }</a>
list-empty-installed =
    .value = Não há nenhuma extensão deste tipo instalada
list-empty-available-updates =
    .value = Nenhuma atualização encontrada.
list-empty-recent-updates =
    .value = Você não atualizou recentemente nenhuma extensão
list-empty-find-updates =
    .label = Verificar se há atualizações
list-empty-button =
    .label = Saiba mais sobre extensões
help-button = Suporte para extensões
sidebar-help-button-title =
    .title = Suporte para extensões
preferences =
    { PLATFORM() ->
        [windows] Opções do { -brand-short-name }
       *[other] Preferências do { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Opções do { -brand-short-name }
           *[other] Preferências do { -brand-short-name }
        }
addons-settings-button = Configurações do { -brand-short-name }
sidebar-settings-button-title =
    .title = Configurações do { -brand-short-name }
show-unsigned-extensions-button =
    .label = Algumas extensões não puderam ser verificadas
show-all-extensions-button =
    .label = Mostrar todas as extensões
cmd-show-details =
    .label = Mostrar mais informações
    .accesskey = E
cmd-find-updates =
    .label = Procurar atualizações
    .accesskey = P
cmd-preferences =
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
cmd-enable-theme =
    .label = Aplicar tema
    .accesskey = A
cmd-disable-theme =
    .label = Stop Wearing Theme
    .accesskey = W
cmd-install-addon =
    .label = Instalar
    .accesskey = I
cmd-contribute =
    .label = Contribuir
    .accesskey = C
    .tooltiptext = Contribuir para o desenvolvimento desta extensão
detail-version =
    .label = Versão
detail-last-updated =
    .label = Última atualização
detail-contributions-description = O autor solicita o seu apoio no desenvolvimento através de uma pequena contribuição.
detail-contributions-button = Contribua
    .title = Contribua com o desenvolvimento desta extensão
    .accesskey = C
detail-update-type =
    .value = Atualização automática
detail-update-default =
    .label = Padrão
    .tooltiptext = Instalar atualizações automaticamente somente se isto for o padrão
detail-update-automatic =
    .label = Ativada
    .tooltiptext = Instalar atualizações automaticamente
detail-update-manual =
    .label = Desativada
    .tooltiptext = Não instalar atualizações automaticamente
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Funcionar em janelas privativas
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Não permitido em janelas privativas
detail-private-disallowed-description2 = Esta extensão fica desativada na navegação privativa. <a data-l10n-name="learn-more">Saiba mais</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Requer acesso a janelas privativas
detail-private-required-description2 = Esta extensão tem acesso à sua atividade online durante a navegação privativa. <a data-l10n-name="learn-more">Saiba mais</a>
detail-private-browsing-on =
    .label = Permitir
    .tooltiptext = Ativar na navegação privativa
detail-private-browsing-off =
    .label = Não permitir
    .tooltiptext = Desativar na navegação privativa
detail-home =
    .label = Site
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Perfil da extensão
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Verificar se há atualizações
    .accesskey = V
    .tooltiptext = Verificar se há atualizações para esta extensão
detail-show-preferences =
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
    .tooltiptext =
        { PLATFORM() ->
            [windows] Alterar as opções desta extensão
           *[other] Alterar as preferências desta extensão
        }
detail-rating =
    .value = Classificação
addon-restart-now =
    .label = Reiniciar agora
disabled-unsigned-heading =
    .value = Algumas extensões foram desativadas
disabled-unsigned-description = As seguintes extensões não foram verificadas para uso no { -brand-short-name }. Você pode <label data-l10n-name="find-addons">procurar substitutos</label> ou solicitar que o desenvolvedor peça a sua verificação.
disabled-unsigned-learn-more = Saiba mais sobre nossos esforços para ajudar a manter os usuários seguros.
disabled-unsigned-devinfo = Desenvolvedores interessados em ter suas extensões verificadas devem ler nosso <label data-l10n-name="learn-more">manual</label>.
plugin-deprecation-description = Faltando alguma coisa? Alguns plugins não são mais suportados pelo { -brand-short-name }. <label data-l10n-name="learn-more">Saiba mais.</label>
legacy-warning-show-legacy = Mostrar extensões legadas
legacy-extensions =
    .value = Extensões legadas
legacy-extensions-description = Estas extensões não cumprem os padrões atuais do { -brand-short-name }, então foram desativadas. <label data-l10n-name="legacy-learn-more">Saiba mais sobre mudanças em extensões</label>
private-browsing-description2 =
    O { -brand-short-name } está mudando o modo como extensões funcionam na navegação privativa. Qualquer nova extensão que você adicionar ao
    { -brand-short-name } por padrão não funcionará em janelas privativas. A menos que você permita nas configurações, a
    extensão não funcionará durante a navegação privativa e não terá acesso à sua atividade online.
    Fizemos esta alteração para assegurar sua navegação privativa.
    <label data-l10n-name="private-browsing-learn-more">Saiba como gerenciar configurações de extensões.</label>
addon-category-discover = Recomendações
addon-category-discover-title =
    .title = Recomendações
addon-category-extension = Extensões
addon-category-extension-title =
    .title = Extensões
addon-category-theme = Temas
addon-category-theme-title =
    .title = Temas
addon-category-plugin = Plugins
addon-category-plugin-title =
    .title = Plugins
addon-category-dictionary = Dicionários
addon-category-dictionary-title =
    .title = Dicionários
addon-category-locale = Idiomas
addon-category-locale-title =
    .title = Idiomas
addon-category-available-updates = Atualizações disponíveis
addon-category-available-updates-title =
    .title = Atualizações disponíveis
addon-category-recent-updates = Atualizações recentes
addon-category-recent-updates-title =
    .title = Atualizações recentes

## These are global warnings

extensions-warning-safe-mode = Todas as extensões foram desativadas pelo modo de segurança.
extensions-warning-check-compatibility = A verificação de compatibilidade de extensões está desativada. Você pode ter extensões incompatíveis.
extensions-warning-check-compatibility-button = Ativar
    .title = Ativar verificação de compatibilidade de extensões
extensions-warning-update-security = A verificação de segurança de atualizações de extensões está desativada. Atualizações de extensões podem comprometer seu computador.
extensions-warning-update-security-button = Ativar
    .title = Ativar verificação de segurança da atualização de extensões

## Strings connected to add-on updates

addon-updates-check-for-updates = Verificar se há atualizações
    .accesskey = V
addon-updates-view-updates = Ver atualizações recentes
    .accesskey = e

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Atualizar automaticamente
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Definir atualização automática de tudo
    .accesskey = D
addon-updates-reset-updates-to-manual = Definir atualização manual de tudo
    .accesskey = D

## Status messages displayed when updating add-ons

addon-updates-updating = Atualizando extensões
addon-updates-installed = Suas extensões foram atualizadas.
addon-updates-none-found = Nenhuma atualização encontrada
addon-updates-manual-updates-found = Ver atualizações disponíveis

## Add-on install/debug strings for page options menu

addon-install-from-file = Instalar de um arquivo…
    .accesskey = I
addon-install-from-file-dialog-title = Selecionar extensão para instalar
addon-install-from-file-filter-name = Extensões
addon-open-about-debugging = Depurar extensões
    .accesskey = x

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Gerenciar atalhos de extensões
    .accesskey = h
shortcuts-no-addons = Você não tem nenhuma extensão ativada.
shortcuts-no-commands = As seguintes extensões não têm atalhos de teclado:
shortcuts-input =
    .placeholder = Digite um atalho
shortcuts-browserAction2 = Ativar botão na barra de ferramentas
shortcuts-pageAction = Ativar ação de página
shortcuts-sidebarAction = Exibir/ocultar o painel lateral
shortcuts-modifier-mac = Incluir Ctrl, Alt ou ⌘
shortcuts-modifier-other = Incluir Ctrl ou Alt
shortcuts-invalid = Combinação inválida
shortcuts-letter = Digite uma letra
shortcuts-system = Não é possível substituir um atalho do { -brand-short-name }
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Atalho duplicado
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } está sendo usado como atalho em mais de um caso. Atalhos duplicados podem causar comportamento inesperado.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Já em uso por { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Mostrar mais { $numberToShow }
       *[other] Mostrar mais { $numberToShow }
    }
shortcuts-card-collapse-button = Mostrar menos
header-back-button =
    .title = Voltar

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Extensões e temas são como aplicativos para seu navegador. Eles permitem
    proteger senhas, baixar vídeos, encontrar ofertas, bloquear anúncios chatos,
    mudar a aparência do navegador e muito mais. Esses pequenos programas são
    geralmente desenvolvidos por terceiros. Aqui está uma seleção que o { -brand-product-name }
    <a data-l10n-name="learn-more-trigger">recomenda</a> por suas excepcionais características de segurança, desempenho e funcionalidade.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Algumas dessas recomendações são personalizadas. Elas são feitas com base 
    em outras extensões que você instalou, preferências de perfil e estatísticas de uso.
discopane-notice-learn-more = Saiba mais
privacy-policy = Política de privacidade
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = por <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Usuários: { $dailyUsers }
install-extension-button = Adicionar ao { -brand-product-name }
install-theme-button = Instalar tema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Gerenciar
find-more-addons = Encontrar mais extensões
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Mais opções

## Add-on actions

report-addon-button = Denunciar
remove-addon-button = Remover
# The link will always be shown after the other text.
remove-addon-disabled-button = Não pode ser removido <a data-l10n-name="link">Por quê?</a>
disable-addon-button = Desativar
enable-addon-button = Ativar
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Ativar
preferences-addon-button =
    { PLATFORM() ->
        [windows] Opções
       *[other] Preferências
    }
details-addon-button = Detalhes
release-notes-addon-button = Notas de atualização
permissions-addon-button = Permissões
extension-enabled-heading = Ativado
extension-disabled-heading = Desativado
theme-enabled-heading = Ativado
theme-disabled-heading = Desativado
plugin-enabled-heading = Ativado
plugin-disabled-heading = Desativado
dictionary-enabled-heading = Ativado
dictionary-disabled-heading = Desativado
locale-enabled-heading = Ativado
locale-disabled-heading = Desativado
ask-to-activate-button = Perguntar para ativar
always-activate-button = Sempre ativar
never-activate-button = Nunca ativar
addon-detail-author-label = Autor
addon-detail-version-label = Versão
addon-detail-last-updated-label = Última atualização
addon-detail-homepage-label = Página web
addon-detail-rating-label = Classificação
# Message for add-ons with a staged pending update.
install-postponed-message = Esta extensão será atualizada quando o { -brand-short-name } for reiniciado.
install-postponed-button = Atualizar agora
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Avaliação: { NUMBER($rating, maximumFractionDigits: 1) } de 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (desativado)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } avaliação
       *[other] { $numberOfReviews } avaliações
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> foi removido.
pending-uninstall-undo-button = Desfazer
addon-detail-updates-label = Atualização automática
addon-detail-updates-radio-default = Padrão
addon-detail-updates-radio-on = Ativada
addon-detail-updates-radio-off = Desativada
addon-detail-update-check-label = Procurar atualização
install-update-button = Atualizar
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Permitido em janelas privativas
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Com permissão, a extensão tem acesso à sua atividade online durante a navegação privativa. <a data-l10n-name="learn-more">Saiba mais</a>
addon-detail-private-browsing-allow = Permitir
addon-detail-private-browsing-disallow = Não permitir

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = O { -brand-product-name } só recomenda extensões que atendem aos nossos padrões de segurança e desempenho
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Mozilla" in the string below because the extensions are built
# by Mozilla and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Extensão oficial desenvolvida pela Mozilla. Atende aos padrões de desempenho e segurança
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = Esta extensão foi revisada para atender aos nossos padrões de segurança e desempenho.
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Atualizações disponíveis
recent-updates-heading = Atualizações recentes
release-notes-loading = Carregando…
release-notes-error = Desculpe, houve um erro ao carregar as notas de atualização.
addon-permissions-empty = Esta extensão não exige nenhum permissão
addon-permissions-required = Permissões necessárias para a funcionalidade principal:
addon-permissions-optional = Permissões opcionais para funcionalidades adicionais:
addon-permissions-learnmore = Saiba mais sobre permissões
recommended-extensions-heading = Extensões recomendadas
recommended-themes-heading = Temas recomendados
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Sentindo criatividade? <a data-l10n-name="link">Crie seu próprio tema com o Firefox Color.</a>

## Page headings

extension-heading = Gerenciamento de extensões
theme-heading = Gerenciamento de temas
plugin-heading = Gerenciamento de plugins
dictionary-heading = Gerenciamento de dicionários
locale-heading = Gerenciamento de idiomas
updates-heading = Gerencie suas atualizações
discover-heading = Personalize o { -brand-short-name }
shortcuts-heading = Gerenciar atalhos de extensões
default-heading-search-label = Encontrar mais extensões
addons-heading-search-input =
    .placeholder = Pesquisar em addons.mozilla.org
addon-page-options-button =
    .title = Ferramentas para todas as extensões
