# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Czy anulować pobieranie wszystkich plików?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Jeśli skończysz teraz pracę programu, pobieranie bieżącego pliku zostanie anulowane. Czy na pewno zakończyć pracę programu?
       *[other] Jeśli skończysz teraz pracę programu, pobieranie wszystkich { $downloadsCount } plików zostanie anulowane. Czy na pewno zakończyć pracę programu?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Jeśli skończysz teraz pracę programu, pobieranie bieżącego pliku zostanie anulowane. Czy na pewno zakończyć pracę programu?
       *[other] Jeśli skończysz teraz pracę programu, pobieranie wszystkich { $downloadsCount } plików zostanie anulowane. Czy na pewno zakończyć pracę programu?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] Nie zamykaj
       *[other] Nie kończ
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Jeśli przejdziesz teraz do trybu offline, pobieranie bieżącego pliku zostanie anulowane. Czy na pewno przejść do trybu offline?
       *[other] Jeśli przejdziesz teraz do trybu offline, pobieranie wszystkich { $downloadsCount } plików zostanie anulowane. Czy na pewno przejść do trybu offline?
    }
download-ui-dont-go-offline-button = Pozostań w trybie online

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Zamknięcie wszystkich okien trybu prywatnego teraz spowoduje przerwanie pobierania 1 pliku. Czy na pewno opuścić tryb prywatny?
       *[other] Zamknięcie wszystkich okien trybu prywatnego teraz spowoduje przerwanie pobierania { $downloadsCount } plików. Czy na pewno opuścić tryb prywatny?
    }
download-ui-dont-leave-private-browsing-button = Pozostań w trybie prywatnym

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] Anuluj pobieranie 1 pliku
       *[other] Anuluj pobieranie { $downloadsCount } plików
    }

##

download-ui-file-executable-security-warning-title = Uruchamianie pliku wykonywalnego!
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = „{ $executable }” jest plikiem wykonywalnym. Pliki wykonywalne mogą zawierać wirusy lub inny niebezpieczny kod, który mógłby uszkodzić komputer. Zaleca się zachowanie ostrożności przy otwieraniu plików tego typu. Czy na pewno uruchomić „{ $executable }”?
