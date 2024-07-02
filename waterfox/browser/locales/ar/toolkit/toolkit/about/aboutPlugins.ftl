# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = عن الملحقات
installed-plugins-label = الملحقات المنصّبة
no-plugins-are-installed-label = لا يوجد ملحقات منصّبة
deprecation-description = أهناك ما تفتقده؟ بعض الملحقات لم تعد مدعومة. <a data-l10n-name="deprecation-link">اطّلع على المزيد.</a>
deprecation-description2 =
    .message = أهناك ما تفتقده؟ بعض الملحقات لم تعد مدعومة.

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">الملف:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">المسار:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">الإصدارة:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">الحالة:</span> مفعّل
state-dd-enabled-block-list-state = <span data-l10n-name="state">الحالة:</span> مفعّل ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">الحالة:</span> معطّل
state-dd-Disabled-block-list-state = <span data-l10n-name="state">الحالة:</span> معطّل ({ $blockListState })
mime-type-label = نوع MIME
description-label = الوصف
suffixes-label = اللواحق

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = معلومات الترخيص
plugins-gmp-privacy-info = معلومات الخصوصية
plugins-openh264-name = مرماز الڤديو OpenH264 من سيسكو سيستمز المحدودة.
plugins-openh264-description = تنصّب BrowserWorks هذه الملحقة تلقائيا للتوافق مع معيار WebRTC و لتفعيل مكالمات WebRTC على الأجهزة التي تحتاج مرماز لڤديو H.264. انتقل إلى ‪http://www.openh264.org/‬ للاطلاع على المصدر البرمجي للمرماز و للاطلاع أكثر على التطبيق.
plugins-widevine-name = وحدة Widevine لتعمية المحتوى من جوجل.
plugins-widevine-description = تتيح هذه الملحقة تشغيل الوسائط المعمّاة لتتوافق ومواصفات امتدادات الوسائط المعمّاة. تستعمل المواقع عادةً الوسائط المعمّاة لتحميل محتواها الممتاز من النسخ. زُر https://www.w3.org/TR/encrypted-media/ لمزيد من المعلومات حول امتدادات الوسائط المعمّاة.
