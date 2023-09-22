# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } forhindrede webstedet i at spørge om du vil installere software på din computer.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = Vil du give { $host } lov til at installere en tilføjelse?
xpinstall-prompt-message = Du forsøger at installere en tilføjelse fra { $host }. Fortsæt kun, hvis du stoler på webstedet.

##

xpinstall-prompt-header-unknown = Vil du give et ukendt websted lov til at installere en tilføjelse?
xpinstall-prompt-message-unknown = Du forsøger at installere en tilføjelse fra et ukendt websted. Fortsæt kun, hvis du stoler på webstedet.

xpinstall-prompt-dont-allow =
    .label = Tillad ikke
    .accesskey = A
xpinstall-prompt-never-allow =
    .label = Tillad aldrig
    .accesskey = l
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Rapporter mistænkeligt websted
    .accesskey = R
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Fortsæt til installation
    .accesskey = o

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Webstedet anmoder om adgang til dine MIDI-enheder (Musical Instrument Digital Interface). Adgang kan aktiveres ved at installere en tilføjelse.
site-permission-install-first-prompt-midi-message = Der er ingen garanti for, at adgangen er sikker. Fortsæt kun, hvis du stoler på webstedet.

##

xpinstall-disabled-locked = Installation af software er deaktiveret af din systemadministrator.
xpinstall-disabled = Installation af software er i øjeblikket deaktiveret. Klik på Aktiver og prøv igen.
xpinstall-disabled-button =
    .label = Aktiver
    .accesskey = A

# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) er blokeret af din system-administrator.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = Din systemadministrator har forhindret dette websted i at spørge dig om lov til at installere software på din computer.
addon-install-full-screen-blocked = Installation af tilføjelser er ikke tilladt i fuldskærms-tilstand eller ved aktivering af fuldskærms-tilstand.

# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } blev tilføjet til { -brand-short-name }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } kræver nye tilladelser

# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = Afslut installation af udvidelser importeret til { -brand-short-name }

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = Fjern { $name }?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = Fjern { $name } fra { -brand-shorter-name }?
addon-removal-button = Fjern
addon-removal-abuse-report-checkbox = Rapporter denne udvidelse til { -vendor-short-name }

# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying =
    { $addonCount ->
        [one] Henter og verificerer tilføjelse…
       *[other] Henter og verificerer { $addonCount } tilføjelser…
    }
addon-download-verifying = Verificerer

addon-install-cancel-button =
    .label = Afbryd
    .accesskey = A
addon-install-accept-button =
    .label = Tilføj
    .accesskey = T

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one] Webstedet beder om tilladelse til at installere en tilføjelse til { -brand-short-name }:
       *[other] Webstedet beder om tillladelse til at installere { $addonCount } tilføjelser til { -brand-short-name }:
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one] Webstedet beder om tilladelse til at installere en uverificeret tilføjelse til { -brand-short-name }: Fortsæt på eget ansvar.
       *[other] Webstedet beder om tillladelse til at installere { $addonCount }  uverificerede tilføjelser til { -brand-short-name }. Fortsæt på eget ansvar.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = Advarsel: Webstedet beder om tilladelse til at installere { $addonCount } tilføjelser til { -brand-short-name }, hvoraf nogle ikke er verificerede. Fortsæt på eget ansvar.

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = Tilføjelsen kunne ikke hentes på grund af en forbindelsesfejl.
addon-install-error-incorrect-hash = Tilføjelsen kunne ikke installeres, fordi den ikke matcher, hvad { -brand-short-name } forventede.
addon-install-error-corrupt-file = Tilføjelsen fra dette websted kunne ikke installeres, da den synes at være ødelagt.
addon-install-error-file-access = { $addonName } kunne ikke installeres, fordi { -brand-short-name } ikke kan redigere den nødvendige fil.
addon-install-error-not-signed = { -brand-short-name } har forhindret dette websted i at installere en uverificeret tilføjelse.
addon-install-error-invalid-domain = Tilføjelsen { $addonName } kan ikke installeres fra denne placering.
addon-local-install-error-network-failure = Denne tilføjelse kunne ikke installeres på grund af en filsystemsfejl.
addon-local-install-error-incorrect-hash = Denne tilføjelse kunne ikke installeres, fordi den ikke matcher den tilføjelse { -brand-short-name } forventede.
addon-local-install-error-corrupt-file = Denne tilføjelse kunne ikke installeres, fordi den lader til at være ødelagt.
addon-local-install-error-file-access = { $addonName } kunne ikke installeres, fordi { -brand-short-name } ikke kan redigere den nødvendige fil.
addon-local-install-error-not-signed = Denne tilføjelse kunne ikke installeres, fordi den ikke er blevet verificeret.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = { $addonName } kunne ikke installeres, da den ikke er kompatibel med { -brand-short-name } { $appVersion }.
addon-install-error-blocklisted = { $addonName } kunne ikke installeres, fordi der er høj risiko for, at den forårsager stabilitets- eller sikkerhedsproblemer.
