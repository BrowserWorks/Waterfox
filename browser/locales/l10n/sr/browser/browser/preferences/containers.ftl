# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Додај нови контејнер
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } поставке контејнера
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
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Унесите име контејнера

containers-icon-label = Иконица
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Боја
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = Готово
    .accesskey = D

containers-color-blue =
    .label = Плава
containers-color-turquoise =
    .label = Тиркизна
containers-color-green =
    .label = Зелена
containers-color-yellow =
    .label = Жута
containers-color-orange =
    .label = Наранџаста
containers-color-red =
    .label = Црвена
containers-color-pink =
    .label = Розе
containers-color-purple =
    .label = Љубичаста
containers-color-toolbar =
    .label = Усклади са траком алата

containers-icon-fence =
    .label = Ограда
containers-icon-fingerprint =
    .label = Отисак
containers-icon-briefcase =
    .label = Актовка
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Знак долара
containers-icon-cart =
    .label = Колица за куповину
containers-icon-circle =
    .label = Тачка
containers-icon-vacation =
    .label = Одмор
containers-icon-gift =
    .label = Поклон
containers-icon-food =
    .label = Храна
containers-icon-fruit =
    .label = Воће
containers-icon-pet =
    .label = Љубимац
containers-icon-tree =
    .label = Дрво
containers-icon-chill =
    .label = Опуштено
