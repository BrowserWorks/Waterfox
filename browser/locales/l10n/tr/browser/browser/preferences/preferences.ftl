# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Web sitelerine izlenmek istemediğimi bildiren “Do Not Track” sinyalini gönder
do-not-track-learn-more = Daha fazla bilgi al
do-not-track-option-default-content-blocking-known =
    .label = Yalnızca { -brand-short-name } bilinen takipçileri engellemeye ayarlandığında
do-not-track-option-always =
    .label = Her zaman
pref-page-title =
    { PLATFORM() ->
        [windows] Seçenekler
       *[other] Tercihler
    }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Seçeneklerde ara
           *[other] Tercihlerde ara
        }
managed-notice = Tarayıcınız kuruluşunuz tarafından yönetiliyor.
pane-general-title = Genel
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Giriş Sayfası
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Arama
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Gizlilik ve Güvenlik
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-experimental-title = { -brand-short-name } Deneyleri
category-experimental =
    .tooltiptext = { -brand-short-name } Deneyleri
pane-experimental-subtitle = Dikkatli olun
pane-experimental-search-results-header = { -brand-short-name } deneyleri: dikkatli olun
pane-experimental-description = Gelişmiş yapılandırma tercihlerini değiştirmek { -brand-short-name } performansını veya güvenliğini etkileyebilir.
help-button-label = { -brand-short-name } Desteği
addons-button-label = Eklentiler ve Temalar
focus-search =
    .key = f
close-button =
    .aria-label = Kapat

## Browser Restart Dialog

feature-enable-requires-restart = Bu özelliği etkinleştirmek için { -brand-short-name } yeniden başlatılmalıdır.
feature-disable-requires-restart = Bu özelliği devre dışı bırakmak { -brand-short-name } için yeniden başlatılmalıdır.
should-restart-title = { -brand-short-name } tarayıcısını yeniden başlat
should-restart-ok = { -brand-short-name } tarayıcısını yeniden başlat
cancel-no-restart-button = Vazgeç
restart-later = Daha sonra yeniden başlat

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = Giriş sayfanızı <img data-l10n-name="icon"/> { $name } adlı eklenti yönetiyor.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Yeni Sekme sayfanızı <img data-l10n-name="icon"/> { $name } adlı eklenti yönetiyor.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Bu ayarı <img data-l10n-name="icon"/> { $name } adlı eklenti yönetiyor.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Bu ayarı <img data-l10n-name="icon"/> { $name } adlı eklenti kontrol ediyor.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = <img data-l10n-name="icon"/> { $name } eklentisi varsayılan arama motorunuzu değiştirdi.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = <img data-l10n-name="icon"/> { $name } eklentisi kapsayıcı sekmelere ihtiyaç duyuyor.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Bu ayarı <img data-l10n-name="icon"/> { $name } adlı eklenti yönetiyor.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = { -brand-short-name } tarayıcınızın internete nasıl bağlanacağını <img data-l10n-name="icon"/> { $name } adlı eklenti kontrol ediyor.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Eklentiyi etkinleştirmek için <img data-l10n-name="menu-icon"/> menüdeki <img data-l10n-name="addons-icon"/> Eklentiler bölümüne gidin.

## Preferences UI Search Results

search-results-header = Arama sonuçları
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Kusura bakmayın, seçeneklerde “<span data-l10n-name="query"></span>” ile ilgili bir sonuç bulamadık.
       *[other] Kusura bakmayın, tercihlerde “<span data-l10n-name="query"></span>” ile ilgili bir sonuç bulamadık.
    }
search-results-help-link = Yardım mı gerekiyor? <a data-l10n-name="url">{ -brand-short-name } Destek</a>’i ziyaret edin.

## General Section

startup-header = Başlangıç
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = { -brand-short-name } ve Firefox’un aynı anda çalışmasına izin ver
use-firefox-sync = İpucu: Bu ayarda farklı profiller kullanılır. Tarayıcılar arasında veri paylaşmak için { -sync-brand-short-name }’i kullanın.
get-started-not-logged-in = { -sync-brand-short-name }’e giriş yap…
get-started-configured = { -sync-brand-short-name } tercihlerini aç
always-check-default =
    .label = Varsayılan tarayıcımın { -brand-short-name } olup olmadığını her zaman denetle
    .accesskey = H
is-default = { -brand-short-name } şu anda varsayılan tarayıcınız
is-not-default = { -brand-short-name } varsayılan tarayıcınız değil
set-as-my-default-browser =
    .label = Varsayılan yap…
    .accesskey = a
startup-restore-previous-session =
    .label = Önceki oturumu geri yükle
    .accesskey = o
startup-restore-warn-on-quit =
    .label = Tarayıcıdan çıkarken beni uyar
disable-extension =
    .label = Eklentiyi etkisizleştir
tabs-group-header = Sekmeler
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab, sekmeler arasında son kullanıldıkları sırayla atlasın
    .accesskey = T
open-new-link-as-tabs =
    .label = Bağlantıları yeni pencere yerine yeni sekmede aç
    .accesskey = B
