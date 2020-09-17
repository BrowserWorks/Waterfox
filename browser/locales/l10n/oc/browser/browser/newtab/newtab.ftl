# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Onglet novèl
newtab-settings-button =
    .title = Personalizar la pagina Onglet novèl

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Recercar
    .aria-label = Recercar

newtab-search-box-search-the-web-text = Recèrca sul web
newtab-search-box-search-the-web-input =
    .placeholder = Recèrca sul web
    .title = Recèrca sul web
    .aria-label = Recèrca sul web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Apondre un motor de recèrca
newtab-topsites-add-topsites-header = Noù site popular
newtab-topsites-edit-topsites-header = Modificar lo site popular
newtab-topsites-title-label = Títol
newtab-topsites-title-input =
    .placeholder = Picar un títol

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Picar o pegar una URL
newtab-topsites-url-validation = Una URLvalida es requesida

newtab-topsites-image-url-label = URL de l'imatge personalizat
newtab-topsites-use-image-link = Utilizar un imatge personalizat…
newtab-topsites-image-validation = L’imatge a pas capitat de se cargar. Ensajatz una URL diferenta.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Anullar
newtab-topsites-delete-history-button = Suprimir de l’istoric
newtab-topsites-save-button = Enregistrar
newtab-topsites-preview-button = Apercebut
newtab-topsites-add-button = Apondre

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Volètz vertadièrament suprimir l’istoric de totas las instàncias d’aquesta pagina ?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Impossible d'anullar aquesta accion.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Dobrir lo menú
    .aria-label = Dobrir lo menú

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Suprimir
    .aria-label = Suprimir

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Dobrir lo menú
    .aria-label = Dobrir lo menú contextual de { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Modificar aqueste site
    .aria-label = Modificar aqueste site

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Modificar
newtab-menu-open-new-window = Dobrir lo ligam dins una fenèstra novèla
newtab-menu-open-new-private-window = Dobrir lo ligam dins una fenèstra privada
newtab-menu-dismiss = Tirar
newtab-menu-pin = Penjar
newtab-menu-unpin = Despenjar
newtab-menu-delete-history = Suprimir de l’istoric
newtab-menu-save-to-pocket = Enregistrar dins { -pocket-brand-name }
newtab-menu-delete-pocket = Suprimir de { -pocket-brand-name }
newtab-menu-archive-pocket = Archivar dins { -pocket-brand-name }
newtab-menu-show-privacy-info = Nòstres esponsòrs e vòstra vida privada

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Acabat
newtab-privacy-modal-button-manage = Gerir los paramètres de contengut pairinejat
newtab-privacy-modal-header = Vòstra vida privada es importanta.
newtab-privacy-modal-paragraph-2 = En mai de contar d'istòrias pivelantas, vos mostram tanben de contengut pertinent e nautamant verificat d'esponsòrs seleccionats. Tranquilisatz-vos, <strong>vòstras donadas de navegacion sortisson pas jamai de vòstra còpia personala de { -brand-product-name } </strong> - la vejam pas, e tanpauc nòstres esponsòrs.
newtab-privacy-modal-link = Ne saber mai sul respècte de la vida privada dins un onglet novèl

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Suprimir lo marcapagina
# Bookmark is a verb here.
newtab-menu-bookmark = Marcar aquesta pagina

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Copiar lo ligam de telecargament
newtab-menu-go-to-download-page = Anar a la pagina de telecargament
newtab-menu-remove-download = Tirar de l’istoric

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Mostrar dins Finder
       *[other] Dobrir lo repertòri ont se tròba
    }
newtab-menu-open-file = Dobrir lo fichièr

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Visitat
newtab-label-bookmarked = Apondut als marcapaginas
newtab-label-removed-bookmark = Marcapaginas suprimit
newtab-label-recommended = Tendéncia
newtab-label-saved = Pagina enregistrada dins { -pocket-brand-name }
newtab-label-download = Telecargat

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Pairinejat

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Pairinejat per { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Suprimir la seccion
newtab-section-menu-collapse-section = Reduire la seccion
newtab-section-menu-expand-section = Desplegar la seccion
newtab-section-menu-manage-section = Gerir la seccion
newtab-section-menu-manage-webext = Gerir l’extension
newtab-section-menu-add-topsite = Apondre als sites populars
newtab-section-menu-add-search-engine = Apondre un motor de recèrca
newtab-section-menu-move-up = Desplaçar cap amont
newtab-section-menu-move-down = Desplaçar cap aval
newtab-section-menu-privacy-notice = Politica de confidencialitat

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Reduire la seccion
newtab-section-expand-section-label =
    .aria-label = Desplegar la seccion

## Section Headers.

newtab-section-header-topsites = Sites favorits
newtab-section-header-highlights = Notables
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Recomandat per { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Començatz de navegar e aquí vos mostrarem los melhors articles, vidèos e autras paginas qu’avètz visitadas o apondudas als marcapaginas.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Sètz a jorn. Tornatz mai tard per descobrir mai d’articles de tria de { $provider }. Podètz pas esperar ? Causissètz un subjècte popular per trapar mai d’aarticles d'interès sul Web.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Sètz ja a jorn.
newtab-discovery-empty-section-topstories-content = Tornatz mai tard per descobrir mai d’articles.
newtab-discovery-empty-section-topstories-try-again-button = Tornar ensajar
newtab-discovery-empty-section-topstories-loading = Cargament…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Ops ! Sembla qu’aquesta seccion es pas complètament cargada.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Tèmas populars :
newtab-pocket-more-recommendations = Mai de recomandacions
newtab-pocket-learn-more = Ne saber mai
newtab-pocket-cta-button = Installar { -pocket-brand-name }
newtab-pocket-cta-text = Enregistratz vòstres articles preferits dins { -pocket-brand-name } e garissètz vòstre esperit amb de lecturas fascinantas.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Ops, una error s’es producha en cargant aqueste contengut.
newtab-error-fallback-refresh-link = Actualizatz la pagina per tornar ensajar.
