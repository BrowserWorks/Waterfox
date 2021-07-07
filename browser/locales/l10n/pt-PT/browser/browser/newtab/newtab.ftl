# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Waterfox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Novo separador
newtab-settings-button =
    .title = Personalizar a sua página de novo separador
newtab-personalize-icon-label =
    .title = Personalizar novo separador
    .aria-label = Personalizar novo separador
newtab-personalize-dialog-label =
    .aria-label = Personalizar

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Pesquisar
    .aria-label = Pesquisar
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = Pesquisar com { $engine } ou introduzir endereço
newtab-search-box-handoff-text-no-engine = Pesquisar ou introduzir endereço
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = Pesquisar com { $engine } ou introduzir endereço
    .title = Pesquisar com { $engine } ou introduzir endereço
    .aria-label = Pesquisar com { $engine } ou introduzir endereço
newtab-search-box-handoff-input-no-engine =
    .placeholder = Pesquisar ou introduzir endereço
    .title = Pesquisar ou introduzir endereço
    .aria-label = Pesquisar ou introduzir endereço
newtab-search-box-search-the-web-input =
    .placeholder = Pesquisar na Web
    .title = Pesquisar na Web
    .aria-label = Pesquisar na Web
newtab-search-box-text = Pesquisar na Internet
newtab-search-box-input =
    .placeholder = Pesquisar na Internet
    .aria-label = Pesquisar na Internet

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Adicionar motor de pesquisa
newtab-topsites-add-topsites-header = Novo site mais visitado
newtab-topsites-add-shortcut-header = Novo atalho
newtab-topsites-edit-topsites-header = Editar site mais visitado
newtab-topsites-edit-shortcut-header = Editar atalho
newtab-topsites-title-label = Título
newtab-topsites-title-input =
    .placeholder = Digite um título
newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Digite ou cole um URL
newtab-topsites-url-validation = URL válido requerido
newtab-topsites-image-url-label = URL de imagem personalizada
newtab-topsites-use-image-link = Utilizar uma imagem personalizada…
newtab-topsites-image-validation = A imagem falhou o carregamento. Tente um URL diferente.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Cancelar
newtab-topsites-delete-history-button = Apagar do histórico
newtab-topsites-save-button = Guardar
newtab-topsites-preview-button = Pré-visualizar
newtab-topsites-add-button = Adicionar

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Tem a certeza que pretende eliminar todas as instâncias desta página do seu histórico?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Esta ação não pode ser anulada.

## Top Sites - Sponsored label

newtab-topsite-sponsored = Patrocinado

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Abrir menu
    .aria-label = Abrir menu
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Remover
    .aria-label = Remover
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Abrir menu
    .aria-label = Abrir menu de contexto para { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Editar este site
    .aria-label = Editar este site

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Editar
newtab-menu-open-new-window = Abrir numa nova janela
newtab-menu-open-new-private-window = Abrir numa nova janela privada
newtab-menu-dismiss = Dispensar
newtab-menu-pin = Afixar
newtab-menu-unpin = Desafixar
newtab-menu-delete-history = Apagar do histórico
newtab-menu-save-to-pocket = Guardar no { -pocket-brand-name }
newtab-menu-delete-pocket = Apagar do { -pocket-brand-name }
newtab-menu-archive-pocket = Arquivar no { -pocket-brand-name }
newtab-menu-show-privacy-info = Os nossos patrocinadores e a sua privacidade

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Concluído
newtab-privacy-modal-button-manage = Gerir configurações de conteúdo patrocinado
newtab-privacy-modal-header = As sua privacidade é importante.
newtab-privacy-modal-paragraph-2 =
    Para além de encontrar históricas cativantes, também lhe mostramos conteúdo relevante
    e altamente escrutinado a partir de patrocinadores selecionados. Fique descansado que <strong>os seus 
    dados de navegação nunca deixam a sua cópia pessoal do { -brand-product-name }</strong> — nem nós, 
    nem os nossos patrocinadores têm acesso a esses dados.
newtab-privacy-modal-link = Saiba como a privacidade funciona no novo separador

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Remover marcador
# Bookmark is a verb here.
newtab-menu-bookmark = Adicionar aos marcadores

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Copiar ligação da transferência
newtab-menu-go-to-download-page = Ir para a página da transferência
newtab-menu-remove-download = Remover do histórico

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Mostrar no Finder
       *[other] Abrir pasta de destino
    }
