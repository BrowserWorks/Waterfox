# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Əlavə idarəçisi

addons-page-title = Əlavə idarəçisi

search-header =
    .placeholder = addons.mozilla.org saytında axtar
    .searchbuttonlabel = Axtar

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Bu növ qurulmuş əlavəniz yoxdur

list-empty-available-updates =
    .value = Yenilənmə tapılmadı

list-empty-recent-updates =
    .value = Yaxın vaxtlarda hər hansı bir əlavəni yeniləmədiniz

list-empty-find-updates =
    .label = Yeniləmələri yoxla

list-empty-button =
    .label = Əlavələr haqqında daha çox öyrənin

help-button = Əlavə Dəstəyi

sidebar-help-button-title =
    .title = Əlavə Dəstəyi

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } Seçimləri
       *[other] { -brand-short-name } Nizamlamaları
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } Seçimləri
           *[other] { -brand-short-name } Nizamlamaları
        }

show-unsigned-extensions-button =
    .label = Bəzi uzantılar təsdiqlənə bilmirlər

show-all-extensions-button =
    .label = Bütün uzantıları göstər

cmd-show-details =
    .label = Əlavə məlumat ver
    .accesskey = v

cmd-find-updates =
    .label = Yeniləmələrə bax
    .accesskey = F

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Nizamlar
           *[other] Nizamlamalar
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }

cmd-enable-theme =
    .label = Temadan istifadə elə
    .accesskey = T

cmd-disable-theme =
    .label = Tema istifadə etmə
    .accesskey = e

cmd-install-addon =
    .label = Qur
    .accesskey = u

cmd-contribute =
    .label = Kömək
    .accesskey = C
    .tooltiptext = Bu əlavənin inkişaf etdirilməsinə kömək et

detail-version =
    .label = Buraxılış

detail-last-updated =
    .label = Son yenilənmə

detail-contributions-description = Bu əlavəninin inkişaf etdiricisi, sizdən kiçik bir maddi kömək edərək əlavəni inkişaf etdirmə işini dəstəkləməyinizi istəyir.

detail-update-type =
    .value = Avtomatik yeniləmə

detail-update-default =
    .label = Standart
    .tooltiptext = Yeniləmələri sadəcə standart tənzimləmə budusa avtomatik quraşdır

detail-update-automatic =
    .label = Açıqdır
    .tooltiptext = Yeniləmələri avtomatik quraşdır

detail-update-manual =
    .label = Bağlı
    .tooltiptext = Yeniləmələri avtomatik quraşdırma

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Məxfi Pəncərələrdə işlət

detail-private-browsing-on =
    .label = İcazə ver
    .tooltiptext = Məxfi Pəncərələrdə aktivləşdir

detail-private-browsing-off =
    .label = İcazə vermə
    .tooltiptext = Məxfi Pəncərələrdə söndür

detail-home =
    .label = Ana səhifə

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Əlavənin ID nömrəsi

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Yeniləmələrə bax…
    .accesskey = b
    .tooltiptext = Bu əlavənin yeniləmələri üçün bax

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Nizamlar
           *[other] Nizamlamalar
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Bu əlavənin seçimlərini dəyiş
           *[other] Bu əlavənin seçimlərini dəyiş
        }

detail-rating =
    .value = Bəyənilmə

addon-restart-now =
    .label = İndi yenidən başlat

disabled-unsigned-heading =
    .value = Bəzi əlavələr söndürüldü

disabled-unsigned-description = Bu əlavələr { -brand-short-name } səyyahında işlətmək üçün təsdiqlənməyiblər. Siz <label data-l10n-name="find-addons">yerinə başqasını tapa</label> və ya tərtibatçıdan onları təsdiqləməsini istəyə bilərsiz.

disabled-unsigned-learn-more = Sizi onlayn təhlükəsiz tutmaq üçün etdiklərimiz haqqında ətraflı öyrənin.

disabled-unsigned-devinfo = Əlavələrinin təsdiqlənməsini istəyən tərtibatçılar <label data-l10n-name="learn-more">təlimatları</label> oxumaqla başlaya bilərlər.

plugin-deprecation-description = Nəsə çatışmır? Bəzi qoşmalar artıq { -brand-short-name } tərəfindən dəstəklənmir. <label data-l10n-name="learn-more">Ətraflı Öyrən.</label>

legacy-warning-show-legacy = Köhnəlmiş qoşmaları göstər

legacy-extensions =
    .value = Köhnəlmiş Qoşmalar

