# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Headers used in the webextension permissions dialog,
## See https://bug1308309.bmoattachments.org/attachment.cgi?id=8814612
## for an example of the full dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension.

webext-perms-header = Tambahkan { $extension }?
webext-perms-header-with-perms = Tambahkan { $extension }? Ekstensi ini akan memiliki izin untuk:
webext-perms-header-unsigned = Tambahkan { $extension }? Ekstensi ini tidak diverifikasi. Ekstensi berbahaya dapat mencuri informasi pribadi Anda atau membahayakan komputer Anda. Hanya tambahkan ekstensi ini jika Anda percaya sumbernya.
webext-perms-header-unsigned-with-perms = Tambahkan { $extension }? Ekstensi ini tidak diverifikasi. Ekstensi berbahaya dapat mencuri informasi pribadi Anda atau membahayakan komputer Anda. Hanya tambahkan ekstensi ini jika Anda percaya sumbernya. Ekstensi ini akan memiliki izin untuk:
webext-perms-sideload-header = { $extension } ditambahkan
webext-perms-optional-perms-header = { $extension } meminta izin tambahan.

##

webext-perms-add =
    .label = Tambahkan
    .accesskey = T
webext-perms-cancel =
    .label = Batal
    .accesskey = B

webext-perms-sideload-text = Program lain pada komputer Anda memasang pengaya yang mungkin mempengaruhi peramban Anda. Harap tinjau permintaan izin dari pengaya ini dan pilih Aktifkan atau Batal (untuk membuatnya nonaktif).
webext-perms-sideload-text-no-perms = Program lain pada komputer Anda telah memasang pengaya yang dapat mempengaruhi peramban Anda. Silakan pilih untuk Aktifkan atau Batal (untuk membuatnya tetap nonaktif).
webext-perms-sideload-enable =
    .label = Aktifkan
    .accesskey = A
webext-perms-sideload-cancel =
    .label = Batal
    .accesskey = B

# Variables:
#   $extension (String): replaced with the localized name of the extension.
webext-perms-update-text = { $extension } telah diperbarui. Anda harus menyetujui izin barunya sebelum dapat memasang versi terbaru. Dengan memilih “Batal” maka ekstensi versi Anda saat ini akan dipertahankan. Ektstensi ini akan memiliki izin untuk:
webext-perms-update-accept =
    .label = Perbarui
    .accesskey = P

webext-perms-optional-perms-list-intro = Pengaya ingin:
webext-perms-optional-perms-allow =
    .label = Izinkan
    .accesskey = I
webext-perms-optional-perms-deny =
    .label = Tolak
    .accesskey = T

webext-perms-host-description-all-urls = Mengakses data Anda pada semua situs

# Variables:
#   $domain (String): will be replaced by the DNS domain for which a webextension is requesting access (e.g., mozilla.org)
webext-perms-host-description-wildcard = Mengakses data Anda untuk situs pada domain { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-wildcards = Mengakses data Anda pada { $domainCount } domain lainnya
# Variables:
#   $domain (String): will be replaced by the DNS host name for which a webextension is requesting access (e.g., www.mozilla.org)
webext-perms-host-description-one-site = Mengakses data Anda pada { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-sites = Mengakses data Anda pada { $domainCount } situs lainnya

## Headers used in the webextension permissions dialog for synthetic add-ons.
## The part of the string describing what privileges the extension gives should be consistent
## with the value of webext-site-perms-description-gated-perms-{sitePermission}.
## Note, this string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $hostname (String): the hostname of the site the add-on is being installed from.

webext-site-perms-header-with-gated-perms-midi = Pengaya ini memberikan akses kepada { $hostname } ke perangkat MIDI Anda.
webext-site-perms-header-with-gated-perms-midi-sysex = Pengaya ini memberikan akses kepada { $hostname } ke perangkat MIDI Anda (dengan dukungan SysEx).

##


## Headers used in the webextension permissions dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension being installed.
##   $hostname (String): will be replaced by the DNS host name for which a webextension enables permissions.

webext-site-perms-header-with-perms = Tambahkan { $extension }? Ekstensi ini memberikan kemampuan berikut untuk { $hostname }:
webext-site-perms-header-unsigned-with-perms = Tambahkan { $extension }? Ekstensi ini belum diverifikasi. Ekstensi yang berbahaya dapat mencuri informasi pribadi Anda atau membahayakan komputer Anda. Hanya tambahkan jika Anda mempercayai sumbernya. Ekstensi ini memberikan kemampuan berikut untuk { $hostname }:

## These should remain in sync with permissions.NAME.label in sitePermissions.properties

webext-site-perms-midi = Akses perangkat MIDI
webext-site-perms-midi-sysex = Akses perangkat MIDI dengan dukungan SysEx
