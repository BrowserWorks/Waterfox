# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Ping məlumatı mənbəsi:
about-telemetry-show-archived-ping-data = Arxivlənmiş ping məlumatı
about-telemetry-show-subsession-data = Alt seans məlumatlarını göstər
about-telemetry-choose-ping = Ping-i seçin
about-telemetry-archive-ping-type = Ping Növü
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Bu gün
about-telemetry-option-group-yesterday = Dünən
about-telemetry-option-group-older = Daha əvvəl
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetriya Məlumatları
about-telemetry-more-information = Ətraflı məlumat üçün baxırsınız?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox Məlumat Sənədləri</a> məlumat alətlərimizlə necə işləmək lazım olduğu haqqında yol göstərir.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox Telemetriya klient sənədlərinə</a> konsept tərifləri, API sənədləri və məlumat istinadları daxildir.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Telemetriya idarə lövhələri</a> Mozillanın Telemetriya ilə aldığı məlumatları vizuallaşdırmağınıza imkan verir.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Zond Lüğəti</a> Telemetriya tərəfindən toplanmış zondlarla əlaqədar məlumat və açıqlamaları təchiz edir.
about-telemetry-show-in-Firefox-json-viewer = JSON göstəricidə aç
about-telemetry-home-section = Ev
about-telemetry-general-data-section =   Ümumi Məlumat
about-telemetry-environment-data-section = Mühit Məlumatları
about-telemetry-session-info-section = Sessiya Məlumatı
about-telemetry-scalar-section = Skalyarlar
about-telemetry-keyed-scalar-section = Açarlı Skalyarlar
about-telemetry-histograms-section =   Histoqram
about-telemetry-keyed-histogram-section =   Açarlanmış Histogramlar
about-telemetry-events-section = Tədbirlər
about-telemetry-simple-measurements-section =   Sadə Ölçülər
about-telemetry-slow-sql-section =   Zəif SQL İfadələr
about-telemetry-addon-details-section =   Əlavə Detalları
about-telemetry-captured-stacks-section = Tutulan Dəstələr
about-telemetry-late-writes-section =   Gecikmiş Yazılar
about-telemetry-raw-payload-section = Xam yük
about-telemetry-raw = Xam JSON
about-telemetry-full-sql-warning = NOTE: Slow SQL debugging is enabled. Full SQL strings may be displayed below but they will not be submitted to Telemetry.
about-telemetry-fetch-stack-symbols = Dəstələr üçün funksiya adlarını çək
about-telemetry-hide-stack-symbols = Xam dəstə məlumatlarını göstər
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] buraxılış məlumatlarını
       *[prerelease] buraxılış öncəsi məlumatları
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] aktivdir
       *[disabled] sönülüdür
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Bu səhifə Telemetry tərəfindən toplanan məhsuldarlıq, avadanlıq, istifadə və fərdiləşdirmə məlumatlarını göstərir. Bu məlumatlar { -brand-full-name } səyyahını yaxşılaşdırmaq üçün { $telemetryServerOwner } serverlərinə göndərilir.
about-telemetry-settings-explanation = Telemetry { about-telemetry-data-type } yığır və yükləmə <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Hər bit məlumat parçası “<a data-l10n-name="ping-link">ping</a>” paketləri halında göndərilir. Hazırda { $name }, { $timestamp } ping-inə baxırsınız.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle } bölümündə tap
about-telemetry-filter-all-placeholder =
    .placeholder = Bütün bölmələrdə tap
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = “{ $searchTerms }” üçün nəticələr
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Üzr istəyirik! { $sectionName } bölümündə “{ $currentSearchText }” üçün nəticə yoxdur
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Bağışlayın! Heç bir bölmədə “{ $searchTerms }” üçün nəticə tapılmadı
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Bağışlayın! Hazırda “{ $sectionName }” bölümündə heç bir məlumat yoxdur
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = hamısı
# button label to copy the histogram
about-telemetry-histogram-copy = Köçür
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Slow SQL Statements on Main Thread
about-telemetry-slow-sql-other = Slow SQL Statements on Helper Threads
about-telemetry-slow-sql-hits = Hits
about-telemetry-slow-sql-average = Avg. Time (ms)
about-telemetry-slow-sql-statement = Statement
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Əlavənin ID-si
about-telemetry-addon-table-details = Ətraflı məlumat
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Provayder { $addonProvider }
about-telemetry-keys-header = Property
about-telemetry-names-header = Ad
about-telemetry-values-header = Dəyər
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (tutulma sayısı: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Gec Yazı #{ $lateWriteCount }
about-telemetry-stack-title = Stack:
about-telemetry-memory-map-title = Memory map:
about-telemetry-error-fetching-symbols = An error occurred while fetching symbols. Check that you are connected to the Internet and try again.
about-telemetry-time-stamp-header = vaxt möhürü
about-telemetry-category-header = kateqoriya
about-telemetry-method-header = metod
about-telemetry-object-header = obyekt
about-telemetry-extra-header = əlavə
