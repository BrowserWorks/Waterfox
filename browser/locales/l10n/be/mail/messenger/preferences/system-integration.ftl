# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Узаемадзеянне з сістэмай

system-integration-dialog =
    .buttonlabelaccept = Прызначыць змоўчным
    .buttonlabelcancel = Прапусціць узаемадзеянне
    .buttonlabelcancel2 = Скасаваць

default-client-intro = Ужываць { -brand-short-name } як змоўчны спажывец:

unset-default-tooltip = Немагчыма адмяніць прызначэнне { -brand-short-name } змоўным спажыўцом у { -brand-short-name }. Каб зрабіць іншае прыстасаванне змоўчным, вы мусіце скарыстацца яго дыялогам 'Прызначэнне змоўчным'.

checkbox-email-label =
    .label = Э-пошты
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Навінакупаў
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Жывільнікаў
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Пошук Windows
       *[other] { "" }
    }

system-search-integration-label =
    .label = Дазволіць { system-search-engine-name } шукаць лісты
    .accesskey = ш

check-on-startup-label =
    .label = Заўсёды рабіць гэтую праверку падчас запуску { -brand-short-name }
    .accesskey = ў
