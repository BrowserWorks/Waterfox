# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# NOTE: For English locales, strings in this file should be in APA-style Title Case.
# See https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case
#
# NOTE: For Engineers, please don't re-use these strings outside of the menubar.


## Application Menu (macOS only)

menu-application-preferences =
    .label = Voorkeuren
menu-application-services =
    .label = Services
menu-application-hide-this =
    .label = Verberg { -brand-shorter-name }
menu-application-hide-other =
    .label = Verberg andere
menu-application-show-all =
    .label = Toon alles
menu-application-touch-bar =
    .label = Aanraakbalk aanpassen…

##

# These menu-quit strings are only used on Windows and Linux.
menu-quit =
    .label =
        { PLATFORM() ->
            [windows] Afsluiten
           *[other] Afsluiten
        }
    .accesskey =
        { PLATFORM() ->
            [windows] A
           *[other] A
        }
# This menu-quit-mac string is only used on macOS.
menu-quit-mac =
    .label = { -brand-shorter-name } afsluiten
# This menu-quit-button string is only used on Linux.
menu-quit-button =
    .label = { menu-quit.label }
# This menu-quit-button-win string is only used on Windows.
menu-quit-button-win =
    .label = { menu-quit.label }
    .tooltip = { -brand-shorter-name } afsluiten
menu-about =
    .label = Over { -brand-shorter-name }
    .accesskey = O

## File Menu

menu-file =
    .label = Bestand
    .accesskey = B
menu-file-new-tab =
    .label = Nieuw tabblad
    .accesskey = t
menu-file-new-container-tab =
    .label = Nieuw containertabblad
    .accesskey = c
menu-file-new-window =
    .label = Nieuw venster
    .accesskey = N
menu-file-new-private-window =
    .label = Nieuw privévenster
    .accesskey = r
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Locatie openen…
menu-file-open-file =
    .label = Bestand openen…
    .accesskey = o
menu-file-close =
    .label = Sluiten
    .accesskey = S
menu-file-close-window =
    .label = Venster sluiten
    .accesskey = e
menu-file-save-page =
    .label = Pagina opslaan als…
    .accesskey = p
menu-file-email-link =
    .label = Koppeling e-mailen…
    .accesskey = m
menu-file-print-setup =
    .label = Pagina-instellingen…
    .accesskey = i
menu-file-print-preview =
    .label = Afdrukvoorbeeld
    .accesskey = v
menu-file-print =
    .label = Afdrukken…
    .accesskey = d
menu-file-import-from-another-browser =
    .label = Importeren vanuit een andere browser…
    .accesskey = b
menu-file-go-offline =
    .label = Offline werken
    .accesskey = f

## Edit Menu

menu-edit =
    .label = Bewerken
    .accesskey = w
menu-edit-find-on =
    .label = Zoeken op deze pagina…
    .accesskey = Z
menu-edit-find-in-page =
    .label = Zoeken op pagina…
    .accesskey = Z
menu-edit-find-again =
    .label = Opnieuw zoeken
    .accesskey = w
menu-edit-bidi-switch-text-direction =
    .label = Tekstrichting omkeren
    .accesskey = t

## View Menu

menu-view =
    .label = Beeld
    .accesskey = l
menu-view-toolbars-menu =
    .label = Werkbalken
    .accesskey = W
menu-view-customize-toolbar =
    .label = Aanpassen…
    .accesskey = A
menu-view-customize-toolbar2 =
    .label = Werkbalk aanpassen…
    .accesskey = p
menu-view-sidebar =
    .label = Zijbalk
    .accesskey = Z
menu-view-bookmarks =
    .label = Bladwijzers
menu-view-history-button =
    .label = Geschiedenis
menu-view-synced-tabs-sidebar =
    .label = Gesynchroniseerde tabbladen
menu-view-full-zoom =
    .label = Zoomen
    .accesskey = o
menu-view-full-zoom-enlarge =
    .label = Inzoomen
    .accesskey = I
menu-view-full-zoom-reduce =
    .label = Uitzoomen
    .accesskey = U
menu-view-full-zoom-actual-size =
    .label = Werkelijke grootte
    .accesskey = W
menu-view-full-zoom-toggle =
    .label = Alleen tekst zoomen
    .accesskey = t
menu-view-page-style-menu =
    .label = Paginastijl
    .accesskey = P
menu-view-page-style-no-style =
    .label = Geen stijl
    .accesskey = G
menu-view-page-basic-style =
    .label = Basisstijl
    .accesskey = B
menu-view-charset =
    .label = Tekstcodering
    .accesskey = c
menu-view-repair-text-encoding =
    .label = Tekstcodering repareren
    .accesskey = c

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Schermvullende weergave
    .accesskey = S
menu-view-exit-full-screen =
    .label = Volledig scherm verlaten
    .accesskey = V
menu-view-full-screen =
    .label = Volledig scherm
    .accesskey = d

##

menu-view-show-all-tabs =
    .label = Alle tabbladen tonen
    .accesskey = A
menu-view-bidi-switch-page-direction =
    .label = Paginarichting omkeren
    .accesskey = a

## History Menu

