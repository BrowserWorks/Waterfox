# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Tanlamalar
           *[other] Parametrlar
        }

pane-compose-title = Yozish
category-compose =
    .tooltiptext = Yozish

pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat

pane-calendar-title = Taqvim
category-calendar =
    .tooltiptext = Taqvim

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name } bosh sahifasi

start-page-label =
    .label = { -brand-short-name } ishga tushganda, xabar hududida bosh sahifa ko‘rsatilsin
    .accesskey = i

location-label =
    .value = Joylashuvi:
    .accesskey = o
restore-default-label =
    .label = Standart holatni tiklash
    .accesskey = t

default-search-engine = Asosiy qidiruv tizimi

new-message-arrival = Yangi xabar kelganda:
mail-play-button =
    .label = Ijro etish
    .accesskey = I

change-dock-icon = Ilova dastur nishonchasi uchun parametrlarni o‘zgartirish
app-icon-options =
    .label = Ilova dastur nishonchasi tanlamalari…
    .accesskey = n

animated-alert-label =
    .label = Ogohlantirish signalini ko‘rsatish
    .accesskey = k
customize-alert-label =
    .label = Qulaylashtirish…
    .accesskey = Q

tray-icon-label =
    .label = Patni nishonchasini ko‘rsatish
    .accesskey = P

mail-custom-sound-label =
    .label = Quyidagi tovush faylidan foydalanilsin
    .accesskey = f
mail-browse-sound-button =
    .label = Ko‘rish…
    .accesskey = r

enable-gloda-search-label =
    .label = Global izlash va indekslashni yoqib qo‘yish
    .accesskey = q

allow-hw-accel =
    .label = Mavjud bo‘lganda qurilmani tezlatishdan foydalanilsin
    .accesskey = q

store-type-label =
    .value = Yangi hisoblar uchun xabarlarni saqlash turi:
    .accesskey = t

mbox-store-label =
    .label = Har bir jilddagi fayl (mbox)
maildir-store-label =
    .label = Har bir xabardagi fayl (maildir)

scrolling-legend = Siljitish
autoscroll-label =
    .label = Avtosiljitishdan foydalanish
    .accesskey = f
smooth-scrolling-label =
    .label = Bir tekisda siljitishdan foydalanish
    .accesskey = e

system-integration-legend = Tizimni integratsiyalash
always-check-default =
    .label = Ishga tushirilganda doimo { -brand-short-name } standart e-pochta mijozi ekanligi tekshirilsin
    .accesskey = A
check-default-button =
    .label = Hozir tekshirish…
    .accesskey = H

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows qidiruvi
       *[other] { "" }
    }

search-integration-label =
    .label = Xabarlarni qidirishda { search-engine-name }ga ruxsat berilsin
    .accesskey = s

config-editor-button =
    .label = Tahrirlagichni moslash…
    .accesskey = T

return-receipts-description = { -brand-short-name } qabul qilinganlik haqidagi xabarlar bilan qanday ishlashini aniqlash
return-receipts-button =
    .label = Qabul qilinganligi haqida xabar berish…
    .accesskey = Q

automatic-updates-label =
    .label = Yangilanishlarni avtomatik o‘rnatish (tavsiya qilinadi: yaxshilangan xavfsizlik)
    .accesskey = a
check-updates-label =
    .label = Yangilanishlar uchun tekshirilsin, ammo menga tanlab o‘rnatish imkoni berilsin
    .accesskey = t

update-history-button =
    .label = Yangilash tarixini ko‘rsatish
    .accesskey = a

use-service =
    .label = Yangilanishlarni o‘rnatish uchun orqa fonda yangilash xizmatidan foydalaning
    .accesskey = o

networking-legend = Ulanish
proxy-config-description = { -brand-short-name } dasturini internetga ulanishini moslash

network-settings-button =
    .label = Sozlamalar…
    .accesskey = S

offline-legend = Oflayn
offline-settings = Oflayn sozlamalarini to‘g‘rilash

offline-settings-button =
    .label = Oflayn…
    .accesskey = O

diskspace-legend = Diskdagi joy
offline-compact-folder =
    .label = Barcha jildlar saqlanganda ularni yig‘ish
    .accesskey = a

compact-folder-size =
    .value = Jami: MB

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Kesh uchun
    .accesskey = U

use-cache-after = MB joydan foydalaning

##

clear-cache-button =
    .label = Hozir tozalash
    .accesskey = t

fonts-legend = Shriftlar va ranglar

default-font-label =
    .value = Asosiy shrift
    .accesskey = A

default-size-label =
    .value = Hajmi:
    .accesskey = H

font-options-button =
    .label = Qo‘shimcha…
    .accesskey = Q

color-options-button =
    .label = Ranglar…
    .accesskey = R

display-width-legend = Oddiy matn xabarlari

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Hissiyotlarni grafika kabi ko‘rsatish
    .accesskey = H

display-text-label = Oddiy matn xabarlari qo‘shtirnoq ichida ko‘rsatilganda:

style-label =
    .value = Uslub:
    .accesskey = l

