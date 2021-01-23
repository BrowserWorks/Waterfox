# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Додај нов контејнер
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Поставки на контејнерот { $name }
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

containers-name-label = Име
    .accesskey = И
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Внесете име на контејнер

containers-icon-label = Икона
    .accesskey = И
    .style = { -containers-labels-style }

containers-color-label = Боја
    .accesskey = Б
    .style = { -containers-labels-style }

containers-button-done =
    .label = Готово
    .accesskey = Д

containers-color-blue =
    .label = Сина
containers-color-turquoise =
    .label = Тиркизна
containers-color-green =
    .label = Зелена
containers-color-yellow =
    .label = Жолта
containers-color-orange =
    .label = Портокалова
containers-color-red =
    .label = Црвена
containers-color-pink =
    .label = Розова
containers-color-purple =
    .label = Виолетова

containers-icon-fingerprint =
    .label = Отпечаток
containers-icon-briefcase =
    .label = Актовка
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Долар
containers-icon-cart =
    .label = Торба за пазарување
containers-icon-circle =
    .label = Точка
containers-icon-vacation =
    .label = Одмор
containers-icon-gift =
    .label = Подарок
containers-icon-food =
    .label = Храна
containers-icon-fruit =
    .label = Овошје
containers-icon-pet =
    .label = Домашно милениче
containers-icon-tree =
    .label = Дрво
containers-icon-chill =
    .label = Опуштено
