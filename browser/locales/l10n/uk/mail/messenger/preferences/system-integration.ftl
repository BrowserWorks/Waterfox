# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Системна інтеграція

system-integration-dialog =
    .buttonlabelaccept = Встановити типовим
    .buttonlabelcancel = Пропустити інтеграцію
    .buttonlabelcancel2 = Скасувати

default-client-intro = Використовувати { -brand-short-name } як типовий клієнт для:

unset-default-tooltip = Неможливо скасувати встановлення { -brand-short-name } типовим клієнтом в межах { -brand-short-name }. Щоб встановити іншу програму типовою, ви повинні скористатись відповідним запитом тої програми.

checkbox-email-label =
    .label = Електронної пошти
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Груп новин
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Стрічок
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
    .label = Дозволити { system-search-engine-name } шукати повідомлення
    .accesskey = ш

check-on-startup-label =
    .label = Завжди виконувати цю перевірку при запуску { -brand-short-name }
    .accesskey = З
