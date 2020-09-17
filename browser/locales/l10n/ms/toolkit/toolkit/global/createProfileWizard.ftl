# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Bestari Mencipta Profil
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Pengenalan
       *[other] Selamat Datang ke { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } menyimpan maklumat perihal tetapan dan keutamaan anda dalam profil peribadi anda.

profile-creation-explanation-2 = Jika anda berkongsi salinan { -brand-short-name } ini dengan pengguna lain, anda boleh gunakan profil untuk kekalkan maklumat pengguna terpisah. Untuk itu, setiap pengguna perlu mencipta profilnya sendiri.

profile-creation-explanation-3 = Jika hanya anda seorang yang menggunakan salinan { -brand-short-name }, anda mesti mempunyai sekurangnya satu profil. Jika anda mahu, anda boleh menipta banyak profil untuk diri anda bagi menyimpan tetapan dan keutamaan yang berbeza. Sebagai ontoh, anda mungkin mahukan profil berasingan untuk kegunaan perniagaan dan peribadi.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Untuk mula mencipta profil anda, klik Sambung.
       *[other] Untuk mula mencipta profil anda, klik Berikut.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Rumusan
       *[other] Menyelesaikan { create-profile-window.title }
    }

profile-creation-intro = Jika anda mencipta beberapa profil anda boleh panggilnya dengan nama profil. Anda boleh gunakan nama yang disediakan atau gunakan nama yang anda pilih.

profile-prompt = Masukkan nama profil baru:
    .accesskey = a

profile-default-name =
    .value = Pengguna Piawai

profile-directory-explanation = Tetapan pengguna anda, keutamaan dan data berkaitan pengguna lain akan disimpan di dalam:

create-profile-choose-folder =
    .label = Pilih Folder…
    .accesskey = l

create-profile-use-default =
    .label = Guna Folder Piawai
    .accesskey = U
