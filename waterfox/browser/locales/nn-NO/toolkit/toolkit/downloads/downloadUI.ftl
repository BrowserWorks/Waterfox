# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Avbryte alle nedlastingane?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Dersom du avsluttar no, vil 1 nedlasting avbrytast. Er du sikker på at du vil avslutte?
       *[other] Dersom du avsluttar no, vil { $downloadsCount } nedlastingar verte avbrotne. Er du sikker på at du vil du avslutte?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Dersom du avsluttar no, vil 1 nedlasting verte avbroten. Er du sikker på at du vil du avslutte?
       *[other] Dersom du avsluttar no, vil { $downloadsCount } nedlastingar avbrytast. Er du sikker på at du vil du avslutte?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] Ikkje avslutt
       *[other] Ikkje avslutt
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Om du koplar frå no, vil 1 nedlasting avbrytast. Er du sikker på at du vil du kople frå?
       *[other] Om du koplar frå no, vil { $downloadsCount } nedlastingar avbrytast. Er du sikker på at du vil du kople frå?
    }
download-ui-dont-go-offline-button = Bli verande tilkopla

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Om du lèt att alle Private nettlesar-vindauga no, vil 1 nedlasting avbrytast. Er du sikker på at du vil avslutte Privat nettlesing?
       *[other] Dersom du lèt att alle Private nettlesings-vindauge no, vil { $downloadsCount } nedlastingar avbrytast. Er du sikker på at du vil avslutte Privat nettlesing?
    }
download-ui-dont-leave-private-browsing-button = Fortset med Privat nettlesing

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] Avbryt 1 nedlasting
       *[other] Avbryt { $downloadsCount } nedlastingar
    }

##

download-ui-file-executable-security-warning-title = Opne programfil?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = «{ $executable }» er ei programfil. Programfiler kan innehalde virus eller annan kode som kan skade datamaskina di. Ver varsam med å opne slike filer. Er du sikker på at du vil opne «{ $executable }»?