legacy-extensions-description = Bu qoşmalar hazırkı { -brand-short-name } standartlarına cavab vermirlər və bu səbəbdən söndürüldülər. <label data-l10n-name="legacy-learn-more">Əlavələrə olan dəyişikliklər haqqında öyrən</label>

addon-category-extension = Uzantılar
addon-category-extension-title =
    .title = Uzantılar
addon-category-theme = Mövzular
addon-category-theme-title =
    .title = Mövzular
addon-category-plugin = Qoşmalar
addon-category-plugin-title =
    .title = Qoşmalar
addon-category-dictionary = Lüğətlər
addon-category-dictionary-title =
    .title = Lüğətlər
addon-category-locale = Dillər
addon-category-locale-title =
    .title = Dillər
addon-category-available-updates = Mövcud yeniləmələr
addon-category-available-updates-title =
    .title = Mövcud yeniləmələr
addon-category-recent-updates = Yaxın vaxtlardakı yeniləmələr
addon-category-recent-updates-title =
    .title = Yaxın vaxtlardakı yeniləmələr

## These are global warnings

extensions-warning-safe-mode = Bütün əlavələr təhlükəsizlik rejimdə söndürüldü.
extensions-warning-check-compatibility = Əlavə uyğunluq nəzarəti söndürülüb. Uyğun olmayan əlavələriniz ola bilər.
extensions-warning-check-compatibility-button = Aktiv et
    .title = Əlavə uyğunluq nəzarətini aktivləşdir
extensions-warning-update-security = Əlavə yeniləmə təhlükəsizliyinə  nəzarəti söndürülüb. Yeniləmələr təhlükəli ola bilər.
extensions-warning-update-security-button = Aktiv et
    .title = Əlavə yeniləmə təhlükəsizliyinə  nəzarəti aktivləşdir


## Strings connected to add-on updates

addon-updates-check-for-updates = Yeniləmələrə bax…
    .accesskey = C
addon-updates-view-updates = Yaxın vaxtdakı yeniləmələrə bax
    .accesskey = b

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Əlavələri avtomatik yenilə
    .accesskey = n

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Bütün əlavələri avtomatik yeniləyəcək şəkildə nizamla
    .accesskey = a
addon-updates-reset-updates-to-manual = Bütün əlavələri əllə yeniləyəcək şəkildə nizamla
    .accesskey = a

## Status messages displayed when updating add-ons

addon-updates-updating = Əlavələr yenilənir
addon-updates-installed = Əlavələriniz yenilənir.
addon-updates-none-found = Yenilənmə tapılmadı
addon-updates-manual-updates-found = Quraşdırıla biləcək yeniləmələrə bax

## Add-on install/debug strings for page options menu

addon-install-from-file = Fayldan əlavə qur...
    .accesskey = I
addon-install-from-file-dialog-title = Quraşdırılacaq əlavəni seçin
addon-install-from-file-filter-name = Əlavələr
addon-open-about-debugging = Əlavələri Sazla
    .accesskey = z

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Uzantı Qısa-yollarını İdarə et
    .accesskey = S

shortcuts-no-addons = Aktiv uzantınız yoxdur.
shortcuts-no-commands = Bu uzantıların qısa-yolları yoxdur:
shortcuts-input =
    .placeholder = Qısayol yazın

shortcuts-pageAction = Səhifə əməliyyatını aktivləşdir
shortcuts-sidebarAction = Yan Paneli Aç/Qapat

shortcuts-modifier-mac = Ctrl, Alt və ya ⌘ istifadə edin
shortcuts-modifier-other = Ctrl və ya Alt istifadə edin
shortcuts-invalid = Səhv kombinasiya
shortcuts-letter = Hərf yazın
shortcuts-system = { -brand-short-name } qısayolu dəyişdirilə bilməz

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Daha { $numberToShow } dənə göstər
       *[other] Daha { $numberToShow } dənə göstər
    }

shortcuts-card-collapse-button = Daha az göstər

header-back-button =
    .title = Geri get

## Recommended add-ons page


## Add-on actions

remove-addon-button = Sil
disable-addon-button = Söndür
enable-addon-button = Aktiv et

## Pending uninstall message bar


## Page headings

extension-heading = Uzantılarını idarə et
theme-heading = Mözvularını idarə et
plugin-heading = Qoşmalarını idarə et
dictionary-heading = Lüğətlərini idarə et
locale-heading = Dillərini idarə et
discover-heading = { -brand-short-name } səyyahınızı şəxsiləşdirin
shortcuts-heading = Uzantı Qısa-yollarını İdarə et

addons-heading-search-input =
    .placeholder = addons.mozilla.org saytında axtar

addon-page-options-button =
    .title = Bütün əlavələr üçün alətlər
