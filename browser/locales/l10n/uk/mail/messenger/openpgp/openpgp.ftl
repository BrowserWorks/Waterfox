# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = Щоб надсилати захищені або підписані цифровим підписом повідомлення, вам необхідно налаштувати технологію шифрування OpenPGP або S/MIME.

e2e-intro-description-more = Виберіть свій особистий ключ, щоб дозволити використання OpenPGP, або ваш особистий сертифікат, щоб дозволити використання S/MIME. Для особистого ключа або сертифіката ви отримаєте відповідний секретний ключ.

openpgp-key-user-id-label = Обліковий запис / ID користувача
openpgp-keygen-title-label =
    .title = Створити ключ OpenPGP
openpgp-cancel-key =
    .label = Скасувати
    .tooltiptext = Скасувати створення ключа
openpgp-key-gen-expiry-title =
    .label = Термін дії ключа
openpgp-key-gen-expire-label = Ключ чинний до
openpgp-key-gen-days-label =
    .label = днів
openpgp-key-gen-months-label =
    .label = місяців
openpgp-key-gen-years-label =
    .label = років
openpgp-key-gen-no-expiry-label =
    .label = Безтерміновий ключ
openpgp-key-gen-key-size-label = Розмір ключа
openpgp-key-gen-console-label = Створення ключа
openpgp-key-gen-key-type-label = Тип ключа
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (Еліптична крива)
openpgp-generate-key =
    .label = Створити ключ
    .tooltiptext = Створює новий, сумісний з OpenPGP, ключ для шифрування та/або підписання
openpgp-advanced-prefs-button-label =
    .label = Додатково…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">ПРИМІТКА: Створення ключа може тривати кілька хвилин.</a> Не виходьте з програми, доки створюється ключ. Активний перегляд або виконання дій, пов'язаних з читанням чи записом на диск під час створення ключа збільшить кількість випадкових комбінацій і прискорить процес. Ви отримаєте сповіщення коли ключ буде створено.

openpgp-key-expiry-label =
    .label = Термін дії

openpgp-key-id-label =
    .label = ID ключа

openpgp-cannot-change-expiry = Це ключ зі складною структурою, зміна його терміну дії не підтримується.

openpgp-key-man-title =
    .title = Менеджер ключів OpenPGP
openpgp-key-man-generate =
    .label = Додавання пов'язаного ключа
    .accesskey = к
openpgp-key-man-gen-revoke =
    .label = Сертифікат про відкликання
    .accesskey = в
openpgp-key-man-ctx-gen-revoke-label =
    .label = Створити та зберегти сертифікат про відкликання

openpgp-key-man-file-menu =
    .label = Файл
    .accesskey = Ф
openpgp-key-man-edit-menu =
    .label = Змінити
    .accesskey = З
openpgp-key-man-view-menu =
    .label = Переглянути
    .accesskey = П
openpgp-key-man-generate-menu =
    .label = Створити
    .accesskey = С
openpgp-key-man-keyserver-menu =
    .label = Сервер ключів
    .accesskey = С

openpgp-key-man-import-public-from-file =
    .label = Імпорт відкритих ключів із файлу
    .accesskey = м
openpgp-key-man-import-secret-from-file =
    .label = Імпорт таємних ключів із файлу
openpgp-key-man-import-sig-from-file =
    .label = Імпорти відкликаних з файлу
openpgp-key-man-import-from-clipbrd =
    .label = Імпорт ключів із буфера обміну
    .accesskey = б
openpgp-key-man-import-from-url =
    .label = Імпорт ключів з URL-адреси
    .accesskey = а
openpgp-key-man-export-to-file =
    .label = Експорт відкритих ключів до файлу
    .accesskey = Е
openpgp-key-man-send-keys =
    .label = Надіслати відкриті ключі електронною поштою
    .accesskey = Н
openpgp-key-man-backup-secret-keys =
    .label = Резервне копіювання таємних ключів до файлу
    .accesskey = Р

openpgp-key-man-discover-cmd =
    .label = Дослідити ключі в Мережі
    .accesskey = М
openpgp-key-man-discover-prompt = Щоб дослідити ключі OpenPGP в Мережі, на серверах ключів або за допомогою протоколу WKD, введіть адресу електронної пошти або ID ключа.
openpgp-key-man-discover-progress = Пошук…

