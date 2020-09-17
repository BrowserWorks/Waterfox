# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } заблокував { $count } елемент стеження за минулий тиждень
        [few] { -brand-short-name } заблокував { $count } елементи стеження за минулий тиждень
       *[many] { -brand-short-name } заблокував { $count } елементів стеження за минулий тиждень
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> елемент стеження заблокований починаючи з { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [few] <b>{ $count }</b> елементи стеження заблоковано починаючи з { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[many] <b>{ $count }</b> елементів стеження заблоковано починаючи з { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } продовжує блокувати стеження в приватних вікнах, але не записує, що було заблоковано.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Стеження, яке { -brand-short-name } заблокував цього тижня

protection-report-webpage-title = Панель стану захисту
protection-report-page-content-title = Панель стану захисту
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } може непомітно захищати вашу приватність під час перебування в Інтернеті. Це персоналізований підсумок стану захисту, включаючи засоби контролю вашої безпеки в Інтернеті.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } непомітно захищає вашу приватність під час перебування в Інтернеті. Це персоналізований підсумок стану захисту, включаючи засоби контролю вашої безпеки в Інтернеті.

protection-report-settings-link = Керуйте своїми налаштуваннями приватності й безпеки

etp-card-title-always = Розширений захист від стеження: Завжди увімкнено
etp-card-title-custom-not-blocking = Розширений захист від стеження: ВИМКНЕНО
etp-card-content-description = { -brand-short-name } автоматично блокує таємне стеження компаній за вами в Інтернеті.
protection-report-etp-card-content-custom-not-blocking = Всі засоби захисту зараз вимкнено. Оберіть, які елементи стеження блокувати, в налаштуваннях захисту { -brand-short-name }.
protection-report-manage-protections = Керувати налаштуваннями

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Сьогодні

# This string is used to describe the graph for screenreader users.
graph-legend-description = Графік відображає загальну кількість стеження кожного типу, заблокованого цього тижня.

social-tab-title = Стеження соціальних мереж
social-tab-contant = Соціальні мережі розміщують елементи стеження на інших вебсайтах, щоб стежити за вашими діями в інтернеті. Це дозволяє їм дізнаватися більше про вас, окрім того, чим ви ділитеся у своєму профілі. <a data-l10n-name="learn-more-link">Докладніше</a>

cookie-tab-title = Куки стеження між сайтами
cookie-tab-content = Ці куки переслідують вас від одного сайту до іншого, з метою збирання даних про вашу діяльність онлайн. Вони встановлюються сторонніми рекламними й аналітичними компаніями. Блокування куків стеження між сайтами зменшує кількість реклами, що переслідує вас. <a data-l10n-name="learn-more-link">Докладніше</a>

tracker-tab-title = Вміст стеження
tracker-tab-description = Вебсайти можуть завантажувати зовнішню рекламу, відео, а також інший вміст з кодом стеження. Блокування такого вмісту може допомогти сайтам швидше завантажуватись, але при цьому деякі кнопки, поля форм і входів можуть не працювати. <a data-l10n-name="learn-more-link">Докладніше</a>

fingerprinter-tab-title = Зчитування цифрового відбитка
fingerprinter-tab-content = Засоби зчитування цифрового відбитка збирають дані про налаштування вашого браузера та комп'ютера, з метою створення вашого профілю. Використовуючи такий цифровий відбиток, вони можуть стежити за вами на багатьох різних вебсайтах. <a data-l10n-name="learn-more-link">Докладніше</a>

cryptominer-tab-title = Криптомайнери
cryptominer-tab-content = Криптомайнери використовують ресурси вашої системи для добування криптовалют. Скрипти для добування криптовалют споживають заряд вашого акумулятора, сповільнюють роботу комп'ютера, а також можуть збільшити ваші витрати на електроенергію. <a data-l10n-name="learn-more-link">Докладніше</a>

protections-close-button2 =
    .aria-label = Закрити
    .title = Закрити
  
mobile-app-title = Блокуйте рекламне стеження на всіх пристроях
mobile-app-card-content = Використовуйте мобільний браузер із вбудованим захистом від стеження.
mobile-app-links = { -brand-product-name } для <a data-l10n-name="android-mobile-inline-link">Android</a> та <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Ніколи більше не забувайте пароль
lockwise-title-logged-in2 = Керування паролями
lockwise-header-content = { -lockwise-brand-name } безпечно зберігає ваші паролі в браузері.
lockwise-header-content-logged-in = Безпечно зберігайте й синхронізуйте свої паролі на всіх пристроях.
protection-report-save-passwords-button = Зберігати паролі
    .title = Зберігати паролі в { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Керувати паролями
    .title = Керувати паролями в { -lockwise-brand-short-name }
lockwise-mobile-app-title = Отримайте свої паролі всюди
lockwise-no-logins-card-content = Використовуйте паролі, що збережені в { -brand-short-name }, на будь-якому пристрої.
lockwise-app-links = { -lockwise-brand-name } для <a data-l10n-name="lockwise-android-inline-link">Android</a> та <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 пароль, ймовірно, викрито внаслідок витоку даних.
        [few] { $count } паролі, ймовірно, викрито внаслідок витоку даних.
       *[many] { $count } паролів, ймовірно, викрито внаслідок витоку даних.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] Надійно зберігається 1 пароль.
        [few] Надійно зберігаються { $count } паролі.
       *[many] Надійно зберігаються { $count } паролів.
    }
