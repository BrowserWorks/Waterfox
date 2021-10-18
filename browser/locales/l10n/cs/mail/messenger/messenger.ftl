# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] Jedna nepřečtená zpráva
        [few] { $count } nepřečtená zprávy
       *[other] { $count } nepřečtených zpráv
    }
about-rights-notification-text = { -brand-short-name } je svobodný a otevřený software vytvořený komunitou tisíců lidí z celého světa.

## Content tabs

content-tab-page-loading-icon =
    .alt = Stránka se načítá
content-tab-security-high-icon =
    .alt = Spojení je zabezpečené
content-tab-security-broken-icon =
    .alt = Spojení není zabezepečené

## Toolbar

addons-and-themes-toolbarbutton =
    .label = Doplňky a vzhledy
    .tooltiptext = Správa doplňků
quick-filter-toolbarbutton =
    .label = Rychlý filtr
    .tooltiptext = Filtrování zpráv
redirect-msg-button =
    .label = Přesměrovat
    .tooltiptext = Přesměruje vybranou zprávu

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Nástroje podokna složek
    .accesskey = a
folder-pane-toolbar-options-button =
    .tooltiptext = Nastavení podokna složek
folder-pane-header-label = Složky

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Skrýt nástrojovou lištu
    .accesskey = S
show-all-folders-label =
    .label = Všechny složky
    .accesskey = V
show-unread-folders-label =
    .label = Nepřečtené složky
    .accesskey = N
show-favorite-folders-label =
    .label = Oblíbené složky
    .accesskey = O
show-smart-folders-label =
    .label = Jednotné složky
    .accesskey = J
show-recent-folders-label =
    .label = Nedávné složky
    .accesskey = e
folder-toolbar-toggle-folder-compact-view =
    .label = Kompaktní zobrazení
    .accesskey = K

## Menu

redirect-msg-menuitem =
    .label = Přesměrovat
    .accesskey = m
menu-file-save-as-file =
    .label = Soubor…
    .accesskey = S

## AppMenu

appmenu-save-as-file =
    .label = Soubor…
# Since v89 we dropped the platforms distinction between Options or Preferences
# and consolidated everything with Preferences.
appmenu-preferences =
    .label = Předvolby
appmenu-addons-and-themes =
    .label = Doplňky a vzhledy
appmenu-help-enter-troubleshoot-mode =
    .label = Režim řešení potíží…
appmenu-help-exit-troubleshoot-mode =
    .label = Ukončit režim řešení potíží
appmenu-help-more-troubleshooting-info =
    .label = Další technické informace
appmenu-redirect-msg =
    .label = Přesměrovat

## Context menu

context-menu-redirect-msg =
    .label = Přesměrovat

## Message header pane

other-action-redirect-msg =
    .label = Přesměrovat

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Nastavení tohoto rozšíření
    .accesskey = e
toolbar-context-menu-remove-extension =
    .label = Odebrat rozšíření
    .accesskey = d

## Message headers

message-header-address-in-address-book-icon =
    .alt = Adresa je v kontaktech
message-header-address-not-in-address-book-icon =
    .alt = Adresa není v kontaktech

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Opravdu chcete odebrat rozšíření { $name }?
addon-removal-confirmation-button = Odebrat
addon-removal-confirmation-message =
    Opravdu chcete odebrat doplněk { $name } a jeho nastavení a data z { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }?
caret-browsing-prompt-title = Procházení stránky
caret-browsing-prompt-text = Stisknutím klávesy F7 zapnete či vypnete funkci Procházení stránky. Ta umístí do obsahu textový kurzor, který vám umožní vybírat text pomocí klávesnice. Chcete zapnout funkci Procházení stránky?
caret-browsing-prompt-check-text = Příště se už neptat.
repair-text-encoding-button =
    .label = Opravit znakovou sadu textu
    .tooltiptext = Na základě obsahu zprávy odhadne správnou znakovou sadu textu

## no-reply handling

no-reply-title = Adrese pro odpověď není podporovaná
no-reply-message = Adresa pro odpověď ({ $email }) není sledovanou adresou. Zprávy odeslané na tuto adresu si nejspíše nikdo nepřečte.
no-reply-reply-anyway-button = Přesto odpověď odeslat
