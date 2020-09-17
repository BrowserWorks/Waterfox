# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = درآمد مددگار

import-from =
    { PLATFORM() ->
        [windows] اختیارات، بک مارک، سابقات، پاس ورڈ اور دیگر کوائف یہاں سے درآمد کریں:
       *[other] ترجیحات، بک مارک، سابقات، پاس ورڈ اور دیگر کوائف یہاں سے درآمد کریں:
    }

import-from-bookmarks = بک مارک یہاں سے درآمد کریں:
import-from-ie =
    .label = Microsoft انٹرنیٹ ایکسپلورر
    .accesskey = ا
import-from-edge =
    .label = مائیکروسافٹ عیدج
    .accesskey = ع
import-from-edge-legacy =
    .label = Microsoft Edge Legacy
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = کچھ درآمد نہ کریں
    .accesskey = ن
import-from-safari =
    .label = Safari
    .accesskey = S
import-from-canary =
    .label = کروم کینری
    .accesskey = ی
import-from-chrome =
    .label = Chrome
    .accesskey = C
import-from-chrome-beta =
    .label = Chrome Beta
    .accesskey = B
import-from-chrome-dev =
    .label = Chrome ڈیو
    .accesskey = D
import-from-chromium =
    .label = کرومیم
    .accesskey = م
import-from-firefox =
    .label = فائر فاکس
    .accesskey = ف
import-from-360se =
    .label = 360 قابل بھروسا براؤزر
    .accesskey = 3

no-migration-sources = کوئی بھی بک مارکوں، سابقات یا پاس ورڈ کوائف کا حامل پروگرام نہیں ملا۔

import-source-page-title = سیٹنگز اور کوائف درآمد کریں
import-items-page-title = درآمد کرنے کی اشیا

import-items-description = درآمد کرنے کے لیے اشیا منتخب کریں:

import-migrating-page-title = درآمد کر رہے ہے...

import-migrating-description = مندرجہ ذیل اشیا اس وقت درآمد ہو رہے ہیں۔۔۔

import-select-profile-page-title = پروفائل منتخب کیجیے

import-select-profile-description = مندرجہ ذیل پروفائل درآمد کے لیے دستیاب ہیں:

import-done-page-title = درآمد مکمل

import-done-description = مندرجہ ذیل اشیا کامیابی سے درآمد ہو گئیں:

import-close-source-browser = جاری رکھنے سے پہلے براہ کرم یقینی بنائیں کے منتخب براؤزر بند کر دیا ہے۔

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source } سے

source-name-ie = انٹرنیٹ ایکسپلورر
source-name-edge = مائیکروسافٹ عیدج
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = سفاری
source-name-canary = Google Chrome کینری
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome بیٹا
source-name-chrome-dev = Google Chrome ڈیو
source-name-chromium = کرومیم
source-name-firefox = Mozilla Firefox
source-name-360se = 360 قابل بھروسا براؤزر

imported-safari-reading-list = فہرست پڑھ رہا ہے (سفاری سے)
imported-edge-reading-list = فہرست پڑھ رہا ہے (عیدج سے)

## Browser data types
## All of these strings get a $browser variable passed in.
## You can use the browser variable to differentiate the name of items,
## which may have different labels in different browsers.
## The supported values for the $browser variable are:
## 360se
## chrome
## edge
## firefox
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

## Browser data types
## All of these strings get a $browser variable passed in.
## You can use the browser variable to differentiate the name of items,
## which may have different labels in different browsers.
## The supported values for the $browser variable are:
## 360se
## chrome
## edge
## firefox
## ie
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

browser-data-cookies-checkbox =
    .label = کوکیز
browser-data-cookies-label =
    .value = کوکیز

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] براؤزنگ کی تاریخ اور بک مارک
           *[other] براؤزنگ کی تاریخ
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] براؤزنگ کی تاریخ اور بک مارک
           *[other] براؤزنگ کی تاریخ
        }

browser-data-formdata-checkbox =
    .label = فارم کی تاریخ محفوظ کی گئی
browser-data-formdata-label =
    .value = فارم کی تاریخ محفوظ کی گئی

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = لاگ انز اور پاس ورڈز محفوظ کیے گئے
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = لاگ انز اور پاس ورڈز محفوظ کیے گئے

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] پسندیدہ
            [edge] پسندیدہ
           *[other] بک مارک
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] پسندیدہ
            [edge] پسندیدہ
           *[other] بک مارک
        }

browser-data-otherdata-checkbox =
    .label = دیگر ڈیٹا
browser-data-otherdata-label =
    .label = دیگر ڈیٹا

browser-data-session-checkbox =
    .label = دریچے اور ٹیب
browser-data-session-label =
    .value = دریچے اور ٹیب
