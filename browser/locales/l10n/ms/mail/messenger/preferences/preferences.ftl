# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


close-button =
    .aria-label = Tutup

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Pilihan
           *[other] Keutamaan
        }

pane-compose-title = Karangan
category-compose =
    .tooltiptext = Karangan

pane-chat-title = Sembang
category-chat =
    .tooltiptext = Sembang

pane-calendar-title = Kalendar
category-calendar =
    .tooltiptext = Kalendar

choose-messenger-language-description = Pilih bahasa yang digunakan untuk memaparkan menu, mesej dan notifikasi { -brand-short-name }.
manage-messenger-languages-button =
    .label = Tetapkan Alternatif...
    .accesskey = T
confirm-messenger-language-change-description = Mula semula { -brand-short-name } untuk melaksanakan perubahan ini
confirm-messenger-language-change-button = Terap dan Mula semula

addons-button = Ekstensi & Tema

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = Halaman Permulaan { -brand-short-name }

start-page-label =
    .label = Apabila { -brand-short-name } dilancarkan, papar Halaman Permulaan dalam ruang mesej
    .accesskey = A

location-label =
    .value = Lokasi:
    .accesskey = o
restore-default-label =
    .label = Pulih Piawai
    .accesskey = P

default-search-engine = Enjin Carian Piawai

new-message-arrival = Apabila ada mesej baru:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Mainkan fail bunyian berikut:
           *[other] Mainkan bunyian
        }
    .accesskey =
        { PLATFORM() ->
            [macos] n
           *[other] n
        }
mail-play-button =
    .label = Main
    .accesskey = M

change-dock-icon = Tukar keutamaan ikon aplikasi
app-icon-options =
    .label = Pilihan Ikon Aplikasi…
    .accesskey = n

notification-settings = Makluman dan bunyian piawai boleh dinyahaktifkan dalam anak tetingkap Notifikasi dalam Keutamaan Sistem.

animated-alert-label =
    .label = Papar makluman
    .accesskey = P
customize-alert-label =
    .label = Penyesuaian…
    .accesskey = P

tray-icon-label =
    .label = Papar ikon dulang
    .accesskey = d

mail-custom-sound-label =
    .label = Gunakan fail bunyian berikut
    .accesskey = G
mail-browse-sound-button =
    .label = Cari…
    .accesskey = C

enable-gloda-search-label =
    .label = Aktifkan Carian Global dan Pengindeks
    .accesskey = A

datetime-formatting-legend = Format Tarikh dan Masa
language-selector-legend = Bahasa

allow-hw-accel =
    .label = Guna pecutan perkakasan, jika tersedia
    .accesskey = p

store-type-label =
    .value = Jenis Storan Mesej untuk akaun baru:
    .accesskey = J

mbox-store-label =
    .label = Fail setiap folder (mbox)
maildir-store-label =
    .label = Fail setiap mesej (maildir)

scrolling-legend = Skrol
autoscroll-label =
    .label = Guna auto-skrol
    .accesskey = G
smooth-scrolling-label =
    .label = Guna skrol lancar
    .accesskey = c

system-integration-legend = Integrasi Sistem
always-check-default =
    .label = Sentiasa semak samada { -brand-short-name } adalah klien mel piawai pada permulaan
    .accesskey = S
check-default-button =
    .label = Semak Sekarang…
    .accesskey = S

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

search-integration-label =
    .label = Izinkan { search-engine-name } mencari mesej
    .accesskey = S

config-editor-button =
    .label = Editor Konfigurasi…
    .accesskey = E

return-receipts-description = Tentukan cara { -brand-short-name } mengendalikan resit pemberitahu serahan
return-receipts-button =
    .label = Resit Pemberitahu Serahan…
    .accesskey = R

update-app-legend = Kemaskini { -brand-short-name }

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Versi { $version }

automatic-updates-label =
    .label = Pasang kemaskini secara automatik (digalakkan: meningkatkan keselamatan)
    .accesskey = P
