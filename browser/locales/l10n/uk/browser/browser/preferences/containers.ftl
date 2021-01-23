# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Додати новий контейнер
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Налаштування контейнера { $name }
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

containers-name-label = Назва
    .accesskey = Н
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Введіть назву контейнера

containers-icon-label = Піктограма
    .accesskey = П
    .style = { -containers-labels-style }

containers-color-label = Колір
    .accesskey = К
    .style = { -containers-labels-style }

containers-button-done =
    .label = Готово
    .accesskey = Г

containers-color-blue =
    .label = Блакитний
containers-color-turquoise =
    .label = Бірюзовий
containers-color-green =
    .label = Зелений
containers-color-yellow =
    .label = Жовтий
containers-color-orange =
    .label = Помаранчевий
containers-color-red =
    .label = Червоний
containers-color-pink =
    .label = Рожевий
containers-color-purple =
    .label = Бузковий
containers-color-toolbar =
    .label = Як панель інструментів

containers-icon-fence =
    .label = Відокремлення
containers-icon-fingerprint =
    .label = Відбиток
containers-icon-briefcase =
    .label = Портфель
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Знак долара
containers-icon-cart =
    .label = Картка покупок
containers-icon-circle =
    .label = Крапка
containers-icon-vacation =
    .label = Відпустка
containers-icon-gift =
    .label = Подарунки
containers-icon-food =
    .label = Їжа
containers-icon-fruit =
    .label = Фрукт
containers-icon-pet =
    .label = Тваринка
containers-icon-tree =
    .label = Дерево
containers-icon-chill =
    .label = Застуда
