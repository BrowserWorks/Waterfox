# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Zrušit všechna stahování?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Pokud teď skončíte, bude zrušeno stahování jednoho souboru. Opravdu chcete skončit?
       *[other] Pokud teď skončíte, bude zrušeno stahování { $downloadsCount } souborů. Opravdu chcete skončit?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Pokud teď skončíte, bude zrušeno stahování jednoho souboru. Opravdu chcete skončit?
       *[other] Pokud teď skončíte, bude zrušeno stahování { $downloadsCount } souborů. Opravdu chcete skončit?
    }
download-ui-dont-quit-button = Neskončit

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Pokud přejdete do režimu offline, bude zrušeno stahování souboru. Opravdu chcete přejít do režimu offline?
       *[other] Pokud přejdete do režimu offline, bude zrušeno stahování { $downloadsCount } souborů. Opravdu chcete přejít do režimu offline?
    }
download-ui-dont-go-offline-button = Zůstat online

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Pokud zavřete všechna anonymní okna, zruší se jedno aktuální stahování. Opravdu chcete opustit anonymní prohlížení?
       *[other] Pokud zavřete všechna anonymní okna, zruší se některá ({ $downloadsCount }) aktuální stahování. Opravdu chcete opustit anonymní prohlížení?
    }
download-ui-dont-leave-private-browsing-button = Zůstat v anonymním prohlížení

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] Zrušit stahování
       *[other] Zrušit { $downloadsCount } stahování
    }

##

download-ui-file-executable-security-warning-title = Otevřít spustitelný soubor?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = „{ $executable }“ je spustitelný soubor. Ten může obsahovat viry nebo jiný škodlivý kód, který může poškodit váš počítač. Při spuštění buďte opatrní. Chcete opravdu spustit soubor „{ $executable }“?