check-updates-label =
    .label = Semak sebarang kemaskini, tetapi biarkan saya pilih untuk memasangnya
    .accesskey = S

update-history-button =
    .label = Papar Sejarah Kemaskini
    .accesskey = s

use-service =
    .label = Gunakan servis latar belakang bagi pemasangan versi terkini
    .accesskey = b

networking-legend = Sambungan
proxy-config-description = Tentukan cara { -brand-short-name } menyambung ke Internet

network-settings-button =
    .label = Tetapan…
    .accesskey = T

offline-legend = Luar talian
offline-settings = Konfigurasi tetapan luar talian

offline-settings-button =
    .label = Luar talian…
    .accesskey = L

diskspace-legend = Ruang Cakera
offline-compact-folder =
    .label = Padatkan semua folder apabila dapat menjimatkan
    .accesskey = a

compact-folder-size =
    .value = MB secara keseluruhan

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Guna sehingga
    .accesskey = G

use-cache-after = MB ruang untuk cache

##

smart-cache-label =
    .label = Terbalikkan pengurusan cache automatik
    .accesskey = b

clear-cache-button =
    .label = Buang Sekarang
    .accesskey = B

fonts-legend = Fon & Warna

default-font-label =
    .value = Fon piawai:
    .accesskey = F

default-size-label =
    .value = Saiz:
    .accesskey = S

font-options-button =
    .label = Lanjutan…
    .accesskey = L

color-options-button =
    .label = Warna…
    .accesskey = W

display-width-legend = Mesej Teks Biasa

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Papar ikon emotif sebagai grafik
    .accesskey = e

display-text-label = Apabila memaparkan petikan mesej teks biasa:

style-label =
    .value = Gaya:
    .accesskey = y

regular-style-item =
    .label = Biasa
bold-style-item =
    .label = Tebal
italic-style-item =
    .label = Italik
bold-italic-style-item =
    .label = Italik Tebal

size-label =
    .value = Saiz:
    .accesskey = z

regular-size-item =
    .label = Biasa
bigger-size-item =
    .label = Lebih besar
smaller-size-item =
    .label = Lebih kecil

quoted-text-color =
    .label = Warna:
    .accesskey = n

search-input =
    .placeholder = Cari

type-column-label =
    .label = Jenis Kandungan
    .accesskey = J

action-column-label =
    .label = Tindakan
    .accesskey = T

save-to-label =
    .label = Simpan fail ke
    .accesskey = S

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Pilih…
           *[other] Cari…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] P
           *[other] C
        }

always-ask-label =
    .label = Sentiasa tanya saya lokasi untuk simpan fail
    .accesskey = S


display-tags-text = Tag boleh digunakan untuk mengelaskan dan mengutamakan mesej.

new-tag-button =
    .label = Baru…
    .accesskey = B

edit-tag-button =
    .label = Edit…
    .accesskey = E

delete-tag-button =
    .label = Buang
    .accesskey = B

auto-mark-as-read =
    .label = Tandakan mesej secara automatik sebagai sudah dibaca
    .accesskey = T

mark-read-no-delay =
    .label = Serta-merta apabila dipaparkan
    .accesskey = r

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Selepas dipaparkan selama
    .accesskey = d

seconds-label = saat

##

open-msg-label =
    .value = Buka mesej dalam:

open-msg-tab =
    .label = Tab baru
    .accesskey = b

open-msg-window =
    .label = Tetingkap mesej baru
    .accesskey = n

open-msg-ex-window =
    .label = Tetingkap mesej sedia ada
    .accesskey = e

close-move-delete =
    .label = Tutup tetingkap/tab mesej apabila dipindahkan atau dibuang
    .accesskey = T

condensed-addresses-label =
    .label = Papar nama paparan kenalan dalam buku alamat sahaja
    .accesskey = P

## Compose Tab

forward-label =
    .value = Mesej kirim semula:
    .accesskey = K

inline-label =
    .label = Sebaris

