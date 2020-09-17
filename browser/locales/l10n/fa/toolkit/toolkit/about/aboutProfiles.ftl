# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = در مورد نمایه‌ها
profiles-subtitle = این صفحه به شما کمک می‌کند تا نمايه‌های خود را مدیریت کنید. هر نمایه دارای دنیا جدا شامل تاریخچه، تنظیمات،‌ نشانک‌ها و افزونه های جدا است.
profiles-create = ایجاد نمایه جدید
profiles-restart-title = راه‌اندازی مجدد
profiles-restart-in-safe-mode = راه‌اندازی به همراه غیرفعال‌سازی افزونه ها
profiles-restart-normal = راه‌اندازی مجدد معمولی
profiles-conflict = نسخه دیگری از { -brand-product-name } باعث تغییراتی در نمایه‌ها شده است. قبل از ایجاد تغییرات بیشتر، باید { -brand-short-name } را مجدداً راه اندازی کنید.
profiles-flush-fail-title = تغییرات ذخیره نشد
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = یک خطای غیرمنتظره مانع از ذخیره تغییرات شما شده است.
profiles-flush-restart-button = راه‌اندازی مجدد { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = نمایه: { $name }
profiles-is-default = نمایه پیش فرض
profiles-rootdir = شاخه‌ی ریشه

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = شاخه محلی
profiles-current-profile = این نمایه‌ای است که مورد استفاده قرار می‌گیرد و نمی‌تواند پاک شود.
profiles-in-use-profile = این نمایه در برنامه دیگری در حال استفاده است و قابل حذف نیست.

profiles-rename = تغییر نام
profiles-remove = حذف
profiles-set-as-default = تنظیم این نمایه به عنوان نمایه پیش فرض
profiles-launch-profile = اجرا نمایه در مرورگر جدید

profiles-cannot-set-as-default-title = تنظیم پیش‌فرض امکان پذیر نیست
profiles-cannot-set-as-default-message = نمایهٔ پیش‌فرض برای { -brand-short-name } قابل تغییر نیست.

profiles-yes = بله
profiles-no = نه

profiles-rename-profile-title = تغییر نام نمایه
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = تغییر نام نمایه { $name }

profiles-invalid-profile-name-title = نام نمایه نامعتبر است
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = نام نمایه «{ $name }» دارای مجوز نیست.

profiles-delete-profile-title = حذف نمایه
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    حذف یک مجموعه نمایه آن را از فهرست مجموعه‌ نمایه ها موجود پاک می‌کند و قابل برگشت نیست.
    شما همچنین می‌توانید پرونده‌های مجموعه نمایه را نیز که شامل تنظیمات، گواهی‌ها و دیگر اطلاعات مربوط به کاربر می‌شود، حذف کنید. این گزینه پوشهٔ «{ $dir }» را حذف می‌کند و قابل برگشت نیست.
    آیا مایل به حذف پرونده‌های نمایه‌ها هستید؟
profiles-delete-files = حذف پرونده‌ها
profiles-dont-delete-files = پرونده‌ها را حذف نکن

profiles-delete-profile-failed-title = خطا
profiles-delete-profile-failed-message = هنگام تلاش برای حذف این نمایه خطایی روی داد.


profiles-opendir =
    { PLATFORM() ->
        [macos] نمایش در یابنده
        [windows] باز کردن پوشه
       *[other] باز کردن شاخه
    }
