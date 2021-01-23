# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Системска интеграција

system-integration-dialog =
    .buttonlabelaccept = Подеси као подразумевано
    .buttonlabelcancel = Прескочи интеграцију
    .buttonlabelcancel2 = Откажи

default-client-intro = Користи { -brand-short-name } као подразумевани клијент за:

unset-default-tooltip = Није могуће подесити да { -brand-short-name } не буде више подразумевани клијент унутар самог { -brand-short-name }-а. Да бисте подесили да неки други програм буде подразумевани, морате искористити „Подеси као подразумевано“ дијалог тог програма.

checkbox-email-label =
    .label = Е-пошту
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Новинске групе
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Доводе
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows претрага
       *[other] { "" }
    }

system-search-integration-label =
    .label = Дозволи програму { system-search-engine-name } да претражује поруке
    .accesskey = Д

check-on-startup-label =
    .label = Увек изврши ову проверу приликом покретања { -brand-short-name }-а
    .accesskey = У
