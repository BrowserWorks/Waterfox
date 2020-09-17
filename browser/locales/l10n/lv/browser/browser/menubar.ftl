# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = Fails
    .accesskey = F
menu-file-new-tab =
    .label = Jauna cilne
    .accesskey = c
menu-file-new-container-tab =
    .label = Jauna saturošā cilne
    .accesskey = c
menu-file-new-window =
    .label = Jauns logs
    .accesskey = n
menu-file-new-private-window =
    .label = Jauns privātais logs
    .accesskey = v
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Atvērt vietu…
menu-file-open-file =
    .label = Atvērt failu…
    .accesskey = A
menu-file-close =
    .label = Aizvērt
    .accesskey = z
menu-file-close-window =
    .label = Aizvērt logu
    .accesskey = g
menu-file-save-page =
    .label = Saglabāt lapu kā…
    .accesskey = S
menu-file-email-link =
    .label = Nosūtīt saiti…
    .accesskey = N
menu-file-print-setup =
    .label = Lapas iestatījumi…
    .accesskey = u
menu-file-print-preview =
    .label = Drukas priekšskatījums
    .accesskey = p
menu-file-print =
    .label = Drukāt…
    .accesskey = D
menu-file-go-offline =
    .label = Strādāt nesaistē
    .accesskey = r

## Edit Menu

menu-edit =
    .label = Rediģēt
    .accesskey = e
menu-edit-find-on =
    .label = Atrast šajā lapā…
    .accesskey = A
menu-edit-find-again =
    .label = Meklēt vēlreiz
    .accesskey = k
menu-edit-bidi-switch-text-direction =
    .label = Nomainīt teksta virzienu
    .accesskey = m

## View Menu

menu-view =
    .label = Skats
    .accesskey = S
menu-view-toolbars-menu =
    .label = Rīkjoslas
    .accesskey = l
menu-view-customize-toolbar =
    .label = Pielāgot…
    .accesskey = P
menu-view-sidebar =
    .label = Sānu josla
    .accesskey = a
menu-view-bookmarks =
    .label = Grāmatzīmes
menu-view-history-button =
    .label = Vēsture
menu-view-synced-tabs-sidebar =
    .label = Sinhronizētās cilnes
menu-view-full-zoom =
    .label = Mērogs
    .accesskey = M
menu-view-full-zoom-enlarge =
    .label = Pietuvināt
    .accesskey = i
menu-view-full-zoom-reduce =
    .label = Attālināt
    .accesskey = A
menu-view-full-zoom-toggle =
    .label = Mērogot tikai tekstu
    .accesskey = t
menu-view-page-style-menu =
    .label = Lapas stils
    .accesskey = t
menu-view-page-style-no-style =
    .label = Bez stila
    .accesskey = B
menu-view-page-basic-style =
    .label = Lapas pamata stils
    .accesskey = m
menu-view-charset =
    .label = Teksta kodējums
    .accesskey = k

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Ieiet pilnekrāna režīmā
    .accesskey = p
menu-view-exit-full-screen =
    .label = Iziet no pilnekrāna režīma
    .accesskey = p
menu-view-full-screen =
    .label = Pa visu ekrānu
    .accesskey = v

##

menu-view-show-all-tabs =
    .label = Rādīt visas cilnes
    .accesskey = v
menu-view-bidi-switch-page-direction =
    .label = Nomainīt lapas virzienu
    .accesskey = p

## History Menu

menu-history =
    .label = Vēsture
    .accesskey = V
menu-history-show-all-history =
    .label = Parādīt visu vēsturi
menu-history-clear-recent-history =
    .label = Dzēst neseno vēsturi…
menu-history-synced-tabs =
    .label = Sinhronizētās cilnes
menu-history-restore-last-session =
    .label = Atjaunot iepriekšējo sesiju
menu-history-hidden-tabs =
    .label = Slēptās cilnes
menu-history-undo-menu =
    .label = Nesen aizvērtās cilnes
menu-history-undo-window-menu =
    .label = Nesen aizvērtie logi

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Grāmatzīmes
    .accesskey = G
menu-bookmarks-show-all =
    .label = Rādīt visas grāmatzīmes
menu-bookmark-this-page =
    .label = Saglabāt šo lapu grāmatzīmēs
menu-bookmark-edit =
    .label = Rediģēt šo grāmatzīmi
menu-bookmarks-all-tabs =
    .label = Saglabāt visas cilnes grāmatzīmēs…
menu-bookmarks-toolbar =
    .label = Grāmatzīmju rīkjosla
menu-bookmarks-other =
    .label = Citas grāmatzīmes
menu-bookmarks-mobile =
    .label = Mobilās grāmatzīmes

## Tools Menu

menu-tools =
    .label = Rīki
    .accesskey = R
menu-tools-downloads =
    .label = Lejupielādes
    .accesskey = d
menu-tools-addons =
    .label = Papildinājumi
    .accesskey = a
menu-tools-sync-now =
    .label = Sinhronizēt
    .accesskey = S
menu-tools-web-developer =
    .label = Izstrādātāju rīki
    .accesskey = T
menu-tools-page-source =
    .label = Lapas pirmkods
    .accesskey = o
menu-tools-page-info =
    .label = Informācija par lapu
    .accesskey = I
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Iestatījumi
           *[other] Iestatījumi
        }
    .accesskey =
        { PLATFORM() ->
            [windows] m
           *[other] m
        }
menu-tools-layout-debugger =
    .label = Izkārtojuma atkļūdotājs
    .accesskey = I

## Window Menu

menu-window-menu =
    .label = Logs
menu-window-bring-all-to-front =
    .label = Nest visu uz priekšplānu

## Help Menu

menu-help =
    .label = Palīdzība
    .accesskey = P
menu-help-product =
    .label = { -brand-shorter-name } palīdzība
    .accesskey = l
menu-help-show-tour =
    .label = { -brand-shorter-name } ekskursija
    .accesskey = r
menu-help-keyboard-shortcuts =
    .label = Taustiņu kombinācijas
    .accesskey = k
menu-help-troubleshooting-info =
    .label = Problēmu novēršanas informācija
    .accesskey = P
menu-help-feedback-page =
    .label = Nosūtīt atsauksmi…
    .accesskey = s
menu-help-safe-mode-without-addons =
    .label = Pārstartēt ar deaktivētiem papildinājumiem…
    .accesskey = r
menu-help-safe-mode-with-addons =
    .label = Pārstartēt ar aktivētiem papildinājumiem
    .accesskey = r
# Label of the Help menu item. Either this or
# safeb.palm.notdeceptive.label from
# phishing-afterload-warning-message.dtd is shown.
menu-help-report-deceptive-site =
    .label = Ziņot par maldinošu lapu…
    .accesskey = d
menu-help-not-deceptive =
    .label = Šī nav maldinoša lapa…
    .accesskey = d
