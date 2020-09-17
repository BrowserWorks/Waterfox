# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = File
    .accesskey = F
menu-file-new-tab =
    .label = Bagong Tab
    .accesskey = T
menu-file-new-container-tab =
    .label = Bagong Container Tab
    .accesskey = B
menu-file-new-window =
    .label = Bagong Window
    .accesskey = N
menu-file-new-private-window =
    .label = Bagong Private Window
    .accesskey = W
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Buksan ang Lokasyon…
menu-file-open-file =
    .label = Magbukas ng File...
    .accesskey = O
menu-file-close =
    .label = Isara
    .accesskey = C
menu-file-close-window =
    .label = Isara ang Window
    .accesskey = d
menu-file-save-page =
    .label = i-Save ang Pahina Bilang…
    .accesskey = A
menu-file-email-link =
    .label = i-Email ang Link…
    .accesskey = E
menu-file-print-setup =
    .label = Page Setup...
    .accesskey = u
menu-file-print-preview =
    .label = Print Preview
    .accesskey = v
menu-file-print =
    .label = Print
    .accesskey = P
menu-file-import-from-another-browser =
    .label = Mag-import mula sa Ibang Browser…
    .accesskey = I
menu-file-go-offline =
    .label = Magtrabaho nang Offline
    .accesskey = k

## Edit Menu

menu-edit =
    .label = Edit
    .accesskey = E
menu-edit-find-on =
    .label = Hanapin sa Pahinang Ito...
    .accesskey = F
menu-edit-find-again =
    .label = Hanapin Muli
    .accesskey = g
menu-edit-bidi-switch-text-direction =
    .label = Pagpalitin ang Direksyon ng Text
    .accesskey = w

## View Menu

menu-view =
    .label = Tingnan
    .accesskey = T
menu-view-toolbars-menu =
    .label = Mga Toolbar
    .accesskey = T
menu-view-customize-toolbar =
    .label = i-Customize...
    .accesskey = c
menu-view-sidebar =
    .label = Sidebar
    .accesskey = e
menu-view-bookmarks =
    .label = Mga Bookmark
menu-view-history-button =
    .label = Kasaysayan
menu-view-synced-tabs-sidebar =
    .label = Mga Naka-Sync na Tab
menu-view-full-zoom =
    .label = i-Zoom
    .accesskey = Z
menu-view-full-zoom-enlarge =
    .label = Palakihin
    .accesskey = I
menu-view-full-zoom-reduce =
    .label = Paliitin
    .accesskey = O
menu-view-full-zoom-actual-size =
    .label = Totoong Sukat
    .accesskey = A
menu-view-full-zoom-toggle =
    .label = i-Zoom lamang ang mga Salita
    .accesskey = T
menu-view-page-style-menu =
    .label = Style ng Pahina
    .accesskey = y
menu-view-page-style-no-style =
    .label = Walang Istilo
    .accesskey = n
menu-view-page-basic-style =
    .label = Basic na Estilo ng Pahina
    .accesskey = b
menu-view-charset =
    .label = Pag-encode ng Teksto
    .accesskey = c

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Pumunta sa Full Screen
    .accesskey = F
menu-view-exit-full-screen =
    .label = Umalis sa Full Screen
    .accesskey = F
menu-view-full-screen =
    .label = Buong Screen
    .accesskey = B

##

menu-view-show-all-tabs =
    .label = Ipakita ang Lahat ng Mga Tab
    .accesskey = a
menu-view-bidi-switch-page-direction =
    .label = Lumipat ng Page Direction
    .accesskey = D

## History Menu

menu-history =
    .label = Kasaysayan
    .accesskey = s
menu-history-show-all-history =
    .label = Ipakita ang Lahat ng Kasaysayan
menu-history-clear-recent-history =
    .label = Burahin ang Kasaysayan…
menu-history-synced-tabs =
    .label = Mga Naka-sync na Tab
menu-history-restore-last-session =
    .label = Ibalik ang Nakaraang Session
menu-history-hidden-tabs =
    .label = Mga Nakatagong Tab
menu-history-undo-menu =
    .label = Mga Naisarang Tab
menu-history-undo-window-menu =
    .label = Mga Isinarang Window Kamakailan

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Mga Bookmark
    .accesskey = B
menu-bookmarks-show-all =
    .label = Ipakita Lahat ng mga Bookmark
menu-bookmark-this-page =
    .label = i-Bookmark ang Pahinang Ito
menu-bookmark-edit =
    .label = i-Edit ang bookmark na ito
menu-bookmarks-all-tabs =
    .label = i-Bookmark ang Lahat ng mga Tab…
menu-bookmarks-toolbar =
    .label = Bookmark Toolbar
menu-bookmarks-other =
    .label = Iba pang mga Bookmark
menu-bookmarks-mobile =
    .label = Mga Mobile Bookmark

## Tools Menu

menu-tools =
    .label = Mga Kagamitan
    .accesskey = T
menu-tools-downloads =
    .label = Mga Download
    .accesskey = D
menu-tools-addons =
    .label = Mga Add-on
    .accesskey = A
menu-tools-fxa-sign-in =
    .label = Mag-Sign In sa { -brand-product-name }...
    .accesskey = g
menu-tools-turn-on-sync =
    .label = Buksan ang { -sync-brand-short-name }…
    .accesskey = n
menu-tools-sync-now =
    .label = Mag-sync Na
    .accesskey = S
menu-tools-fxa-re-auth =
    .label = Kumunektang muli sa { -brand-product-name }…
    .accesskey = R
menu-tools-web-developer =
    .label = Web Developer
    .accesskey = W
menu-tools-page-source =
    .label = Source code ng web page
    .accesskey = o
menu-tools-page-info =
    .label = Impormasyon tungkol sa Pahina
    .accesskey = I
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Options
           *[other] Mga Kagustuhan
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] n
        }
menu-tools-layout-debugger =
    .label = Layout Debugger
    .accesskey = L

## Window Menu

menu-window-menu =
    .label = Window
menu-window-bring-all-to-front =
    .label = Dalhin Lahat sa Harap

## Help Menu

menu-help =
    .label = Tulong
    .accesskey = T
menu-help-product =
    .label = Tulong sa { -brand-shorter-name }
    .accesskey = H
menu-help-show-tour =
    .label = Libutin ang { -brand-shorter-name }
    .accesskey = o
menu-help-import-from-another-browser =
    .label = Mag-import mula sa Ibang Browser…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Mga Keyboard Shortcut
    .accesskey = K
menu-help-troubleshooting-info =
    .label = Impormasyon para sa Troubleshooting
    .accesskey = T
menu-help-feedback-page =
    .label = Magbigay ng Katugunan...
    .accesskey = s
menu-help-safe-mode-without-addons =
    .label = Mag-restart na Naka-disable ang mga Add-on...
    .accesskey = R
menu-help-safe-mode-with-addons =
    .label = Mag-restart nang Naka-enable ang mga Add-on
    .accesskey = R
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Magsumbong ng Mapanlinlang na Site...
    .accesskey = D
menu-help-not-deceptive =
    .label = Ito ay hindi mapagkunwaring site...
    .accesskey = d
