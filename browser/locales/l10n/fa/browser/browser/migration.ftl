# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = راهنمای گام‌به‌گام وارد کردن اطلاعات

import-from =
    { PLATFORM() ->
        [windows] وارد کردن گزینه‌ها، نشانک‌ها، تاریخچه، گذرواژه‌ها و دیگر داده‌ها از:
       *[other] وارد کردن ترجیحات، نشانک‌ها، تاریخچه، گذرواژه‌ها و دیگر داده‌ها از:
    }

import-from-bookmarks = وارد کردن نشانک‌ها از:
import-from-ie =
    .label = اینترنت اکسپلورر مایکروسافت
    .accesskey = م
import-from-edge =
    .label = مایکروسافت Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge Legacy
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = هیچ چیزی وارد نکن
    .accesskey = ه
import-from-safari =
    .label = سافاری
    .accesskey = س
import-from-canary =
    .label = کروم قناری
    .accesskey = ق
import-from-chrome =
    .label = کروم
    .accesskey = ک
import-from-chrome-beta =
    .label = کروم بتا
    .accesskey = B
import-from-chrome-dev =
    .label = کروم Dev
    .accesskey = D
import-from-chromium =
    .label = کرومیوم
    .accesskey = م
import-from-firefox =
    .label = Firefox
    .accesskey = ف
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = برنامه‌ای که شامل اطلاعات نشانک‌ها، تاریخچه یا گذرواژه‌ها باشد یافت نشد.

import-source-page-title = وارد کردن تنظیمات و داده‌ها
import-items-page-title = مواردی که وارد شوند

import-items-description = مواردی را که می‌خواهید وارد شوند انتخاب کنید:

import-migrating-page-title = در حال وارد کردن…

import-migrating-description = موارد زیر در حال وارد شدن هستند…

import-select-profile-page-title = انتخاب مجموعهٔ تنظیمات

import-select-profile-description = مجموعه تنظیمات زیر برای وارد کردن موجودند:

import-done-page-title = اطلاعات وارد شد

import-done-description = موارد زیر با موفقیت وارد شدند:

import-close-source-browser = لطفا قبل از ادامه دادن مطمئن شوید که مرورگر انتخاب شده بسته باشد.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = از { $source }:

source-name-ie = اینترنت اکسپلورر
source-name-edge = مایکروسافت Edge
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = سافاری
source-name-canary = گوگل کروم قناری
source-name-chrome = گوگل کروم
source-name-chrome-beta = گوگل کروم بتا
source-name-chrome-dev = گوگل کروم Dev
source-name-chromium = کرومیوم
source-name-firefox = موزیلا فایرفاکس
source-name-360se = 360 Secure Browser

imported-safari-reading-list = لیست خواندن (از اپل سفری)
imported-edge-reading-list = لیست مطالعه (از Edge)

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
    .label = کوکی‌ها
browser-data-cookies-label =
    .value = کوکی‌ها

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] تاریخچهٔ مرور و نشانک‌ها
           *[other] تاریخچهٔ مرور
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] تاریخچهٔ مرور و نشانک‌ها
           *[other] تاریخچهٔ مرور
        }

browser-data-formdata-checkbox =
    .label = ذخیره‌شده از تاریخچه
browser-data-formdata-label =
    .value = ذخیره‌شده از تاریخچه

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = ورودها و گذرواژه‌های ذخیره‌شده
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = ورودها و گذرواژه‌های ذخیره‌شده

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] محبوب‌ها
            [edge] محبوب‌ها
           *[other] نشانک‌ها
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] محبوب‌ها
            [edge] محبوب‌ها
           *[other] نشانک‌ها
        }

browser-data-otherdata-checkbox =
    .label = دیگر داده‌ها
browser-data-otherdata-label =
    .label = دیگر داده‌ها

browser-data-session-checkbox =
    .label = پنجره‌ها و سربرگ ها
browser-data-session-label =
    .value = پنجره‌ها و سربرگ ها
