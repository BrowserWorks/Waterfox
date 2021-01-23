# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Додати особистий ключ OpenPGP для { $identity }

key-wizard-button =
    .buttonlabelaccept = Продовжити
    .buttonlabelhelp = Повернутися

key-wizard-warning = <b>Якщо у вас є особистий ключ</b> для цієї електронної адреси, вам необхідно імпортувати його. Інакше, ви не матимете доступу до своїх архівів захищених електронних листів, а також не зможете читати захищені вхідні електронні листи від людей, які все ще використовують ваш наявний ключ.

key-wizard-learn-more = Докладніше

radio-create-key =
    .label = Створити новий ключ OpenPGP
    .accesskey = С

radio-import-key =
    .label = Імпортувати наявний ключ OpenPGP
    .accesskey = І

radio-gnupg-key =
    .label = Використати зовнішній ключ через GnuPG (наприклад, зі смарткарти)
    .accesskey = з

## Generate key section

openpgp-generate-key-title = Створити ключ OpenPGP

openpgp-generate-key-info = <b>Створення ключа може тривати кілька хвилин.</b> Не виходьте з програми, доки створюється ключ. Активний перегляд або виконання дій, пов'язаних з читанням чи записом на диск під час створення ключа збільшить кількість випадкових комбінацій і прискорить процес. Ви отримаєте сповіщення коли ключ буде створено.

openpgp-keygen-expiry-title = Термін дії ключа

openpgp-keygen-expiry-description = Визначте час чинності новоствореного ключа. Пізніше ви можете змінити дату, якщо це буде необхідно.

radio-keygen-expiry =
    .label = Ключ чинний до
    .accesskey = л

radio-keygen-no-expiry =
    .label = Безтерміновий ключ
    .accesskey = н

openpgp-keygen-days-label =
    .label = днів
openpgp-keygen-months-label =
    .label = місяців
openpgp-keygen-years-label =
    .label = років

openpgp-keygen-advanced-title = Розширені налаштування

openpgp-keygen-advanced-description = Керуйте розширеними налаштуваннями вашого ключа OpenPGP.

openpgp-keygen-keytype =
    .value = Тип ключа:
    .accesskey = Т

openpgp-keygen-keysize =
    .value = Розмір ключа:
    .accesskey = Р

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (Еліптична крива)

openpgp-keygen-button = Створити ключ

openpgp-keygen-progress-title = Створення нового ключа OpenPGP…

openpgp-keygen-import-progress-title = Імпорт ключів OpenPGP…

openpgp-import-success = Ключі OpenPGP успішно імпортовано!

openpgp-import-success-title = Завершіть процес імпорту

openpgp-import-success-description = Щоб почати користуватися імпортованим ключем OpenPGP для захисту електронної пошти, закрийте це діалогове вікно та відкрийте налаштування облікового запису, щоб вибрати його.

openpgp-keygen-confirm =
    .label = Підтвердити

openpgp-keygen-dismiss =
    .label = Скасувати

openpgp-keygen-cancel =
    .label = Скасувати створення…

openpgp-keygen-import-complete =
    .label = Закрити
    .accesskey = З

openpgp-keygen-missing-username = Для цього облікового запису не вказано ім’я. Введіть ім'я в поле  "Ваше ім'я" в налаштуваннях облікового запису.
openpgp-keygen-long-expiry = Ви не можете створити ключ, термін дії якого понад 100 років.
openpgp-keygen-short-expiry = Ваш ключ повинен бути дійсним щонайменше один день.

openpgp-keygen-ongoing = Ключ вже створюється!

openpgp-keygen-error-core = Неможливо встановити основну службу OpenPGP

openpgp-keygen-error-failed = Не вдалося створити ключ OpenPGP з невідомої причини

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = Ключ OpenPGP успішно створено, але не вдалося відкликати ключ { $key }

openpgp-keygen-abort-title = Скасувати створення ключа?
openpgp-keygen-abort = Відбувається створення ключа OpenPGP, ви впевнені, що хочете скасувати його?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Створити відкритий та таємний ключ для { $identity }?

## Import Key section

openpgp-import-key-title = Імпорт наявного особистого ключа OpenPGP

openpgp-import-key-legend = Виберіть раніше створений резервний файл.

openpgp-import-key-description = Ви можете імпортувати особисті ключі, створені за допомогою іншого програмного забезпечення OpenPGP.

openpgp-import-key-info = Інше програмне забезпечення може називати особистий ключ іншим терміном, так як-от власний ключ, секретний ключ, приватний ключ або пара ключів.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird знайшов один ключ, який можна імпортувати.
        [few] Thunderbird знайшов { $count } ключі, які можна імпортувати.
       *[many] Thunderbird знайшов { $count } ключів, які можна імпортувати.
    }

openpgp-import-key-list-description = Підтвердьте, які ключі можуть вважатися вашими особистими ключами. Лише створені вами ключі та ті, які підтверджують вашу особу, повинні використовуватись як особисті ключі. Цей параметр можна змінити пізніше у діалоговому вікні властивостей ключів.

openpgp-import-key-list-caption = Ключі, позначені як особисті, буде перелічено в розділі Наскрізне шифрування. Інші будуть доступні у Менеджері ключів.

openpgp-passphrase-prompt-title = Необхідна парольна фраза

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Введіть парольну фразу, щоб розблокувати такий ключ: { $key }

openpgp-import-key-button =
    .label = Виберіть файл для імпорту…
    .accesskey = В

import-key-file = Імпортувати файл ключа OpenPGP

import-key-personal-checkbox =
    .label = Вважати цей ключ особистим

gnupg-file = Файли GnuPG

import-error-file-size = <b>Помилка!</b> Файли розміром понад 5 Мб не підтримуються.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Помилка!</b> Не вдалося імпортувати файл. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Помилка!</b> Не вдалося імпортувати ключі. { $error }

openpgp-import-identity-label = Ідентифікація

openpgp-import-fingerprint-label = Цифровий відбиток

openpgp-import-created-label = Створено

openpgp-import-bits-label = біт

openpgp-import-key-props =
    .label = Властивості ключа
    .accesskey = к

## External Key section

openpgp-external-key-title = Зовнішній ключ GnuPG

openpgp-external-key-description = Налаштуйте зовнішній ключ GnuPG, ввівши його ID

openpgp-external-key-info = Крім того, ви повинні скористатися Менеджером ключів, щоб імпортувати та прийняти відповідний відкритий ключ.

openpgp-external-key-warning = <b>Ви можете налаштувати лише один зовнішній ключ GnuPG.</b> Ваш попередній запис буде замінено.

openpgp-save-external-button = Зберегти ID ключа

openpgp-external-key-label = ID таємного ключа:

openpgp-external-key-input =
    .placeholder = 123456789341298340
