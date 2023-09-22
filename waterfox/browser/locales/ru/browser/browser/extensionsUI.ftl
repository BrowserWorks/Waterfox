# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = Подробнее
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = { $addonName } хочет сменить вашу поисковую систему по умолчанию с { $currentEngine } на { $newEngine }. Вы согласны?
webext-default-search-yes =
    .label = Да
    .accesskey = Д
webext-default-search-no =
    .label = Нет
    .accesskey = Н
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = { $addonName } было добавлено.

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = Запускать { $addonName } на сайтах с ограничениями?
webext-quarantine-confirmation-line-1 = В целях защиты ваших данных это расширение запрещено на этом сайте.
webext-quarantine-confirmation-line-2 = Разрешите это расширение, если вы доверяете ему читать и изменять ваши данные на сайтах, ограниченных { -vendor-short-name }.
webext-quarantine-confirmation-allow =
    .label = Разрешить
    .accesskey = ш
webext-quarantine-confirmation-deny =
    .label = Не разрешать
    .accesskey = е
