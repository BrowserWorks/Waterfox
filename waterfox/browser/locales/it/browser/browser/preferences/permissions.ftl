# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

permissions-window =
    .title = Eccezioni
    .style = width: 45em

permissions-close-key =
    .key = w

permissions-address = Indirizzo del sito web
    .accesskey = n

permissions-block =
    .label = Blocca
    .accesskey = B

permissions-session =
    .label = Consenti per la sessione
    .accesskey = e

permissions-allow =
    .label = Consenti
    .accesskey = C

permissions-button-off =
    .label = Disattiva
    .accesskey = D

permissions-button-off-temporarily =
    .label = Disattiva temporaneamente
    .accesskey = m

permissions-site-name =
    .label = Sito web

permissions-status =
    .label = Stato

permissions-remove =
    .label = Rimuovi sito web
    .accesskey = R

permissions-remove-all =
    .label = Rimuovi tutti i siti web
    .accesskey = t

permission-dialog =
    .buttonlabelaccept = Salva modifiche
    .buttonaccesskeyaccept = S

permissions-autoplay-menu = Impostazione predefinita per tutti i siti web:

permissions-searchbox =
    .placeholder = Cerca sito web

permissions-capabilities-autoplay-allow =
    .label = Consenti audio e video
permissions-capabilities-autoplay-block =
    .label = Blocca audio
permissions-capabilities-autoplay-blockall =
    .label = Blocca audio e video

permissions-capabilities-allow =
    .label = Consenti
permissions-capabilities-block =
    .label = Blocca
permissions-capabilities-prompt =
    .label = Chiedi sempre

permissions-capabilities-listitem-allow =
    .value = Consenti
permissions-capabilities-listitem-block =
    .value = Blocca
permissions-capabilities-listitem-allow-session =
    .value = Consenti per la sessione

permissions-capabilities-listitem-off =
    .value = Disattivato
permissions-capabilities-listitem-off-temporarily =
    .value = Disattivato temporaneamente

## Invalid Hostname Dialog

permissions-invalid-uri-title = Il nome inserito per il server non è valido
permissions-invalid-uri-label = Inserire un nome valido per il server

## Exceptions - Tracking Protection

permissions-exceptions-etp-window =
    .title = Eccezioni per protezione antitracciamento avanzata
    .style = { permissions-window.style }
permissions-exceptions-etp-desc = La protezione è stata disattivata per i seguenti siti web.

## Exceptions - Cookies

permissions-exceptions-cookie-window =
    .title = Eccezioni - Cookie e dati dei siti web
    .style = { permissions-window.style }
permissions-exceptions-cookie-desc = È possibile indicare quali siti web potranno o meno salvare cookie e dati. Inserire l’indirizzo esatto del sito web da gestire e fare clic su Blocca, Consenti per la sessione o Consenti.

## Exceptions - HTTPS-Only Mode

permissions-exceptions-https-only-window =
    .title = Eccezioni - Modalità solo HTTPS
    .style = { permissions-window.style }
permissions-exceptions-https-only-desc = È possibile disattivare la modalità solo HTTPS per determinati siti. { -brand-short-name } non cercherà di aggiornare la connessione alla versione sicura HTTPS per questi siti. Le eccezioni non sono valide per le finestre anonime.

## Exceptions - Pop-ups

permissions-exceptions-popup-window =
    .title = Siti web con permesso - Finestre pop-up
    .style = { permissions-window.style }
permissions-exceptions-popup-desc = È possibile indicare quali siti web potranno aprire finestre pop-up. Inserire l’indirizzo esatto del sito web a cui dare il permesso e fare clic su Consenti.

## Exceptions - Saved Logins

permissions-exceptions-saved-logins-window =
    .title = Eccezioni - Credenziali salvate
    .style = { permissions-window.style }
permissions-exceptions-saved-logins-desc = Non verranno salvate le credenziali di accesso per i seguenti siti web

## Exceptions - Add-ons

permissions-exceptions-addons-window =
    .title = Siti web con permesso - Installazione componenti
    .style = { permissions-window.style }