openpgp-key-copy-key =
    .label = Скопіюйте відкритий ключ
    .accesskey = к

openpgp-key-export-key =
    .label = Експорт відкритого ключа до файлу
    .accesskey = п

openpgp-key-backup-key =
    .label = Резервне копіювання таємного ключа до файлу
    .accesskey = є

openpgp-key-send-key =
    .label = Надіслати відкритий ключ електронною поштою
    .accesskey = п

openpgp-key-man-copy-to-clipbrd =
    .label = Скопіювати відкриті ключі до буфера обміну
    .accesskey = м
openpgp-key-man-ctx-expor-to-file-label =
    .label = Експорт ключів до файлу
openpgp-key-man-ctx-copy-to-clipbrd-label =
    .label = Скопіювати відкриті ключі до буфера обміну

openpgp-key-man-close =
    .label = Закрити
openpgp-key-man-reload =
    .label = Перезавантажити кеш ключів
    .accesskey = ш
openpgp-key-man-change-expiry =
    .label = Змінити термін дії
    .accesskey = д
openpgp-key-man-del-key =
    .label = Видалити ключі
    .accesskey = и
openpgp-delete-key =
    .label = Видалити ключ
    .accesskey = д
openpgp-key-man-revoke-key =
    .label = Відкликати ключ
    .accesskey = л
openpgp-key-man-key-props =
    .label = Властивості ключа
    .accesskey = ю
openpgp-key-man-key-more =
    .label = Докладніше
    .accesskey = о
openpgp-key-man-view-photo =
    .label = Фото ID
    .accesskey = Ф
openpgp-key-man-ctx-view-photo-label =
    .label = Переглянути фото ID
openpgp-key-man-show-invalid-keys =
    .label = Показати недійсні ключі
    .accesskey = о
openpgp-key-man-show-others-keys =
    .label = Показати ключі від інших людей
    .accesskey = ш
openpgp-key-man-user-id-label =
    .label = Назва
openpgp-key-man-fingerprint-label =
    .label = Цифровий відбиток
openpgp-key-man-select-all =
    .label = Вибрати всі ключі
    .accesskey = в
openpgp-key-man-empty-tree-tooltip =
    .label = Введіть пошукові терміни в поле вище
openpgp-key-man-nothing-found-tooltip =
    .label = Жоден ключ не збігається з введеним
openpgp-key-man-please-wait-tooltip =
    .label = Зачекайте, доки завантажуються ключі…

openpgp-key-man-filter-label =
    .placeholder = Пошук ключів

openpgp-key-man-select-all-key =
    .key = В
openpgp-key-man-key-details-key =
    .key = І

openpgp-key-details-title =
    .title = Властивості ключа
openpgp-key-details-signatures-tab =
    .label = Сертифікати
openpgp-key-details-structure-tab =
    .label = Структура
openpgp-key-details-uid-certified-col =
    .label = ID користувача / Сертифіковано користувачем
openpgp-key-details-user-id2-label = Вказаний власник ключа
openpgp-key-details-id-label =
    .label = ID
openpgp-key-details-key-type-label = Тип
openpgp-key-details-key-part-label =
    .label = Частина ключа
openpgp-key-details-algorithm-label =
    .label = Алгоритм
openpgp-key-details-size-label =
    .label = Розмір
openpgp-key-details-created-label =
    .label = Створено
openpgp-key-details-created-header = Створено
openpgp-key-details-expiry-label =
    .label = Термін дії
openpgp-key-details-expiry-header = Термін дії
openpgp-key-details-usage-label =
    .label = Використання
openpgp-key-details-fingerprint-label = Цифровий відбиток
openpgp-key-details-sel-action =
    .label = Вибрати дію…
    .accesskey = д
openpgp-key-details-also-known-label = Інші ідентифікатори власника ключа:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Закрити
openpgp-acceptance-label =
    .label = Затверджено вами
openpgp-acceptance-rejected-label =
    .label = Ні, відхилити цей ключ.
openpgp-acceptance-undecided-label =
    .label = Не зараз, можливо потім.
openpgp-acceptance-unverified-label =
    .label = Так, але я не верифікував правильність ключа.
