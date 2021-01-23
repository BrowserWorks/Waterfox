# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Съчетаване с операционната система

system-integration-dialog =
    .buttonlabelaccept = По подразбиране
    .buttonlabelcancel = Прескачане на интеграцията
    .buttonlabelcancel2 = Отмяна

default-client-intro = Използване на { -brand-short-name } като клиент по подразбиране за:

unset-default-tooltip = Не е възможно да отмените { -brand-short-name } като клиент по подразбиране за { -brand-short-name } За да изберете друго приложение, трябва да използвате диалога "По подразбиране".

checkbox-email-label =
    .label = Електронна поща
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Дискусионни групи
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Емисии
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
    .label = Разрешаване на { system-search-engine-name } да търси съобщения
    .accesskey = т

check-on-startup-label =
    .label = Винаги се прави тази проверка при стартиране на { -brand-short-name }
    .accesskey = В
