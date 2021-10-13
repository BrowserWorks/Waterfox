# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Dígale hola a un nuevo { -brand-short-name }
upgrade-dialog-new-subtitle = Diseñado para llevarle más rápidoa donde quiera
upgrade-dialog-new-item-menu-title = Barra de herramientas y menús optimizados
upgrade-dialog-new-item-menu-description = Priorice las cosas importantes para encontrar lo que necesita.
upgrade-dialog-new-item-tabs-title = Pestañas modernas
upgrade-dialog-new-item-tabs-description = Contiene información de forma ordenada, favoreciendo la concentración y la flexibilidad de movimientos.
upgrade-dialog-new-item-icons-title = Iconos renovados y mensajes más claros
upgrade-dialog-new-item-icons-description = Le ayuda a encontrar su camino con un toque más ligero.
upgrade-dialog-new-primary-default-button = Hacer que { -brand-short-name } sea mi navegador predeterminado
upgrade-dialog-new-primary-theme-button = Elija un tema
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
        [macos] Mantener { -brand-short-name } en su Dock
       *[other] Fijar { -brand-short-name } a su barra de tareas
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Obtenga fácil acceso al { -brand-short-name } más actual.
       *[other] Tenga el { -brand-short-name } más actual al alcance de la mano.
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Mantener en el Dock
       *[other] Fijar a la barra de tareas
    }
upgrade-dialog-pin-secondary-button = Ahora no

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Hacer que{ -brand-short-name } sea su navegador predeterminado
upgrade-dialog-default-subtitle-2 = Obtenga velocidad, seguridad y privacidad de forma automática.
upgrade-dialog-default-primary-button-2 = Establecer como navegador predeterminado
upgrade-dialog-default-secondary-button = Ahora no

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Comience desde cero con un nuevo tema
upgrade-dialog-theme-system = Tema del sistema
    .title = Usar el tema del sistema operativo para botones, menús y ventanas
upgrade-dialog-theme-light = Claro
    .title = Usar un tema claro para botones, menús y ventanas
upgrade-dialog-theme-dark = Oscuro
    .title = Usar un tema oscuro para botones, menús y ventanas
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Usar un tema dinámico y colorido para botones, menús y ventanas
upgrade-dialog-theme-keep = Mantener anterior
    .title = Usar el tema que estaba instalado antes de actualizar { -brand-short-name }
upgrade-dialog-theme-primary-button = Guardar tema
upgrade-dialog-theme-secondary-button = Ahora no
