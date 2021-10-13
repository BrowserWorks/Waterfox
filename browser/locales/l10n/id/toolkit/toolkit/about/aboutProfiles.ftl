# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Tentang Profil
profiles-subtitle = Laman ini membantu Anda mengelola profil. Setiap profil adalah dunia terpisah yang berisi riwayat, markah, pengaturan, dan pengaya yang benar-benar terpisah.
profiles-create = Buat Profil Baru
profiles-restart-title = Mulai Ulang
profiles-restart-in-safe-mode = Mulai Ulang dengan Pengaya Dinonaktifkan…
profiles-restart-normal = Mulai ulang dengan normal…
profiles-conflict = Salinan lain dari { -brand-product-name } telah membuat perubahan pada profil. Anda harus memulai ulang { -brand-short-name } sebelum membuat lebih banyak perubahan.
profiles-flush-fail-title = Perubahan tidak disimpan
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Kesalahan tak terduga telah mencegah perubahan Anda disimpan.
profiles-flush-restart-button = Mulai Ulang { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Profil Baku
profiles-rootdir = Direktori Akar

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Direktori Lokal
profiles-current-profile = Profil ini sedang digunakan dan tidak dapat dihapus.
profiles-in-use-profile = Profil ini sedang digunakan dalam aplikasi lain dan tidak dapat dihapus.

profiles-rename = Ubah Nama
profiles-remove = Hapus
profiles-set-as-default = Setel sebagai profil baku
profiles-launch-profile = Luncurkan profil di peramban baru

profiles-cannot-set-as-default-title = Gagal menyetel bawaan
profiles-cannot-set-as-default-message = Profil bawaan tidak bisa diubah untuk { -brand-short-name }.

profiles-yes = ya
profiles-no = tidak

profiles-rename-profile-title = Ganti Nama Profil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Ganti nama profil { $name }

profiles-invalid-profile-name-title = Nama profil tidak sah
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Nama profil "{ $name }" tidak dibolehkan.

profiles-delete-profile-title = Hapus Profil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Menghapus sebuah profil akan menghilangkannya dari daftar profil yang tersedia dan tidak akan dapat dibatalkan.
    Anda juga bisa memilih menghapus berkas data profil, termasuk pengaturan, sertifikat, dan data pengguna lainnya. Pilihan ini akan menghapus folder “{ $dir }” dan tidak dapat dibatalkan.
    Apakah ingin menghapus berkas data profil?
profiles-delete-files = Hapus Berkas
profiles-dont-delete-files = Jangan Hapus Berkas

profiles-delete-profile-failed-title = Galat
profiles-delete-profile-failed-message = Terjadi kesalahan saat mencoba menghapus profil ini.


profiles-opendir =
    { PLATFORM() ->
        [macos] Tampilkan di Finder
        [windows] Buka folder
       *[other] Buka Direktori
    }
