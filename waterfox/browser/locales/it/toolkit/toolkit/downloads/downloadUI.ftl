# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Annullare tutti i download?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Chiudendo ora l’applicazione verrà annullato il download. Continuare?
       *[other] Chiudendo ora l’applicazione verranno annullati { $downloadsCount } download. Continuare?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Chiudendo ora l’applicazione verrà annullato il download. Continuare?
       *[other] Chiudendo ora l’applicazione verranno annullati { $downloadsCount } download. Continuare?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] Non uscire
       *[other] Non uscire
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Scollegandosi ora verrà annullato il download. Scollegarsi?
       *[other] Scollegandosi ora verranno annullati { $downloadsCount } download. Scollegarsi?
    }
download-ui-dont-go-offline-button = Rimani collegato

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Chiudendo tutte le finestre in modalità Navigazione anonima verrà annullato il download in corso. Abbandonare la modalità Navigazione anonima?
       *[other] Chiudendo tutte le finestre in modalità Navigazione anonima verranno annullati { $downloadsCount } download in corso. Abbandonare la modalità Navigazione anonima?
    }
download-ui-dont-leave-private-browsing-button = Rimani in modalità Navigazione anonima

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] Annulla il download
       *[other] Annulla { $downloadsCount } download
    }

##

download-ui-file-executable-security-warning-title = Aprire il file eseguibile?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = “{ $executable }” è un file eseguibile e potrebbe contenere virus o altri codici potenzialmente dannosi per il computer. Aprire questo file con cautela. Procedere con l’apertura di “{ $executable }”?
