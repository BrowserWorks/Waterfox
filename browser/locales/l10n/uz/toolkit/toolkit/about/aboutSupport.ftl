# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Nosozliklarni to‘g‘rilash ma’lumoti
page-subtitle = Bu sahifa muammolarni hal qilishingizda foydasi tegishi mumkin bo‘lgan  texnik ma’lumotlarga ega. Agar siz { -brand-short-name } haqida umumiy savollarga javob izlayotgan bo‘lsangiz, bizning <a data-l10n-name="support-link">yordam saytimiz</a>nitekshirib ko‘ring.

crashes-title = Nosozlik ma’lumotlari
crashes-id = Hisobot xos raqami
crashes-send-date = Jo‘natildi
crashes-all-reports = Barcha nosozlik ma’lumotlari
crashes-no-config = Ushbu ilova dastur nosozlik ma’lumotlarini ko‘rsatish uchun moslanmagan.
extensions-title = Kengaytmalar
extensions-name = Nomi
extensions-enabled = Yoqib qo‘yilgan
extensions-version = Versiyasi
extensions-id = ID
support-addons-name = Nomi
support-addons-version = Versiyasi
support-addons-id = ID
app-basics-title = Ilova dastur asoslari
app-basics-name = Nomi
app-basics-version = Versiyasi
app-basics-build-id = Tuzilma ID raqami
app-basics-update-channel = Yangilash kanali
app-basics-update-history = Yangilash tarixi
app-basics-show-update-history = Yangilash tarixini ko‘rsatish
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Profil direktoriyasi
       *[other] Profil jildi
    }
app-basics-enabled-plugins = Yoqilgan plaginlar
app-basics-build-config = Tuzish konfiguratsiyasi
app-basics-user-agent = Foydalanuvchi agent
app-basics-os = OT
app-basics-memory-use = Foydalanilgan xotira
app-basics-performance = Samaradorlik
app-basics-service-workers = Ro‘yxatdan o‘tgan Service Workers
app-basics-profiles = Profillar
app-basics-multi-process-support = Multijarayon oynalari
app-basics-safe-mode = Xavfsiz rejim
modified-key-prefs-title = Muhim o‘zgartirilgan moslamalar
modified-prefs-name = Nomi
modified-prefs-value = Qiymati
user-js-title = user.js parametrlari
user-js-description = Profil direktoriyangizda <a data-l10n-name="user-js-link">user.js file</a> mavjud, unga { -brand-short-name } tomonidan yaratilmagan parametrlar qo‘shilgan.
locked-key-prefs-title = Muhim o‘zgartirilgan parametrlar
locked-prefs-name = Nomi
locked-prefs-value = Qiymati
graphics-title = Grafika
graphics-features-title = Imkoniyatlar
graphics-diagnostics-title = Diagnostika
graphics-failure-log-title = Xato ma’lumoti
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Qaror ma’lumoti
graphics-crash-guards-title = Nosozlik soqchisini o‘chirish xususiyatlari
graphics-workarounds-title = Aylanma yo‘llar
place-database-title = Ma’lumotlar bazasi joylashgan o‘rinlari
place-database-integrity = Butunlik
place-database-verify-integrity = Butunligini tekshirish
a11y-title = Qulaylik
a11y-activated = Faollashtirilgan
a11y-force-disabled = Qulaylikni namoyish qilish
library-version-title = Kutubxona versiyasi
copy-text-to-clipboard-label = Matndan nusxa olish
copy-raw-data-to-clipboard-label = Manba ma’lumotlarni vaqtinchalik xotiraga nusxa olish
sandbox-title = Sandbox
safe-mode-title = Xavfsizlik usulida urinib ko‘ring
restart-in-safe-mode-label = Qo‘sh. dasturlarni o‘chirib ishga tushirish

## Media titles

audio-backend = Audio Server

##


## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/


##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] So‘nggi { $days } kun uchun nosozlik xabarlari
       *[other] So‘nggi { $days } kun uchun nosozlik xabarlari
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } daqiqa oldin
       *[other] { $minutes } daqiqa oldin
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } soat oldin
       *[other] { $hours } soat oldin
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } kun oldin
       *[other] { $days } kun oldin
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Barcha nosozlik xabarlari (berilgan vaqt oralig‘idagi { $reports } ta nosozlik bilan birga)
       *[other] Barcha nosozlik xabarlari (berilgan vaqt oralig‘idagi { $reports } ta nosozlik bilan birga)
    }

