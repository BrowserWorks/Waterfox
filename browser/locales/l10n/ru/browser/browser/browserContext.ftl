# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Потяните вниз для показа истории
           *[other] Щёлкните правой кнопкой или потяните вниз для показа истории
        }

## Back

main-context-menu-back =
    .tooltiptext = На предыдущую страницу
    .aria-label = Назад
    .accesskey = а
navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }
toolbar-button-back =
    .label = { main-context-menu-back.aria-label }
# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = На предыдущую страницу ({ $shortcut })
    .aria-label = Назад
    .accesskey = а
# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = Назад
    .accesskey = а
navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }
toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = На следующую страницу
    .aria-label = Вперёд
    .accesskey = е
navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }
toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }
# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = На следующую страницу ({ $shortcut })
    .aria-label = Вперёд
    .accesskey = е
# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = Вперёд
    .accesskey = е
navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }
toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Обновить
    .accesskey = в
# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = Обновить
    .accesskey = в
toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Остановить
    .accesskey = н
# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = Остановить
    .accesskey = н
toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Firefox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name }
    .tooltiptext = { -fxaccount-brand-name }

## Save Page

main-context-menu-page-save =
    .label = Сохранить как…
    .accesskey = р
toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Добавить страницу в закладки
    .accesskey = в
    .tooltiptext = Добавить страницу в закладки
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = Добавить в закладки
    .accesskey = в
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = Изменить закладку
    .accesskey = м
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Добавить страницу в закладки
    .accesskey = в
    .tooltiptext = Добавить страницу в закладки ({ $shortcut })
main-context-menu-bookmark-change =
    .aria-label = Редактировать эту закладку
    .accesskey = в
    .tooltiptext = Редактировать эту закладку
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Редактировать эту закладку
    .accesskey = в
    .tooltiptext = Редактировать эту закладку ({ $shortcut })
main-context-menu-open-link =
    .label = Открыть ссылку
    .accesskey = к
main-context-menu-open-link-new-tab =
    .label = Открыть ссылку в новой вкладке
    .accesskey = в
main-context-menu-open-link-container-tab =
    .label = Открыть ссылку в новой вкладке в контейнере
    .accesskey = е
main-context-menu-open-link-new-window =
    .label = Открыть ссылку в новом окне
    .accesskey = ь
main-context-menu-open-link-new-private-window =
    .label = Открыть ссылку в новом приватном окне
    .accesskey = п
main-context-menu-bookmark-this-link =
    .label = Добавить ссылку в закладки
    .accesskey = с
main-context-menu-bookmark-link =
    .label = Добавить в закладки
    .accesskey = з
main-context-menu-save-link =
    .label = Сохранить объект как…
    .accesskey = х
main-context-menu-save-link-to-pocket =
    .label = Сохранить ссылку в { -pocket-brand-name }
    .accesskey = н

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.


## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Копировать адрес электронной почты
    .accesskey = э
main-context-menu-copy-link =
    .label = Копировать ссылку
    .accesskey = ы
main-context-menu-copy-link-simple =
    .label = Копировать ссылку
    .accesskey = л

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Воспроизвести
    .accesskey = с
main-context-menu-media-pause =
    .label = Приостановить
    .accesskey = с

##

main-context-menu-media-mute =
    .label = Убрать звук
    .accesskey = т
main-context-menu-media-unmute =
    .label = Восстановить звук
    .accesskey = т
main-context-menu-media-play-speed =
    .label = Скорость воспроизведения
    .accesskey = к
main-context-menu-media-play-speed-slow =
    .label = Замедленная (0.5×)
    .accesskey = м
main-context-menu-media-play-speed-normal =
    .label = Нормальная
    .accesskey = о
main-context-menu-media-play-speed-fast =
    .label = Повышенная (1.25×)
    .accesskey = ш
main-context-menu-media-play-speed-faster =
    .label = Высокая (1.5×)
    .accesskey = ы
# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Безумная (2×)
    .accesskey = з
main-context-menu-media-play-speed-2 =
    .label = Скорость
    .accesskey = к
main-context-menu-media-play-speed-slow-2 =
    .label = 0.5×
main-context-menu-media-play-speed-normal-2 =
    .label = 1.0×
main-context-menu-media-play-speed-fast-2 =
    .label = 1.25×
main-context-menu-media-play-speed-faster-2 =
    .label = 1.5×
main-context-menu-media-play-speed-fastest-2 =
    .label = 2×
main-context-menu-media-loop =
    .label = Повторять
    .accesskey = в

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Показать пульт управления
    .accesskey = п
main-context-menu-media-hide-controls =
    .label = Скрыть пульт управления
    .accesskey = п

##

main-context-menu-media-video-fullscreen =
    .label = Полный экран
    .accesskey = л
main-context-menu-media-video-leave-fullscreen =
    .label = Выйти из полноэкранного режима
    .accesskey = ы
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Картинка в картинке
    .accesskey = и
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-watch-pip =
    .label = Смотреть в режиме «Картинка в картинке»
    .accesskey = а
main-context-menu-image-reload =
    .label = Перезагрузить изображение
    .accesskey = и
main-context-menu-image-view =
    .label = Открыть изображение
    .accesskey = т
main-context-menu-video-view =
    .label = Открыть видео
    .accesskey = т
main-context-menu-image-view-new-tab =
    .label = Открыть изображение в новой вкладке
    .accesskey = ы
