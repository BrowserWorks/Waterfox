# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Жаңа контейнерді қосу
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } контейнер баптаулары
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

containers-name-label = Атауы
    .accesskey = А
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Контейнер атауын енгізіңіз

containers-icon-label = Таңбашасы
    .accesskey = Т
    .style = { -containers-labels-style }

containers-color-label = Түсі
    .accesskey = с
    .style = { -containers-labels-style }

containers-button-done =
    .label = Дайын
    .accesskey = Д

containers-color-blue =
    .label = Көк
containers-color-turquoise =
    .label = Көгілдір ақық
containers-color-green =
    .label = Жасыл
containers-color-yellow =
    .label = Сары
containers-color-orange =
    .label = Қызғылт сары
containers-color-red =
    .label = Қызыл
containers-color-pink =
    .label = Қызғылт
containers-color-purple =
    .label = Қызыл көк
containers-color-toolbar =
    .label = Саймандар панелі сияқты

containers-icon-fence =
    .label = Шарбақ
containers-icon-fingerprint =
    .label = Баспасы
containers-icon-briefcase =
    .label = Портфель
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Доллар таңбасы
containers-icon-cart =
    .label = Қоржын
containers-icon-circle =
    .label = Нүкте
containers-icon-vacation =
    .label = Демалыс
containers-icon-gift =
    .label = Сыйлық
containers-icon-food =
    .label = Тамақ
containers-icon-fruit =
    .label = Жеміс
containers-icon-pet =
    .label = Жануар
containers-icon-tree =
    .label = Ағаш
containers-icon-chill =
    .label = Салқындату
