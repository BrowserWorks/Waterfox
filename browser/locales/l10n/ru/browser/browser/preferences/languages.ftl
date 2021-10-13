# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webpage-languages-window =
    .title = Настройки языка веб-страниц
    .style = width: 40em

languages-close-key =
    .key = w

languages-description = Некоторые веб-страницы могут быть доступны более чем на одном языке. Укажите порядок выбора языка страницы

languages-customize-spoof-english =
    .label = Для повышения приватности запрашивать веб-страницы на английском языке

languages-customize-moveup =
    .label = Вверх
    .accesskey = в

languages-customize-movedown =
    .label = Вниз
    .accesskey = н

languages-customize-remove =
    .label = Удалить
    .accesskey = а

languages-customize-select-language =
    .placeholder = Выберите язык, чтобы его добавить…

languages-customize-add =
    .label = Добавить
    .accesskey = б

# The pattern used to generate strings presented to the user in the
# locale selection list.
#
# Example:
#   Icelandic [is]
#   Spanish (Chile) [es-CL]
#
# Variables:
#   $locale (String) - A name of the locale (for example: "Icelandic", "Spanish (Chile)")
#   $code (String) - Locale code of the locale (for example: "is", "es-CL")
languages-code-format =
    .label = { $locale }  [{ $code }]

languages-active-code-format =
    .value = { languages-code-format.label }

browser-languages-window =
    .title = Настройки языка { -brand-short-name }
    .style = width: 40em

browser-languages-description = { -brand-short-name } будет использовать первый язык из списка по умолчанию, а другие языки в указанном порядке, при необходимости.

browser-languages-search = Найти больше языков…

browser-languages-searching =
    .label = Поиск языков…

browser-languages-downloading =
    .label = Загрузка…

browser-languages-select-language =
    .label = Выберите язык, чтобы его добавить…
    .placeholder = Выберите язык, чтобы его добавить…

browser-languages-installed-label = Установленные языки
browser-languages-available-label = Доступные языки

browser-languages-error = { -brand-short-name } не может обновить ваши языки прямо сейчас. Проверьте, что вы подключены к Интернету, или попробуйте снова.