warn-on-close-multiple-tabs =
    .label = Birden fazla sekmeyi kapatırken beni uyar
    .accesskey = m
warn-on-open-many-tabs =
    .label = Birden çok sekme açmanın { -brand-short-name } uygulamasını yavaşlatabileceği durumlarda beni uyar
    .accesskey = k
switch-links-to-new-tabs =
    .label = Bir bağlantıyı yeni sekmede açtığımda hemen o sekmeye geç
    .accesskey = B
show-tabs-in-taskbar =
    .label = Sekme ön izlemelerini Windows görev çubuğunda göster
    .accesskey = ö
browser-containers-enabled =
    .label = Kapsayıcı sekmeleri etkinleştir
    .accesskey = K
browser-containers-learn-more = Daha fazla bilgi al
browser-containers-settings =
    .label = Ayarlar…
    .accesskey = A
containers-disable-alert-title = Tüm kapsayıcı sekmeler kapatılsın mı?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Kapsayıcı Sekmeler’i şimdi devre dışı bırakırsanız { $tabCount } kapsayıcı sekme kapatılacaktır. Bu özelliği devre dışı bırakmak istediğinizden emin misiniz?
       *[other] Kapsayıcı Sekmeler’i şimdi devre dışı bırakırsanız { $tabCount } kapsayıcı sekme kapatılacaktır. Bu özelliği devre dışı bırakmak istediğinizden emin misiniz?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] { $tabCount } kapsayıcı sekmeyi kapat
       *[other] { $tabCount } kapsayıcı sekmeyi kapat
    }
containers-disable-alert-cancel-button = Vazgeç
containers-remove-alert-title = Bu kapsayıcı silinsin mi?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Bu kapsayıcıyı şimdi silerseniz { $count } kapsayıcı sekmesi kapanacaktır. Kapsayıcıyı silmek istediğinizden emin misiniz?
       *[other] Bu kapsayıcıyı şimdi silerseniz { $count } kapsayıcı sekmesi kapanacaktır. Kapsayıcıyı silmek istediğinizden emin misiniz?
    }
containers-remove-ok-button = Kapsayıcıyı sil
containers-remove-cancel-button = Kapsayıcıyı silme

## General Section - Language & Appearance

language-and-appearance-header = Dil ve görünüm
fonts-and-colors-header = Yazı tipleri ve renkler
default-font = Varsayılan yazı tipi
    .accesskey = t
default-font-size = Boyut
    .accesskey = B
advanced-fonts =
    .label = Gelişmiş…
    .accesskey = G
colors-settings =
    .label = Renkler…
    .accesskey = R
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Yakınlaştırma
preferences-default-zoom = Varsayılan yakınlaştırma
    .accesskey = m
preferences-default-zoom-value =
    .label = %{ $percentage }
preferences-zoom-text-only =
    .label = Sadece metni yakınlaştır
    .accesskey = t
language-header = Dil
choose-language-description = Sayfaları hangi dilde görmeyi tercih ettiğinizi seçin
choose-button =
    .label = Seç…
    .accesskey = S
choose-browser-language-description = { -brand-short-name } menülerini, iletilerini ve bildirimlerini gösterirken kullanılacak dilleri seçin.
manage-browser-languages-button =
    .label = Alternatifleri ayarla…
    .accesskey = l
confirm-browser-language-change-description = Bu değişiklikleri uygulamak için { -brand-short-name } tarayıcısını yeniden başlatın
confirm-browser-language-change-button = Uygula ve yeniden başlat
translate-web-pages =
    .label = Web içeriğini çevir
    .accesskey = W
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Çeviriler: <img data-l10n-name="logo"/>
translate-exceptions =
    .label = İstisnalar…
    .accesskey = s
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Tarih, saat, sayı ve ölçüleri biçimlendirmek için “{ $localeName }” işletim sistemi ayarlarımı kullan
check-user-spelling =
    .label = Yazarken yazım denetimi yap
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = Dosyalar ve uygulamalar
download-header = İndirme
download-save-to =
    .label = Dosya kayıt yeri
    .accesskey = a
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Seç…
           *[other] Gözat…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] z
        }
download-always-ask-where =
    .label = Dosyaların nereye kaydedileceğini her zaman sor
    .accesskey = o
applications-header = Uygulamalar
applications-description = { -brand-short-name } tarayıcısının Web’den indirdiğiniz dosyaları veya Web’de gezinirken kullandığınız uygulamaları nasıl ele alacağını seçin.
applications-filter =
    .placeholder = Dosya türlerinde ve uygulamalarda ara
applications-type-column =
    .label = İçerik türü
    .accesskey = t
applications-action-column =
    .label = Eylem
    .accesskey = E
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } dosyası
applications-action-save =
    .label = Dosyayı kaydet
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = { $app-name } kullanılsın
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = { $app-name } kullanılsın (varsayılan)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Varsayılan macOS uygulamasını kullan
            [windows] Varsayılan Windows uygulamasını kullan
           *[other] Varsayılan sistem uygulamasını kullan
        }
