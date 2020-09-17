# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Sumber data ping:
about-telemetry-show-archived-ping-data = Data ping diarkibkan
about-telemetry-show-subsession-data = Papar data sub-sesi
about-telemetry-choose-ping = Pilih ping:
about-telemetry-archive-ping-type = Jenis Ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Hari ini
about-telemetry-option-group-yesterday = Semalam
about-telemetry-option-group-older = Lebih lama
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Data Telemetri
about-telemetry-more-information = Mahu mencari maklumat selanjutnya?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Dokumentasi Data Firefox</a> mengandungkan panduan perihal cara menggunakan alatan data kami.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox Telemetry klien dokumentasi</a> menjelaskan takrif konsep, dokumentasi API dan rujukan data.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Papan pemuka Telemetri</a> membolehkan anda menggambarkan data yang diterima oleh Mozilla melalui Telemetri.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> menyediakan butiran dan penjelasan untuk masalah yang dikumpulkan oleh Telemetry.
about-telemetry-show-in-Firefox-json-viewer = Buka dalam pemapar JSON
about-telemetry-home-section = Laman
about-telemetry-general-data-section = Data Umum
about-telemetry-environment-data-section = Data Persekitaran
about-telemetry-session-info-section = Maklumat Sesi
about-telemetry-scalar-section = Skala
about-telemetry-keyed-scalar-section = Skala Dikunci
about-telemetry-histograms-section = Histogram
about-telemetry-keyed-histogram-section = Histogram Dikunci
about-telemetry-events-section = Acara
about-telemetry-simple-measurements-section = Pengukuran Mudah
about-telemetry-slow-sql-section = Penyata SQL Perlahan
about-telemetry-addon-details-section = Butiran Add-on
about-telemetry-captured-stacks-section = Tangkapan Stacks
about-telemetry-late-writes-section = Penulisan Lewat
about-telemetry-raw-payload-section = Muatan Mentah
about-telemetry-raw = JSON Mentah
about-telemetry-full-sql-warning = NOTA; Menyahpepijat SQL secara perlahan sedang aktif. String penuh SQL mungkin dipaparkan di bawah ini tapi tidak akan dihantar ke Telemetri.
about-telemetry-fetch-stack-symbols = Mendapatkan nama fungsi stacks
about-telemetry-hide-stack-symbols = Papar data susunan mentah
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] data keluaran
       *[prerelease] data prakeluaran
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] didayakan
       *[disabled] dinyahdayakan
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Halaman ini memaparkan informasi berkenaan dengan prestasi, perkakasan, penggunaan dan penyesuaian yang diambil oleh Telemetry. Informasi ini dihantar ke { $telemetryServerOwner } untuk membantu meningkatkan { -brand-full-name }.
about-telemetry-settings-explanation = Telemetri mengumpulkan { about-telemetry-data-type } dan muat naik adalah <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Setiap maklumat dihantar bersama ke “<a data-l10n-name="ping-link">ping</a>”. Anda sedang melihat ping { $name }, { $timestamp }.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Cari dalam { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Cari dalam semua bahagian
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Hasil untuk “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Maaf! Tiada hasil dalam { $sectionName } untuk “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Maaf! Tiada hasil dalam mana-mana bahagian untuk “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Maaf! Buat masa ini tiada data yang boleh didapati dalam “{ $sectionName }”
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = semua
# button label to copy the histogram
about-telemetry-histogram-copy = Salin
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Pernyataan SQL Perlahan dalam Thread Utama
about-telemetry-slow-sql-other = Pernyataan SQL Perlahan dalam Thread Pembantu
about-telemetry-slow-sql-hits = Hit
about-telemetry-slow-sql-average = Masa Purata (ms)
about-telemetry-slow-sql-statement = Penyata
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID Add-on
about-telemetry-addon-table-details = Butiran
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Penyedia { $addonProvider }
about-telemetry-keys-header = Sifat
about-telemetry-names-header = Nama
about-telemetry-values-header = Nilai
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (capture count: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Lewat Menulis #{ $lateWriteCount }
about-telemetry-stack-title = Tindanan:
about-telemetry-memory-map-title = Peta memori:
about-telemetry-error-fetching-symbols = Ada ralat semasa mendapatkan simbol. Pastikan anda ada sambungan Internet dan cuba sekali lagi.
about-telemetry-time-stamp-header = cap masa
about-telemetry-category-header = kategori
about-telemetry-method-header = kaedah
about-telemetry-object-header = objek
about-telemetry-extra-header = tambahan
