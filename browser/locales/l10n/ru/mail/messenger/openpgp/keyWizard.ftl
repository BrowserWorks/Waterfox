# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Добавить персональный ключ OpenPGP для { $identity }
key-wizard-button =
    .buttonlabelaccept = Продолжить
    .buttonlabelhelp = Вернуться
key-wizard-warning = <b>Если у вас есть личный ключ</b> для этого адреса электронной почты, вы должны его импортировать. В противном случае у вас не будет доступа к вашим архивам зашифрованных писем и вы не сможете читать входящие зашифрованные письма от людей, которые всё ещё используют ваш существующий ключ.
key-wizard-learn-more = Подробнее
radio-create-key =
    .label = Создать новый ключ OpenPGP
    .accesskey = з
radio-import-key =
    .label = Импортировать существующий ключ OpenPGP
    .accesskey = м
radio-gnupg-key =
    .label = Использовать свой внешний ключ через GnuPG (например, со смарт-карты)
    .accesskey = п

## Generate key section

openpgp-generate-key-title = Создать ключ OpenPGP
openpgp-generate-key-info = <b>Генерация ключа может занять до нескольких минут.</b> Не выходите из приложения, пока идёт процесс генерации ключа. Активный просмотр страниц или выполнение операций с интенсивным использованием диска во время генерации ключа пополнит «пул случайностей» и ускорит процесс. Вы будете предупреждены, когда генерация ключа будет завершена.
openpgp-keygen-expiry-title = Срок действия ключа
openpgp-keygen-expiry-description = Определите срок действия вашего нового сгенерированного ключа. Позже вы можете управлять датой, чтобы продлить её при необходимости.
radio-keygen-expiry =
    .label = Срок действия ключа истекает через
    .accesskey = е
radio-keygen-no-expiry =
    .label = Ключ не истекает
    .accesskey = ю
openpgp-keygen-days-label =
    .label = дней
openpgp-keygen-months-label =
    .label = месяцев
openpgp-keygen-years-label =
    .label = лет
openpgp-keygen-advanced-title = Дополнительные параметры
openpgp-keygen-advanced-description = Управление дополнительными параметрами вашего ключа OpenPGP.
openpgp-keygen-keytype =
    .value = Тип ключа:
    .accesskey = и
openpgp-keygen-keysize =
    .value = Размер ключа:
    .accesskey = з
openpgp-keygen-type-rsa =
    .label = RSA
openpgp-keygen-type-ecc =
    .label = ECC (эллиптические кривые)
openpgp-keygen-button = Создать ключ
openpgp-keygen-progress-title = Генерация вашего нового ключа OpenPGP…
openpgp-keygen-import-progress-title = Импорт ваших ключей OpenPGP…
openpgp-import-success = Ключи OpenPGP успешно импортированы!
openpgp-import-success-title = Завершение процесса импорта
openpgp-import-success-description = Чтобы начать использование импортированного ключа OpenPGP для шифрования электронной почты, закройте это диалоговое окно и зайдите в параметры своей учётной записи, чтобы его выбрать.
openpgp-keygen-confirm =
    .label = Подтвердить
openpgp-keygen-dismiss =
    .label = Отмена
openpgp-keygen-cancel =
    .label = Отменить процесс…
openpgp-keygen-import-complete =
    .label = Закрыть
    .accesskey = ы
openpgp-keygen-missing-username = Для текущей учётной записи не указано имя. Введите значение в поле · «Ваше имя» в параметрах учётной записи.
openpgp-keygen-long-expiry = Вы не можете создать ключ, срок действия которого истекает более чем через 100 лет.
openpgp-keygen-short-expiry = Ваш ключ должен быть действителен по меньшей мере один день.
openpgp-keygen-ongoing = Генерация ключа уже выполняется!
openpgp-keygen-error-core = Невозможно инициализировать основной сервис OpenPGP
openpgp-keygen-error-failed = Генерация ключа OpenPGP неожиданно прервалась
#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = Ключ OpenPGP создан успешно, но не удалось получить отзыв для ключа { $key }
openpgp-keygen-abort-title = Прервать генерацию ключа?
openpgp-keygen-abort = Генерация ключа OpenPGP в настоящее время продолжается, вы уверены, что хотите её отменить?
#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Создать открытый и секретный ключ для { $identity }?

## Import Key section

openpgp-import-key-title = Импортировать существующий личный ключ OpenPGP
openpgp-import-key-legend = Выберите ранее сохранённую копию файла.
openpgp-import-key-description = Вы можете импортировать личные ключи, созданные с помощью другого программного обеспечения OpenPGP.
openpgp-import-key-info = Другое программное обеспечение может описывать личный ключ с помощью альтернативных терминов, например, ваш собственный ключ, секретный ключ, закрытый ключ или пара ключей.
#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird обнаружил { $count } ключ, который можно импортировать.
        [few] Thunderbird обнаружил { $count } ключа, которые можно импортировать.
       *[many] Thunderbird обнаружил { $count } ключей, которые можно импортировать.
    }
openpgp-import-key-list-description = Подтвердите, какие ключи могут рассматриваться в качестве ваших личных ключей. В качестве личных ключей должны использоваться только ключи, которые вы создали сами и которые идентифицируют вашу личность. Вы можете изменить эту настройку позже в диалоговом окне Свойства ключа.
openpgp-import-key-list-caption = Ключи, помеченные как Личные, будут перечислены в разделе Сквозное шифрование. Другие будут доступны в Менеджере ключей.
openpgp-passphrase-prompt-title = Требуется парольная фраза
#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Введите, пожалуйста, парольную фразу, чтобы разблокировать следующий ключ: { $key }
openpgp-import-key-button =
    .label = Выбор файла для импорта…
    .accesskey = ы
import-key-file = Импорт файла ключей OpenPGP
import-key-personal-checkbox =
    .label = Рассматривать этот ключ в качестве Личного ключа
gnupg-file = Файлы GnuPG
import-error-file-size = <b>Ошибка!</b> Файлы размером более 5МБ не поддерживаются.
#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Ошибка!</b> Не удалось импортировать файл. { $error }
#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Ошибка!</b> Не удалось импортировать ключи. { $error }
openpgp-import-identity-label = Личность
openpgp-import-fingerprint-label = Отпечаток
openpgp-import-created-label = Создан
openpgp-import-bits-label = Биты
openpgp-import-key-props =
    .label = Свойства ключа
    .accesskey = в

## External Key section

openpgp-external-key-title = Внешний ключ GnuPG
openpgp-external-key-description = Настройте внешний ключ GnuPG, введя идентификатор ключа
openpgp-external-key-info = Кроме того, вы должны использовать Менеджер ключей для импорта и принятия соответствующего открытого ключа.
openpgp-external-key-warning = <b>Вы можете настроить только один внешний ключ GnuPG.</b> Ваша предыдущая запись будет заменена.
openpgp-save-external-button = Сохранить идентификатор ключа
openpgp-external-key-label = Идентификатор секретного ключа:
openpgp-external-key-input =
    .placeholder = 123456789341298340
