# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Estensione consigliata
cfr-doorhanger-feature-heading = Funzione consigliata

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Perché viene visualizzato questo messaggio

cfr-doorhanger-extension-cancel-button = Non adesso
    .accesskey = N

cfr-doorhanger-extension-ok-button = Aggiungi
    .accesskey = A

cfr-doorhanger-extension-manage-settings-button = Gestisci impostazioni suggerimenti
    .accesskey = G

cfr-doorhanger-extension-never-show-recommendation = Non visualizzare suggerimenti
    .accesskey = v

cfr-doorhanger-extension-learn-more-link = Ulteriori informazioni

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = di { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Suggerimento

cfr-doorhanger-extension-notification2 = Suggerimento
  .tooltiptext = Estensione suggerita
  .a11y-announcement = È disponibile un suggerimento per un’estensione

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Suggerimento
  .tooltiptext = Funzione suggerita
  .a11y-announcement = È disponibile un suggerimento per una funzione

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
              [one] { $total } stella
             *[other] { $total } stelle
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } utente
       *[other] { $total } utenti
    }

## These messages are steps on how to use the feature and are shown together.


## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sincronizza ovunque i tuoi segnalibri
cfr-doorhanger-bookmark-fxa-body = Ottima scoperta. Assicurati di non restare senza questo segnalibro sul tuo dispositivo mobile. Crea un { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Sincronizza subito i segnalibri…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
  .aria-label = Pulsante di chiusura
  .title = Chiudi

## Protections panel

cfr-protections-panel-header = Naviga senza lasciarti seguire
cfr-protections-panel-body = Mantieni i tuoi dati al riparo da occhi indiscreti. { -brand-short-name } ti protegge dagli elementi traccianti più comuni che cercano di seguire le tue attività online.
cfr-protections-panel-link-text = Ulteriori informazioni

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nuova funzione:

cfr-whatsnew-button =
  .label = Novità
  .tooltiptext = Novità

cfr-whatsnew-release-notes-link-text = Leggi le note di versione

## Search Bar

## Picture-in-Picture

## Permission Prompt

## Fingerprinter Counter

## Bookmark Sync

## Login Sync

## Send Tab

## Waterfox Send

## Social Tracking Protection

## Enhanced Tracking Protection Milestones

cfr-doorhanger-milestone-heading2 = { -brand-short-name } ha bloccato oltre <b>{ $blockedCount }</b> elementi traccianti da { DATETIME($date, month: "long", year: "numeric") }.
cfr-doorhanger-milestone-ok-button = Visualizza tutto
  .accesskey = V

## What’s New Panel Content for Waterfox 76

## Lockwise message

## Vulnerable Passwords message

## Picture-in-Picture fullscreen message

## Protections Dashboard message

## Better PDF message

cfr-doorhanger-milestone-close-button = Chiudi
  .accesskey = C

## DOH Message

cfr-doorhanger-doh-body = La tua privacy è importante. { -brand-short-name } ora indirizza in modo sicuro le richieste DNS, quando possibile, a un servizio fornito da un partner per proteggerti durante la navigazione.
cfr-doorhanger-doh-header = Ricerche DNS più sicure e crittate
cfr-doorhanger-doh-primary-button-2 = OK
  .accesskey = O
cfr-doorhanger-doh-secondary-button = Disattiva
  .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = La tua privacy è importante. Ora { -brand-short-name } isola i siti web l’uno dall’altro, rendendo più difficile il furto di password, numeri di carte di credito e altre informazioni sensibili da parte di hacker.
cfr-doorhanger-fission-header = Isolamento dei siti
cfr-doorhanger-fission-primary-button = OK, ricevuto
  .accesskey = O
cfr-doorhanger-fission-secondary-button = Ulteriori informazioni
  .accesskey = U

## Full Video Support CFR message

cfr-doorhanger-video-support-body = I video di questo sito potrebbero non funzionare correttamente in questa versione di { -brand-short-name }. Aggiorna { -brand-short-name } per garantire il completo supporto della riproduzione video.
cfr-doorhanger-video-support-header = Aggiorna { -brand-short-name } per riprodurre i video
cfr-doorhanger-video-support-primary-button = Aggiorna adesso
  .accesskey = A

## Spotlight modal shared strings

spotlight-learn-more-collapsed = Ulteriori informazioni
  .title = Espandi per scoprire ulteriori informazioni su questa funzione
spotlight-learn-more-expanded = Ulteriori informazioni
  .title = Chiudi

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

spotlight-public-wifi-vpn-header = Sembra che ti trovi su una rete Wi-Fi pubblica
spotlight-public-wifi-vpn-body = Hai mai pensato di utilizzare una VPN per nascondere la tua posizione e le tue attività online? Questo ti manterrà al sicuro quando navighi in luoghi pubblici come aeroporti e bar.
spotlight-public-wifi-vpn-primary-button = Proteggi la tua privacy con { -mozilla-vpn-brand-name }
  .accesskey = M
spotlight-public-wifi-vpn-link = Non adesso
  .accesskey = N

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header =
  Prova in anteprima una nuova esperienza
  per il massimo della privacy
spotlight-total-cookie-protection-body = La Protezione totale per i cookie impedisce l’utilizzo dei cookie per seguire le tue attività online.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = { -brand-short-name } crea un recinto intorno ai cookie, limitandoli al sito in cui ti trovi. In questo modo non è possibile utilizzarli per seguirti sul Web. Attivando questa funzione in anteprima, ci aiuti a perfezionarla e costruire un Web migliore per tutti.
spotlight-total-cookie-protection-primary-button = Attiva Protezione totale per i cookie
spotlight-total-cookie-protection-secondary-button = Non adesso

cfr-total-cookie-protection-header = Grazie al tuo aiuto, { -brand-short-name } è più riservato e sicuro che mai
cfr-total-cookie-protection-body = La Protezione totale per i cookie è lo strumento più potente per la protezione della privacy che abbiamo mai realizzato. E adesso è disponibile come impostazione predefinita per tutti gli utenti di { -brand-short-name } nel mondo. Questo risultato sarebbe stato impossibile senza il contributo di persone che, come te, hanno deciso di provare questa funzione in anteprima. Grazie per il tuo contributo e per aiutarci a creare un Internet migliore e più sicuro.

## Emotive Continuous Onboarding

spotlight-better-internet-header = La strada verso un Internet migliore parte da te
spotlight-better-internet-body = Scegliendo { -brand-short-name } esprimi il tuo supporto per una rete aperta e accessibile, migliore per tutti.
spotlight-peace-mind-header = Sempre dalla tua parte
spotlight-peace-mind-body = Ogni mese { -brand-short-name } blocca in media 3.000 elementi traccianti per ciascun utente. Questo perché nessun ostacolo dovrebbe frapporsi tra te e la parte migliore di Internet, in special modo queste seccature per la tua privacy.
spotlight-pin-primary-button = { PLATFORM() ->
    [macos] Mantieni nel Dock
   *[other] Aggiungi alla barra delle applicazioni
}
spotlight-pin-secondary-button = Non adesso
