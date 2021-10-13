# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Dí hola a un nuevo { -brand-short-name }
upgrade-dialog-new-subtitle = Diseñado para llevarte más rápido a donde quieres ir
upgrade-dialog-new-item-menu-title = Barra de herramientas y menús optimizados
upgrade-dialog-new-item-menu-description = Prioriza las cosas importantes para que encuentres lo que necesitas.
upgrade-dialog-new-item-tabs-title = Pestañas modernas
upgrade-dialog-new-item-tabs-description = Contiene la información de manera ordenada, apoyando el enfoque y el movimiento flexible.
upgrade-dialog-new-item-icons-title = Iconos nuevos y mensajes más claros
upgrade-dialog-new-item-icons-description = Te ayuda a encontrar tu camino con un toque más ligero.
upgrade-dialog-new-primary-default-button = Establecer { -brand-short-name } como mi navegador predeterminado
upgrade-dialog-new-primary-theme-button = Elige un tema
upgrade-dialog-new-secondary-button = Ahora no
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = ¡De acuerdo, entendido!

## Pin Waterfox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] Mantener { -brand-short-name } en tu Dock
       *[other] Fijar { -brand-short-name } a la barra de tareas
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Obten acceso fácil a la última versión de { -brand-short-name }
       *[other] Manten a tu alcance la última versión de { -brand-short-name }
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Mantener en el Dock
       *[other] Fijar a la barra de tareas
    }
upgrade-dialog-pin-secondary-button = Ahora no

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Hacer que { -brand-short-name } sea el predeterminado
upgrade-dialog-default-subtitle-2 = Obtén velocidad, seguridad y privacidad de forma automática.
upgrade-dialog-default-primary-button-2 = Hacer navegador predeterminado
upgrade-dialog-default-secondary-button = Ahora no

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Comienza de nuevo con un nuevo tema
upgrade-dialog-theme-system = Tema del sistema
    .title = Usar el tema del sistema operativo para botones, menùs y ventanas

## Start screen

upgrade-dialog-start-secondary-button = Ahora no

## Colorway screen

upgrade-dialog-theme-light = Claro
    .title = Usar un tema claro para botones, menús y ventanas
upgrade-dialog-theme-dark = Oscuro
    .title = Usar un tema oscuro para botones, menús y ventanas
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Usar un tema dinámico y colorido para botones, menús y ventanas
upgrade-dialog-theme-keep = Mantener anterior
    .title = Usar el tema instalado previamente a la actualización de { -brand-short-name }
upgrade-dialog-theme-primary-button = Guardar tema
upgrade-dialog-theme-secondary-button = Ahora no

## Thank you screen

