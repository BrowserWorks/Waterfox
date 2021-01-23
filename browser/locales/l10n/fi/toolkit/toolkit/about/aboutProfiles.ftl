# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Tietoja profiileista
profiles-subtitle = Tämä sivu auttaa hallinnoimaan profiilejasi. Jokainen profiili on oma maailmansa, joka sisältää erilliset historiat, kirjanmerkit, asetukset ja lisäosat.
profiles-create = Luo uusi profiili
profiles-restart-title = Käynnistä uudelleen
profiles-restart-in-safe-mode = Käynnistä uudelleen ilman lisäosia…
profiles-restart-normal = Käynnistä uudelleen normaalisti…
profiles-conflict = Toinen { -brand-product-name }-kopio on tehnyt muutoksia profiileihin. { -brand-short-name } täytyy käynnistää uudestaan ennen lisämuutosten tekemistä.
profiles-flush-fail-title = Muutoksia ei tallennettu
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Odottamaton virhe on estänyt muutosten tallentamisen.
profiles-flush-restart-button = Käynnistä { -brand-short-name } uudestaan

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profiili: { $name }
profiles-is-default = Oletusprofiili
profiles-rootdir = Päähakemisto

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Paikallinen hakemisto
profiles-current-profile = Tämä on tällä hetkellä käytössä oleva profiili, joten sitä ei voi poistaa.
profiles-in-use-profile = Profiili on käytössä toisessa ohjelmassa eikä sitä voida poistaa.

profiles-rename = Nimeä uudelleen
profiles-remove = Poista
profiles-set-as-default = Aseta oletusprofiiliksi
profiles-launch-profile = Käynnistä profiili uuteen selaimeen

profiles-cannot-set-as-default-title = Ei voitu asettaa oletukseksi
profiles-cannot-set-as-default-message = Oletusprofiilia ei voi muuttaa ohjelmalle { -brand-short-name }.

profiles-yes = kyllä
profiles-no = ei

profiles-rename-profile-title = Nimeä profiili uudelleen
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Nimeä profiili { $name } uudelleen

profiles-invalid-profile-name-title = Profiilin nimi ei kelpaa
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Profiilin nimi ”{ $name }” ei ole sallittu.

profiles-delete-profile-title = Poista profiili
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Profiilin poistaminen poistaa profiilin käytettävissä olevien profiilien listalta eikä tätä toimintoa voi kumota.
    Voit myös halutessasi poistaa profiilin datatiedostot, mukaan lukien asetuksesi, varmenteet ja muut käyttäjäkohtaiset tiedot. Tämä valinta poistaa kansion ”{ $dir }” eikä tätä toimintoa voi kumota.
    Haluatko poistaa profiilin datatiedostot?
profiles-delete-files = Poista tiedostot
profiles-dont-delete-files = Älä poista tiedostoja

profiles-delete-profile-failed-title = Virhe
profiles-delete-profile-failed-message = Profiilin poistaminen epäonnistui.


profiles-opendir =
    { PLATFORM() ->
        [macos] Näytä Finderissa
        [windows] Avaa kansio
       *[other] Avaa hakemisto
    }
