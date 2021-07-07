# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = إعدادات مُحلّل الأداء
perftools-intro-description =
    تفتح التسجيلات profiler.firefox.com في لسان جديد. كلّ البيانات مخزّنة
    على جهازك، ولكن يمكنك رفعها إن أردت مشاركتها.

## All of the headings for the various sections.

perftools-heading-settings = كل الإعدادات
perftools-heading-buffer = إعدادات الصِوان
perftools-heading-features = الميزات
perftools-heading-features-disabled = الميزات المعطّلة
perftools-heading-features-experimental = الميزات التجريبية
perftools-heading-threads = الخيوط

##


## The controls for the interval at which the profiler samples the code.

perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } م‌ث

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = حجم الصِوان:
perftools-devtools-threads-label = الخيوط:
perftools-devtools-settings-label = الإعدادات

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-recording-stopped-by-another-tool = أوقفت أداة أخرى التسجيل.
perftools-status-restart-required = يجب إعادة تشغيل المتصفّح لتفعيل هذه الميزة.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = يُوقف التسجيل

##

perftools-button-start-recording = ابدأ التسجيل
perftools-button-cancel-recording = ألغِ التسجيل
perftools-button-save-settings = احفظ الإعدادات وعُد
perftools-button-restart = أعِد التشغيل
perftools-button-remove-directory = أزِل المحدد
perftools-button-edit-settings = عدّل الإعدادات…

## These messages are descriptions of the threads that can be enabled for the profiler.


##


## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## both devtools.performance.new-panel-onboarding & devtools.performance.new-panel-enabled
## preferences are true.

