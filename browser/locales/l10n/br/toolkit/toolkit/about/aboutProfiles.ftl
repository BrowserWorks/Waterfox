# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = A-zivout an aeladoù
profiles-subtitle = Ar bajenn-mañ a skoazell ac'hanoc'h da ardeiñ hoc'h aeladoù. Pep aelad a zo ur bed disheñvel gant pep a roll istor, sinedoù, arventennoù hag askouezhioù.
profiles-create = Krouiñ un aelad nevez
profiles-restart-title = Adloc'hañ
profiles-restart-in-safe-mode = Adloc'hañ gant an askouezhioù diweredekaet…
profiles-restart-normal = Adloc'hañ ordinal...
profiles-flush-fail-title = N'eo ket enrollet ar c'hemmoù
profiles-flush-conflict = { profiles-conflict }
profiles-flush-restart-button = Adloc'hañ { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Aelad : { $name }
profiles-is-default = Aelad dre ziouer
profiles-rootdir = Kavlec'h gwrizienn

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Kavlec'h lec'hel
profiles-current-profile = An aelad arveret eo an hini-mañ ha n'hall ket bezañ dilamet.
profiles-in-use-profile = Arveret eo an aelad-mañ gant un arload all ha n'hall ket bezañ dilamet.

profiles-rename = Adenvel
profiles-remove = Lemel kuit
profiles-set-as-default = Lakaat evel aelad dre ziouer
profiles-launch-profile = Lañsañ an aelad en ur merdeer nevez

profiles-cannot-set-as-default-title = N'haller ket lakaat dre ziouer
profiles-cannot-set-as-default-message = N'haller ket kemmañ an aelad dre ziouer evit { -brand-short-name }

profiles-yes = ya
profiles-no = ket

profiles-rename-profile-title = Adenvel an aelad
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Adenvel an aelad { $name }

profiles-invalid-profile-name-title = Anv aelad didalvoudek
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = N'eo ket aotreet an anv aelad "{ $name }".

profiles-delete-profile-title = Dilemel an aelad
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Dilemel un aelad a denno kuit an aelad diwar roll an aeladoù hegerz ha n'hallot ket dizober.
    Dibabet e vez ivez dilemel restroù roadennoù an aelad, enno hoc'h arventennoù, testenioù pe roadennoù arveriaded kar all. Dilamet e vo an teuliad "{ $dir }" gant an dibarzh-mañ ha n'hallot ket dizober.
    Ha fellout a rafe deoc'h dilemel restroù roadennoù an aelad ?
profiles-delete-files = Dilemel ar restroù
profiles-dont-delete-files = Na zilemel ar restroù

profiles-delete-profile-failed-title = Fazi
profiles-delete-profile-failed-message = Degouezhet ez eus bet ur fazi en ur glask dilemel an aelad-mañ.


profiles-opendir =
    { PLATFORM() ->
        [macos] Diskouez e-barzh Finder
        [windows] Digeriñ un teuliad
       *[other] Digeriñ ar c'havlec'h
    }
