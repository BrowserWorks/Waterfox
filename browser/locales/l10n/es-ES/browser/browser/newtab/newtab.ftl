# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Nueva pestaña
newtab-settings-button =
    .title = Personalizar la página Nueva pestaña
newtab-personalize-button-label = Personalizar
    .title = Personalizar la nueva pestaña
    .aria-label = Personalizar la nueva pestaña
newtab-personalize-dialog-label =
    .aria-label = Personalizar

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Buscar
    .aria-label = Buscar
newtab-search-box-search-the-web-text = Buscar en la Web
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = Buscar con { $engine } o introducir una dirección
newtab-search-box-handoff-text-no-engine = Buscar o escribir dirección
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = Buscar con { $engine } o introducir una dirección
    .title = Buscar con { $engine } o introducir una dirección
    .aria-label = Buscar con { $engine } o introducir una dirección
newtab-search-box-handoff-input-no-engine =
    .placeholder = Buscar o escribir dirección
    .title = Buscar o escribir dirección
    .aria-label = Buscar o escribir dirección
newtab-search-box-search-the-web-input =
    .placeholder = Buscar en la Web
    .title = Buscar en la Web
    .aria-label = Buscar en la Web
newtab-search-box-text = Buscar en la web
newtab-search-box-input =
    .placeholder = Buscar en la web
    .aria-label = Buscar en la web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Añadir motor de búsqueda
newtab-topsites-add-topsites-header = Nuevo sitio popular
newtab-topsites-add-shortcut-header = Nuevo acceso directo
newtab-topsites-edit-topsites-header = Editar sitio popular
newtab-topsites-edit-shortcut-header = Editar acceso directo
newtab-topsites-title-label = Título
newtab-topsites-title-input =
    .placeholder = Introducir título
newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Escribir o pegar una URL
newtab-topsites-url-validation = Se requiere una URL válida
newtab-topsites-image-url-label = URL de imagen personalizada
newtab-topsites-use-image-link = Utilizar una imagen personalizada…
newtab-topsites-image-validation = No se ha podido cargar la imagen. Pruebe con una URL diferente.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Cancelar
newtab-topsites-delete-history-button = Eliminar del historial
newtab-topsites-save-button = Guardar
newtab-topsites-preview-button = Vista preliminar
newtab-topsites-add-button = Agregar

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = ¿Está seguro de que quiere eliminar de su historial todas las instancias de esta página?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Esta acción no se puede deshacer.

## Top Sites - Sponsored label

newtab-topsite-sponsored = Patrocinado

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Abrir menú
    .aria-label = Abrir menú
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Eliminar
    .aria-label = Eliminar
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Abrir menú
    .aria-label = Abrir menú de contexto para { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Editar este sitio
    .aria-label = Editar este sitio

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Editar
newtab-menu-open-new-window = Abrir en una nueva ventana
newtab-menu-open-new-private-window = Abrir en una nueva ventana privada
newtab-menu-dismiss = Ignorar
newtab-menu-pin = Fijar
newtab-menu-unpin = Soltar
newtab-menu-delete-history = Eliminar del historial
newtab-menu-save-to-pocket = Guardar en { -pocket-brand-name }
newtab-menu-delete-pocket = Eliminar de { -pocket-brand-name }
newtab-menu-archive-pocket = Archivar en { -pocket-brand-name }
newtab-menu-show-privacy-info = Nuestros patrocinadores y su privacidad

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Hecho
newtab-privacy-modal-button-manage = Administrar la configuración de contenido patrocinado
newtab-privacy-modal-header = Su privacidad es importante.
newtab-privacy-modal-paragraph-2 = Además de ofrecer historias cautivadoras, también le mostramos contenido relevante y altamente revisado de patrocinadores seleccionados. Tenga la seguridad de que, <strong>sus datos de navegación nunca dejan su copia personal de { -brand-product-name }</strong>: nosotros no los vemos y nuestros patrocinadores tampoco.
newtab-privacy-modal-link = Conozca cómo funciona la privacidad en la nueva pestaña

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Eliminar marcador
# Bookmark is a verb here.
newtab-menu-bookmark = Marcador

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Copiar el enlace de descarga
newtab-menu-go-to-download-page = Ir a la página de descarga
newtab-menu-remove-download = Eliminar del historial

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Mostrar en Finder
       *[other] Abrir la carpeta que lo contiene
    }
newtab-menu-open-file = Abrir archivo

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Visitados
newtab-label-bookmarked = En marcadores
newtab-label-removed-bookmark = Marcador eliminado
newtab-label-recommended = Tendencias
newtab-label-saved = Guardado en { -pocket-brand-name }
newtab-label-download = Descargado
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Patrocinado
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Patrocinado por { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Eliminar sección
newtab-section-menu-collapse-section = Contraer sección
newtab-section-menu-expand-section = Expandir sección
newtab-section-menu-manage-section = Gestionar sección
newtab-section-menu-manage-webext = Gestionar extensión
newtab-section-menu-add-topsite = Añadir sitio popular
newtab-section-menu-add-search-engine = Añadir motor de búsqueda
newtab-section-menu-move-up = Subir
newtab-section-menu-move-down = Bajar
newtab-section-menu-privacy-notice = Aviso de privacidad

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Contraer sección
newtab-section-expand-section-label =
    .aria-label = Expandir sección

## Section Headers.

newtab-section-header-topsites = Sitios favoritos
newtab-section-header-highlights = Destacados
newtab-section-header-recent-activity = Actividad reciente
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Recomendado por { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Empiece a navegar y nosotros le mostraremos aquí algunos de los mejores artículos, videos y otras páginas que haya visitado recientemente o agregado a marcadores.
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Ya está al día. Vuelva luego y busque más historias de { $provider }. ¿No puede esperar? Seleccione un tema popular y encontrará más historias alucinantes por toda la web.

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = ¡Está al día!
newtab-discovery-empty-section-topstories-content = Vuelva más tarde para obtener más historias.
newtab-discovery-empty-section-topstories-try-again-button = Volver a intentarlo
newtab-discovery-empty-section-topstories-loading = Cargando...
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = ¡Ups! Casi se carga la sección al completo.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Temas populares:
newtab-pocket-more-recommendations = Más recomendaciones
newtab-pocket-learn-more = Saber más
newtab-pocket-cta-button = Obtener { -pocket-brand-name }
newtab-pocket-cta-text = Guarde en { -pocket-brand-name } las historias que le gustan y alimente su mente con lecturas fascinantes.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Lo sentimos, algo salió mal al cargar el contenido.
newtab-error-fallback-refresh-link = Recargue la página e inténtelo de nuevo.

## Customization Menu

newtab-custom-shortcuts-title = Accesos directos
newtab-custom-shortcuts-subtitle = Sitios que guarda o visita
newtab-custom-row-selector =
    { $num ->
        [one] { $num } fila
       *[other] { $num } filas
    }
newtab-custom-sponsored-sites = Accesos directos patrocinados
newtab-custom-pocket-title = Recomendado por { -pocket-brand-name }
newtab-custom-pocket-subtitle = Contenido excepcional seleccionado por { -pocket-brand-name }, parte de la familia { -brand-product-name }
newtab-custom-pocket-sponsored = Historias patrocinadas
newtab-custom-recent-title = Actividad reciente
newtab-custom-recent-subtitle = Una selección de sitios y contenidos recientes
newtab-custom-close-button = Cerrar
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
newtab-custom-snippets-title = Mensajes interactivos
newtab-custom-snippets-subtitle = Consejos y noticias de { -vendor-short-name } y { -brand-product-name }
newtab-custom-settings = Administrar más ajustes
