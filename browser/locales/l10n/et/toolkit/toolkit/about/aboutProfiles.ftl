# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Profiilid
profiles-subtitle = See leht aitab sul hallata oma profiile. Iga profiil on nagu eraldi maailm, mis sisaldab oma ajalugu, järjehoidjaid, sätteid ja lisasid.
profiles-create = Loo uus profiil
profiles-restart-title = Taaskäivitamine
profiles-restart-in-safe-mode = Taaskäivita koos lisade keelamisega…
profiles-restart-normal = Taaskäivita tavapäraselt…
profiles-conflict = Teine { -brand-product-name }i instants on teinud profiilidesse muudatusi. Enne uute muudatuste salvestamist pead sa { -brand-short-name }i taaskäivitama.
profiles-flush-fail-title = Muudatusi ei salvestatud
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Ootamatu viga takistas muudatuste salvestamist.
profiles-flush-restart-button = Taaskäivita { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profiil: { $name }
profiles-is-default = Vaikeprofiil
profiles-rootdir = Juurkaust

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Kohalik kaust
profiles-current-profile = See profiil on kasutusel ja seda ei saa kustutada.
profiles-in-use-profile = See profiil on teises rakenduses kasutusel ja seda ei saa kustutada.

profiles-rename = Muuda nime
profiles-remove = Eemalda
profiles-set-as-default = Määra vaikeprofiiliks
profiles-launch-profile = Ava profiil uues aknas

profiles-cannot-set-as-default-title = Vaikeprofiiliks määramine polnud võimalik
profiles-cannot-set-as-default-message = { -brand-short-name }i vaikeprofiili ei pole võimalik muuta.

profiles-yes = jah
profiles-no = ei

profiles-rename-profile-title = Profiili nime muutmine
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Profiili { $name } nime muutmine

profiles-invalid-profile-name-title = Vigane profiili nimi
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Profiili nimi "{ $name }" pole lubatud.

profiles-delete-profile-title = Profiili kustutamine
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Profiili kustutamisel eemaldatakse see saadaolevate profiilide nimekirjast ja seda sammu pole võimalik tagasi võtta.
    Soovi korral võid kustutada ka profiili andmed, sealhulgas sätted, sertifikaadid ja muu kasutajaga seotud info. See valik kustutab kausta "{ $dir }" ja seda pole võimalik tagasi võtta.
    Kas soovid profiili andmefailid kustutada?
profiles-delete-files = Kustuta failid
profiles-dont-delete-files = Ära kustuta faile

profiles-delete-profile-failed-title = Viga
profiles-delete-profile-failed-message = Selle profiili kustutamisel esines viga.


profiles-opendir =
    { PLATFORM() ->
        [macos] Kuva Finderis
        [windows] Ava kaust
       *[other] Ava kaust
    }
