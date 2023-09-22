# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } hat diese Website daran gehindert, Sie zu fragen, ob Software auf Ihrem Computer installiert werden soll.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = { $host } das Installieren eines Add-ons erlauben?
xpinstall-prompt-message = Sie versuchen, ein Add-on von { $host } zu installieren. Überprüfen Sie, ob die Website vertrauenswürdig ist, bevor Sie fortfahren.

##

xpinstall-prompt-header-unknown = Unbekannter Website das Installieren eines Add-ons erlauben?
xpinstall-prompt-message-unknown = Sie versuchen, ein Add-on von einer unbekannten Website zu installieren. Überprüfen Sie, ob die Website vertrauenswürdig ist, bevor Sie fortfahren.
xpinstall-prompt-dont-allow =
    .label = Nicht erlauben
    .accesskey = N
xpinstall-prompt-never-allow =
    .label = Nie erlauben
    .accesskey = e
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Verdächtige Seite melden
    .accesskey = m
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Installation fortsetzen
    .accesskey = o

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Diese Website fordert Zugriff auf Ihre MIDI-Geräte (Musical Instrument Digital Interface) an. Der Gerätezugriff kann durch die Installation eines Add-ons aktiviert werden.
site-permission-install-first-prompt-midi-message = Dieser Zugrif ist nicht garantiert sicher. Fahren Sie nur fort, wenn Sie dieser Website vertrauen.

##

xpinstall-disabled-locked = Die Software-Installation wurde von Ihrem Administrator deaktiviert.
xpinstall-disabled = Die Software-Installation ist momentan deaktiviert. Klicken Sie auf  "Aktivieren" und versuchen Sie es dann erneut.
xpinstall-disabled-button =
    .label = Aktivieren
    .accesskey = k
# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) wurde durch den Systemadministrator blockiert.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = Ihr Systemadministrator hat diese Website daran gehindert, Sie zu fragen, ob Software auf Ihrem Computer installiert werden soll.
addon-install-full-screen-blocked = Das Installieren von Add-ons ist nicht erlaubt während des Vollbildmodus oder vor dessen Start.
# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } zu { -brand-short-name } hinzugefügt
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } benötigt neue Berechtigungen
# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = Abschluss der Installation von Erweiterungen, die in { -brand-short-name } importiert wurden

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = { $name } entfernen?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = { $name } aus { -brand-shorter-name } entfernen?
addon-removal-button = Entfernen
addon-removal-abuse-report-checkbox = Erweiterung melden an { -vendor-short-name }
# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying =
    { $addonCount ->
        [one] Add-on wird heruntergeladen und verifiziert…
       *[other] { $addonCount } Add-ons werden heruntergeladen und verifiziert…
    }
addon-download-verifying = Verifizieren
addon-install-cancel-button =
    .label = Abbrechen
    .accesskey = A
addon-install-accept-button =
    .label = Hinzufügen
    .accesskey = H

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one] Diese Seite möchte ein Add-on in { -brand-short-name } installieren:
       *[other] Diese Seite möchte { $addonCount } Add-ons in { -brand-short-name } installieren:
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one] Achtung: Diese Seite möchte ein nicht verifiziertes Add-on in { -brand-short-name } installieren. Das Installieren erfolgt auf eigene Gefahr.
       *[other] Achtung: Diese Seite möchte { $addonCount } nicht verifizierte Add-ons in { -brand-short-name } installieren. Das Installieren erfolgt auf eigene Gefahr.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = Achtung: Diese Seite möchte { $addonCount } Add-ons in { -brand-short-name } installieren, von denen einige nicht verifiziert sind. Das Installieren erfolgt auf eigene Gefahr.

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = Das Add-on konnte auf Grund eines Verbindungsfehlers nicht heruntergeladen werden.
addon-install-error-incorrect-hash = Das Add-on konnte nicht installiert werden, da es nicht das von { -brand-short-name } erwartete Add-on ist.
addon-install-error-corrupt-file = Das von dieser Seite heruntergeladene Add-on konnte nicht installiert werden, da es beschädigt zu sein scheint.
addon-install-error-file-access = { $addonName } konnte nicht installiert werden, da { -brand-short-name } die benötigte Datei nicht verändern kann.
addon-install-error-not-signed = { -brand-short-name } hat diese Website am Installieren eines nicht verifizierten Add-ons gehindert.
addon-install-error-invalid-domain = Das Add-on { $addonName } kann von diesem Speicherort nicht installiert werden.
addon-local-install-error-network-failure = Dieses Add-on konnte wegen eines Dateisystem-Fehlers nicht installiert werden.
addon-local-install-error-incorrect-hash = Dieses Add-on konnte nicht installiert werden, da es nicht das von { -brand-short-name } erwartete Add-on ist.
addon-local-install-error-corrupt-file = Dieses Add-on konnte nicht installiert werden, da es beschädigt zu sein scheint.
addon-local-install-error-file-access = { $addonName } konnte nicht installiert werden, da { -brand-short-name } die benötigte Datei nicht verändern kann.
addon-local-install-error-not-signed = Dieses Add-on konnte nicht installiert werden, da es nicht verifiziert wurde.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = { $addonName } konnte nicht installiert werden, da es nicht mit { -brand-short-name } { $appVersion } kompatibel ist.
addon-install-error-blocklisted = { $addonName } konnte nicht installiert werden, da es ein hohes Risiko bezüglich Stabilität und Sicherheit darstellt.
