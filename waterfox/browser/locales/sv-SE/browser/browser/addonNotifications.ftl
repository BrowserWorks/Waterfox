# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } hindrade den här webbplatsen från att be dig installera programvara på din dator.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = Tillåt { $host } att installera ett tillägg?
xpinstall-prompt-message = Du försöker installera ett tillägg från { $host }. Se till att du litar på den här webbplatsen innan du fortsätter.

##

xpinstall-prompt-header-unknown = Tillåt en okänd webbplats att installera ett tillägg?
xpinstall-prompt-message-unknown = Du försöker installera ett tillägg från en okänd webbplats. Se till att du litar på den här webbplatsen innan du fortsätter.

xpinstall-prompt-dont-allow =
    .label = Tillåt inte
    .accesskey = n
xpinstall-prompt-never-allow =
    .label = Tillåt aldrig
    .accesskey = a
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Rapportera misstänkt webbplats
    .accesskey = R
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Fortsätt till installation
    .accesskey = F

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Den här webbplatsen begär åtkomst till dina MIDI-enheter (Musical Instrument Digital Interface). Enhetsåtkomst kan aktiveras genom att installera ett tillägg.
site-permission-install-first-prompt-midi-message = Denna åtkomst är inte garanterad säker. Fortsätt bara om du litar på den här webbplatsen.

##

xpinstall-disabled-locked = Programvaruinstallationer har inaktiverats av systemadministratören.
xpinstall-disabled = Programvaruinstallationer är för närvarande inaktiverade. Klicka på Aktivera och försök sedan igen.
xpinstall-disabled-button =
    .label = Aktivera
    .accesskey = A

# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) blockeras av din systemadministratör.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = Din systemadministratör förhindrade den här webbplatsen från att be dig installera programvara på din dator.
addon-install-full-screen-blocked = Tilläggsinstallation är inte tillåten när den är i eller innan fullskärmsläge.

# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } har lagts till { -brand-short-name }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } kräver nya behörigheter

# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = Slutför installationen av tillägg importerade till { -brand-short-name }

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = Ta bort { $name }?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = Ta bort { $name } från { -brand-shorter-name }?
addon-removal-button = Ta bort
addon-removal-abuse-report-checkbox = Rapportera detta tillägg till { -vendor-short-name }

# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying =
    { $addonCount ->
        [one] Laddar ner och verifierar tillägg…
       *[other] Laddar ner och verifierar { $addonCount } tillägg…
    }
addon-download-verifying = Verifierar

addon-install-cancel-button =
    .label = Avbryt
    .accesskey = A
addon-install-accept-button =
    .label = Lägg till
    .accesskey = L

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one] Den här webbplatsen vill installera ett tillägg i { -brand-short-name }:
       *[other] Den här webbplatsen vill installera { $addonCount } tillägg i { -brand-short-name }:
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one] Varning: Den här webbplatsen vill installera ett overifierat tillägg i { -brand-short-name }. Fortsätt på egen risk.
       *[other] Varning: Den här webbplatsen vill installera { $addonCount } overifierade tillägg i { -brand-short-name }. Fortsätt på egen risk.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = Varning: Den här webbplatsen vill installera { $addonCount } tillägg i { -brand-short-name }, varav någon är overifierad. Fortsätt på egen risk.

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = Tillägget kunde inte hämtas eftersom anslutningen bröts.
addon-install-error-incorrect-hash = Tillägget kunde inte installeras eftersom det inte matchar tillägget som { -brand-short-name } förväntade sig.
addon-install-error-corrupt-file = Tillägget som hämtades från denna sidan kunde inte installeras eftersom det verkar som filen har blivit korrupt.
addon-install-error-file-access = { $addonName } kunde inte installeras eftersom { -brand-short-name } inte kan modifiera den nödvändiga filen.
addon-install-error-not-signed = { -brand-short-name } har hindrat den här webbplatsen från att installera ett overifierat tillägg.
addon-install-error-invalid-domain = Tillägget { $addonName } kan inte installeras från den här platsen.
addon-local-install-error-network-failure = Tillägget kunde inte installeras på grund av ett fel i filsystemet.
addon-local-install-error-incorrect-hash = Tillägget kunde inte installeras eftersom det inte matchar tillägget som { -brand-short-name } förväntade sig.
addon-local-install-error-corrupt-file = Tillägget kunde inte installeras eftersom det verkar vara trasigt.
addon-local-install-error-file-access = { $addonName } kunde inte installeras eftersom { -brand-short-name } inte kan modifiera den nödvändiga filen.
addon-local-install-error-not-signed = Detta tillägg kunde inte installeras eftersom det inte har verifierats.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = { $addonName } kunde inte installeras eftersom det inte är kompatibelt med { -brand-short-name } { $appVersion }.
addon-install-error-blocklisted = { $addonName } kunde inte installeras eftersom det finns en stor risk för att stabilitets- eller säkerhetsproblem uppstår.