applications-use-other =
    .label = Başkasını kullan…
applications-select-helper = Yardımcı uygulamayı seçin
applications-manage-app =
    .label = Uygulama ayrıntıları…
applications-always-ask =
    .label = Her zaman sor
applications-type-pdf = Taşınabilir Belge Biçimi (PDF)
# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })
# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = { $plugin-name } kullan ({ -brand-short-name } içinde)
applications-open-inapp =
    .label = { -brand-short-name } ile aç

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = Sayısal Hak Yönetimi (DRM) içerikleri
play-drm-content =
    .label = DRM denetimli içerikleri oynat
    .accesskey = D
play-drm-content-learn-more = Daha fazla bilgi al
update-application-title = { -brand-short-name } güncellemeleri
update-application-description = En yüksek performans, güvenilirlik ve güvenlik için { -brand-short-name } tarayıcınızı güncel tutmalısınız.
update-application-version = Sürüm { $version } <a data-l10n-name="learn-more">Yeni neler var?</a>
update-history =
    .label = Güncelleme geçmişini göster…
    .accesskey = c
update-application-allow-description = { -brand-short-name } güncellemeleri
update-application-auto =
    .label = Otomatik olarak yüklensin (Önerilir)
    .accesskey = O
update-application-check-choose =
    .label = Denetlensin ama yükleme kararı bana bırakılsın
    .accesskey = D
update-application-manual =
    .label = Hiçbir zaman denetlenmesin (Önerilmez)
    .accesskey = H
update-application-warning-cross-user-setting = Bu ayar, bu { -brand-short-name } kurulumunu kullanan tüm Windows hesaplarına ve { -brand-short-name } profillerine uygulanacaktır.
update-application-use-service =
    .label = Güncellemeleri yüklemek için arka plan hizmetini kullan
    .accesskey = h
update-setting-write-failure-title = Güncelleme tercihlerini kaydetmede hata
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } bir hatayla karşılaştı ve bu değişikliği kaydetmedi. Bu güncelleme tercihinin ayarlanması için aşağıdaki dosyaya yazma izninizin olması gerekir. Siz veya sistem yöneticiniz bu dosya için Kullanıcılar grubuna tam denetim vererek hatayı giderebilirsiniz.
    
    Dosyaya yazılamadı: { $path }
update-in-progress-title = Güncelleme sürüyor
update-in-progress-message = { -brand-short-name } bu güncellemeyi uygulamaya devam etsin mi?
update-in-progress-ok-button = &Vazgeç
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Devam et

## General Section - Performance

performance-title = Performans
performance-use-recommended-settings-checkbox =
    .label = Önerilen performans ayarlarını kullan
    .accesskey = Ö
performance-use-recommended-settings-desc = Bu ayarlar bilgisayarınızın donanımına ve işletim sistemine göre seçilmiştir.
performance-settings-learn-more = Daha fazla bilgi al
performance-allow-hw-accel =
    .label = Mümkün olduğunda donanım ivmelenmesini kullan
    .accesskey = d
performance-limit-content-process-option = İçerik işlemi sınırı
    .accesskey = L
performance-limit-content-process-enabled-desc = Daha fazla içerik işlemine izin verdiğinizde, çok sayıda sekme açıkken performans artar ama daha fazla bellek kullanılır.
performance-limit-content-process-blocked-desc = İçerik işlemi sayısını değiştirmek yalnızca çok işlemli { -brand-short-name } ile mümkündür. <a data-l10n-name="learn-more">Çok işlemin etkin olmadığını kontrol etmeyi öğrenin</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (varsayılan)

## General Section - Browsing

browsing-title = Gezinti
browsing-use-autoscroll =
    .label = Otomatik kaydırmayı kullan
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = Akıcı kaydırmayı kullan
    .accesskey = c
browsing-use-onscreen-keyboard =
    .label = Gerektiğinde dokunmatik klavyeyi göster
    .accesskey = k
browsing-use-cursor-navigation =
    .label = Sayfaların içinde hareket etmek için her zaman ok tuşlarını kullan
    .accesskey = S
browsing-search-on-start-typing =
    .label = Yazmaya başlar başlamaz arama yap
    .accesskey = z
browsing-picture-in-picture-toggle-enabled =
    .label = Görüntü içinde görüntü video düğmelerini etkinleştir
    .accesskey = G
browsing-picture-in-picture-learn-more = Daha fazla bilgi al
browsing-cfr-recommendations =
    .label = Gezinirken yeni eklentiler öner
    .accesskey = G
browsing-cfr-features =
    .label = Gezinirken yeni özellikler öner
    .accesskey = z
browsing-cfr-recommendations-learn-more = Daha fazla bilgi al

## General Section - Proxy

network-settings-title = Ağ ayarları
network-proxy-connection-description = { -brand-short-name } tarayıcınızın internete nasıl bağlanacağını yapılandırın.
network-proxy-connection-learn-more = Daha fazla bilgi al
network-proxy-connection-settings =
    .label = Ayarlar…
    .accesskey = A

