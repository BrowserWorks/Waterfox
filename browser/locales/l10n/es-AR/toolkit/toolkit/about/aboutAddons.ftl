# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Administrador de complementos
addons-page-title = Administrador de complementos

search-header =
    .placeholder = Buscar en addons.mozilla.org
    .searchbuttonlabel = Buscar

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = No tiene instalado ningún complemento de este tipo

list-empty-available-updates =
    .value = No se encontraron actualizaciones

list-empty-recent-updates =
    .value = No hubo actualizaciones recientes de ningún complemento

list-empty-find-updates =
    .label = Buscar actualizaciones

list-empty-button =
    .label = Conocer más sobre complementos

help-button = Ayuda sobre complementos
sidebar-help-button-title =
    .title = Ayuda sobre complementos

preferences =
    { PLATFORM() ->
        [windows] Opciones de { -brand-short-name }
       *[other] Preferencias de { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Opciones de { -brand-short-name }
           *[other] Preferencias de { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = Algunos complementos no pudieron ser verificados

show-all-extensions-button =
    .label = Mostrar todos los complementos

cmd-show-details =
    .label = Mostrar más información
    .accesskey = s

cmd-find-updates =
    .label = Buscar actualizaciones
    .accesskey = B

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opciones
           *[other] Preferencias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }

cmd-enable-theme =
    .label = Usar tema
    .accesskey = U

cmd-disable-theme =
    .label = Dejar de usar tema
    .accesskey = u

cmd-install-addon =
    .label = Instalar
    .accesskey = I

cmd-contribute =
    .label = Contribuir
    .accesskey = C
    .tooltiptext = Contribuir al desarrollo de este complemento

detail-version =
    .label = Versión

detail-last-updated =
    .label = Última actualización

detail-contributions-description = El programador de este complemento pide que lo ayuden a mantener su desarrollo continuo mediante una pequeña contribución.

detail-contributions-button = Contribuir
    .title = Contribuir con el desarrollo de este complemento
    .accesskey = C

detail-update-type =
    .value = Actualización automática

detail-update-default =
    .label = Predeterminadas
    .tooltiptext = Instalar actualizaciones automáticas sólo si es la acción predeterminada

detail-update-automatic =
    .label = Sí
    .tooltiptext = Instalar actualizaciones automáticamente

detail-update-manual =
    .label = No
    .tooltiptext = No instalar actualizaciones automáticamente

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Ejecutar en ventanas privadas

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = No permitido en ventanas privadas
detail-private-disallowed-description2 = Esta extensión no se ejecuta en navegación privada. <a data-l10n-name="learn-more">Conocer más</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Requiere acceso a ventanas privadas
detail-private-required-description2 = Esta extensión tiene acceso a las actividades en línea mientras se está en navegación privada. <a data-l10n-name="learn-more">Conocer más</a>

detail-private-browsing-on =
    .label = Permitir
    .tooltiptext = Habilitar en navegación privada

detail-private-browsing-off =
    .label = No permitir
    .tooltiptext = Deshabilitar en navegación privada

detail-home =
    .label = Sitio web

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Perfil del complemento

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Buscar actualizaciones
    .accesskey = B
    .tooltiptext = Buscar actualizaciones para este complemento

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opciones
           *[other] Preferencias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Cambiar las opciones para este complemento
           *[other] Cambiar las preferencias para este complemento
        }

detail-rating =
    .value = Puntuación

addon-restart-now =
    .label = Reiniciar ahora

disabled-unsigned-heading =
    .value = Se deshabilitaron algunos complementos

disabled-unsigned-description = Los siguientes complementos no fueron verificados para usar en { -brand-short-name }. Puede <label data-l10n-name="find-addons">buscar reemplazos</label> o pedir al desarrollador que los haga verificar.

disabled-unsigned-learn-more = Conocer más sobre nuestros esfuerzos para ayudar a mantenerlo seguro mientras está en línea.

disabled-unsigned-devinfo = Los desarrolladores interesados en conseguir que sus complementos sean verificados pueden continuar leyendo nuestro <label data-l10n-name="learn-more">manual</label>.

plugin-deprecation-description = ¿Falta algo? Algunos plugins ya no son compatibles con { -brand-short-name }. <label data-l10n-name="learn-more">Conocer más.</label>

legacy-warning-show-legacy = Mostrar complementos heredados

legacy-extensions =
    .value = Complementos heredados

legacy-extensions-description = Estos complementos no cumplen los estándares actuales de { -brand-short-name } por lo que se desactivaron. <label data-l10n-name="legacy-learn-more">Conocer sobre los cambios en los complementos</label>

private-browsing-description2 =
    { -brand-short-name } está cambiando la forma en la que funcionan los complementos en la navegación privada. Cualquier nuevo complemento que agregue a
    { -brand-short-name } no se ejecutará de forma predeterminada en las ventanas privadas. A menos que lo permita en la configuración, el complemento no funcionará en la navegación privada, y no tendrá acceso a sus actividades en línea. Hicimos este cambio para mantener privada su navegación privada.
    <label data-l10n-name = "private-browsing-learn-more"> Aprenda cómo administrar la configuración del complemento. </label>

addon-category-discover = Recomendaciones
addon-category-discover-title =
    .title = Recomendaciones
addon-category-extension = Extensiones
addon-category-extension-title =
    .title = Extensiones
addon-category-theme = Temas
addon-category-theme-title =
    .title = Temas
addon-category-plugin = Plugins
addon-category-plugin-title =
    .title = Plugins
addon-category-dictionary = Diccionarios
addon-category-dictionary-title =
    .title = Diccionarios
addon-category-locale = Idiomas
addon-category-locale-title =
    .title = Idiomas
addon-category-available-updates = Actualizaciones disponibles
addon-category-available-updates-title =
    .title = Actualizaciones disponibles
addon-category-recent-updates = Actualizaciones recientes
addon-category-recent-updates-title =
    .title = Actualizaciones recientes

## These are global warnings

extensions-warning-safe-mode = Todos los complementos fueron deshabilitados por el Modo seguro.
extensions-warning-check-compatibility = La verificación de compatibilidad de los  complementos está deshabilitada. Puede tener complementos incompatibles.
extensions-warning-check-compatibility-button = Habilitar
    .title = Habilitar la verificación de la compatibilidad de los complementos
extensions-warning-update-security = La verificación de actualizaciones de seguridad de complementos está deshabilitada. Puede estar comprometido por las actualizaciones.
extensions-warning-update-security-button = Habilitar
    .title = Habilitar la verificación de las actualizaciones de seguridad


## Strings connected to add-on updates

addon-updates-check-for-updates = Buscar actualizaciones
    .accesskey = c
addon-updates-view-updates = Ver actualizaciones recientes
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Actualizar complementos automáticamente
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Reiniciar todos los complementos a actualización automática
    .accesskey = R
addon-updates-reset-updates-to-manual = Reiniciar todos los complementos a actualización manual
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = Actualizando complementos
addon-updates-installed = Se actualizaron sus complementos.
addon-updates-none-found = No se encontraron actualizaciones
addon-updates-manual-updates-found = Ver las actualizaciones disponibles

## Add-on install/debug strings for page options menu

addon-install-from-file = Instalar complemento desde archivo…
    .accesskey = I
addon-install-from-file-dialog-title = Selecionar complemento para instalar
addon-install-from-file-filter-name = Complemento
addon-open-about-debugging = Depurar complementos
    .accesskey = D

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Administrar los accesos directos del complemento
    .accesskey = S

shortcuts-no-addons = No tiene ningún complemento habilitado.
shortcuts-no-commands = Los siguientes complementos no tienen atajos de teclado:
shortcuts-input =
    .placeholder = Escriba un atajo

shortcuts-browserAction2 = Activar botón de barra de herramientas
shortcuts-pageAction = Activar Acción de la página
shortcuts-sidebarAction = Alternar la barra lateral

shortcuts-modifier-mac = Incluir Ctrl, Alt o ⌘
shortcuts-modifier-other = Incluir Ctrl o Alt
shortcuts-invalid = Combinación inválida
shortcuts-letter = Escriba una letra
shortcuts-system = No se puede anular un atajo de { -brand-short-name }

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Acceso directo duplicado

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = El { $shortcut } se está usando como atajo en más de un caso. Los accesos directos duplicados pueden causar un comportamiento inesperado.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Ya está en uso por { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Mostrar { $numberToShow } más
       *[other] Mostrar { $numberToShow } más
    }

shortcuts-card-collapse-button = Mostrar menos

header-back-button =
    .title = Retroceder

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Los complementos y los temas son como aplicaciones para el navegador y le permiten
    proteger sus contraseñas, descargar vídeos, encontrar ofertas, bloquear publicidad,
    cambiar la apariencia del navegador y mucho más. Suelen ser terceros los que generalmente desarrollan estos pequeños programas de software. Le ofrecemos una selección de { -brand-product-name }
    <a data-l10n-name="learn-more-trigger">recomendados</a> en seguridad, rendimiento
    y funcionalidad excepcionales.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = Algunas de estas recomendaciones son personalizadas. Se basan en otros complementos que tiene instalados, preferencias de su perfil y estadísticas de uso.
discopane-notice-learn-more = Conocer más

privacy-policy = Política de privacidad

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = por <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Usuarios: { $dailyUsers }
install-extension-button = Agregar a { -brand-product-name }
install-theme-button = Instalar tema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Administrar
find-more-addons = Buscar más complementos

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Más opciones

## Add-on actions

report-addon-button = Informar
remove-addon-button = Eliminar
# The link will always be shown after the other text.
remove-addon-disabled-button = No se puede eliminar <a data-l10n-name="link">¿Por qué?</a>
disable-addon-button = Deshabilitar
enable-addon-button = Habilitar
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Habilitar
preferences-addon-button =
    { PLATFORM() ->
        [windows] Opciones
       *[other] Preferencias
    }
details-addon-button = Detalles
release-notes-addon-button = Notas de la versión
permissions-addon-button = Permisos

extension-enabled-heading = Habilitado
extension-disabled-heading = Deshabilitado

theme-enabled-heading = Habilitado
theme-disabled-heading = Deshabilitado

plugin-enabled-heading = Habilitado
plugin-disabled-heading = Deshabilitado

dictionary-enabled-heading = Habilitado
dictionary-disabled-heading = Deshabilitado

locale-enabled-heading = Habilitado
locale-disabled-heading = Deshabilitado

ask-to-activate-button = Preguntar para activar
always-activate-button = Activar siempre
never-activate-button = No activar nunca

addon-detail-author-label = Autor
addon-detail-version-label = Versión
addon-detail-last-updated-label = Última actualización
addon-detail-homepage-label = Página de inicio
addon-detail-rating-label = Clasificación

# Message for add-ons with a staged pending update.
install-postponed-message = Esta extensión se actualizará cuando se reinicie { -brand-short-name }.
install-postponed-button = Actualizar ahora

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Calificación de { NUMBER($rating, maximumFractionDigits: 1) } sobre 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (deshabilitado)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } revisión
       *[other] { $numberOfReviews } revisiones
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = Se eliminó <span data-l10n-name="addon-name">{ $addon }</span>.
pending-uninstall-undo-button = Deshacer

