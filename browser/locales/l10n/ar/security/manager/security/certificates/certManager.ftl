# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = مدير الشّهادات

certmgr-tab-mine =
    .label = شهاداتك

certmgr-tab-people =
    .label = الناس

certmgr-tab-servers =
    .label = الخواديم

certmgr-tab-ca =
    .label = السّلطات

certmgr-mine = لديك شهادات من هذه المنظّمات التي تعرّفك
certmgr-remembered = تُستعمل هذه الشهادات لتعريف نفسك إلى المواقع
certmgr-people = لديك شهادات على ملفّ تعرّف هؤلاء الناس
certmgr-server = تُعرّف هذه المُدخلات استثناءات الأعطال في شهادات الخواديم
certmgr-ca = لديك شهادات على ملفّ تعرّف سلطات الشّهادات هذه

certmgr-edit-ca-cert =
    .title = حرِّر إعدادات ثقة شهادة سلطة الشّهادات
    .style = width: 48em;

certmgr-edit-cert-edit-trust = حرِّر إعدادات الثّقة:

certmgr-edit-cert-trust-ssl =
    .label = تستطيع هذه الشّهادة تعريف المواقع.

certmgr-edit-cert-trust-email =
    .label = تستطيع هذه الشّهادة تعريف مستخدمي البريد.

certmgr-delete-cert =
    .title = احذف الشّهادة
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = المستضيف

certmgr-cert-name =
    .label = اسم الشّهادة

certmgr-cert-server =
    .label = الخادوم

certmgr-override-lifetime =
    .label = الصلاحية

certmgr-token-name =
    .label = جهاز الأمن

certmgr-begins-label =
    .label = تبدأ في

certmgr-expires-label =
    .label = تنقضي في

certmgr-email =
    .label = عنوان البريد الإلكتروني

certmgr-serial =
    .label = الرّقم التّسلسلي

certmgr-view =
    .label = اعرض…
    .accesskey = ع

certmgr-edit =
    .label = حرّر الثقة…
    .accesskey = ح

certmgr-export =
    .label = صدّر…
    .accesskey = ص

certmgr-delete =
    .label = احذف…
    .accesskey = ح

certmgr-delete-builtin =
    .label = احذف أو لا تثق…
    .accesskey = ذ

certmgr-backup =
    .label = احفظ احتياطيًا…
    .accesskey = ط

certmgr-backup-all =
    .label = احفظ الكل احتياطيا…
    .accesskey = ك

certmgr-restore =
    .label = استورِد…
    .accesskey = س

certmgr-add-exception =
    .label = أضِف استثناءً…
    .accesskey = ت

exception-mgr =
    .title = أضِف استثناءً أمنيًا

exception-mgr-extra-button =
    .label = أكّد الاستثناء الأمني
    .accesskey = س

exception-mgr-supplemental-warning = لن تطلب منك هذا البنوك الحقيقية والمتاجر والمواقع العامة الأخرى.

exception-mgr-cert-location-url =
    .value = المكان:

exception-mgr-cert-location-download =
    .label = اجلب الشهادة
    .accesskey = ج

exception-mgr-cert-status-view-cert =
    .label = اعرض…
    .accesskey = ع

exception-mgr-permanent =
    .label = احفظ هذا الاستثناء دائما
    .accesskey = د

pk11-bad-password = كلمة السر المدخلة غير صحيحة.
pkcs12-decode-err = فشل تظهير الملفّ.  إمّا أنّه ليس بهيئة PKCS #12، أو تلف، أو أنّ كلمة السر غير صحيحة.
pkcs12-unknown-err-restore = فشلت استعادة ملفّ PKCS #12 لأسباب غير معروفة.
pkcs12-unknown-err-backup = فشل إنشاء ملف النسخة الاحتياطيّة PKCS #12 لأسباب غير معروفة.
pkcs12-unknown-err = فشلت عمليّة PKCS #12 لأسباب غير معروفة.
pkcs12-info-no-smartcard-backup = تعذّر النّسخ الاحتياطي لشهادات من جهاز أمن كقارئ بطاقات.
pkcs12-dup-data = توجد الشّهادة و المفتاح السرّيّ على جهاز الأمن مسبقًا.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = اسم الملفّ المراد نسخه احتياطيًّا
file-browse-pkcs12-spec = ملفّات PKCS12
choose-p12-restore-file-dialog = اسم الشهادة المطلوب استيرادها

