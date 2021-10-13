# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Om profiler
profiles-subtitle = Denne side hjælper dig med at håndtere dine profiler. Hver profil indeholder sin egen historik, bogmærker, indstillinger og tilføjelser.
profiles-create = Opret en ny profil
profiles-restart-title = Genstart
profiles-restart-in-safe-mode = Genstart med tilføjelser deaktiveret…
profiles-restart-normal = Genstart normalt…

profiles-conflict = En anden kopi af { -brand-product-name } har lavet ændringer til profiler. Du skal genstarte { -brand-short-name }, før du laver flere ændringer.
profiles-flush-fail-title = Ændringerne blev ikke gemt
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = En uventet fejl har forhindret dine ændringer i at blive gemt.
profiles-flush-restart-button = Genstart { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Standardprofil
profiles-rootdir = Rod-mappe

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Lokal mappe
profiles-current-profile = Denne profil benyttes i øjeblikket og kan ikke slettes.
profiles-in-use-profile = Denne profil benyttes i et andet program og kan derfor ikke slettes.

profiles-rename = Omdøb
profiles-remove = Fjern
profiles-set-as-default = Angiv som standardprofil
profiles-launch-profile = Start profilen i en ny browser-session

profiles-cannot-set-as-default-title = Kan ikke indstille standard
profiles-cannot-set-as-default-message = Standard-profilen i { -brand-short-name } kan ikke ændres.

profiles-yes = ja
profiles-no = nej

profiles-rename-profile-title = Omdøb profil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Omdøb profilen { $name }

profiles-invalid-profile-name-title = Ugyldigt profilnavn
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Profilnavnet "{ $name }" er ikke tilladt.

profiles-delete-profile-title = Slet profil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Sletning af en profil vil fjerne profilen fra listen over tilgængelige profiler og kan ikke fortrydes.
    Du kan også vælge at slette profilens datafiler, inklusive dine gemte mail, indstillinger og certifikater. Denne mulighed sletter mappen "{ $dir }" som derefter ikke kan gendannes.
    Ønsker du at slette profilens datafiler?
profiles-delete-files = Slet filer
profiles-dont-delete-files = Slet ikke filer

profiles-delete-profile-failed-title = Fejl
profiles-delete-profile-failed-message = Der opstod en fejl, da filen blev forsøgt slettet.


profiles-opendir =
    { PLATFORM() ->
        [macos] Vis i Finder
        [windows] Åbn mappe
       *[other] Åbn mappe
    }
