# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = O profilih
profiles-subtitle = Ta stran vam pomaga pri upravljanju s profili. Vsak profil je svet zase, ki vsebuje ločeno zgodovino, zaznamke, nastavitve in dodatke.
profiles-create = Ustvari nov profil
profiles-restart-title = Ponovno zaženi
profiles-restart-in-safe-mode = Ponovno zaženi z onemogočenimi dodatki …
profiles-restart-normal = Običajen ponovni zagon …
profiles-conflict = Druga namestitev { -brand-product-name }a je spremenila podatke o profilih. Pred nadaljnjimi spremembami morate ponovno zagnati { -brand-short-name }.
profiles-flush-fail-title = Spremembe niso bile shranjene
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Nepričakovana napaka je preprečila shranjevanje sprememb.
profiles-flush-restart-button = Ponovno zaženi { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Privzeti profil
profiles-rootdir = Korenska mapa

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Krajevna mapa
profiles-current-profile = Ta profil je v uporabi in ga ni mogoče izbrisati.
profiles-in-use-profile = Ta profil trenutno uporablja drug program in ga ni mogoče izbrisati.

profiles-rename = Preimenuj
profiles-remove = Odstrani
profiles-set-as-default = Nastavi kot privzeti profil
profiles-launch-profile = Zaženi profil v novem brskalniku

profiles-cannot-set-as-default-title = Nastavitev privzetega profila ni bila mogoča
profiles-cannot-set-as-default-message = Privzetega profila za { -brand-short-name } ni bilo mogoče zamenjati.

profiles-yes = da
profiles-no = ne

profiles-rename-profile-title = Preimenuj profil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Preimenuj profil { $name }

profiles-invalid-profile-name-title = Neveljavno ime profila
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Ime profila "{ $name }" ni dovoljeno.

profiles-delete-profile-title = Izbriši profil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Brisanje odstrani profil iz seznama profilov, ki so na voljo, in ga ni mogoče razveljaviti.
    Izberete lahko tudi brisanje datotek profila, vključno z nastavitvami, digitalnimi potrdili in drugimi podatki uporabnika. Ta možnost bo izbrisala mapo "{ $dir }" in je ni mogoče razveljaviti.
    Ali bi radi izbrisali datoteke profila?
profiles-delete-files = Izbriši datoteke
profiles-dont-delete-files = Ne izbriši datotek

profiles-delete-profile-failed-title = Napaka
profiles-delete-profile-failed-message = Med poskusom brisanja profila je prišlo do napake.


profiles-opendir =
    { PLATFORM() ->
        [macos] Prikaži v Finderju
        [windows] Odpri mapo
       *[other] Odpri mapo
    }
