# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Window controls

messenger-window-minimize-button =
    .tooltiptext = Riduci a icona
messenger-window-maximize-button =
    .tooltiptext = Ingrandisci
messenger-window-restore-down-button =
    .tooltiptext = Ripristina in basso
messenger-window-close-button =
    .tooltiptext = Chiudi
# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] 1 messaggio non letto
       *[other] { $count } messaggi non letti
    }
about-rights-notification-text = { -brand-short-name } è un software gratuito, libero e open source, realizzato da una comunità di migliaia di persone provenienti da tutto il mondo.

## Content tabs

content-tab-page-loading-icon =
    .alt = Caricamento pagina in corso
content-tab-security-high-icon =
    .alt = La connessione è sicura
content-tab-security-broken-icon =
    .alt = La connessione non è sicura

## Toolbar

addons-and-themes-toolbarbutton =
    .label = Componenti aggiuntivi e temi
    .tooltiptext = Gestisci i tuoi componenti aggiuntivi
quick-filter-toolbarbutton =
    .label = Filtro veloce
    .tooltiptext = Filtra messaggi
redirect-msg-button =
    .label = Reindirizza
    .tooltiptext = Reindirizza il messaggio selezionato

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Barra degli strumenti del pannello cartelle
    .accesskey = c
folder-pane-toolbar-options-button =
    .tooltiptext = Opzioni del pannello cartelle
folder-pane-header-label = Cartelle

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Nascondi barra degli strumenti
    .accesskey = s
show-all-folders-label =
    .label = Tutte le cartelle
    .accesskey = T
show-unread-folders-label =
    .label = Cartelle non lette
    .accesskey = r
show-favorite-folders-label =
    .label = Cartelle preferite
    .accesskey = i
show-smart-folders-label =
    .label = Cartelle unificate
    .accesskey = u
show-recent-folders-label =
    .label = Cartelle recenti
    .accesskey = n
folder-toolbar-toggle-folder-compact-view =
    .label = Vista compatta
    .accesskey = c

## Menu

redirect-msg-menuitem =
    .label = Reindirizza
    .accesskey = d
menu-file-save-as-file =
    .label = File…
    .accesskey = e

## AppMenu

appmenu-save-as-file =
    .label = File…
appmenu-settings =
    .label = Impostazioni
appmenu-addons-and-themes =
    .label = Componenti aggiuntivi e temi
appmenu-help-enter-troubleshoot-mode =
    .label = Modalità risoluzione problemi…
appmenu-help-exit-troubleshoot-mode =
    .label = Disattiva Modalità risoluzione problemi
appmenu-help-more-troubleshooting-info =
    .label = Altre informazioni per la risoluzione di problemi
appmenu-redirect-msg =
    .label = Reindirizza

## Context menu

context-menu-redirect-msg =
    .label = Reindirizza
mail-context-delete-messages =
    .label =
        { $count ->
            [one] Elimina messaggio
           *[other] Elimina i messaggi selezionati
        }
context-menu-decrypt-to-folder =
    .label = Copia come decrittato in
    .accesskey = d

## Message header pane

other-action-redirect-msg =
    .label = Reindirizza
message-header-msg-flagged =
    .title = Speciale
    .aria-label = Speciale
message-header-msg-not-flagged =
    .title = Messaggio non contrassegnato come speciale
# Variables:
# $address (String) - The email address of the recipient this picture belongs to.
message-header-recipient-avatar =
    .alt = Immagine del profilo per { $address }.

## Message header cutomize panel

message-header-customize-panel-title = Impostazioni intestazione del messaggio
message-header-customize-button-style =
    .value = Stile pulsante
    .accesskey = S
message-header-button-style-default =
    .label = Icone e testo
message-header-button-style-text =
    .label = Testo
message-header-button-style-icons =
    .label = Icone
message-header-show-sender-full-address =
    .label = Mostra sempre l’indirizzo completo del mittente
    .accesskey = M
message-header-show-sender-full-address-description = L’indirizzo email verrà mostrato sotto il nome visualizzato.
message-header-show-recipient-avatar =
    .label = Mostra l’immagine del profilo del mittente
    .accesskey = o
message-header-hide-label-column =
    .label = Nascondi colonna etichette
    .accesskey = e
