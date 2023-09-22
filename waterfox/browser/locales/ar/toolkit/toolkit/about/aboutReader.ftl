# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-reader-loading = يُحمّل…
about-reader-load-error = فشل تحميل المقالة من الصفحة

about-reader-color-scheme-light = فاتح
    .title = مخطّط الألوان فاتح
about-reader-color-scheme-dark = داكن
    .title = مخطّط الألوان داكن

# An estimate for how long it takes to read an article,
# expressed as a range covering both slow and fast readers.
# Variables:
#   $rangePlural (String): The plural category of the range, using the same set as for numbers.
#   $range (String): The range of minutes as a localised string. Examples: "3-7", "~1".
about-reader-estimated-read-time =
    { $rangePlural ->
        [zero] { $range } دقيقة
        [one] { $range } دقيقة
        [two] { $range } دقيقة
        [few] { $range } دقيقة
        [many] { $range } دقيقة
       *[other] { $range } دقيقة
    }

## These are used as tooltips in Type Control

about-reader-toolbar-minus =
    .title = صغّر مقاس الخط
about-reader-toolbar-plus =
    .title = كبّر مقاس الخط
about-reader-toolbar-contentwidthminus =
    .title = صغّر عرض المحتوى
about-reader-toolbar-contentwidthplus =
    .title = كبّر عرض المحتوى
about-reader-toolbar-lineheightminus =
    .title = صغّر ارتفاع السطر
about-reader-toolbar-lineheightplus =
    .title = كبّر ارتفاع السطر

## These are the styles of typeface that are options in the reader view controls.

about-reader-font-type-serif = مذيّل
about-reader-font-type-sans-serif = غير مذيّل

## Reader View toolbar buttons

about-reader-toolbar-close = أغلق منظور القارئ
about-reader-toolbar-type-controls = أزرار الخطوط
