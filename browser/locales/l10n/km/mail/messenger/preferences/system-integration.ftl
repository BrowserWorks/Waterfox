# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Համակարգային ինտեգրում

system-integration-dialog =
    .buttonlabelaccept = ​កំណត់​ជា​លំនាំដើម
    .buttonlabelcancel = រំលង​ការដាក់​​បញ្ចូល​
    .buttonlabelcancel2 = បោះបង់

default-client-intro = Օգտ. { -brand-short-name }-ը որպես հիմնական ծրագիր՝

unset-default-tooltip = មិន​អាច​កំណត់ { -brand-short-name } ជា​ម៉ាស៊ីន​លំនាំដើម​ក្នុង { -brand-short-name } ។ ដើម្បី​ធ្វើ​ឲ្យ​កម្មវិធីផ្សេង​ជា​លំនាំដើម​ដែល​អ្នក​ត្រូវ​តែ​ប្រើ​ប្រអប់ 'កំណត់​ជា​លំនាំដើម' ។

checkbox-email-label =
    .label = E-Mail
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Նորությունների
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
    .label = Թույլատրել { system-search-engine-name }-ին փնտրելու նամակներ
    .accesskey = s

check-on-startup-label =
    .label = { -brand-short-name }-ը բացելիս միշտ ստուգել այս ընտրությունը։
    .accesskey = A
