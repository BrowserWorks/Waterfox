# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-page-title = Gestor de extras
search-header =
    .placeholder = Pesquisar addons.mozilla.org
    .searchbuttonlabel = Pesquisar
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = Obter extensões e temas em <a data-l10n-name="get-extensions">{ $domain }</a>
list-empty-installed =
    .value = Não tem instalado qualquer extra deste tipo
list-empty-available-updates =
    .value = Nenhuma atualização encontrada
list-empty-recent-updates =
    .value = Não atualizou quaisquer extras recentemente
list-empty-find-updates =
    .label = Procurar atualizações
list-empty-button =
    .label = Saber mais acerca dos extras
help-button = Apoio dos extras
sidebar-help-button-title =
    .title = Apoio dos extras
addons-settings-button = Definições do { -brand-short-name }
sidebar-settings-button-title =
    .title = Definições do { -brand-short-name }
show-unsigned-extensions-button =
    .label = Algumas extensões não foram verificadas
show-all-extensions-button =
    .label = Mostrar todas as extensões
detail-version =
    .label = Versão
detail-last-updated =
    .label = Última atualização
detail-contributions-description = O programador deste extra pede para o ajudar no desenvolvimento com uma pequena contribuição.
detail-contributions-button = Contribuir
    .title = Contribua para o desenvolvimento deste extra
    .accesskey = C
detail-update-type =
    .value = Atualizações automáticas
detail-update-default =
    .label = Predefinição
    .tooltiptext = Instalar atualizações automaticamente se for a predefinição
detail-update-automatic =
    .label = Ligadas
    .tooltiptext = Instalar atualizações automaticamente
detail-update-manual =
    .label = Desligadas
    .tooltiptext = Não instalar atualizações automaticamente
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Executar em janelas privadas
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Não permitido em janelas privadas
detail-private-disallowed-description2 = Esta extensão não é executada durante a navegação privada. <a data-l10n-name="learn-more">Saber mais</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Requer acesso a janelas privadas
detail-private-required-description2 = Esta extensão tem acesso às suas atividades on-line durante a navegação privada. <a data-l10n-name="learn-more">Saber mais</a>
detail-private-browsing-on =
    .label = Permitir
    .tooltiptext = Ativar em navegação privada
detail-private-browsing-off =
    .label = Não permitir
    .tooltiptext = Desativar em navegação privada
detail-home =
    .label = Página inicial
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Perfil do extra
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Procurar atualizações
    .accesskey = c
    .tooltiptext = Procurar atualizações para este extra
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
            [windows] Alterar opções deste extra
           *[other] Mudar as preferências deste extra
        }
detail-rating =
    .value = Avaliação
addon-restart-now =
    .label = Reiniciar agora
disabled-unsigned-heading =
    .value = Alguns extras foram desativados
disabled-unsigned-description = Os seguintes extras não foram verificados para utilização no { -brand-short-name }. Pode <label data-l10n-name="find-addons">encontrar substitutos</label> ou solicitar que o programador peça a sua verificação.
disabled-unsigned-learn-more = Saber mais acerca do nosso esforço para manter os utilizadores seguros.
disabled-unsigned-devinfo = Os programadores interessados em que o seus extras sejam verificados, devem ler o nosso <label data-l10n-name="learn-more">manual</label>.
plugin-deprecation-description = Falta alguma coisa? Alguns plugins deixaram de ser suportados pelo { -brand-short-name }. <label data-l10n-name="learn-more">Saber mais.</label>
legacy-warning-show-legacy = Mostrar extensões de legado
legacy-extensions =
    .value = Extensões de legado
