# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Интеграция с системой

system-integration-dialog =
    .buttonlabelaccept = Установить по умолчанию
    .buttonlabelcancel = Пропустить интеграцию
    .buttonlabelcancel2 = Отмена

default-client-intro = Использовать { -brand-short-name } по умолчанию в качестве:

unset-default-tooltip = Нельзя отказаться от использования { -brand-short-name } в качестве клиента по умолчанию, находясь в самом { -brand-short-name }. Чтобы установить другое приложение в качестве клиента по умолчанию, вы должны воспользоваться его функцией «установки по умолчанию».

checkbox-email-label =
    .label = Почтового клиента
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Клиента групп новостей
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Клиента лент новостей
    .tooltiptext = { unset-default-tooltip }

checkbox-calendar-label =
    .label = Календаря
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Поиску Windows
       *[other] { "" }
    }

system-search-integration-label =
    .label = Разрешить { system-search-engine-name } производить поиск сообщений
    .accesskey = з

check-on-startup-label =
    .label = Всегда производить эту проверку при запуске { -brand-short-name }
    .accesskey = В
