# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Headers used in the webextension permissions dialog,
## See https://bug1308309.bmoattachments.org/attachment.cgi?id=8814612
## for an example of the full dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension.

webext-perms-header = Pridėti „{ $extension }“?
webext-perms-header-with-perms = Pridėti „{ $extension }“? Šis priedas turės tokius leidimus:
webext-perms-header-unsigned = Pridėti „{ $extension }“? Šis priedas yra nepatikrintas. Kenkėjiški priedai gali pavogti jūsų asmeninę informaciją, arba apkrėsti kompiuterį. Pridėkite tik jei pasitikite šaltiniu.
webext-perms-header-unsigned-with-perms = Pridėti „{ $extension }“? Šis priedas yra nepatikrintas. Kenkėjiški priedai gali pavogti jūsų asmeninę informaciją, arba apkrėsti kompiuterį. Pridėkite tik jei pasitikite šaltiniu. Šis priedas turės tokius leidimus:
webext-perms-sideload-header = „{ $extension }“ pridėtas
webext-perms-optional-perms-header = „{ $extension }“ prašo papildomų leidimų.

##

webext-perms-add =
    .label = Pridėti
    .accesskey = P
webext-perms-cancel =
    .label = Atsisakyti
    .accesskey = A

webext-perms-sideload-text = Kita jūsų kompiuteryje esanti programa įrašė priedą, galintį paveikti jūsų naršyklę. Prašome peržiūrėti šio priedo prašomų leidimų sąrašą ir nuspręsti ar įjungti, ar atsisakyti (palikti išjungtą).
webext-perms-sideload-text-no-perms = Kita jūsų kompiuteryje esanti programa įrašė priedą, galintį paveikti jūsų naršyklę. Prašome nuspręsti ar įjungti, ar atsisakyti (palikti išjungtą).
webext-perms-sideload-enable =
    .label = Įjungti
    .accesskey = Į
webext-perms-sideload-cancel =
    .label = Atsisakyti
    .accesskey = A

# Variables:
#   $extension (String): replaced with the localized name of the extension.
webext-perms-update-text = „{ $extension }“ buvo atnaujintas. Jūs turite patvirtinti naujus leidimus prieš įrašant šią versiją. Pasirinkę „Atsisakyti“, liksite prie senos priedo versijos. Šis priedas turės tokius leidimus:
webext-perms-update-accept =
    .label = Naujinti
    .accesskey = N

webext-perms-optional-perms-list-intro = Jam reikia:
webext-perms-optional-perms-allow =
    .label = Leisti
    .accesskey = L
webext-perms-optional-perms-deny =
    .label = Drausti
    .accesskey = D

webext-perms-host-description-all-urls = Pasiekti jūsų duomenis visose svetainėse

# Variables:
#   $domain (String): will be replaced by the DNS domain for which a webextension is requesting access (e.g., mozilla.org)
webext-perms-host-description-wildcard = Pasiekti jūsų duomenis svetainėse, priklausančiose { $domain } sričiai

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-wildcards =
    { $domainCount ->
        [one] Pasiekti jūsų duomenis { $domainCount } kitoje srityje
        [few] Pasiekti jūsų duomenis { $domainCount } kitose srityse
       *[other] Pasiekti jūsų duomenis { $domainCount } kitų sričių
    }
# Variables:
#   $domain (String): will be replaced by the DNS host name for which a webextension is requesting access (e.g., www.mozilla.org)
webext-perms-host-description-one-site = Pasiekti jūsų duomenis iš { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-sites =
    { $domainCount ->
        [one] Pasiekti jūsų duomenis { $domainCount } kitoje svetainėse
        [few] Pasiekti jūsų duomenis { $domainCount } kitose svetainėse
       *[other] Pasiekti jūsų duomenis { $domainCount } kitų svetainių
    }

## Headers used in the webextension permissions dialog for synthetic add-ons.
## The part of the string describing what privileges the extension gives should be consistent
## with the value of webext-site-perms-description-gated-perms-{sitePermission}.
## Note, this string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $hostname (String): the hostname of the site the add-on is being installed from.


##


## Headers used in the webextension permissions dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension being installed.
##   $hostname (String): will be replaced by the DNS host name for which a webextension enables permissions.

webext-site-perms-header-with-perms = Pridėti „{ $extension }“? Šis priedas suteikia šias galimybes { $hostname }:
webext-site-perms-header-unsigned-with-perms = Pridėti „{ $extension }“? Šis priedas yra nepatikrintas. Kenkėjiški priedai gali pavogti jūsų asmeninę informaciją, arba apkrėsti kompiuterį. Pridėkite tik jei pasitikite šaltiniu. Šis priedas suteikia tokias galimybes { $hostname }:

## These should remain in sync with permissions.NAME.label in sitePermissions.properties

webext-site-perms-midi = Naudoti MIDI įrenginius
webext-site-perms-midi-sysex = Naudoti MIDI įrenginius su „SysEx“ palaikymu
