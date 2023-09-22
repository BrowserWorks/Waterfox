# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Megszakítja az összes letöltést?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Ha most kilép, 1 letöltés megszakad. Biztosan kilép?
       *[other] Ha most kilép, { $downloadsCount } letöltés megszakad. Biztosan kilép?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Ha most kilép, 1 letöltés megszakad. Biztosan kilép?
       *[other] Ha most kilép, { $downloadsCount } letöltés megszakad. Biztosan kilép?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] Ne lépjen ki
       *[other] Ne lépjen ki
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Ha most kapcsolat nélküli üzemmódba lép, 1 letöltés megszakad. Biztosan meg szeretné szakítani a hálózati kapcsolatot?
       *[other] Ha most kapcsolat nélküli üzemmódba lép, { $downloadsCount } letöltés megszakad. Biztosan meg szeretné szakítani a hálózati kapcsolatot?
    }
download-ui-dont-go-offline-button = Maradjon online

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Ha most bezárja az összes privát böngészési ablakot, 1 letöltés megszakad. Biztos, hogy ki akar lépni a privát böngészésből?
       *[other] Ha most bezárja az összes privát böngészési ablakot, { $downloadsCount } letöltés megszakad. Biztos, hogy ki akar lépni a privát böngészésből?
    }
download-ui-dont-leave-private-browsing-button = Maradok privát böngészésben

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] 1 letöltés megszakítása
       *[other] { $downloadsCount } letöltés megszakítása
    }

##

download-ui-file-executable-security-warning-title = Megnyitja a végrehajtható fájlt?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = „{ $executable }” fájl végrehajtható. A végrehajtható fájlok vírusokat vagy más, rosszindulatú kódokat tartalmazhatnak, amelyek kárt okozhatnak a számítógépen. Legyen óvatos a fájl megnyitásakor. Biztosan elindítja: „{ $executable }”?
