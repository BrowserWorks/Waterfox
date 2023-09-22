# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } heeft voorkomen dat deze website u vraagt software op uw computer te installeren.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = Mag { $host } een add-on installeren?
xpinstall-prompt-message = U probeert een add-on te installeren vanaf { $host }. Zorg ervoor dat u deze website vertrouwt voordat u verdergaat.

##

xpinstall-prompt-header-unknown = Een onbekende website toestaan een add-on te installeren?
xpinstall-prompt-message-unknown = U probeert een add-on te installeren vanaf een onbekende website. Zorg ervoor dat u deze website vertrouwt voordat u verdergaat.

xpinstall-prompt-dont-allow =
    .label = Niet toestaan
    .accesskey = N
xpinstall-prompt-never-allow =
    .label = Nooit toestaan
    .accesskey = N
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Verdachte website melden
    .accesskey = m
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Doorgaan naar installatie
    .accesskey = D

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Deze website vraagt toegang tot uw MIDI-apparaten (Musical Instrument Digital Interface). Toegang tot apparaten kan worden ingeschakeld door een add-on te installeren.
site-permission-install-first-prompt-midi-message = Deze toegang is niet gegarandeerd veilig. Ga alleen verder als u deze website vertrouwt.

##

xpinstall-disabled-locked = Installatie van software is uitgeschakeld door uw systeembeheerder.
xpinstall-disabled = Installatie van software is momenteel uitgeschakeld. Klik op Inschakelen en probeer het opnieuw.
xpinstall-disabled-button =
    .label = Inschakelen
    .accesskey = n

# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) is geblokkeerd door uw systeembeheerder.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = Uw systeembeheerder heeft voorkomen dat deze website u vraagt software op uw computer te installeren.
addon-install-full-screen-blocked = Add-on-installatie is niet toegestaan in of voor het openen van de modus volledig scherm.

# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } is aan { -brand-short-name } toegevoegd
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } vereist nieuwe toestemmingen

# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = Installeren van naar { -brand-short-name } geïmporteerde extensies voltooien

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = { $name } verwijderen?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = { $name } uit { -brand-shorter-name } verwijderen?
addon-removal-button = Verwijderen
addon-removal-abuse-report-checkbox = Deze extensie rapporteren aan { -vendor-short-name }

# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying =
    { $addonCount ->
        [one] Add-on downloaden en verifiëren…
       *[other] { $addonCount } add-ons downloaden en verifiëren…
    }
addon-download-verifying = Verifiëren

addon-install-cancel-button =
    .label = Annuleren
    .accesskey = A
addon-install-accept-button =
    .label = Toevoegen
    .accesskey = T

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one] Deze website wil een add-on installeren in { -brand-short-name }:
       *[other] Deze website wil { $addonCount } add-ons installeren in { -brand-short-name }:
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one] Waarschuwing: deze website wil een niet-geverifieerde add-on installeren in { -brand-short-name }. Ga verder op eigen risico.
       *[other] Waarschuwing: deze website wil { $addonCount } niet-geverifieerde add-ons installeren in { -brand-short-name }. Ga verder op eigen risico.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = Waarschuwing: deze website wil { $addonCount } add-ons installeren in { -brand-short-name }, waarvan enkele niet zijn geverifieerd. Ga verder op eigen risico.

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = De add-on kon niet worden gedownload, vanwege een fout in de verbinding.
addon-install-error-incorrect-hash = De add-on kon niet worden geïnstalleerd, omdat deze niet overeenkomt met de verwachte add-on { -brand-short-name }.
addon-install-error-corrupt-file = De van deze website gedownloade add-on kon niet worden geïnstalleerd, omdat deze beschadigd lijkt.
addon-install-error-file-access = { $addonName } kon niet worden geïnstalleerd, omdat { -brand-short-name } het benodigde bestand niet kan aanpassen.
addon-install-error-not-signed = { -brand-short-name } heeft voorkomen dat deze website een niet-geverifieerde add-on heeft geïnstalleerd.
addon-install-error-invalid-domain = De add-on { $addonName } kan niet vanaf deze locatie worden geïnstalleerd.
addon-local-install-error-network-failure = Deze add-on kon niet worden geïnstalleerd, vanwege een bestandssysteemfout.
addon-local-install-error-incorrect-hash = Deze add-on kon niet worden geïnstalleerd, omdat deze niet overeenkomt met de verwachte add-on { -brand-short-name }.
addon-local-install-error-corrupt-file = Deze add-on kon niet worden geïnstalleerd, omdat deze beschadigd lijkt.
addon-local-install-error-file-access = { $addonName } kon niet worden geïnstalleerd, omdat { -brand-short-name } het benodigde bestand niet kan aanpassen.
addon-local-install-error-not-signed = Deze add-on kon niet worden geïnstalleerd, omdat deze niet is geverifieerd.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = { $addonName } kon niet worden geïnstalleerd, omdat het niet compatibel is met { -brand-short-name } { $appVersion }.
addon-install-error-blocklisted = { $addonName } kon niet worden geïnstalleerd, omdat het een hoog risico op stabiliteits- of beveiligingsproblemen geeft.
