# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Ping verisi kaynağı:
about-telemetry-show-current-data = Güncel veriler
about-telemetry-show-archived-ping-data = Arşivlenmiş ping verileri
about-telemetry-show-subsession-data = Alt oturum verilerini göster
about-telemetry-choose-ping = Ping'i seçin:
about-telemetry-archive-ping-type = Ping türü
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Bugün
about-telemetry-option-group-yesterday = Dün
about-telemetry-option-group-older = Daha eski
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetri Verileri
about-telemetry-current-store = Geçerli depo:
about-telemetry-more-information = Daha fazla bilgi almak mı istiyorsunuz?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox Veri Belgeleri</a>, veri araçlarlarımızla nasıl çalışabileceğinize dair rehberleri içerir.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox Telemetri istemcisi belgeleri</a> kavram tanımlarını, API belgelerini ve veri referanslarını içerir.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Telemetri panoları</a> Mozilla'nın Telemetri aracılığıyla aldığı verileri görselleştirmenize olanak tanır.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Sonda sözlüğü</a> Telemetri’nin topladığı sondalarla ilgili ayrıntıları ve açıklamaları içerir.
about-telemetry-show-in-Firefox-json-viewer = JSON görüntüleyicide aç
about-telemetry-home-section = Ana Sayfa
about-telemetry-general-data-section = Genel Veriler
about-telemetry-environment-data-section = Ortam Verileri
about-telemetry-session-info-section = Oturum Bilgisi
about-telemetry-scalar-section = Değişkenler
about-telemetry-keyed-scalar-section = Anahtarlı Skalerler
about-telemetry-histograms-section = Histogramlar
about-telemetry-keyed-histogram-section = Anahtarlı Histogramlar
about-telemetry-events-section = Olaylar
about-telemetry-simple-measurements-section = Basit Ölçümler
about-telemetry-slow-sql-section = Yavaş SQL Deyimleri
about-telemetry-addon-details-section = Eklenti Ayrıntıları
about-telemetry-captured-stacks-section = Yakalanan Yığınlar
about-telemetry-late-writes-section = Geç Yazmalar
about-telemetry-raw-payload-section = Ham yük
about-telemetry-raw = Ham JSON
about-telemetry-full-sql-warning = NOT: Yavaş SQL hata ayıklaması etkin durumda. Tam SQL dizgileri aşağıdaki gösterilebilir ama Telemetri'ye gönderilmezler.
about-telemetry-fetch-stack-symbols = Yığınların fonksiyon adlarını topla
about-telemetry-hide-stack-symbols = Ham yığın verilerini göster
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] yayın verilerini
       *[prerelease] yayın öncesi verileri
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] açık
       *[disabled] kapalı
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } örnek, ortalama = { $prettyAverage }, toplam = { $sum }
       *[other] { $sampleCount } örnek, ortalama = { $prettyAverage }, toplam = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Bu sayfa; Telemetri tarafından toplanan performans, donanım, kullanım ve özelleştirme bilgilerini gösterir. Bu bilgiler { -brand-full-name } tarayıcısının gelişimine yardımcı olmaları için { $telemetryServerOwner } sunucularına gönderilir.
about-telemetry-settings-explanation = Telemetri { about-telemetry-data-type } topluyor ve veri gönderimi <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Her bilgi parçası “<a data-l10n-name="ping-link">ping</a>” paketleri halinde gönderilir. Şu anda { $name }, { $timestamp } ping’ine bakıyorsunuz.
about-telemetry-data-details-current = Her bilgi parçası  “<a data-l10n-name="ping-link">ping</a>“ denilen paketler halinde gönderilir. Şu anda güncel verilere bakıyorsunuz.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle } içinde ara
about-telemetry-filter-all-placeholder =
    .placeholder = Tüm bölümlerde ara
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = “{ $searchTerms }” sonuçları
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Kusura bakmayın, { $sectionName } içinde “{ $currentSearchText }” ile ilgili bir sonuç bulamadık
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Kusura bakmayın, hiçbir bölümde “{ $searchTerms }” ile ilgili bir sonuç bulamadık
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Kusura bakmayın, şu anda “{ $sectionName }” bölümünde hiç veri yok
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = güncel veriler
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = tümü
# button label to copy the histogram
about-telemetry-histogram-copy = Kopyala
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Ana parçacıkta yavaş SQL deyimleri
about-telemetry-slow-sql-other = Yardımcı parçacıklarda yavaş SQL deyimleri
about-telemetry-slow-sql-hits = Hit
about-telemetry-slow-sql-average = Ort. süre (ms)
about-telemetry-slow-sql-statement = Deyim
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Eklenti kimliği
about-telemetry-addon-table-details = Ayrıntılar
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } sağlayıcısı
about-telemetry-keys-header = Özellik
about-telemetry-names-header = Adı
about-telemetry-values-header = Değer
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (yakalama sayısı: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Geç yazma #{ $lateWriteCount }
about-telemetry-stack-title = Yığın:
about-telemetry-memory-map-title = Bellek haritası:
about-telemetry-error-fetching-symbols = Sembolleri getirirken bir hata oluştu. Lütfen internete bağlı olduğunuzdan emin olup, tekrar deneyin.
about-telemetry-time-stamp-header = zaman damgası
about-telemetry-category-header = kategori
about-telemetry-method-header = yöntem
about-telemetry-object-header = nesne
about-telemetry-extra-header = ekstra
about-telemetry-origin-section = Köken Telemetrisi
about-telemetry-origin-origin = köken
about-telemetry-origin-count = sayaç
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Köken Telemetrisi</a> verileri göndermeden öne şifreler. Böylece { $telemetryServerOwner } bazı şeyleri sayabilir ama hangi { -brand-product-name } tarayıcılarının bu sayıma dahil olduğunu bilemez. (<a data-l10n-name="prio-blog-link">Daha fazla bilgi alın</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } işlemi
