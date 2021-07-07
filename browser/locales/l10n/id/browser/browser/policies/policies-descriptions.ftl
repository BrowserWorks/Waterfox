# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Tetapkan kebijakan yang dapat diakses WebExtensions melalui chrome.storage.managed.
policy-AllowedDomainsForApps = Tentukan domain yang diizinkan untuk mengakses Google Workspace.
policy-AppAutoUpdate = Aktifkan atau nonaktifkan pembaruan aplikasi otomatis.
policy-AppUpdateURL = Atur URL pemutakhiran aplikasi khusus
policy-Authentication = Atur autentikasi terintegrasi untuk situs lain yang mendukung.
policy-AutoLaunchProtocolsFromOrigins = Menentukan daftar protokol eksternal yang dapat digunakan dari asal-usul terdaftar tanpa bertanya pada pengguna.
policy-BackgroundAppUpdate2 = Aktifkan atau nonaktifkan pembaruan latar belakang.
policy-BlockAboutAddons = Blokir akses ke Pengelola Pengaya (about:addons).
policy-BlockAboutConfig = Blokir akses ke laman about:config.
policy-BlockAboutProfiles = Blokir akses ke laman about:profiles.
policy-BlockAboutSupport = Blokir akses ke laman about:support.
policy-Bookmarks = Buat markah pada bilah alat Markah, menu Markah, atau folder tertentu yang ada di dalamnya.
policy-CaptivePortal = Aktifkan atau nonaktifkan dukungan captive portal.
policy-CertificatesDescription = Tambahkan sertifikat atau gunakan sertifikat bawaan.
policy-Cookies = Izinkan atau tolak situs untuk menyetel kuki.
policy-DisabledCiphers = Nonaktifkan ciphers.
policy-DefaultDownloadDirectory = Atur direktori unduhan baku.
policy-DisableAppUpdate = Cegah peramban untuk memperbarui.
policy-DisableBuiltinPDFViewer = Nonaktifkan PDF.js, penampil PDF bawaan di { -brand-short-name }.
policy-DisableDefaultBrowserAgent = Cegah agen bawaan peramban untuk melakukan tindakan apapun. Hanya berlaku di Windows; platform lain tidak memiliki agen.
policy-DisableDeveloperTools = Blokir akses ke alat pengembang.
policy-DisableFeedbackCommands = Nonaktifkan perintah untuk mengirim umpan balik dari menu Bantuan (Kirim Saran dan Laporkan Situs Tipuan).
policy-DisableFirefoxAccounts = Nonaktifkan layanan berbasis { -fxaccount-brand-name }, termasuk Sync.
# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Nonaktifkan fitur Firefox Screenshots.
policy-DisableFirefoxStudies = Cegah { -brand-short-name } menjalankan kajian.
policy-DisableForgetButton = Cegah akses ke tombol Lupakan.
policy-DisableFormHistory = Jangan ingat riwayat pencarian dan formulir.
policy-DisableMasterPasswordCreation = Jika ya, sandi utama tidak bisa dibuat.
policy-DisablePrimaryPasswordCreation = Jika ya, Sandi Utama tidak bisa dibuat.
policy-DisablePasswordReveal = Jangan izinkan untuk menampilkan kata sandi dalam info masuk tersimpan.
policy-DisablePocket = Nonaktifkan fitur untuk menyimpan laman web ke Pocket.
policy-DisablePrivateBrowsing = Nonaktifkan Penjelajahan Pribadi.
policy-DisableProfileImport = Nonaktifkan perintah menu untuk mengimpor data dari peramban lainnya.
policy-DisableProfileRefresh = Nonaktifkan tombol Segarkan { -brand-short-name } di laman about:support.
policy-DisableSafeMode = Nonaktifkan fitur untuk memulai ulang di Mode Aman. Catatan: Tombol Shift untuk masuk ke Mode Aman hanya dapat dinonaktifkan pada Windows menggunakan Kebijakan Grup.
policy-DisableSecurityBypass = Mencegah pengguna melewati peringatan keamanan tertentu.
policy-DisableSetAsDesktopBackground = Nonaktifkan perintah menu Jadikan sebagai Latar Belakang Desktop untuk gambar.
policy-DisableSystemAddonUpdate = Mencegah peramban memasang dan memperbarui pengaya sistem.
policy-DisableTelemetry = Nonaktifkan Telemetry.
policy-DisplayBookmarksToolbar = Tampilkan Bilah Markah secara baku.
policy-DisplayMenuBar = Tampilkan Bilah Menu secara otomatis.
policy-DNSOverHTTPS = Konfigurasikan DNS lewat HTTPS.
policy-DontCheckDefaultBrowser = Nonaktifkan pemeriksaan untuk peramban bawaan saat memulai.
policy-DownloadDirectory = Atur dan kunci direktori unduhan.
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Aktifkan atau nonaktifkan Pemblokiran Konten dan kunci ia secara opsional.
# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Aktifkan atau nonaktifkan Ekstensi Media Terenkripsi dan kunci dia secara opsional.
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Memasang, mencopot, atau mengunci ekstensi. Opsi Memasang membutuhkan parameter URL atau jalur. Opsi Mencopot dan Mengunci membutuhkan ID ekstensi.
policy-ExtensionSettings = Kelola semua aspek pemasangan ekstensi.
policy-ExtensionUpdate = Aktifkan atau nonaktifkan pembaruan ekstensi otomatis.
policy-FirefoxHome = Atur Firefox Home.
policy-FlashPlugin = Izinkan atau tolak penggunaan plugin Flash.
policy-Handlers = Konfigurasikan penanganan aplikasi baku.
policy-HardwareAcceleration = Jika bernilai false, menonaktifkan akselerasi perangkat keras.
# “lock” means that the user won’t be able to change this setting
policy-Homepage = Mengatur dan mengunci halaman beranda secara opsional.
policy-InstallAddonsPermission = Izinkan situs tertentu untuk memasang pengaya.
policy-LegacyProfiles = Nonaktifkan fitur yang memberlakukan profil terpisah pada setiap pemasangan.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Aktifkan setelan perilaku kuki SameSite lama baku
policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Kembalikan ke perilaku baku SameSite untuk kuki pada situs tertentu.

