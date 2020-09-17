# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-AppUpdateURL = Tetapkan aplikasi penyesuaian kemaskini URL.

policy-Authentication = Konfigurasi pengesahan bersepadu untuk laman web yang menyokongnya.

policy-BlockAboutAddons = Sekat akses ke Pengurus Add-ons (about: addons).

policy-BlockAboutConfig = Sekat akses ke halaman about:config.

policy-BlockAboutProfiles = Sekat akses ke halaman about:profiles.

policy-BlockAboutSupport = Sekat akses ke halaman about:support.

policy-Bookmarks = Cipta tandabuku dalam bar alatan Tandabuku, menu Tandabuku atau folder khusus di dalamnya.

policy-CertificatesDescription = Tambah sijil atau gunakan sijil terbina dalam.

policy-Cookies = Izinkan atau tidak laman web menetapkan kuki.

policy-DisableAppUpdate = Halang pelayar daripada mengemaskini.

policy-DisableBuiltinPDFViewer = Nyahdayakan PDF.js, pemapar PDF terbina-dalam { -brand-short-name }.

policy-DisableDeveloperTools = Sekat akses ke alatan pembangun.

policy-DisableFeedbackCommands = Nyahdayakan perintah untuk menghantar maklum balas daripada menu Bantuan (Hantar Maklum balas dan Laporkan Laman Mengelirukan).

policy-DisableFirefoxAccounts = Nyahdayakan perkhidmatan asas { -fxaccount-brand-name }, termasuk Sync.

# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Nyahdayakan ciri Firefox Screenshots.

policy-DisableFirefoxStudies = Halang { -brand-short-name } melaksanakan kajian.

policy-DisableForgetButton = Halang akses ke butang Lupa.

policy-DisableFormHistory = Jangan ingat sejarah carian dan borang.

policy-DisableMasterPasswordCreation = Jika true, kata laluan induk tidak boleh dicipta.

policy-DisablePocket = Nyahdayakan ciri untuk menyimpan laman web ke Pocket.

policy-DisablePrivateBrowsing = Nyahdayakan Pelayaran Peribadi.

policy-DisableProfileImport = Nyahdayakan menu perintah untuk mengimport data daripada pelayar lain.

policy-DisableProfileRefresh = Nyahdayakan butang Muat semula  { -brand-short-name } dalam halaman about:support.

policy-DisableSafeMode = Nyahdayakan ciri Mula semula dalam Mod Selamat. Nota: kekunci Shift untuk memasuki Mod Selamat hanya boleh dinyahdayakan dalam Windows menggunakan Polisi Kumpulan.

policy-DisableSecurityBypass = Halang pengguna daripada memintas amaran keselamatan tertentu.

policy-DisableSetAsDesktopBackground = Nyahdayakan perintah menu Tetapkan sebagai Latar belakang Desktop untuk imej.

policy-DisableSystemAddonUpdate = Halang pelayar daripada memasang dan mengemaskini sistem add-ons.

policy-DisableTelemetry = Nyahaktifkan Telemetry.

policy-DisplayBookmarksToolbar = Papar Bar alatan Tandabuku secara piawai.

policy-DisplayMenuBar = Papar Bar Menu secara piawai.

policy-DNSOverHTTPS = Konfigurasi DNS mengatasi HTTPS

policy-DontCheckDefaultBrowser = Nyahdayakan pilihan untuk pelayar piawai pada permulaan.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Dayakan atau Nyahdayakan Sekatan Kandungan dan pilihan untuk menguncinya.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs. See also:
# https://github.com/mozilla/policy-templates/blob/master/README.md#extensions-machine-only
policy-Extensions = Pasang, nyahpasang atau kunci ekstensi. Pilihan Pasang menggunakan URL atau laluan sebagai parameter. Pilihan Nyahpasang dan Dikunci menggunakan ID ekstensi.

policy-FlashPlugin = Izinkan atau tidak penggunaan plugin Flash.

policy-HardwareAcceleration = Jika false, nyahaktifkan pecutan perkakasan.

# “lock” means that the user won’t be able to change this setting
policy-Homepage = Tetapkan dan pilihan mengunci Laman.

policy-InstallAddonsPermission = Izinkan laman web tertentu untuk memasang add-ons.

## Do not translate "SameSite", it's the name of a cookie attribute.

##

policy-NoDefaultBookmarks = Nyahdayakan penciptaan tandabuku piawai yang disertakan dengan { -brand-short-name }, dan Tandabuku Pintar (Paling Dilawati, Tag Terkini). Nota: polisi ini hanya berkesan jika digunakan sebelum profil pertama dilaksanakan.

policy-OfferToSaveLogins = Kuatkuasakan tatacara untuk mengizinkan { -brand-short-name } mengingatkan log masuk dan kata laluan yang disimpan. Kedua-dua nilai true dan false akan diterima.

policy-OverrideFirstRunPage = Tulis ganti halaman pelaksanaan pertama. Tetapkan polisi ini ke kosong jika anda mahu menyahdayakan halaman pelaksanaan pertama.

policy-OverridePostUpdatePage = Tulis ganti halaman selepas-kemaskini "What's New". Tetapkan polisi ini ke kosong jika anda mahu menyahdayakan halaman selepas-kemaskini.

policy-PopupBlocking = Izinkan laman web tertentu untuk memaparkan popups secara piawai.

policy-Proxy = Konfigurasi tetapan proksi.

policy-RequestedLocales = Tetapkan senarai lokaliti aplikasi yang diminta mengikut turutan keutamaan.

policy-SearchBar = Tetapkan lokasi piawai bar carian. Pengguna masih boleh menyesuaikannya.

policy-SearchEngines = Konfigurasi tetapan enjin carian. Polisi ini hanya boleh didapati dalam versi Extended Support Release (ESR).

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Pasang modul PKCS #11.

# “format” refers to the format used for the value of this policy. See also:
# https://github.com/mozilla/policy-templates/blob/master/README.md#websitefilter-machine-only
policy-WebsiteFilter = Sekat laman web daripada dilawati. Lihat dokumentasi untuk maklumat lanjut format berkenaan.
