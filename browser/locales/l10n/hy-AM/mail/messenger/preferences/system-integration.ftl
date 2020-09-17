# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Համակարգային ինտեգրում

system-integration-dialog =
    .buttonlabelaccept = Նշել որպես հիմնական
    .buttonlabelcancel = Բաց թողնել ինտեգրացիան
    .buttonlabelcancel2 = Չեղարկել

default-client-intro = Օգտ. { -brand-short-name }-ը որպես հիմնական ծրագիր՝

unset-default-tooltip = It is not possible to unset { -brand-short-name } as the default client within { -brand-short-name }. To make another application the default you must use its 'Set as default' dialog.

checkbox-email-label =
    .label = Էլ. նամակ
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Լուրախմբեր
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Շղթաների
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
    .label = Թույլատրել { system-search-engine-name }-ին որոնել նամակներ
    .accesskey = s

check-on-startup-label =
    .label = { -brand-short-name }-ը բացելիս միշտ ստուգել այս ընտրությունը։
    .accesskey = A