## Home Section

home-new-windows-tabs-header = Yeni pencere ve sekmeler
home-new-windows-tabs-description2 = Giriş sayfanızı, yeni pencereleri ve yeni sekmeleri açtığınızda ne görmek istediğinizi seçin.

## Home Section - Home Page Customization

home-homepage-mode-label = Giriş sayfası ve yeni pencereler
home-newtabs-mode-label = Yeni sekmeler
home-restore-defaults =
    .label = Varsayılanları geri yükle
    .accesskey = R
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Firefox giriş sayfası (varsayılan)
home-mode-choice-custom =
    .label = Özel adresler…
home-mode-choice-blank =
    .label = Boş sayfa
home-homepage-custom-url =
    .placeholder = Adres yapıştır…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Geçerli sayfayı kullan
           *[other] Geçerli sayfaları kullan
        }
    .accesskey = s
choose-bookmark =
    .label = Yer imi kullan…
    .accesskey = m

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Firefox giriş sayfası içeriği
home-prefs-content-description = Firefox giriş sayfasında görmek istediğiniz içerikleri seçin.
home-prefs-search-header =
    .label = Web araması
home-prefs-topsites-header =
    .label = Sık kullanılan siteler
home-prefs-topsites-description = En çok ziyaret ettiğiniz siteler

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = { $provider } öneriyor
home-prefs-recommended-by-description-update = { $provider } tarafından seçilen harika içerikler

##

home-prefs-recommended-by-learn-more = Nasıl çalışır?
home-prefs-recommended-by-option-sponsored-stories =
    .label = Sponsorlu haberler
home-prefs-highlights-header =
    .label = Öne çıkanlar
home-prefs-highlights-description = Kaydettiğiniz ve ziyaret ettiğiniz sitelerin bir seçkisi
home-prefs-highlights-option-visited-pages =
    .label = Ziyaret ettiğim sayfalar
home-prefs-highlights-options-bookmarks =
    .label = Yer imleri
home-prefs-highlights-option-most-recent-download =
    .label = Son indirme
home-prefs-highlights-option-saved-to-pocket =
    .label = { -pocket-brand-name }’a kaydettiğim sayfalar
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Duyurular
home-prefs-snippets-description = { -vendor-short-name } ve { -brand-product-name }’tan haberler
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } satır
           *[other] { $num } satır
        }

## Search Section

search-bar-header = Arama çubuğu
search-bar-hidden =
    .label = Hem arama hem de gezinti için adres çubuğunu kullan
search-bar-shown =
    .label = Araç çubuğuna arama çubuğunu ekle
search-engine-default-header = Varsayılan arama motoru
search-engine-default-desc-2 = Bu, adres çubuğundaki ve arama çubuğundaki varsayılan arama motorunuzdur. İstediğiniz zaman değiştirebilirsiniz.
search-engine-default-private-desc-2 = Yalnızca gizli pencerelerde kullanmak istediğiniz arama motorunu seçin
search-separate-default-engine =
    .label = Gizli pencerelerde bu arama motorunu kullan
    .accesskey = G
search-suggestions-header = Arama önerileri
search-suggestions-desc = Arama motorlarından gelen önerilerin nasıl görüneceğini seçin.
search-suggestions-option =
    .label = Arama önerileri sun
    .accesskey = ö
search-show-suggestions-url-bar-option =
    .label = Adres çubuğu sonuçlarında arama önerilerini göster
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Adres çubuğu sonuçlarında arama önerilerini gezinti geçmişinden önce göster
search-show-suggestions-private-windows =
    .label = Gizli pencerelerde arama önerilerini göster
suggestions-addressbar-settings-generic = Diğer adres çubuğu önerileri için tercihleri değiştir
search-suggestions-cant-show = { -brand-short-name } tarayıcısını geçmişi hatırlamayacak şekilde ayarladığınız için konum çubuğu sonuçlarında arama önerileri gösterilmeyecektir.
search-one-click-header = Tek tıklamalı arama motorları
search-one-click-desc = Anahtar kelimeleri yazmaya başladığınızda adres çubuğunun ve arama çubuğunun altında görünecek alternatif arama motorlarını seçin.
search-choose-engine-column =
    .label = Arama motoru
search-choose-keyword-column =
    .label = Anahtar kelime
search-restore-default =
    .label = Varsayılan arama motorlarını geri yükle
    .accesskey = V
search-remove-engine =
    .label = Kaldır
    .accesskey = K
search-add-engine =
    .label = Ekle
    .accesskey = E
search-find-more-link = Daha fazla arama motoru bul
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Tekrarlanan Anahtar Kelime
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Şu anda “{ $name }” tarafından kullanılan bir anahtar kelime seçtiniz. Lütfen başka bir şey seçin.
search-keyword-warning-bookmark = Şu anda bir yer imi tarafından kullanılan bir anahtar kelime seçtiniz. Lütfen başka bir şey seçin.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Seçeneklere geri dön
           *[other] Tercihlere geri dön
        }
