# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Выгрузка вкладки
about-unloads-intro-1 =
    { -brand-short-name } имеет функцию, которая автоматически выгружает вкладки,
    чтобы предотвратить сбой приложения из-за нехватки памяти,
    когда в системе мало доступной памяти. Следующая вкладка, которую нужно выгрузить,
    выбирается на основе нескольких атрибутов. На этой странице показано, как
    { -brand-short-name } определяет приоритеты вкладок, и какая вкладка будет выгружена при срабатывании функции выгрузки вкладки.
about-unloads-intro-2 = Открытые вкладки отображены в таблице ниже, в том же порядке, в котором { -brand-short-name } будет выбирать следующую вкладку для выгрузки. Идентификатор процесса выделен <strong>жирным шрифтом</strong>, если в нём размещён верхний фрейм вкладки, и <em>курсивом</em>, если в процессе размещены разные вкладки. Вы можете запустить выгрузку вкладки вручную, щёлкнув ниже по кнопке <em>Выгрузить</em>.
about-unloads-intro = { -brand-short-name } имеет функцию, которая автоматически выгружает вкладки, чтобы предотвратить сбой приложения из-за нехватки памяти, когда в системе мало доступной памяти. Следующая вкладка, которую нужно выгрузить, выбирается на основе нескольких параметров. На этой странице показано, как { -brand-short-name } определяет приоритеты вкладок, и какая вкладка будет выгружена при срабатывании функции выгрузки вкладки. Вы можете запустить выгрузку вкладки вручную, щёлкнув по кнопке <em>Выгрузить</em> ниже.
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more = Чтобы узнать больше о функции и этой странице, обратитесь к странице <a data-l10n-name="doc-link">Выгрузка вкладки</a>.
about-unloads-last-updated = Последнее обновление: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Выгрузить
    .title = Выгрузить вкладку с наивысшим приоритетом
about-unloads-no-unloadable-tab = Нет выгружаемых вкладок.
about-unloads-column-priority = Приоритет
about-unloads-column-host = Узел
about-unloads-column-last-accessed = Последний доступ
about-unloads-column-weight = Базовый вес
    .title = Вкладки сначала сортируются по этому значению, которое определяется некоторыми специальными атрибутами, такими как воспроизведение звука, WebRTC и т.д.
about-unloads-column-sortweight = Вторичный вес
    .title = Если доступно, вкладки сортируются по этому значению после сортировки по базовому весу. Значение зависит от использования памяти вкладкой и числа процессов.
about-unloads-column-memory = Память
    .title = Предполагаемое использование памяти вкладкой
about-unloads-column-processes = Идентификаторы процессов
    .title = Идентификаторы процессов, в которых размещено содержимое вкладки
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } МБ
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } МБ