message-header-large-subject =
    .label = Oggetto grande
    .accesskey = O

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Gestisci estensione
    .accesskey = G
toolbar-context-menu-remove-extension =
    .label = Rimuovi estensione
    .accesskey = R

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Rimuovere { $name }?
addon-removal-confirmation-button = Rimuovi
addon-removal-confirmation-message = Rimuovere { $name } da { -brand-short-name }, inclusi impostazioni e dati associati?
caret-browsing-prompt-title = Navigazione nel testo
caret-browsing-prompt-text = Premendo il tasto F7 è possibile attivare o disattivare la Navigazione nel testo. Questa funzione visualizza un cursore mobile all’interno di alcuni contenuti, consentendo di selezionare il testo attraverso la tastiera. Attivare la Navigazione nel testo?
caret-browsing-prompt-check-text = Non chiedere nuovamente.
repair-text-encoding-button =
    .label = Correggi codifica testo
    .tooltiptext = Cerca di identificare la codifica testo corretta in base al contenuto del messaggio

## no-reply handling

no-reply-title = Risposta non supportata
no-reply-message = Sembra che l’indirizzo di risposta ({ $email }) non venga controllato. I messaggi inviati a questo indirizzo potrebbero non essere letti.
no-reply-reply-anyway-button = Rispondi comunque

## error messages

decrypt-and-copy-failures = Non è stato possibile decrittare e copiare { $failures } di { $total } messaggi.

## Spaces toolbar

spaces-toolbar-element =
    .toolbarname = Barra degli spazi
    .aria-label = Barra degli spazi
    .aria-description = Barra degli strumenti verticale per passare da uno spazio all’altro. Utilizzare i tasti freccia per selezionare i pulsanti disponibili.
spaces-toolbar-button-mail2 =
    .title = Posta
spaces-toolbar-button-address-book2 =
    .title = Rubrica
spaces-toolbar-button-calendar2 =
    .title = Calendario
spaces-toolbar-button-tasks2 =
    .title = Attività
spaces-toolbar-button-chat2 =
    .title = Chat
spaces-toolbar-button-overflow =
    .title = Altro spazi…
spaces-toolbar-button-settings2 =
    .title = Impostazioni
spaces-toolbar-button-hide =
    .title = Nascondi barra degli spazi
spaces-toolbar-button-show =
    .title = Mostra barra degli spazi
spaces-context-new-tab-item =
    .label = Apri in una nuova scheda
spaces-context-new-window-item =
    .label = Apri in una nuova finestra
# Variables:
# $tabName (String) - The name of the tab this item will switch to.
spaces-context-switch-tab-item =
    .label = Passa a { $tabName }
settings-context-open-settings-item2 =
    .label = Impostazioni
settings-context-open-account-settings-item2 =
    .label = Impostazioni account
settings-context-open-addons-item2 =
    .label = Componenti aggiuntivi e temi

## Spaces toolbar pinned tab menupopup

spaces-toolbar-pinned-tab-button =
    .tooltiptext = Apri menu degli spazi
spaces-pinned-button-menuitem-mail =
    .label = { spaces-toolbar-button-mail.title }
spaces-pinned-button-menuitem-address-book =
    .label = { spaces-toolbar-button-address-book.title }
spaces-pinned-button-menuitem-calendar =
    .label = { spaces-toolbar-button-calendar.title }
spaces-pinned-button-menuitem-tasks =
    .label = { spaces-toolbar-button-tasks.title }
spaces-pinned-button-menuitem-chat =
    .label = { spaces-toolbar-button-chat.title }
spaces-pinned-button-menuitem-settings =
    .label = { spaces-toolbar-button-settings2.title }
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
            [one] Un messaggio non letto
           *[other] { $count } messaggi non letti
        }

## Spaces toolbar customize panel

menuitem-customize-label =
    .label = Personalizza…
spaces-customize-panel-title = Impostazioni della barra degli spazi
spaces-customize-background-color = Colore di sfondo
spaces-customize-icon-color = Colore del pulsante
# The background color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-background-color = Colore di sfondo del pulsante selezionato
# The icon color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-text-color = Colore del pulsante selezionato
spaces-customize-button-restore = Ripristina predefiniti
    .accesskey = r
customize-panel-button-save = Fatto
    .accesskey = F
