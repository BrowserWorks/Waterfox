# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = عن اللاحات
profiles-subtitle = تساعدك هذه الصفحة في إداراة لاحاتك. كل لاحة هي عالم بذاته يحتوي تأريخًا و علامات و إضافات منفصلة.
profiles-create = أنشئ لاحة جديدة
profiles-restart-title = أعِد التشغيل
profiles-restart-in-safe-mode = أعِد التشغيل مع تعطيل الإضافات…
profiles-restart-normal = أعد التشغيل في الوضع العادي…

# Variables:
#   $name (String) - Name of the profile
profiles-name = ملف شخصي: { $name }
profiles-is-default = الملف الشخصي المبدئي
profiles-rootdir = المجلد الجذر

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = الملجد المحلي
profiles-current-profile = هذا الملف الشخصي مستخدم و لا يمكن حذفه.
profiles-in-use-profile = ملف الإعدادات قيد الاستخدام في تطبيق آخر و لا يمكن حذفه.

profiles-rename = غيّر الاسم
profiles-remove = أزِل
profiles-set-as-default = اجعله الملف الشخصي المبدئي
profiles-launch-profile = ابدأ الملف الشخصي في متصفح جديد

profiles-yes = نعم
profiles-no = لا

profiles-rename-profile-title = غيّر اسم الملف الشخصي
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = غيّر الملف الشخصي { $name }

profiles-invalid-profile-name-title = اسم ملفّ شخصي غير سليم
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = اسم الملفّ الشّخصي ”{ $name }“ غير مسموح به.

profiles-delete-profile-title = احذف الملف الشخصي
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    حذف ملف شخصي سيزيله من قائمة الملفات الشخصية المتوفرة ولا يمكن التراجع عنه.
    قد تختار أيضا حذف بيانات الملف الشخصي، بما في ذلك إعداداتك، شهاداتك وغيرها من البيانات الخاصة بالمستخدم. هذا الخيار سيحذف المجلّد ”{ $dir }“ ولا يمكن التراجع عنه.
    هل تريد حذف بيانات الملف الشخصي؟
profiles-delete-files = احذف الملفّات
profiles-dont-delete-files = لا تحذف الملفّات

profiles-delete-profile-failed-title = خطأ
profiles-delete-profile-failed-message = حدث خطأ أثناء محاولة حذف ملف الإعدادات هذا.


profiles-opendir =
    { PLATFORM() ->
        [macos] أظهِر في فايندر
        [windows] افتح المجلد
       *[other] افتح المجلد
    }
