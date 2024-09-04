# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = Расширение не может читать и изменять данные
origin-controls-quarantined =
    .label = Расширению запрещено читать и изменять данные
origin-controls-quarantined-status =
    .label = Расширение запрещено на сайтах с ограничениями
origin-controls-quarantined-allow =
    .label = Разрешить на сайтах с ограничениями
origin-controls-options =
    .label = Расширение может читать и изменять данные:
origin-controls-option-all-domains =
    .label = На всех страницах
origin-controls-option-when-clicked =
    .label = Только при щелчке
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = Всегда разрешать на { $domain }

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = Не может читать и изменять данные на этой странице
origin-controls-state-quarantined = Запрещено { -vendor-short-name } на этом сайте
origin-controls-state-always-on = Всегда может читать и изменять данные на этой странице
origin-controls-state-when-clicked = Требуется разрешение на чтение и изменение данных
origin-controls-state-hover-run-visit-only = Выполнить только для этого посещения
origin-controls-state-runnable-hover-open = Открыть расширение
origin-controls-state-runnable-hover-run = Запустить расширение
origin-controls-state-temporary-access = Может читать и изменять данные для этого посещения

## Extension's toolbar button.
## Variables:
##   $extensionTitle (String) - Extension name or title message.

origin-controls-toolbar-button =
    .label = { $extensionTitle }
    .tooltiptext = { $extensionTitle }
# Extension's toolbar button when permission is needed.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-permission-needed =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Необходимо разрешение
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Не разрешено { -vendor-short-name } на этом сайте