regular-style-item =
    .label = Muntazam
bold-style-item =
    .label = Qalin
italic-style-item =
    .label = Qiya
bold-italic-style-item =
    .label = Qalin qiya

size-label =
    .value = Hajmi:
    .accesskey = H

regular-size-item =
    .label = Muntazam
bigger-size-item =
    .label = Kattaroq
smaller-size-item =
    .label = Kichikroq

quoted-text-color =
    .label = Rangi:
    .accesskey = R

search-input =
    .placeholder = Izlash

type-column-label =
    .label = Tarkib turi
    .accesskey = t

action-column-label =
    .label = Amal
    .accesskey = A

save-to-label =
    .label = Fayllarni saqlash
    .accesskey = s

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Tanlash…
           *[other] Ko‘rish…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] T
           *[other] r
        }

always-ask-label =
    .label = Fayllarni saqlash joy doimo mendan so‘ralsin
    .accesskey = d


display-tags-text = Teglar xabarlaringizni turkumlarga va muhimligi bo‘yicha ajratishda foydalaniladi.

delete-tag-button =
    .label = O‘chirish
    .accesskey = O

auto-mark-as-read =
    .label = Xabarlarni avtomatik tarzda o‘qilgan deb belgilash
    .accesskey = a

mark-read-no-delay =
    .label = Tezda ekranda
    .accesskey = e

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Ko‘rsatilsin –
    .accesskey = d

seconds-label = soniyadan so‘ng

##

open-msg-label =
    .value = Xabarlar

open-msg-tab =
    .label = yangi ichi oynada ochilsin
    .accesskey = i

open-msg-window =
    .label = yangi xabar oynasida ochilsin
    .accesskey = y

open-msg-ex-window =
    .label = Mavjud xabar oynasida ochilsin
    .accesskey = M

close-move-delete =
    .label = Xabar oynasi/ichki oynasi ko‘chirilganda yoki o‘chirilganda yopilsin
    .accesskey = y

condensed-addresses-label =
    .label = Faqat manzillar kitobimdagi odamlarni nomi ko‘rsatilsin
    .accesskey = k

## Compose Tab

forward-label =
    .value = Xabarlarni boshqalarga yuborish:
    .accesskey = X

inline-label =
    .label = Ichki

as-attachment-label =
    .label = Biriktirma sifatida

extension-label =
    .label = kengaytmani fayl nomiga qo‘shish
    .accesskey = k

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Avto saqlash –
    .accesskey = A

auto-save-end = har daqiqada

##

warn-on-send-accel-key =
    .label = Xabar jo‘natishda tayyot tugmalardan foydalanishni tasdiqlash
    .accesskey = t

spellcheck-label =
    .label = Jo‘natishdan oldin imlo xatolarini tekshirish
    .accesskey = t

spellcheck-inline-label =
    .label = Yozayotganda imlo xatolarini tekshirishni yoqib qo‘yish
    .accesskey = E

language-popup-label =
    .value = Til:
    .accesskey = T

download-dictionaries-link = Boshqa lug‘atlarni yuklab olish

font-label =
    .value = Shrift:
    .accesskey = S

font-color-label =
    .value = Matn rangi:
    .accesskey = M

bg-color-label =
    .value = Orqa fon rangi:
    .accesskey = O

restore-html-label =
    .label = Asosiy sozlamalarni tiklash
    .accesskey = t

default-format-label =
    .label = Asosiy matn o‘rniga Paragraf formatidan foydalaning
    .accesskey = P

format-description = Matn formati xususiyatlarini moslash

send-options-label =
    .label = Jo‘natish moslamalari…
    .accesskey = J

autocomplete-description = Xabarlar manzilga yo‘naltirilayotganda, kiritilganlar mosligini tekshirish:

ab-label =
    .label = Mahalliy manzil kitobi
    .accesskey = M

directories-label =
    .label = Direktoriya serveri
    .accesskey = D

directories-none-label =
    .none = Yo‘q

edit-directories-label =
    .label = Direktoriyalarni tahrirlash…
    .accesskey = t

email-picker-label =
    .label = Xat yuborilayotgan manzillar avtomatik tarzda qo‘shilsin:
    .accesskey = a

attachment-label =
    .label = Biriktirmalar qolib ketmasligi uchun tekshirish
    .accesskey = q

attachment-options-label =
    .label = Kalit so‘zlar…
    .accesskey = K

enable-cloud-share =
    .label = Ushbudan kattaroq fayllarni bo‘lishish taklif qilinsin
cloud-share-size =
    .value = MB

remove-cloud-account =
    .label = Olib tashlash
    .accesskey = O

cloud-account-description = Yangi Filelink ombori xizmatini qo‘shish


## Privacy Tab

mail-content = Xatdagi sayt

remote-content-label =
    .label = Xabarlarda masofadagi saytga ruxsat berish
    .accesskey = m

exceptions-button =
    .label = Istisnolar...
    .accesskey = I

remote-content-info =
    .value = Masofadagi sayt maxfiylik muammolari haqida batafsil ma’lumot

web-content = Veb sayt