## Import certificate(s) file dialog

file-browse-certificate-spec = ملفّات الشّهادات
import-ca-certs-prompt = اختر الملفّ الذي يحتوي على شهادة سلطة الشّهادات لاستيراده
import-email-cert-prompt = اختر الملفّ الذي يحتوي على شهادة البريد الإلكتروني لشخص ما لاستيراده

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = تمثّل الشّهادة ”{ $certName }“ سلطة شهادات.

## For Deleting Certificates

delete-user-cert-title =
    .title = احذف شهاداتك
delete-user-cert-confirm = أمتأكّد أنّك تريد حذف هذه الشّهادات؟
delete-user-cert-impact = إذا حذفت واحدة من شهاداتك، لن تكون قادرًا على استخدامها لتعريف نفسك بعد الآن.


delete-ca-cert-title =
    .title = حذف أو نزع الثقة من شهادة تابعة لسلطة شهادات
delete-ca-cert-confirm = لقد طلبت حذف الشهادات من سلطة الشهادات هذه. بالنسبة للشهادات المضمنة، ستنزع منها الثقة جميعها، وهو التأثير نفسه. أمتأكد من أنك تريد الحذف أو نزع الثقة؟
delete-ca-cert-impact = إذا حذفت أو نزعت الثقة من شهادة تابعة لسلطة شهادات، لن يثق هذا البرنامج بأي شهادات صادرة من سلطة الشهادات تلك.


delete-email-cert-title =
    .title = احذف شهادات البريد الإلكتروني
delete-email-cert-confirm = أمتأكّد أنّك تريد حذف شهادات البريد الإلكتروني لهؤلاء الأشخاص؟
delete-email-cert-impact = إن حذفت شهادة بريد لشخص، فلن تستطيع إرسال بريد معمّى له بعد الآن.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = شهادة بالرقم التسلسلي: { $serialNumber }

## Cert Viewer

## Used to show whether an override is temporary or permanent


## Add Security Exception dialog

add-exception-branded-warning = أنت على وشك تخطي كيفية تعرّف { -brand-short-name } على هذا الموقع.
add-exception-invalid-header = يحاول هذا الموقع تعريف نفسه بمعلومات غير مقبولة.
add-exception-domain-mismatch-short = الموقع الخطأ
add-exception-domain-mismatch-long = تنتمي الشهادة لموقع آخر، ما قد يعني أن هناك من يحاول انتحال هوية هذا الموقع.
add-exception-expired-short = معلومات قديمة
add-exception-expired-long = الشهادة غير صحيحة. ربما سُرقت أو ضاعت، و قد تُستخدم لانتحال هوية هذا الموقع.
add-exception-unverified-or-bad-signature-short = هويّة مجهولة
add-exception-unverified-or-bad-signature-long = الشهادة ليست موثوقة، لأنه لم تتحقق منها سلطة موثوقة تستخدم توقيعًا آمنًا.
add-exception-valid-short = شهادة صالحة
add-exception-valid-long = يعطي هذا الموقع شهادة صالحة، وهوية موثّقة.  لا حاجة لإضافة استثناء.
add-exception-checking-short = يفحص المعلومات
add-exception-checking-long = يحاول التعرف على هذا الموقع…
add-exception-no-cert-short = لا توجد معلومات
add-exception-no-cert-long = تعذّر الحصول على حالة التعرف على هذا الموقع.

## Certificate export "Save as" and error dialogs

save-cert-as = احفظ الشهادة في ملف
cert-format-base64 = شهادة ‪X.509 (PEM)‬
cert-format-base64-chain = شهادة ‪X.509 (PEM)‬ مع سلسلة
cert-format-der = شهادة ‪X.509‬‏ (DER)
cert-format-pkcs7 = شهادة ‪X.509 (PKCS#7)
cert-format-pkcs7-chain = شهادة ‪X.509 (PKCS#7)‬ مع سلسلة
write-file-failure = خطأ في الملف
