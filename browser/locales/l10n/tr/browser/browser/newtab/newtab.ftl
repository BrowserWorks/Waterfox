# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Yeni Sekme
newtab-settings-button =
    .title = Yeni Sekme sayfanızı özelleştirin

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Ara
    .aria-label = Ara

newtab-search-box-search-the-web-text = Web’de ara
newtab-search-box-search-the-web-input =
    .placeholder = Web’de ara
    .title = Web’de ara
    .aria-label = Web’de ara

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Arama motoru ekle
newtab-topsites-add-topsites-header = Yeni sık kullanılan site
newtab-topsites-edit-topsites-header = Sık kullanılan siteyi düzenle
newtab-topsites-title-label = Başlık
newtab-topsites-title-input =
    .placeholder = Başlık yazın

newtab-topsites-url-label = Adres
newtab-topsites-url-input =
    .placeholder = Adres yazın ve yapıştırın
newtab-topsites-url-validation = Geçerli bir adres gerekli

newtab-topsites-image-url-label = Özel resim adresi
newtab-topsites-use-image-link = Özel resim kullan…
newtab-topsites-image-validation = Resim yüklenemedi. Başka bir adres deneyin.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = İptal
newtab-topsites-delete-history-button = Geçmişten sil
newtab-topsites-save-button = Kaydet
newtab-topsites-preview-button = Ön izleme yap
newtab-topsites-add-button = Ekle

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Bu sayfanın tüm kayıtlarını geçmişinizden silmek istediğinizden emin misiniz?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Bu işlem geri alınamaz.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Menüyü aç
    .aria-label = Menüyü aç

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Kaldır
    .aria-label = Kaldır

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Menüyü aç
    .aria-label = { $title } sağ tıklama menüsünü aç
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Bu siteyi düzenle
    .aria-label = Bu siteyi düzenle

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Düzenle
newtab-menu-open-new-window = Yeni pencerede aç
newtab-menu-open-new-private-window = Yeni gizli pencerede aç
newtab-menu-dismiss = Kapat
newtab-menu-pin = Sabitle
newtab-menu-unpin = Sabitleneni kaldır
newtab-menu-delete-history = Geçmişten sil
newtab-menu-save-to-pocket = { -pocket-brand-name }’a kaydet
newtab-menu-delete-pocket = { -pocket-brand-name }’tan sil
newtab-menu-archive-pocket = { -pocket-brand-name }’ta arşivle
newtab-menu-show-privacy-info = Sponsorlarımız ve gizliliğiniz

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Tamam
newtab-privacy-modal-button-manage = Sponsorlu içerik ayarlarını yönet
newtab-privacy-modal-header = Gizliliğiniz bizim için önemli.
newtab-privacy-modal-paragraph-2 = İlginizi çekebilecek yazıların yanı sıra seçkin sponsorlarımızdan gelen bazı içerikleri de gösteriyoruz. Gezinti verileriniz <strong>asla bilgisayarınızdaki { -brand-product-name } kurulumunun dışına çıkmıyor</strong>: Hangi sitelere girdiğinizi ne biz görüyoruz ne de sponsorlarımız.
newtab-privacy-modal-link = Yeni sekmede gizliliğinizi nasıl koruduğumuzu öğrenin

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Yer imini sil
# Bookmark is a verb here.
newtab-menu-bookmark = Yer imlerine ekle

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = İndirme bağlantısını kopyala
newtab-menu-go-to-download-page = İndirme sayfasına git
newtab-menu-remove-download = Geçmişten kaldır

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Finder’da göster
       *[other] Bulunduğu klasörü aç
    }
newtab-menu-open-file = Dosyayı aç

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Ziyaret etmiştiniz
newtab-label-bookmarked = Yer imlerinizde
newtab-label-removed-bookmark = Yer imi silindi
newtab-label-recommended = Popüler
newtab-label-saved = { -pocket-brand-name }’a kaydedildi
newtab-label-download = İndirildi

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Sponsorlu

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = { $sponsor } sponsorluğunda

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Bölümü sil
newtab-section-menu-collapse-section = Bölümü daralt
newtab-section-menu-expand-section = Bölümü genişlet
newtab-section-menu-manage-section = Bölümü yönet
newtab-section-menu-manage-webext = Eklentiyi yönet
newtab-section-menu-add-topsite = Sık kullanılan site ekle
newtab-section-menu-add-search-engine = Arama motoru ekle
newtab-section-menu-move-up = Yukarı taşı
newtab-section-menu-move-down = Aşağı taşı
newtab-section-menu-privacy-notice = Gizlilik bildirimi

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Bölümü daralt
newtab-section-expand-section-label =
    .aria-label = Bölümü genişlet

## Section Headers.

newtab-section-header-topsites = Sık Kullanılan Siteler
newtab-section-header-highlights = Öne Çıkanlar
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = { $provider } öneriyor

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Gezinmeye başlayın. Son zamanlarda baktığınız veya yer imlerinize eklediğiniz bazı güzel makaleleri, videoları ve diğer sayfaları burada göstereceğiz.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Hepsini bitirdiniz. Yeni { $provider } haberleri için daha fazla yine gelin. Beklemek istemiyor musunuz? İlginç yazılara ulaşmak için popüler konulardan birini seçebilirsiniz.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Hepsini bitirdiniz!
newtab-discovery-empty-section-topstories-content = Daha fazla yazı için daha sonra yine gelin.
newtab-discovery-empty-section-topstories-try-again-button = Tekrar dene
newtab-discovery-empty-section-topstories-loading = Yükleniyor…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Hata! Bu bölüm tam olarak yüklenemedi.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Popüler konular:
newtab-pocket-more-recommendations = Daha fazla öneri
newtab-pocket-learn-more = Daha fazla bilgi al
newtab-pocket-cta-button = { -pocket-brand-name }’ı edinin
newtab-pocket-cta-text = Sevdiğiniz yazıları { -pocket-brand-name }’a kaydedin, aklınız okumaya değer şeylerle doldurun.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Bu içerik yüklenirken bir hata oluştu.
newtab-error-fallback-refresh-link = Yeniden denemek için sayfayı tazeleyin.
