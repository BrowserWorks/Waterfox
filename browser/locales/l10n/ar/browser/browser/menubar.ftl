# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# NOTE: For English locales, strings in this file should be in APA-style Title Case.
# See https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case
#
# NOTE: For Engineers, please don't re-use these strings outside of the menubar.


## Application Menu (macOS only)

menu-application-preferences =
    .label = التفضيلات
menu-application-services =
    .label = الخدمات
menu-application-hide-this =
    .label = أخفِ { -brand-shorter-name }
menu-application-hide-other =
    .label = أخفِ الآخرين
menu-application-show-all =
    .label = أظهر الكل
menu-application-touch-bar =
    .label = خصّص شريط اللمس…

##

# These menu-quit strings are only used on Windows and Linux.
menu-quit =
    .label =
        { PLATFORM() ->
            [windows] اخرج
           *[other] أغلق
        }
    .accesskey =
        { PLATFORM() ->
            [windows] خ
           *[other] غ
        }
# This menu-quit-mac string is only used on macOS.
menu-quit-mac =
    .label = أغلق { -brand-shorter-name }
# This menu-quit-button string is only used on Linux.
menu-quit-button =
    .label = { menu-quit.label }
# This menu-quit-button-win string is only used on Windows.
menu-quit-button-win =
    .label = { menu-quit.label }
    .tooltip = أغلق { -brand-shorter-name }
menu-about =
    .label = عن { -brand-shorter-name }
    .accesskey = ع

## File Menu

menu-file =
    .label = ملف
    .accesskey = م
menu-file-new-tab =
    .label = لسان جديد
    .accesskey = ل
menu-file-new-container-tab =
    .label = لسان حاوٍ جديد
    .accesskey = ح
menu-file-new-window =
    .label = نافذة جديدة
    .accesskey = ج
menu-file-new-private-window =
    .label = نافذة خاصة جديدة
    .accesskey = ن
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = افتح مكانًا…
menu-file-open-file =
    .label = افتح ملفًا…
    .accesskey = ف
menu-file-close =
    .label = أغلق
    .accesskey = غ
menu-file-close-window =
    .label = أغلق النافذة
    .accesskey = ن
menu-file-save-page =
    .label = احفظ الصفحة باسم…
    .accesskey = س
menu-file-email-link =
    .label = أرسل الرابط بالبريد…
    .accesskey = س
menu-file-print-setup =
    .label = إعداد الصفحة…
    .accesskey = ع
menu-file-print-preview =
    .label = معاينة الطباعة
    .accesskey = ط
menu-file-print =
    .label = اطبع…
    .accesskey = ط
menu-file-import-from-another-browser =
    .label = استورد من متصفح آخر…
    .accesskey = س
menu-file-go-offline =
    .label = اعمل دون اتصال
    .accesskey = ع

## Edit Menu

menu-edit =
    .label = حرّر
    .accesskey = ح
menu-edit-find-on =
    .label = ابحث في هذه الصفحة…
    .accesskey = ب
menu-edit-find-in-page =
    .label = ابحث في الصفحة…
    .accesskey = ح
menu-edit-find-again =
    .label = ابحث مجددًا
    .accesskey = ب
menu-edit-bidi-switch-text-direction =
    .label = اعكس اتجاه النص
    .accesskey = ن

## View Menu

menu-view =
    .label = عرض
    .accesskey = ع
menu-view-toolbars-menu =
    .label = أشرطة الأدوات
    .accesskey = ش
menu-view-customize-toolbar =
    .label = خصّص…
    .accesskey = ص
menu-view-customize-toolbar2 =
    .label = خصّص شريط الأدوات…
    .accesskey = خ
menu-view-sidebar =
    .label = الشريط الجانبي
    .accesskey = ط
menu-view-bookmarks =
    .label = العلامات
menu-view-history-button =
    .label = التأريخ
menu-view-synced-tabs-sidebar =
    .label = الألسنة المُزامنة
menu-view-full-zoom =
    .label = قرّب
    .accesskey = ر
menu-view-full-zoom-enlarge =
    .label = قرّب
    .accesskey = ق
menu-view-full-zoom-reduce =
    .label = بعّد
    .accesskey = ب
menu-view-full-zoom-actual-size =
    .label = المقاس الفعلي
    .accesskey = ق
menu-view-full-zoom-toggle =
    .label = قرّب النص فقط
    .accesskey = ن
menu-view-page-style-menu =
    .label = طراز الصفحة
    .accesskey = ط
menu-view-page-style-no-style =
    .label = بلا طراز
    .accesskey = ل
menu-view-page-basic-style =
    .label = طراز صفحة بسيط
    .accesskey = ص
menu-view-charset =
    .label = ترميز النص
    .accesskey = ر

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = تحول إلى ملء الشاشة
    .accesskey = ش
menu-view-exit-full-screen =
    .label = غادر ملء الشاشة
    .accesskey = ش
menu-view-full-screen =
    .label = ملء الشاشة
    .accesskey = ش

##

menu-view-show-all-tabs =
    .label = أظهِر كل الألسنة
    .accesskey = ك
menu-view-bidi-switch-page-direction =
    .label = اعكس اتجاه الصفحة
    .accesskey = ك

## History Menu

menu-history =
    .label = التأريخ
    .accesskey = ت
menu-history-show-all-history =
    .label = أظهر كل التأريخ
