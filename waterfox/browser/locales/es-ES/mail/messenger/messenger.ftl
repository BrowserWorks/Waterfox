# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Window controls

messenger-window-minimize-button =
    .tooltiptext = Minimizar
messenger-window-maximize-button =
    .tooltiptext = Maximizar
messenger-window-restore-down-button =
    .tooltiptext = Restaurar
messenger-window-close-button =
    .tooltiptext = Cerrar
# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] 1 mensaje no leído
       *[other] { $count } mensajes no leídos
    }
about-rights-notification-text = { -brand-short-name } es software libre y de código abierto, creado por una comunidad de miles de personas en todo el mundo.

## Content tabs

content-tab-page-loading-icon =
    .alt = La página está cargando
content-tab-security-high-icon =
    .alt = La conexión es segura
content-tab-security-broken-icon =
    .alt = La conexión no es segura

## Toolbar

addons-and-themes-toolbarbutton =
    .label = Complementos y temas
    .tooltiptext = Administre sus complementos
quick-filter-toolbarbutton =
    .label = Filtro rápido
    .tooltiptext = Filtrar mensajes
redirect-msg-button =
    .label = Redirigir
    .tooltiptext = Redirige el mensaje seleccionado

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Barra de herramientas del panel de carpetas
    .accesskey = p
folder-pane-toolbar-options-button =
    .tooltiptext = Opciones del panel de carpetas
folder-pane-header-label = Carpetas

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Ocultar la barra de herramientas
    .accesskey = O
show-all-folders-label =
    .label = Todas las carpetas
    .accesskey = T
show-unread-folders-label =
    .label = Carpetas no leídas
    .accesskey = n
show-favorite-folders-label =
    .label = Carpetas favoritas
    .accesskey = f
show-smart-folders-label =
    .label = Carpetas unificadas
    .accesskey = u
show-recent-folders-label =
    .label = Carpetas recientes
    .accesskey = r
folder-toolbar-toggle-folder-compact-view =
    .label = Vista compacta
    .accesskey = c

## Menu

redirect-msg-menuitem =
    .label = Redirigir
    .accesskey = R
menu-file-save-as-file =
    .label = Archivo…
    .accesskey = A

## AppMenu

appmenu-save-as-file =
    .label = Archivo…
appmenu-settings =
    .label = Ajustes
appmenu-addons-and-themes =
    .label = Complementos y temas
appmenu-help-enter-troubleshoot-mode =
    .label = Modo de resolución de problemas…
appmenu-help-exit-troubleshoot-mode =
    .label = Desactivar el modo de resolución de problemas
appmenu-help-more-troubleshooting-info =
    .label = Más información sobre la resolución de problemas
appmenu-redirect-msg =
    .label = Redirigir

## Context menu

context-menu-redirect-msg =
    .label = Redirigir
mail-context-delete-messages =
    .label =
        { $count ->
            [one] Eliminar mensaje seleccionado
           *[other] Eliminar mensajes seleccionados
        }
context-menu-decrypt-to-folder =
    .label = Copiar como descifrado a
    .accesskey = i

## Message header pane

other-action-redirect-msg =
    .label = Redirigir
message-header-msg-flagged =
    .title = Con estrella
    .aria-label = Con estrella
# Variables:
# $address (String) - The email address of the recipient this picture belongs to.
message-header-recipient-avatar =
    .alt = Foto de perfil de { $address }.

## Message header cutomize panel

message-header-customize-panel-title = Configuración del encabezado del mensaje
message-header-customize-button-style =
    .value = Estilo de botón
    .accesskey = E
message-header-button-style-default =
    .label = Iconos y texto
message-header-button-style-text =
    .label = Texto
message-header-button-style-icons =
    .label = Iconos
message-header-show-sender-full-address =
    .label = Mostrar siempre la dirección completa del remitente
    .accesskey = i
message-header-show-sender-full-address-description = La dirección de correo electrónico se mostrará debajo del nombre para mostrar.
message-header-show-recipient-avatar =
    .label = Mostrar la foto de perfil del remitente
    .accesskey = p
message-header-hide-label-column =
    .label = Ocultar la columna de etiquetas
    .accesskey = l
message-header-large-subject =
    .label = Tema grande
    .accesskey = T

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Gestionar extensión
    .accesskey = e
