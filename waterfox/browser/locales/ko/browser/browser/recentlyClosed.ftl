# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used in the main menu,
## and should follow the same capitalization (title case for English).
## Check menubar.ftl for reference.

recently-closed-menu-reopen-all-tabs = 모든 탭 다시 열기
recently-closed-menu-reopen-all-windows = 모든 창 다시 열기

## These strings are used in the app menu,
## and should follow the same capitalization (sentence case for English).
## Check appmenu.ftl for reference.

recently-closed-panel-reopen-all-tabs = 모든 탭 다시 열기
recently-closed-panel-reopen-all-windows = 모든 창 다시 열기

##

# Variables:
#   $tabCount (Number): Number of other tabs
#   $winTitle (String): Window title
recently-closed-undo-close-window-label =
    { $tabCount ->
        [0] { $winTitle }
       *[other] { $winTitle } (다른 탭 { $tabCount }개)
    }
