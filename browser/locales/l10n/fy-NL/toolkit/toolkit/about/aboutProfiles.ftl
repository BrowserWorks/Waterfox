# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Oer profilen
profiles-subtitle = Dizze side helpt jo jo profilen te behearen. Elk profyl is in aparte omjouwing dy't aparte skiednis, blêdwizers, ynstellingen en add-ons befettet.
profiles-create = In nij profyl oanmeitsje
profiles-restart-title = Opnij starte
profiles-restart-in-safe-mode = Opnij starte mei útskeakele add-ons…
profiles-restart-normal = Normaal starte…
profiles-conflict = In oar eksimplaar fan { -brand-product-name } hat wizigingen yn profilen oanbrocht. Jo moatte { -brand-short-name } opnij starte, eardat jo mear wizigingen oanbringe.
profiles-flush-fail-title = Wizigingen net bewarre
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Troch in ûnferwachte flater binne jo wizigingen net bewarre.
profiles-flush-restart-button = { -brand-short-name } opnij starte

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profyl: { $name }
profiles-is-default = Standertprofyl
profiles-rootdir = Haadmap

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Lokale map
profiles-current-profile = Dit is it profyl dat yn gebrûk is en kin dêrom net fuortsmiten wurde.
profiles-in-use-profile = Dit profyl is yn gebrûk yn in oare tapassing en kin dêrom net fuortsmiten wurde.

profiles-rename = Omneame
profiles-remove = Fuortsmite
profiles-set-as-default = Ynstelle as standertprofyl
profiles-launch-profile = Profyl starte yn nije browser

profiles-cannot-set-as-default-title = Kin standertprofyl net ynstelle
profiles-cannot-set-as-default-message = It standertprofyl kin net wizige wurde foar { -brand-short-name }.

profiles-yes = ja
profiles-no = nee

profiles-rename-profile-title = Profyl omneame
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Profyl { $name } omneame

profiles-invalid-profile-name-title = Unjildige profylnamme
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = De profylnamme ‘{ $name }’ is net tastien.

profiles-delete-profile-title = Profyl fuortsmite
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    It fuortsmiten fan in profyl sil it profyl fan de list mei beskikbere profilen fuortsmite en kin net ûngedien makke wurde.
    Jo kinne der ek foar kieze om de bestannen mei profylgegevens, wêrûnder jo ynstellingen, sertifikaten en oare brûkersgegevens fuort te smiten. Dizze opsje sil de map ‘{ $dir }’ fuortsmite en kin net ûngedien makke wurde.
    Wolle jo de bestannen mei profylgegevens fuortsmite?
profiles-delete-files = Bestannen fuortsmite
profiles-dont-delete-files = Bestannen net fuortsmite

profiles-delete-profile-failed-title = Flater
profiles-delete-profile-failed-message = Der is in flater bard wylst in besykjen om dit profyl fuort te smiten.


profiles-opendir =
    { PLATFORM() ->
        [macos] Toane yn Finder
        [windows] Map iepenje
       *[other] Map iepenje
    }
