# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Annuller alle filhentninger?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Hvis du afslutter nu, vil hentning af 1 fil blive annulleret. Er du sikker på, at du vil afslutte?
       *[other] Hvis du afslutter nu, vil hentning af { $downloadsCount } filer blive annulleret. Er du sikker på, at du vil afslutte?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Hvis du afslutter nu, vil hentning af 1 fil blive annulleret. Er du sikker på, at du vil afslutte?
       *[other] Hvis du afslutter nu, vil hentning af { $downloadsCount } filer blive annulleret. Er du sikker på, at du vil afslutte?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] Afslut ikke
       *[other] Afslut ikke
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Hvis du går offline nu, vil hentning af 1 fil blive annulleret. Er du sikker på, at du vil gå offline?
       *[other] Hvis du går offline nu, vil hentning af { $downloadsCount } filer blive annulleret. Er du sikker på, at du vil gå offline?
    }
download-ui-dont-go-offline-button = Forbliv online

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Hvis du lukker alle privat browsing-vinduer nu, vil 1 filhentning blive annulleret. Er du sikker på, at du vil forlade privat browsing-tilstand?
       *[other] Hvis du lukker alle privat browsing-vinduer nu, vil { $downloadsCount } filhentninger blive annulleret. Er du sikker på, at du vil forlade privat browsing-tilstand?
    }
download-ui-dont-leave-private-browsing-button = Forbliv i privat browsing-tilstand

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] Annuller hentning af 1 fil
       *[other] Annuller hentning af { $downloadsCount } filer
    }

##

download-ui-file-executable-security-warning-title = Åbn eksekverbar fil?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = "{ $executable }" er en eksekverbar fil og kan indeholde vira eller anden ondsindet kode, som kan skade din computer. Vær agtpågivende, når du åbner denne fil. Er du sikker på, at du vil åbne "{ $executable }"?