addon-detail-updates-label = Permitir las actualizaciones automáticas
addon-detail-updates-radio-default = Predeterminado
addon-detail-updates-radio-on = Activado
addon-detail-updates-radio-off = Desactivar
addon-detail-update-check-label = Verificar si hay actualizaciones
install-update-button = Actualizar

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Permitida en ventanas privadas
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Cuando está activado, el complemento tendrá acceso a todo lo que hace mientras navega de forma privada. <a data-l10n-name="learn-more">Conozca más más</a>
addon-detail-private-browsing-allow = Permitir
addon-detail-private-browsing-disallow = No permitir

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } solo recomienda extensiones que cumplan con nuestros estándares de seguridad y rendimiento
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Actualizaciones disponibles
recent-updates-heading = Actualizaciones recientes

release-notes-loading = Cargando…
release-notes-error = Lo sentimos, pero hubo un error al cargar las notas de la versión.

addon-permissions-empty = Este complemento no requiere ningún permiso.

recommended-extensions-heading = Complementos recomendados
recommended-themes-heading = Temas recomendados

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = ¿Se siente creativo? <a data-l10n-name="link"> Cree su propio tema con Firefox Color. </a>

## Page headings

extension-heading = Administrar extensiones
theme-heading = Administrar temas
plugin-heading = Administrar plugins
dictionary-heading = Administrar diccionarios
locale-heading = Administrar idiomas
updates-heading = Administrar sus actualizaciones
discover-heading = Personalice su { -brand-short-name }
shortcuts-heading = Administrar Accesos directos de extensión

default-heading-search-label = Buscar más complementos
addons-heading-search-input =
    .placeholder = Buscar en addons.mozilla.org

addon-page-options-button =
    .title = Herramientas para todos los complementos
