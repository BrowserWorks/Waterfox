# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Дадаць новы кантэйнер
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Налады кантэйнера { $name }
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
    .placeholder = Увядзіце назву кантэйнера

containers-icon-label = Значок
    .accesskey = З
    .style = { -containers-labels-style }

containers-color-label = Колер
    .accesskey = о
    .style = { -containers-labels-style }

containers-button-done =
    .label = Гатова
    .accesskey = Г

containers-color-blue =
    .label = Блакітны
containers-color-turquoise =
    .label = Бірузовы
containers-color-green =
    .label = Зялёны
containers-color-yellow =
    .label = Жоўты
containers-color-orange =
    .label = Аранжавы
containers-color-red =
    .label = Чырвоны
containers-color-pink =
    .label = Ружовы
containers-color-purple =
    .label = Фіялетавы
containers-color-toolbar =
    .label = Дапасаваць да паліцы прылад

containers-icon-fence =
    .label = Агароджа
containers-icon-fingerprint =
    .label = Адбітак пальца
containers-icon-briefcase =
    .label = Партфель
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Знак долара
containers-icon-cart =
    .label = Кошык
containers-icon-circle =
    .label = Кропка
containers-icon-vacation =
    .label = Адпачынак
containers-icon-gift =
    .label = Падарунак
containers-icon-food =
    .label = Ежа
containers-icon-fruit =
    .label = Садавіна
containers-icon-pet =
    .label = Жывёліна
containers-icon-tree =
    .label = Дрэва
containers-icon-chill =
    .label = Прастуда
