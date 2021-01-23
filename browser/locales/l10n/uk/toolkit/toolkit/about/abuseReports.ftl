# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title.
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Повідомити про порушення для { $addon-name }

abuse-report-title-extension = Поскаржитись на це розширення до { -vendor-short-name }
abuse-report-title-theme = Поскаржитись на цю тему до { -vendor-short-name }
abuse-report-subtitle = У чому проблема?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = від <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Не впевнені, яку проблему обрати?
    <a data-l10n-name="learnmore-link">Дізнайтеся більше про скарги на розширення і теми</a>

abuse-report-submit-description = Опишіть проблему (необов'язково)
abuse-report-textarea =
    .placeholder = Нам легше розв'язати проблему, якщо вона детально описана. Будь ласка, розкажіть про усі подробиці. Дякуємо за допомогу.
abuse-report-submit-note =
    Примітка: Не включайте особисту інформацію (наприклад, ім'я, адресу, номер телефону).
    { -vendor-short-name } постійно зберігає всі записи про такі звіти.

## Panel buttons.

abuse-report-cancel-button = Скасувати
abuse-report-next-button = Далі
abuse-report-goback-button = Повернутись назад
abuse-report-submit-button = Відправити

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Скаргу на <span data-l10n-name="addon-name">{ $addon-name }</span> скасовано.
abuse-report-messagebar-submitting = Надсилання скарги на <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Дякуємо за надсилання скарги. Хочете вилучити <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Дякуємо за надсилання скарги.
abuse-report-messagebar-removed-extension = Дякуємо за надсилання скарги. Ви вилучили розширення <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Дякуємо за надсилання скарги. Ви вилучили тему <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Сталася помилка під час надсилання скарги на <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Скаргу на <span data-l10n-name="addon-name">{ $addon-name }</span> не було надіслано, тому що недавно було відправлено іншу скаргу.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Так, вилучити
abuse-report-messagebar-action-keep-extension = Ні, залишити
abuse-report-messagebar-action-remove-theme = Так, вилучити
abuse-report-messagebar-action-keep-theme = Ні, залишити
abuse-report-messagebar-action-retry = Повторити спробу
abuse-report-messagebar-action-cancel = Скасувати

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Пошкодження мого комп'ютера або компрометація моїх даних
abuse-report-damage-example = Наприклад: Зловмисне програмне забезпечення чи викрадання даних

abuse-report-spam-reason-v2 = Спам або небажана реклама
abuse-report-spam-example = Наприклад: Додавання реклами на вебсторінках

abuse-report-settings-reason-v2 = Зміна пошукового засобу, домівки чи сторінки нової вкладки без мого дозволу
abuse-report-settings-suggestions = Перед надсиланням скарги ви можете спробувати змінити налаштування:
abuse-report-settings-suggestions-search = Зміна типового пошукового засобу
abuse-report-settings-suggestions-homepage = Зміна домівки і сторінки нової вкладки

abuse-report-deceptive-reason-v2 = Видавання себе за щось інше
abuse-report-deceptive-example = Наприклад: Опис чи зображення, що вводять в оману

abuse-report-broken-reason-extension-v2 = Не працює, пошкоджує вебсайти, або сповільнює роботу { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Не працює чи пошкоджує вигляд браузера
abuse-report-broken-example = Наприклад: Повільна робота, труднощі з використанням, або не працює; частини вебсайтів не завантажуються, або виглядають незвично
abuse-report-broken-suggestions-extension =
    Схоже, ви виявили помилку. Окрім надсилання скарги, найкращим способом
    розв'язання проблеми буде зв'язок із розробником розширення.
    <a data-l10n-name="support-link">Відвідайте вебсайт розширення</a> для отримання інформації про розробника.
abuse-report-broken-suggestions-theme =
    Схоже, ви виявили помилку. Окрім надсилання скарги, найкращим способом
    розв'язання проблеми буде зв'язок із розробником теми.
    <a data-l10n-name="support-link">Відвідайте вебсайт теми</a> для отримання інформації про розробника.

abuse-report-policy-reason-v2 = Має ненависний, насильницький або незаконний вміст
abuse-report-policy-suggestions =
    Примітка: Скарги на порушення авторських прав і торгової марки повинні відправлятися в окремому процесі.
    <a data-l10n-name="report-infringement-link">Скористайтеся цими інструкціями</a> для
    повідомлення про проблему.

abuse-report-unwanted-reason-v2 = Мені це було непотрібно і я не знаю, як цього позбутися
abuse-report-unwanted-example = Наприклад: Встановлення без дозволу

abuse-report-other-reason = Щось інше

