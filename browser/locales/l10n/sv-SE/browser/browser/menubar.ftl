# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# NOTE: For English locales, strings in this file should be in APA-style Title Case.
# See https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case
#
# NOTE: For Engineers, please don't re-use these strings outside of the menubar.


## Application Menu (macOS only)

menu-application-preferences =
    .label = Inställningar
menu-application-services =
    .label = Tjänster
menu-application-hide-this =
    .label = Göm { -brand-shorter-name }
menu-application-hide-other =
    .label = Göm övriga
menu-application-show-all =
    .label = Visa alla
menu-application-touch-bar =
    .label = Anpassa menyrad för Touch…

##

# These menu-quit strings are only used on Windows and Linux.
menu-quit =
    .label =
        { PLATFORM() ->
            [windows] Avsluta
           *[other] Avsluta
        }
    .accesskey =
        { PLATFORM() ->
            [windows] A
           *[other] A
        }
# This menu-quit-mac string is only used on macOS.
menu-quit-mac =
    .label = Avsluta { -brand-shorter-name }
# This menu-quit-button string is only used on Linux.
menu-quit-button =
    .label = { menu-quit.label }
# This menu-quit-button-win string is only used on Windows.
menu-quit-button-win =
    .label = { menu-quit.label }
    .tooltip = Avsluta { -brand-shorter-name }
menu-about =
    .label = Om { -brand-shorter-name }
    .accesskey = O

## File Menu

menu-file =
    .label = Arkiv
    .accesskey = A
menu-file-new-tab =
    .label = Ny flik
    .accesskey = f
menu-file-new-container-tab =
    .label = Ny innehållsflik
    .accesskey = k
menu-file-new-window =
    .label = Nytt fönster
    .accesskey = N
menu-file-new-private-window =
    .label = Nytt privat fönster
    .accesskey = t
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Öppna adress…
menu-file-open-file =
    .label = Öppna fil…
    .accesskey = Ö
menu-file-close =
    .label = Stäng
    .accesskey = ä
menu-file-close-window =
    .label = Stäng fönster
    .accesskey = t
menu-file-save-page =
    .label = Spara sida som…
    .accesskey = m
menu-file-email-link =
    .label = E-posta länk…
    .accesskey = E
menu-file-print-setup =
    .label = Utskriftsformat…
    .accesskey = o
menu-file-print-preview =
    .label = Förhandsgranska…
    .accesskey = h
menu-file-print =
    .label = Skriv ut…
    .accesskey = u
menu-file-import-from-another-browser =
    .label = Importera från en annan webbläsare…
    .accesskey = m
menu-file-go-offline =
    .label = Arbeta nedkopplad
    .accesskey = b

## Edit Menu

menu-edit =
    .label = Redigera
    .accesskey = R
menu-edit-find-on =
    .label = Sök på den här sidan…
    .accesskey = S
menu-edit-find-in-page =
    .label = Hitta på sidan…
    .accesskey = H
menu-edit-find-again =
    .label = Sök igen
    .accesskey = ö
menu-edit-bidi-switch-text-direction =
    .label = Byt textriktning
    .accesskey = t

## View Menu

menu-view =
    .label = Visa
    .accesskey = s
menu-view-toolbars-menu =
    .label = Verktygsfält
    .accesskey = V
menu-view-customize-toolbar =
    .label = Anpassa…
    .accesskey = A
menu-view-customize-toolbar2 =
    .label = Anpassa verktygsfält…
    .accesskey = A
menu-view-sidebar =
    .label = Sidofält
    .accesskey = o
menu-view-bookmarks =
    .label = Bokmärken
menu-view-history-button =
    .label = Historik
menu-view-synced-tabs-sidebar =
    .label = Synkade Flikar
menu-view-full-zoom =
    .label = Zoom
    .accesskey = Z
menu-view-full-zoom-enlarge =
    .label = Zooma in
    .accesskey = Z
menu-view-full-zoom-reduce =
    .label = Zooma ut
    .accesskey = u
menu-view-full-zoom-actual-size =
    .label = Verklig storlek
    .accesskey = V
menu-view-full-zoom-toggle =
    .label = Zooma endast texten
    .accesskey = e
menu-view-page-style-menu =
    .label = Sidstil
    .accesskey = d
menu-view-page-style-no-style =
    .label = Ingen
    .accesskey = I
menu-view-page-basic-style =
    .label = Normal sidstil
    .accesskey = N
menu-view-charset =
    .label = Textkodning
    .accesskey = k
menu-view-repair-text-encoding =
    .label = Reparera textkodning
    .accesskey = k

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Aktivera helskärm
    .accesskey = h
menu-view-exit-full-screen =
    .label = Stäng helskärm
    .accesskey = h
menu-view-full-screen =
    .label = Helskärm
    .accesskey = H

##

menu-view-show-all-tabs =
    .label = Visa alla flikar
    .accesskey = f
menu-view-bidi-switch-page-direction =
    .label = Byt sidriktning
    .accesskey = B

## History Menu

