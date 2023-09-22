# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Batalkan Semua Unduhan?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Apabila Anda keluar sekarang, sebuah unduhan akan dibatalkan. Yakin ingin keluar?
       *[other] Apabila Anda keluar sekarang, { $downloadsCount } unduhan akan dibatalkan. Yakin ingin keluar?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Apabila Anda keluar sekarang, sebuah unduhan akan dibatalkan. Yakin ingin keluar?
       *[other] Apabila Anda keluar sekarang, { $downloadsCount } unduhan akan dibatalkan. Yakin ingin keluar?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] Jangan Keluar
       *[other] Jangan Keluar
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Apabila Anda keluar sekarang, sebuah unduhan akan dibatalkan. Yakin ingin keluar?
       *[other] Apabila Anda keluar sekarang, { $downloadsCount } unduhan akan dibatalkan. Yakin ingin keluar?
    }
download-ui-dont-go-offline-button = Tetap Daring

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Jika Anda menutup semua jendela pada Mode Penjelajahan Pribadi sekarang, 1 unduhan akan dibatalkan. Yakin akan meninggalkan Mode Penjelajahan Pribadi?
       *[other] Jika Anda menutup semua jendela pada Mode Penjelajahan Pribadi sekarang, { $downloadsCount } unduhan akan dibatalkan. Yakin akan meninggalkan Mode Penjelajahan Pribadi?
    }
download-ui-dont-leave-private-browsing-button = Tetap dalam Mode Penjelajahan Pribadi

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] Batalkan 1 Unduhan
       *[other] Batalkan { $downloadsCount } Unduhan
    }

##

download-ui-file-executable-security-warning-title = Buka Berkas Eksekutabel?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = "{ $executable }" adalah berkas eksekutabel. Berkas eksekutabel mungkin mengandung virus atau kode jahat lainnya yang dapat membahayakan komputer Anda. Berhati-hatilah saat membuka berkas ini. Yakin ingin menjalankan "{ $executable }"?
