# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = قوائم الحجب
    .style = width: 55em
blocklist-description = اختر القائمة التي على { -brand-short-name } استخدامها لحجب المتعقّبات على الشبكة. تُقدّم <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a> هذه القوائم.
blocklist-close-key =
    .key = w
blocklist-treehead-list =
    .label = قائمة
blocklist-button-cancel =
    .label = ألغِ
    .accesskey = ل
blocklist-button-ok =
    .label = احفظ التغييرات
    .accesskey = ح
blocklist-dialog =
    .buttonlabelaccept = احفظ التغييرات
    .buttonaccesskeyaccept = ح
# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = ‏{ $listName } ‏{ $description }
blocklist-item-moz-std-listName = المستوی الأول من قائمة الحجب (مستحسن).
blocklist-item-moz-std-description = يترك بعض المتعقّبات على حالها لألا تعطب الكثير من المواقع.
blocklist-item-moz-full-listName = المستوى الثاني من قائمة الحجب.
blocklist-item-moz-full-description = يحجب كل المتعقّبات المكتشفة. يمكن ألا تتحمّل بعض المواقع أو أجزاء منها كما ينبغي.