menu-history =
    .label = Geschiedenis
    .accesskey = G
menu-history-show-all-history =
    .label = Alle geschiedenis tonen
menu-history-clear-recent-history =
    .label = Recente geschiedenis wissen…
menu-history-synced-tabs =
    .label = Gesynchroniseerde tabbladen
menu-history-restore-last-session =
    .label = Vorige sessie herstellen
menu-history-hidden-tabs =
    .label = Verborgen tabbladen
menu-history-undo-menu =
    .label = Onlangs gesloten tabbladen
menu-history-undo-window-menu =
    .label = Onlangs gesloten vensters
menu-history-reopen-all-tabs = Alle tabbladen opnieuw openen
menu-history-reopen-all-windows = Alle vensters opnieuw openen

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Bladwijzers
    .accesskey = a
menu-bookmarks-show-all =
    .label = Alle bladwijzers tonen
menu-bookmark-this-page =
    .label = Bladwijzer voor deze pagina maken
menu-bookmarks-manage =
    .label = Bladwijzers beheren
menu-bookmark-current-tab =
    .label = Bladwijzer voor huidige tabblad maken
menu-bookmark-edit =
    .label = Deze bladwijzer bewerken
menu-bookmarks-all-tabs =
    .label = Bladwijzer voor alle tabbladen maken…
menu-bookmarks-toolbar =
    .label = Bladwijzerwerkbalk
menu-bookmarks-other =
    .label = Andere bladwijzers
menu-bookmarks-mobile =
    .label = Mobiel-bladwijzers

## Tools Menu

menu-tools =
    .label = Extra
    .accesskey = x
menu-tools-downloads =
    .label = Downloads
    .accesskey = D
menu-tools-addons =
    .label = Add-ons
    .accesskey = A
menu-tools-fxa-sign-in =
    .label = Aanmelden bij { -brand-product-name }…
    .accesskey = m
menu-tools-turn-on-sync =
    .label = { -sync-brand-short-name } inschakelen…
    .accesskey = n
menu-tools-addons-and-themes =
    .label = Add-ons en thema’s
    .accesskey = A
menu-tools-fxa-sign-in2 =
    .label = Aanmelden
    .accesskey = m
menu-tools-turn-on-sync2 =
    .label = Synchronisatie inschakelen…
    .accesskey = n
menu-tools-sync-now =
    .label = Nu synchroniseren
    .accesskey = N
menu-tools-fxa-re-auth =
    .label = Opnieuw verbinden met { -brand-product-name }…
    .accesskey = O
menu-tools-web-developer =
    .label = Webontwikkelaar
    .accesskey = W
menu-tools-browser-tools =
    .label = Browserhulpmidelen
    .accesskey = B
menu-tools-task-manager =
    .label = Taakbeheerder
    .accesskey = b
menu-tools-page-source =
    .label = Paginabron
    .accesskey = b
menu-tools-page-info =
    .label = Pagina-info
    .accesskey = i
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opties
           *[other] Voorkeuren
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] V
        }
menu-settings =
    .label = Instellingen
    .accesskey =
        { PLATFORM() ->
            [windows] I
           *[other] n
        }
menu-tools-layout-debugger =
    .label = Lay-out-debugger
    .accesskey = L

## Window Menu

menu-window-menu =
    .label = Venster
menu-window-bring-all-to-front =
    .label = Alles naar voren brengen

## Help Menu


# NOTE: For Engineers, any additions or changes to Help menu strings should
# also be reflected in the related strings in appmenu.ftl. Those strings, by
# convention, will have the same ID as these, but prefixed with "app".
# Example: appmenu-get-help
#
# These strings are duplicated to allow for different casing depending on
# where the strings appear.

menu-help =
    .label = Help
    .accesskey = H
menu-help-product =
    .label = { -brand-shorter-name } Help
    .accesskey = H
menu-help-show-tour =
    .label = { -brand-shorter-name }-rondleiding
    .accesskey = d
menu-help-import-from-another-browser =
    .label = Importeren vanuit een andere browser…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Sneltoetsen
    .accesskey = S
menu-help-troubleshooting-info =
    .label = Probleemoplossingsinformatie
    .accesskey = P
menu-get-help =
    .label = Hulp verkrijgen
    .accesskey = H
menu-help-more-troubleshooting-info =
    .label = Meer probleemoplossingsinformatie
    .accesskey = p
menu-help-report-site-issue =
    .label = Websiteprobleem melden…
menu-help-feedback-page =
    .label = Feedback verzenden…
    .accesskey = v
menu-help-safe-mode-without-addons =
    .label = Herstarten met uitgeschakelde add-ons…
    .accesskey = r
menu-help-safe-mode-with-addons =
    .label = Herstarten met ingeschakelde add-ons
    .accesskey = r
menu-help-enter-troubleshoot-mode2 =
    .label = Probleemoplossingsmodus…
    .accesskey = u
menu-help-exit-troubleshoot-mode =
    .label = Probleemoplossingsmodus uitschakelen
    .accesskey = m
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Misleidende website rapporteren…
    .accesskey = M
menu-help-not-deceptive =
    .label = Dit is geen misleidende website…
    .accesskey = m