main-context-menu-video-view-new-tab =
    .label = Открыть видео в новой вкладке
    .accesskey = и
main-context-menu-image-copy =
    .label = Копировать изображение
    .accesskey = и
main-context-menu-image-copy-location =
    .label = Копировать ссылку на изображение
    .accesskey = п
main-context-menu-video-copy-location =
    .label = Копировать ссылку на видео
    .accesskey = п
main-context-menu-audio-copy-location =
    .label = Копировать ссылку на аудио
    .accesskey = п
main-context-menu-image-copy-link =
    .label = Копировать ссылку на изображение
    .accesskey = р
main-context-menu-video-copy-link =
    .label = Копировать ссылку на видео
    .accesskey = в
main-context-menu-audio-copy-link =
    .label = Копировать ссылку на аудио
    .accesskey = д
main-context-menu-image-save-as =
    .label = Сохранить изображение как…
    .accesskey = о
main-context-menu-image-email =
    .label = Отправить изображение по почте…
    .accesskey = а
main-context-menu-image-set-as-background =
    .label = Сделать фоновым рисунком рабочего стола…
    .accesskey = е
main-context-menu-image-set-image-as-background =
    .label = Сделать фоновым рисунком рабочего стола…
    .accesskey = у
main-context-menu-image-info =
    .label = Информация об изображении
    .accesskey = з
main-context-menu-image-desc =
    .label = Описание изображения
    .accesskey = а
main-context-menu-video-save-as =
    .label = Сохранить видео как…
    .accesskey = о
main-context-menu-audio-save-as =
    .label = Сохранить аудио как…
    .accesskey = о
main-context-menu-video-image-save-as =
    .label = Сохранить кадр как…
    .accesskey = х
main-context-menu-video-take-snapshot =
    .label = Захватить кадр…
    .accesskey = х
main-context-menu-video-email =
    .label = Отправить видео по почте…
    .accesskey = а
main-context-menu-audio-email =
    .label = Отправить аудио по почте…
    .accesskey = а
main-context-menu-plugin-play =
    .label = Включить этот плагин
    .accesskey = ю
main-context-menu-plugin-hide =
    .label = Скрыть этот плагин
    .accesskey = к
main-context-menu-save-to-pocket =
    .label = Сохранить страницу в { -pocket-brand-name }
    .accesskey = ь
main-context-menu-send-to-device =
    .label = Отправить страницу на устройство
    .accesskey = п
main-context-menu-view-background-image =
    .label = Открыть фоновое изображение
    .accesskey = ы
main-context-menu-generate-new-password =
    .label = Использовать сгенерированный пароль…
    .accesskey = п

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = Использовать сохранённый логин
    .accesskey = й
main-context-menu-use-saved-password =
    .label = Использовать сохраненный пароль
    .accesskey = н

##

main-context-menu-suggest-strong-password =
    .label = Предложить надежный пароль…
    .accesskey = ж
main-context-menu-manage-logins2 =
    .label = Управление логинами
    .accesskey = п
main-context-menu-keyword =
    .label = Добавить краткое имя для данного поиска…
    .accesskey = с
main-context-menu-link-send-to-device =
    .label = Отправить ссылку на устройство
    .accesskey = п
main-context-menu-frame =
    .label = В этом фрейме
    .accesskey = ф
main-context-menu-frame-show-this =
    .label = Показать только этот фрейм
    .accesskey = П
main-context-menu-frame-open-tab =
    .label = Открыть фрейм в новой вкладке
    .accesskey = в
main-context-menu-frame-open-window =
    .label = Открыть фрейм в новом окне
    .accesskey = н
main-context-menu-frame-reload =
    .label = Обновить фрейм
    .accesskey = и
main-context-menu-frame-bookmark =
    .label = Добавить фрейм в закладки
    .accesskey = б
main-context-menu-frame-save-as =
    .label = Сохранить фрейм как…
    .accesskey = н
main-context-menu-frame-print =
    .label = Печать фрейма…
    .accesskey = ч
main-context-menu-frame-view-source =
    .label = Исходный код фрейма
    .accesskey = о
main-context-menu-frame-view-info =
    .label = Информация о фрейме
    .accesskey = ц
main-context-menu-print-selection =
    .label = Печать выделенной области
    .accesskey = ы
main-context-menu-view-selection-source =
    .label = Исходный код выделенного фрагмента
    .accesskey = д
main-context-menu-take-screenshot =
    .label = Сделать скриншот
    .accesskey = ш
main-context-menu-take-frame-screenshot =
    .label = Сделать скриншот
    .accesskey = ш
main-context-menu-view-page-source =
    .label = Исходный код страницы
    .accesskey = о
main-context-menu-view-page-info =
    .label = Информация о странице
    .accesskey = ц
main-context-menu-bidi-switch-text =
    .label = Переключить направление текста на странице
    .accesskey = т
main-context-menu-bidi-switch-page =
    .label = Переключить направление текста на странице
    .accesskey = н
main-context-menu-inspect-element =
    .label = Исследовать элемент
    .accesskey = л
main-context-menu-inspect =
    .label = Исследовать
    .accesskey = е
main-context-menu-inspect-a11y-properties =
    .label = Исследовать свойства поддержки доступности
main-context-menu-eme-learn-more =
    .label = Узнать больше о DRM…
    .accesskey = а
