# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] 1 mensaje no leído
       *[other] { $count } mensajes no leídos
    }

## Content tabs


## Toolbar

addons-and-themes-toolbarbutton =
    .label = Complementos y temas
    .tooltiptext = Administra tus complementos

quick-filter-toolbarbutton =
    .label = Filtro rápido
    .tooltiptext = Filtrar mensajes

## Folder Pane

folder-pane-header-label = Carpetas

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Ocultar barra de herramientas
    .accesskey = O

show-all-folders-label =
    .label = Todas las carpetas
    .accesskey = T

show-unread-folders-label =
    .label = Carpetas no leídas
    .accesskey = C

show-favorite-folders-label =
    .label = Carpetas favoritas
    .accesskey = C

show-recent-folders-label =
    .label = Carpetas recientes
    .accesskey = C

folder-toolbar-toggle-folder-compact-view =
    .label = Vista compacta
    .accesskey = C

## Menu


## AppMenu

# Since v89 we dropped the platforms distinction between Options or Preferences
# and consolidated everything with Preferences.
appmenu-preferences =
    .label = Preferencias

appmenu-addons-and-themes =
    .label = Complementos y temas

appmenu-help-enter-troubleshoot-mode =
    .label = Modo de resolución de problemas…

appmenu-help-exit-troubleshoot-mode =
    .label = Desactivar modo de resolución de problemas

appmenu-help-more-troubleshooting-info =
    .label = Más información sobre resolución de problemas

## Context menu


## Message header pane


## Action Button Context Menu

toolbar-context-menu-remove-extension =
    .label = Eliminar extensión
    .accesskey = E

## Message headers


## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = ¿Eliminar { $name }?
addon-removal-confirmation-button = Eliminar

caret-browsing-prompt-check-text = No volver a preguntar.

## no-reply handling

