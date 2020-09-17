# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

profiles-title = O profilima
profiles-subtitle = Ova stranica pomaže pri upravljanju profilima. Svaki profil je zasebna cjelina koja sadrži zasebnu povijest, zabilješke, postavke i dodatke.
profiles-create = Stvori novi profil
profiles-restart-title = Pokreni ponovo
profiles-restart-in-safe-mode = Ponovo pokreni s isključenim dodacima …
profiles-restart-normal = Ponovo pokreni normalno …
profiles-conflict = Druga { -brand-product-name } kopija je napravila izmjene u profilu. Trebate ponovo pokrenuti { -brand-short-name } prije nego li napravite nove izmjene.
profiles-flush-fail-title = Izmjene nisu spremljene
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Neočekivana greška je spriječila spremanje vaših izmjena.
profiles-flush-restart-button = Ponovo pokreni { -brand-short-name }
# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Standardni profil
profiles-rootdir = Korijenski direktorij
# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Lokalni direktorij
profiles-current-profile = Ovaj se profil trenutačno koristi i ne može se izbrisati.
profiles-in-use-profile = Ovaj profil upotrebljava druga aplikacija i ne može se izbrisati.
profiles-rename = Preimenuj
profiles-remove = Ukloni
profiles-set-as-default = Postavi kao standardni profil
profiles-launch-profile = Pokreni profil u novom pregledniku
profiles-cannot-set-as-default-title = Nije moguće postaviti standardnu vrijednost
profiles-cannot-set-as-default-message = Standardni profil se ne može promijeniti za { -brand-short-name }.
profiles-yes = da
profiles-no = ne
profiles-rename-profile-title = Preimenuj profil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Preimenuj profil { $name }
profiles-invalid-profile-name-title = Neispravno ime profila
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Ime profila „{ $name }” nije dopušteno.
profiles-delete-profile-title = Izbriši profil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Brisanje profila uklonit će profil s popisa dostupnih profila i neće se moći vratiti.
    Možeš odabrati i brisanje podataka profila, uključujući tvoje postavke, certifikate i ostale korisničke podatke. Ova će opcija izbrisati mapu „{ $dir }” i neće se moći vratiti.
    Želiš li izbrisati datoteke profila?
profiles-delete-files = Izbriši datoteke
profiles-dont-delete-files = Nemoj izbrisati datoteke
profiles-delete-profile-failed-title = Greška
profiles-delete-profile-failed-message = Došlo je do pogreške za vrijeme brisanja ovog profila.
profiles-opendir =
    { PLATFORM() ->
        [macos] Prikaži u Finderu
        [windows] Otvori mapu
       *[other] Otvori direktorij
    }
