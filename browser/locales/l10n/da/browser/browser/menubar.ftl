# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# NOTE: For English locales, strings in this file should be in APA-style Title Case.
# See https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case
#
# NOTE: For Engineers, please don't re-use these strings outside of the menubar.


## Application Menu (macOS only)

menu-application-preferences =
    .label = Indstillinger
menu-application-services =
    .label = Tjenester
menu-application-hide-this =
    .label = Skjul { -brand-shorter-name }
menu-application-hide-other =
    .label = Skjul andre
menu-application-show-all =
    .label = Vis alle
menu-application-touch-bar =
    .label = Tilpas Touch Bar…

##

# These menu-quit strings are only used on Windows and Linux.
menu-quit =
    .label =
        { PLATFORM() ->
            [windows] Afslut
           *[other] Afslut
        }
    .accesskey =
        { PLATFORM() ->
            [windows] A
           *[other] A
        }
# This menu-quit-mac string is only used on macOS.
menu-quit-mac =
    .label = Afslut { -brand-shorter-name }
# This menu-quit-button string is only used on Linux.
menu-quit-button =
    .label = { menu-quit.label }
# This menu-quit-button-win string is only used on Windows.
menu-quit-button-win =
    .label = { menu-quit.label }
    .tooltip = Afslut { -brand-shorter-name }
menu-about =
    .label = Om { -brand-shorter-name }
    .accesskey = O

## File Menu

menu-file =
    .label = Filer
    .accesskey = F
menu-file-new-tab =
    .label = Nyt faneblad
    .accesskey = f
menu-file-new-container-tab =
    .label = Nyt kontekst-faneblad
    .accesskey = k
menu-file-new-window =
    .label = Nyt vindue
    .accesskey = v
menu-file-new-private-window =
    .label = Nyt privat vindue
    .accesskey = p
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Åbn…
menu-file-open-file =
    .label = Åbn fil…
    .accesskey = b
menu-file-close =
    .label = Luk
    .accesskey = L
menu-file-close-window =
    .label = Luk vindue
    .accesskey = k
menu-file-save-page =
    .label = Gem side som…
    .accesskey = m
menu-file-email-link =
    .label = Send link…
    .accesskey = l
menu-file-print-setup =
    .label = Sideopsætning…
    .accesskey = S
menu-file-print-preview =
    .label = Vis udskrift
    .accesskey = d
menu-file-print =
    .label = Udskriv…
    .accesskey = U
menu-file-import-from-another-browser =
    .label = Importer fra en anden browser…
    .accesskey = I
menu-file-go-offline =
    .label = Arbejd offline
    .accesskey = o

## Edit Menu

menu-edit =
    .label = Rediger
    .accesskey = R
menu-edit-find-on =
    .label = Find på denne side…
    .accesskey = d
menu-edit-find-in-page =
    .label = Find på side…
    .accesskey = d
menu-edit-find-again =
    .label = Find næste
    .accesskey = n
menu-edit-bidi-switch-text-direction =
    .label = Skift tekstretning
    .accesskey = t

## View Menu

menu-view =
    .label = Vis
    .accesskey = V
menu-view-toolbars-menu =
    .label = Værktøjslinjer
    .accesskey = V
menu-view-customize-toolbar =
    .label = Tilpas…
    .accesskey = p
menu-view-customize-toolbar2 =
    .label = Tilpas værktøjslinje…
    .accesskey = T
menu-view-sidebar =
    .label = Sidepaneler
    .accesskey = S
menu-view-bookmarks =
    .label = Bogmærker
menu-view-history-button =
    .label = Historik
menu-view-synced-tabs-sidebar =
    .label = Synkroniserede faneblade
menu-view-full-zoom =
    .label = Zoom
    .accesskey = Z
menu-view-full-zoom-enlarge =
    .label = Zoom ind
    .accesskey = i
menu-view-full-zoom-reduce =
    .label = Zoom ud
    .accesskey = u
menu-view-full-zoom-actual-size =
    .label = Faktisk størrelse
    .accesskey = F
menu-view-full-zoom-toggle =
    .label = Zoom kun tekst
    .accesskey = t
menu-view-page-style-menu =
    .label = Sidestil
    .accesskey = i
menu-view-page-style-no-style =
    .label = Ingen sidestil
    .accesskey = I
menu-view-page-basic-style =
    .label = Basissidestil
    .accesskey = B
menu-view-charset =
    .label = Tegnkodning
    .accesskey = T

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Start fuld skærm
    .accesskey = F
menu-view-exit-full-screen =
    .label = Afslut fuld skærm
    .accesskey = F
menu-view-full-screen =
    .label = Fuld skærm
    .accesskey = F

##

menu-view-show-all-tabs =
    .label = Vis alle faneblade
    .accesskey = a
menu-view-bidi-switch-page-direction =
    .label = Skift sideretning
    .accesskey = g

## History Menu

menu-history =
    .label = Historik
    .accesskey = i