legacy-extensions-description = Estas extensões não atendem aos padrões atuais do { -brand-short-name } por isso foram desativadas <label data-l10n-name="legacy-learn-more">Saber acerca das alterações aos extras</label>
private-browsing-description2 =
    O { -brand-short-name } está a mudar a maneira como as extensões funcionam na navegação privada. Quaisquer novas extensões que adicione ao
    { -brand-short-name } não serão executadas por predefinição em janelas privadas. A menos que permita isso nas definições, a
    extensão não irá funcionar durante a navegação privada e não irá ter acesso às suas atividades online
    lá. Fizemos esta alteração para manter a sua navegação privada, privada.
    <label data-l10n-name = "private-browsing-learn-more">Saber como gerir definições de extensões.</ label>
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

extensions-warning-safe-mode = Todos os extras foram desativados pelo modo de segurança.
extensions-warning-check-compatibility = A verificação de compatibilidade de extras está desativada. Poderá ter extras incompatíveis.
extensions-warning-check-compatibility-button = Ativar
    .title = Ativar verificação de compatibilidade de extras
extensions-warning-update-security = A verificação de compatibilidade de extras está desativada. Poderá estar comprometido com atualizações.
extensions-warning-update-security-button = Ativar
    .title = Ativar verificação de segurança de atualização do extra

## Strings connected to add-on updates

addon-updates-check-for-updates = Procurar atualizações
    .accesskey = c
addon-updates-view-updates = Ver atualizações recentes
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Atualizar extras automaticamente
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Repor atualização automática para todos os extras
    .accesskey = R
addon-updates-reset-updates-to-manual = Repor atualização manual para todos os extras
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = A atualizar extras
addon-updates-installed = Os seus extras foram atualizados.
addon-updates-none-found = Nenhuma atualização encontrada
addon-updates-manual-updates-found = Ver atualizações disponíveis

## Add-on install/debug strings for page options menu

addon-install-from-file = Instalar extra a partir de ficheiro…
    .accesskey = I
addon-install-from-file-dialog-title = Selecione o extra a instalar
addon-install-from-file-filter-name = Extras
addon-open-about-debugging = Depurar extras
    .accesskey = p

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Gerir atalhos de extensões
    .accesskey = s
shortcuts-no-addons = Não tem quaisquer extensões ativadas.
shortcuts-no-commands = As seguintes extensões não possuem atalhos:
shortcuts-input =
    .placeholder = Escrever um atalho
shortcuts-browserAction2 = Ativar botão da barra de ferramentas
shortcuts-pageAction = Ativar ação da página
shortcuts-sidebarAction = Alternar a barra lateral
shortcuts-modifier-mac = Incluir Ctrl, Alt ou ⌘
shortcuts-modifier-other = Incluir Ctrl ou Alt
shortcuts-invalid = Combinação inválida
shortcuts-letter = Escrever uma letra
shortcuts-system = Não é possível sobrepor um atalho do { -brand-short-name }
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Atalho duplicado
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } está a ser utilizado como um atalho em mais do que um caso. Atalhos duplicados podem causar comportamentos inesperados.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Já está em uso por { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Mostrar mais { $numberToShow }
       *[other] Mostrar mais { $numberToShow }
    }
shortcuts-card-collapse-button = Mostrar menos
header-back-button =
    .title = Retroceder

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    As extensões são como aplicações para o seu navegador, estas permitem-lhe
    proteger palavras-passe, transferir vídeos, encontrar ofertas, bloquear anúncios irritantes, alterar
    a aparência do seu navegador, e muito mais. Estes pequenos programas de software são
    muitas vezes programados por terceiros. Aqui está uma seleção que o { -brand-product-name }
    <a data-l10n-name="learn-more-trigger">recomenda</a> para segurança, desempenho e funcionalidade excecionais.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Algumas destas recomendações são personalizadas. Estas são baseadas noutras
    extensões que instalou, preferências de perfil e estatísticas de utilização.
discopane-notice-learn-more = Saber mais
privacy-policy = Política de privacidade
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = por <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Utilizadores: { $dailyUsers }
install-extension-button = Adicionar ao { -brand-product-name }
install-theme-button = Instalar tema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Gerir
find-more-addons = Encontrar mais extras
find-more-themes = Encontrar mais temas
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Mais opções

## Add-on actions