##

policy-LocalFileLinks = Izinkan situs web tertentu untuk bertaut dengan berkas lokal.
policy-ManagedBookmarks = Mengonfigurasi daftar markah yang dikelola oleh administrator yang tidak dapat diubah oleh pengguna.
policy-MasterPassword = Membutuhkan atau mencegah penggunaan kata sandi utama.
policy-ManualAppUpdateOnly = Izinkan pembaruan manual saja dan jangan beri tahu pengguna tentang pembaruan.
policy-PrimaryPassword = Membutuhkan atau mencegah penggunaan Sandi Utama.
policy-NetworkPrediction = Aktifkan atau nonaktifkan prediksi jaringan (DNS prefetching).
policy-NewTabPage = Aktifkan atau nonaktifkan laman Tab Baru.
policy-NoDefaultBookmarks = Nonaktifkan pembuatan markah default yang dibundel dengan { -brand-short-name } serta Markah Cerdas (Sering Mampir, Tag Terbaru). Catatan: kebijakan ini hanya efektif jika digunakan sebelum menjalankan profil pertama.
policy-OfferToSaveLogins = Paksa setelan untuk mengizinkan { -brand-short-name } untuk menawarkan agar mengingat info masuk dan kata sandi yang disimpan. Nilai true dan false diterima.
policy-OfferToSaveLoginsDefault = Setel nilai default untuk mengizinkan { -brand-short-name } untuk menawarkan agar mengingat info masuk dan kata sandi yang disimpan. Nilai true dan false diterima.
policy-OverrideFirstRunPage = Ganti laman pertama yang dibuka. Setel kebijakan ini menjadi kosong jika ingin menonaktifkan laman pertama yang dibuka.
policy-OverridePostUpdatePage = Ganti laman "Yang Baru" yang tampil setelah pembaruan. Setel kebijakan ini menjadi kosong jika ingin menonaktifkan laman setelah pembaruan.
policy-PasswordManagerEnabled = Aktifkan penyimpanan sandi melalui manajer sandi.
# PDF.js and PDF should not be translated
policy-PDFjs = Nonaktifkan atau atur konfigurasi PDF.js, penampil PDF bawaan di { -brand-short-name }.
policy-Permissions2 = Atur izin untuk kamera, mikrofon, lokasi, notifikasi, dan putar-otomatis.
policy-PictureInPicture = Aktifkan atau nonaktifkan Picture-in-Picture.
policy-PopupBlocking = Izinkan situs tertentu untuk menampilkan pop-up secara otomatis.
policy-Preferences = Tetapkan dan kunci nilai untuk subset preferensi.
policy-PromptForDownloadLocation = Tanyakan di mana berkas disimpan saat mengunduh.
policy-Proxy = Atur setelan proxy.
policy-RequestedLocales = Atur daftar kode pelokalan yang diminta untuk aplikasi sesuai urutan.
policy-SanitizeOnShutdown2 = Bersihkan data navigasi saat dimatikan
policy-SearchBar = Setel lokasi bawaan untuk bilah pencarian. Pengguna masih diizinkan untuk mengubahsuainya.
policy-SearchEngines = Konfigurasikan setelan mesin pencari. Kebijakan ini hanya tersedia dalam versi Extended Support Release (ESR).
policy-SearchSuggestEnabled = Aktifkan atau nonaktifkan saran pencarian.
# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Pasang modul PKCS #11.
policy-ShowHomeButton = Tampilkan tombol beranda pada bilah alat.
policy-SSLVersionMax = Tetapkan versi SSL maksimum.
policy-SSLVersionMin = Tetapkan versi SSL minimum.
policy-SupportMenu = Tambahkan item menu dukungan khusus pada menu bantuan.
policy-UserMessaging = Jangan tampilkan pesan tertentu kepada pengguna.
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blokir situs web agar tidak dikunjungi. Lihat dokumentasi lebih lanjut untuk formatnya.