permissions-exceptions-addons-desc = È possibile specificare quali siti web avranno il permesso di installare componenti aggiuntivi. Inserire l’indirizzo esatto del sito web a cui dare il permesso e fare clic su Consenti.

## Site Permissions - Autoplay

permissions-site-autoplay-window =
    .title = Impostazioni - Riproduzione automatica
    .style = { permissions-window.style }
permissions-site-autoplay-desc = È possibile specificare quali siti web non seguono le impostazioni predefinite per la riproduzione automatica.

## Site Permissions - Notifications

permissions-site-notification-window =
    .title = Impostazioni - Permessi notifiche
    .style = { permissions-window.style }
permissions-site-notification-desc = I seguenti siti web hanno richiesto il permesso di inviare notifiche. È possibile indicare quali siti web potranno inviarle o bloccare direttamente le nuove richieste.
permissions-site-notification-disable-label =
    .label = Blocca nuove richieste di inviare notifiche
permissions-site-notification-disable-desc = Verrà impedito a qualunque sito web non presente nell’elenco di richiedere il permesso di inviare notifiche. Il blocco delle notifiche potrebbe comportare il malfunzionamento di alcuni siti web.

## Site Permissions - Location

permissions-site-location-window =
    .title = Impostazioni - Permessi posizione
    .style = { permissions-window.style }
permissions-site-location-desc = I seguenti siti web hanno richiesto il permesso di accedere alla posizione corrente. È possibile indicare quali siti web potranno accedere a questa informazione o bloccare direttamente le nuove richieste.
permissions-site-location-disable-label =
    .label = Blocca nuove richieste di accesso alla posizione corrente
permissions-site-location-disable-desc = Verrà impedito a qualunque sito web non presente nell’elenco di richiedere il permesso di accedere alla posizione corrente. L’impossibilità di accedere alla posizione potrebbe comportare il malfunzionamento di alcuni siti web.

## Site Permissions - Virtual Reality

permissions-site-xr-window =
    .title = Impostazioni - Permessi per la realtà virtuale
    .style = { permissions-window.style }
permissions-site-xr-desc = I seguenti siti web hanno richiesto il permesso di accedere ai dispositivi per realtà virtuale. È possibile indicare quali siti web potranno accedere a questi dispositivi o bloccare direttamente le nuove richieste.
permissions-site-xr-disable-label =
    .label = Blocca nuove richieste di accesso ai dispositivi per realtà virtuale
permissions-site-xr-disable-desc = Verrà impedito a qualunque sito web non presente nell’elenco di richiedere il permesso di accedere ai dispositivi per realtà virtuale. L’impossibilità di accedere ai dispositivi potrebbe comportare il malfunzionamento di alcuni siti web.

## Site Permissions - Camera

permissions-site-camera-window =
    .title = Impostazioni - Permessi fotocamera
    .style = { permissions-window.style }
permissions-site-camera-desc = I seguenti siti web hanno richiesto il permesso di utilizzare la fotocamera. È possibile indicare quali siti web potranno accedere al dispositivo o bloccare direttamente le nuove richieste.
permissions-site-camera-disable-label =
    .label = Blocca nuove richieste di accesso alla fotocamera
permissions-site-camera-disable-desc = Verrà impedito a qualunque sito web non presente nell’elenco di richiedere il permesso di accedere alla fotocamera. L’impossibilità di accedere al dispositivo potrebbe comportare il malfunzionamento di alcuni siti web.

## Site Permissions - Microphone

permissions-site-microphone-window =
    .title = Impostazioni - Permessi microfono
    .style = { permissions-window.style }
permissions-site-microphone-desc = I seguenti siti web hanno richiesto il permesso di utilizzare il microfono. È possibile indicare quali siti web potranno accedere al dispositivo o bloccare direttamente le nuove richieste.
permissions-site-microphone-disable-label =
    .label = Blocca nuove richieste di accesso al microfono
permissions-site-microphone-disable-desc = Verrà impedito a qualunque sito web non presente nell’elenco di richiedere il permesso di accedere al microfono. L’impossibilità di accedere al dispositivo potrebbe comportare il malfunzionamento di alcuni siti web.