report-addon-button = Reportar
remove-addon-button = Remover
# The link will always be shown after the other text.
remove-addon-disabled-button = Não pode ser removido <a data-l10n-name="link">Porquê?</a>
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
release-notes-addon-button = Notas de lançamento
permissions-addon-button = Permissões
extension-enabled-heading = Ativada
extension-disabled-heading = Desativada
theme-enabled-heading = Ativado
theme-disabled-heading = Desativado
theme-monochromatic-heading = Esquemas de cor
theme-monochromatic-subheading = Novos esquemas de cor vibrantes do { -brand-product-name }. Disponível por tempo limitado.
plugin-enabled-heading = Ativado
plugin-disabled-heading = Desativado
dictionary-enabled-heading = Ativado
dictionary-disabled-heading = Desativado
locale-enabled-heading = Ativada
locale-disabled-heading = Desativada
always-activate-button = Ativar sempre
never-activate-button = Nunca ativar
addon-detail-author-label = Autor
addon-detail-version-label = Versão
addon-detail-last-updated-label = Última atualização
addon-detail-homepage-label = Página inicial
addon-detail-rating-label = Avaliação
# Message for add-ons with a staged pending update.
install-postponed-message = Esta extensão será atualizada quando o { -brand-short-name } for reiniciado.
install-postponed-button = Atualizar agora
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Avaliado com { NUMBER($rating, maximumFractionDigits: 1) } de 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (desativado)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } análise
       *[other] { $numberOfReviews } análises
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> foi removido.
pending-uninstall-undo-button = Desfazer
addon-detail-updates-label = Permitir atualizações automáticas
addon-detail-updates-radio-default = Predefinido
addon-detail-updates-radio-on = Ligado
addon-detail-updates-radio-off = Desligado
addon-detail-update-check-label = Procurar atualizações
install-update-button = Atualizar
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Permitido nas janelas privadas
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Quando permitido, a extensão irá ter acesso às suas atividades online durante a navegação privada. <a data-l10n-name="learn-more">Saber mais</a>
addon-detail-private-browsing-allow = Permitir
addon-detail-private-browsing-disallow = Não permitir

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = O { -brand-product-name } recomenda apenas as extensões que cumpram aos nossos padrões para segurança e desempenho.
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Waterfox" in the string below because the extensions are built
# by Waterfox and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Extensão oficial desenvolvida pela Waterfox. Cumpre as recomendações de segurança e de desempenho.
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = Esta extensão foi revista para cumprir com os nossos padrões de segurança e desempenho
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Atualizações disponíveis
recent-updates-heading = Atualizações recentes
release-notes-loading = A carregar…
release-notes-error = Desculpe mas ocorreu um erro ao carregar as notas de lançamento.
addon-permissions-empty = Esta extensão não requer quaisquer permissões
addon-permissions-required = Permissões necessárias para a funcionalidade principal:
addon-permissions-optional = Permissões opcionais para a funcionalidade adicionada:
addon-permissions-learnmore = Saber mais sobre permissões
recommended-extensions-heading = Extensões recomendadas
recommended-themes-heading = Temas recomendados
# A recommendation for the Waterfox Color theme shown at the bottom of the theme
# list view. The "Waterfox Color" name itself should not be translated.
recommended-theme-1 = A sentir-se criativo(a)? <a data-l10n-name="link">Crie o seu próprio tema com o Waterfox Color.</a>

## Page headings

extension-heading = Gira as suas extensões
theme-heading = Gira os seus temas
plugin-heading = Gira os seus plugins
dictionary-heading = Gira os seus dicionários
locale-heading = Gira os seus idiomas
updates-heading = Gerir as suas atualizações
discover-heading = Personalize o seu { -brand-short-name }
shortcuts-heading = Gira atalhos de extensões
default-heading-search-label = Encontrar mais extras
addons-heading-search-input =
    .placeholder = Pesquisar addons.mozilla.org
addon-page-options-button =
    .title = Ferramentas para todos os extras
