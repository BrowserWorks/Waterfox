# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Um notendur
profiles-subtitle = Þessi síða hjálpar þér að sýsla með notendastillingar. Hver notandi er með sérstakar stillingar sem inniheldur sér feril, bókamerki, stillingar og viðbætur.
profiles-create = Stofna nýjan notanda
profiles-restart-title = Endurræsa
profiles-restart-in-safe-mode = Endurræsa með viðbætur óvirkar…
profiles-restart-normal = Venjuleg endurræsing…

# Variables:
#   $name (String) - Name of the profile
profiles-name = Notandi: { $name }
profiles-is-default = Sjálfgefinn notandi
profiles-rootdir = Rótarmappa

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Staðbundin mappa
profiles-current-profile = Þessi notandi er þegar í notkun og er ekki hægt að eyða.
profiles-in-use-profile = Aðgangur þessa notanda er enn í notkun í öðru forriti og ekki hægt að fjarlægja hann.

profiles-rename = Endurnefna
profiles-remove = Fjarlægja
profiles-set-as-default = Setja sem sjálfgefin notanda
profiles-launch-profile = Keyra notanda í nýjum vafra

profiles-cannot-set-as-default-title = Ekki hægt að setja sem sjálfgefið gildi

profiles-yes = já
profiles-no = nei

profiles-rename-profile-title = Endurnefna notanda
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Endurnefna notanda { $name }

profiles-invalid-profile-name-title = Ólöglegt nafn á notanda
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Nafnið “{ $name }” er ekki leyfilegt nafn á notanda.

profiles-delete-profile-title = Eyða notanda
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Að eyða notanda mun eyða notanda úr lista yfir notendur og er ekki hægt að afturkalla.
    Þú getur einnig valið að eyða gögnum notanda, með stillingum, skilríkjum og öðrum gögnum. Þessi aðgerð mun eyða möppu “{ $dir }” og er ekki hægt að afturkalla.
    Viltu eyða gögnum notanda?
profiles-delete-files = Eyða skrám
profiles-dont-delete-files = Ekki eyða skrám

profiles-delete-profile-failed-title = Villa
profiles-delete-profile-failed-message = Villa hefur komið upp við að fjarlægja aðgang notanda.


profiles-opendir =
    { PLATFORM() ->
        [macos] Sýna í Finder
        [windows] Opna möppu
       *[other] Opna möppu
    }
