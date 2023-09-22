# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } telah mencegah situs ini untuk memasang perangkat lunak di komputer Anda.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = Izinkan { $host } untuk memasang pengaya?
xpinstall-prompt-message = Anda akan memasang pengaya dari { $host }. Pastikan Anda mempercayai situs ini sebelum melanjutkan.

##

xpinstall-prompt-header-unknown = Izinkan situs yang tidak dikenal memasang pengaya?
xpinstall-prompt-message-unknown = Anda akan memasang pengaya dari situs yang tidak dikenal. Pastikan Anda mempercayai situs ini sebelum melanjutkan.
xpinstall-prompt-dont-allow =
    .label = Jangan Izinkan
    .accesskey = J
xpinstall-prompt-never-allow =
    .label = Jangan Pernah Izinkan
    .accesskey = N
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Laporkan Situs Yang Mencurigakan
    .accesskey = L
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Lanjut ke Pemasangan
    .accesskey = L

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Situs ini meminta akses ke perangkat MIDI (Musical Instrument Digital Interface) Anda. Akses perangkat dapat diaktifkan dengan memasang pengaya.
site-permission-install-first-prompt-midi-message = Akses ini tidak dijamin aman. Lanjutkan jika Anda mempercayai situs ini.

##

xpinstall-disabled-locked = Pilihan pemasangan perangkat lunak telah dinonaktifkan administrator sistem Anda.
xpinstall-disabled = Pemasangan perangkat lunak sedang dinonaktifkan. Klik Aktifkan dan coba lagi.
xpinstall-disabled-button =
    .label = Aktifkan
    .accesskey = f
# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) diblokir oleh administrator sistem Anda.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = Administrator sistem Anda mencegah situs ini meminta Anda untuk memasang perangkat lunak di komputer Anda.
addon-install-full-screen-blocked = Instalasi pengaya tidak diizinkan saat sebelum memasuki atau berada dalam mode layar penuh.
# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } ditambahkan pada { -brand-short-name }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } memerlukan izin baru
# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = Selesaikan pemasangan ekstensi yang diimpor ke { -brand-short-name }

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = Hapus { $name }?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = Hapus { $name } dari { -brand-shorter-name }?
addon-removal-button = Hapus
addon-removal-abuse-report-checkbox = Laporkan ekstensi ini ke { -vendor-short-name }
# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying = Mengunduh dan memverifikasi { $addonCount } pengaya…
addon-download-verifying = Memverifikasi
addon-install-cancel-button =
    .label = Batal
    .accesskey = B
addon-install-accept-button =
    .label = Tambahkan
    .accesskey = T

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message = Situs ini ingin menginstal { $addonCount } pengaya di { -brand-short-name }:
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [1] Perhatian: Situs ini ingin menginstal { $addonCount } pengaya tidak terverifikasi di { -brand-short-name }. Jika melanjutkan, risiko ditanggung sendiri.
       *[other] Perhatian: Situs ini ingin menginstal { $addonCount } pengaya tidak terverifikasi di { -brand-short-name }. Jika melanjutkan, risiko ditanggung sendiri.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = Perhatian: Situs ini ingin menginstal { $addonCount } pengaya di { -brand-short-name }, beberapa diantaranya tidak terverifikasi. Jika melanjutkan, risiko ditanggung sendiri.

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = Pengaya tidak dapat diunduh karena kegagalan sambungan.
addon-install-error-incorrect-hash = Pengaya tidak dapat dipasang karena tidak cocok dengan yang diharapkan { -brand-short-name }.
addon-install-error-corrupt-file = Pengaya yang diunduh dari situs ini tidak dapat dipasang karena rusak.
addon-install-error-file-access = { $addonName } tidak dapat dipasang karena { -brand-short-name } tidak dapat mengubah berkas yang dibutuhkan.
addon-install-error-not-signed = { -brand-short-name } telah mencegah situs ini untuk menginstal pengaya yang belum diverifikasi.
addon-install-error-invalid-domain = Pengaya { $addonName } tidak dapat dipasang dari lokasi ini.
addon-local-install-error-network-failure = Pengaya ini tidak dapat dipasang karena ada kesalahan pada sistem berkas.
addon-local-install-error-incorrect-hash = Pengaya ini tidak dapat dipasang karena tidak cocok dengan yang diharapkan { -brand-short-name }.
addon-local-install-error-corrupt-file = Pengaya ini tidak dapat dipasang karena tampaknya berkasnya rusak.
addon-local-install-error-file-access = { $addonName } tidak dapat dipasang karena { -brand-short-name } tidak dapat mengubah berkas yang dibutuhkan.
addon-local-install-error-not-signed = Pengaya ini tidak dapat dipasang karena belum diverifikasi.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = { $addonName } tidak dapat dipasang karena tidak kompatibel dengan { -brand-short-name } { $appVersion }.
addon-install-error-blocklisted = { $addonName } tidak dapat dipasang karena berisiko tinggi untuk menyebabkan masalah stabilitas dan keamanan.
