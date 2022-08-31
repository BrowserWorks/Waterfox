# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = При отправке сообщения произошла ошибка. Пожалуйста, повторите попытку позже.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Сайт был исправлен? Отправьте сообщение

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Строгая
    .label = Строгая
protections-popup-footer-protection-label-custom = Персональная
    .label = Персональная
protections-popup-footer-protection-label-standard = Стандартная
    .label = Стандартная

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Больше информации об улучшенной защите от отслеживания

protections-panel-etp-on-header = Улучшенная защита от отслеживания на этом сайте ВКЛЮЧЕНА
protections-panel-etp-off-header = Улучшенная защита от отслеживания на этом сайте ОТКЛЮЧЕНА

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Сайт не работает?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Сайт не работает?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Почему?
protections-panel-not-blocking-why-etp-on-tooltip = Блокировка может привести к неработоспособности элементов некоторых веб-сайтов. Без трекеров некоторые кнопки, формы и поля для входа могут не работать.
protections-panel-not-blocking-why-etp-off-tooltip = Все трекеры на этом сайте были загружены, потому что защита отключена.

##

protections-panel-no-trackers-found = На этой странице не обнаружено трекеров известных { -brand-short-name }.

protections-panel-content-blocking-tracking-protection = Отслеживающее содержимое

protections-panel-content-blocking-socialblock = Трекеры социальных сетей
protections-panel-content-blocking-cryptominers-label = Криптомайнеры
protections-panel-content-blocking-fingerprinters-label = Сборщики цифровых отпечатков

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Блокируются
protections-panel-not-blocking-label = Разрешены
protections-panel-not-found-label = Ничего не найдено

##

protections-panel-settings-label = Настройки защиты
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Панель состояния защиты

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Отключите защиту, если у вас возникли проблемы с:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Полями ввода
protections-panel-site-not-working-view-issue-list-forms = Формами
protections-panel-site-not-working-view-issue-list-payments = Совершением платежей
protections-panel-site-not-working-view-issue-list-comments = Написанием комментариев
protections-panel-site-not-working-view-issue-list-videos = Просмотром видео

protections-panel-site-not-working-view-send-report = Отправьте сообщение

##

protections-panel-cross-site-tracking-cookies = Такие куки ходят за вами с сайта на сайт для сбора информации о том, что вы делаете в Интернете. Они устанавливаются такими сторонними организациями, как рекламодатели и аналитические компании.
protections-panel-cryptominers = Криптомайнеры используют вычислительные мощности вашей системы для добычи цифровых валют. Такие скрипты разряжают вашу батарею, замедляют работу компьютера и могут увеличить ваш счёт за электроэнергию.
protections-panel-fingerprinters = Сборщики цифровых отпечатков используют параметры вашего браузера и компьютера, чтобы создать ваш профиль. Используя этот цифровой отпечаток, они могут отслеживать вас на различных веб-сайтах.
protections-panel-tracking-content = Веб-сайты могут загружать внешнюю рекламу, видео и другой контент с отслеживающим кодом. Блокировка отслеживающего содержимого может помочь сайтам загружаться быстрее, но некоторые кнопки, формы и поля для входа могут не работать.
protections-panel-social-media-trackers = Социальные сети размещают трекеры на других веб-сайтах, чтобы следить за тем, что вы делаете, видите и смотрите в Интернете. Это позволяет их владельцам узнавать о вас больше, чем вы указываете в своих профилях в социальных сетях.

protections-panel-description-shim-allowed = Некоторые отмеченные ниже трекеры были частично разблокированы на этой странице, так как вы с ними взаимодействовали.
protections-panel-description-shim-allowed-learn-more = Подробнее
protections-panel-shim-allowed-indicator =
    .tooltiptext = Частично разблокированные трекеры

protections-panel-content-blocking-manage-settings =
    .label = Управление настройками защиты
    .accesskey = п

protections-panel-content-blocking-breakage-report-view =
    .title = Сообщить о неработающем сайте
protections-panel-content-blocking-breakage-report-view-description = Блокировка некоторых трекеров может вызывать проблемы с некоторыми веб-сайтами. Сообщая о таких проблемах, вы помогаете сделать { -brand-short-name } лучше для всех и каждого. При отправке сообщения в Waterfox будет отправлен адрес сайта, а также информация о настройках вашего браузера. <label data-l10n-name="learn-more">Подробнее</label>
protections-panel-content-blocking-breakage-report-view-collection-url = Адрес страницы
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = Адрес страницы
protections-panel-content-blocking-breakage-report-view-collection-comments = Не обязательно: Опишите проблему
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Не обязательно: Опишите проблему
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Отмена
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Отправить сообщение
