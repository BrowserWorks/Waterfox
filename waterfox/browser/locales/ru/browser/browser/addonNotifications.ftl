# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } заблокировал запрос на установку программного обеспечения с этого сайта на ваш компьютер.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = Разрешить { $host } выполнить установку дополнения?
xpinstall-prompt-message = Вы пытаетесь установить дополнение с { $host }. Прежде чем продолжить, убедитесь, что вы доверяете этому сайту.

##

xpinstall-prompt-header-unknown = Разрешить неизвестному сайту установить дополнение?
xpinstall-prompt-message-unknown = Вы пытаетесь установить дополнение с неизвестного сайта. Прежде чем продолжить, убедитесь, что вы доверяете этому сайту.

xpinstall-prompt-dont-allow =
    .label = Не разрешать
    .accesskey = е
xpinstall-prompt-never-allow =
    .label = Никогда не разрешать
    .accesskey = и
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Сообщить о подозрительном сайте
    .accesskey = п
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Продолжить установку
    .accesskey = ж

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Этот сайт запрашивает доступ к вашим устройствам MIDI (цифровой интерфейс музыкальных инструментов). Доступ к устройству можно включить, установив дополнение.
site-permission-install-first-prompt-midi-message = Безопасный доступ не гарантируется. Продолжайте, только если вы доверяете этому сайту.

##

xpinstall-disabled-locked = Установка программного обеспечения запрещена вашим системным администратором.
xpinstall-disabled = Установка программного обеспечения в данный момент запрещена. Нажмите «Разрешить» и попробуйте снова.
xpinstall-disabled-button =
    .label = Разрешить
    .accesskey = р

# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) заблокировано вашим системным администратором.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = Ваш системный администратор запретил этому сайту запрашивать установку ПО на ваш компьютер.
addon-install-full-screen-blocked = Установка дополнений не разрешена во время или перед входом в полноэкранный режим.

# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } добавлено в { -brand-short-name }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } запрашивает новые разрешения

# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = Завершить установку расширений, импортированных в { -brand-short-name }

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = Удалить { $name }?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = Удалить { $name } из { -brand-shorter-name }?
addon-removal-button = Удалить
addon-removal-abuse-report-checkbox = Пожаловаться на это расширение в { -vendor-short-name }

# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying =
    { $addonCount ->
        [one] Загрузка и проверка { $addonCount } дополнения…
        [few] Загрузка и проверка { $addonCount } дополнений…
       *[many] Загрузка и проверка { $addonCount } дополнений…
    }
addon-download-verifying = Проверка

addon-install-cancel-button =
    .label = Отмена
    .accesskey = О
addon-install-accept-button =
    .label = Добавить
    .accesskey = Д

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one] Этот сайт хочет установить { $addonCount } дополнение в { -brand-short-name }:
        [few] Этот сайт хочет установить { $addonCount } дополнения в { -brand-short-name }:
       *[many] Этот сайт хочет установить { $addonCount } дополнений в { -brand-short-name }:
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one] Внимание: Этот сайт хочет установить { $addonCount } непроверенное дополнение в { -brand-short-name }. Продолжайте на свой страх и риск.
        [few] Внимание: Этот сайт хочет установить { $addonCount } непроверенных дополнения в { -brand-short-name }. Продолжайте на свой страх и риск.
       *[many] Внимание: Этот сайт хочет установить { $addonCount } непроверенных дополнений в { -brand-short-name }. Продолжайте на свой страх и риск.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message =
    { $addonCount ->
        [one] Внимание: Этот сайт хочет установить { $addonCount } дополнение в { -brand-short-name }, некоторые из которых не проверены. Продолжайте на свой страх и риск.
        [few] Внимание: Этот сайт хочет установить { $addonCount } дополнения в { -brand-short-name }, некоторые из которых не проверены. Продолжайте на свой страх и риск.
       *[many] Внимание: Этот сайт хочет установить { $addonCount } дополнений в { -brand-short-name }, некоторые из которых не проверены. Продолжайте на свой страх и риск.
    }

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = Дополнение не может быть загружено из-за ошибки соединения.
addon-install-error-incorrect-hash = Дополнение не может быть установлено, так как оно не соответствует дополнению, ожидаемому { -brand-short-name }.
addon-install-error-corrupt-file = Дополнение, загруженное с этого сайта, не может быть установлено, так как оно, по-видимому, повреждено.
addon-install-error-file-access = { $addonName } не может быть установлено, так как { -brand-short-name } не может изменить нужный файл.
addon-install-error-not-signed = { -brand-short-name } заблокировал установку непроверенного дополнения с этого сайта.
addon-install-error-invalid-domain = Дополнение { $addonName } не может быть установлено из этого расположения.
addon-local-install-error-network-failure = Это дополнение не может быть установлено из-за ошибки файловой системы.
addon-local-install-error-incorrect-hash = Это дополнение не может быть установлено, так как оно не соответствует дополнению, ожидаемому { -brand-short-name }.
addon-local-install-error-corrupt-file = Это дополнение не может быть установлено, так как оно, по-видимому, повреждено.
addon-local-install-error-file-access = { $addonName } не может быть установлено, так как { -brand-short-name } не может изменить нужный файл.
addon-local-install-error-not-signed = Это дополнение не может быть установлено, так как оно не было проверено.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = { $addonName } не может быть установлено, так как оно не совместимо с { -brand-short-name } { $appVersion }.
addon-install-error-blocklisted = { $addonName } не может быть установлено, так как есть высокий риск, что оно вызовет проблемы со стабильностью или безопасностью.
