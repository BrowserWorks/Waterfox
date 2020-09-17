# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = צבעים
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = טקסט ורקע

text-color-label =
    .value = טקסט:
    .accesskey = ט

background-color-label =
    .value = רקע:
    .accesskey = ר

use-system-colors =
    .label = שימוש בצבעי המערכת
    .accesskey = צ

colors-link-legend = צבעי קישורים

link-color-label =
    .value = קישורים שלא ביקרת בהם:
    .accesskey = ל

visited-link-color-label =
    .value = קישורים שביקרת בהם:
    .accesskey = ב

underline-link-checkbox =
    .label = קו מתחת לקישורים
    .accesskey = ת

override-color-label =
    .value = דריסת הצבעים שהוקצו על ידי התוכן עם בחירותי שלהלן:
    .accesskey = ד

override-color-always =
    .label = תמיד

override-color-auto =
    .label = רק בערכות נושא בניגודיות גבוהה

override-color-never =
    .label = לעולם לא
