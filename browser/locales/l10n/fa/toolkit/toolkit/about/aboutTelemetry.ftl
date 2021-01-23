# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = منبع اطلاعات پینگ:
about-telemetry-show-archived-ping-data = بایگانی اطلاعات پینگ
about-telemetry-show-subsession-data = نمایش اطلاعات زیرنشست‌ها
about-telemetry-choose-ping = انتخاب پینگ:
about-telemetry-archive-ping-type = عنوان پینگ
about-telemetry-archive-ping-header = پینگ
about-telemetry-option-group-today = امروز
about-telemetry-option-group-yesterday = دیروز
about-telemetry-option-group-older = قدیمی
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = اطلاعات مسافت‌سنجی
about-telemetry-more-information = به دنبال اطلاعات بیشتر هستید؟
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">مستندات اطلاعات فایرفاکس</a> شامل راهنماهای بسیار زیادی در خصوص کار کردن با ابزارهای داده می باشد.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link"> مستندات Telemetry فایرفاکس برای کاربران</a> شامل تعریفات مفاهیم، مستندات و منابع API ها.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link"> داشبورد Telemetry</a> به شما این امکان را می‌دهد تا داده های دریافت شده توسط Telemetryموزیلا را تصویر کنید.
about-telemetry-show-in-Firefox-json-viewer = بازکردن در نمایشگرJSON
about-telemetry-home-section = خانه
about-telemetry-general-data-section =   اطلاعات عمومی
about-telemetry-environment-data-section = اطلاعات محیطی
about-telemetry-session-info-section = اطلاعات نشست
about-telemetry-scalar-section = عددی
about-telemetry-keyed-scalar-section = Keyed Scalars
about-telemetry-histograms-section =   نمودارهای هیستوگرام
about-telemetry-keyed-histogram-section =   نمودارهای هیستوگرام کوک شده
about-telemetry-events-section = رویدادها
about-telemetry-simple-measurements-section =   اندازه‌گیری‌های ساده
about-telemetry-slow-sql-section =   عبارات کند SQL
about-telemetry-addon-details-section =   جزئیات افزونه
about-telemetry-captured-stacks-section = پشته گرفته شده
about-telemetry-late-writes-section =   دیرنویس‌ها
about-telemetry-raw-payload-section = Payload خام
about-telemetry-raw = JSON خام
about-telemetry-full-sql-warning =   نکته: رفع‌اشکال SQLهای کُند فعال است. رشته‌های کامل SQL ممکن است در پایین نمایش داده شوند ولی آنها در مسافت‌سنج ثبت نخواهند شد.
about-telemetry-fetch-stack-symbols = دریافت نام توابع برای پشته‌ها
about-telemetry-hide-stack-symbols = نمایش داده‌های خام پشته
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] انتشار اطلاعات
       *[prerelease] قبل از انتشار اطلاعات
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] فعال شد
       *[disabled] غیرفعال شد
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = این صفحه اطلاعاتی درباره کارایی، سخت‌افزار، استفاده و سفارشی‌سازی‌های جمع‌آوری شده توسط مسافت‌سنج را نشان می‌دهد. این اطلاعات در { $telemetryServerOwner } ثبت شده است تا در بهبود { -brand-full-name } کمک کند.
about-telemetry-settings-explanation = سنجش از راه دور { about-telemetry-data-type } را ذخیره می‌کند و <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a> بارگذاری می‌کند.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = هر قطعه از این اطلاعات به همراه“<a data-l10n-name="ping-link">پینگ‌ها</a>” ارسال شده است. شما در حال نگاه کردن به پینگ { $name }, { $timestamp } هستید.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = پیدا کردن در { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = یافتن تمام بخش‌ها
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = نتایج برای “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = متاسفیم! ولی نتیجه ای در{ $sectionName } برای “{ $currentSearchText }” وجود ندارد
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = متاسفیم! نتیجه ای برای بخش “{ $searchTerms }” پیدا نشد
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = متاسفیم! ولی در حال حاضر اطلاعاتی برای “{ $sectionName }” در دسترس نیست
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = همه
# button label to copy the histogram
about-telemetry-histogram-copy = رونوشت برداشتن
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = عبارت‌های SQL کُند در ترد اصلی
about-telemetry-slow-sql-other = عبارت‌های SQL کُند در تردهای کمکی
about-telemetry-slow-sql-hits = بازدیدها
about-telemetry-slow-sql-average = زمان میانگین (ms)
about-telemetry-slow-sql-statement = عبارت
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = شناسه افزونه
about-telemetry-addon-table-details = جزئیات
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = فراهم‌کننده { $addonProvider }
about-telemetry-keys-header = ویژگی
about-telemetry-names-header = نام
about-telemetry-values-header = مقدار
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (تعداد دریافت‌ها: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = دیرنویس #{ $lateWriteCount }
about-telemetry-stack-title = پشته:
about-telemetry-memory-map-title = نقشه حافظه:
about-telemetry-error-fetching-symbols = خطایی هنگام دریافت علائم رخ داد. لطفا اتصال خود را به اینترنت بررسی و مجددا تلاش کنید.
about-telemetry-time-stamp-header = مهر زمان
about-telemetry-category-header = دسته بندی
about-telemetry-method-header = روش
about-telemetry-object-header = شئ
about-telemetry-extra-header = اضافی
