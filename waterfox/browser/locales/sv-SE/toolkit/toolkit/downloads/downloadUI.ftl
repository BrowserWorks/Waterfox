# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Avbryt alla filhämtningar?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Om du avslutar nu kommer en filhämtning att avbrytas. Är du säker på att du vill avsluta?
       *[other] Om du avslutar nu kommer { $downloadsCount } filhämtningar att avbrytas. Är du säker på att du vill avsluta?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Om du avslutar nu kommer en filhämtning att avbrytas. Är du säker på att du vill avsluta?
       *[other] Om du avslutar nu kommer { $downloadsCount } filhämtningar att avbrytas. Är du säker på att du vill avsluta?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] Avsluta inte
       *[other] Avsluta inte
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Om du kopplar ned kommer en filhämtning att avbrytas. Är du säker på att du vill koppla ned?
       *[other] Om du kopplar ned kommer { $downloadsCount } filhämtningar att avbrytas. Är du säker på att du vill koppla ned?
    }
download-ui-dont-go-offline-button = Fortsätt uppkopplad

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Om du stänger alla fönster med privat surfning nu, kommer 1 filhämtning avbryts. Är du säker på att du vill lämna privat surfning?
       *[other] Om du stänger alla fönster med privat surfning nu, kommer  { $downloadsCount } filhämtningar avbryts. Är du säker på att du vill lämna privat surfning?
    }
download-ui-dont-leave-private-browsing-button = Fortsätt med privat surfning

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] Avbryt filhämtningen
       *[other] Avbryt { $downloadsCount } filhämtningar
    }

##

download-ui-file-executable-security-warning-title = Öppna körbar fil?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = “{ $executable }” är en körbar fil. Körbara filer kan innehålla virus eller annan illasinnad kod som kan skada din dator. Var försiktig vid öppnande av denna fil. Är du säker på att du vill köra “{ $executable }”?
