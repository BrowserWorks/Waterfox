# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = أنشئ صفحة طُرز جديدة ثم ألحقها بالمستند
    .accesskey = ج
styleeditor-import-button =
    .tooltiptext = استورد صفحة طُرز ثم ألحقها بالمستند
    .accesskey = س
styleeditor-visibility-toggle =
    .tooltiptext = بدّل ظهور صفحة الطُرز
    .accesskey = ح
styleeditor-save-button = احفظ
    .tooltiptext = احفظ صفحة الطُرز في ملف
    .accesskey = ح
styleeditor-options-button =
    .tooltiptext = خيارات محرر الأنماط
styleeditor-editor-textbox =
    .data-placeholder = اكتب CSS هنا.
styleeditor-no-stylesheet = ليس لهذه الصفحة أي طُرز.
styleeditor-no-stylesheet-tip = أترغب في <a data-l10n-name="append-new-stylesheet">إلحاق صفحة طُرز</a>بها؟
styleeditor-open-link-new-tab =
    .label = افتح الرابط في لسان جديد
styleeditor-copy-url =
    .label = انسخ المسار
styleeditor-find =
    .label = ابحث
    .accesskey = ب
styleeditor-find-again =
    .label = ابحث مجددًا
    .accesskey = ب
styleeditor-go-to-line =
    .label = اقفز إلى سطر…
    .accesskey = ق

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [zero] لا قواعد.
        [one] قاعدة واحدة.
        [two] قاعدتان.
        [few] { $ruleCount } قواعد.
        [many] { $ruleCount } قاعدة.
       *[other] { $ruleCount } قاعدة.
    }
