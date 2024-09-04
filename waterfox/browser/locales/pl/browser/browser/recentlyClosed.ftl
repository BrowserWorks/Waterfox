# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used in the main menu,
## and should follow the same capitalization (title case for English).
## Check menubar.ftl for reference.

recently-closed-menu-reopen-all-tabs = Przywróć wszystkie karty
recently-closed-menu-reopen-all-windows = Przywróć wszystkie okna

## These strings are used in the app menu,
## and should follow the same capitalization (sentence case for English).
## Check appmenu.ftl for reference.

recently-closed-panel-reopen-all-tabs = Przywróć wszystkie karty
recently-closed-panel-reopen-all-windows = Przywróć wszystkie okna

##

# Variables:
#   $tabCount (Number): Number of other tabs
#   $winTitle (String): Window title
recently-closed-undo-close-window-label =
    { $tabCount ->
        [0] { $winTitle }
        [one] { $winTitle } (i { $tabCount } inna karta)
        [few] { $winTitle } (i { $tabCount } inne karty)
       *[many] { $winTitle } (i { $tabCount } innych kart)
    }