containers-header = Kapsayıcı sekmeler
containers-add-button =
    .label = Yeni kapsayıcı ekle
    .accesskey = e
containers-new-tab-check =
    .label = Her yeni sekme için kapsayıcı seç
    .accesskey = H
containers-preferences-button =
    .label = Tercihler
containers-remove-button =
    .label = Sil

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Web’inizi yanınızda taşıyın
sync-signedout-description = Yer imlerinizi, geçmişinizi, sekmelerinizi, eklentilerinizi ve tercihlerinizi tüm cihazlarınız arasında senkronize edin.
sync-signedout-account-signin2 =
    .label = { -sync-brand-short-name }’e giriş yap…
    .accesskey = r
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Mobil cihazınızla eşitleme yapmak isterseniz <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> veya <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> için Firefox’u indirin.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Profil resmini değiştir
sync-sign-out =
    .label = Çıkış yap…
    .accesskey = k
sync-manage-account = Hesabı yönet
    .accesskey = H
sync-signedin-unverified = { $email } doğrulanmamış.
sync-signedin-login-failure = Yeniden { $email } hesabınıza bağlanmak için lütfen giriş yapın
sync-resend-verification =
    .label = Doğrulamayı yeniden gönder
    .accesskey = d
sync-remove-account =
    .label = Hesabı kaldır
    .accesskey = H
sync-sign-in =
    .label = Giriş yap
    .accesskey = G

## Sync section - enabling or disabling sync.

prefs-syncing-on = Eşitleme: AÇIK
prefs-syncing-off = Eşitleme: KAPALI
prefs-sync-setup =
    .label = { -sync-brand-short-name }’i kur…
    .accesskey = S
prefs-sync-offer-setup-label = Yer imlerinizi, geçmişinizi, sekmelerinizi, eklentilerinizi ve tercihlerinizi tüm cihazlarınız arasında senkronize edin.
prefs-sync-now =
    .labelnotsyncing = Şimdi eşitle
    .accesskeynotsyncing = m
    .labelsyncing = Eşitleniyor…

## The list of things currently syncing.

sync-currently-syncing-heading = Şu anda aşağıdaki öğeleri eşitliyorsunuz:
sync-currently-syncing-bookmarks = Yer imleri
sync-currently-syncing-history = Geçmiş
sync-currently-syncing-tabs = Açık sekmeler
sync-currently-syncing-logins-passwords = Hesaplar ve parolalar
sync-currently-syncing-addresses = Adresler
sync-currently-syncing-creditcards = Kredi kartları
sync-currently-syncing-addons = Eklentiler
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Seçenekler
       *[other] Tercihler
    }
sync-change-options =
    .label = Değiştir…
    .accesskey = D

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Nelerin eşitleneceğini seçin
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Değişiklikleri kaydet
    .buttonaccesskeyaccept = D
    .buttonlabelextra2 = Bağlantıyı kes…
    .buttonaccesskeyextra2 = B
sync-engine-bookmarks =
    .label = Yer imleri
    .accesskey = m
sync-engine-history =
    .label = Geçmiş
    .accesskey = G
sync-engine-tabs =
    .label = Açık sekmeler
    .tooltiptext = Eşitlenen tüm cihazlarınızdaki açık sekmelerin listesi
    .accesskey = s
sync-engine-logins-passwords =
    .label = Hesaplar ve parolalar
    .tooltiptext = Kaydettiğiniz kullanıcı adları ve parolalar
    .accesskey = H
sync-engine-addresses =
    .label = Adresler
    .tooltiptext = Kaydettiğiniz posta adresleri (yalnızca masaüstü)
    .accesskey = A
sync-engine-creditcards =
    .label = Kredi kartları
    .tooltiptext = Adlar, numaralar ve son kullanma tarihleri (yalnızca masaüstü)
    .accesskey = K
sync-engine-addons =
    .label = Eklentiler
    .tooltiptext = Masaüstü Firefox eklentileri ve temaları
    .accesskey = t
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Seçenekler
           *[other] Tercihler
        }
    .tooltiptext = Değiştirdiğiniz Genel, Gizlilik ve Güvenlik ayarları
    .accesskey = e

## The device name controls.

sync-device-name-header = Cihaz adı
sync-device-name-change =
    .label = Cihaz adını değiştir…
    .accesskey = C
sync-device-name-cancel =
    .label = İptal
    .accesskey = t
sync-device-name-save =
    .label = Kaydet
    .accesskey = K
sync-connect-another-device = Başka bir cihaz bağla

## Privacy Section

privacy-header = Tarayıcı gizliliği

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Hesaplar ve parolalar
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Sitelerdeki kullanıcı adı ve parolalarımı kaydetmeyi öner
    .accesskey = r
forms-exceptions =
    .label = İstisnalar…
    .accesskey = s
forms-generate-passwords =
    .label = Güçlü parolalar öner ve oluştur
    .accesskey = G
