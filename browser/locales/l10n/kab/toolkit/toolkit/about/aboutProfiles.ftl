# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Talɣut ɣef imaɣna
profiles-subtitle = Asebter-a ad k-d-yefk tallelt i usefrek n imeɣna-inek. Yal ameɣnu d amaḍal i yiman-is i igebren azray-ines, ticraḍ-ines n isebtar, iɣawwaṛen-ines d izegrar-ines.
profiles-create = Rnu amaɣnu amaynut
profiles-restart-title = Ales asenker
profiles-restart-in-safe-mode = Ales asenker s usensi n izegrar…
profiles-restart-normal = Ales asenker s wudem amagnu…
profiles-conflict = Anɣel-nniḍen n { -brand-product-name } yewwi-d yid-s ibeddilen i yimuɣna. Ilaq ad talseḍ asenker n { -brand-short-name } send ad tedduḍ ɣer yibeddilen-nniḍen.
profiles-flush-fail-title = Isnifal ur ttwakelsen ara
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Tucḍa ur nettwarǧi ara ur teǧǧi ara isnifal-ik/im ad ttwakelsen.
profiles-flush-restart-button = Ales asenker n { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Amaɣnu: { $name }
profiles-is-default = Amaɣnu amezwer
profiles-rootdir = Akaram aẓaṛ

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Akaram adigan
profiles-current-profile = Amaɣnu-agi ittuseqdac yakan, ur yezmir ara ad ittwakkes.
profiles-in-use-profile = Amaγnu-agi attan ittwaseqdec deg usnas-nniḍen γef aya ur tezmireḍ ara ad tekseḍ-t.

profiles-rename = Snifel isem
profiles-remove = Kkes
profiles-set-as-default = Sbadut d amaɣnu amezwer
profiles-launch-profile = Senker amaɣnu ɣef iminig amaynut

profiles-cannot-set-as-default-title = Ur yezmir ara ad yesbadu amezwer
profiles-cannot-set-as-default-message = Amaɣnu amezwer ur izmir ara ad ibeddel i { -brand-short-name }.

profiles-yes = Ih
profiles-no = ala

profiles-rename-profile-title = Snifel isem n umaɣnu
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Snifel isem n umaɣnu "{ $name }"

profiles-invalid-profile-name-title = Isem n umaɣnu d arameɣtu
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Isem n umaɣnu "{ $name }" ur ittusireg ara.

profiles-delete-profile-title = Kkes amaɣnu
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Tukksa n umaɣnu ad isfeḍ amaɣnu si tebdart n imeɣna yellan, ur tettizmireḍ ara ad t-id-arreḍ.
    Tzemreḍ daɣen ad tferneḍ tukksa n ifuyla n isefka n umaɣnu, ddan daɣen iɣewwaṛen-ik, iselkan d isefka nniḍen icudden ɣeṛ useqdac. Aɣewwaṛ-agi ad yekkes akaram "{ $dir }", ihi ur tezmireḍ ara ad t-id-erreḍ.
    Tebɣiḍ ad tekkseḍ ifuyla n isefka n umaɣnu?
profiles-delete-files = Kkes ifuyla
profiles-dont-delete-files = Ur tekkes ara ifuyla

profiles-delete-profile-failed-title = Tuccḍa
profiles-delete-profile-failed-message = Teḍra-d tuccḍa deg tukksa n umaγnu-agi.


profiles-opendir =
    { PLATFORM() ->
        [macos] Ldi di Finder
        [windows] Ldi akaram
       *[other] Ldi akaram
    }
