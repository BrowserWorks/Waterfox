# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = La extensión no puede leer ni cambiar datos
origin-controls-quarantined =
    .label = La extensión no tiene permiso de leer ni cambiar datos
origin-controls-quarantined-status =
    .label = Extensión no permitida en sitios restringidos
origin-controls-quarantined-allow =
    .label = Permitir en sitios restringidos
origin-controls-options =
    .label = La extensión puede leer y cambiar datos:
origin-controls-option-all-domains =
    .label = En todos los sitios
origin-controls-option-when-clicked =
    .label = Solo cuando se hace clic
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = Permitir siempre en { $domain }

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = No puede leer ni cambiar datos en este sitio
origin-controls-state-quarantined = No permitido por { -vendor-short-name } en este sitio
origin-controls-state-always-on = Siempre puede leer y cambiar datos en este sitio
origin-controls-state-when-clicked = Permiso necesario para leer y cambiar datos
origin-controls-state-hover-run-visit-only = Ejecutar solo para esta visita
origin-controls-state-runnable-hover-open = Abrir extensión
origin-controls-state-runnable-hover-run = Ejecutar extensión
origin-controls-state-temporary-access = Puede leer o cambiar datos para esta visita

## Extension's toolbar button.
## Variables:
##   $extensionTitle (String) - Extension name or title message.

origin-controls-toolbar-button =
    .label = { $extensionTitle }
    .tooltiptext = { $extensionTitle }
# Extension's toolbar button when permission is needed.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-permission-needed =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Se necesita permiso
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        No permitido por { -vendor-short-name } en este sitio
