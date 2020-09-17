# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Maklumat Profil
profiles-subtitle = Halaman ini membantu anda untuk menguruskan profil. Setiap profil adalah entiti berbeza yang mengandungi perkataan, sejarah, tanda buku, tetapan dan add-ons yang berasingan.
profiles-create = Cipta Profil Baru
profiles-restart-title = Mula semula
profiles-restart-in-safe-mode = Mula semula dengan Add-ons Dinyahdayakan…
profiles-restart-normal = Mula semula secara normal…

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Profil Piawai
profiles-rootdir = Direktori Root

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Direktori Lokal
profiles-current-profile = Ini adalah profil yang sedang digunakan dan tidak boleh dihapuskan.
profiles-in-use-profile = Profil ini sedang digunakan dalam aplikasi lain dan tidak boleh dibuang.

profiles-rename = Namakan semula
profiles-remove = Buang
profiles-set-as-default = Set sebagai profil piawai
profiles-launch-profile = Lancarkan profil dalam pelayar baru

profiles-yes = ya
profiles-no = tidak

profiles-rename-profile-title = Namakan semula Profil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Namakan semula profil { $name }

profiles-invalid-profile-name-title = Nama profil tidak sah
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Nama profil “{ $name }” tidak dibenarkan.

profiles-delete-profile-title = Buang Profil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Membuang profil akan mengeluarkan profil daripada senarai profil dan tidak boleh dibatalkan.
    Anda juga boleh pilih untuk buang fail data profil, termasuk tetapan, sijil dan lain-lain data yang berkaitan dengan pengguna. Pilihan ini akan membuang folder “{ $dir }” dan tidak boleh dibatalkan.
    Adakah anda mahu buang fail data profil ini?
profiles-delete-files = Buang Fail
profiles-dont-delete-files = Jangan Buang Profil

profiles-delete-profile-failed-title = Ralat
profiles-delete-profile-failed-message = Ada ralat semasa percubaan untuk membuang profil ini.


profiles-opendir =
    { PLATFORM() ->
        [macos] Papar dalam Finder
        [windows] Buka Folder
       *[other] Buka Direktori
    }