openpgp-acceptance-verified-label =
    .label = Так, я особисто верифікував, правильність цифрового відбитка цього ключа.
key-accept-personal =
    Для цього ключа у вас є і відкрита, і таємна частини. Ви можете застосовувати його як особистий ключ.
    Якщо цей ключ вам дав хтось інший, то не користуйтеся ним як особистим ключем.
key-personal-warning = Чи створили ви цей ключ самостійно та чи саме ви є власником показаного ключа?
openpgp-personal-no-label =
    .label = Ні, не використовувати його як мій особистий ключ.
openpgp-personal-yes-label =
    .label = Так, вважати цей ключ моїм особистим ключем.

openpgp-copy-cmd-label =
    .label = Копіювати

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbird не знайшов особистих ключів OpenPGP, пов’язаних з <b>{ $identity }</b>
        [one] Thunderbird знайшов { $count } особистий ключ OpenPGP, пов’язаний з <b>{ $identity }</b>
        [few] Thunderbird знайшов { $count } особисті ключі OpenPGP, пов’язаних з <b>{ $identity }</b>
       *[many] Thunderbird знайшов { $count } особистих ключів OpenPGP, пов’язаних з <b>{ $identity }</b>
    }

#   $count (Number) - the number of configured keys associated with the current identity
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status =
    { $count ->
        [0] Виберіть чинний ключ для увімкнення протоколу OpenPGP.
        [one] Ваші поточні налаштування використовують ID ключа <b>{ $key }</b>
        [few] Ваші поточні налаштування використовують ID ключів <b>{ $key }</b>
       *[many] Ваші поточні налаштування використовують ID ключів <b>{ $key }</b>
    }

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Ваші поточні налаштування використовують не чинний ключ <b>{ $key }</b>.

openpgp-add-key-button =
    .label = Додати ключ…
    .accesskey = о

e2e-learn-more = Докладніше

openpgp-keygen-success = Ключ OpenPGP успішно створено!

openpgp-keygen-import-success = Ключі OpenPGP успішно імпортовано!

openpgp-keygen-external-success = Зовнішній ID ключа GnuPG збережено!

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Немає

openpgp-radio-none-desc = Не користуватися OpenPGP для цієї особи.

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Чинний до: { $date }

openpgp-key-expires-image =
    .tooltiptext = Термін дії ключа закінчується менш ніж за 6 місяців

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Не чинний від: { $date }

openpgp-key-expired-image =
    .tooltiptext = Ключ не чинний

openpgp-key-expand-section =
    .tooltiptext = Докладніше

openpgp-key-revoke-title = Відкликати ключ

openpgp-key-edit-title = Змінити ключ OpenPGP

openpgp-key-edit-date-title = Продовжити термін дії

openpgp-manager-description = Користуйтеся менеджером ключів OpenPGP для перегляду та керування відкритими ключами ваших кореспондентів та всіма іншими ключами, які не перелічені вище.

openpgp-manager-button =
    .label = Менеджер ключів OpenPGP
    .accesskey = O

openpgp-key-remove-external =
    .label = Видалити ID зовнішнього ключа
    .accesskey = з

key-external-label = Зовнішній ключ GnuPG

# Strings in keyDetailsDlg.xhtml
key-type-public = відкритий ключ
key-type-primary = головний ключ
key-type-subkey = дочірній ключ
key-type-pair = пов'язані ключі (таємний та відкритий)
key-expiry-never = ніколи
key-usage-encrypt = Захистити
key-usage-sign = Підписати
key-usage-certify = Сертифікувати
key-usage-authentication = Автентифікація
key-does-not-expire = Безтерміновий ключ
key-expired-date = Ключ чинний до { $keyExpiry }
key-expired-simple = Ключ вже не чинний
key-revoked-simple = Ключ було відкликано
key-do-you-accept = Чи затверджуєте ви цей ключ для перевірки цифрових підписів та захисту повідомлень?
key-accept-warning = Уникайте затвердження шахрайського ключа. Використовуйте інший канал зв'язку, крім електронної пошти, щоб перевірити цифровий відбиток ключа вашого співрозмовника.

# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Не вдається надіслати повідомлення, оскільки є проблема з вашим особистим ключем. { $problem }
cannot-encrypt-because-missing = Не вдається надіслати це повідомлення захищене наскрізним шифруванням, оскільки є проблеми з ключами таких одержувачів: { $problem }
window-locked = Вікно написання заблоковано; надсилання скасовано

# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Захищена частина повідомлення
mime-decrypt-encrypted-part-concealed-data = Це захищена частина повідомлення. Необхідно відкрити її в окремому вікні, натиснувши на вкладення.

# Strings in keyserver.jsm
keyserver-error-aborted = Скасовано
keyserver-error-unknown = Сталася невідома помилка
keyserver-error-server-error = Сервер ключів повідомив про помилку.
keyserver-error-import-error = Не вдалося імпортувати завантажений ключ.
keyserver-error-unavailable = Сервер ключів недоступний.
keyserver-error-security-error = Сервер ключів не підтримує захищений доступ.
keyserver-error-certificate-error = Сертифікат сервера ключів недійсний.
keyserver-error-unsupported = Сервер ключів не підтримується.

# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Ваш постачальник електронної пошти обробив ваш запит щодо вивантаження вашого відкритого ключа до каталогу
    мережних ключів OpenPGP. Підтвердьте, щоб вивантаження відкритого ключа.
wkd-message-body-process =
    Цей електронний лист, пов’язаний з автоматичною обробкою вивантаження вашого відкритого ключа до каталогу
    мережних ключів OpenPGP. На цю мить вам не потрібно виконувати жодних дій вручну.

# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Не вдалося розшифрувати повідомлення з темою
    { $subject }.
    Бажаєте спробувати з іншою парольною фразою чи хочете пропустити повідомлення?

# Strings in gpg.jsm
unknown-signing-alg = Невідомий алгоритм підписання (ID: { $id })
unknown-hash-alg = Невідомий криптографічний хеш (ID: { $id })

# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Термін дії вашого ключа { $desc } закінчується за { $days } днів.
    Ми радимо створити нові пов'язані ключі й налаштувати відповідні облікові записи для їхнього використання.
expiry-keys-expire-soon =
    Термін дії таких ключів завершується менше ніж за { $days } днів: { $desc }.
    Ми радимо створити нові ключі та налаштувати відповідні облікові записи для їхнього використання.
expiry-key-missing-owner-trust =
    У вашому таємному ключі { $desc } відсутні налаштування довіри.
    Ми радимо встановити параметр "Ви покладаєтесь на сертифікати" на "довіряти цілком" у властивостях ключа.
expiry-keys-missing-owner-trust =
    У таких ваших таємному ключах відсутні налаштування довіри.
    { $desc }.
    Ми радимо встановити параметр "Ви покладаєтесь на сертифікати" на "довіряти цілком" у властивостях ключа.
expiry-open-key-manager = Відкрити менеджер ключів OpenPGP
expiry-open-key-properties = Відкрити властивості ключів

# Strings filters.jsm
filter-folder-required = Виберіть теку для збереження.
filter-decrypt-move-warn-experimental =
    Попередження - дія фільтра "Завжди розшифрувати" може призвести до знищення повідомлень.
    Ми наполегливо радимо спершу спробувати фільтр "Створити розшифровану копію", ретельно перевірити результат та застосувати цей фільтр лише після задоволених результатів.
filter-term-pgpencrypted-label = Захищено OpenPGP
filter-key-required = Виберіть ключ одержувача.
filter-key-not-found = Не вдалося знайти ключ шифрування для '{ $desc }'.
filter-warn-key-not-secret =
    Попередження - дія фільтра "Захистити ключ" замінює одержувачів.
    Якщо у вас немає таємного ключа для '{ $desc }', ви більше не зможете читати електронні листи.

# Strings filtersWrapper.jsm
filter-decrypt-move-label = Завжди розшифрувати (OpenPGP)
filter-decrypt-copy-label = Створити розшифровану копію (OpenPGP)
filter-encrypt-label = Захистити ключ (OpenPGP)

# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Ключі успішно імпортовано
import-info-bits = біт
import-info-created = Створено
import-info-fpr = Цифровий відбиток
import-info-details = Перегляд деталей та керування затвердженням ключа
import-info-no-keys = Жодного ключа не імпортовано.