forms-breach-alerts =
    .label = Veri ihlaline uğrayan sitelerdeki parolalarla ilgili uyarı göster
    .accesskey = V
forms-breach-alerts-learn-more-link = Daha fazla bilgi al
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Kullanıcı adı ve parolaları otomatik doldur
    .accesskey = ı
forms-saved-logins =
    .label = Kayıtlı hesaplar…
    .accesskey = K
forms-master-pw-use =
    .label = Ana parola kullan
    .accesskey = n
forms-primary-pw-use =
    .label = Ana parola kullan
    .accesskey = n
forms-primary-pw-learn-more-link = Daha fazla bilgi al
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Ana parolayı değiştir…
    .accesskey = d
forms-master-pw-fips-title = Şu anda FIPS kipindesiniz. FIPS için boş olmayan bir ana parola gerekli.
forms-primary-pw-change =
    .label = Ana parolayı değiştir…
    .accesskey = d
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Şu anda FIPS kipindesiniz. FIPS için boş olmayan bir ana parola gereklidir.
forms-master-pw-fips-desc = Parola değiştirme başarısız

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Ana parola oluşturmak için Windows hesap bilgilerinizi girin. Bu sayede hesaplarınızı daha güvenli bir şekilde koruyabiliriz.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = ana parola oluşturma
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Ana parola oluşturmak için Windows hesap bilgilerinizi girin. Bu sayede hesaplarınızı daha güvenli bir şekilde koruyabiliriz.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = ana parola oluşturma
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Geçmiş
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name }
    .accesskey = i
history-remember-option-all =
    .label = geçmişi hatırlasın
history-remember-option-never =
    .label = geçmişi asla hatırlamasın
history-remember-option-custom =
    .label = geçmiş için özel ayarları kullansın
history-remember-description = { -brand-short-name } gezinti, indirme, form ve arama geçmişlerinizi hatırlayacak.
history-dontremember-description = { -brand-short-name } Gizli Gezinti ile aynı ayarları kullanacak ve siz internette gezerken geçmişle ilgili hiçbir şeyi hatırlamayacak.
history-private-browsing-permanent =
    .label = Her zaman gizli gezinti kipini kullan
    .accesskey = m
history-remember-browser-option =
    .label = Tarama ve indirme geçmişini hatırla
    .accesskey = T
history-remember-search-option =
    .label = Arama ve form geçmişini hatırla
    .accesskey = f
history-clear-on-close-option =
    .label = { -brand-short-name } kapatılınca geçmişi temizle
    .accesskey = e
history-clear-on-close-settings =
    .label = Ayarlar…
    .accesskey = A
history-clear-button =
    .label = Geçmişi temizle…
    .accesskey = G

## Privacy Section - Site Data

sitedata-header = Çerezler ve site verileri
sitedata-total-size-calculating = Site verilerinin ve önbelleğin boyutu hesaplanıyor…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Depolanmış site verileriniz ve önbelleğiniz şu anda { $value } { $unit } disk alanı kullanıyor.
sitedata-learn-more = Daha fazla bilgi al
sitedata-delete-on-close =
    .label = { -brand-short-name } kapatıldığında çerezleri ve site verilerini sil
    .accesskey = k
sitedata-delete-on-close-private-browsing = Kalıcı gizli gezinti modunda, { -brand-short-name } kapatıldığında çerezler ve site verileri her zaman silinir.
sitedata-allow-cookies-option =
    .label = Çerezleri ve site verilerini kabul et
    .accesskey = z
sitedata-disallow-cookies-option =
    .label = Çerezleri ve site verilerini engelle
    .accesskey = s
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Engellenecek tür
    .accesskey = ü
sitedata-option-block-cross-site-trackers =
    .label = Siteler arası takipçiler
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Siteler arası takipçiler ve sosyal medya takipçileri
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Siteler arası takipçiler ve sosyal medya takipçileri, kalan çerezleri izole et
sitedata-option-block-unvisited =
    .label = Ziyaret etmediğim sitelerden gelen çerezler
sitedata-option-block-all-third-party =
    .label = Tüm üçüncü taraf çerezleri (Bazı siteler bozulabilir.)
sitedata-option-block-all =
    .label = Tüm çerezler (Bazı siteler bozulabilir.)
sitedata-clear =
    .label = Verileri temizle…
    .accesskey = l
sitedata-settings =
    .label = Verileri yönet…
    .accesskey = V
sitedata-cookies-permissions =
    .label = İzinleri yönet…
    .accesskey = z
sitedata-cookies-exceptions =
    .label = İstisnaları yönet…
    .accesskey = İ

## Privacy Section - Address Bar

addressbar-header = Adres çubuğu
addressbar-suggest = Adres çubuğunu kullanırken şunları öner:
addressbar-locbar-history-option =
    .label = Gezinti geçmişi
    .accesskey = G
addressbar-locbar-bookmarks-option =
    .label = Yer imleri
    .accesskey = Y
addressbar-locbar-openpage-option =
    .label = Açık sekmeler
    .accesskey = s
