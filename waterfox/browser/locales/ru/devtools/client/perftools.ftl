# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Настройки профайлера
perftools-intro-description =
    Запись запустит profiler.firefox.com в новой вкладке. Все данные хранятся
    локально, но вы можете поделиться ими, выгрузив их.

## All of the headings for the various sections.

perftools-heading-settings = Все настройки
perftools-heading-buffer = Настройки буфера
perftools-heading-features = Функции
perftools-heading-features-default = Функции (рекомендованные к включению по умолчанию)
perftools-heading-features-disabled = Отключённые функции
perftools-heading-features-experimental = Экспериментальные
perftools-heading-threads = Потоки
perftools-heading-threads-jvm = Потоки JVM
perftools-heading-local-build = Локальная сборка

##

perftools-description-intro =
    Запись запустит <a>profiler.firefox.com</a> в новой вкладке. Все данные хранятся
    локально, но вы можете поделиться ими, выгрузив их.
perftools-description-local-build =
    Если вы профилируете сборку, которую скомпилировали самостоятельно на этой
    машине, добавьте objdir вашей сборки в список ниже, чтобы
    её можно было использовать в поиске символьной информации.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Интервал выборки:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } мс

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Размер буфера:
perftools-custom-threads-label = Добавить собственные потоки по имени:
perftools-devtools-interval-label = Интервал:
perftools-devtools-threads-label = Потоки:
perftools-devtools-settings-label = Настройки

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-recording-stopped-by-another-tool = Запись была остановлена другим инструментом.
perftools-status-restart-required = Для включения этой функции необходимо перезапустить браузер.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Остановка записи
perftools-request-to-get-profile-and-stop-profiler = Захват профиля

##

perftools-button-start-recording = Начать запись
perftools-button-capture-recording = Захватить запись
perftools-button-cancel-recording = Отменить запись
perftools-button-save-settings = Сохранить настройки и вернуться
perftools-button-restart = Перезапустить
perftools-button-add-directory = Добавить каталог
perftools-button-remove-directory = Удалить выбранное
perftools-button-edit-settings = Изменить настройки…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = Основные процессы как для родительского процесса, так и для процессов контента
perftools-thread-compositor =
    .title = Объединяет различные отрисованные элементы на странице
perftools-thread-dom-worker =
    .title = Обрабатывает как web worker'ы, так и service worker'ы
perftools-thread-renderer =
    .title = Когда WebRender включён, этот поток выполняет вызовы OpenGL
perftools-thread-render-backend =
    .title = Поток WebRender RenderBackend
perftools-thread-paint-worker =
    .title = Поток, в котором происходит отрисовка, когда включена отрисовка вне основного потока
perftools-thread-timer =
    .title = Таймеры обработки потока (setTimeout, setInterval, nsITimer)
perftools-thread-style-thread =
    .title = Вычисление стилей разбито на несколько потоков
pref-thread-stream-trans =
    .title = Сетевой потоковый транспорт
perftools-thread-socket-thread =
    .title = Поток, в котором сетевой код запускает любые вызовы блокирующие сокеты
perftools-thread-img-decoder =
    .title = Потоки декодирования изображений
perftools-thread-dns-resolver =
    .title = В этом потоке происходит разрешение DNS
perftools-thread-task-controller =
    .title = Потоки пула потоков TaskController
perftools-thread-jvm-gecko =
    .title = Основной поток Gecko JVM
perftools-thread-jvm-nimbus =
    .title = Основные потоки для SDK экспериментов Nimbus
perftools-thread-jvm-default-dispatcher =
    .title = Диспетчер по умолчанию для библиотеки сопрограмм Kotlin
perftools-thread-jvm-glean =
    .title = Основные потоки для SDK телеметрии Glean
perftools-thread-jvm-arch-disk-io =
    .title = Диспетчер ввода-вывода для библиотеки сопрограмм Kotlin
perftools-thread-jvm-pool =
    .title = Потоки, созданные в безымянном пуле потоков

##

perftools-record-all-registered-threads = Игнорировать выбор выше и записывать все регистрируемые потоки
perftools-tools-threads-input-label =
    .title = Эти имена потоков представляют собой список разделенный запятыми, который используется для включения профилирования потоков в профайлере. Имя может быть только частичным совпадением с именем потока, который будет включён. Это поле чувствительно к пробелам.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## devtools.performance.new-panel-onboarding preference is true.

perftools-onboarding-message = <b>Новое</b>:  В Инструменты разработчика теперь интегрирован { -profiler-brand-name }. <a>Узнайте больше</a> об этом новом, мощном инструменте.
perftools-onboarding-close-button =
    .aria-label = Закрыть приветственное сообщение

## Profiler presets


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# The same labels and descriptions are also defined in appmenu.ftl.

perftools-presets-web-developer-label = Веб-разработка
perftools-presets-web-developer-description = Рекомендуемые настройки для отладки большинства веб-приложений с низкими накладными расходами.
perftools-presets-firefox-label = { -brand-shorter-name }
perftools-presets-firefox-description = Рекомендуемые настройки для профилирования { -brand-shorter-name }.
perftools-presets-graphics-label = Графика
perftools-presets-graphics-description = Настройки для выявления ошибок графики в { -brand-shorter-name }.
perftools-presets-media-label = Медиа
perftools-presets-media-description2 = Настройки для выявления ошибок аудио и видео в { -brand-shorter-name }.
perftools-presets-networking-label = Сеть
perftools-presets-networking-description = Настройки для выявления сетевых ошибок в { -brand-shorter-name }.
# "Power" is used in the sense of energy (electricity used by the computer).
perftools-presets-power-label = Электропитание
perftools-presets-power-description = Настройки для выявления ошибок потребления энергии в { -brand-shorter-name }, с небольшими накладными расходами.
perftools-presets-custom-label = Персональный

##