newtab-menu-open-file = Abrir ficheiro

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Visitados
newtab-label-bookmarked = Adicionados aos marcadores
newtab-label-removed-bookmark = Marcador removido
newtab-label-recommended = Tendência
newtab-label-saved = Guardado no { -pocket-brand-name }
newtab-label-download = Transferido
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Patrocinado
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Patrocinado por { $sponsor }
# This string is used under the image of story cards to indicate source and time to read
# Variables:
#  $source (String): This is the name of a company or their domain
#  $timeToRead (Number): This is the estimated number of minutes to read this story
newtab-label-source-read-time = { $source } · { $timeToRead } min

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Remover secção
newtab-section-menu-collapse-section = Colapsar secção
newtab-section-menu-expand-section = Expandir secção
newtab-section-menu-manage-section = Gerir secção
newtab-section-menu-manage-webext = Gerir extensão
newtab-section-menu-add-topsite = Adicionar site mais visitado
newtab-section-menu-add-search-engine = Adicionar motor de pesquisa
newtab-section-menu-move-up = Mover para cima
newtab-section-menu-move-down = Mover para baixo
newtab-section-menu-privacy-notice = Aviso de privacidade

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Colapsar secção
newtab-section-expand-section-label =
    .aria-label = Expandir secção

## Section Headers.

newtab-section-header-topsites = Sites mais visitados
newtab-section-header-highlights = Destaques
newtab-section-header-recent-activity = Atividade recente
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Recomendado por { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Comece a navegar, e iremos mostrar-lhe alguns dos ótimos artigos, vídeos, e outras páginas que visitou recentemente ou adicionou aos marcadores aqui.
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Já apanhou tudo. Verifique mais tarde para mais histórias principais de { $provider }. Não pode esperar? Selecione um tópico popular para encontrar mais boas histórias de toda a web.

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Está em dia!
newtab-discovery-empty-section-topstories-content = Volte mais tarde para mais histórias.
newtab-discovery-empty-section-topstories-try-again-button = Tentar novamente
newtab-discovery-empty-section-topstories-loading = A carregar…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Oops! Quase carregámos esta secção, por pouco.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Tópicos populares:
newtab-pocket-new-topics-title = Quer ainda mais histórias? Consulte estes tópicos populares do { -pocket-brand-name }
newtab-pocket-more-recommendations = Mais recomendações
newtab-pocket-learn-more = Saber mais
newtab-pocket-cta-button = Obter o { -pocket-brand-name }
newtab-pocket-cta-text = Guarde as histórias que adora no { -pocket-brand-name }, e abasteça a sua mente com leituras fascinantes.
newtab-pocket-pocket-firefox-family = O { -pocket-brand-name } faz parte da família { -brand-product-name }
# A save to Pocket button that shows over the card thumbnail on hover.
newtab-pocket-save-to-pocket = Guardar no { -pocket-brand-name }
newtab-pocket-saved-to-pocket = Guardado no { -pocket-brand-name }
# This is a button shown at the bottom of the Pocket section that loads more stories when clicked.
newtab-pocket-load-more-stories-button = Carreguar mais histórias

## Pocket Final Card Section.
## This is for the final card in the Pocket grid.

newtab-pocket-last-card-title = Está atualizado!
newtab-pocket-last-card-desc = Volte mais tarde para mais.
newtab-pocket-last-card-image =
    .alt = Está atualizado

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Oops, algo correu mal ao carregar este conteúdo.
newtab-error-fallback-refresh-link = Atualize a página para tentar novamente.

## Customization Menu

newtab-custom-shortcuts-title = Atalhos
newtab-custom-shortcuts-subtitle = Sites que guarda ou visita
newtab-custom-row-selector =
    { $num ->
        [one] { $num } linha
       *[other] { $num } linhas
    }
newtab-custom-sponsored-sites = Atalhos patrocinados
newtab-custom-pocket-title = Recomendado por { -pocket-brand-name }
newtab-custom-pocket-subtitle = Conteúdo excecional com curadoria de { -pocket-brand-name }, parte da família { -brand-product-name }
newtab-custom-pocket-sponsored = Histórias patrocinadas
newtab-custom-recent-title = Atividade recente
newtab-custom-recent-subtitle = Uma seleção de sites e conteúdos recentes
newtab-custom-close-button = Fechar
newtab-custom-settings = Gerir mais configurações