addressbar-locbar-topsites-option =
    .label = Sık kullanılanlar
    .accesskey = S
addressbar-suggestions-settings = Arama motoru önerileri için tercihleri değiştir

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Gelişmiş izlenme koruması
content-blocking-section-top-level-description = Takipçiler, gezinti alışkanlıklarınız ve ilgi alanlarınız hakkında bilgi toplamak için internette sizi takip eder. { -brand-short-name } bu takipçilerin ve diğer kötü amaçlı betiklerin çoğunu engeller.
content-blocking-learn-more = Daha fazla bilgi al

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standart
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Sıkı
    .accesskey = S
enhanced-tracking-protection-setting-custom =
    .label = Özel
    .accesskey = Ö

##

content-blocking-etp-standard-desc = Dengeli koruma ve performans. Sayfalar normal şekilde yüklenir.
content-blocking-etp-strict-desc = Daha güçlü koruma, ama bazı siteler ve içerikler düzgün çalışmayabilir.
content-blocking-etp-custom-desc = Hangi takipçilerin ve betiklerin engelleneceğini seçin.
content-blocking-private-windows = Gizli pencelerde takip amaçlı içerikler
content-blocking-cross-site-tracking-cookies = Siteler arası takip çerezleri
content-blocking-cross-site-tracking-cookies-plus-isolate = Siteler arası takipçiler ve takip çerezleri, kalan çerezleri izole et
content-blocking-social-media-trackers = Sosyal medya takipçileri
content-blocking-all-cookies = Tüm çerezler
content-blocking-unvisited-cookies = Ziyaret etmediğim sitelerden gelen çerezler
content-blocking-all-windows-tracking-content = Tüm pencerelerde takip amaçlı içerikler
content-blocking-all-third-party-cookies = Tüm üçüncü taraf çerezlerini engeller
content-blocking-cryptominers = Kripto madencileri
content-blocking-fingerprinters = Parmak izi toplayıcılar
content-blocking-warning-title = Dikkat!
content-blocking-and-isolating-etp-warning-description = Takipçileri engellemek ve çerezleri izole etmek bazı sitelerin düzgün çalışmamasına yol açabilir. Takipçi içeren bir sayfanın tüm içeriğini yüklemek için sayfayı tazeleyin.
content-blocking-warning-learn-how = Nasıl yapılacağını öğrenin
content-blocking-reload-description = Bu değişiklikleri uygulamak için sekmelerinizi tazelemeniz gerekiyor.
content-blocking-reload-tabs-button =
    .label = Sekmeleri tazele
    .accesskey = S
content-blocking-tracking-content-label =
    .label = Takip amaçlı içerikler
    .accesskey = T
content-blocking-tracking-protection-option-all-windows =
    .label = Tüm pencerelerde
    .accesskey = m
content-blocking-option-private =
    .label = Yalnızca gizli pencerelerde
    .accesskey = z
content-blocking-tracking-protection-change-block-list = Engelleme listesini değiştir
content-blocking-cookies-label =
    .label = Çerezler
    .accesskey = e
content-blocking-expand-section =
    .tooltiptext = Daha fazla bilgi
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Kripto madencileri
    .accesskey = m
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Parmak izi toplayıcılar
    .accesskey = P

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = İstisnaları yönet…
    .accesskey = n

## Privacy Section - Permissions

permissions-header = İzinler
permissions-location = Konum
permissions-location-settings =
    .label = Ayarlar…
    .accesskey = r
permissions-xr = Sanal gerçeklik
permissions-xr-settings =
    .label = Ayarlar…
    .accesskey = A
permissions-camera = Kamera
permissions-camera-settings =
    .label = Ayarlar…
    .accesskey = r
permissions-microphone = Mikrofon
permissions-microphone-settings =
    .label = Ayarlar…
    .accesskey = r
permissions-notification = Bildirimler
permissions-notification-settings =
    .label = Ayarlar…
    .accesskey = r
permissions-notification-link = Daha fazla bilgi al
permissions-notification-pause =
    .label = { -brand-short-name } yeniden başlatılana dek bildirimleri duraklat
    .accesskey = b
permissions-autoplay = Otomatik oynatma
permissions-autoplay-settings =
    .label = Ayarlar…
    .accesskey = r
permissions-block-popups =
    .label = Açılır pencereleri engelle
    .accesskey = n
permissions-block-popups-exceptions =
    .label = İstisnalar…
    .accesskey = a
permissions-addon-install-warning =
    .label = Siteler eklenti yüklemeye çalıştığında beni uyar
    .accesskey = u
permissions-addon-exceptions =
    .label = İstisnalar…
    .accesskey = n
permissions-a11y-privacy-checkbox =
    .label = Erişilebilirlik hizmetlerinin tarayıcıma erişmesini engelle
    .accesskey = E
permissions-a11y-privacy-link = Daha fazla bilgi al

## Privacy Section - Data Collection

