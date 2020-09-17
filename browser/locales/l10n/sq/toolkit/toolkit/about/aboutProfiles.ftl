# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Rreth Profilesh
profiles-subtitle = Kjo faqe ju ndihmon të administroni profilet tuaj. Çdo profil është një botë ndarazi që përmban historikun, faqerojtës, rregullime dhe shtesa.
profiles-create = Krijoni një Profil të Ri
profiles-restart-title = Riniseni
profiles-restart-in-safe-mode = Riniseni me Shtesat të Çaktivizuara…
profiles-restart-normal = Riniseni normalisht…
profiles-conflict = Një tjetër kopje e { -brand-product-name }-it ka bërë ndryshime te profilet. Duhet të rinisni { -brand-short-name }-in, përpara se të bëni ndryshime të tjera.
profiles-flush-fail-title = Ndryshimet s’u ruajtën
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Një gabim i papritur pengoi ruajtjen e ndryshimeve tuaja.
profiles-flush-restart-button = Rinise { -brand-short-name }-in

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Profil Parazgjedhje
profiles-rootdir = Drejtori Rrënjë

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Drejtori Vendore
profiles-current-profile = Ky është profili në përdorim dhe s’mund të fshihet.
profiles-in-use-profile = Ky profil është në përdorim nga një aplikacion dhe s’mund të fshihet.

profiles-rename = Riemërtoje
profiles-remove = Hiqe
profiles-set-as-default = Vëre si parazgjedhje
profiles-launch-profile = Nise profilin në shfletues të ri

profiles-cannot-set-as-default-title = S’arrihet të caktohet parazgjedhja
profiles-cannot-set-as-default-message = S’mund të ndryshohet profili parazgjedhje për { -brand-short-name }.

profiles-yes = po
profiles-no = jo

profiles-rename-profile-title = Riemërtoni Profil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Riemërtoni profilin { $name }

profiles-invalid-profile-name-title = Emër i pavlefshëm profili
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Nuk lejohet emri “{ $name }” për profilin.

profiles-delete-profile-title = Fshini Profil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Fshirja e një profili do të sjellë heqjen e tij prej listës së profileve të përdorshëm dhe s’mund të zhbëhet.
    Mund të zgjidhni edhe fshirjen e kartelave të të dhënave të profilit, përfshi rregullimet, dëshmitë, dhe të tjera të dhëna tuajat si përdorues. Kjo zgjedhje do sjellë fshirjen e dosjes "{ $dir }" dhe s’mund të zhbëhet.
    Do të donit të fshihen kartela të dhënash profili?
profiles-delete-files = Fshiji Kartelat
profiles-dont-delete-files = Mos i Fshi Kartelat

profiles-delete-profile-failed-title = Gabim
profiles-delete-profile-failed-message = Pati një gabim teksa provohej të fshihej ky profil.


profiles-opendir =
    { PLATFORM() ->
        [macos] Shfaqe në Finder
        [windows] Hape Dosjen
       *[other] Hape Drejtorinë
    }
