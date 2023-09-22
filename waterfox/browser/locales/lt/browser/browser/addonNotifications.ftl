# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = „{ -brand-short-name }“ neleido šiai svetainei prašyti jūsų leidimo įdiegti programinę įrangą į kompiuterį.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = Leisti { $host } įdiegti priedą?
xpinstall-prompt-message = Bandote įdiegti priedą iš { $host }. Prieš tęsdami įsitikinkite, ar pasitikite šia svetaine.

##

xpinstall-prompt-header-unknown = Leisti nežinomai svetainei įdiegti priedą?
xpinstall-prompt-message-unknown = Bandote įdiegti priedą iš nežinomos svetainės. Prieš tęsdami įsitikinkite, ar pasitikite šia svetaine.

xpinstall-prompt-dont-allow =
    .label = Neleisti
    .accesskey = N
xpinstall-prompt-never-allow =
    .label = Niekada neleisti
    .accesskey = N
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Tęsti diegimą
    .accesskey = T

# These messages are shown when a website invokes navigator.requestMIDIAccess.


##

xpinstall-disabled-locked = Programinės įrangos diegimas neleidžiamas jūsų sistemos administratoriaus.
xpinstall-disabled = Programinės įrangos automatinis diegimas šiuo metu neleidžiamas. Jei norite leisti, spustelėkite „Leisti“ ir bandykite vėl.
xpinstall-disabled-button =
    .label = Leisti
    .accesskey = L

# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = Jūsų sistemos administratorius yra užblokavęs „{ $addonName }“ ({ $addonId }).
addon-install-full-screen-blocked = Priedų diegimas yra neleidžiamas esant viso ekrano veiksenoje, arba prieš pareinant į ją.

# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = „{ $addonName }“ pridėtas į „{ -brand-short-name }“
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = „{ $addonName }“ reikalauja naujų leidimų

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = Pašalinti „{ $name }“?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = Pašalinti „{ $name }“ iš „{ -brand-shorter-name }“?
addon-removal-button = Pašalinti
addon-removal-abuse-report-checkbox = Pranešti apie šį priedą į „{ -vendor-short-name }“

# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying =
    { $addonCount ->
        [one] Parsiunčiamas ir patikrinamas priedas…
        [few] Parsiunčiami ir patikrinami { $addonCount } priedai…
       *[other] Parsiunčiama ir patikrinama { $addonCount } priedų…
    }
addon-download-verifying = Tikrinamas

addon-install-cancel-button =
    .label = Atsisakyti
    .accesskey = t
addon-install-accept-button =
    .label = Pridėti
    .accesskey = P

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one] Ši svetainė į { -brand-short-name } norėtų įdiegti priedą:
        [few] Ši svetainė į { -brand-short-name } norėtų įdiegti { $addonCount } priedus:
       *[other] Ši svetainė į { -brand-short-name } norėtų įdiegti { $addonCount } priedų:
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one] Atsargiai: ši svetainė į { -brand-short-name } nori įdiegti nepatvirtintą priedą. Tęskite suprasdami riziką.
        [few] Atsargiai: ši svetainė į { -brand-short-name } nori įdiegti { $addonCount } nepatvirtintus priedus. Tęskite suprasdami riziką.
       *[other] Atsargiai: ši svetainė į { -brand-short-name } nori įdiegti { $addonCount } nepatvirtintų priedų. Tęskite suprasdami riziką.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message =
    { $addonCount ->
        [few] Atsargiai: ši svetainė į { -brand-short-name } nori įdiegti { $addonCount } priedus, iš kurių dalis yra nepatikrinti. Tęskite suprasdami riziką.
       *[other] Atsargiai: ši svetainė į { -brand-short-name } nori įdiegti { $addonCount } priedų, iš kurių dalis yra nepatikrinti. Tęskite suprasdami riziką.
    }

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = Priedo parsiųsti nepavyko dėl ryšio sutrikimo.
addon-install-error-incorrect-hash = Priedo įdiegti nepavyko, nes tai ne tas priedas, kurio „{ -brand-short-name }“ tikėjosi.
addon-install-error-corrupt-file = Iš šios svetainės parsiųsto priedo įdiegti nepavyko, nes jis sugadintas.
addon-install-error-file-access = Priedas „{ $addonName }“ neįdiegtas, nes programai „{ -brand-short-name }“ nepavyko pakeisti reikiamo failo.
addon-install-error-not-signed = „{ -brand-short-name }“ neleido šiai svetainei įdiegti nepatikrinto priedo.
addon-install-error-invalid-domain = Priedas „{ $addonName }“ negali būti įdiegtas iš šios vietos.
addon-local-install-error-network-failure = Priedo įdiegti nepavyko dėl failų sistemos klaidos.
addon-local-install-error-incorrect-hash = Priedo įdiegti nepavyko, nes tai ne tas priedas, kurio { -brand-short-name }“ tikėjosi.
addon-local-install-error-corrupt-file = Priedo įdiegti nepavyko, nes jis sugadintas.
addon-local-install-error-file-access = Priedas „{ $addonName }“ neįdiegtas, nes programai „{ -brand-short-name }“ nepavyko pakeisti reikiamo failo.
addon-local-install-error-not-signed = Priedo nepavyko įdiegti, nes jis nėra patikrintas.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = Priedas „{ $addonName }“ neįdiegtas, nes jis nesuderinamas su „{ -brand-short-name } { $appVersion }“.
addon-install-error-blocklisted = Priedas „{ $addonName }“ neįdiegtas, nes yra didelė tikimybe, kad jis sukeltų stabilumo ar saugumo problemų.
