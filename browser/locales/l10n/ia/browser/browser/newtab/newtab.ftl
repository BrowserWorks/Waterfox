# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Nove scheda
newtab-settings-button =
    .title = Personalisar tu pagina de nove scheda

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Cercar
    .aria-label = Cercar

newtab-search-box-search-the-web-text = Cercar in le Web
newtab-search-box-search-the-web-input =
    .placeholder = Cercar in le Web
    .title = Cercar in le Web
    .aria-label = Cercar in le Web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Adder un motor de recerca
newtab-topsites-add-topsites-header = Nove sito preferite
newtab-topsites-edit-topsites-header = Modificar le sito preferite
newtab-topsites-title-label = Titulo
newtab-topsites-title-input =
    .placeholder = Scriber un titulo

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Scriber o collar un URL
newtab-topsites-url-validation = Es necessari un URL valide

newtab-topsites-image-url-label = URL de imagine personal
newtab-topsites-use-image-link = Uso de imagine personal...
newtab-topsites-image-validation = Error durante le cargamento del imagine. Prova un altere URL.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Cancellar
newtab-topsites-delete-history-button = Deler del chronologia
newtab-topsites-save-button = Salvar
newtab-topsites-preview-button = Vista preliminar
newtab-topsites-add-button = Adder

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Desira tu vermente deler cata instantia de iste pagina de tu chronologia?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Iste action es irreversibile.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Aperir le menu
    .aria-label = Aperir le menu

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Remover
    .aria-label = Remover

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Aperir le menu
    .aria-label = Aperir le menu contextual pro { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Modificar iste sito
    .aria-label = Modificar iste sito

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Modificar
newtab-menu-open-new-window = Aperir in un nove fenestra
newtab-menu-open-new-private-window = Aperir in un nove fenestra private
newtab-menu-dismiss = Dimitter
newtab-menu-pin = Fixar
newtab-menu-unpin = Disfixar
newtab-menu-delete-history = Deler del chronologia
newtab-menu-save-to-pocket = Salvar in { -pocket-brand-name }
newtab-menu-delete-pocket = Deler de { -pocket-brand-name }
newtab-menu-archive-pocket = Archivar in { -pocket-brand-name }
newtab-menu-show-privacy-info = Nostre sponsores e tu vita private

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Facite
newtab-privacy-modal-button-manage = Gerer parametros de contento sponsorisate
newtab-privacy-modal-header = Tu vita private es importante.
newtab-privacy-modal-paragraph-2 = In addition a servir te historias captivante, nos te monstra anque contento pertinente e ben curate ab sponsores seligite. Sia assecurate que <strong>tu datos de navigation non essera jammais divulgate ab tu copia personal de { -brand-product-name }</strong>: nos non los vide, ni nostre sponsores.
newtab-privacy-modal-link = Saper plus sur le respecto del vita private in le pagina de nove scheda

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Remover le marcapaginas
# Bookmark is a verb here.
newtab-menu-bookmark = Adder marcapaginas

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Copiar le ligamine de discargamento
newtab-menu-go-to-download-page = Ir al pagina de discargamento
newtab-menu-remove-download = Remover del chronologia

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Monstrar in Finder
       *[other] Aperir le dossier que lo contine
    }
newtab-menu-open-file = Aperir le file

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Visitate
newtab-label-bookmarked = Marcapaginas addite
newtab-label-removed-bookmark = Marcapaginas removite
newtab-label-recommended = Tendentias
newtab-label-saved = Salvate in { -pocket-brand-name }
newtab-label-download = Discargate

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Sponsorisate

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Sponsorisate per { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Remover le section
newtab-section-menu-collapse-section = Collaber le section
newtab-section-menu-expand-section = Expander le section
newtab-section-menu-manage-section = Gerer le section
newtab-section-menu-manage-webext = Gerer extension
newtab-section-menu-add-topsite = Adder sito preferite
newtab-section-menu-add-search-engine = Adder un motor de recerca
newtab-section-menu-move-up = Mover in alto
newtab-section-menu-move-down = Mover in basso
newtab-section-menu-privacy-notice = Aviso de confidentialitate

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Collaber le section
newtab-section-expand-section-label =
    .aria-label = Expander le section

## Section Headers.

newtab-section-header-topsites = Sitos preferite
newtab-section-header-highlights = In evidentia
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Recommendate per { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Comencia a navigar e nos te monstrara hic alcunes del excellente articulos, videos e altere paginas que tu ha recentemente visitate o addite al marcapaginas.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Tu ja es toto al currente. Reveni plus tarde pro plus historias popular de { $provider }. Non vole attender? Selige un subjecto popular pro discoperir altere articulos interessante sur le web.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Il ha nihil plus!
newtab-discovery-empty-section-topstories-content = Reveni plus tarde pro leger altere articulos.
newtab-discovery-empty-section-topstories-try-again-button = Retentar
newtab-discovery-empty-section-topstories-loading = Cargamento…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Ups! Nos non ha potite cargar tote le articulos de iste section.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Subjectos popular:
newtab-pocket-more-recommendations = Altere recommendationes
newtab-pocket-learn-more = Saper plus
newtab-pocket-cta-button = Obtener { -pocket-brand-name }
newtab-pocket-cta-text = Salva le articulos que tu ama in { -pocket-brand-name }, e alimenta tu mente con lecturas fascinante.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Un error ha occurrite durante le cargamento de iste contento.
newtab-error-fallback-refresh-link = Refresca le pagina pro tentar de novo.
