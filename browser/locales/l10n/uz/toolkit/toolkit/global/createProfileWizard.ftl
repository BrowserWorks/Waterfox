# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Profil ustasini yaratish
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Kirish
       *[other] { create-profile-window.title }ga xush kelibsiz
    }

profile-creation-explanation-1 = { -brand-short-name } barcha moslamalar va parametrlar ma`lumotlarini shaxsiy profilingizga saqlaydi.

profile-creation-explanation-2 = Agar siz { -brand-short-name } nusxasini boshqa foydalanuvchilar bilan boʻlishsangiz, har bir foydalanuvchining ma`lumotlarini alohida saqlashingiz mumkin. Bu bilan har bir foydalanuvchi oʻzining shaxsiy profilini yaratishi mumkin.

profile-creation-explanation-3 = Agar siz { -brand-short-name } nusxasidan foydalanayotgan yagona shaxs boʻsangiz, bitta profilingiz boʻlishi kerak. Agar bir nechta profil yaratmoqchi boʻlsangiz, parametrlar va moslamalarga oʻzgartirish kiritishingiz kerak. Masalan, profillaringizni ish va shaxsiy foydalanish uchun ajratishingiz mumkin.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Profilingizni yaratishni boshlashni xohlasangiz, "Davom etish"ni bosing.
       *[other] Profilingizni yaratishni boshlashni xohlasangiz, "Keyingi"ni bosing.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Xotima
       *[other] { create-profile-window.title } tugadi
    }

profile-creation-intro = Agar bir nechta profil yaratmoqchi boʻlsangiz, ularga alohida profil nomlari qoʻyishingiz mumkin. Bu yerda keltirilgan nomlardan birini yoki oʻzingiz xohlagan nomdan foydalanishingiz mumkin.

profile-prompt = Yangi profil nomini kiriting:
    .accesskey = k

profile-default-name =
    .value = Standart foydalanuvchi

profile-directory-explanation = Parametrlar, moslamalar va boshqa kerakli ma`lumotlaringizni bu yerda saqlab qolishingiz mumkin:

create-profile-choose-folder =
    .label = Jildni tanlash
    .accesskey = t

create-profile-use-default =
    .label = Standart jilddan foydalanish
    .accesskey = f