menu-history-clear-recent-history =
    .label = امسح التأريخ الحالي…
menu-history-synced-tabs =
    .label = الألسنة المُزامنة
menu-history-restore-last-session =
    .label = استعد الجلسة السابقة
menu-history-hidden-tabs =
    .label = الألسنة المخفية
menu-history-undo-menu =
    .label = الألسنة المُغلقة مؤخرًا
menu-history-undo-window-menu =
    .label = النوافذ المغلقة مؤخرًا
menu-history-reopen-all-tabs = أعِد فتح كل الألسنة
menu-history-reopen-all-windows = أعِد فتح كل النوافذ

## Bookmarks Menu

menu-bookmarks-menu =
    .label = علامات
    .accesskey = ع
menu-bookmarks-show-all =
    .label = أظهِر كل العلامات
menu-bookmark-this-page =
    .label = علّم هذه الصفحة
menu-bookmark-current-tab =
    .label = علّم اللسان الحالي
menu-bookmark-edit =
    .label = حرّر هذه العلامة
menu-bookmarks-all-tabs =
    .label = علّم كل الألسنة…
menu-bookmarks-toolbar =
    .label = شريط العلامات
menu-bookmarks-other =
    .label = العلامات الأخرى
menu-bookmarks-mobile =
    .label = علامات المحمول

## Tools Menu

menu-tools =
    .label = أدوات
    .accesskey = د
menu-tools-downloads =
    .label = التنزيلات
    .accesskey = ز
menu-tools-addons =
    .label = الإضافات
    .accesskey = ض
menu-tools-fxa-sign-in =
    .label = لِج إلى { -brand-product-name }…
    .accesskey = ل
menu-tools-addons-and-themes =
    .label = الإضافات والسمات
    .accesskey = ض
menu-tools-fxa-sign-in2 =
    .label = لِج
    .accesskey = ل
menu-tools-turn-on-sync =
    .label = فعّل { -sync-brand-short-name }…
    .accesskey = ف
menu-tools-turn-on-sync2 =
    .label = فعّل المزامنة…
    .accesskey = ن
menu-tools-sync-now =
    .label = زامِن الآن
    .accesskey = ز
menu-tools-fxa-re-auth =
    .label = أعِد الاتصال بِ‍ { -brand-product-name }…
    .accesskey = ع
menu-tools-web-developer =
    .label = مطوّري الوب
    .accesskey = و
menu-tools-browser-tools =
    .label = أدوات المتصفّح
    .accesskey = ص
menu-tools-task-manager =
    .label = مدير المهام
    .accesskey = م
menu-tools-page-source =
    .label = مصدر الصفحة
    .accesskey = ح
menu-tools-page-info =
    .label = معلومات الصفحة
    .accesskey = م
menu-settings =
    .label = الإعدادات
    .accesskey =
        { PLATFORM() ->
            [windows] ع
           *[other] ع
        }
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] خيارات
           *[other] التفضيلات
        }
    .accesskey =
        { PLATFORM() ->
            [windows] خ
           *[other] ف
        }
menu-tools-layout-debugger =
    .label = منقح تخطيط الصفحة
    .accesskey = م

## Window Menu

menu-window-menu =
    .label = نافذة
menu-window-bring-all-to-front =
    .label = اجلب الكل للمقدمة

## Help Menu


# NOTE: For Engineers, any additions or changes to Help menu strings should
# also be reflected in the related strings in appmenu.ftl. Those strings, by
# convention, will have the same ID as these, but prefixed with "app".
# Example: appmenu-get-help
#
# These strings are duplicated to allow for different casing depending on
# where the strings appear.

menu-help =
    .label = مساعدة
    .accesskey = س
menu-help-product =
    .label = مساعدة { -brand-shorter-name }
    .accesskey = س
menu-help-show-tour =
    .label = جولة في { -brand-shorter-name }
    .accesskey = ل
menu-help-import-from-another-browser =
    .label = استورِد من متصفح آخر…
    .accesskey = س
menu-help-keyboard-shortcuts =
    .label = اختصارات لوحة المفاتيح
    .accesskey = خ
menu-get-help =
    .label = احصل على مُساعدة
    .accesskey = ح
menu-help-troubleshooting-info =
    .label = معلومات مواجهة الأعطال
    .accesskey = ط
menu-help-taskmanager =
    .label = مدير المهام
menu-help-more-troubleshooting-info =
    .label = معلومات أكثر عن مواجهة الأعطال
    .accesskey = ط
menu-help-report-site-issue =
    .label = أبلغ عن مشكلة بالموقع…
menu-help-feedback-page =
    .label = أرسِل تعليقًا…
    .accesskey = ر
menu-help-safe-mode-without-addons =
    .label = أعِد التشغيل مع تعطيل الإضافات…
    .accesskey = ش
menu-help-safe-mode-with-addons =
    .label = أعِد التشغيل مع تفعيل الإضافات
    .accesskey = ش
menu-help-enter-troubleshoot-mode2 =
    .label = وضع مواجهة الأعطال
    .accesskey = ه
menu-help-exit-troubleshoot-mode =
    .label = عطّل وضع مواجهة الأعطال
    .accesskey = ط
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = أبلغ عن موقع مخادع…
    .accesskey = ع
menu-help-not-deceptive =
    .label = هذا ليس موقعًا مخادعًا…
    .accesskey = خ
