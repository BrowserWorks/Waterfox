# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = التكامل مع النظام

system-integration-dialog =
    .buttonlabelaccept = اجعله المبدئي
    .buttonlabelcancel = تجاوز التكامل مع النظام
    .buttonlabelcancel2 = ألغِ

default-client-intro = اجعل { -brand-short-name } العميل المبدئي ل‍:

unset-default-tooltip = لا يمكن تغيير كون { -brand-short-name } العميل المبدئي من داخله. لجعل تطبيق آخر المبدئي، عليك فعله هذا من داخل التطبيق الآخر.

checkbox-email-label =
    .label = البريد الإلكتروني
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = مجموعات الأخبار
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = التلقيمات
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

system-search-integration-label =
    .label = اسمح ل‍ { system-search-engine-name } بالبحث في الرسائل
    .accesskey = س

check-on-startup-label =
    .label = تحقق دائمًا من ذلك عند بدء { -brand-short-name }
    .accesskey = ء
