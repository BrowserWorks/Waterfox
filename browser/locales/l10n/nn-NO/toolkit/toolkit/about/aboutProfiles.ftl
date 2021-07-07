# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Om profilar
profiles-subtitle = Denne sida hjelper deg med å handtere profilane dine. Kvar profil er ei separat verd som inneheld separat historikk, separate bokmerke, innstillingar og tillegg.
profiles-create = Lag ein ny profil
profiles-restart-title = Start på nytt
profiles-restart-in-safe-mode = Start på nytt med utvidingar avslått…
profiles-restart-normal = Start på nytt vanleg…
profiles-conflict = Eit anna eksemplar av programmet { -brand-product-name } har gjort endringar i profilane. Du må starte { -brand-short-name } på nytt før du kan gjere fleire endringar.
profiles-flush-fail-title = Endringar ikkje lagra
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Ein uventa feil hindra endringane dine i å bli lagra.
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
profiles-localdir = Lokalmappe
profiles-current-profile = Dette er profilen som er i bruk, og han kan ikkje slettast.
profiles-in-use-profile = Denne profilen er i bruk i eit anna program, og han kan ikkje slettast.

profiles-rename = Byt namn
profiles-remove = Fjern
profiles-set-as-default = Vel som standard profil
profiles-launch-profile = Start profil i ny nettlesar

profiles-cannot-set-as-default-title = Kan ikkje stille inn som standard
profiles-cannot-set-as-default-message = Standardprofilen kan ikkje endrast for { -brand-short-name }.

profiles-yes = ja
profiles-no = nei

profiles-rename-profile-title = Byt namn på profilen
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Byt namn på profilen { $name }

profiles-invalid-profile-name-title = Ugyldig profilnamn
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = profilnamnet "{ $name }" er ikkje tillate.

profiles-delete-profile-title = Slett profilen
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Om du slettar ein profil vil det fjerne profilen frå lista over tilgjengelege profilar, og det kan ikkje angrast. 
    Du kan òg velje å slette profildata-filene, inkludert innstillingar, sertifikat og andre brukar-relaterte data. Dette valet vil òg slette mappa «{ $dir }», og kan ikkje gjerast om.
    Vil du slette profildata-filene?
profiles-delete-files = Slett filer
profiles-dont-delete-files = Ikkje slett filer

profiles-delete-profile-failed-title = Feil
profiles-delete-profile-failed-message = Det oppstod ein feil då du prøvde å slette denne profilen.


profiles-opendir =
    { PLATFORM() ->
        [macos] Vis i Finder
        [windows] Opne mappe
       *[other] Opne mappe
    }
