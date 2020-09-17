# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Joriy asboblar qutisi nishonini qoʻllab-quvvatlamaydi

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Qoʻshimcha dasturlar oʻrnatgan dasturlash asboblari

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Mavjud asboblar qutisi tugmalari

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Mavzular

## Inspector section

# The heading
options-context-inspector = Nazoratchi

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Brauzer uslublarini ko‘rsatish
options-show-user-agent-styles-tooltip =
    .title = Buni yoqish brauzer tomonidan yuklangan joriy uslublarni ko‘rsatadi.

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Standart rang
options-default-color-unit-hex = 16-lik son
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Rang nomlari

## Style Editor section

# The heading
options-styleeditor-label = Uslubni tahrirlagich

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Avtotugatish CSS
options-stylesheet-autocompletion-tooltip =
    .title = "Uslub tahrirchisi" CSS xossalari, qiymatlari va tanlagichlarini yozuvingiz sifatida avtotugatish

## Screenshot section


## Editor section

# The heading
options-sourceeditor-label = Tahrirlagich parametrlari

options-sourceeditor-detectindentation-tooltip =
    .title = Manba tarkibi asosida xat boshidan boshlashni topish
options-sourceeditor-detectindentation-label = Xat boshini aniqlash
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Yopiluvchi qavslarni avtomatik kiritish
options-sourceeditor-autoclosebrackets-label = Qavslarni avtomatik yopish
options-sourceeditor-expandtab-tooltip =
    .title = Ichki oyna belgisi o‘rniga bo‘sh joylardan foydalanish
options-sourceeditor-expandtab-label = Bo‘sh joylardan foydalanib xat boshidan boshlash
options-sourceeditor-tabsize-label = Varaq hajmi
options-sourceeditor-keybinding-label = Tugmalar birikmasi
options-sourceeditor-keybinding-default-label = Standart

## Advanced section

# The heading
options-context-advanced-settings = Qoʻshimcha sozlamalar

options-disable-http-cache-tooltip =
    .title = Buni yoqib qo‘ysangiz, u asboblar paneli ochiq bo‘lgan barcha ichki oynalar uchun HTTP keshni o‘chirib qo‘yadi. Service Workers ta’minotiga ta’sir qilmaydi.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = JavaScript *’ni o‘chirib qo‘yish
options-disable-javascript-tooltip =
    .title = Agar buni tanlasangiz, joriy ichki oyna uchun JavaScript o‘chiriladi. Agar ichki oyna yoki asboblar paneli yopilsa, ushbu moslashlar oʻz kuchini yoʻqotadi.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Brauzer xromi va  asboblar panelini tuzatish qo‘shimcha dasturlarini yoqing
options-enable-chrome-tooltip =
    .title = Ushbu moslamani yoqish brauzer kontektstida turli xil dasturlar vositalaridan foydalanish (Asboblar > Veb dasturchi > Brazuer asboblar paneli orqali) va "Qo‘shimcha dasturlarni boshqarish"dan qo‘shimcha dasturlarni tuzatishga ruxsat beradi

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Masofadan nosozliklarni jo‘natishni yoqish

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Service Workers ta’minotini sinash xususiyatlarini yoqib qo‘yadi (asboblar paneli ochiq bo‘lganda)
options-enable-service-workers-http-tooltip =
    .title = Asboblar paneli bo‘lgan barcha ichki oynalar uchun HTTP ustida service workers ta’minotni yoqib qo‘yadi.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Faqat joriy seans, sahifani qayta yuklaydi

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Gecko platformasi ma’lumotlarini koʻrsatish
options-show-platform-data-tooltip =
    .title = Agar siz ushbu moslamani yoqsangiz, JavaScript Profiler natijalari  Gekko platformasi simvollarini qoʻshadi
