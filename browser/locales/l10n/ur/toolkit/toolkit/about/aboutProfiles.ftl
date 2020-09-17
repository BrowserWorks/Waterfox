# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = پروفائلز کے بارے میں
profiles-subtitle = اس صفحہ تک آپ کو آپ کی پروفائلز کو منظم کرنے میں مدد ملتی. ہر پروفائل علیحدہ سرگزشت، بک مارکس، سیٹنگز اور ایڈ اون  پر مشتمل ہے جس نے ایک علیحدہ لفظ ہے.
profiles-create = ایک نئی پروفائل بنائیں
profiles-restart-title = دوبارہ شروع کریں
profiles-restart-in-safe-mode = ایڈز آن نا اہل کر کے دوبارہ شروع کریں ...
profiles-restart-normal = معمول کے مطابق دوبارہ چالو کریں…
profiles-flush-fail-title = تبدیلیاں محفوظ ہویی
profiles-flush-conflict = { profiles-conflict }
profiles-flush-restart-button = { -brand-short-name } دوبارہ شروع کریں

# Variables:
#   $name (String) - Name of the profile
profiles-name = پروفائل: { $name }
profiles-is-default = طے شدہ پروفائل
profiles-rootdir = جڑ ڈائریکٹری

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = مقامی ڈائریکٹری
profiles-current-profile = یہ پروفائل استعمال میں ہے اور یہ حزف نہین ہو سکتی۔
profiles-in-use-profile = یہ پروفائل کسی اور ایپلی کیشن کے استعمال میں ہے اور اسے حذف نہیں کیا جا سکتاہے۔

profiles-rename = نیا نام دیں
profiles-remove = ہٹائیں
profiles-set-as-default = طےشدہ پروفائل کے طور پر سیٹ کریں
profiles-launch-profile = پروفائل کو نئے براؤزر میں چالو کریں

profiles-cannot-set-as-default-title = پہلے سے طے شدہ سیٹ کرنے میں ناکام رہا

profiles-yes = ہاں
profiles-no = نہیں

profiles-rename-profile-title = پروفائل کو نیا نام دیں
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = پروفائل کو نیا نام دیں { $name }

profiles-invalid-profile-name-title = ناجائز پروفائل کا نام
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = پروفائل نام "{ $name }" کی اجازت نہیں ہے۔

profiles-delete-profile-title = پروفائل حذف کریں
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    ایک پروفائل حذف کر رہا ہے آپ پروفائلز کی فہرست سے نکال دیا جائے گا پروفائل اور رد نہیں کیا جاسکتا ہے.
    تم نے بھی آپ کی سیٹنگز، سرٹیفکیٹ اور دیگر صارف سے متعلقہ اعداد و شمار سمیت، پروفائل ڈیٹا فائلوں کو خارج کرنے کا انتخاب کر سکتے. یہ آپشن این فولڈر“{ $dir }”کو حذف کر دے گا اور اسے رد نہیں کیا جا سکتا ہے. 
    آپ کا پروفائل ڈیٹا فائلوں کو خارج کرنا چاہتے ہیں؟
profiles-delete-files = فایلز حذف کریں
profiles-dont-delete-files = مسلیں حذف مت کریں

profiles-delete-profile-failed-title = نقص
profiles-delete-profile-failed-message = اس پروفائل کو حذف کرنے کے دوران ایک نقص تھا۔


profiles-opendir =
    { PLATFORM() ->
        [macos] فولڈر میں دکھائیں
        [windows] فولڈر کھولیں
       *[other] ڈائریکٹری کھولیں
    }
