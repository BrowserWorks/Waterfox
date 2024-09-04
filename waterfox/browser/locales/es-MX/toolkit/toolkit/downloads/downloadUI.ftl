# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = ¿Realmente quieres cancelar todas las descargas?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Si sales ahora se cancelará una descarga. ¿Realmente quieres salir?
       *[other] Si sales ahora se cancelarán { $downloadsCount } descargas. ¿Realmente quieres salir?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Si cierras ahora se cancelará una descarga. ¿Realmente quieres salir?
       *[other] Si cierras ahora se cancelarán { $downloadsCount } descargas. ¿Realmente quieres salir?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] No cerrar
       *[other] No salir
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Si cambias al modo sin conexión ahora, se cancelará una descarga. ¿Realmente quieres hacerlo?
       *[other] Si cambias al modo sin conexión ahora, se cancelarán { $downloadsCount } descargas. ¿Realmente quieres hacerlo?
    }
download-ui-dont-go-offline-button = Permanecer conectado

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Si cierras todas las ventanas de navegación privada ahora, se cancelará 1 descarga. ¿Estás seguro de que quieres salir de la navegación privada?
       *[other] Si cierras todas las ventanas de navegación privada ahora, se cancelarán { $downloadsCount } descargas. ¿Estás seguro de que quieres salir de la navegación privada?
    }
download-ui-dont-leave-private-browsing-button = Permanecer en el modo de Navegación Privada

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] Cancelar una descarga
       *[other] Cancelar { $downloadsCount } descargas
    }

##

download-ui-file-executable-security-warning-title = ¿Abrir archivos ejecutables?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = "{ $executable }" es un archivo ejecutable. Si el orígen de los archivos ejecutables no es de confianza, éstos puden contener virus u otros códigos maliciosos que podrían dañar tu computadora. Ten cuidado al abrir este archivo. ¿Realmente deseas ejecutar "{ $executable }"?
