# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Нов изолатор
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Настройки на изолатора { $name }
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

containers-name-label = Наименование
    .accesskey = н
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Въведете име на изолатор

containers-icon-label = Пиктограма
    .accesskey = п
    .style = { -containers-labels-style }

containers-color-label = Цвят
    .accesskey = ц
    .style = { -containers-labels-style }

containers-button-done =
    .label = Готово
    .accesskey = Г

containers-color-blue =
    .label = Синьо
containers-color-turquoise =
    .label = Тюркоазено
containers-color-green =
    .label = Зелено
containers-color-yellow =
    .label = Жълто
containers-color-orange =
    .label = Оранжево
containers-color-red =
    .label = Червено
containers-color-pink =
    .label = Розово
containers-color-purple =
    .label = Лилаво
containers-color-toolbar =
    .label = Като лентата с инструменти

containers-icon-fence =
    .label = Ограда
containers-icon-fingerprint =
    .label = Пръстов отпечатък
containers-icon-briefcase =
    .label = Куфарче
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Знак за долар
containers-icon-cart =
    .label = Количка за пазаруване
containers-icon-circle =
    .label = Точка
containers-icon-vacation =
    .label = Ваканция
containers-icon-gift =
    .label = Подарък
containers-icon-food =
    .label = Храна
containers-icon-fruit =
    .label = Плод
containers-icon-pet =
    .label = Домашен любимец
containers-icon-tree =
    .label = Дърво
containers-icon-chill =
    .label = Разпускане