collection-header = { -brand-short-name } veri toplama ve kullanma izinleri
collection-description = Yalnızca { -brand-short-name } tarayıcınızı geliştirmemize yarayacak verileri topluyoruz ve istemezseniz onları da toplamıyoruz. Kişisel verilerinizi sunucularımıza göndermeden önce mutlaka izninizi istiyoruz.
collection-privacy-notice = Gizlilik bildirimi
collection-health-report-telemetry-disabled = Artık { -vendor-short-name }’nın teknik veri ve etkileşim verisi toplamasına izin vermiyorsunuz. Eski verilerinizin hepsi 30 gün içinde silinecektir.
collection-health-report-telemetry-disabled-link = Daha fazla bilgi al
collection-health-report =
    .label = { -brand-short-name }, teknik ve etkileşim verilerimi { -vendor-short-name }’ya gönderebilir
    .accesskey = r
collection-health-report-link = Daha fazla bilgi al
collection-studies =
    .label = { -brand-short-name }, araştırmalar yükleyip çalıştırabilir
collection-studies-link = { -brand-short-name } araştırmalarını göster
addon-recommendations =
    .label = { -brand-short-name }, bana özel eklenti tavsiyelerinde bulunabilir
addon-recommendations-link = Daha fazla bilgi al
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Bu yapılandırma için veri raporlama devre dışı bırakılmış
collection-backlogged-crash-reports =
    .label = { -brand-short-name } geriye dönük çökme raporlarını benim adıma gönderebilir
    .accesskey = ö
collection-backlogged-crash-reports-link = Daha fazla bilgi al

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Güvenlik
security-browsing-protection = Aldatıcı içerik ve tehlikeli yazılım koruması
security-enable-safe-browsing =
    .label = Tehlikeli ve aldatıcı içerikleri engelle
    .accesskey = T
security-enable-safe-browsing-link = Daha fazla bilgi al
security-block-downloads =
    .label = Tehlikeli indirmeleri engelle
    .accesskey = i
security-block-uncommon-software =
    .label = İstenmeyen ve bilinmeyen yazılımlar hakkında beni uyar
    .accesskey = b

## Privacy Section - Certificates

certs-header = Sertifikalar
certs-personal-label = Bir sunucu kişisel sertifikamı istediğinde
certs-select-auto-option =
    .label = Birini kendiliğinden seç
    .accesskey = B
certs-select-ask-option =
    .label = Her seferinde bana sor
    .accesskey = H
certs-enable-ocsp =
    .label = Sertifikaların geçerliliğini doğrulamak için OCSP otomatik yanıt sunucularını sorgula
    .accesskey = d
certs-view =
    .label = Sertifikaları göster…
    .accesskey = ö
certs-devices =
    .label = Güvenlik aygıtları…
    .accesskey = ü
space-alert-learn-more-button =
    .label = Daha fazla bilgi al
    .accesskey = D
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Seçenekleri aç
           *[other] Tercihleri aç
        }
    .accesskey =
        { PLATFORM() ->
            [windows] S
           *[other] e
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } tarafından kulllanılabilen disk alanı azaldı. Site içerikleri düzgün görüntülenemeyebilir. Depolanan verileri Seçenekler > Gizlilik ve Güvenlik > Site verileri kısmından temizleyebilirsiniz.
       *[other] { -brand-short-name } tarafından kulllanılabilen disk alanı azaldı. Site içerikleri düzgün görüntülenemeyebilir. Depolanan verileri Tercihler > Gizlilik ve Güvenlik > Site verileri kısmından temizleyebilirsiniz.
    }
space-alert-under-5gb-ok-button =
    .label = Anladım
    .accesskey = A
space-alert-under-5gb-message = { -brand-short-name } tarafından kulllanılabilen disk alanı azaldı. Site içerikleri düzgün görüntülenemeyebilir. Daha iyi bir gezinti deneyimi içi disk kullanımınızı iyileştirmek isterseniz “Daha fazla bilgi al” sayfasını ziyaret edin.

## Privacy Section - HTTPS-Only

httpsonly-header = Yalnızca HTTPS modu
httpsonly-description = HTTPS, ziyaret ettiğiniz sitelerle { -brand-short-name } arasında güvenli ve şifrelenmiş bağlantı sağlar. Çoğu site HTTPS desteği sunar. “Yalnızca HTTPS” modunu açarsanız { -brand-short-name } tüm bağlantılarda HTTPS kullanmaya çalışır.
httpsonly-learn-more = Daha fazla bilgi al
httpsonly-radio-enabled =
    .label = Yalnızca HTTPS modunu tüm pencerelerde etkinleştir
httpsonly-radio-enabled-pbm =
    .label = Yalnızca HTTPS modunu yalnızca gizli pencerelerde etkinleştir
httpsonly-radio-disabled =
    .label = Yalnızca HTTPS modunu etkinleştirme

## The following strings are used in the Download section of settings

desktop-folder-name = Masaüstü
downloads-folder-name = İndirilenler
choose-download-folder-title = İndirme klasörünü seçin:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Dosyaları { $service-name } alanıma kaydet