as-attachment-label =
    .label = Sebagai Lampiran

extension-label =
    .label = tambah ekstensi pada nama fail
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Auto Simpan setiap
    .accesskey = A

auto-save-end = minit

##

warn-on-send-accel-key =
    .label = Sahkan dahulu sebelum menghantar mesej apabila menggunakan pintasan papan kekunci
    .accesskey = S

spellcheck-label =
    .label = Semak ejaan sebelum hantar
    .accesskey = S

spellcheck-inline-label =
    .label = Aktifkan menyemak ejaan semasa menaip
    .accesskey = A

language-popup-label =
    .value = Bahasa:
    .accesskey = B

download-dictionaries-link = Muat turun Kamus Lain

font-label =
    .value = Fon:
    .accesskey = n

font-size-label =
    .value = Saiz:
    .accesskey = z

default-colors-label =
    .label = Guna warna piawai pembaca
    .accesskey = b

font-color-label =
    .value = Warna Teks:
    .accesskey = T

bg-color-label =
    .value = Warna Latar belakang:
    .accesskey = L

restore-html-label =
    .label = Pulih Piawai
    .accesskey = P

default-format-label =
    .label = Guna format Perenggan secara piawai, bukan Teks Kandungan
    .accesskey = P

format-description = Tetapkan tatalaku format teks

send-options-label =
    .label = Pilihan Hantar…
    .accesskey = H

autocomplete-description = Apabila mengalamatkan mesej, cari entri yang sepadan dalam:

ab-label =
    .label = Buku Alamat Lokal
    .accesskey = L

directories-label =
    .label = Pelayan Direktori:
    .accesskey = D

directories-none-label =
    .none = Tiada

edit-directories-label =
    .label = Edit Direktori…
    .accesskey = E

email-picker-label =
    .label = Tambah secara automatik alamat e-mel keluar ke:
    .accesskey = T

default-directory-label =
    .value = Direktori permulaan piawai dalam tetingkap buku alamat:
    .accesskey = D

default-last-label =
    .none = Direktori terkini digunakan

attachment-label =
    .label = Semak lampiran yang hilang
    .accesskey = m

attachment-options-label =
    .label = Kata kunci…
    .accesskey = K

enable-cloud-share =
    .label = Tawar berkongsi fail yang melebihi
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Tambah…
    .accesskey = T
    .defaultlabel = Tambah…

remove-cloud-account =
    .label = Buang
    .accesskey = B

cloud-account-description = Tambah perkhidmatan storan Filelink yang baru


## Privacy Tab

mail-content = Kandungan Mel

remote-content-label =
    .label = Izinkan kandungan jauh dalam mesej
    .accesskey = m

exceptions-button =
    .label = Pengecualian…
    .accesskey = P

remote-content-info =
    .value = Ketahui lebih lanjut perihal isu privasi kandungan jauh

web-content = Kandungan Web

history-label =
    .label = Ingat laman web dan pautan yang saya telah layari
    .accesskey = I

cookies-label =
    .label = Terima kuki dari laman
    .accesskey = T

third-party-label =
    .value = Terima kuki pihak ketiga:
    .accesskey = k

third-party-always =
    .label = Sentiasa
third-party-never =
    .label = Jangan sesekali
third-party-visited =
    .label = Daripada yang dilawati

keep-label =
    .value = Kekalkan sehingga:
    .accesskey = K

keep-expire =
    .label = luput
keep-close =
    .label = Saya tutup { -brand-short-name }
keep-ask =
    .label = sentiasa tanya saya

cookies-button =
    .label = Papar Kuki…
    .accesskey = P

passwords-description = { -brand-short-name } boleh mengingati kata laluan untuk semua akaun anda.

passwords-button =
    .label = Kata laluan Tersimpan…
    .accesskey = K

master-password-description = Kata laluan Induk melindungi semua kata laluan, tapi anda perlu masukkan sekali bagi setiap sesi.

master-password-label =
    .label = Guna kata laluan induk
    .accesskey = G

