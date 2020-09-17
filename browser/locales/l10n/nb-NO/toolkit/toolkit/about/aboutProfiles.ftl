# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Om profiler
profiles-subtitle = Denne siden hjelper deg å behandle dine profiler. Hver profil er en egen verden som inneholder egen historikk, bokmerker, innstillinger og utvidelser.
profiles-create = Lag en ny profil
profiles-restart-title = Start på nytt
profiles-restart-in-safe-mode = Start på nytt med utvidelser avslått …
profiles-restart-normal = Start på nytt vanlig …
profiles-conflict = En annen kopi av { -brand-product-name } har gjort endringer i profiler. Du må starte { -brand-short-name } på nytt før du kan gjøre flere endringer.
profiles-flush-fail-title = Endringer ikke lagret
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = En uventet feil hindret dine endringer i å bli lagret.
profiles-flush-restart-button = Start { -brand-short-name } på nytt

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Standardprofil
profiles-rootdir = Rotmappe

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Lokal mappe
profiles-current-profile = Denne profilen er i bruk, og den kan ikke slettes.
profiles-in-use-profile = Denne profilen er i bruk i et annet program, og den kan ikke slettes.

profiles-rename = Endre navn
profiles-remove = Fjern
profiles-set-as-default = Sett som standardprofil
profiles-launch-profile = Start profil i ny nettleser

profiles-cannot-set-as-default-title = Kan ikke angi standard
profiles-cannot-set-as-default-message = Standardprofilen kan ikke endres for { -brand-short-name }.

profiles-yes = ja
profiles-no = nei

profiles-rename-profile-title = Endre navn på profilen
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Endre navn på profilen { $name }

profiles-invalid-profile-name-title = Ugyldig profilnavn
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Profilnavnet «{ $name }» er ikke tillatt.

profiles-delete-profile-title = Slett profil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Sletting av en profil vil fjerne den profilen fra listen av tilgjengelige profiler, og kan ikke angres.
    Du kan også velge å slette datafilene i profilen, inkludert innstillinger, sertifikater og annen bruker-relatert data. Dette valget vil også slette mappen «{ $dir }» og kan ikke angres.
    Vil du slette datafilene i profilen?
profiles-delete-files = Slett filer
profiles-dont-delete-files = Ikke slett filer

profiles-delete-profile-failed-title = Feil
profiles-delete-profile-failed-message = En feil oppstod når du forsøkte å slette denne profilen.


profiles-opendir =
    { PLATFORM() ->
        [macos] Vis i Finder
        [windows] Åpne mappe
       *[other] Åpne mappe
    }
