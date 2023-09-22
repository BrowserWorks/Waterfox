# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = مقياس جودة كلمة السرّ

## Change Password dialog

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = جهاز الأمن: { $tokenName }
change-password-old = كلمة السرّ الحاليّة:
change-password-new = كلمة السرّ الجّديدة:
change-password-reenter = كلمة السرّ الجّديدة (مرّة ثانية):
pippki-incorrect-pw = لم تُدخل كلمة السر الرئيسية الصحيحة. رجاءً أعِد المحاولة.

## Reset Primary Password dialog

reset-password-button-label =
    .label = صفّر

## Downloading cert dialog

download-cert-window2 =
    .title = يجري تنزيل الشّهادات
    .style = min-width: 46em
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


## Client Authentication Ask dialog

client-auth-window =
    .title = طلب تعريف مستخدم
client-auth-site-description = طلب هذا الموقع أن تعرّف نفسك بشهادة:
client-auth-choose-cert = اختر شهادة لتقدّمها كتعريف:
client-auth-cert-details = تفاصيل الشّهادة المختارة:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = أُصدِرت إلى: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = الرقم التسلسلي: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = صالحة من { $notBefore } إلى { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = استخدامات المفتاح: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = عناوين البريد الإلكتروني: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = أصدرها: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = محفوظة في: { $storedOn }
client-auth-cert-remember-box =
    .label = تذكّر هذا القرار

## Set password (p12) dialog

set-password-window =
    .title = اختر كلمة سرّ النّسخة الاحتياطيّة للشّهادة
set-password-message = تحمي كلمة سرّ النّسخة الاحتياطيّة للشّهادة التي تعيّنها الملفّ الاحتياطي الذي توشك على إنشائه.  عليك ضبط كلمة السرّ هذه لمتابعة النسخ الاحتياطي.
set-password-backup-pw =
    .value = كلمة سرّ النّسخة الاحتياطيّة للشّهادة:
set-password-repeat-backup-pw =
    .value = كلمة سرّ النّسخة الاحتياطيّة للشّهادة (مرّة ثانية):
set-password-reminder = هامّ: إذا نسيت كلمة سرّ النّسخة الاحتياطيّة للشّهادة، لن تكون قادرًا على استعادة هذه النّسخة الاحتياطيّة لاحقًا.  الرجاء تسجيلها بمكان آمن.

## Protected authentication alert

