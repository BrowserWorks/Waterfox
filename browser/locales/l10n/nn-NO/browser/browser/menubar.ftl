# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# NOTE: For English locales, strings in this file should be in APA-style Title Case.
# See https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case
#
# NOTE: For Engineers, please don't re-use these strings outside of the menubar.


## Application Menu (macOS only)

menu-application-preferences =
    .label = Innstillingar
menu-application-services =
    .label = Tenester
menu-application-hide-this =
    .label = Gøym { -brand-shorter-name }
menu-application-hide-other =
    .label = Gøym andre
menu-application-show-all =
    .label = Vis alle
menu-application-touch-bar =
    .label = Tilpass Touch Bar…

##

# These menu-quit strings are only used on Windows and Linux.
menu-quit =
    .label =
        { PLATFORM() ->
            [windows] Avslutt
           *[other] Avslutt
        }
    .accesskey =
        { PLATFORM() ->
            [windows] t
           *[other] t
        }
# This menu-quit-mac string is only used on macOS.
menu-quit-mac =
    .label = Avslutt { -brand-shorter-name }
# This menu-quit-button string is only used on Linux.
menu-quit-button =
    .label = { menu-quit.label }
# This menu-quit-button-win string is only used on Windows.
menu-quit-button-win =
    .label = { menu-quit.label }
    .tooltip = Avslutt { -brand-shorter-name }
menu-about =
    .label = Om { -brand-shorter-name }
    .accesskey = O

## File Menu

menu-file =
    .label = Fil
    .accesskey = F
menu-file-new-tab =
    .label = Ny fane
    .accesskey = f
menu-file-new-container-tab =
    .label = Ny innhaldsfane
    .accesskey = i
menu-file-new-window =
    .label = Nytt vindauge
    .accesskey = N
menu-file-new-private-window =
    .label = Nytt privat vindauge
    .accesskey = v
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Opne adresse…
menu-file-open-file =
    .label = Opne fil…
    .accesskey = O
menu-file-close =
    .label = Lat att
    .accesskey = L
menu-file-close-window =
    .label = Lat att vindauge
    .accesskey = L
menu-file-save-page =
    .label = Lagre sida som…
    .accesskey = a
menu-file-email-link =
    .label = Send lenke på e-post…
    .accesskey = e
menu-file-print-setup =
    .label = Utskriftsformat…
    .accesskey = m
menu-file-print-preview =
    .label = Førehandsvis sida
    .accesskey = v
menu-file-print =
    .label = Skriv ut…
    .accesskey = u
menu-file-import-from-another-browser =
    .label = Importer frå ein annan nettlesar…
    .accesskey = I
menu-file-go-offline =
    .label = Arbeid fråkopla
    .accesskey = r

## Edit Menu

menu-edit =
    .label = Rediger
    .accesskey = R
menu-edit-find-on =
    .label = Søk på denne sida…
    .accesskey = S
menu-edit-find-in-page =
    .label = Finn på sida…
    .accesskey = F
menu-edit-find-again =
    .label = Søk igjen
    .accesskey = ø
menu-edit-bidi-switch-text-direction =
    .label = Byt tekstretning
    .accesskey = B

## View Menu

menu-view =
    .label = Vis
    .accesskey = V
menu-view-toolbars-menu =
    .label = Verktøylinjer
    .accesskey = V
menu-view-customize-toolbar =
    .label = Tilpass…
    .accesskey = T
menu-view-customize-toolbar2 =
    .label = Tilpass verktøylinje…
    .accesskey = T
menu-view-sidebar =
    .label = Sidestolpe
    .accesskey = d
menu-view-bookmarks =
    .label = Bokmerke
menu-view-history-button =
    .label = Historikk
menu-view-synced-tabs-sidebar =
    .label = Synkroniserte faner
menu-view-full-zoom =
    .label = Skalering
    .accesskey = r
menu-view-full-zoom-enlarge =
    .label = Større skrift
    .accesskey = S
menu-view-full-zoom-reduce =
    .label = Mindre skrift
    .accesskey = M
menu-view-full-zoom-actual-size =
    .label = Verkeleg storleik
    .accesskey = V
menu-view-full-zoom-toggle =
    .label = Forstørr berre tekst
    .accesskey = o
menu-view-page-style-menu =
    .label = Sidestil
    .accesskey = e
menu-view-page-style-no-style =
    .label = Ingen
    .accesskey = I
menu-view-page-basic-style =
    .label = Vanleg
    .accesskey = V
menu-view-charset =
    .label = Teiknkoding
    .accesskey = T
menu-view-repair-text-encoding =
    .label = Reparer tekstkoding
    .accesskey = e

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Opne fullskjerm
    .accesskey = n
menu-view-exit-full-screen =
    .label = Avslutt fullskjerm
    .accesskey = v
menu-view-full-screen =
    .label = Fullskjerm
    .accesskey = F

##

menu-view-show-all-tabs =
    .label = Vis alle faner
    .accesskey = V
menu-view-bidi-switch-page-direction =
    .label = Byt tekstretning på sida
    .accesskey = r

## History Menu

