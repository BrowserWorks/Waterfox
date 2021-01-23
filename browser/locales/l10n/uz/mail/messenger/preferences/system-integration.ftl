# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Tizimni integratsiyalash

system-integration-dialog =
    .buttonlabelaccept = Asosiy sifatida o‘rnatish
    .buttonlabelcancel = Integratsiyalashni tashlab o‘tish
    .buttonlabelcancel2 = Bekor qilish

default-client-intro = { -brand-short-name } dasturidan asosiy mijoz sifatida foydalanish:

unset-default-tooltip = { -brand-short-name } dasturini { -brand-short-name } ichidagi asosiy mijoz sifatida bekor qilib bo‘lmaydi. Boshqa ilova dasturni asosiy sifatida o‘rnatish uchun uning "Asosiy sifatida o‘rnatish" oynasidan foydalanishingiz kerak.

checkbox-email-label =
    .label = E-pochta
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Yangiliklar guruhi
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Tasmalar
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows qidiruvi
       *[other] { "" }
    }

system-search-integration-label =
    .label = Xabarlarni qidirishda { system-search-engine-name }ga ruxsat berilsin
    .accesskey = s

check-on-startup-label =
    .label = { -brand-short-name } ishga tushganda doimo ushbu tekshiruv amalga oshirilsin
    .accesskey = d
