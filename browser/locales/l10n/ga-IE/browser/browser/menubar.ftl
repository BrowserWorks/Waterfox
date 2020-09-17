# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = Comhad
    .accesskey = C
menu-file-new-tab =
    .label = Cluaisín Nua
    .accesskey = C
menu-file-new-container-tab =
    .label = Cluaisín Coimeádáin Nua
    .accesskey = m
menu-file-new-window =
    .label = Fuinneog Nua
    .accesskey = N
menu-file-new-private-window =
    .label = Fuinneog Nua Phríobháideach
    .accesskey = P
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Oscail Suíomh…
menu-file-open-file =
    .label = Oscail Comhad…
    .accesskey = O
menu-file-close =
    .label = Dún
    .accesskey = D
menu-file-close-window =
    .label = Dún an Fhuinneog
    .accesskey = F
menu-file-save-page =
    .label = Sábháil an Leathanach Mar…
    .accesskey = M
menu-file-email-link =
    .label = Seol an Nasc trí Ríomhphost…
    .accesskey = S
menu-file-print-setup =
    .label = Socrú Leathanaigh…
    .accesskey = L
menu-file-print-preview =
    .label = Réamhamharc Priontála
    .accesskey = R
menu-file-print =
    .label = Priontáil…
    .accesskey = P
menu-file-go-offline =
    .label = Oibrigh As Líne
    .accesskey = b

## Edit Menu

menu-edit =
    .label = Eagar
    .accesskey = E
menu-edit-find-on =
    .label = Aimsigh sa Leathanach Seo…
    .accesskey = A
menu-edit-find-again =
    .label = Aimsigh Arís
    .accesskey = m
menu-edit-bidi-switch-text-direction =
    .label = Athraigh Treo an Téacs
    .accesskey = T

## View Menu

menu-view =
    .label = Amharc
    .accesskey = A
menu-view-toolbars-menu =
    .label = Barraí Uirlisí
    .accesskey = U
menu-view-customize-toolbar =
    .label = Saincheap…
    .accesskey = c
menu-view-sidebar =
    .label = Barra Taoibh
    .accesskey = T
menu-view-bookmarks =
    .label = Leabharmharcanna
menu-view-history-button =
    .label = Stair
menu-view-synced-tabs-sidebar =
    .label = Cluaisíní Sioncronaithe
menu-view-full-zoom =
    .label = Súmáil
    .accesskey = S
menu-view-full-zoom-enlarge =
    .label = Súmáil Isteach
    .accesskey = I
menu-view-full-zoom-reduce =
    .label = Súmáil Amach
    .accesskey = A
menu-view-full-zoom-toggle =
    .label = Súmáil Téacs Amháin
    .accesskey = T
menu-view-page-style-menu =
    .label = Stíl Leathanaigh
    .accesskey = L
menu-view-page-style-no-style =
    .label = Gan Stíl
    .accesskey = n
menu-view-page-basic-style =
    .label = Stíl Leathanaigh Bhunúsach
    .accesskey = B
menu-view-charset =
    .label = Ionchódú Téacs
    .accesskey = c

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Lánscáileán
    .accesskey = L
menu-view-exit-full-screen =
    .label = Scoir ón Lánscáileán
    .accesskey = L
menu-view-full-screen =
    .label = Lánscáileán
    .accesskey = i

##

menu-view-show-all-tabs =
    .label = Taispeáin Gach Cluaisín
    .accesskey = a
menu-view-bidi-switch-page-direction =
    .label = Athraigh Treo an Leathanaigh
    .accesskey = L

## History Menu

menu-history =
    .label = Stair
    .accesskey = i
menu-history-show-all-history =
    .label = Taispeáin an Stair Iomlán
menu-history-clear-recent-history =
    .label = Glan an Stair Is Déanaí…
menu-history-synced-tabs =
    .label = Cluaisíní Sioncronaithe
menu-history-restore-last-session =
    .label = Athchóirigh an Seisiún Roimhe Seo
menu-history-undo-menu =
    .label = Cluaisíní a Dúnadh Le Déanaí
menu-history-undo-window-menu =
    .label = Fuinneoga a Dúnadh Le Déanaí

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Leabharmharcanna
    .accesskey = L
menu-bookmarks-show-all =
    .label = Taispeáin Gach Leabharmharc
menu-bookmark-this-page =
    .label = Cruthaigh Leabharmharc don Leathanach Seo
menu-bookmark-edit =
    .label = Cuir an Leabharmharc Seo in Eagar
menu-bookmarks-all-tabs =
    .label = Leabharmharcáil Gach Cluaisín…
menu-bookmarks-toolbar =
    .label = Barra Leabharmharc
menu-bookmarks-other =
    .label = Leabharmharcanna Eile
menu-bookmarks-mobile =
    .label = Leabharmharcanna Soghluaiste

## Tools Menu

menu-tools =
    .label = Uirlisí
    .accesskey = U
menu-tools-downloads =
    .label = Íoslódálacha
    .accesskey = l
menu-tools-addons =
    .label = Breiseáin
    .accesskey = B
menu-tools-sync-now =
    .label = Sioncronaigh Anois
    .accesskey = S
menu-tools-web-developer =
    .label = Forbróir Gréasáin
    .accesskey = F
menu-tools-page-source =
    .label = Foinse an Leathanaigh
    .accesskey = F
menu-tools-page-info =
    .label = Eolas Leathanaigh
    .accesskey = s
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Roghanna
           *[other] Sainroghanna
        }
    .accesskey =
        { PLATFORM() ->
            [windows] o
           *[other] n
        }

## Window Menu

menu-window-menu =
    .label = Fuinneog
menu-window-bring-all-to-front =
    .label = Tabhair an t-iomlán chun tosaigh

## Help Menu

menu-help =
    .label = Cabhair
    .accesskey = h
menu-help-product =
    .label = Cabhair { -brand-shorter-name }
    .accesskey = C
menu-help-show-tour =
    .label = Turas ar { -brand-shorter-name }
    .accesskey = u
menu-help-keyboard-shortcuts =
    .label = Aicearraí Méarchláir
    .accesskey = A
menu-help-troubleshooting-info =
    .label = Fabhtcheartú
    .accesskey = t
menu-help-feedback-page =
    .label = Seol Aiseolas Chugainn…
    .accesskey = S
menu-help-safe-mode-without-addons =
    .label = Atosaigh gan aon bhreiseáin…
    .accesskey = A
menu-help-safe-mode-with-addons =
    .label = Atosaigh leis na Breiseáin ar siúl…
    .accesskey = A
# Label of the Help menu item. Either this or
# safeb.palm.notdeceptive.label from
# phishing-afterload-warning-message.dtd is shown.
menu-help-report-deceptive-site =
    .label = Tuairiscigh suíomh cealgach…
    .accesskey = c
menu-help-not-deceptive =
    .label = Ní suíomh cealgach é seo…
    .accesskey = c
