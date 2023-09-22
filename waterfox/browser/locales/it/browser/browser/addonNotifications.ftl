# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } ha impedito a questo sito di richiedere l’installazione di software sul computer.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = Consentire a { $host } di installare un componente aggiuntivo?
xpinstall-prompt-message = Si sta cercando di installare un componente aggiuntivo da { $host }. Assicurarsi che il sito sia affidabile prima di proseguire.

##

xpinstall-prompt-header-unknown = Consentire a questo sito sconosciuto di installare un componente aggiuntivo?
xpinstall-prompt-message-unknown = Si sta cercando di installare un componente aggiuntivo da un sito sconosciuto. Assicurarsi che il sito sia affidabile prima di proseguire.

xpinstall-prompt-dont-allow =
    .label = Non consentire
    .accesskey = N
xpinstall-prompt-never-allow =
    .label = Mai
    .accesskey = M
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Segnala sito sospetto
    .accesskey = S
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Prosegui con l’installazione
    .accesskey = P

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Questo sito sta richiedendo accesso ai tuoi dispositivi MIDI (Musical Instrument Digital Interface). È possibile garantire l’accesso installando un componente aggiuntivo.
site-permission-install-first-prompt-midi-message = Questo accesso potrebbe non essere completamente sicuro. Procedere solo se si considera il sito affidabile.

##

xpinstall-disabled-locked = L’installazione di software è stata disattivata dall’amministratore di sistema.
xpinstall-disabled = L’installazione di software è attualmente disattivata. Fare clic su Attiva e riprovare.
xpinstall-disabled-button =
    .label = Attiva
    .accesskey = A

# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) è stato bloccato dall’amministratore di sistema.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = L’amministratore di sistema ha impedito a questo sito di richiedere l’installazione di software sul computer.
addon-install-full-screen-blocked = L’installazione di un componente aggiuntivo non è consentita in modalità a schermo intero, oppure prima di passare a schermo intero.

# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } installato in { -brand-short-name }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } richiede nuovi permessi

# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = Completa l’installazione delle estensioni importate in { -brand-short-name }

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = Rimuovere { $name }?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = Rimuovere { $name } da { -brand-shorter-name }?
addon-removal-button = Rimuovi
addon-removal-abuse-report-checkbox = Segnala questa estensione a { -vendor-short-name }

# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying =
    { $addonCount ->
        [one] Download e verifica comp. aggiuntivo…
       *[other] Download e verifica { $addonCount } comp. aggiuntivi…
    }
addon-download-verifying = Verifica in corso

addon-install-cancel-button =
    .label = Annulla
    .accesskey = n
addon-install-accept-button =
    .label = Aggiungi
    .accesskey = A

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one] Questo sito vorrebbe installare un componente aggiuntivo in { -brand-short-name }
       *[other] Questo sito vorrebbe installare { $addonCount } componenti aggiuntivi in { -brand-short-name }
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one] Attenzione: questo sito vorrebbe installare un componente aggiuntivo non verificato in { -brand-short-name }. Procedere con cautela.
       *[other] Attenzione: questo sito vorrebbe installare { $addonCount } componenti aggiuntivi non verificati in { -brand-short-name }. Procedere con cautela.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = Attenzione: questo sito vorrebbe installare { $addonCount } componenti aggiuntivi in { -brand-short-name }, alcuni dei quali non verificati. Procedere con cautela.

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = Impossibile scaricare il componente aggiuntivo a causa di un errore nella connessione.
addon-install-error-incorrect-hash = Impossibile installare il componente aggiuntivo in quanto non corrisponde al componente aggiuntivo previsto da { -brand-short-name }.
addon-install-error-corrupt-file = Impossibile installare il componente aggiuntivo scaricato da questo sito in quanto il file risulta danneggiato.
addon-install-error-file-access = Impossibile installare { $addonName } in quanto { -brand-short-name } non è in grado di modificare il file richiesto.
addon-install-error-not-signed = L’installazione di un componente aggiuntivo non verificato è stata bloccata da { -brand-short-name }.
addon-install-error-invalid-domain = Impossibile installare il componente aggiuntivo { $addonName } da questo indirizzo.
addon-local-install-error-network-failure = Impossibile installare questo componente aggiuntivo in quanto si è verificato un errore nel filesystem.
addon-local-install-error-incorrect-hash = Impossibile installare questo componente aggiuntivo in quanto non corrisponde al componente aggiuntivo previsto da { -brand-short-name }.
addon-local-install-error-corrupt-file = Impossibile installare questo componente aggiuntivo in quanto risulta danneggiato.
addon-local-install-error-file-access = Impossibile installare { $addonName } in quanto { -brand-short-name } non è in grado di modificare il file richiesto.
addon-local-install-error-not-signed = Impossibile installare questo componente aggiuntivo in quanto non verificato.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = Impossibile installare { $addonName } in quanto non compatibile con { -brand-short-name } { $appVersion }.
addon-install-error-blocklisted = Impossibile installare { $addonName } in quanto comporta un rischio elevato per la stabilità o la sicurezza.