menu-history-show-all-history =
    .label = Vis al historik
menu-history-clear-recent-history =
    .label = Ryd seneste historik…
menu-history-synced-tabs =
    .label = Synkroniserede faneblade
menu-history-restore-last-session =
    .label = Gendan forrige session
menu-history-hidden-tabs =
    .label = Skjulte faneblade
menu-history-undo-menu =
    .label = Senest lukkede faneblade
menu-history-undo-window-menu =
    .label = Senest lukkede vinduer
menu-history-reopen-all-tabs = Genåbn alle faneblade
menu-history-reopen-all-windows = Genåbn alle vinduer

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Bogmærker
    .accesskey = B
menu-bookmarks-show-all =
    .label = Vis alle bogmærker
menu-bookmark-this-page =
    .label = Bogmærk denne side
menu-bookmark-current-tab =
    .label = Bogmærk dette faneblad
menu-bookmark-edit =
    .label = Rediger bogmærke
menu-bookmarks-all-tabs =
    .label = Bogmærk alle faneblade…
menu-bookmarks-toolbar =
    .label = Bogmærkelinje
menu-bookmarks-other =
    .label = Andre bogmærker
menu-bookmarks-mobile =
    .label = Mobil-bogmærker

## Tools Menu

menu-tools =
    .label = Funktioner
    .accesskey = u
menu-tools-downloads =
    .label = Filhentning
    .accesskey = F
menu-tools-addons =
    .label = Tilføjelser
    .accesskey = t
menu-tools-fxa-sign-in =
    .label = Log ind på { -brand-product-name }…
    .accesskey = g
menu-tools-addons-and-themes =
    .label = Tilføjelser og temaer
    .accesskey = T
menu-tools-fxa-sign-in2 =
    .label = Log ind
    .accesskey = L
menu-tools-turn-on-sync =
    .label = Aktiver { -sync-brand-short-name }…
    .accesskey = A
menu-tools-turn-on-sync2 =
    .label = Slå synkronisering til
    .accesskey = S
menu-tools-sync-now =
    .label = Synkroniser nu
    .accesskey = S
menu-tools-fxa-re-auth =
    .label = Genopret forbindelse til { -brand-product-name }…
    .accesskey = G
menu-tools-web-developer =
    .label = Webudvikler
    .accesskey = W
menu-tools-browser-tools =
    .label = Browser-værktøj
    .accesskey = B
menu-tools-task-manager =
    .label = Jobliste
    .accesskey = J
menu-tools-page-source =
    .label = Sidens kildekode
    .accesskey = k
menu-tools-page-info =
    .label = Sideoplysninger
    .accesskey = o
menu-settings =
    .label = Indstillinger
    .accesskey =
        { PLATFORM() ->
            [windows] I
           *[other] t
        }
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Indstillinger
           *[other] Indstillinger
        }
    .accesskey =
        { PLATFORM() ->
            [windows] I
           *[other] I
        }
menu-tools-layout-debugger =
    .label = Layout-debugger
    .accesskey = d

## Window Menu

menu-window-menu =
    .label = Vindue
menu-window-bring-all-to-front =
    .label = Vis alle vinduer

## Help Menu


# NOTE: For Engineers, any additions or changes to Help menu strings should
# also be reflected in the related strings in appmenu.ftl. Those strings, by
# convention, will have the same ID as these, but prefixed with "app".
# Example: appmenu-get-help
#
# These strings are duplicated to allow for different casing depending on
# where the strings appear.

menu-help =
    .label = Hjælp
    .accesskey = H
menu-help-product =
    .label = Hjælp til { -brand-shorter-name }
    .accesskey = H
menu-help-show-tour =
    .label = Rundvisning i { -brand-shorter-name }
    .accesskey = R
menu-help-import-from-another-browser =
    .label = Importer fra en anden browser…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Tastaturgenveje
    .accesskey = u
menu-get-help =
    .label = Få hjælp
    .accesskey = h
menu-help-troubleshooting-info =
    .label = Teknisk information…
    .accesskey = T
menu-help-taskmanager =
    .label = Jobliste
menu-help-more-troubleshooting-info =
    .label = Mere teknisk information
    .accesskey = t
menu-help-report-site-issue =
    .label = Rapportér problem med websted…
menu-help-feedback-page =
    .label = Indsend feedback…
    .accesskey = n
menu-help-safe-mode-without-addons =
    .label = Genstart med tilføjelser deaktiveret…
    .accesskey = G
menu-help-safe-mode-with-addons =
    .label = Genstart med tilføjelser aktiveret
    .accesskey = G
menu-help-enter-troubleshoot-mode2 =
    .label = Fejlsøgnings-tilstand…
    .accesskey = F
menu-help-exit-troubleshoot-mode =
    .label = Slå fejlsøgnings-tilstand fra
    .accesskey = f
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Anmeld vildledende websted…
    .accesskey = A
menu-help-not-deceptive =
    .label = Dette er ikke et vildledende websted…
    .accesskey = v