toolbar-context-menu-remove-extension =
    .label = Eliminar extensión
    .accesskey = n

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = ¿Eliminar { $name }?
addon-removal-confirmation-button = Eliminar
addon-removal-confirmation-message = ¿Eliminar { $name } así como su configuración y datos de { -brand-short-name }?
caret-browsing-prompt-title = Navegación con cursor
caret-browsing-prompt-text = Presionando F7 se activa o desactiva la navegación con cursor. Esta característica coloca un cursor móvil dentro de algunos contenidos, lo que le permite seleccionar texto con el teclado. ¿Desea activar la navegación con cursor?
caret-browsing-prompt-check-text = No volver a preguntar.
repair-text-encoding-button =
    .label = Reparar la codificación de texto
    .tooltiptext = Adivina la codificación correcta del texto desde el contenido del mensaje

## no-reply handling

no-reply-title = Respuesta no admitida
no-reply-message = La dirección de respuesta ({ $email }) no parece que sea una dirección supervisada. Es probable que nadie lea los mensajes enviados a esta dirección.
no-reply-reply-anyway-button = Responder de todas formas

## error messages

decrypt-and-copy-failures = No se han podido descifrar { $failures } de { $total } mensajes y no se han copiado.

## Spaces toolbar

spaces-toolbar-element =
    .toolbarname = Barra de herramientas de espacios
    .aria-label = Barra de herramientas de espacios
    .aria-description = Barra de herramientas vertical para cambiar entre los diferentes espacios. Use las teclas de navegación para ver los botones disponibles.
spaces-toolbar-button-mail2 =
    .title = Correo
spaces-toolbar-button-address-book2 =
    .title = Libreta de direcciones
spaces-toolbar-button-calendar2 =
    .title = Calendario
spaces-toolbar-button-tasks2 =
    .title = Tareas
spaces-toolbar-button-chat2 =
    .title = Chat
spaces-toolbar-button-overflow =
    .title = Más espacios…
spaces-toolbar-button-settings2 =
    .title = Ajustes
spaces-toolbar-button-hide =
    .title = Ocultar la barra de herramientas de espacios
spaces-toolbar-button-show =
    .title = Mostrar la barra de herramientas de espacios
spaces-context-new-tab-item =
    .label = Abrir en una pestaña nueva
spaces-context-new-window-item =
    .label = Abrir en una ventana nueva
# Variables:
# $tabName (String) - The name of the tab this item will switch to.
spaces-context-switch-tab-item =
    .label = Cambiar a { $tabName }
settings-context-open-settings-item2 =
    .label = Ajustes
settings-context-open-account-settings-item2 =
    .label = Configuración de la cuenta
settings-context-open-addons-item2 =
    .label = Complementos y temas

## Spaces toolbar pinned tab menupopup

spaces-toolbar-pinned-tab-button =
    .tooltiptext = Menú de espacios
spaces-pinned-button-menuitem-mail2 =
    .label = { spaces-toolbar-button-mail2.title }
spaces-pinned-button-menuitem-address-book2 =
    .label = { spaces-toolbar-button-address-book2.title }
spaces-pinned-button-menuitem-calendar2 =
    .label = { spaces-toolbar-button-calendar2.title }
spaces-pinned-button-menuitem-tasks2 =
    .label = { spaces-toolbar-button-tasks2.title }
spaces-pinned-button-menuitem-chat2 =
    .label = { spaces-toolbar-button-chat2.title }
spaces-pinned-button-menuitem-settings2 =
    .label = { spaces-toolbar-button-settings2.title }
spaces-pinned-button-menuitem-show =
    .label = { spaces-toolbar-button-show.title }
# Variables:
# $count (Number) - Number of unread messages.
chat-button-unread-messages = { $count }
    .title =
        { $count ->
            [one] Un mensaje sin leer
           *[other] { $count } mensajes sin leer
        }

## Spaces toolbar customize panel

menuitem-customize-label =
    .label = Personalizar...
spaces-customize-panel-title = Ajustes de la barra de herramientas de espacios
spaces-customize-background-color = Color de fondo
spaces-customize-icon-color = Color del botón
# The background color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-background-color = Color de fondo del botón seleccionado
# The icon color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-text-color = Color del botón seleccionado
spaces-customize-button-restore = Restaurar predeterminados
    .accesskey = R
customize-panel-button-save = Hecho
    .accesskey = H