menu-history =
    .label = Historikk
    .accesskey = s
menu-history-show-all-history =
    .label = Vis all historikk
menu-history-clear-recent-history =
    .label = Slett nyleg historikk…
menu-history-synced-tabs =
    .label = Synkronisterte faner
menu-history-restore-last-session =
    .label = Bygg oppatt siste programøkt
menu-history-hidden-tabs =
    .label = Gøymde faner
menu-history-undo-menu =
    .label = Nyleg attlatne faner
menu-history-undo-window-menu =
    .label = Nyleg attlatne vindauge
menu-history-reopen-all-tabs = Opne alle faner på nytt
menu-history-reopen-all-windows = Opne alle vindauge på nytt

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Bokmerke
    .accesskey = B
menu-bookmarks-show-all =
    .label = Vis alle bokmerka
menu-bookmark-this-page =
    .label = Bokmerk denne sida
menu-bookmarks-manage =
    .label = Handter bokmerke
menu-bookmark-current-tab =
    .label = Bokmerk gjeldande fane
menu-bookmark-edit =
    .label = Rediger dette bokmerket
menu-bookmarks-all-tabs =
    .label = Bokmerk alle faner…
menu-bookmarks-toolbar =
    .label = Bokmerkelinje
menu-bookmarks-other =
    .label = Andre bokmerke
menu-bookmarks-mobile =
    .label = Mobile bokmerke

## Tools Menu

menu-tools =
    .label = Verktøy
    .accesskey = e
menu-tools-downloads =
    .label = Nedlastingar
    .accesskey = N
menu-tools-addons =
    .label = Tillegg
    .accesskey = T
menu-tools-fxa-sign-in =
    .label = Logg inn på { -brand-product-name }…
    .accesskey = g
menu-tools-turn-on-sync =
    .label = Slå på { -sync-brand-short-name }…
    .accesskey = S
menu-tools-addons-and-themes =
    .label = Tillegg og tema
    .accesskey = T
menu-tools-fxa-sign-in2 =
    .label = Logg inn
    .accesskey = L
menu-tools-turn-on-sync2 =
    .label = Slå på synkronisering…
    .accesskey = S
menu-tools-sync-now =
    .label = Synkroniser no
    .accesskey = S
menu-tools-fxa-re-auth =
    .label = Kople til { -brand-product-name } på nytt…
    .accesskey = K
menu-tools-web-developer =
    .label = Nettsideutvikling
    .accesskey = N
menu-tools-browser-tools =
    .label = Nettlesarverktøy
    .accesskey = N
menu-tools-task-manager =
    .label = Oppgåvehandterar
    .accesskey = O
menu-tools-page-source =
    .label = Kjeldekode
    .accesskey = d
menu-tools-page-info =
    .label = Sideinformasjon
    .accesskey = d
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Innstillingar
           *[other] Innstillingar
        }
    .accesskey =
        { PLATFORM() ->
            [windows] I
           *[other] I
        }
menu-settings =
    .label = Innstillingar
    .accesskey =
        { PLATFORM() ->
            [windows] n
           *[other] n
        }
menu-tools-layout-debugger =
    .label = Feilsøk layout
    .accesskey = F

## Window Menu

menu-window-menu =
    .label = Vindauge
menu-window-bring-all-to-front =
    .label = Send alle til framgrunnen

## Help Menu


# NOTE: For Engineers, any additions or changes to Help menu strings should
# also be reflected in the related strings in appmenu.ftl. Those strings, by
# convention, will have the same ID as these, but prefixed with "app".
# Example: appmenu-get-help
#
# These strings are duplicated to allow for different casing depending on
# where the strings appear.

menu-help =
    .label = Hjelp
    .accesskey = H
menu-help-product =
    .label = { -brand-shorter-name } Hjelp
    .accesskey = H
menu-help-show-tour =
    .label = Omvising i { -brand-shorter-name }
    .accesskey = m
menu-help-import-from-another-browser =
    .label = Importer frå ein annan nettlesar…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Tastatursnarvegar
    .accesskey = T
menu-help-troubleshooting-info =
    .label = Feilsøking
    .accesskey = e
menu-get-help =
    .label = Få hjelp
    .accesskey = F
menu-help-more-troubleshooting-info =
    .label = Meir feilsøkingsinformasjon
    .accesskey = M
menu-help-report-site-issue =
    .label = Rapporter problem med nettstad…
menu-help-feedback-page =
    .label = Gje tilbakemelding…
    .accesskey = G
menu-help-safe-mode-without-addons =
    .label = Start på nytt med avslåtte tillegg…
    .accesskey = S
menu-help-safe-mode-with-addons =
    .label = Start på nytt med påslåtte tillegg
    .accesskey = S
menu-help-enter-troubleshoot-mode2 =
    .label = Feilsøkingsmodus…
    .accesskey = F
menu-help-exit-troubleshoot-mode =
    .label = Slå av feilsøkingsmodus
    .accesskey = S
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Rapporter villeiande nettstad…
    .accesskey = R
menu-help-not-deceptive =
    .label = Dette er ikkje ein villeiande nettstad…
    .accesskey = d
