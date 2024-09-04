# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = О { -brand-full-name }

releaseNotes-link = Что нового

update-checkForUpdatesButton =
    .label = Проверить наличие обновлений
    .accesskey = о

update-updateButton =
    .label = Перезапустить { -brand-shorter-name } для обновления
    .accesskey = е

update-checkingForUpdates = Проверка наличия обновлений…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>Загрузка обновления — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Загрузка обновления — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Применение обновления…

update-failed = Обновление не удалось. <label data-l10n-name="failed-link">Загрузите последнюю версию</label>
update-failed-main = Обновление не удалось. <a data-l10n-name="failed-link-main">Загрузите последнюю версию</a>

update-adminDisabled = Обновления отключены вашим системным администратором
update-noUpdatesFound = Установлена последняя версия { -brand-short-name }
aboutdialog-update-checking-failed = Не удалось проверить наличие обновлений.
update-otherInstanceHandlingUpdates = Обновление производится другим процессом { -brand-short-name }

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Обновления доступны на <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = Обновления доступны на <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = Вы не можете производить дальнейшие обновления на этой системе. <label data-l10n-name="unsupported-link">Подробнее</label>

update-restarting = Перезапуск…

update-internal-error2 = Не удалось проверить наличие обновлений из-за внутренней ошибки. Обновления доступны по адресу <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = Сейчас вы находитесь на канале обновлений <label data-l10n-name="current-channel">{ $channel }</label>.

warningDesc-version = { -brand-short-name } является пробным и может быть нестабилен.

aboutdialog-help-user = Справка { -brand-product-name }
aboutdialog-submit-feedback = Отправить отзыв

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> является <label data-l10n-name="community-exp-creditsLink">глобальным сообществом</label>, работающим над тем, чтобы Интернет оставался открытым  и общедоступным для всех и каждого.

community-2 = { -brand-short-name } создан <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label> — <label data-l10n-name="community-creditsLink">глобальным сообществом</label>, работающим над тем, чтобы Интернет оставался открытым и общедоступным для всех и каждого.

helpus = Хотите помочь? <label data-l10n-name="helpus-donateLink">Сделайте пожертвование</label> или <label data-l10n-name="helpus-getInvolvedLink">присоединяйтесь!</label>

bottomLinks-license = Сведения о лицензии
bottomLinks-rights = Права конечного пользователя
bottomLinks-privacy = Политика приватности

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits }-разрядный)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits }-разрядный)
