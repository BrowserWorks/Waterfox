# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = مُرشِد إنشاء ملفّ شخصي
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] مقدّمة
       *[other] مرحبًا في { create-profile-window.title }
    }

profile-creation-explanation-1 = يخزن { -brand-short-name } معلومات عن إعداداتك و تفضيلاتك في ملفّك الشّخصي.

profile-creation-explanation-2 = في حال مشاركة هذه النّسخة من { -brand-short-name } مع مستخدمين آخرين، يمكنك استخدام الملفّات الشّخصيّة لإبقاء معلومات المستخدمين منفصلة. لتحقيق هذا، على كلّ مستخدم أن ينشئ ملفًّا شخصيًّا.

profile-creation-explanation-3 = إذا كنت الشّخص الوحيد الذي يستخدم هذه النّسخة من { -brand-short-name }، عليك إنشاء ملفّ شخصي واحد على الأقلّ. إذا أردت، يمكنك إنشاء عدّة ملفّات شخصيّة لك لتخزين مجموعات مختلفة من الإعدادات و التّفضيلات. مثلًا، قد تنشئ ملفّات شخصيّة منفصلة للعمل و الاستخدام الشّخصي.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] لبدء إنشاء ملفّك الشّخصي، انقر واصِل.
       *[other] لبدء إنشاء ملفّك الشّخصي، انقر التّالي.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] خاتمة
       *[other] إكمال { create-profile-window.title }
    }

profile-creation-intro = إذا أنشأت عدّة ملفّات شخصيّة، يمكنك التّمييز بينها من خلال اسم الملفّ الشّخصي. يمكنك استخدام الاسم المزود هنا أو اسم من عندك.

profile-prompt = أدخل اسم الملف الشخصي الجديد:
    .accesskey = س

profile-default-name =
    .value = المستخدم المبدئي

profile-directory-explanation = إعدادات المستخدم الخاصة بك، وتفضيلاتك وغير ذلك من البيانات المتعلقة بالمستخدم سيتم تخزينها في:

create-profile-choose-folder =
    .label = اختر مجلدًا…
    .accesskey = خ

create-profile-use-default =
    .label = استعمل المجلد المبدئي
    .accesskey = س