raw-data-copied = Manba ma’lumotlar vaqtinchalik xotiraga nusxa olingan
text-copied = Matn vaqtinchalik xotiraga nusxa olingan

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Video kartangiz drayveri versiyasi tufayli bloklangan.
blocked-gfx-card = Video kartangiz tufayli bloklangan, chunki hal qilib bo‘lmayidgan drayver muammosi yuz bergan.
blocked-os-version = Operatsion tizimingiz versiyasi uchun bloklangan.
blocked-mismatched-version = Video kartangiz drayveri versiyasi DLL fayli va ro‘yxatdan o‘tgani o‘rtasidagi tafovut tufayli bloklandi.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Video kartangiz drayveri tufayli bloklangan. Video kartangiz versiyasini { $driverVersion } versiyasiga yoki yangirog‘iga yangilashga urinib ko‘ring.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType parameterlari

compositing = Yozish
hardware-h264 = H264 qurilmasida dekoding qo‘llab-quvvatlanadi
main-thread-no-omtc = asosiy mavzu, OMTC yo‘q
yes = Ha
no = Yo‘q

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

gpu-description = Taʼrifi
gpu-vendor-id = Ishlab chiqaruvchi ID raqami
gpu-device-id = Qurilma ID raqami
gpu-subsys-id = Subsys ID
gpu-drivers = Drayverlar
gpu-ram = RAM
gpu-driver-version = Drayver versiyasi
gpu-driver-date = Drayver sanasi
gpu-active = Aktiv
blocklisted-bug = Ma’lum sabablarga ko‘ra blok ro‘yxatiga qo‘shildi

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = nosozlik: { $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Blok ro‘yxatiga qo‘shildi; xatolik kodi: { $failureCode }

d3d11layers-crash-guard = D3D11 Compositor
d3d11video-crash-guard = D3D11 Video Decoder
d3d9video-crash-guard = D3D9 Video Decoder
glcontext-crash-guard = OpenGL

reset-on-next-restart = Keyingi ishga tushishda tiklash

min-lib-versions = Kutilgan minimum versiya
loaded-lib-versions = Foydalanilayotgan versiya

has-seccomp-bpf = Seccomp-BPF (Tizimni chaqirishni filterlash)
has-seccomp-tsync = Seccomp mavzularini sinxronlash
has-user-namespaces = Foydalanuvchilar nomlari maydonchalari
has-privileged-user-namespaces = Imtiyozli jarayonlar uchun foydalanuvchilar nomlari maydonchalari
can-sandbox-content = Kontent sandbokslash jarayoni
can-sandbox-media = Media plugin Sandbokslash

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Foydalanuvchi yoqib qo‘ygan
multi-process-status-1 = Standart sozlamalar bo‘yicha yoqib qo‘yilgan
multi-process-status-2 = O‘chirib qo‘yilgan
multi-process-status-4 = Maxsus imkoniyatlar asboblari tomonidan o‘chirib qo‘yilgan
multi-process-status-6 = Mos kelmaydigan matn kiritilganligi uchun o‘chirib qo‘yigan
multi-process-status-7 = Qo‘shimcha dasturlar tomonidan o‘chirib qo‘yilgan
multi-process-status-8 = Majburiy o‘chirib qo‘yildi
multi-process-status-unknown = Noma’lum holat

async-pan-zoom = Asinxronlanadigan Nov/Mastshab
apz-none = yo‘q
wheel-enabled = g‘ildirakdan foydalanish yoqildi
touch-enabled = sichqoncha tugmasidan foydalanish yoqildi
drag-enabled = siljitish panelidan foydalanish yoqildi

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = async g‘ildirakdan foydalanish mos kelmadyigan qo‘shimcha tufayli o‘chirib qo‘yildi: { $preferenceKey }
touch-warning = async teginib kiritish mos kelmadyigan qo‘shimcha tufayli o‘chirib qo‘yildi: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

