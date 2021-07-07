# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = مقياس جودة كلمة السرّ

## Change Password dialog

change-password-window =
    .title = غيّر كلمة السرّ الرئيسيّة
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = جهاز الأمن: { $tokenName }
change-password-old = كلمة السرّ الحاليّة:
change-password-new = كلمة السرّ الجّديدة:
change-password-reenter = كلمة السرّ الجّديدة (مرّة ثانية):

## Reset Password dialog

reset-password-window =
    .title = صفّر كلمة السرّ الرّئيسية
    .style = width: 40em
pippki-incorrect-pw = لم تُدخل كلمة السر الرئيسية الصحيحة. رجاءً أعِد المحاولة.

## Reset Primary Password dialog

reset-password-button-label =
    .label = صفّر
reset-password-text = إذا صفّرت كلمة السرّ الرئيسية، ستُنسى كلّ كلمات سرّ البريد الإلكتروني و وِب، وبيانات الاستمارات، والشّهادات الشّخصيّة، والمفاتيح السرّية المخزّنة. متأكّد أنّك تريد إعادة ضبط كلمة السرّ الرّئيسية؟

## Downloading cert dialog

download-cert-window =
    .title = يجري تنزيل الشّهادات
    .style = width: 46em
download-cert-message = يُطلب منك الوثوق بسلطة شهادات جديدة.
download-cert-trust-ssl =
    .label = ثِق في سلطة الشّهادات هذه لتعريف مواقع وِب.
download-cert-trust-email =
    .label = ثِق في سلطة الشّهادات هذه لتعريف مستخدمي البريد الإلكتروني.
download-cert-message-desc = قبل الوثوق بسلطة الشّهادات هذه لأي سبب، عليك فحص شهادتها و سياستها و إجراءاتها (في حال توفّرها).
download-cert-view-cert =
    .label = اعرض
download-cert-view-text = افحص شهادة سلطة الشّهادات

## Client Authorization Ask dialog

client-auth-window =
    .title = طلب تعريف مستخدم
client-auth-site-description = طلب هذا الموقع أن تعرّف نفسك بشهادة:
client-auth-choose-cert = اختر شهادة لتقدّمها كتعريف:
client-auth-cert-details = تفاصيل الشّهادة المختارة:

## Set password (p12) dialog

set-password-window =
    .title = اختر كلمة سرّ النّسخة الاحتياطيّة للشّهادة
set-password-message = تحمي كلمة سرّ النّسخة الاحتياطيّة للشّهادة التي تعيّنها الملفّ الاحتياطي الذي توشك على إنشائه.  عليك ضبط كلمة السرّ هذه لمتابعة النسخ الاحتياطي.
set-password-backup-pw =
    .value = كلمة سرّ النّسخة الاحتياطيّة للشّهادة:
set-password-repeat-backup-pw =
    .value = كلمة سرّ النّسخة الاحتياطيّة للشّهادة (مرّة ثانية):
set-password-reminder = هامّ: إذا نسيت كلمة سرّ النّسخة الاحتياطيّة للشّهادة، لن تكون قادرًا على استعادة هذه النّسخة الاحتياطيّة لاحقًا.  الرجاء تسجيلها بمكان آمن.

## Protected Auth dialog

protected-auth-window =
    .title = استيثاق علامة محمية
protected-auth-msg = من فضلك استوثق من هذه العلامة. تعتمد طريقة الاستيثاق على نوع علامتك.
protected-auth-token = علامة:
