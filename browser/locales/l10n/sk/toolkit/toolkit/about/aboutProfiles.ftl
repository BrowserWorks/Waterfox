# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = O profiloch
profiles-subtitle = Táto stránka vám pomôže spravovať vaše profily. Každý profil je samostatný svet, ktorý obsahuje samostatnú históriu, záložky, nastavenia a doplnky.
profiles-create = Vytvoriť nový profil
profiles-restart-title = Reštartovať
profiles-restart-in-safe-mode = Reštartovať a zakázať doplnky…
profiles-restart-normal = Reštartovať normálne…
profiles-conflict = Iná kópia aplikácie { -brand-product-name } urobila zmeny v profile. Pred urobením ďalších zmien musíte reštartovať { -brand-short-name }.
profiles-flush-fail-title = Zmeny neboli uložené
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Neočakávaná chyba zabránila v uložení zmien.
profiles-flush-restart-button = Reštartovať { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Predvolený profil
profiles-rootdir = Koreňový priečinok

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Lokálny priečinok
profiles-current-profile = Toto je profil používa a nedá sa odstrániť.
profiles-in-use-profile = Tento profil je používaní inou aplikáciou a nemôže byť odstránený.

profiles-rename = Premenovať
profiles-remove = Odstrániť
profiles-set-as-default = Nastaviť ako predvolený profil
profiles-launch-profile = Spustiť profil v novom okne prehliadača

profiles-cannot-set-as-default-title = Predvolený profil nebolo možné zmeniť
profiles-cannot-set-as-default-message = Predvolený profil pre aplikáciu { -brand-short-name } nie je možné zmeniť.

profiles-yes = áno
profiles-no = nie

profiles-rename-profile-title = Premenovanie profilu
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Premenovať profil { $name }

profiles-invalid-profile-name-title = Neplatný názov profilu
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Názov profilu "{ $name }" nie je povolený.

profiles-delete-profile-title = Odstránenie profilu
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Odstránením profilu odstránite profil zo zoznamu dostupných profilov. Túto akciu nie je možné vrátiť späť.
    Môžete sa rozhodnúť odstrániť aj súbory profilu, vrátane nastavení, certifikátov a iných údajov týkajúcich sa používateľa. Táto možnosť odstráni priečinok "{ $dir }". Akciu nie je možné vrátiť späť.
    Chcete odstrániť aj súbory profilu?
profiles-delete-files = Odstrániť súbory
profiles-dont-delete-files = Neodstraňovať súbory

profiles-delete-profile-failed-title = Chyba
profiles-delete-profile-failed-message = Pri pokuse o odstránenie tohto profilu sa vyskytla chyba.


profiles-opendir =
    { PLATFORM() ->
        [macos] Zobraziť vo Finderi
        [windows] Otvoriť priečinok
       *[other] Otvoriť priečinok
    }