menu-history =
    .label = Historik
    .accesskey = o
menu-history-show-all-history =
    .label = Visa all historik
menu-history-clear-recent-history =
    .label = Rensa ut tidigare historik…
menu-history-synced-tabs =
    .label = Synkade flikar
menu-history-restore-last-session =
    .label = Återställ föregående session
menu-history-hidden-tabs =
    .label = Dolda flikar
menu-history-undo-menu =
    .label = Nyligen stängda flikar
menu-history-undo-window-menu =
    .label = Nyligen stängda fönster
menu-history-reopen-all-tabs = Återöppna alla flikar
menu-history-reopen-all-windows = Återöppna alla fönster

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Bokmärken
    .accesskey = B
menu-bookmarks-show-all =
    .label = Visa alla bokmärken
menu-bookmark-this-page =
    .label = Bokmärk denna sida
menu-bookmarks-manage =
    .label = Hantera bokmärken
menu-bookmark-current-tab =
    .label = Bokmärk aktuell flik
menu-bookmark-edit =
    .label = Redigera bokmärket
menu-bookmarks-all-tabs =
    .label = Bokmärke för alla flikar…
menu-bookmarks-toolbar =
    .label = Bokmärkesfältet
menu-bookmarks-other =
    .label = Andra bokmärken
menu-bookmarks-mobile =
    .label = Mobila bokmärken

## Tools Menu

menu-tools =
    .label = Verktyg
    .accesskey = V
menu-tools-downloads =
    .label = Filhämtaren
    .accesskey = F
menu-tools-addons =
    .label = Tillägg
    .accesskey = T
menu-tools-fxa-sign-in =
    .label = Logga in till { -brand-product-name }…
    .accesskey = g
menu-tools-turn-on-sync =
    .label = Slå på { -sync-brand-short-name }…
    .accesskey = p
menu-tools-addons-and-themes =
    .label = Tillägg och teman
    .accesskey = T
menu-tools-fxa-sign-in2 =
    .label = Logga in
    .accesskey = L
menu-tools-turn-on-sync2 =
    .label = Aktivera synkronisering…
    .accesskey = A
menu-tools-sync-now =
    .label = Synka nu
    .accesskey = n
menu-tools-fxa-re-auth =
    .label = Återanslut till { -brand-product-name }…
    .accesskey = t
menu-tools-web-developer =
    .label = Webbutvecklare
    .accesskey = W
menu-tools-browser-tools =
    .label = Webbläsarverktyg
    .accesskey = W
menu-tools-task-manager =
    .label = Aktivitetshanterare
    .accesskey = A
menu-tools-page-source =
    .label = Källkod
    .accesskey = ä
menu-tools-page-info =
    .label = Sidinfo
    .accesskey = d
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Inställningar
           *[other] Inställningar
        }
    .accesskey =
        { PLATFORM() ->
            [windows] I
           *[other] I
        }
menu-settings =
    .label = Inställningar
    .accesskey =
        { PLATFORM() ->
            [windows] n
           *[other] n
        }
menu-tools-layout-debugger =
    .label = Felsök layout
    .accesskey = e

## Window Menu

menu-window-menu =
    .label = Fönster
menu-window-bring-all-to-front =
    .label = Lägg alla överst

## Help Menu


# NOTE: For Engineers, any additions or changes to Help menu strings should
# also be reflected in the related strings in appmenu.ftl. Those strings, by
# convention, will have the same ID as these, but prefixed with "app".
# Example: appmenu-get-help
#
# These strings are duplicated to allow for different casing depending on
# where the strings appear.

menu-help =
    .label = Hjälp
    .accesskey = H
menu-help-product =
    .label = { -brand-shorter-name } Hjälp
    .accesskey = H
menu-help-show-tour =
    .label = { -brand-shorter-name }-guide
    .accesskey = d
menu-help-import-from-another-browser =
    .label = Importera från en annan webbläsare…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Tangentbordskommandon
    .accesskey = T
menu-help-troubleshooting-info =
    .label = Felsökningsinformation
    .accesskey = F
menu-get-help =
    .label = Få hjälp
    .accesskey = h
menu-help-more-troubleshooting-info =
    .label = Mer felsökningsinformation
    .accesskey = f
menu-help-report-site-issue =
    .label = Rapportera webbplatsproblem…
menu-help-feedback-page =
    .label = Skicka in feedback…
    .accesskey = k
menu-help-safe-mode-without-addons =
    .label = Starta om utan tillägg…
    .accesskey = S
menu-help-safe-mode-with-addons =
    .label = Starta om med tillägg aktiverade
    .accesskey = S
menu-help-enter-troubleshoot-mode2 =
    .label = Felsökningsläge…
    .accesskey = F
menu-help-exit-troubleshoot-mode =
    .label = Stäng av felsökningsläge
    .accesskey = g
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Rapportera vilseledande webbplats…
    .accesskey = d
menu-help-not-deceptive =
    .label = Detta är inte en vilseledande webbplats…
    .accesskey = v
