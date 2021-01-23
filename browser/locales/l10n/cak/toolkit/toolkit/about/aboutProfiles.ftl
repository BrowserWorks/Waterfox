# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Chi kij ri taq ruwäch b'i'aj
profiles-subtitle = Re ruxaq k'amaya'l re' nito'on chi nib'an runuk'ulem ri taq ruwäch ab'i'. Chi jujun taq ruwäch b'i'aj junwi chi ruwachulew, ri k'o runatab'al, taq yaketal, taq runuk'ulem chuqa' taq rutz'aqat.
profiles-create = Tinuk' jun k'ak'a' ruwäch b'i'aj
profiles-restart-title = Titikirisäx chik
profiles-restart-in-safe-mode = Titikirisäx chik kik'in ri chupül taq tz'aqat…
profiles-restart-normal = Titikirisäx chik achi'el jantape'…
profiles-conflict = Jun chik ruwachib'al { -brand-product-name } xerujäl ri taq ruwäch b'i'aj. K'o chi nitikirisäx chik { -brand-short-name } chuwäch ye'ab'äl ch'aqa' chik taq jaloj.
profiles-flush-fail-title = Man eyakon ta ri taq jaloj
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Jun man oyob'en ta sachoj xub'än chi man xeyak ta ri taq jaloj.
profiles-flush-restart-button = Titikirisäx chik { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Ruwäch b'i'aj: { $name }
profiles-is-default = Ruwäch b'i'aj kan k'o wi
profiles-rootdir = Ruxe' cholb'äl

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Aj wawe' cholb'äl
profiles-current-profile = Man tajin tan okisäx re ruwäch b'i'aj re' chuqa' man tikirel ta niyuj el.
profiles-in-use-profile = Re ruwäch b'i'aj re' nokisäx pa jun chik chokoy ruma ri' man tikirel ta niyuj el.

profiles-rename = Tisik'ïx chik
profiles-remove = Tiyuj
profiles-set-as-default = Tichap kan achi'el ruwäch b'i'aj ri kan k'o wi
profiles-launch-profile = Ruwäch b'i'aj richin relesaxik pa jun k'ak'a' okik'amaya'l

profiles-cannot-set-as-default-title = Man tikirel ta niya' qa ri k'o wi
profiles-cannot-set-as-default-message = Man tikirel ta nijal ri ruwäch b'i'aj k'o wi richin ri { -brand-short-name }.

profiles-yes = ja'
profiles-no = manäq

profiles-rename-profile-title = Tisik'ïx chik ri ruwäch b'i'aj
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Tisik'ïx chik ri ruwäch b'i'aj { $name }

profiles-invalid-profile-name-title = Man okel ta ri rub'i' ruwäch b'i'aj
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Man okel ta ri rub'i' ruwäch b'i'aj "{ $name }".

profiles-delete-profile-title = Telesäx el ri ruwäch b'i'aj
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Toq nayüj el jun ruwäch b'i'aj, xtelesäx el pa ri kicholajem taq ruwäch b'i'aj chuqa' man xkatikïr ta xtaköl.
    Chuqa' yatikïr nacha' chi keyuj el ri taq ruyakb'al rutzij ri ruwäch b'i'aj, achi'el ri anuk'ulem, taq ruwujil b'i'aj chuqa' ch'aqa' chik taq tzij. Re cha'oj re' xtuyüj el ri molyakb'äl "{ $dir }", akuchi' man tikirel ta nikolotäj.
    ¿La kan nawajo' ye'ayüj el ri taq ruyakb'al re ruwäch b'i'aj re'?
profiles-delete-files = Tiyuj el yakb'äl
profiles-dont-delete-files = Man keyuj el taq yakb'äl

profiles-delete-profile-failed-title = Sachoj
profiles-delete-profile-failed-message = Xk'ulwachitäj jun sachoj toq nitojtob'ëx niyuj re ruwäch b'i'aj re'.


profiles-opendir =
    { PLATFORM() ->
        [macos] Tik'ut pe pan ilonel
        [windows] Tijaq yakwuj
       *[other] Tijaq ri cholb'äl
    }