lockwise-how-it-works-link = Як це працює

turn-on-sync = Увімкнути { -sync-brand-short-name(case: "acc") }
    .title = Перейти до налаштувань синхронізації

monitor-title = Стеження за витоками даних
monitor-link = Як це працює
monitor-header-content-no-account = Спробуйте { -monitor-brand-name }, щоб перевірити чи ви потрапили до відомого витоку даних, а також отримуйте попередження про нові витоки.
monitor-header-content-signed-in = { -monitor-brand-name } попереджає вас, якщо ваша інформація з'явилася у відомих витоках даних.
monitor-sign-up-link = Підписатися на сповіщення
    .title = Підписатися на сповіщення про витоки від { -monitor-brand-name }
auto-scan = Автоматично проскановано сьогодні

monitor-emails-tooltip =
    .title = Переглянути відстежувані адреси е-пошти на { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Переглянути відомі витоки даних на { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Переглянути викриті паролі на { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Адреса е-пошти відстежується
        [few] Адреси е-пошти відстежуються
       *[many] Адрес е-пошти відстежуються
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Відомий витік даних викрив вашу інформацію
        [few] Відомі витоки даних викрили вашу інформацію
       *[many] Відомих витоків даних викрили вашу інформацію
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Відомий витік даних позначено розвʼязаним
        [few] Відомі витоки даних позначено розвʼязаними
       *[many] Відомих витоків даних позначено розвʼязаними
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Викритий пароль серед усіх витоків даних
        [few] Викриті паролі серед усіх витоків даних
       *[many] Викритих паролів серед усіх витоків даних
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Викритий пароль у нерозвʼязаних витоках
        [few] Викриті паролі у нерозвʼязаних витоках
       *[many] Викритих паролів у нерозвʼязаних витоках
    }

monitor-no-breaches-title = Гарні новини!
monitor-no-breaches-description = У вас немає відомих витоків даних. Якщо щось зміниться, ми повідомимо вас.
monitor-view-report-link = Переглянути звіт
    .title = Розв'язати проблеми, пов'язані з витоками даних на { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Розв'язати проблеми витоку даних
monitor-breaches-unresolved-description = Після перегляду подробиць про витік даних та вжиття заходів для захисту вашої інформації, ви можете позначити витік вирішеним.
monitor-manage-breaches-link = Керувати витоками
    .title = Керування витоками даних на { -monitor-brand-short-name }
monitor-breaches-resolved-title = Чудово! Ви розв'язали всі відомі витоки даних.
monitor-breaches-resolved-description = Якщо ваша е-пошта з'явиться в нових витоках даних, ми вас повідомимо.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } витік даних з { $numBreaches } позначено розв'язаним
        [few] { $numBreachesResolved } витоки даних з { $numBreaches } позначено розв'язаними
       *[many] { $numBreachesResolved } витоків даних з { $numBreaches } позначено розв'язаними
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% завершено

monitor-partial-breaches-motivation-title-start = Гарний початок!
monitor-partial-breaches-motivation-title-middle = Так тримати!
monitor-partial-breaches-motivation-title-end = Майже завершено! Так тримати.
monitor-partial-breaches-motivation-description = Розв'яжіть решту своїх витоків даних на { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Розв'язати витоки
    .title = Розв'язати витоки даних на { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Стеження соціальних мереж
    .aria-label =
        { $count ->
            [one] { $count } елемент стеження соціальних мереж ({ $percentage }%)
            [few] { $count } елементи стеження соціальних мереж ({ $percentage }%)
           *[many] { $count } елементів стеження соціальних мереж ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Куки стеження між сайтами
    .aria-label =
        { $count ->
            [one] { $count } куків стеження між сайтами ({ $percentage }%)
            [few] { $count } куків стеження між сайтами ({ $percentage }%)
           *[many] { $count } куків стеження між сайтами ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Вміст стеження
    .aria-label =
        { $count ->
            [one] { $count } елемент вмісту стеження ({ $percentage }%)
            [few] { $count } елементи вмісту стеження ({ $percentage }%)
           *[many] { $count } елементів вмісту стеження ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Зчитування цифрового відбитка
    .aria-label =
        { $count ->
            [one] { $count } елемент зчитування цифрового відбитка ({ $percentage }%)
            [few] { $count } елементи зчитування цифрового відбитка ({ $percentage }%)
           *[many] { $count } елементів зчитування цифрового відбитка ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Криптомайнери
    .aria-label =
        { $count ->
            [one] { $count } криптомайнер ({ $percentage }%)
            [few] { $count } криптомайнери ({ $percentage }%)
           *[many] { $count } криптомайнерів ({ $percentage }%)
        }