# Strings in enigmailKeyManager.js
import-from-clip = Бажаєте імпортувати ключі з буфера обміну?
import-from-url = Завантажити відкритий ключ з цієї URL-адреси:
copy-to-clipbrd-failed = Не вдалося скопіювати вибрані ключі до буфера обміну.
copy-to-clipbrd-ok = Ключі скопійовано до буфера обміну
delete-secret-key =
    УВАГА: Ви збираєтесь видалити таємний ключ!
    
    Якщо ви видалите таємний ключ, ви більше не зможете розшифрувати жодного повідомлення, захищене для розшифрування цим ключем, і не зможете його відкликати.
    
    Ви дійсно хочете видалити, і таємний, і відкритий ключі
    '{ $userId }'?
delete-mix =
    Увага: Ви збираєтесь видалити таємні ключі!
    Якщо ви видалите таємний ключ, ви більше не зможете розшифрувати жодного повідомлення, захищених для розшифрування цим ключем.
    Ви дійсно хочете видалити вибрані таємний і відкритий ключі?
delete-pub-key =
    Хочете видалити відкритий ключ
    '{ $userId }'?
delete-selected-pub-key = Хочете видалити відкриті ключі?
refresh-all-question = Ви не вибрали жодного ключа. Хочете оновити ВСІ ключі?
key-man-button-export-sec-key = Експортувати &таємні ключі
key-man-button-export-pub-key = Експортувати лише &відкриті ключі
key-man-button-refresh-all = &Оновити всі ключі
key-man-loading-keys = Ключі завантажуються, зачекайте…
ascii-armor-file = Захищені ASCII файли (*.asc)
no-key-selected = Виберіть хоча б один ключ, щоб виконати вибрану операцію
export-to-file = Експортувати відкритий ключ до файлу
export-keypair-to-file = Експортувати відкритий і таємний ключі до файлу
export-secret-key = Бажаєте включити таємний ключ до збереженого файлу ключа OpenPGP?
save-keys-ok = Ключі успішно збережено
save-keys-failed = Не вдалося зберегти ключі
default-pub-key-filename = Експортовані-відкриті-ключі
default-pub-sec-key-filename = Резервні-копії-таємних-ключів
refresh-key-warn = Попередження: залежно від кількості ключів та швидкості з'єднання, оновлення всіх ключів може тривати досить довго!
preview-failed = Не вдається прочитати файл відкритого ключа.
general-error = Помилка: { $reason }
dlg-button-delete = &Видалити

## Account settings export output

openpgp-export-public-success = <b>Відкритий ключ успішно експортовано!</b>
openpgp-export-public-fail = <b>Не вдається експортувати вибраний відкритий ключ!</b>

openpgp-export-secret-success = <b>Таємний ключ успішно експортовано!</b>
openpgp-export-secret-fail = <b>Не вдається експортувати вибраний таємний ключ!</b>

# Strings in keyObj.jsm
key-ring-pub-key-revoked = Ключ { $userId } (ID ключа { $keyId }) відкликано.
key-ring-pub-key-expired = Ключ { $userId } (ID ключа { $keyId }) втратив чинність.
key-ring-key-disabled = Ключ { $userId } (ID ключа { $keyId }) вимкнено; його не можна використовувати.
key-ring-key-invalid = Ключ { $userId } (ID ключа { $keyId }) недійсний. Будь ласка, спробуйте перевірити його правильно.
key-ring-key-not-trusted = Недостатня довіра до ключа { $userId } (ID ключа { $keyId }) . Будь ласка, встановіть рівень довіри вашому ключеві на "довіряти цілком", щоб застосовувати його для підписання.
key-ring-no-secret-key = Схоже ви не маєте таємного ключа для { $userId } (ID ключа { $keyId }) серед ваших ключів; ви не можете скористатися ключем для підписання.
key-ring-pub-key-not-for-signing = Ключ { $userId } (ID ключа { $keyId }) не можна використовувати для підписання.
key-ring-pub-key-not-for-encryption = Ключ { $userId } (ID ключа { $keyId }) не можна використовувати для шифрування.
key-ring-sign-sub-keys-revoked = Усі дочірні ключі для підписання { $userId } (ID ключа { $keyId }) відкликано.
key-ring-sign-sub-keys-expired = Усі дочірні ключі для підписання { $userId } (ID ключа { $keyId }) втратили чинність.
key-ring-sign-sub-keys-unusable = Усі дочірні ключі для підписання { $userId } (ID ключа { $keyId }) відкликано, втратили чинність або не дійсні з іншої причини.
key-ring-enc-sub-keys-revoked = Усі дочірні ключі { $userId } (ID ключа { $keyId }) відкликано.
key-ring-enc-sub-keys-expired = Усі дочірні ключі { $userId } (ID ключа { $keyId }) втратили чинність.
key-ring-enc-sub-keys-unusable = Усі дочірні ключі для підписання { $userId } (ID ключа { $keyId }) відкликано, втратили чинність або не дійсні з іншої причини.

