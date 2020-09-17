# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Докладніше
onboarding-button-label-get-started = Розпочнімо

## Welcome modal dialog strings

onboarding-welcome-header = Вітаємо в { -brand-short-name }
onboarding-welcome-body = Тепер у вас є браузер.<br/>Познайомтеся ближче з { -brand-product-name }.
onboarding-welcome-learn-more = Дізнатися більше про переваги.
onboarding-welcome-modal-get-body = Ви отримали браузер.<br/>Тепер отримайте максимум можливостей з { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Посильте захист своєї приватності.
onboarding-welcome-modal-privacy-body = Ви отримали браузер. Тепер додаймо більше захисту приватності.
onboarding-welcome-modal-family-learn-more = Дізнайтеся про інші продукти { -brand-product-name }.
onboarding-welcome-form-header = Розпочніть тут
onboarding-join-form-body = Введіть адресу електронної пошти, щоб почати.
onboarding-join-form-email =
    .placeholder = Введіть адресу е-пошти
onboarding-join-form-email-error = Необхідна дійсна адреса е-пошти
onboarding-join-form-legal = Продовжуючи, ви приймаєте <a data-l10n-name="terms">Умови користування</a> і <a data-l10n-name="privacy">Політику приватності</a>.
onboarding-join-form-continue = Продовжити
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Вже маєте обліковий запис?
# Text for link to submit the sign in form
onboarding-join-form-signin = Увійти
onboarding-start-browsing-button-label = Почати перегляд
onboarding-cards-dismiss =
    .title = Сховати
    .aria-label = Сховати

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Вітаємо в <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Швидкий, безпечний та приватний браузер, який підтримується некомерційною організацією.
onboarding-multistage-welcome-primary-button-label = Почати налаштування
onboarding-multistage-welcome-secondary-button-label = Увійти
onboarding-multistage-welcome-secondary-button-text = Маєте обліковий запис?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Імпортуйте свої паролі, закладки та <span data-l10n-name="zap">інше</span>
onboarding-multistage-import-subtitle = Переходите з іншого браузера? Легко переносьте усе до { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Почати імпортування
onboarding-multistage-import-secondary-button-label = Не зараз
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Перелічені тут сайти знайдено на цьому пристрої. { -brand-short-name } не зберігає та не синхронізує дані з іншого браузера, доки ви не захочете їх імпортувати.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Початок роботи: екран { $current } з { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Змініть <span data-l10n-name="zap">зовнішній вигляд</span>
onboarding-multistage-theme-subtitle = Персоналізуйте { -brand-short-name } за допомогою теми.
onboarding-multistage-theme-primary-button-label = Зберегти тему
onboarding-multistage-theme-secondary-button-label = Не зараз
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Автоматично
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Застосувати тему системи
onboarding-multistage-theme-label-light = Світла
onboarding-multistage-theme-label-dark = Темна
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        Наслідування зовнішнього вигляду вашої
        операційної системи кнопками, меню та вікнами.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Використовувати світлий вигляд
        кнопок, меню та вікон.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Використовувати темний вигляд
        кнопок, меню та вікон.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Використовувати різнобарвний вигляд
        кнопок, меню та вікон.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Наслідування зовнішнього вигляду вашої
        операційної системи кнопками, меню та вікнами.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Наслідування зовнішнього вигляду вашої
        операційної системи кнопками, меню та вікнами.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Використовувати світлий вигляд
        кнопок, меню та вікон.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Використовувати світлий вигляд
        кнопок, меню та вікон.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Використовувати темний вигляд
        кнопок, меню та вікон.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Використовувати темний вигляд
        кнопок, меню та вікон.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Використовувати різнобарвний вигляд
        кнопок, меню та вікон.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Використовувати різнобарвний вигляд
        кнопок, меню та вікон.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Розпочнімо знайомство з усіма можливостями.
onboarding-fullpage-form-email =
    .placeholder = Адреса вашої е-пошти…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Візьміть { -brand-product-name } з собою
onboarding-sync-welcome-content = Ваші закладки, історія, паролі та інші налаштування на всіх ваших пристроях.
onboarding-sync-welcome-learn-more-link = Дізнайтеся більше про обліковий запис Firefox
onboarding-sync-form-input =
    .placeholder = Е-пошта
onboarding-sync-form-continue-button = Продовжити
onboarding-sync-form-skip-login-button = Пропустити цей крок

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Введіть свою адресу е-пошти
onboarding-sync-form-sub-header = для продовження в { -sync-brand-name(case: "gen") }

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Виконуйте свої справи з використанням сімейства засобів, що поважають вашу приватність на всіх пристроях.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Вся наша робота виконується з повагою до особистих даних користувачів: Збирати менше. Зберігати в безпеці. Жодних секретів.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Отримуйте доступ до закладок, паролів, історії та інших даних всюди, де ви використовуєте { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Отримуйте сповіщення, коли ваша особиста інформація з'являється у відомих витоках даних.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Отримайте безпечний доступ до паролів на всіх пристроях.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Захист від стеження
onboarding-tracking-protection-text2 = { -brand-short-name } допомагає запобігти стеженню вебсайтами за вами в мережі, ускладнюючи рекламі переслідувати вас.
onboarding-tracking-protection-button2 = Як це працює
onboarding-data-sync-title = Синхронізуйте свої налаштування
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Синхронізуйте закладки, паролі та інші дані між усіма пристроями { -brand-product-name }.
onboarding-data-sync-button2 = Увійти в { -sync-brand-short-name(case: "acc") }
onboarding-firefox-monitor-title = Отримуйте попередження про витоки даних
onboarding-firefox-monitor-text2 = { -monitor-brand-name } стежить, чи не з'явилася ваша адреса електронної пошти у відомих витоках даних і одразу повідомляє вас про це.
onboarding-firefox-monitor-button = Підписатися на попередження
onboarding-browse-privately-title = Користуйтесь інтернетом приватно
onboarding-browse-privately-text = Приватний перегляд очищує вашу історію пошуку і перегляду, щоб не дозволити дізнатися про неї іншим користувачам вашого комп'ютера.
onboarding-browse-privately-button = Відкрити приватне вікно
onboarding-firefox-send-title = Приватний обмін файлами
onboarding-firefox-send-text2 = Вивантажуйте свої файли через { -send-brand-name }, щоб обмінюватися ними з використанням наскрізного шифрування і посиланнями з функцією автоматичного самознищення.
onboarding-firefox-send-button = Спробувати { -send-brand-name }
onboarding-mobile-phone-title = Встановіть { -brand-product-name } на свій смартфон
onboarding-mobile-phone-text = Завантажте { -brand-product-name } для iOS чи Android і синхронізуйте свої дані між різними пристроями.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Завантажити мобільний браузер
onboarding-send-tabs-title = Миттєво пересилайте собі вкладки
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Легко обмінюйтесь сторінками між своїми пристроями без копіювання посилань та не покидаючи браузер.
onboarding-send-tabs-button = Почати використання обмін вкладками
onboarding-pocket-anywhere-title = Читайте і слухайте всюди
onboarding-pocket-anywhere-text2 = Зберігайте улюблені статті для автономного доступу за допомогою додатка { -pocket-brand-name } і читайте та слухайте їх всюди, де вам зручно.
onboarding-pocket-anywhere-button = Спробувати { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Створюйте й зберігайте надійні паролі
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } створює надійні паролі та зберігає їх всі в одному місці.
onboarding-lockwise-strong-passwords-button = Керуйте своїми паролями
onboarding-facebook-container-title = Встановіть обмеження для Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } обмежує ваш соціальний профіль від доступу до всього іншого, ускладнюючи для Facebook можливість стежити за вами з метою показу реклами.
onboarding-facebook-container-button = Встановити розширення
onboarding-import-browser-settings-title = Імпортуйте свої закладки, паролі та іншу інформацію
onboarding-import-browser-settings-text = Швидке занурення — легко перенесіть свої сайти й налаштування з Chrome.
onboarding-import-browser-settings-button = Імпорт даних Chrome
onboarding-personal-data-promise-title = Розроблено для приватності
onboarding-personal-data-promise-text = { -brand-product-name } ставиться до ваших даних з повагою, тому ми отримуємо їх якнайменше, захищаємо їх та чесно повідомляємо, як ми ними користуємося.
onboarding-personal-data-promise-button = Прочитайте нашу Обіцянку

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Чудово, ви отримали { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Тепер перейдімо до <icon></icon><b>{ $addon-name }</b>.
return-to-amo-extension-button = Додати розширення
return-to-amo-get-started-button = Початок роботи з { -brand-short-name }
