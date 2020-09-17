# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Qoʻshimcha dasturlar boshqaruvchisi

addons-page-title = Qoʻshimcha dasturlar boshqaruvchisi

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Ushbu turdagi oʻrnatilgan birorta ham qoʻshimcha dasturingiz yoʻq

list-empty-available-updates =
    .value = Yangilanishlar topilmadi

list-empty-recent-updates =
    .value = Yaqinda birorta ham qoʻshimcha dasturlarni yangilamagansiz

list-empty-find-updates =
    .label = Yangilanishlar uchun tekshirish

list-empty-button =
    .label = Qoʻshimcha dasturlar haqida koʻproq oʻrganish

show-unsigned-extensions-button =
    .label = Ba’zi kengaytmalar tasdiqlanmadi

show-all-extensions-button =
    .label = Barcha kengaytmalarni ko‘rsatish

cmd-show-details =
    .label = Koʻproq ma`lumotlarni koʻrsatish
    .accesskey = k

cmd-find-updates =
    .label = Yangilanishlarni topish
    .accesskey = t

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Moslamalar
           *[other] Moslamalar
        }
    .accesskey =
        { PLATFORM() ->
            [windows] M
           *[other] M
        }

cmd-enable-theme =
    .label = Mavzu oʻrnatish
    .accesskey = o

cmd-disable-theme =
    .label = Mavzu oʻrnatishni toʻxtatish
    .accesskey = t

cmd-install-addon =
    .label = Oʻrnatish
    .accesskey = O

cmd-contribute =
    .label = Hissa qoʻshish
    .accesskey = H
    .tooltiptext = Ushbu qoʻshimcha dasturni rivojlantirishga hissa qoʻshish

detail-version =
    .label = Versiyasi

detail-last-updated =
    .label = Soʻnggi yangilangan

detail-contributions-description = Ushbu qoʻshimcha dastur muallifi sizdan dasturni rivojlantirish uchun ozroq hissangizni qoʻshishni soʻramoqda.

detail-update-type =
    .value = Avtomatik yangilanishlar

detail-update-default =
    .label = Standart
    .tooltiptext = Agar faqat ular standart boʻlsa avtomatik yangilanishlar oʻrnatilsin

detail-update-automatic =
    .label = Yoqilgan
    .tooltiptext = Yangilanishlarni avtomatik oʻrnatish

detail-update-manual =
    .label = Oʻchirilgan
    .tooltiptext = Yangilanishlar avtomatik oʻrnatilmasin

detail-home =
    .label = Uy sahifasi

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Qoʻshimcha dastur profili

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Yangilanishlar uchun tekshirish
    .accesskey = Y
    .tooltiptext = Ushbu qoʻshimcha dastur uchun yangilanishlarni tekshirish

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Moslamalar
           *[other] Moslamalar
        }
    .accesskey =
        { PLATFORM() ->
            [windows] M
           *[other] M
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Ushbu qoʻshimcha dastur moslamalarini oʻzgartirish
           *[other] Ushbu qoʻshimcha dastur moslamalarini oʻzgartirish
        }

detail-rating =
    .value = Reyting

addon-restart-now =
    .label = Hozir qayta ishga tushirish

disabled-unsigned-heading =
    .value = Ba’zi qo‘shimcha dasturlar o‘chirib qo‘yildi

disabled-unsigned-description = Quyidagi qo‘shimcha dasturlar { -brand-short-name } brauzerida foydalanish uchun tasdiqdan o‘tmagan. Siz <label data-l10n-name="find-addons">almashtiriladiganlarini topishingiz</label> yoki dasturchidan ularni tasdiqlashini so‘rashingiz mumkin.

disabled-unsigned-learn-more = Onlayn xavfsizligingizni ta’minlash uchun qilayotgan harakatlarimiz haqida batafsil ma’lumot oling.

disabled-unsigned-devinfo = Dasturchilar qo‘shimcha dasturlarini bizning qo‘llanmamizni o‘qib, tasdiqdan o‘tkazishga <label data-l10n-name="learn-more">qiziqishadi</label>.

addon-category-discover = Tavsiyalar
addon-category-discover-title =
    .title = Tavsiyalar
addon-category-extension = Kengaytmalar
addon-category-extension-title =
    .title = Kengaytmalar
addon-category-theme = Mavzular
addon-category-theme-title =
    .title = Mavzular
addon-category-plugin = Plaginlar
addon-category-plugin-title =
    .title = Plaginlar
addon-category-dictionary = Lugʻatlar
addon-category-dictionary-title =
    .title = Lugʻatlar
addon-category-locale = Tillar
addon-category-locale-title =
    .title = Tillar
addon-category-available-updates = Mavjud yangilanishlar
addon-category-available-updates-title =
    .title = Mavjud yangilanishlar
addon-category-recent-updates = Soʻnggi yangilanishlar
addon-category-recent-updates-title =
    .title = Soʻnggi yangilanishlar

## These are global warnings

extensions-warning-safe-mode = "Xavfsiz usuli" tomonidan  barcha qoʻshimcha dasturlar oʻchirilgan
extensions-warning-check-compatibility = Qoʻshimcha dasturning mosligini tekshirish oʻchirilgan. Sizda tugallanmagan qoʻshimcha dasturlar boʻlishi mumkin.
extensions-warning-check-compatibility-button = Yoqish
    .title = Qoʻshimcha dasturning mosligini tekshirishni yoqish
extensions-warning-update-security = Qoʻshimcha dasturlarni xavfsiz yangilash oʻchirilgan. Yangilanishlar uchun xavf ostida boʻlishi mumkin.
extensions-warning-update-security-button = Yoqish
    .title = Qoʻshimcha dasturni xavfsiz yangilashni tekshirishni yoqish


## Strings connected to add-on updates

addon-updates-check-for-updates = Yangilanishlar uchun tekshirish
    .accesskey = t
addon-updates-view-updates = Soʻnggi yangilanishlarni koʻrish
    .accesskey = k

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Qoʻshimcha dasturlarni avtomatik yangilash
    .accesskey = Q

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Barcha qoʻshimcha dasturlarni avtomatik yangilash uchun tiklash
    .accesskey = t
addon-updates-reset-updates-to-manual = Qoʻlbola yangilash uchun barcha qoʻshimcha dasturlarni tiklash
    .accesskey = t

## Status messages displayed when updating add-ons

addon-updates-updating = Qoʻshimcha dasturlarni yangilash
addon-updates-installed = Qoʻshimcha dasturingiz yangilandi.
addon-updates-none-found = Yangilanishlar topilmadi
addon-updates-manual-updates-found = Mavjud yangilanishlarni koʻrish

## Add-on install/debug strings for page options menu

addon-install-from-file = Qoʻshimcha dasturlarni fayldan oʻrnatish
    .accesskey = o
addon-install-from-file-dialog-title = Oʻrnatish uchun qoʻshimcha dasturni tanlang
addon-install-from-file-filter-name = Qoʻshimcha dasturlar
addon-open-about-debugging = Qo‘shimcha dasturlarni tuzatish
    .accesskey = t

## Extension shortcut management


## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Kengaytmalar va mavzular brauzeringiz uchun ilovalarga oʻxshaydi.
    Ular parollaringizni himoya qiladi, videolarni yuklab oladi, chegirmalarni topadi,
    asabbuzar reklamalarni bloklaydi, brauzer koʻrinishini oʻzgartiradi.
    Bunday kichik dasturiy taʼminotlarni begona dasturchilar ishlab chiqadi.
    Bu yerdan mutlaq xavfsizligingiz, samaradorlik va funksionallik uchun { -brand-product-name }
    <a data-l10n-name="learn-more-trigger">tavsiya etiladigan</a> kengaytma
    va mavzular toʻplamini topish mumkin.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Ayrim tavsiyalar aynan siz uchun moslashtirilgan. Ular siz oʻrnatgan boshqa 
    kengaytmalar, profil sozlamalari va foydalanish statistikasi asosida tavsiya etiladi.

## Add-on actions


## Pending uninstall message bar

recommended-themes-heading = Tavsiya etilgan mavzular

## Page headings

theme-heading = Mavzularni boshqarish

addon-page-options-button =
    .title = Barcha qoʻshimcha dasturlar uchun asboblar
