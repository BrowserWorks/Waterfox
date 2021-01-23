# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Waterfox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Nueva pestaña
newtab-settings-button =
    .title = Personalizar la página nueva pestaña

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Buscar
    .aria-label = Buscar

newtab-search-box-search-the-web-text = Buscar en la web
newtab-search-box-search-the-web-input =
    .placeholder = Buscar en la web
    .title = Buscar en la web
    .aria-label = Buscar en la web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Agregar buscador
newtab-topsites-add-topsites-header = Nuevo sitio más visitado
newtab-topsites-edit-topsites-header = Editar sitio más visitado
newtab-topsites-title-label = Título
newtab-topsites-title-input =
    .placeholder = Ingresar un título

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Escribir o pegar URL
newtab-topsites-url-validation = Se requiere URL válida

newtab-topsites-image-url-label = URL de Imagen personalizada
newtab-topsites-use-image-link = Usar imagen personalizada…
newtab-topsites-image-validation = La imagen no se pudo cargar. Pruebe una URL diferente.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Cancelar
newtab-topsites-delete-history-button = Borrar del historial
newtab-topsites-save-button = Guardar
newtab-topsites-preview-button = Vista previa
newtab-topsites-add-button = Agregar

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = ¿Está seguro de querer borrar cualquier instancia de esta página del historial?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Esta acción no puede deshacerse.

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
    .aria-label = Abrir el menú para { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Editar este sitio
    .aria-label = Editar este sitio

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Editar
newtab-menu-open-new-window = Abrir en nueva ventana
newtab-menu-open-new-private-window = Abrir en nueva ventana privada
newtab-menu-dismiss = Descartar
newtab-menu-pin = Pegar
newtab-menu-unpin = Despegar
newtab-menu-delete-history = Borrar del historial
newtab-menu-save-to-pocket = Guardar en { -pocket-brand-name }
newtab-menu-delete-pocket = Borrar de { -pocket-brand-name }
newtab-menu-archive-pocket = Archivar en { -pocket-brand-name }
newtab-menu-show-privacy-info = Nuestros patrocinadores y su privacidad

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Listo
newtab-privacy-modal-button-manage = Administrar la configuración de contenido patrocinado
newtab-privacy-modal-header = Su privacidad es importante.
newtab-privacy-modal-paragraph-2 =
    Además de ofrecer historias cautivadoras, también le vamos a mostrar información relevante,
    contenido sumamente revisado de patrocinadores seleccionados. No se preocupe, <strong>la seguridad de los datos de su navegación
     nunca dejan su copia personal de { -brand-product-name }: nosotros no la vemos y nuestros patrocinadores tampoco.
newtab-privacy-modal-link = Aprenda cómo funciona la privacidad en la pestaña nueva

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Eliminar marcador
# Bookmark is a verb here.
newtab-menu-bookmark = Marcador

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Copiar Dirección del enlace
newtab-menu-go-to-download-page = Ir a la página de descarga
newtab-menu-remove-download = Eliminar del Historial

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Mostrar en Finder
       *[other] Abrir Carpeta contenedora
    }
newtab-menu-open-file = Abrir Archivo

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Visitados
newtab-label-bookmarked = Marcados
newtab-label-removed-bookmark = Marcador eliminado
newtab-label-recommended = Tendencias
newtab-label-saved = Guardado en { -pocket-brand-name }
newtab-label-download = Descargada

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
newtab-section-menu-collapse-section = Colapsar sección
newtab-section-menu-expand-section = Expandir sección
newtab-section-menu-manage-section = Administrar sección
newtab-section-menu-manage-webext = Administrar extensión
newtab-section-menu-add-topsite = Agregar Sitio más visitado
newtab-section-menu-add-search-engine = Agregar buscador
newtab-section-menu-move-up = Subir
newtab-section-menu-move-down = Bajar
newtab-section-menu-privacy-notice = Nota de privacidad

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Contraer sección
newtab-section-expand-section-label =
    .aria-label = Expandir sección

## Section Headers.

newtab-section-header-topsites = Más visitados
newtab-section-header-highlights = Destacados
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Recomendado por { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Comenzá a navegar y te mostraremos algunos de los mejores artículos, videos y otras páginas que hayás visitado o marcado acá.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Ya te pusiste al día. Volvé más tarde para más historias de { $provider }. ¿No podés esperar? Seleccioná un tema popular para encontrar más historias de todo el mundo.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = ¡Estás atrapado!
newtab-discovery-empty-section-topstories-content = Revisá más tarde para ver si hay historias nuevas.
newtab-discovery-empty-section-topstories-try-again-button = Probar de nuevo
newtab-discovery-empty-section-topstories-loading = Cargando…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = ¡Uy! Casi cargamos esta sección, pero no del todo.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Tópicos populares:
newtab-pocket-more-recommendations = Más recomendaciones
newtab-pocket-learn-more = Conocer más
newtab-pocket-cta-button = Obtener { -pocket-brand-name }
newtab-pocket-cta-text = Guarde las historias que quiera en { -pocket-brand-name } y potencie su mente con lecturas fascinantes.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Epa, algo salió mal al cargar este contenido.
newtab-error-fallback-refresh-link = Refrescar la página para reintentar.
