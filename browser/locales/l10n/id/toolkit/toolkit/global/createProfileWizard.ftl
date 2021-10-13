# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Penuntun Pembuatan Profil
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Pendahuluan
       *[other] Selamat datang di { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } menyimpan informasi tentang pengaturan di profil pribadi Anda.

profile-creation-explanation-2 = Apabila Anda menggunakan program { -brand-short-name } bersama-sama dengan pengguna lain, Anda dapat menggunakan profil untuk menjaga terpisahnya data Anda dengan pengguna lain. Caranya adalah dengan membuat profil terpisah untuk setiap pengguna.

profile-creation-explanation-3 = Apabila Anda adalah satu-satunya orang yang menggunakan program { -brand-short-name } ini, Anda paling tidak harus membuat sebuah profil. Apabila diinginkan, Anda dapat membuat beberapa profil untuk menyimpan kelompok pengaturan yang berbeda. Sebagai contoh, Anda mempunyai profil terpisah untuk penggunaan pribadi dan untuk penggunaan bisnis.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Untuk memulai membuat profil, klik Lanjut.
       *[other] Untuk memulai membuat profil, klik Lanjut.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Kesimpulan
       *[other] Melengkapi { create-profile-window.title }
    }

profile-creation-intro = Apabila Anda membuat beberapa profil, Anda dapat mengenali profil dari nama profilnya. Anda dapat menggunakan nama yang diberikan di bawah ini atau menggantinya dengan nama lain.

profile-prompt = Masukkan nama profil baru:
    .accesskey = M

profile-default-name =
    .value = Pengguna Baku

profile-directory-explanation = Pengaturan yang Anda buat dan semua data lainnya akan disimpan di:

create-profile-choose-folder =
    .label = Pilih Folder…
    .accesskey = P

create-profile-use-default =
    .label = Gunakan Folder Baku
    .accesskey = u
