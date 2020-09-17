# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Davart ils profils
profiles-subtitle = Questa pagina gida dad administrar tes profils. Mintga profil è in mund separà che cuntegna datas separadas per la cronologia, ils segnapaginas, ils parameters ed ils supplements.
profiles-create = Crear in nov profil
profiles-restart-title = Reaviar
profiles-restart-in-safe-mode = Reaviar e deactivar ils supplements…
profiles-restart-normal = Reaviar a moda normala…
profiles-conflict = In'autra copia da { -brand-product-name } ha modifitgà profils. Ti stos reaviar { -brand-short-name } avant che far ulteriuras midadas.
profiles-flush-fail-title = Betg memorisà las midadas
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = I n'è betg reussì da memorisar tias midadas pervia dad ina errur nunspetgada.
profiles-flush-restart-button = Reaviar { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Profil da standard
profiles-rootdir = Ordinatur da basa

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Ordinatur local
profiles-current-profile = Quai è il profil actual e na po betg vegnir stizzà.
profiles-in-use-profile = Impussibel da stizzar quest profil perquai ch'el vegn gist utilisà dad ina autra applicaziun.

profiles-rename = Renumnar
profiles-remove = Allontanar
profiles-set-as-default = Definir sco profil da standard
profiles-launch-profile = Avrir il profil en in nov navigatur

profiles-cannot-set-as-default-title = Impussibel da definir sco predefinì
profiles-cannot-set-as-default-message = Impussibel da midar il profil da standard per { -brand-short-name }.

profiles-yes = gea
profiles-no = na

profiles-rename-profile-title = Renumnar il profil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Renumnar il profil { $name }

profiles-invalid-profile-name-title = Num da profil nunvalid
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Il num da profil "{ $name }" n'è betg permess.

profiles-delete-profile-title = Stizzar il profil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    «Stizzar il profil» allontanescha il profil da la glista dals profils disponibels. I n'è betg pussaivel da revocar questa acziun.
    Ti pos tscherner dad era stizzar las datotecas dal profil, inclus ils parameters, ils cretificats ed autras datas da l'utilisader. Questa opziun vegn a stizzar l'ordinatur "{ $dir }" e na po betg vegnir revocada.
    Vuls ti stizzar las datotecas dal profil?
profiles-delete-files = Stizzar las datotecas
profiles-dont-delete-files = Betg stizzar las datotecas

profiles-delete-profile-failed-title = Errur
profiles-delete-profile-failed-message = Ina errur è succedida cun empruvar da stizzar quest profil.


profiles-opendir =
    { PLATFORM() ->
        [macos] Mussar en il finder
        [windows] Avrir l'ordinatur
       *[other] Avrir l'ordinatur
    }
