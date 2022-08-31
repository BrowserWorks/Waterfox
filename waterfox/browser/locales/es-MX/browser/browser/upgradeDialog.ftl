# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

## Pin Waterfox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

## Default browser screen

## Theme selection screen

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = La vida a todo color
upgrade-dialog-start-subtitle = Nuevas combinaciones de colores vibrantes. Disponible por tiempo limitado.
upgrade-dialog-start-primary-button = Explorar combinaciones de colores
upgrade-dialog-start-secondary-button = Ahora no

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = Elige tu paleta
# This is shown to users with a custom home page, so they can switch to default.
upgrade-dialog-colorway-home-checkbox = Cambiar a la página de inicio de Waterfox con un fondo temático
upgrade-dialog-colorway-primary-button = Guardar combinación de colores
upgrade-dialog-colorway-secondary-button = Mantener el tema anterior
upgrade-dialog-colorway-theme-tooltip =
    .title = Explorar los temas predeterminados
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = Explorar combinaciones de colores de { $colorwayName }
upgrade-dialog-colorway-default-theme = Predeterminado
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = Auto
    .title = Usar el tema del sistema operativo para los botones, menús y ventanas
upgrade-dialog-theme-light = Claro
    .title = Usar un tema claro para botones, menús y ventanas
upgrade-dialog-theme-dark = Oscuro
    .title = Usar un tema oscuro para botones, menús y ventanas
upgrade-dialog-colorway-variation-soft = Suave
    .title = Usar esta combinación
upgrade-dialog-colorway-variation-balanced = Equilibrado
    .title = Usar esa combinación
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = Fuerte
    .title = Usar esta combinación

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = Gracias por elegirnos
upgrade-dialog-thankyou-subtitle = { -brand-short-name } es un navegador independiente respaldado por una organización sin fines de lucro. Juntos, estamos haciendo que la web sea más segura, saludable y privada.
upgrade-dialog-thankyou-primary-button = Comenzar a navegar
