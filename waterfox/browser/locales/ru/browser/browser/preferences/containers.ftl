# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Добавить новый контейнер
    .style = width: 45em

# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Настройки контейнера { $name }
    .style = width: 45em

containers-window-close =
    .key = w

# This is a term to store style to be applied
# on the three labels in the containers add/edit dialog:
#   - name
#   - icon
#   - color
#
# Using this term and referencing it in the `.style` attribute
# of the three messages ensures that all three labels
# will be aligned correctly.
-containers-labels-style = min-width: 4rem

containers-name-label = Имя
    .accesskey = м
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Введите имя контейнера

containers-icon-label = Значок
    .accesskey = а
    .style = { -containers-labels-style }

containers-color-label = Цвет
    .accesskey = е
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = Готово
    .buttonaccesskeyaccept = о

containers-color-blue =
    .label = Синий
containers-color-turquoise =
    .label = Бирюзовый
containers-color-green =
    .label = Зелёный
containers-color-yellow =
    .label = Жёлтый
containers-color-orange =
    .label = Оранжевый
containers-color-red =
    .label = Красный
containers-color-pink =
    .label = Розовый
containers-color-purple =
    .label = Фиолетовый
containers-color-toolbar =
    .label = Как панель инструментов

containers-icon-fence =
    .label = Ограда
containers-icon-fingerprint =
    .label = Отпечаток
containers-icon-briefcase =
    .label = Портфель
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Знак доллара
containers-icon-cart =
    .label = Тележка покупателя
containers-icon-circle =
    .label = Точка
containers-icon-vacation =
    .label = Отпуск
containers-icon-gift =
    .label = Подарок
containers-icon-food =
    .label = Еда
containers-icon-fruit =
    .label = Фрукт
containers-icon-pet =
    .label = Животное
containers-icon-tree =
    .label = Дерево
containers-icon-chill =
    .label = Отдых
