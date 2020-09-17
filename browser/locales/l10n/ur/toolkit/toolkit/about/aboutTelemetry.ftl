# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = کوائف ماخذ کو پنگ کریں
about-telemetry-show-current-data = موجودہ ڈیٹا
about-telemetry-show-archived-ping-data = محفوظہ پنگ کوائف
about-telemetry-show-subsession-data = ذیلی سیشن کوائف دکھائیں
about-telemetry-choose-ping = پنگ کا انتخاب کریں
about-telemetry-archive-ping-type = پنگ کی قسم
about-telemetry-archive-ping-header = پینگ
about-telemetry-option-group-today = آج
about-telemetry-option-group-yesterday = گزرا کل
about-telemetry-option-group-older = پرانا
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = ٹیلیمٹری کوائف
about-telemetry-current-store = موجودہ اسٹور:
about-telemetry-more-information = مزید معلومات تلاش کر رہے ہیں؟
about-telemetry-home-section = ابتدائی صفحہ
about-telemetry-general-data-section = جنرل کوائف
about-telemetry-environment-data-section = ماحولیاتی کوائف
about-telemetry-session-info-section = سیشن کی معلومات
about-telemetry-scalar-section = سکیلر
about-telemetry-keyed-scalar-section = Keyed Scalars
about-telemetry-histograms-section = ہسٹو گرام
about-telemetry-keyed-histogram-section = کلید شدہ ہسٹوگرامز
about-telemetry-events-section = واقعات
about-telemetry-simple-measurements-section = سادہ پیمائشیں
about-telemetry-slow-sql-section = سست SQL سٹیٹمنٹ
about-telemetry-addon-details-section = اضافہ تفاصیل
about-telemetry-captured-stacks-section = گرفت شدہ اسٹیک
about-telemetry-late-writes-section = دیرانہ لکھائی
about-telemetry-raw = خام JSON
about-telemetry-full-sql-warning = نوٹ: سست SQL ڈیبگنگ اہل ہے۔ نیچے پوری SQL سٹرنگز دکھائی جا سکتی ہیں لیکن یہ ٹیلیمٹری کو جمع نہیں کرائ جائیں گی۔
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] اہل کردہ
       *[disabled] نااہل کردہ
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = یہ صفحہ کارکردگی، ہارڈ ہئر اور تخصیص کاری کی معلومات دکھا رہا ہے جو کہ ٹیلیمیٹری سے جمع کیا گیا ہے۔ یہ معلومات { -brand-full-name } بہتر کرنے کے لیے { $telemetryServerOwner } میں جمع کی گئ ہے۔
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle } میں تلاش کریں
about-telemetry-filter-all-placeholder =
    .placeholder = تمام حصوں میں تلاش کریں
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = موجودہ ڈیٹا
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = تمام
# button label to copy the histogram
about-telemetry-histogram-copy = نقل
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = مین تھریڈ میں سست SQL سٹیٹمنٹیں
about-telemetry-slow-sql-other = دستگیر تھریڈ میں سست SQL سٹیٹمنٹیں
about-telemetry-slow-sql-hits = ہٹس
about-telemetry-slow-sql-average = اوسط وقت (ms)
about-telemetry-slow-sql-statement = بیان
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = اضافہ شناخت
about-telemetry-addon-table-details = تفاصیل
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } مہیا کنندہ
about-telemetry-keys-header = خاصیت
about-telemetry-names-header = نام
about-telemetry-values-header = قدر
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = دیرانہ لکھائی #{ $lateWriteCount }
about-telemetry-stack-title = سٹیک:
about-telemetry-memory-map-title = میموری نقشہ:
about-telemetry-error-fetching-symbols = علامتیں لاتے ہوئے نقص آ گیا۔ چیک کریں کی آپ انٹرنٹ سے جڑیں ہوئیں ہیں اور پھر کوشش کریں۔
about-telemetry-time-stamp-header = timestamp
about-telemetry-category-header = زمرہ
about-telemetry-method-header = طریقہ
about-telemetry-object-header = آبجیکٹ
about-telemetry-extra-header = فالتو
about-telemetry-origin-origin = اصل
about-telemetry-origin-count = گنیں
