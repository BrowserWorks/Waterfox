# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Pengurus Add-ons

addons-page-title = Pengurus Add-ons

search-header =
    .placeholder = Cari di addons.mozilla.org
    .searchbuttonlabel = Cari

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Anda tidak mempunyai add-ons jenis ini yang dipasang

list-empty-available-updates =
    .value = Tiada kemaskini ditemui

list-empty-recent-updates =
    .value = Anda tidak ada mengemaskini sebarang add-on baru-baru ini

list-empty-find-updates =
    .label = Semak Kemaskini

list-empty-button =
    .label = Ketahui selanjutnya mengenai add-ons

help-button = Sokongan Add-ons

sidebar-help-button-title =
    .title = Sokongan Add-ons

preferences =
    { PLATFORM() ->
        [windows] Pilihan { -brand-short-name }
       *[other] Keutamaan { -brand-short-name }
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Pilihan { -brand-short-name }
           *[other] Keutamaan { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = Beberapa ekstensi tidak dapat disahkan

show-all-extensions-button =
    .label = Papar semua ekstensi

cmd-show-details =
    .label = Papar Maklumat Tambahan
    .accesskey = p

cmd-find-updates =
    .label = Cari Kemaskini
    .accesskey = k

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Pilihan
           *[other] Keutamaan
        }
    .accesskey =
        { PLATFORM() ->
            [windows] P
           *[other] K
        }

cmd-enable-theme =
    .label = Tema Digunakan
    .accesskey = i

cmd-disable-theme =
    .label = Berhenti Menggunakan Tema
    .accesskey = r

cmd-install-addon =
    .label = Pasang
    .accesskey = g

cmd-contribute =
    .label = Menyumbang
    .accesskey = a
    .tooltiptext = Sumbang untuk pembangunan add-on ini

detail-version =
    .label = Versi

detail-last-updated =
    .label = Kemaskini Terakhir

detail-contributions-description = Pembangun aplikasi tambahan ini meminta anda bantuan untuk menyokong pembangunan yang berterusan dengan memberikan sedikit sumbangan.

detail-update-type =
    .value = Kemaskini automatik

detail-update-default =
    .label = Piawai
    .tooltiptext = Pasang kemaskini secara automatik hanya jika itulah piawai

detail-update-automatic =
    .label = Aktif
    .tooltiptext = Pasang kemaskini secara automatik

detail-update-manual =
    .label = Nyahaktif
    .tooltiptext = Jangan pasang kemaskini secara automatik

detail-home =
    .label = Laman

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Profil add-on

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Semak Kemaskini
    .accesskey = n
    .tooltiptext = Semak kemaskini add-on ini

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Pilihan
           *[other] Keutamaan
        }
    .accesskey =
        { PLATFORM() ->
            [windows] P
           *[other] K
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Tukar pilihan add-on ini
           *[other] Tukar keutamaan add-on ini
        }

detail-rating =
    .value = Kadaran

addon-restart-now =
    .label = Mula semula sekarang

disabled-unsigned-heading =
    .value = Beberapa add-ons telah dinyahdayakan

disabled-unsigned-description = Add-ons berikut belum disahkan untuk digunakan dalam { -brand-short-name }. Anda boleh <label data-l10n-name="find-addons">cari pengganti</label> atau tanya pembangun untuk mengesahkannya.

disabled-unsigned-learn-more = Ketahui selanjutnya mengenai usaha kami untuk memastikan anda selamat dalam talian.

disabled-unsigned-devinfo = Pembangun yang berminat untuk mengesahkan add-on mereka boleh meneruskan dengan membaca <label data-l10n-name="learn-more">manual</label>.

plugin-deprecation-description = Ada sesuatu yang tidak kena? Ada plugin yang tidak lagi disokong oleh { -brand-short-name }. <label data-l10n-name="learn-more">Ketahui Selanjutnya.</label>

legacy-warning-show-legacy = Pamerkan ekstensi legasi

legacy-extensions =
    .value = Ekstensi Legasi

legacy-extensions-description = Ekstensi berikut tidak memenuhi piawai { -brand-short-name } oleh itu dinyahaktifkan. <label data-l10n-name="legacy-learn-more">Ketahui lanjut perubahan add-ons</label>

addon-category-extension = Ekstensi
addon-category-extension-title =
    .title = Ekstensi
addon-category-theme = Tema
addon-category-theme-title =
    .title = Tema
addon-category-plugin = Plugin
addon-category-plugin-title =
    .title = Plugin
addon-category-dictionary = Kamus
addon-category-dictionary-title =
    .title = Kamus
addon-category-locale = Bahasa
addon-category-locale-title =
    .title = Bahasa
addon-category-available-updates = Kemaskini Tersedia
addon-category-available-updates-title =
    .title = Kemaskini Tersedia
addon-category-recent-updates = Kemaskini Terkini
addon-category-recent-updates-title =
    .title = Kemaskini Terkini

## These are global warnings

extensions-warning-safe-mode = Semua add-ons telah dinyahdayakan oleh mod selamat.
extensions-warning-check-compatibility = Pemeriksaan kesesuaian add-on telah dinyahdayakan. Anda mungkin mempunyai add-on yang tidak sesuai.
extensions-warning-check-compatibility-button = Dayakan
    .title = Dayakan semakan kesesuaian add-on
extensions-warning-update-security = Semakan keselamatan kemaskini add-on telah dinyahdayakan. Anda mungkin terdedah kepada bahaya ketika mengemaskini.
extensions-warning-update-security-button = Dayakan
    .title = Dayakan semakan keselamatan kemaskini add-on


## Strings connected to add-on updates

addon-updates-check-for-updates = Semak Kemaskini
    .accesskey = e
addon-updates-view-updates = Papar Kemaskini Terbaru
    .accesskey = P

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Kemaskini Add-ons secara Automatik
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Set semula Semua Add-ons untuk Kemaskini Automatik
    .accesskey = u
addon-updates-reset-updates-to-manual = Set semula Semua Add-ons Untuk Kemaskini Manual
    .accesskey = n

## Status messages displayed when updating add-ons

addon-updates-updating = Mengemaskini add-on
addon-updates-installed = Add-ons anda telah dikemaskini.
addon-updates-none-found = Tiada kemaskini ditemui
addon-updates-manual-updates-found = Papar Kemaskini Tersedia

## Add-on install/debug strings for page options menu

addon-install-from-file = Pasang Add-ons Dari Fail…
    .accesskey = I
addon-install-from-file-dialog-title = Pilih add-on untuk dipasang
addon-install-from-file-filter-name = Add-ons
addon-open-about-debugging = Add-ons Nyahpepijat
    .accesskey = s

## Extension shortcut management


## Recommended add-ons page


## Add-on actions


## Pending uninstall message bar


## Page headings

extension-heading = Urus ekstensi anda
theme-heading = Urus tema anda
plugin-heading = Urus plugin anda
dictionary-heading = Urus kamus anda
locale-heading = Urus bahasa anda

addons-heading-search-input =
    .placeholder = Cari di addons.mozilla.org

addon-page-options-button =
    .title = Alatan untuk semua add-on
