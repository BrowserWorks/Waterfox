# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-protection-dashboard-title = لوحة الحمايات
appmenuitem-customize-mode =
    .label = خصّص…

## Zoom Controls

appmenuitem-new-tab =
    .label = لسان جديد
appmenuitem-new-window =
    .label = نافذة جديدة
appmenuitem-new-private-window =
    .label = نافذة خاصة جديدة
appmenuitem-passwords =
    .label = كلمات السر
appmenuitem-addons-and-themes =
    .label = الإضافات والسمات
appmenuitem-find-in-page =
    .label = ابحث في الصفحة…
appmenuitem-more-tools =
    .label = أدوات أكثر
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] غادِر
           *[other] اخرج
        }
appmenu-menu-button-closed2 =
    .tooltiptext = افتح قائمة التطبيق
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = أغلِق قائمة التطبيق
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = الإعدادات

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = قرّب
appmenuitem-zoom-reduce =
    .label = بعّد
appmenuitem-fullscreen =
    .label = ملء الشاشة

## Firefox Account toolbar button and Sync panel in App menu.

fxa-toolbar-sync-now =
    .label = زامِن الآن
appmenu-remote-tabs-sign-into-sync =
    .label = لِج كي تبدأ المزامنة…
appmenu-remote-tabs-turn-on-sync =
    .label = فعّل المزامنة…
appmenuitem-fxa-toolbar-sync-now2 = زامِن الآن
appmenuitem-fxa-manage-account = أدِر الحساب
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = كانت آخر مزامنة { $time }
    .label = كانت آخر مزامنة { $time }
appmenu-fxa-sync-and-save-data2 = زامِن واحفظ البيانات
appmenu-fxa-signed-in-label = لِج
appmenu-fxa-setup-sync =
    .label = فعّل المزامنة…
appmenu-fxa-show-more-tabs = أظهِر ألسنة أكثر
appmenuitem-save-page =
    .label = احفظ الصفحة باسم…

## What's New panel in App menu.

whatsnew-panel-header = ما الجديد
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = أعلِمني بالميزات الجديدة
    .accesskey = ع

## The Firefox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = اعرض معلومات أكثر
profiler-popup-description-title =
    .value = سجّل ثمّ حلّل ثمّ شارِك
profiler-popup-description = تعاوَن على حلّ مشاكل الأداء بنشر تحليلات الأداء ومشاركتها مع فريقك.
profiler-popup-learn-more = اطّلع على المزيد
profiler-popup-settings =
    .value = الإعدادات
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = عدّل الإعدادات…
profiler-popup-disabled = مُحلّل الأداء معطّل حاليًا، أغلب الظن أنّ هناك نافذة تصفّح خاص مفتوحة.
profiler-popup-recording-screen = يسجّل…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = مخصّص
profiler-popup-start-recording-button =
    .label = ابدأ التسجيل
profiler-popup-discard-button =
    .label = أهمِل
profiler-popup-capture-button =
    .label = التقِط
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Shift+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Shift+2
    }

## History panel

appmenu-manage-history =
    .label = أدِر التأريخ
appmenu-reopen-all-tabs = أعِد فتح كل الألسنة
appmenu-reopen-all-windows = أعِد فتح كل النوافذ
appmenu-restore-session =
    .label = استعد الجلسة السابقة
appmenu-clear-history =
    .label = امسح التأريخ الحالي…
appmenu-recent-history-subheader = التأريخ القريب
appmenu-recently-closed-tabs =
    .label = الألسنة المُغلقة مؤخرًا
appmenu-recently-closed-windows =
    .label = النوافذ المغلقة مؤخرًا

## Help panel

appmenu-help-header =
    .title = مساعدة { -brand-shorter-name }
appmenu-about =
    .label = عن { -brand-shorter-name }
    .accesskey = ع
appmenu-get-help =
    .label = احصل على مُساعدة
    .accesskey = س
appmenu-help-more-troubleshooting-info =
    .label = معلومات أكثر عن مواجهة الأعطال
    .accesskey = ه
appmenu-help-report-site-issue =
    .label = أبلغ عن مشكلة بالموقع…
appmenu-help-feedback-page =
    .label = أرسِل تعليقًا…
    .accesskey = ر

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = وضع مواجهة الأعطال
    .accesskey = ه
appmenu-help-exit-troubleshoot-mode =
    .label = عطّل وضع مواجهة الأعطال
    .accesskey = ع

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = أبلغ عن موقع مخادع…
    .accesskey = ع
appmenu-help-not-deceptive =
    .label = هذا ليس موقعًا مخادعًا…
    .accesskey = خ

## More Tools

appmenu-customizetoolbar =
    .label = خصّص شريط الأدوات…
appmenu-taskmanager =
    .label = مدير المهام
appmenu-developer-tools-subheader = أدوات المتصفّح
appmenu-developer-tools-extensions =
    .label = الامتدادات التي تخصّ المطوّرين
