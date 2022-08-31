# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Window controls

messenger-window-minimize-button =
    .tooltiptext = Minimera
messenger-window-maximize-button =
    .tooltiptext = Maximera
messenger-window-restore-down-button =
    .tooltiptext = Återställ nedåt
messenger-window-close-button =
    .tooltiptext = Stäng
# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] 1 oläst meddelande
       *[other] { $count } olästa meddelanden
    }
about-rights-notification-text = { -brand-short-name } är fri programvara baserad på öppen källkod, byggd av en community av tusentals personer över hela världen.

## Content tabs

content-tab-page-loading-icon =
    .alt = Sidan laddas
content-tab-security-high-icon =
    .alt = Anslutningen är säker
content-tab-security-broken-icon =
    .alt = Anslutningen är inte säker

## Toolbar

addons-and-themes-toolbarbutton =
    .label = Tillägg och teman
    .tooltiptext = Hantera dina tillägg
quick-filter-toolbarbutton =
    .label = Snabbfiltrering
    .tooltiptext = Filtrera meddelanden
redirect-msg-button =
    .label = Omdirigera
    .tooltiptext = Omdirigera valt meddelande

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Verktygsfältet mappfönster
    .accesskey = m
folder-pane-toolbar-options-button =
    .tooltiptext = Alternativ för mappfönster
folder-pane-header-label = Mappar

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Dölj verktygsfält
    .accesskey = D
show-all-folders-label =
    .label = Alla mappar
    .accesskey = A
show-unread-folders-label =
    .label = Olästa mappar
    .accesskey = O
show-favorite-folders-label =
    .label = Favoritmappar
    .accesskey = F
show-smart-folders-label =
    .label = Sammanförda mappar
    .accesskey = S
show-recent-folders-label =
    .label = Senaste mappar
    .accesskey = S
folder-toolbar-toggle-folder-compact-view =
    .label = Kompakt vy
    .accesskey = K

## Menu

redirect-msg-menuitem =
    .label = Omdirigera
    .accesskey = d
menu-file-save-as-file =
    .label = Arkiv…
    .accesskey = A

## AppMenu

appmenu-save-as-file =
    .label = Arkiv…
appmenu-settings =
    .label = Inställningar
appmenu-addons-and-themes =
    .label = Tillägg och teman
appmenu-help-enter-troubleshoot-mode =
    .label = Felsökningsläge…
appmenu-help-exit-troubleshoot-mode =
    .label = Stäng av felsökningsläge
appmenu-help-more-troubleshooting-info =
    .label = Mer felsökningsinformation
appmenu-redirect-msg =
    .label = Omdirigera

## Context menu

context-menu-redirect-msg =
    .label = Omdirigera
mail-context-delete-messages =
    .label =
        { $count ->
            [one] Ta bort meddelande
           *[other] Ta bort valda meddelanden
        }
context-menu-decrypt-to-folder =
    .label = Kopiera som dekrypterad till
    .accesskey = y

## Message header pane

other-action-redirect-msg =
    .label = Omdirigera
message-header-msg-flagged =
    .title = Stjärnmärkt
    .aria-label = Stjärnmärkt
# Variables:
# $address (String) - The email address of the recipient this picture belongs to.
message-header-recipient-avatar =
    .alt = Profilbild för { $address }.

## Message header cutomize panel

message-header-customize-panel-title = Inställningar för meddelanderubrik
message-header-customize-button-style =
    .value = Knappstil
    .accesskey = K
message-header-button-style-default =
    .label = Ikoner och text
message-header-button-style-text =
    .label = Text
message-header-button-style-icons =
    .label = Ikoner
message-header-show-sender-full-address =
    .label = Visa alltid avsändarens fullständiga adress
    .accesskey = f
message-header-show-sender-full-address-description = E-postadressen kommer att visas under visningsnamnet.
message-header-show-recipient-avatar =
    .label = Visa avsändarens profilbild
    .accesskey = p
message-header-hide-label-column =
    .label = Dölj kolumnen etiketter
    .accesskey = e
message-header-large-subject =
    .label = Stort ämne
    .accesskey = n

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Hantera tillägg
    .accesskey = H
