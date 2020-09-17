# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Nueva pestaña
newtab-settings-button =
    .title = Personaliza tu página de Nueva pestaña

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Buscar
    .aria-label = Buscar

newtab-search-box-search-the-web-text = Buscar en la Web
newtab-search-box-search-the-web-input =
    .placeholder = Buscar en la Web
    .title = Buscar en la Web
    .aria-label = Buscar en la Web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Añadir motor de búsqueda
newtab-topsites-add-topsites-header = Nuevo sitio frecuente
newtab-topsites-edit-topsites-header = Editar sitio frecuente
newtab-topsites-title-label = Título
newtab-topsites-title-input =
    .placeholder = Ingresar un título

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Escribe o pega una URL
newtab-topsites-url-validation = URL válida requerida

newtab-topsites-image-url-label = URL de imagen personalizada
newtab-topsites-use-image-link = Utilizar una imagen personalizada…
newtab-topsites-image-validation = Falló la carga de la imagen. Prueba una URL diferente.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Cancelar
newtab-topsites-delete-history-button = Eliminar del historial
newtab-topsites-save-button = Guardar
newtab-topsites-preview-button = Vista previa
newtab-topsites-add-button = Añadir

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = ¿Estás seguro de que quieres eliminar cada instancia de esta página de tu historial?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Esta acción no puede ser deshecha.

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
    .aria-label = Abrir menú contextual para { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Editar este sitio
    .aria-label = Editar este sitio

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Editar
newtab-menu-open-new-window = Abrir en una nueva ventana
newtab-menu-open-new-private-window = Abrir en una nueva ventana privada
newtab-menu-dismiss = Descartar
newtab-menu-pin = Fijar
newtab-menu-unpin = Soltar
newtab-menu-delete-history = Eliminar del historial
newtab-menu-save-to-pocket = Guardar en { -pocket-brand-name }
newtab-menu-delete-pocket = Eliminar de { -pocket-brand-name }
newtab-menu-archive-pocket = Archivar en { -pocket-brand-name }
newtab-menu-show-privacy-info = Nuestros patrocinadores y tu privacidad

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Hecho
newtab-privacy-modal-button-manage = Gestiona los ajustes de contenido patrocinado
newtab-privacy-modal-header = Tu privacidad importa.
newtab-privacy-modal-paragraph-2 = Junto con ofrecer historias cautivadoras, te mostramos contenido relevante y muy revisado de patrocinadores seleccionados. No te preocupes, <strong>tus datos de navegación jamás dejan tu copia personal de { -brand-product-name }</strong> — nosotros los vemos, y tampoco lo hacen nuestros patrocinadores.
newtab-privacy-modal-link = Aprende cómo funciona la privacidad en la nueva pestaña

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Remover marcador
# Bookmark is a verb here.
newtab-menu-bookmark = Marcador

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Copiar enlace de descarga
newtab-menu-go-to-download-page = Ir a la página de descarga
newtab-menu-remove-download = Eliminar del historial

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Mostrar en Finder
       *[other] Abrir carpeta contenedora
    }
newtab-menu-open-file = Abrir archivo

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Visitado
newtab-label-bookmarked = Marcado
newtab-label-removed-bookmark = Marcador eliminado
newtab-label-recommended = Popular
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
newtab-section-menu-manage-section = Gestionar secciones
newtab-section-menu-manage-webext = Gestionar extensión
newtab-section-menu-add-topsite = Añadir sitio frecuente
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

newtab-section-header-topsites = Sitios frecuentes
newtab-section-header-highlights = Destacados
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Recomendado por { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Empieza a navegar, y nosotros te mostraremos aquí algunos de los mejores artículos, videos y otras páginas que hayas visitado recientemente o marcado.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Te has puesto al día. Revisa más tarde para ver más historias de { $provider }. ¿No puedes esperar? Selecciona un tema popular para encontrar más historias de todo el mundo.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = ¡Estás al día!
newtab-discovery-empty-section-topstories-content = Revisa más tarde para nuevas historias.
newtab-discovery-empty-section-topstories-try-again-button = Volver a intentarlo
newtab-discovery-empty-section-topstories-loading = Cargando…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = ¡Chuta! Casi logramos cargar la sección completa, pero quizá falta una parte.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Temas populares:
newtab-pocket-more-recommendations = Más recomendaciones
newtab-pocket-learn-more = Aprender más
newtab-pocket-cta-button = Obtener { -pocket-brand-name }
newtab-pocket-cta-text = Guarda las historias que amas en { -pocket-brand-name }, y potencia tu mente con fascinantes lecturas.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Chuta, algo se fue a las pailas al cargar este contenido.
newtab-error-fallback-refresh-link = Recarga la página para volver a intentarlo.
