# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = تقرير عن { $addon-name }

abuse-report-title-extension = أبلِغ { -vendor-short-name } عن هذا الامتداد
abuse-report-title-theme = أبلِغ { -vendor-short-name } عن هذه السمة
abuse-report-subtitle = ما المشكلة؟

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = طوّرها <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    لا تعرف ما تختار؟
    <a data-l10n-name="learnmore-link">اطّلع على المزيد حول الإبلاغ عن الامتدادات والسمات</a>

abuse-report-submit-description = صِف المشكلة (لو أردت)
abuse-report-textarea =
    .placeholder = سيسهل علينا فهم المشكلة لو عرفنا تفاصيلها، فمن فضلك صِف المشكلة التي تُواجهها، ونشكرك على مساعدتنا في الحفاظ على صحّة الوِب.
abuse-report-submit-note =
    ملاحظة: لا تضع أيّ معلومات شخصية (مثل الاسم وعنوان البريد الإلكتروني ورقم الهاتف وعنوان سكنك).
    تحتفظ { -vendor-short-name } بكامل هذه التقارير في سجلّ.

## Panel buttons.

abuse-report-cancel-button = ألغِ
abuse-report-next-button = التالي
abuse-report-goback-button = عُد
abuse-report-submit-button = أرسِل

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = أُلغي التقرير عن <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitting = يُرسل تقريرًا عن <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = نشكرك على إرسال التقرير. أتريد إزالة <span data-l10n-name="addon-name">{ $addon-name }</span>؟
abuse-report-messagebar-submitted-noremove = نشكرك على إرسال التقرير.
abuse-report-messagebar-removed-extension = نشكرك على إرسال التقرير. أزلت بنجاح الامتداد <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = نشكرك على إرسال التقرير. أزلت بنجاح السمة <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = حدث خطأ في إرسال التقرير عن <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = لم يُرسل التقرير عن <span data-l10n-name="addon-name">{ $addon-name }</span> إذ أُرسل تقرير آخر عنها حديثًا.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = نعم ، أزِله
abuse-report-messagebar-action-keep-extension = لا، سأُبقيه
abuse-report-messagebar-action-remove-theme = نعم، أزِلها
abuse-report-messagebar-action-keep-theme = لا، سأُبقيها
abuse-report-messagebar-action-retry = أعِد المحاولة
abuse-report-messagebar-action-cancel = ألغِ

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = أتلفَ حاسوبي أو كشف عن بياناتي

abuse-report-settings-reason-v2 = غيّر محرّك البحث أو الصفحة الرئيسة أو صفحة اللسان الجديد دون إعلامي أو طلب ذلك
abuse-report-settings-suggestions = قبل الإبلاغ عن الامتداد، جرّب تعديل إعداداتك:
abuse-report-settings-suggestions-search = غيّر إعدادات البحث المبدئية
abuse-report-settings-suggestions-homepage = غيّر الصفحة الرئيسة وصفحة اللسان الجديد

abuse-report-unwanted-reason-v2 = لم أرده من الأساس ولا أعلم كيف أحذفه
abuse-report-unwanted-example = أمثلة: أحد التطبيقات ثبّته دون طلب ذلك مني

abuse-report-other-reason = شيء آخر

