# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Eklenti Yöneticisi
addons-page-title = Eklenti Yöneticisi

search-header =
    .placeholder = addons.mozilla.org’da ara
    .searchbuttonlabel = Ara

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Bu türden kurulmuş bir eklentiniz yok

list-empty-available-updates =
    .value = Güncelleme bulunamadı

list-empty-recent-updates =
    .value = Yakın zamanda herhangi bir eklenti güncellemediniz

list-empty-find-updates =
    .label = Güncellemeleri denetle

list-empty-button =
    .label = Eklentiler hakkında daha fazlasını öğrenin

help-button = Eklenti desteği
sidebar-help-button-title =
    .title = Eklenti desteği

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } seçenekleri
       *[other] { -brand-short-name } tercihleri
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } seçenekleri
           *[other] { -brand-short-name } tercihleri
        }

show-unsigned-extensions-button =
    .label = Bazı eklentiler doğrulanamadı

show-all-extensions-button =
    .label = Tüm eklentileri göster

cmd-show-details =
    .label = Daha fazla bilgi ver
    .accesskey = v

cmd-find-updates =
    .label = Güncellemeleri bul
    .accesskey = c

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Seçenekler
           *[other] Tercihler
        }
    .accesskey =
        { PLATFORM() ->
            [windows] S
           *[other] T
        }

cmd-enable-theme =
    .label = Tema kullan
    .accesskey = T

cmd-disable-theme =
    .label = Tema kullanma
    .accesskey = e

cmd-install-addon =
    .label = Kur
    .accesskey = u

cmd-contribute =
    .label = Katkıda bulun
    .accesskey = u
    .tooltiptext = Bu eklentinin geliştirilmesine katkıda bulun

detail-version =
    .label = Sürüm

detail-last-updated =
    .label = Son güncelleme

detail-contributions-description = Bu eklentinin geliştiricisi, sizden ufak bir katkıda bulunarak süregelen geliştirme faaliyetlerini desteklemenizi istiyor.

detail-contributions-button = Katkıda bulunun
    .title = Bu eklentinin geliştirilmesine katkıda bulunun
    .accesskey = K

detail-update-type =
    .value = Otomatik güncellemeler

detail-update-default =
    .label = Varsayılan
    .tooltiptext = Güncellemeleri sadece varsayılan ayar buysa kendiliğinden kur

detail-update-automatic =
    .label = Açık
    .tooltiptext = Güncellemeleri kendiliğinden kur

detail-update-manual =
    .label = Kapalı
    .tooltiptext = Güncellemeleri kendiliğinden kurma

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Gizli pencerede çalışabilir

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Gizli pencerelerde izin verilmiyor
detail-private-disallowed-description2 = Gizli gezinti sırasında bu eklenti çalışmaz. <a data-l10n-name="learn-more">Daha fazla bilgi alın</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Gizli pencerelere erişmesi gerekiyor
detail-private-required-description2 = Bu eklenti, gizli gezinti sırasında yaptıklarınıza erişebilir. <a data-l10n-name="learn-more">Daha fazla bilgi alın</a>

detail-private-browsing-on =
    .label = İzin ver
    .tooltiptext = Gizli gezintide izin ver

detail-private-browsing-off =
    .label = İzin verme
    .tooltiptext = Gizli gezintide etkisizleştir

detail-home =
    .label = Ana sayfa

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Eklenti profili

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Güncellemeleri denetle
    .accesskey = m
    .tooltiptext = Bu eklentinin güncellemelerini denetle

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Seçenekler
           *[other] Tercihler
        }
    .accesskey =
        { PLATFORM() ->
            [windows] S
           *[other] T
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Bu eklentinin seçeneklerini değiştir
           *[other] Bu eklentinin tercihlerini değiştir
        }

detail-rating =
    .value = Beğeni

addon-restart-now =
    .label = Şimdi yeniden başlat

disabled-unsigned-heading =
    .value = Bazı eklentiler etkisizleştirildi

disabled-unsigned-description = Aşağıdaki eklentiler { -brand-short-name } üzerinde kullanılmak üzere doğrulanmamıştır. <label data-l10n-name="find-addons">Yerlerine başkalarını bulabilir</label> veya geliştiriciden eklentilerini doğrulamasını isteyebilirsiniz.

disabled-unsigned-learn-more = Sizi internette daha güvende tutma çabalarımız hakkında bilgi alın.

disabled-unsigned-devinfo = Eklentilerini doğrulamak için isteyen geliştiriciler <label data-l10n-name="learn-more">rehberimizi</label> okuyabilir.

plugin-deprecation-description = Bir şeyler mi eksik? Bazı yan uygulamalar artık { -brand-short-name } tarafından desteklenmiyor. <label data-l10n-name="learn-more">Daha fazla bilgi alın.</label>

legacy-warning-show-legacy = Eski teknoloji eklentileri göster

legacy-extensions =
    .value = Eski teknoloji eklentiler

