# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = Pwail
    .accesskey = P
menu-file-new-tab =
    .label = Drica matidi manyen
    .accesskey = D
menu-file-new-container-tab =
    .label = Dirica matidi manyen me mako jami
    .accesskey = m
menu-file-new-window =
    .label = Dirica manyen
    .accesskey = D
menu-file-new-private-window =
    .label = Dirica manyen me mung
    .accesskey = D
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Yab Kabedo…
menu-file-open-file =
    .label = Yab pwail…
    .accesskey = Y
menu-file-close =
    .label = Lor
    .accesskey = L
menu-file-close-window =
    .label = Lor dirica
    .accesskey = c
menu-file-save-page =
    .label = Gwok pot buk calo…
    .accesskey = c
menu-file-email-link =
    .label = Cwal kakube…
    .accesskey = C
menu-file-print-setup =
    .label = Tero Pot Buk…
    .accesskey = t
menu-file-print-preview =
    .label = Nen kit ma obibedo ka ki goyo
    .accesskey = e
menu-file-print =
    .label = Go…
    .accesskey = G
menu-file-import-from-another-browser =
    .label = Kel ki i Layeny Mukene…
    .accesskey = K
menu-file-go-offline =
    .label = Ti ma pe ikube iyamo
    .accesskey = T

## Edit Menu

menu-edit =
    .label = Yub
    .accesskey = Y
menu-edit-find-on =
    .label = Nong i pot buk man…
    .accesskey = N
menu-edit-find-again =
    .label = Nong doki
    .accesskey = o
menu-edit-bidi-switch-text-direction =
    .label = Lok tung coc
    .accesskey = o

## View Menu

menu-view =
    .label = Nen
    .accesskey = N
menu-view-toolbars-menu =
    .label = Gintic
    .accesskey = G
menu-view-customize-toolbar =
    .label = Yiki…
    .accesskey = Y
menu-view-sidebar =
    .label = Gintic ma i nget
    .accesskey = n
menu-view-bookmarks =
    .label = Alama buk
menu-view-history-button =
    .label = Gin mukato
menu-view-synced-tabs-sidebar =
    .label = Dirica matino ma kiribo
menu-view-full-zoom =
    .label = Kwoti
    .accesskey = K
menu-view-full-zoom-enlarge =
    .label = Kwot madit
    .accesskey = m
menu-view-full-zoom-reduce =
    .label = Jwik matidi
    .accesskey = m
menu-view-full-zoom-toggle =
    .label = Kwot coc keken
    .accesskey = c
menu-view-page-style-menu =
    .label = Kit pot buk
    .accesskey = t
menu-view-page-style-no-style =
    .label = Kite Pe
    .accesskey = K
menu-view-page-basic-style =
    .label = Kit pot buk ma dong tidi
    .accesskey = K
menu-view-charset =
    .label = Loko coc i kod
    .accesskey = k

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Dony i wang komputa ma opong
    .accesskey = w
menu-view-exit-full-screen =
    .label = Kat woko ki i wang komputa ma opong
    .accesskey = w
menu-view-full-screen =
    .label = Wang komputa ma opong
    .accesskey = W

##

menu-view-show-all-tabs =
    .label = Nyut dirica matino weng
    .accesskey = w
menu-view-bidi-switch-page-direction =
    .label = Lok tung pot buk
    .accesskey = u

## History Menu

menu-history =
    .label = Gin mukato
    .accesskey = u
menu-history-show-all-history =
    .label = Nyut gin mukato weng
menu-history-clear-recent-history =
    .label = Jwa gin mukato cokki…
menu-history-synced-tabs =
    .label = Dirica matino ma kiribo
menu-history-restore-last-session =
    .label = Dwok kare ma okato ni
menu-history-hidden-tabs =
    .label = Dirica matino ma okane
menu-history-undo-menu =
    .label = Dirica matino ma kiloro cokki
menu-history-undo-window-menu =
    .label = Dirica ma kiloro cokki

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Alama buk
    .accesskey = A
menu-bookmarks-show-all =
    .label = Nyut alamabuk weng
menu-bookmark-this-page =
    .label = Ket alama buk i pot buk man
menu-bookmark-edit =
    .label = Yub alama buk man
menu-bookmarks-all-tabs =
    .label = Ket alama buk i dirica matino weng…
menu-bookmarks-toolbar =
    .label = Gintic me alama buk
menu-bookmarks-other =
    .label = Alamabuk Mukene
menu-bookmarks-mobile =
    .label = Alamabuk me cing

## Tools Menu

menu-tools =
    .label = Gintic
    .accesskey = G
menu-tools-downloads =
    .label = Gam
    .accesskey = G
menu-tools-addons =
    .label = Med-ikome
    .accesskey = M
menu-tools-fxa-sign-in =
    .label = Dony iyie { -brand-product-name }…
    .accesskey = n
menu-tools-turn-on-sync =
    .label = Cak { -sync-brand-short-name }…
    .accesskey = a
menu-tools-sync-now =
    .label = Rib Kombedi
    .accesskey = R
menu-tools-fxa-re-auth =
    .label = Nwo kube ki { -brand-product-name }…
    .accesskey = N
menu-tools-web-developer =
    .label = Layub Kakube
    .accesskey = L
menu-tools-page-source =
    .label = Kama pot buk nonge iye
    .accesskey = k
menu-tools-page-info =
    .label = Ngec me pot buk
    .accesskey = N
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Gin ayera
           *[other] Ma imaro
        }
    .accesskey =
        { PLATFORM() ->
            [windows] G
           *[other] r
        }

## Window Menu

menu-window-menu =
    .label = Dirica
menu-window-bring-all-to-front =
    .label = Kel gi Weng Anyim

## Help Menu

menu-help =
    .label = Kony
    .accesskey = K
menu-help-product =
    .label = Kony me { -brand-shorter-name }
    .accesskey = K
menu-help-show-tour =
    .label = Wot me { -brand-shorter-name }
    .accesskey = o
menu-help-keyboard-shortcuts =
    .label = Yo macego me kadiyo coc
    .accesskey = k
menu-help-troubleshooting-info =
    .label = Ngec me yubu bal
    .accesskey = N
menu-help-feedback-page =
    .label = Cwal adwogi ne…
    .accesskey = C
menu-help-safe-mode-without-addons =
    .label = Cak odoco ki med-ikome gi ma kijuko woko…
    .accesskey = C
menu-help-safe-mode-with-addons =
    .label = Cak odoco kun nongo kicako med-ikome
    .accesskey = C
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Mi ripot i kom kakube me bwola…
    .accesskey = b
menu-help-not-deceptive =
    .label = Man pe kakube me bwola…
    .accesskey = b
