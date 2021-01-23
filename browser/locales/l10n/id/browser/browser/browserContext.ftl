# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Tekan agak lama untuk menampilkan riwayat
           *[other] Klik kanan atau tekan agak lama untuk menampilkan riwayat
        }

## Back

main-context-menu-back =
    .tooltiptext = Mundur satu laman
    .aria-label = Mundur
    .accesskey = K

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Maju satu laman
    .aria-label = Maju
    .accesskey = M

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Muat Ulang
    .accesskey = U

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stop
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Simpan Laman dengan Nama…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Markahi Laman ini
    .accesskey = m
    .tooltiptext = Markahi laman ini

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Markahi Laman ini
    .accesskey = m
    .tooltiptext = Markahi laman ini ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Edit Markah Ini
    .accesskey = m
    .tooltiptext = Edit markah ini

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Edit Markah Ini
    .accesskey = m
    .tooltiptext = Edit markah ini ({ $shortcut })

main-context-menu-open-link =
    .label = Buka Tautan
    .accesskey = a

main-context-menu-open-link-new-tab =
    .label = Buka Tautan di Tab Baru
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = Buka Tautan dalam Tab Kontainer Baru
    .accesskey = k

main-context-menu-open-link-new-window =
    .label = Buka Tautan di Jendela Baru
    .accesskey = J

main-context-menu-open-link-new-private-window =
    .label = Buka Tautan di Jendela Mode Penjelajahan Pribadi Baru
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = Markahi Tautan Ini
    .accesskey = T

main-context-menu-save-link =
    .label = Simpan Tautan dengan Nama…
    .accesskey = T

main-context-menu-save-link-to-pocket =
    .label = Simpan Tautan ke { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Salin Alamat Surel
    .accesskey = E

main-context-menu-copy-link =
    .label = Salin Lokasi Tautan
    .accesskey = S

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Mainkan
    .accesskey = M

main-context-menu-media-pause =
    .label = Tunda
    .accesskey = T

##

main-context-menu-media-mute =
    .label = Senyap
    .accesskey = S

main-context-menu-media-unmute =
    .label = Keraskan
    .accesskey = K

main-context-menu-media-play-speed =
    .label = Kecepatan Pemutaran
    .accesskey = K

main-context-menu-media-play-speed-slow =
    .label = Lambat (0.5 ×)
    .accesskey = L

main-context-menu-media-play-speed-normal =
    .label = Normal
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Cepat (1.25 ×)
    .accesskey = C

main-context-menu-media-play-speed-faster =
    .label = Lebih Cepat (1.5×)
    .accesskey = p

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Sangat Cepat (2×)
    .accesskey = t

main-context-menu-media-loop =
    .label = Pengulangan
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Tampilkan Kendali
    .accesskey = T

main-context-menu-media-hide-controls =
    .label = Sembunyikan Kendali
    .accesskey = S

##

main-context-menu-media-video-fullscreen =
    .label = Layar Penuh
    .accesskey = P

main-context-menu-media-video-leave-fullscreen =
    .label = Keluar dari Mode Layar Penuh
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Gambar-dalam-gambar
    .accesskey = g

main-context-menu-image-reload =
    .label = Muat Ulang Gambar
    .accesskey = U

main-context-menu-image-view =
    .label = Lihat Gambar
    .accesskey = G

main-context-menu-video-view =
    .label = Tampilkan Video
    .accesskey = V

main-context-menu-image-copy =
    .label = Salin Gambar
    .accesskey = G

main-context-menu-image-copy-location =
    .label = Salin Lokasi Gambar
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Salin Lokasi Video
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Salin Lokasi Audio
    .accesskey = o

main-context-menu-image-save-as =
    .label = Simpan Gambar dengan Nama…
    .accesskey = a

main-context-menu-image-email =
    .label = Surelkan Gambar…
    .accesskey = k

main-context-menu-image-set-as-background =
    .label = Jadikan sebagai Latar Belakang Desktop…
    .accesskey = D

main-context-menu-image-info =
    .label = Lihat Informasi Gambar
    .accesskey = m

main-context-menu-image-desc =
    .label = Tampilkan Deskripsi
    .accesskey = D

main-context-menu-video-save-as =
    .label = Simpan Video dengan Nama…
    .accesskey = S

main-context-menu-audio-save-as =
    .label = Simpan Audio dengan Nama…
    .accesskey = S

main-context-menu-video-image-save-as =
    .label = Simpan Cuplikan dengan Nama…
    .accesskey = S

main-context-menu-video-email =
    .label = Surelkan Video…
    .accesskey = k

main-context-menu-audio-email =
    .label = Surelkan Audio…
    .accesskey = k

main-context-menu-plugin-play =
    .label = Aktifkan plugin ini
    .accesskey = p

main-context-menu-plugin-hide =
    .label = Sembunyikan plugin ini
    .accesskey = y

main-context-menu-save-to-pocket =
    .label = Simpan Laman ke { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Kirim Laman ke Perangkat
    .accesskey = L

main-context-menu-view-background-image =
    .label = Lihat Gambar Latar Belakang
    .accesskey = L

main-context-menu-generate-new-password =
    .label = Gunakan Sandi yang Dihasilkan
    .accesskey = D

main-context-menu-keyword =
    .label = Tambahkan Kata Kunci untuk Pencarian ini…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = Kirim Tautan ke Perangkat
    .accesskey = T

main-context-menu-frame =
    .label = Bingkai Ini
    .accesskey = B

main-context-menu-frame-show-this =
    .label = Hanya Tampilkan Bingkai yang Ini
    .accesskey = n

main-context-menu-frame-open-tab =
    .label = Buka Bingkai di Tab Baru
    .accesskey = g

main-context-menu-frame-open-window =
    .label = Buka Bingkai di Jendela Baru
    .accesskey = i

main-context-menu-frame-reload =
    .label = Muatkan Bingkai Lagi
    .accesskey = t

main-context-menu-frame-bookmark =
    .label = Markahi Bingkai Ini
    .accesskey = B

main-context-menu-frame-save-as =
    .label = Simpan Bingkai dengan Nama…
    .accesskey = g

main-context-menu-frame-print =
    .label = Cetak Bingkai…
    .accesskey = i

main-context-menu-frame-view-source =
    .label = Lihat Kode Sumber Bingkai
    .accesskey = B

main-context-menu-frame-view-info =
    .label = Lihat Informasi Bingkai
    .accesskey = I

main-context-menu-view-selection-source =
    .label = Lihat Kode Sumber Teks yang Dipilih
    .accesskey = e

main-context-menu-view-page-source =
    .label = Lihat Kode Sumber Laman
    .accesskey = h

main-context-menu-view-page-info =
    .label = Lihat Informasi Laman
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = Ubah Arah Teks
    .accesskey = T

main-context-menu-bidi-switch-page =
    .label = Ubah Arah Laman
    .accesskey = A

main-context-menu-inspect-element =
    .label = Inspeksi Elemen
    .accesskey = n

main-context-menu-inspect-a11y-properties =
    .label = Periksa Properti Aksesibilitas

main-context-menu-eme-learn-more =
    .label = Pelajari lebih lanjut tentang DRM…
    .accesskey = D

