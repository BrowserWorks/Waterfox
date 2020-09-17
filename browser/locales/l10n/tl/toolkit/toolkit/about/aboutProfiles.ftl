# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Tungkol sa Mga Profile
profiles-subtitle = Tinutulungan ka ng pahinang ito na pamahalaan ang iyong profile. Ang bawat profile ay isang hiwalay na mundo na naglalaman ng hiwalay na kasaysayan, mga bookmark, mga setting at mga add-on.
profiles-create = Lumikha ng isang Bagong Profile
profiles-restart-title = I-restart
profiles-restart-in-safe-mode = I-restart na may Add-ons Disabled...
profiles-restart-normal = I-restart ng pangkaraniwan...
profiles-conflict = May isa pang kopya ng { -brand-product-name } na gumawa ng pagbabago sa mga profile. Kailangan mo munang mag-restart ng { -brand-short-name } bago makagawa ng karagdagang pagbabago.
profiles-flush-fail-title = Hindi na-save ang mga pagbabago
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = May di-inaasahang problemang humadlang para ma-save ang mga binago mo.
profiles-flush-restart-button = I-restart ang { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profile: { $name }
profiles-is-default = Default Profile
profiles-rootdir = Root Directory

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Lokal na Direktoryo
profiles-current-profile = Ito ang profile na ginagamit at hindi ito maaaring matanggal.
profiles-in-use-profile = Ginagamit ng isa pang application ang profile na ito kaya hindi ito pwedeng burahin.

profiles-rename = Palitan ang pangalan
profiles-remove = Alisin
profiles-set-as-default = Itakda bilang default na profile
profiles-launch-profile = Ilunsad ang profile sa bagong browser

profiles-cannot-set-as-default-title = Hindi mai-set bilang default
profiles-cannot-set-as-default-message = Ang default na profile ay hindi kayang mabago para sa { -brand-short-name }.

profiles-yes = oo
profiles-no = hindi

profiles-rename-profile-title = Palitan ang pangalan ng Profile
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Palitan ang pangalan ng profile { $name }

profiles-invalid-profile-name-title = Di-wastong pangalan ng profile
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Hindi pinapayagan ang pangalan ng profile na “{ $name }”.

profiles-delete-profile-title = Tanggalin ang Profile
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Ang pagtanggal ng isang profile ay aalisin mula sa listahan ng magagamit na mga profile at hindi maaaring bawiin.
     Maaari mong piliin din na tanggalin ang mga file ng data ng profile, kasama ang iyong mga setting, certificate at iba pang data na may kaugnayan sa user. Tatanggalin ang folder na ito “{ $dir }” at hindi maaaring bawiin.
     Nais mo bang tanggalin ang mga file ng profile?
profiles-delete-files = Tanggalin ang Mga File
profiles-dont-delete-files = Huwag Tanggalin ang Mga File

profiles-delete-profile-failed-title = Error
profiles-delete-profile-failed-message = Nagkaproblema habang sinusubukang burahin ang profile na ito.


profiles-opendir =
    { PLATFORM() ->
        [macos] Ipakita sa Finder
        [windows] Buksan ang Folder
       *[other] Buksan ang Direktoryo
    }