legacy-extensions-description = Bu eklentiler yeni { -brand-short-name } standartlarını karşılamadığı için etkisiz hale getirilmiştir. <label data-l10n-name="legacy-learn-more">Eklentilerde yaptığımız değişiklikler hakkında bilgi alın</label>

private-browsing-description2 =
    { -brand-short-name } gizli gezinti modunda eklentilerin çalışma şekli değişiyor. Bundan sonra
    { -brand-short-name } tarayıcınıza ekleceğiniz eklentiler varsayılan olarak gizli pencerelerde çalışmayacak.
    Böylece, siz ayarlara girip özellikle izin vermedikçe eklentiler gizli gezinti sırasında yaptıklarınızı göremeyecekler.
    Bu değişikliği, gizli gezintinizin daha da gizli kalması için yapıyoruz.
    <label data-l10n-name="private-browsing-learn-more">Eklenti ayarlarınızı yönetmeyi öğrenin.</label>

addon-category-discover = Öneriler
addon-category-discover-title =
    .title = Öneriler
addon-category-extension = Eklentiler
addon-category-extension-title =
    .title = Eklentiler
addon-category-theme = Temalar
addon-category-theme-title =
    .title = Temalar
addon-category-plugin = Yan uygulamalar
addon-category-plugin-title =
    .title = Yan uygulamalar
addon-category-dictionary = Sözlükler
addon-category-dictionary-title =
    .title = Sözlükler
addon-category-locale = Diller
addon-category-locale-title =
    .title = Diller
addon-category-available-updates = Mevcut güncellemeler
addon-category-available-updates-title =
    .title = Mevcut güncellemeler
addon-category-recent-updates = Yakın zamandaki güncellemeler
addon-category-recent-updates-title =
    .title = Yakın zamandaki güncellemeler

## These are global warnings

extensions-warning-safe-mode = Tüm eklentiler güvenli kipte devre dışı bırakıldı.
extensions-warning-check-compatibility = Eklenti uyumluluk denetimi devre dışı. Uyumsuz eklentileriniz olabilir.
extensions-warning-check-compatibility-button = Etkinleştir
    .title = Eklenti uyumluluk denetimini devreye sok
extensions-warning-update-security = Eklenti güncelleme güvenliği denetimi devre dışı. Güncellemelerle tehlikeye düşebilirsiniz.
extensions-warning-update-security-button = Etkinleştir
    .title = Eklenti güncelleme güvenliği denetimini devreye sok


## Strings connected to add-on updates

addon-updates-check-for-updates = Güncellemeleri denetle
    .accesskey = G
addon-updates-view-updates = En son güncellemelere bak
    .accesskey = b

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Eklentileri kendiliğinden güncelle
    .accesskey = n

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Tüm eklentileri kendiliğinden güncellenecek şekilde ayarla
    .accesskey = a
addon-updates-reset-updates-to-manual = Tüm eklentileri elle güncellenecek şekilde ayarla
    .accesskey = a

## Status messages displayed when updating add-ons

addon-updates-updating = Eklentiler güncelleniyor
addon-updates-installed = Eklentileriniz güncellendi.
addon-updates-none-found = Güncelleme bulunamadı
addon-updates-manual-updates-found = Yüklenebilir güncellemelere bak

## Add-on install/debug strings for page options menu

addon-install-from-file = Dosyadan eklenti kur...
    .accesskey = k
addon-install-from-file-dialog-title = Kurulacak eklentiyi seçin
addon-install-from-file-filter-name = Eklentiler
addon-open-about-debugging = Eklentilerde hata ayıkla
    .accesskey = h

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Eklenti kısayollarını yönet
    .accesskey = E

shortcuts-no-addons = Herhangi bir eklentiyi etkinleştirmediniz.
shortcuts-no-commands = Aşağıdaki eklentilerin kısayolları yok:
shortcuts-input =
    .placeholder = Bir kısayol girin

shortcuts-browserAction2 = Araç çubuğu düğmesini etkinleştir
shortcuts-pageAction = Sayfa eylemini etkinleştir
shortcuts-sidebarAction = Kenar çubuğunu aç/kapat

shortcuts-modifier-mac = Ctrl, Alt veya ⌘ kullanmalısınız
shortcuts-modifier-other = Ctrl veya Alt kullanmalısınız
shortcuts-invalid = Geçersiz kombinasyon
shortcuts-letter = Bir harf yazın
shortcuts-system = { -brand-short-name } kısayollarını değiştiremezsiniz

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Yinelenen kısayol

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } birden fazla yerde kısayol olarak kullanılıyor. Yinelenen kısayollar beklenmeyen davranışlara neden olabilir.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = { $addon } tarafından zaten kullanılıyor

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] { $numberToShow } tane daha göster
       *[other] { $numberToShow } tane daha göster
    }

shortcuts-card-collapse-button = Daha az göster

