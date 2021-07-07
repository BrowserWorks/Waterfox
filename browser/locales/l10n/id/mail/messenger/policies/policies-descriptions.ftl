# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Tetapkan kebijakan yang dapat diakses WebExtensions melalui chrome.storage.managed.

policy-AppAutoUpdate = Mengaktifkan atau menonaktifkan pembaruan aplikasi otomatis.

policy-AppUpdateURL = Tetapkan URL pemutakhiran aplikasi khusus

policy-Authentication = Konfigurasikan otentikasi terintegrasi untuk situs web yang mendukungnya.

policy-BlockAboutAddons = Blokir akses ke Pengelola Pengaya (about:addons).

policy-BlockAboutConfig = Blokir akses ke laman about:config.

policy-BlockAboutProfiles = Blokir akses ke laman about:profiles.

policy-BlockAboutSupport = Blokir akses ke laman about:support.

policy-CaptivePortal = Aktifkan atau nonaktifkan dukungan captive portal.

policy-CertificatesDescription = Tambahkan sertifikat atau gunakan sertifikat bawaan.

policy-Cookies = Izinkan atau tolak situs untuk menetapkan kuki.

policy-DisabledCiphers = Nonaktifkan ciphers.

policy-DefaultDownloadDirectory = Tetapkan direktori unduhan asal.

policy-DisableAppUpdate = Cegah { -brand-short-name } dari pembaruan.

policy-DisableDefaultClientAgent = Cegah agen klien tetap dari mengambil tindakan apa pun. Hanya berlaku untuk Windows; platform lain tidak memiliki agen.

policy-DisableDeveloperTools = Blokir akses ke alat pengembang.

policy-DisableFeedbackCommands = Nonaktifkan perintah untuk mengirim umpan balik dari menu Bantuan (Kirim Saran dan Laporkan Situs Tipuan).

policy-DisableForgetButton = Cegah akses ke tombol Lupakan.

policy-DisableFormHistory = Jangan ingat riwayat pencarian dan formulir.

policy-DisableMasterPasswordCreation = Jika ya, sandi utama tidak bisa dibuat.

policy-DisablePasswordReveal = Jangan izinkan untuk menampilkan sandi dalam info masuk yang tersimpan.

policy-DisableProfileImport = Nonaktifkan perintah menu untuk Mengimpor data dari aplikasi lain.

policy-DisableSafeMode = Nonaktifkan fitur untuk memulai kembali dalam Mode Aman. Catatan: tombol Shift untuk masuk ke Safe Mode hanya dapat dinonaktifkan pada Windows menggunakan Kebijakan Grup.

policy-DisableSecurityBypass = Mencegah pengguna melewati peringatan keamanan tertentu.

policy-DisableSystemAddonUpdate = Cegah { -brand-short-name } memasang dan memperbarui pengaya sistem.

policy-DisableTelemetry = Nonaktifkan Telemetry.

policy-DisplayMenuBar = Tampilkan Bilah Menu secara otomatis.

policy-DNSOverHTTPS = Konfigurasikan DNS lewat HTTPS.

policy-DontCheckDefaultClient = Nonaktifkan pemeriksaan untuk klien tetap pada saat penyalaan.

policy-DownloadDirectory = Atur dan kunci direktori unduhan.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Aktifkan atau nonaktifkan Pemblokiran Konten dan menguncinya secara opsional.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Aktifkan atau nonaktifkan Ekstensi Media Terenkripsi dan menguncinya secara opsional.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Pasang, copot pemasangan atau kunci ekstensi. Opsi Pemasangan mengambil URL atau jalur sebagai parameter. Opsi Pencopotan dan Penguncian mengambil ID ekstensi.

policy-ExtensionSettings = Kelola semua aspek pemasangan ekstensi.

policy-ExtensionUpdate = Aktifkan atau nonaktifkan pembaruan ekstensi otomatis.

policy-HardwareAcceleration = Jika salah, matikan akselerasi perangkat keras.

policy-InstallAddonsPermission = Izinkan situs tertentu untuk memasang pengaya.

policy-LegacyProfiles = Nonaktifkan fitur yang memberlakukan profil terpisah pada setiap pemasangan.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Aktifkan setelan baku perilaku lawas kuki SameSite

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Kembali ke perilaku SameSite lawas untuk kuki di situs yang telah ditentukan.

##

policy-LocalFileLinks = Izinkan situs web tertentu untuk bertaut dengan berkas lokal.

policy-NetworkPrediction = Aktifkan atau nonaktifkan prediksi jaringan (DNS prefetching).

policy-OfferToSaveLogins = Paksa setelan untuk mengizinkan { -brand-short-name } untuk menawarkan agar mengingat info masuk dan sandi yang disimpan. Nilai benar dan salah diterima.

policy-OfferToSaveLoginsDefault = Setel nilai tetap untuk mengizinkan { -brand-short-name } supaya menawarkan agar mengingat info masuk dan sandi yang disimpan. Nilai benar dan salah diterima.

policy-OverrideFirstRunPage = Timpa laman yang dijalankan pertama. Setel kebijakan ini menjadi kosong jika Anda ingin menonaktifkan laman yang dijalankan pertama.

policy-OverridePostUpdatePage = Timpa laman "Yang Baru" yang tampil setelah pembaruan. Setel kebijakan ini menjadi kosong jika ingin menonaktifkan laman setelah pembaruan.

policy-PasswordManagerEnabled = Aktifkan penyimpanan sandi melalui manajer sandi.

# PDF.js and PDF should not be translated
policy-PDFjs = Nonaktifkan atau atur konfigurasi PDF.js, penampil PDF bawaan di { -brand-short-name }.

policy-Permissions2 = Atur izin untuk kamera, mikrofon, lokasi, notifikasi, dan putar-otomatis.

policy-Preferences = Tetapkan dan kunci nilai untuk subset preferensi.

policy-PromptForDownloadLocation = Tanyakan di mana berkas disimpan saat mengunduh.

policy-Proxy = Atur setelan proksi.

policy-RequestedLocales = Atur daftar kode pelokalan yang diminta untuk aplikasi sesuai urutan.

policy-SanitizeOnShutdown2 = Bersihkan data navigasi saat dimatikan

policy-SearchEngines = Konfigurasikan setelan mesin pencari. Kebijakan ini hanya tersedia dalam versi Extended Support Release (ESR).

policy-SearchSuggestEnabled = Aktifkan atau nonaktifkan saran pencarian.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Pasang modul PKCS#11.

policy-SSLVersionMax = Tetapkan versi SSL maksimum.

policy-SSLVersionMin = Tetapkan versi SSL minimum.

policy-SupportMenu = Tambahkan item menu dukungan khusus pada menu bantuan.

policy-UserMessaging = Jangan tampilkan pesan tertentu kepada pengguna.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blokir situs web agar tidak dikunjungi. Lihat dokumentasi lebih lanjut untuk formatnya.
