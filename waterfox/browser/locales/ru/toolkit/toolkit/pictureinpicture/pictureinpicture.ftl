# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = Картинка в картинке

## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.
##
## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

pictureinpicture-pause-btn =
    .aria-label = Приостановить
    .tooltip = Приостановить (Пробел)
pictureinpicture-play-btn =
    .aria-label = Воспроизвести
    .tooltip = Воспроизвести (Пробел)

pictureinpicture-mute-btn =
    .aria-label = Отключить звук
    .tooltip = Отключить звук ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Включить звук
    .tooltip = Включить звук ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Отправить обратно во вкладку
    .tooltip = Обратно во вкладку

pictureinpicture-close-btn =
    .aria-label = Закрыть
    .tooltip = Закрыть ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Субтитры
    .tooltip = Субтитры

pictureinpicture-fullscreen-btn2 =
    .aria-label = На весь экран
    .tooltip = На весь экран (двойной щелчок или { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = Выйти из полноэкранного режима
    .tooltip = Выйти из полноэкранного режима (двойной щелчок или { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Назад
    .tooltip = Назад (←)

pictureinpicture-seekforward-btn =
    .aria-label = Вперёд
    .tooltip = Вперёд (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Настройки субтитров

pictureinpicture-subtitles-label = Субтитры

pictureinpicture-font-size-label = Размер шрифта

pictureinpicture-font-size-small = Маленький

pictureinpicture-font-size-medium = Средний

pictureinpicture-font-size-large = Большой
