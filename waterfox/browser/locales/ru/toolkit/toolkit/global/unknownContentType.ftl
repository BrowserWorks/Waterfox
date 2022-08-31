# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

unknowncontenttype-handleinternally =
    .label = Открыть с помощью { -brand-short-name }
    .accesskey = ы

unknowncontenttype-settingschange =
    .value =
        { PLATFORM() ->
            [windows] Параметры могут быть изменены в настройках { -brand-short-name }.
           *[other] Параметры могут быть изменены в настройках { -brand-short-name }.
        }

unknowncontenttype-intro = Вы собираетесь открыть:
unknowncontenttype-which-is = являющийся:
unknowncontenttype-from = из
unknowncontenttype-prompt = Вы хотите сохранить этот файл?
unknowncontenttype-action-question = Как { -brand-short-name } следует обработать этот файл?
unknowncontenttype-open-with =
    .label = Открыть в
    .accesskey = т
unknowncontenttype-other =
    .label = Выбрать…
unknowncontenttype-choose-handler =
    .label =
        { PLATFORM() ->
            [macos] Выбрать…
           *[other] Обзор…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] а
           *[other] б
        }
unknowncontenttype-save-file =
    .label = Сохранить файл
    .accesskey = х
unknowncontenttype-remember-choice =
    .label = Выполнять автоматически для всех файлов данного типа.
    .accesskey = ы