history-label =
    .label = Men kirgan sayt va havolalar eslab qolinsin
    .accesskey = e

cookies-label =
    .label = Saytlardan kukilarga rozi bo‘lish
    .accesskey = r

third-party-label =
    .value = Begona taraf kukilariga ruxsat berish:
    .accesskey = r

third-party-always =
    .label = Doimo
third-party-never =
    .label = Hech qachon
third-party-visited =
    .label = Kirilganlardan

keep-label =
    .value = Saqlansin:
    .accesskey = S

keep-expire =
    .label = ular eskirguncha
keep-close =
    .label = Men { -brand-short-name }ni yopaman
keep-ask =
    .label = doimo mendan so‘ralsin

cookies-button =
    .label = Kukilarni ko‘rsatish…
    .accesskey = k

passwords-description = { -brand-short-name } barcha hisoblaringiz uchun parollaringizni eslab qoladi.

passwords-button =
    .label = Saqlangan parollar…
    .accesskey = S

master-password-description = Parol ustasi barcha parollaringizni himoya qiladi, lekin har bir seansda bir marta kiritishingiz kerak.

master-password-label =
    .label = Parol ustasidan foydalanish
    .accesskey = f

master-password-button =
    .label = Parol ustasini o‘zgartirish…
    .accesskey = o


junk-description = Asosiy spam sozlamalarini o‘rnating. Hisobda ko‘rsatilgan xatlarni spamga qo‘shish sozlamalarini Hisob sozlamalarida moslash mumkin.

junk-label =
    .label = Xabarlar spam sifatida belgilanganda:
    .accesskey = b

junk-move-label =
    .label = Ular hisobning "Spam" jildiga jo‘natilsin
    .accesskey = o

junk-delete-label =
    .label = Ular o‘chirilsin
    .accesskey = o

junk-read-label =
    .label = Spam sifatida aniqlangan xabarlarni o‘qilgan sifatida belgilash
    .accesskey = b

junk-log-label =
    .label = Moslashuvchan spam filter kiritishlarini yoqish
    .accesskey = y

junk-log-button =
    .label = Jurnalni ko‘rsatish
    .accesskey = k

reset-junk-button =
    .label = O‘rganish ma’lumotlarini tiklash
    .accesskey = t

phishing-description = { -brand-short-name } siz foydalanadigan qurilma umumiy texnikasi izlash funksiyasi orqali e-pochta qallobliklari xabarlarini aniqlay oladi.

phishing-label =
    .label = Men o‘qiyotganimda e-pochta qallobliklari sifatida aniqlangan xabar bo‘lsa menga aytilsin
    .accesskey = a

antivirus-description = Kiruvchi xatlarni kompyuterga saqlashdan oldin antivirus dasturlari tekshirishini { -brand-short-name } osonlashtiradi.

antivirus-label =
    .label = Individual kiruvchi xabarlarni karantinda saqlash uchun antivirus mijozlariga ruxsat berilsin
    .accesskey = r

certificate-description = Server shaxsiy sertifikatimni so‘raganida:

certificate-auto =
    .label = Avtomatik tarzda bittasini tanlash
    .accesskey = S

certificate-ask =
    .label = Har safar mendan so‘ralsin
    .accesskey = A

ocsp-label =
    .label = OCSP javob berish serverlari sertifikatlarining joriy yaroqliligini tasdiqlash uchun so‘rov jo‘natish
    .accesskey = s

## Chat Tab

startup-label =
    .value = { -brand-short-name } ishga tushganda:
    .accesskey = i

offline-label =
    .label = Chat hisoblarim oflayn saqlansin

auto-connect-label =
    .label = Chat hisoblarimga avtomatik tarzda ulansin

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Kompyuterga bir necha daqiqadan so‘ng
    .accesskey = K

idle-time-label = qaytganimdan so‘ng kontaktlarimni bilishga imkon berilsin

##

away-message-label =
    .label = va holatimga Ushbu xabar bilan tashqarida xabari o‘rnatilsin:
    .accesskey = t

send-typing-label =
    .label = Suhbatlarda yozish bildirishnomalarini jo‘natish
    .accesskey = y

notification-label = Xabar siz uchun yo‘naltirilganda:

show-notification-label =
    .label = Bildirishnomani ko‘rsatish:
    .accesskey = B

notification-all =
    .label = jo‘natuvchining ismi va xabar ko‘rinishi bilan
notification-name =
    .label = faqat jo‘natuvchining ismi bilan
notification-empty =
    .label = hech qanday ma’lumotsiz

chat-play-sound-label =
    .label = Tovushni eshitib ko‘rish
    .accesskey = n

chat-play-button =
    .label = Eshitib ko‘rish
    .accesskey = E

chat-system-sound-label =
    .label = Yangi xat uchun asosiy tizim tovushi
    .accesskey = a

chat-custom-sound-label =
    .label = Quyidagi tovush faylidan foydalanilsin
    .accesskey = f

chat-browse-sound-button =
    .label = Ko‘rish…
    .accesskey = r

## Preferences UI Search Results

