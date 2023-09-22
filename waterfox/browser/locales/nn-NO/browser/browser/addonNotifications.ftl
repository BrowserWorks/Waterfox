# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } hindra denne sida frå å spørje deg om å installere programvare på datamaskina di.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = Tillate { $host } å innstallere eit tillegg?
xpinstall-prompt-message = Du prøver å installere eit tillegg frå { $host }. Hald berre fram om du stolar på nettsida.

##

xpinstall-prompt-header-unknown = Tillate ein ukjend nettstad å installere eit tillegg?
xpinstall-prompt-message-unknown = Du prøver å installere ei utviding frå ei ukjend nettside. Fortset berre viss du stolar på nettstaden.
xpinstall-prompt-dont-allow =
    .label = Ikkje tillat
    .accesskey = k
xpinstall-prompt-never-allow =
    .label = Aldri tillat
    .accesskey = A
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Rapporter mistenkjeleg nettstad
    .accesskey = R
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Fortset til installasjon
    .accesskey = F

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Denne nettstaden ber om tilgang til MIDI-einingane (Musical Instrument Digital Interface) dine. Tilgang for eininga kan aktiverast ved å installere eit tillegg.
site-permission-install-first-prompt-midi-message = Denne tilgangen er ikkje garantert å vere sikker. Hald berre fram om du stolar på nettstaden.

##

xpinstall-disabled-locked = Programvareinstallasjon er avslått av systemansvarleg.
xpinstall-disabled = Programvareinstallasjon er avslått no. Trykk på Tillat for å slå på, og prøv på nytt.
xpinstall-disabled-button =
    .label = Tillat
    .accesskey = T
# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) vert blokkert av systemadministratoren din.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = Systemadministratoren din hindra denne nettstaden frå å spørje deg om å installere programvare på datamaskina di.
addon-install-full-screen-blocked = Tilleggsinnstallasjon er ikkje tillaten medan du er i, eller før du går inn i, fullskjermmodus.
# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } lagt til i { -brand-short-name }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } krev nye løyve
# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = Fullfør installasjonen av utvidingar importerte til { -brand-short-name }

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = Fjerne { $name }?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = Fjerne { $name } frå { -brand-shorter-name }?
addon-removal-button = Fjern
addon-removal-abuse-report-checkbox = Rapporter denne utvidinga til { -vendor-short-name }
# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying =
    { $addonCount ->
        [one] Lastar ned og stadfestar tillegg…
       *[other] Lastar ned og stadfestar { $addonCount } tillegg…
    }
addon-download-verifying = Stadfestar
addon-install-cancel-button =
    .label = Avbryt
    .accesskey = A
addon-install-accept-button =
    .label = Legg til
    .accesskey = L

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one] Denne sida vil gjerne installere eit tillegg i { -brand-short-name }:
       *[other] Denne sida vil gjerne installere { $addonCount } tillegg i { -brand-short-name }:
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one] Åtvaring: Denne nettstaden ønskjer å installere eit ikkje-stadfesta tillegg i { -brand-short-name }. Fortset på eigen risiko.
       *[other] Åtvaring: Denne nettstaden ønskjer å installere { $addonCount } ikkje-stadfesta tillegg i { -brand-short-name }. Fortset på eigen risiko.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = Åtvaring: Denne nettstaden ønskjer å installere { $addonCount } tillegg i { -brand-short-name }, der nokre er ikkje-stadfesta. Fortset på eigen risiko.

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = Klarte ikkje å laste ned tillegget på grunn av ein tilkoplingsfeil.
addon-install-error-incorrect-hash = Klarte ikkje å installere tillegget fordi det ikkje passar med det tillegget { -brand-short-name } venta.
addon-install-error-corrupt-file = Klarte ikkje å installere tillegget, lasta ned frå denne sida, fordi det ser ut til at det er skada.
addon-install-error-file-access = Klarte ikkje å installere { $addonName } fordi { -brand-short-name } ikkje klarte å endre den påkravde fila.
addon-install-error-not-signed = { -brand-short-name } har hindra denne sida frå å installere eit ikkje-stadfesta tillegg.
addon-install-error-invalid-domain = Tillegget { $addonName } kan ikkje installerast frå denne plasseringa.
addon-local-install-error-network-failure = Klarte ikkje å installere dette tillegget på grunn av ein feil i filsystemet.
addon-local-install-error-incorrect-hash = Klarte ikkje å installere dette tillegget på grunn av at det ikkje passar med utvidinga som { -brand-short-name } venta.
addon-local-install-error-corrupt-file = Klarte ikkje å installere dette tillegget fordi det ser ut til å vere skada.
addon-local-install-error-file-access = Klarte ikkje å installere { $addonName } fordi { -brand-short-name } kan ikkje endre den påkravde fila.
addon-local-install-error-not-signed = Klarte ikkje å installere dette tillegget fordi det ikkje er stadfesta.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = Klarte ikkje å installere { $addonName } fordi det ikkje er kompatibelt med { -brand-short-name } { $appVersion }.
addon-install-error-blocklisted = Klarte ikkje å installere { $addonName } fordi det er fare for at det vert laga tryggings- og stabilitetsproblem.