header-back-button =
    .title = Geri dön

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = Eklentiler ve temalar tarayıcınızın içinde çalışan uygulamalar gibidir. Parolalarınızı saklamanıza, video indirmeize, indirimleri bulmanıza, sinir bozucu reklamları engellemenize, tarayıcınızın görünümü değiştirmenize ve çok daha birçok şey yapmanıza olanak tanırlar. Bu küçük yazılımlar genellikle üçüncü şahıslar tarafından geliştirilir. Ekstra güvenlik, performans ve işlevsellik için { -brand-product-name } tarafından <a data-l10n-name="learn-more-trigger">önerilen</a> eklenti ve temaları aşağıdaki bulabilirsiniz.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Bu önerilerden bazıları size özeldir. Önerilerimiz; yüklediğiniz
    diğer eklentileri, profil tercihlerinizi ve kullanım istatistiklerinizi temel alır.
discopane-notice-learn-more = Daha fazla bilgi al

privacy-policy = Gizlilik İlkeleri

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = geliştiren: <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Kullanıcı: { $dailyUsers }
install-extension-button = { -brand-product-name }’a ekle
install-theme-button = Temayı yükle
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Yönet
find-more-addons = Daha fazla eklenti bul

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Diğer seçenekler

## Add-on actions

report-addon-button = Şikâyet et
remove-addon-button = Kaldır
# The link will always be shown after the other text.
remove-addon-disabled-button = Kaldırılamıyor <a data-l10n-name="link">Neden?</a>
disable-addon-button = Etkisizleştir
enable-addon-button = Etkinleştir
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Etkinleştir
preferences-addon-button =
    { PLATFORM() ->
        [windows] Seçenekler
       *[other] Tercihler
    }
details-addon-button = Ayrıntılar
release-notes-addon-button = Sürüm notları
permissions-addon-button = İzinler

extension-enabled-heading = Etkin
extension-disabled-heading = Devre dışı

theme-enabled-heading = Etkin
theme-disabled-heading = Devre dışı

plugin-enabled-heading = Etkin
plugin-disabled-heading = Devre dışı

dictionary-enabled-heading = Etkin
dictionary-disabled-heading = Devre dışı

locale-enabled-heading = Etkin
locale-disabled-heading = Devre dışı

ask-to-activate-button = Etkinleştirmek için sor
always-activate-button = Her zaman etkinleştir
never-activate-button = Asla etkinleştirme

addon-detail-author-label = Geliştiren
addon-detail-version-label = Sürüm
addon-detail-last-updated-label = Son güncelleme
addon-detail-homepage-label = Web sitesi
addon-detail-rating-label = Puan

# Message for add-ons with a staged pending update.
install-postponed-message = { -brand-short-name } yeniden başlatılınca bu eklenti güncellenecek.
install-postponed-button = Şimdi güncelle

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = 5 üzerinden { NUMBER($rating, maximumFractionDigits: 1) } puan

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (devre dışı)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } inceleme
       *[other] { $numberOfReviews } inceleme
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> kaldırıldı.
pending-uninstall-undo-button = Geri al

addon-detail-updates-label = Otomatik güncellemelere izin ver
addon-detail-updates-radio-default = Varsayılan
addon-detail-updates-radio-on = Açık
addon-detail-updates-radio-off = Kapalı
addon-detail-update-check-label = Güncellemeleri denetle
install-update-button = Güncelle

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Gizli pencerelerde izinli
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = İzin verirseniz bu eklenti, gizli gezinti sırasında çevrimiçi etkinliklerinize erişebilir. <a data-l10n-name="learn-more">Daha fazla bilgi alın</a>
addon-detail-private-browsing-allow = İzin ver
addon-detail-private-browsing-disallow = İzin verme

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } yalnızca güvenlik ve performans standartlarımızı karşılayan eklentileri önerir
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Mevcut güncellemeler
recent-updates-heading = Son güncellenenler

release-notes-loading = Yükleniyor…
release-notes-error = Üzgünüz, sürüm notları yüklenirken bir hata meydana geldi.

addon-permissions-empty = Bu eklenti herhangi bir izin gerektirmiyor

recommended-extensions-heading = Önerilen eklentiler
recommended-themes-heading = Önerilen temalar

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Yaratıcı gününüzde misiniz? <a data-l10n-name="link">Firefox Color ile kendi temanızı oluşturun.</a>

## Page headings

extension-heading = Eklentilerinizi yönetin
theme-heading = Temalarınızı yönetin
plugin-heading = Yan uygulamalarınızı yönetin
dictionary-heading = Sözlüklerinizi yönetin
locale-heading = Dillerinizi yönetin
updates-heading = Güncellemelerinizi yönetin
discover-heading = { -brand-short-name } tarayıcınızı kişiselleştirin
shortcuts-heading = Eklenti kısayollarını yönet

default-heading-search-label = Daha fazla eklenti bul
addons-heading-search-input =
    .placeholder = addons.mozilla.org’da ara

addon-page-options-button =
    .title = Tüm eklentiler için araçlar
