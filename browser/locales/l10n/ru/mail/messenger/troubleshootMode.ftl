# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = Безопасный режим { -brand-short-name }
    .style = width: 37em;

troubleshoot-mode-description = Используйте безопасный режим { -brand-short-name } для диагностики проблем. Ваши дополнения и настройки будут временно отключены.

troubleshoot-mode-description2 = Произведённые вами изменения настроек вступят в силу при перезапуске в обычном режиме:

troubleshoot-mode-disable-addons =
    .label = Отключить все дополнения
    .accesskey = п

troubleshoot-mode-reset-toolbars =
    .label = Сбросить настройки панелей инструментов и элементов управления
    .accesskey = б

troubleshoot-mode-change-and-restart =
    .label = Произвести изменения и перезапустить
    .accesskey = е

troubleshoot-mode-continue =
    .label = Продолжить в Безопасном Режиме
    .accesskey = ж

troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] Выход
           *[other] Выход
        }
    .accesskey =
        { PLATFORM() ->
            [windows] х
           *[other] х
        }
