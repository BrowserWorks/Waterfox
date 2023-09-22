# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Alle Downloads abbrechen?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Wenn Sie jetzt den Browser beenden, wird 1 Download abgebrochen. Sind Sie sicher, dass Sie den Browser beenden möchten?
       *[other] Wenn Sie jetzt den Browser beenden, werden { $downloadsCount } Downloads abgebrochen. Sind Sie sicher, dass Sie den Browser beenden möchten?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Wenn Sie jetzt den Browser schließen, wird 1 Download abgebrochen. Sind Sie sicher, dass Sie den Browser schließen möchten?
       *[other] Wenn Sie jetzt den Browser schließen, werden { $downloadsCount } Downloads abgebrochen. Sind Sie sicher, dass Sie den Browser schließen möchten?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] Nicht schließen
       *[other] Nicht beenden
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Wenn Sie jetzt offline gehen, wird 1 Download abgebrochen. Sind Sie sicher, dass Sie offline gehen möchten?
       *[other] Wenn Sie jetzt offline gehen, werden { $downloadsCount } Downloads abgebrochen. Sind Sie sicher, dass Sie offline gehen möchten?
    }
download-ui-dont-go-offline-button = Online bleiben

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Wenn Sie jetzt alle privaten Fenster schließen, wird 1 Download abgebrochen. Soll der Private Modus wirklich verlassen werden?
       *[other] Wenn Sie jetzt alle privaten Fenster schließen, werden { $downloadsCount } Downloads abgebrochen. Soll der Private Modus wirklich verlassen werden?
    }
download-ui-dont-leave-private-browsing-button = Im Privaten Modus bleiben

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] 1 Download abbrechen
       *[other] { $downloadsCount } Downloads abbrechen
    }

##

download-ui-file-executable-security-warning-title = Ausführbare Datei öffnen?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = "{ $executable }" ist eine ausführbare Datei. Ausführbare Dateien können Viren oder anderen böswilligen Code enthalten, der Ihrem Computer schaden könnte. Sind Sie sicher, dass Sie "{ $executable }" ausführen wollen?
