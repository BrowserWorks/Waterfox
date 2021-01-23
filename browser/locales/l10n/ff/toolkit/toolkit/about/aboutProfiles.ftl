# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Baɗte Keftinirɗe
profiles-subtitle = Ngoo hello wallat-ma toppitaade keftinirɗe. Heen heftinirde fof ko lowre seertunde mooftoore aslol, maantore, teelte e ɓeyditte.
profiles-create = Sos Heftinirde Hesere
profiles-restart-title = Hurmitin
profiles-restart-in-safe-mode = Hurmitin tawa Ɓeyditte ena Ndaaƴaa…
profiles-restart-normal = Hurmitin goowangal…

# Variables:
#   $name (String) - Name of the profile
profiles-name = Heftinirde: { $name }
profiles-is-default = Heftinirde Woowaande
profiles-rootdir = Runngere Ɗaɗiire

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Runngere Ɓadiinde
profiles-current-profile = Ɗum ko heftinirde wonnde e huutoreede tee waawaa momteede.

profiles-rename = Innit
profiles-remove = Momtu
profiles-set-as-default = Waɗtu heftinirde woowaande
profiles-launch-profile = Hurmito heftinirde e wanngorde hesere

profiles-yes = eey
profiles-no = alaa

profiles-rename-profile-title = Innit Heftinirde
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Innit Heftinirde { $name }

profiles-invalid-profile-name-title = Innde heftinirde jaɓaaka
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Innde heftinirde “{ $name }” yamiraaka.

profiles-delete-profile-title = Momtu Heftinirde
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Momtude heftinirde maa ittu heftinirde ndee e doggol keftinirɗe goodɗe ɗee tee waawaa firteede.
    Aɗa waawi kadi suɓaade momtude keɓe heftinirde ndee, kañum e teelte maa, saadafaaje e keɓe kuutoro goɗɗe. Ndee suɓre maa momtu runngere “{ $dir }” tee waawaa firteede.
    Aɗa yiɗi momtude piille keɓe heftinirde ndee?
profiles-delete-files = Momtu Piille
profiles-dont-delete-files = Hoto Momtu Piille


profiles-opendir =
    { PLATFORM() ->
        [macos] Hollir e Yiytirde
        [windows] Uddit Runngere
       *[other] Uddit Runngere
    }
