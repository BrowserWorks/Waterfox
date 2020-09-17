# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = راهنمای گام‌به‌گام ایجاد مجموعه تنظیمات
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] مقدمه
       *[other] به { create-profile-window.title } خوش آمدید
    }

profile-creation-explanation-1 = { -brand-short-name } اطلاعات مربوط به تنظبمات و ترجیحات شما را در یک مجوعه تنظیمات نگه‌داری می‌کند.

profile-creation-explanation-2 = اگر شما از این نسخه از { -brand-short-name } با کاربران دیگر به صورت اشتراکی استفاده می‌کنید، می‌توانید برای نگه‌داری تنظیمات هر کاربر به صورت جداگانه از مجموعه تنظیمات استفاده کنید. برای این کار، هر کاربری باید مجموعه تنظیمات خود را ایجاد کند.

profile-creation-explanation-3 = اگر شما تنها کسی هستید که از این نسخه از { -brand-short-name } استفاده می‌کنید، باید حداقل یک مجموعه تنظیمات داشته باشید. اگر مایل باشید، می‌توانید به تنهایی چندین مجموعه تنظیمات داشته باشید و از هر کدام برای نگهداری تنظیمات خاصی استفاده کنید. مثلاً ممکن است بخواهید مجموعه تنظیمات مجزایی برای استفادهٔ شخصی و کاری داشته باشید.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] برای آغاز ایجاد مجموعه تنظیمات خود، ادامه را کلیک کنید.
       *[other] برای آغاز ایجاد مجموعه تنظیمات خود، بعدی را کلیک کنید.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] نتیجه
       *[other] در حال تکمیل { create-profile-window.title }
    }

profile-creation-intro = اگر چندین مجموعه تنظیمات ایجاد کنید، می‌توانید آن‌ها را توسط نام از یکدیگر تشخیص دهید. می‌توانید از اسم موجود در اینجا و یا اسم دلخواه خود استفاده کنید.

profile-prompt = نام مجموعه تنظیمات جدید را وارد کنید:
    .accesskey = ن

profile-default-name =
    .value = کاربر پیش‌فرض

profile-directory-explanation = تنظیمات، ترجیحات و دیگر اطلاعات مربوط به کاربرتان در این مکان ذخیره خواهد شد:

create-profile-choose-folder =
    .label = انتخاب پوشه…
    .accesskey = خ

create-profile-use-default =
    .label = استفاده از پوشهٔ پیش‌فرض
    .accesskey = پ
