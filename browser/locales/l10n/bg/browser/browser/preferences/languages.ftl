# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webpage-languages-window =
    .title = Настройки на езика на страницата
    .style = width: 40em

languages-close-key =
    .key = w

languages-description = Някои страници се предлагат на повече от един език. Подредете езиците, на които желаете такива страници да бъдат показвани, в реда на вашето предпочитание

languages-customize-spoof-english =
    .label = Заявяване на английската версия на страниците за подобрена поверителност

languages-customize-moveup =
    .label = Преместване нагоре
    .accesskey = г

languages-customize-movedown =
    .label = Преместване надолу
    .accesskey = д

languages-customize-remove =
    .label = Премахване
    .accesskey = П

languages-customize-select-language =
    .placeholder = Добавяне на език…

languages-customize-add =
    .label = Добавяне
    .accesskey = Д

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
    .label = { $locale } [{ $code }]

languages-active-code-format =
    .value = { languages-code-format.label }

browser-languages-window =
    .title = Настройки на езика на { -brand-short-name }
    .style = width: 40em

browser-languages-description = { -brand-short-name } ще използва първия език от списъка като език по подразбиране, а останалите при необходимост в зададения ред.

browser-languages-search = Търсене на други езици…

browser-languages-searching =
    .label = Търсене на езици…

browser-languages-downloading =
    .label = Изтегляне…

browser-languages-select-language =
    .label = Изберете език, който да бъде добавен…
    .placeholder = Изберете език, който да бъде добавен…

browser-languages-installed-label = Инсталирани езици
browser-languages-available-label = Достъпни езици

browser-languages-error = { -brand-short-name } в момента не може да обнови езиците. Проверете връзката с интернет или опитайте отново.
