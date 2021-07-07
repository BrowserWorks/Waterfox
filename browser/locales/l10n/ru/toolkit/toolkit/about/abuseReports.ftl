# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title.
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Пожаловаться на { $addon-name }
abuse-report-title-extension = Пожаловаться на это расширение в { -vendor-short-name }
abuse-report-title-theme = Пожаловаться на эту тему в { -vendor-short-name }
abuse-report-subtitle = С какой проблемой вы столкнулись?
# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = от <a data-l10n-name="author-name">{ $author-name }</a>
abuse-report-learnmore =
    Не знаете, какую проблему выбрать?
    <a data-l10n-name="learnmore-link">Подробнее о жалобах на расширения и темы</a>
abuse-report-submit-description = Опишите проблему (необязательно)
abuse-report-textarea =
    .placeholder = Нам легче решить проблему, если она подробно описана. Пожалуйста, расскажите все подробности. Спасибо за помощь в поддержке здорового Интернета.
abuse-report-submit-note =
    Примечание: Не указывайте личную информацию (такую как имя, адрес электронной почты, номер телефона, физический адрес).
    { -vendor-short-name } навсегда сохраняет в том числе и такие жалобы.

## Panel buttons.

abuse-report-cancel-button = Отмена
abuse-report-next-button = Далее
abuse-report-goback-button = Вернуться назад
abuse-report-submit-button = Отправить

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Жалоба на <span data-l10n-name="addon-name">{ $addon-name }</span> отменена.
abuse-report-messagebar-submitting = Отправка жалобы на <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Спасибо за отправку жалобы. Вы хотите удалить <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Спасибо за отправку жалобы.
abuse-report-messagebar-removed-extension = Спасибо за отправку жалобы. Вы удалили расширение <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Спасибо за отправку жалобы. Вы удалили тему <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Произошла ошибка при отправке жалобы на <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Жалоба на <span data-l10n-name="addon-name">{ $addon-name }</span> не была отправлена, так как другая жалоба уже была недавно отправлена.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Да, удалить его
abuse-report-messagebar-action-keep-extension = Нет, оставить его
abuse-report-messagebar-action-remove-theme = Да, удалить её
abuse-report-messagebar-action-keep-theme = Нет, оставить её
abuse-report-messagebar-action-retry = Повторить
abuse-report-messagebar-action-cancel = Отмена

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Вредит работе компьютера или крадёт мои данные
abuse-report-damage-example = Например: Вредоносное ПО или кража данных
abuse-report-spam-reason-v2 = Содержит спам или вставляет нежелательную рекламу
abuse-report-spam-example = Например: Вставляет рекламу на веб-страницы
abuse-report-settings-reason-v2 = Изменяет мою поисковую систему, домашнюю страницу или страницу новой вкладки, не сообщая и не спрашивая меня
abuse-report-settings-suggestions = Перед отправкой жалобы на расширение, вы можете попробовать изменить настройки:
abuse-report-settings-suggestions-search = Изменяет настройки поиска по умолчанию
abuse-report-settings-suggestions-homepage = Изменяет домашнюю страницу и страницу новой вкладки
abuse-report-deceptive-reason-v2 = Выдаёт себя не за то, чем является
abuse-report-deceptive-example = Например: Описание или изображение вводят в заблуждение
abuse-report-broken-reason-extension-v2 = Не работает, ломает веб-сайты или замедляет работу { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Не работает или нарушает работу браузера
abuse-report-broken-example = Например: Медленная работа, трудности с использованием или не работает; части веб-сайтов не загружаются или выглядят необычно
abuse-report-broken-suggestions-extension =
    Похоже, что вы обнаружили ошибку. В дополнение к отправке жалобы здесь, лучшим способом
    решения проблемы будет связь с разработчиком расширения.
    <a data-l10n-name="support-link">Посетите веб-сайт расширения</a> для получения информации о разработчике.
abuse-report-broken-suggestions-theme =
    Похоже, что вы обнаружили ошибку. В дополнение к отправке жалобы здесь, лучшим способом
    решения проблемы будет связь с разработчиком темы.
    <a data-l10n-name="support-link">Посетите веб-сайт темы</a> для получения информации о разработчике.
abuse-report-policy-reason-v2 = Содержит незаконное, жестокое, вызывающее ненависть содержимое
abuse-report-policy-suggestions =
    Примечание: Жалобы о нарушении авторских прав или прав на товарный знак должны подаваться отдельно.
    <a data-l10n-name="report-infringement-link">Воспользуйтесь этими инструкциями</a>, чтобы
    сообщить о проблеме.
abuse-report-unwanted-reason-v2 = Я никогда не устанавливал(а) его и не знаю, как от него избавиться
abuse-report-unwanted-example = Например: Приложение установило его без моего разрешения
abuse-report-other-reason = Что-то другое
