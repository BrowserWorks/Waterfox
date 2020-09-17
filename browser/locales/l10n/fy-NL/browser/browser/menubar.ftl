# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = Bestân
    .accesskey = B
menu-file-new-tab =
    .label = Nij ljepblêd
    .accesskey = L
menu-file-new-container-tab =
    .label = Nij kontenerljepblêd
    .accesskey = k
menu-file-new-window =
    .label = Nij finster
    .accesskey = N
menu-file-new-private-window =
    .label = Nij priveefinster
    .accesskey = p
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Lokaasje iepenje…
menu-file-open-file =
    .label = Bestân iepenje…
    .accesskey = i
menu-file-close =
    .label = Slute
    .accesskey = S
menu-file-close-window =
    .label = Finster slute
    .accesskey = s
menu-file-save-page =
    .label = Side bewarje as…
    .accesskey = a
menu-file-email-link =
    .label = Keppeling e-maile…
    .accesskey = e
menu-file-print-setup =
    .label = Side-ynstellingen…
    .accesskey = y
menu-file-print-preview =
    .label = Ofdrukfoarbyld
    .accesskey = f
menu-file-print =
    .label = Ofdrukke…
    .accesskey = d
menu-file-import-from-another-browser =
    .label = Ymportearje fan in oare browser út…
    .accesskey = b
menu-file-go-offline =
    .label = Offline wurkje
    .accesskey = w

## Edit Menu

menu-edit =
    .label = Bewurkje
    .accesskey = W
menu-edit-find-on =
    .label = Sykje op dizze side…
    .accesskey = S
menu-edit-find-again =
    .label = Opnij sykje
    .accesskey = s
menu-edit-bidi-switch-text-direction =
    .label = Tekstrjochting draaie
    .accesskey = t

## View Menu

menu-view =
    .label = Byld
    .accesskey = y
menu-view-toolbars-menu =
    .label = Arkbalken
    .accesskey = A
menu-view-customize-toolbar =
    .label = Oanpasse…
    .accesskey = O
menu-view-sidebar =
    .label = Sidebalke
    .accesskey = S
menu-view-bookmarks =
    .label = Blêdwizers
menu-view-history-button =
    .label = Skiednis
menu-view-synced-tabs-sidebar =
    .label = Syngronisearre ljepblêden
menu-view-full-zoom =
    .label = Zoome
    .accesskey = Z
menu-view-full-zoom-enlarge =
    .label = Ynzoome
    .accesskey = Y
menu-view-full-zoom-reduce =
    .label = Utzoome
    .accesskey = U
menu-view-full-zoom-actual-size =
    .label = Wurklike grutte
    .accesskey = W
menu-view-full-zoom-toggle =
    .label = Allinnich tekst zoome
    .accesskey = A
menu-view-page-style-menu =
    .label = Sidestyl
    .accesskey = d
menu-view-page-style-no-style =
    .label = Gjin styl
    .accesskey = G
menu-view-page-basic-style =
    .label = Basisstyl
    .accesskey = B
menu-view-charset =
    .label = Tekenkodearring
    .accesskey = T

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Folslein skerm werjefte
    .accesskey = S
menu-view-exit-full-screen =
    .label = Folslein skerm werjefte ferlitte
    .accesskey = S
menu-view-full-screen =
    .label = Folslein skerm
    .accesskey = F

##

menu-view-show-all-tabs =
    .label = Alle ljepblêden toane
    .accesskey = A
menu-view-bidi-switch-page-direction =
    .label = Siderjochting draaie
    .accesskey = g

## History Menu

menu-history =
    .label = Skiednis
    .accesskey = S
menu-history-show-all-history =
    .label = Alle skiednis toane
menu-history-clear-recent-history =
    .label = Resinte skiednis wiskje…
menu-history-synced-tabs =
    .label = Syngronisearre ljepblêden
menu-history-restore-last-session =
    .label = Foargeande sesje werom bringe
menu-history-hidden-tabs =
    .label = Ferstoppe ljepblêden
menu-history-undo-menu =
    .label = Koartlyn sluten ljepblêden
menu-history-undo-window-menu =
    .label = Koartlyn sluten skermen

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Blêdwizers
    .accesskey = D
menu-bookmarks-show-all =
    .label = Alle blêdwizers toane
menu-bookmark-this-page =
    .label = Blêdwizer foar dizze side meitsje
menu-bookmark-edit =
    .label = Dizze blêdwizer bewurkje
menu-bookmarks-all-tabs =
    .label = Blêdwizer foar alle ljepblêden meitsje…
menu-bookmarks-toolbar =
    .label = Blêdwizerarkbalke
menu-bookmarks-other =
    .label = Oare blêdwizers
menu-bookmarks-mobile =
    .label = Mobyl-blêdwizers

## Tools Menu

menu-tools =
    .label = Ekstra
    .accesskey = E
menu-tools-downloads =
    .label = Downloads
    .accesskey = D
menu-tools-addons =
    .label = Add-ons
    .accesskey = A
menu-tools-fxa-sign-in =
    .label = Oanmelde by { -brand-product-name }…
    .accesskey = m
menu-tools-turn-on-sync =
    .label = { -sync-brand-short-name } ynskeakelje…
    .accesskey = y
menu-tools-sync-now =
    .label = No syngronisearje
    .accesskey = N
menu-tools-fxa-re-auth =
    .label = Opnij ferbine mei { -brand-product-name }…
    .accesskey = O
menu-tools-web-developer =
    .label = Webûntwikkeler
    .accesskey = W
menu-tools-page-source =
    .label = Sideboarne
    .accesskey = r
menu-tools-page-info =
    .label = Side-ynfo
    .accesskey = f
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opsjes
           *[other] Foarkarren…
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] F
        }
menu-tools-layout-debugger =
    .label = Lay-out-debugger
    .accesskey = L

## Window Menu

menu-window-menu =
    .label = Finster
menu-window-bring-all-to-front =
    .label = Alles nei foaren bringe

## Help Menu

menu-help =
    .label = Help
    .accesskey = H
menu-help-product =
    .label = { -brand-shorter-name } Help
    .accesskey = H
menu-help-show-tour =
    .label = { -brand-shorter-name }-toer
    .accesskey = o
menu-help-import-from-another-browser =
    .label = Ymportearje fan in oare browser út…
    .accesskey = Y
menu-help-keyboard-shortcuts =
    .label = Fluchtoetsen
    .accesskey = t
menu-help-troubleshooting-info =
    .label = Probleemoplossingsynformaasje
    .accesskey = P
menu-help-feedback-page =
    .label = Feedback ferstjoere…
    .accesskey = f
menu-help-safe-mode-without-addons =
    .label = Werstart mei útskeakele add-ons…
    .accesskey = W
menu-help-safe-mode-with-addons =
    .label = Opnij starte mei ynskeakele add-ons
    .accesskey = r
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Misliedende website rapportearje…
    .accesskey = M
menu-help-not-deceptive =
    .label = Dit is gjin misliedende website…
    .accesskey = m