# Strings in gnupg-keylist.jsm
keyring-photo = Світлина
user-att-photo = Атрибут користувача (зображення JPEG)

# Strings in key.jsm
already-revoked = Цей ключ вже відкликано.

#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Ви збираєтесь відкликати ключ '{ $identity }'.
    Ви більше не зможете підписувати цим ключем і після повідомлення, інші не зможуть надалі користуватися цим ключем для захисту. Ви зможете користуватися цим ключем для розшифрування старих повідомлень.
    Хочете продовжити?

#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    У вас немає ключа (0x{ $keyId }), який би відповідав цьому сертифікату про відкликання!
    Якщо ви втратили свій ключ, вам потрібно імпортувати його (наприклад, із сервера ключів), перш ніж імпортувати сертифікат відкликання!

#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = Ключ 0x{ $keyId } вже відкликано.

key-man-button-revoke-key = &Відкликати ключ

openpgp-key-revoke-success = Ключ успішно відкликано.

after-revoke-info =
    Ключ відкликано.
    Поділіться цим відкритим ключем ще раз, надіславши його електронною поштою або завантаживши його на сервери ключів, щоб інші могли знати, що ви відкликали ваш ключ.
    Як тільки програмне забезпечення, яке використовують інші люди, дізнається про відкликання, воно перестане застосовувати ваш старий ключ.
    Якщо ви використовуєте новий ключ для тієї ж адреси електронної пошти й додаєте новий відкритий ключ до надісланих електронних листів, то інформацію про ваш старий відкликаний ключ буде автоматично включено.

# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Імпортувати

delete-key-title = Видалити ключ OpenPGP

delete-external-key-title = Вилучити зовнішній ключ GnuPG

delete-external-key-description = Бажаєте вилучити цей зовнішній ID ключа GnuPG?

key-in-use-title = Ключ OpenPGP зараз використовується

delete-key-in-use-description = Неможливо продовжити! Ключ, який ви хочете видалити, в цей час використовується цією особою. Виберіть інший ключ або виберіть "немає" та спробуйте ще раз.

revoke-key-in-use-description = Неможливо продовжити! Ключ, який ви хочете відхилити, в цей час використовується цією особою. Виберіть інший ключ або виберіть "немає" та спробуйте ще раз.

# Strings used in errorHandling.jsm
key-error-key-spec-not-found = Адресу електронної пошти '{ $keySpec }' не вдається узгодити з жодним вашим ключем.
key-error-key-id-not-found = Налаштований ID '{ $keySpec }' не вдається знайти серед ваших ключів.
key-error-not-accepted-as-personal = Ви не підтвердили, що ключ з ID '{ $keySpec }' є вашим особистим ключем.

# Strings used in enigmailKeyManager.js & windows.jsm
need-online = Вибрана вами функція недоступна в автономному режимі. Увімкніть з'єднання з Мережею та спробуйте знову.

# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Не вдалося знайти жодного ключа, який би відповідав вказаним умовам пошуку.

# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Помилка - не вдалося виконати команду розпакування ключа

# Strings used in keyRing.jsm
fail-cancel = Помилка - користувач скасував надсилання ключа
not-first-block = Помилка - перший блок OpenPGP не є блоком відкритого ключа
import-key-confirm = Імпортувати вкладені у повідомлення відкриті ключі?
fail-key-import = Помилка - Не вдалось імпортувати ключ
file-write-failed = Не вдалося записати до файлу { $output }
no-pgp-block = Помилка - не знайдено дійсного додатково захищеного блоку даних OpenPGP
confirm-permissive-import = Не вдалося імпортувати. Ключ, який ви намагаєтеся імпортувати, може бути пошкоджено або використовує невідомі атрибути. Бажаєте імпортувати правильні подробиці? Це може призвести до імпорту неповних та непридатних ключів.

