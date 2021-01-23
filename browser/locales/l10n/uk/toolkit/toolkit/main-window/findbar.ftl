# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Знайти наступне входження фрази
findbar-previous =
    .tooltiptext = Знайти попереднє входження фрази

findbar-find-button-close =
    .tooltiptext = Закрити панель пошуку

findbar-highlight-all2 =
    .label = Підсвітити все
    .accesskey =
        { PLATFORM() ->
            [macos] с
           *[other] с
        }
    .tooltiptext = Підсвітити всі збіги фрази

findbar-case-sensitive =
    .label = З урахуванням регістру
    .accesskey = р
    .tooltiptext = Шукати з урахуванням регістру

findbar-match-diacritics =
    .label = Відповідність діакритичних знаків
    .accesskey = к
    .tooltiptext = Розрізняти літери з апострофом і їхні основні літери (наприклад, при пошуку "resume", "résumé" не береться до уваги)

findbar-entire-word =
    .label = Цілі слова
    .accesskey = Ц
    .tooltiptext = Шукати лише цілі слова