master-password-button =
    .label = Tukar Kata laluan Induk…
    .accesskey = T


junk-description = Tetapkan tetapan mel remeh piawai. Tetapan Akaun-khusus mel remeh boleh dibuat dalam Tetapan Akaun.

junk-label =
    .label = Apabila saya tandakan mesej sebagai remeh:
    .accesskey = A

junk-move-label =
    .label = Pindahkan ke dalam folder akaun "Mel Remeh"
    .accesskey = o

junk-delete-label =
    .label = Buang
    .accesskey = B

junk-read-label =
    .label = Mesej yang ditandakan Remeh sebagai telah dibaca
    .accesskey = M

junk-log-label =
    .label = Aktifkan log tapisan mel remeh boleh diubah
    .accesskey = A

junk-log-button =
    .label = Papar log
    .accesskey = P

reset-junk-button =
    .label = Mengeset semula Data Latihan
    .accesskey = M

phishing-description = { -brand-short-name } boleh menganalisa mesej yang disyaki penipuan e-mel dengan teknik lazim yang digunakan untuk memperdayakan anda.

phishing-label =
    .label = Maklumkan saya jika mesej yang sedang dibaca disyaki sebagai penipuan e-mel
    .accesskey = M

antivirus-description = { -brand-short-name } memudahkan perisian anti-virus menganalisa mesej mel masuk untuk mengimbas virus sebelum disimpan di dalam komputer.

antivirus-label =
    .label = Izinkan klien anti-virus untuk kuarantin mesej masuk individu
    .accesskey = I

certificate-description = Apabila pelayan meminta sijil peribadi saya:

certificate-auto =
    .label = Pilih satu secara automatik
    .accesskey = P

certificate-ask =
    .label = Sentiasa tanya saya
    .accesskey = S

ocsp-label =
    .label = Minta penggerak balas pelayan OCSP untuk mengesahkan kesahihan sijil semasa
    .accesskey = M

## Chat Tab

startup-label =
    .value = Apabila { -brand-short-name } bermula:
    .accesskey = b

offline-label =
    .label = Kekalkan Akaun Sembang di luar talian

auto-connect-label =
    .label = Sambung akaun sembang secara automatik

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Maklumkan kenalan bahawa saya melahu selepas
    .accesskey = M

idle-time-label = minit tanpa aktiviti

##

away-message-label =
    .label = dan tetapkan status ke Tiada dengan mesej:
    .accesskey = T

send-typing-label =
    .label = Hantar notifikasi menaip dalam perbualan
    .accesskey = t

notification-label = Apabila tiba mesej yang ditujukan kepada anda:

show-notification-label =
    .label = Papar notifikasi:
    .accesskey = s

notification-all =
    .label = dengan nama pengirim dan previu mesej
notification-name =
    .label = dengan nama pengirim sahaja
notification-empty =
    .label = tanpa sebarang info

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animasi ikon dok
           *[other] Pancar item bar tugasan
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] P
        }

chat-play-sound-label =
    .label = Mainkan bunyian
    .accesskey = i

chat-play-button =
    .label = Main
    .accesskey = M

chat-system-sound-label =
    .label = Bunyian sistem piawai untuk mel baru
    .accesskey = B

chat-custom-sound-label =
    .label = Gunakan fail bunyian berikut
    .accesskey = G

chat-browse-sound-button =
    .label = Cari…
    .accesskey = C

theme-label =
    .value = Tema:
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Buih
style-dark =
    .label = Gelap
style-paper =
    .label = Helaian Kertas
style-simple =
    .label = Ringkas

preview-label = Previu:
no-preview-label = Tiada previu tersedia
no-preview-description = Tema ini tidak sah atau tidak tersedia masa ini (add-on dinyahdayakan, mod selamat, …).

chat-variant-label =
    .value = Varian:
    .accesskey = V

chat-header-label =
    .label = Papar Pengepala
    .accesskey = P

## Preferences UI Search Results