# Strings used in trust.jsm
key-valid-unknown = невідомо
key-valid-invalid = недійсний
key-valid-disabled = вимкнено
key-valid-revoked = відкликано
key-valid-expired = не чинний
key-trust-untrusted = ненадійний
key-trust-marginal = граничний
key-trust-full = довірений
key-trust-ultimate = довіряти цілком
key-trust-group = (група)

# Strings used in commonWorkflows.js
import-key-file = Імпортувати файл ключа OpenPGP
import-rev-file = Імпортувати файл відкликання OpenPGP
gnupg-file = Файли GnuPG
import-keys-failed = Не вдалося імпортувати ключі
passphrase-prompt = Введіть парольну фразу, яка розблокує такий ключ: { $key }
file-to-big-to-import = Цей файл завеликий. Не імпортуйте відразу великий набір ключів.

# Strings used in enigmailKeygen.js
save-revoke-cert-as = Створити та зберегти сертифікат про відкликання
revoke-cert-ok = Сертифікат про відкликання успішно створено. Ви можете використовувати його для визнання недійсним вашого відкритого ключа, наприклад якщо ви втратите таємний ключ.
revoke-cert-failed = Не вдалося створити сертифікат відкликання.
gen-going = Ключ вже створюється!
keygen-missing-user-name = Для вибраного облікового запису/особи не вказано ім’я. Введіть ім'я до поля  "Ваше ім'я" в налаштуваннях облікового запису.
expiry-too-short = Ваш ключ повинен бути дійсним щонайменше один день.
expiry-too-long = Ви не можете створити ключ, термін дії якого понад 100 років.
key-confirm = Створити відкритий та таємний ключ для '{ $id }'?
key-man-button-generate-key = &Створити ключ
key-abort = Скасувати створення ключа?
key-man-button-generate-key-abort = &Скасувати створення ключа?
key-man-button-generate-key-continue = &Продовжити створення ключа

# Strings used in enigmailMessengerOverlay.js
failed-decrypt = Помилка - не вдалося розшифрувати
fix-broken-exchange-msg-failed = Не вдалося відновити повідомлення.
attachment-no-match-from-signature = Не вдалося зіставити файл підпису '{ $attachment }' та вкладений файл
attachment-no-match-to-signature = Не вдалося зіставити вкладення '{ $attachment }' та файл підпису
signature-verified-ok = Підпис для вкладення { $attachment } успішно верифіковано
signature-verify-failed = Підпис для вкладення { $attachment } не вдалося верифікувати
decrypt-ok-no-sig =
    Попередження
    Розшифрування вдалося, але не вдалося правильно верифікувати підпис
msg-ovl-button-cont-anyway = &Знехтувати та продовжити
enig-content-note = *Вкладення цього повідомлення не підписано та не захищено*

# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = &Надіслати повідомлення
msg-compose-details-button-label = Подробиці…
msg-compose-details-button-access-key = П
send-aborted = Надсилання скасовано.
key-not-trusted = Недостатньо довіри до ключа '{ $key }'
key-not-found = Ключ '{ $key }' не знайдено
key-revoked = Ключ '{ $key }' відкликано
key-expired = Ключ '{ $key }' не чинний
msg-compose-internal-error = Виникла внутрішня помилка.
keys-to-export = Виберіть OpenPGP ключі для вставлення
msg-compose-partially-encrypted-inlinePGP =
    Повідомлення, на яке ви відповідаєте, містило як незахищені, так і захищені частини. Якщо відправник не зміг спочатку розшифрувати деякі частини повідомлення, можливо, існує витік конфіденційної інформації яку відправник не зміг спочатку розшифрувати самостійно.
    Будь ласка, видаліть весь цитований текст з вашої відповіді цьому відправнику.
msg-compose-cannot-save-draft = Помилка під час збереження чернетки
msg-compose-partially-encrypted-short = Остерігайтеся витоку вразливої інформації - частково захищеного електронного листа.
quoted-printable-warn =
    Ви ввімкнули кодування 'quoted-printable' для надсилання повідомлень. Це може призвести до неправильних розшифрування та/або верифікації вашого повідомлення.
    Ви хочете вимкнути надсилання повідомлень з 'quoted-printable' зараз?
