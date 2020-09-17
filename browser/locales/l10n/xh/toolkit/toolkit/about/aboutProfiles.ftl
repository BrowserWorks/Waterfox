# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Malunga neeProfayili
profiles-subtitle = Eli phepha likunceda ulawule iiprofayili zakho. Profayili nganye liyindawo eyahlukileyo equlelhe imbali, iibhukmakhi, iisetingi nezongelelo ezahlukileyo
profiles-create = Yila Iprofayili Entsha
profiles-restart-title = Qalisa kwakhona
profiles-restart-in-safe-mode = Qalisa Kwakhona Izongezelelo Zivaliwe…
profiles-restart-normal = Qalisa kwakhona ngokuqhelekileyo…

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profayili { $name }
profiles-is-default = Iprofayili Yedifolti
profiles-rootdir = Isalathiso seRuti

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Isalathiso Sasekuhlaleni
profiles-current-profile = Le yiprofayili esebenzayo yaye ayinakucinywa.

profiles-rename = Yinike igama kwakhona
profiles-remove = Susa
profiles-set-as-default = Seta ibe yiprofayili yedifolti
profiles-launch-profile = Qalisa iprofayile kwibhrawza entsha

profiles-yes = ewe
profiles-no = hayi

profiles-rename-profile-title = Phinda Unike Igama KwiProfayili
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Thiya ngokutsha iprofayili { $name }

profiles-invalid-profile-name-title = Igama leprofayili elingagunyaziswanga
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Igama leprofayili "{ $name }" alivunyelwanga.

profiles-delete-profile-title = Cima Iprofayili
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Ukucima iprofayili kuya kushenxisa iprofayili kuluhlu lweeprofayili ezifumanekayo kwaye aziyi kulungiswa.
    Usenokukhetha ukucima iifayile zengcombolo yeprofayili, okuquka iisetingi zakho, izatifiketi kunye nenye ingcombolo enxulumene nomsebenzisi. Oku kukhetha kuya kucima ifolda "{ $dir }" kwaye akunakulungiswa.
    Ungathanda ukuzicima iifayile zengcombolo yeprofayili?
profiles-delete-files = Cima Iifayile
profiles-dont-delete-files = Musa Ukucima Iifayile


profiles-opendir =
    { PLATFORM() ->
        [macos] Bonisa kwiSifumanisi
        [windows] Vula iFolda
       *[other] Isalathiso Esivulekileyo
    }