toolbar-context-menu-remove-extension =
    .label = Ta bort tillägg
    .accesskey = T

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Ta bort { $name }?
addon-removal-confirmation-button = Ta bort
addon-removal-confirmation-message = Ta bort { $name } samt dess konfiguration och data från { -brand-short-name }?
caret-browsing-prompt-title = Textmarkörläge
caret-browsing-prompt-text = Genom att trycka på F7 aktiveras eller inaktiveras textmarkörläge. Denna funktion placerar en rörlig markör i innehållet, så att du kan välja text med tangentbordet. Vill du aktivera textmarkörläge?
caret-browsing-prompt-check-text = Fråga inte igen.
repair-text-encoding-button =
    .label = Reparera textkodning
    .tooltiptext = Gissa korrekt textkodning från meddelandets innehåll

## no-reply handling

no-reply-title = Svar stöds inte
no-reply-message = Svarsadressen ({ $email }) verkar inte vara en övervakad adress. Meddelanden till den här adressen kommer sannolikt inte att läsas av någon.
no-reply-reply-anyway-button = Svara ändå

## error messages

decrypt-and-copy-failures = { $failures } av { $total } meddelanden kunde inte dekrypteras och kopierades inte.

## Spaces toolbar

spaces-toolbar-element =
    .toolbarname = Flikmeny
    .aria-label = Flikmeny
    .aria-description = Vertikalt verktygsfält för att växla mellan olika flikar. Använd piltangenterna för att navigera mellan tillgängliga knappar.
spaces-toolbar-button-mail2 =
    .title = E-post
spaces-toolbar-button-address-book2 =
    .title = Adressbok
spaces-toolbar-button-calendar2 =
    .title = Kalender
spaces-toolbar-button-tasks2 =
    .title = Uppgifter
spaces-toolbar-button-chat2 =
    .title = Chatt
spaces-toolbar-button-overflow =
    .title = Fler flikar…
spaces-toolbar-button-settings2 =
    .title = Inställningar
spaces-toolbar-button-hide =
    .title = Dölj verktygsfält för flikmeny
spaces-toolbar-button-show =
    .title = Visa verktygsfält för flikmeny
spaces-context-new-tab-item =
    .label = Öppna i ny flik
spaces-context-new-window-item =
    .label = Öppna i nytt fönster
# Variables:
# $tabName (String) - The name of the tab this item will switch to.
spaces-context-switch-tab-item =
    .label = Växla till { $tabName }
settings-context-open-settings-item2 =
    .label = Inställningar
settings-context-open-account-settings-item2 =
    .label = Kontoinställningar
settings-context-open-addons-item2 =
    .label = Tillägg och teman

## Spaces toolbar pinned tab menupopup

spaces-toolbar-pinned-tab-button =
    .tooltiptext = Öppna flikmenyn
spaces-pinned-button-menuitem-mail2 =
    .label = { spaces-toolbar-button-mail2.title }
spaces-pinned-button-menuitem-address-book2 =
    .label = { spaces-toolbar-button-address-book2.title }
spaces-pinned-button-menuitem-calendar2 =
    .label = { spaces-toolbar-button-calendar2.title }
spaces-pinned-button-menuitem-tasks2 =
    .label = { spaces-toolbar-button-tasks2.title }
spaces-pinned-button-menuitem-chat2 =
    .label = { spaces-toolbar-button-chat2.title }
spaces-pinned-button-menuitem-settings2 =
    .label = { spaces-toolbar-button-settings2.title }
spaces-pinned-button-menuitem-show =
    .label = { spaces-toolbar-button-show.title }
# Variables:
# $count (Number) - Number of unread messages.
chat-button-unread-messages = { $count }
    .title =
        { $count ->
            [one] Ett oläst meddelande
           *[other] { $count } olästa meddelanden
        }

## Spaces toolbar customize panel

menuitem-customize-label =
    .label = Anpassa…
spaces-customize-panel-title = Inställningar för flikmeny
spaces-customize-background-color = Bakgrundsfärg
spaces-customize-icon-color = Färg för knapp
# The background color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-background-color = Vald bakgrundsfärg för knapp
# The icon color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-text-color = Vald knappfärg
spaces-customize-button-restore = Återställ standard
    .accesskey = t
customize-panel-button-save = Klar
    .accesskey = K