minimal-line-wrapping =
    Ви налаштували загортання рядків понад { $width } символів. Для правильного шифрування та/або підписання це значення повинно бути не менше 68.
    Бажаєте змінити згортання рядків на 68 символів зараз?
sending-hidden-rcpt = Не можна додавати одержувачів BCC (сліпих копій) для надсилання захищеного повідомлення. Щоб надіслати це захищене повідомлення, видаліть одержувачів BCC або перемістіть їх до поля CC.
sending-news =
    Захищене надсилання скасовано.
    Це повідомлення не можна зашифрувати, оскільки є одержувачі у групі новин. Будь ласка, повторно надішліть незахищене повідомлення.
send-to-news-warning =
    Попередження: ви збираєтесь надіслати захищений електронний лист до групи новин.
    Це не рекомендовано, оскільки це має сенс лише у випадку, коли всі члени групи можуть розшифрувати повідомлення, тобто повідомлення потрібно захистити ключами всіх учасників групи. Надішліть це повідомлення лише за умови, що ви впевнені у своїх діях.
    Продовжити?
save-attachment-header = Зберегти розшифроване вкладення
no-temp-dir =
    Не вдалося знайти тимчасову теку для запису
    Будь ласка, встановіть змінну середовища TEMP
possibly-pgp-mime = Можливо, повідомлення захищене або підписане за допомогою PGP/MIME; скористайтеся функцією 'Розшифрувати/Верифікувати' для підтвердження
cannot-send-sig-because-no-own-key = Не вдається підписати це повідомлення цифровим підписом, оскільки ви ще не налаштували наскрізне шифрування для <{ $key }>
cannot-send-enc-because-no-own-key = Не вдається надіслати це повідомлення захищеним, оскільки ви ще не налаштували наскрізне шифрування для <{ $key }>

# Strings used in decryption.jsm
do-import-multiple =
    Імпортувати ці ключі?
    { $key }
do-import-one = Імпортувати { $name } ({ $id })?
cant-import = Помилка імпорту відкритого ключа
unverified-reply = Частину повідомлення (відповіді), ймовірно, було змінено
key-in-message-body = У повідомленні знайдено ключ. Натисніть 'Імпортувати ключ', щоб імпортувати його
sig-mismatch = Помилка - невідповідність підпису
invalid-email = Помилка - недійсна електронна адреса
attachment-pgp-key =
    Вкладення '{ $name }', яке ви відкриваєте, є файлом ключа OpenPGP.
    Клацніть 'Імпортувати', щоб імпортувати їх, або 'Переглянути', щоб переглянути вміст файлу у вікні браузера
dlg-button-view = &Переглянути

# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Розшифроване повідомлення (відновлено зламаний формат PGP електронної пошти, ймовірно, спричинено застарілим сервером Exchange, в результаті, читання може бути ускладнено)

# Strings used in encryption.jsm
not-required = Помилка - не вимагається шифрування

# Strings used in windows.jsm
no-photo-available = Немає світлини
error-photo-path-not-readable = Шлях до світлини '{ $photo }' неможливо прочитати
debug-log-title = Журнал зневадження OpenPGP

# Strings used in dialog.jsm
repeat-prefix = Це сповіщення повторюватиметься { $count }
repeat-suffix-singular = раз.
repeat-suffix-plural = разів.
no-repeat = Це попередження більше не з'являтиметься.
dlg-keep-setting = Запам’ятати моє рішення і більше не запитувати
dlg-button-ok = &OK
dlg-button-close = &Закрити
dlg-button-cancel = &Скасувати
dlg-no-prompt = Більше не показувати це вікно.
enig-prompt = Підказка OpenPGP
enig-confirm = Підтвердження OpenPGP
enig-alert = Сповіщення OpenPGP
enig-info = Відомості OpenPGP

# Strings used in persistentCrypto.jsm
dlg-button-retry = &Повторити
dlg-button-skip = &Пропустити

# Strings used in enigmailCommon.js
enig-error = Помилка OpenPGP
enig-alert-title =
    .title = Сповіщення OpenPGP
