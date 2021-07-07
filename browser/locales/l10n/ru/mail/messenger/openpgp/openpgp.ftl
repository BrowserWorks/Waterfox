# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = Чтобы отправлять зашифрованные сообщения или сообщения с цифровой подписью, вам необходимо настроить технологию шифрования, например, OpenPGP или S/MIME.
e2e-intro-description-more = Выберите свой личный ключ, чтобы включить использование OpenPGP, или свой личный сертификат, чтобы разрешить использование S/MIME. Для личного ключа или сертификата у вас должен быть соответствующий секретный ключ.
openpgp-key-user-id-label = Учётная запись / Идентификатор пользователя
openpgp-keygen-title-label =
    .title = Создать ключ OpenPGP
openpgp-cancel-key =
    .label = Отмена
    .tooltiptext = Отменить генерацию ключа
openpgp-key-gen-expiry-title =
    .label = Срок действия ключа
openpgp-key-gen-expire-label = Срок действия ключа истекает через
openpgp-key-gen-days-label =
    .label = дней
openpgp-key-gen-months-label =
    .label = месяцев
openpgp-key-gen-years-label =
    .label = лет
openpgp-key-gen-no-expiry-label =
    .label = Ключ не истекает
openpgp-key-gen-key-size-label = Размер ключа
openpgp-key-gen-console-label = Генерация ключа
openpgp-key-gen-key-type-label = Тип ключа
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (эллиптические кривые)
openpgp-generate-key =
    .label = Создать ключ
    .tooltiptext = Генерирует новый совместимый с OpenPGP ключ для шифрования и/или подписи
openpgp-advanced-prefs-button-label =
    .label = Дополнительно…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">ПРИМЕЧАНИЕ: Генерация ключа может занять до нескольких минут.</a> Не выходите из приложения, пока идёт генерация ключа. Активный просмотр страниц или выполнение операций с интенсивным использованием диска во время генерации ключа пополнит «пул случайностей» и ускорит процесс. Вы будете предупреждены, когда генерация ключа будет завершена.
openpgp-key-expiry-label =
    .label = Срок действия
openpgp-key-id-label =
    .label = Идентификатор ключа
openpgp-cannot-change-expiry = Это ключ со сложной структурой, изменение срока его действия не поддерживается.
openpgp-key-man-title =
    .title = Менеджер ключей OpenPGP
openpgp-key-man-generate =
    .label = Новая ключевая пара
    .accesskey = в
openpgp-key-man-gen-revoke =
    .label = Сертификат отзыва
    .accesskey = ы
openpgp-key-man-ctx-gen-revoke-label =
    .label = Создать и сохранить сертификат отзыва
openpgp-key-man-file-menu =
    .label = Файл
    .accesskey = а
openpgp-key-man-edit-menu =
    .label = Правка
    .accesskey = в
openpgp-key-man-view-menu =
    .label = Вид
    .accesskey = и
openpgp-key-man-generate-menu =
    .label = Создание
    .accesskey = з
openpgp-key-man-keyserver-menu =
    .label = Сервер ключей
    .accesskey = в
openpgp-key-man-import-public-from-file =
    .label = Импорт открытых ключей из файла
    .accesskey = м
openpgp-key-man-import-secret-from-file =
    .label = Импорт секретных ключей из файла
openpgp-key-man-import-sig-from-file =
    .label = Импорт отзывов ключей из файла
openpgp-key-man-import-from-clipbrd =
    .label = Импорт ключей из буфера обмена
    .accesskey = м
openpgp-key-man-import-from-url =
    .label = Импорт ключей из URL
    .accesskey = п
openpgp-key-man-export-to-file =
    .label = Экспорт открытых ключей в файл
    .accesskey = с
openpgp-key-man-send-keys =
    .label = Отправка открытых ключей по электронной почте
    .accesskey = в
openpgp-key-man-backup-secret-keys =
    .label = Резервирование секретных ключей в файл
    .accesskey = з
openpgp-key-man-discover-cmd =
    .label = Поискать ключи в Интернете
    .accesskey = ь
openpgp-key-man-discover-prompt = Чтобы найти ключи OpenPGP в Интернете, на серверах ключей или с использованием протокола WKD, введите адрес электронной почты или идентификатор ключа.
openpgp-key-man-discover-progress = Поиск…
openpgp-key-copy-key =
    .label = Копировать открытый ключ
    .accesskey = п
openpgp-key-export-key =
    .label = Экспортировать открытый ключ в файл
    .accesskey = ю
openpgp-key-backup-key =
    .label = Создать резервную копию секретного ключа в файле
    .accesskey = ю
openpgp-key-send-key =
    .label = Отправить открытый ключ по электронной почте
    .accesskey = э
openpgp-key-man-copy-to-clipbrd =
    .label = Копировать открытые ключи в буфер обмена
    .accesskey = о
openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
            [one] Копировать идентификатор ключа в буфер обмена
            [few] Копировать идентификаторы ключей в буфер обмена
           *[many] Копировать идентификаторы ключей в буфер обмена
        }
    .accesskey = м
openpgp-key-man-copy-fprs =
    .label =
        { $count ->
            [one] Копировать отпечаток в буфер обмена
            [few] Копировать отпечатки в буфер обмена
           *[many] Копировать отпечатки в буфер обмена
        }
    .accesskey = ч
openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
            [one] Копировать открытый ключ в буфер обмена
            [few] Копировать открытые ключи в буфер обмена
           *[many] Копировать открытые ключи в буфер обмена
        }
    .accesskey = в
openpgp-key-man-ctx-expor-to-file-label =
    .label = Экспортировать ключи в файл
openpgp-key-man-ctx-copy-to-clipbrd-label =
    .label = Копировать открытые ключи в буфер обмена
openpgp-key-man-ctx-copy =
    .label = Копировать
    .accesskey = п
openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
            [one] Отпечаток
            [few] Отпечатка
           *[many] Отпечатков
        }
    .accesskey = п
openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
            [one] Идентификатор ключа
            [few] Идентификатора ключей
           *[many] Идентификаторов ключей
        }
    .accesskey = е
openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
            [one] Открытый ключ
            [few] Открытых ключа
           *[many] Открытых ключей
        }
    .accesskey = ы
openpgp-key-man-close =
    .label = Закрыть
openpgp-key-man-reload =
    .label = Перезагрузить кеш ключей
    .accesskey = ш
openpgp-key-man-change-expiry =
    .label = Изменить срок действия
    .accesskey = м
openpgp-key-man-del-key =
    .label = Удалить ключи
    .accesskey = л
openpgp-delete-key =
    .label = Удалить ключ
    .accesskey = л
openpgp-key-man-revoke-key =
    .label = Отозвать ключ
    .accesskey = з
openpgp-key-man-key-props =
    .label = Свойства ключа
    .accesskey = й
openpgp-key-man-key-more =
    .label = Больше
    .accesskey = о
openpgp-key-man-view-photo =
    .label = Фото идентификатора
    .accesskey = к
openpgp-key-man-ctx-view-photo-label =
    .label = Просмотреть фото идентификатора
openpgp-key-man-show-invalid-keys =
    .label = Показать недействительные ключи
    .accesskey = з
openpgp-key-man-show-others-keys =
    .label = Показать ключи других людей
    .accesskey = з
openpgp-key-man-user-id-label =
    .label = Имя
openpgp-key-man-fingerprint-label =
    .label = Отпечаток
openpgp-key-man-select-all =
    .label = Выбрать все ключи
    .accesskey = б
openpgp-key-man-empty-tree-tooltip =
    .label = Введите поисковый запрос в поле выше
openpgp-key-man-nothing-found-tooltip =
    .label = Нет ключей, соответствующих вашему поисковому запросу
openpgp-key-man-please-wait-tooltip =
    .label = Пожалуйста, подождите, пока ключи загружаются…
openpgp-key-man-filter-label =
    .placeholder = Поиск ключей
openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I
openpgp-key-details-title =
    .title = Свойства ключа
openpgp-key-details-signatures-tab =
    .label = Сертификации
openpgp-key-details-structure-tab =
    .label = Структура
openpgp-key-details-uid-certified-col =
    .label = Идентификатор пользователя / Сертифицировано
openpgp-key-details-user-id2-label = Предполагаемый владелец ключа
openpgp-key-details-id-label =
    .label = Идентификатор
openpgp-key-details-key-type-label = Тип
openpgp-key-details-key-part-label =
    .label = Часть ключа
openpgp-key-details-algorithm-label =
    .label = Алгоритм
openpgp-key-details-size-label =
    .label = Размер
openpgp-key-details-created-label =
    .label = Создан
openpgp-key-details-created-header = Создан
openpgp-key-details-expiry-label =
    .label = Срок действия
openpgp-key-details-expiry-header = Срок действия
openpgp-key-details-usage-label =
    .label = Использование
openpgp-key-details-fingerprint-label = Отпечаток
openpgp-key-details-sel-action =
    .label = Выберите действие…
    .accesskey = б
openpgp-key-details-also-known-label = Предполагаемые альтернативные идентификационные данные владельца ключа:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Закрыть
openpgp-acceptance-label =
    .label = Ваше согласие
openpgp-acceptance-rejected-label =
    .label = Нет, отклонить этот ключ.
openpgp-acceptance-undecided-label =
    .label = Пока нет, может позже.
openpgp-acceptance-unverified-label =
    .label = Да, но правильность ключа мною не проверена.
openpgp-acceptance-verified-label =
    .label = Да, правильность отпечатка ключа лично мною проверена.
key-accept-personal =
    Для этого ключа у вас есть как открытая, так и секретная часть. Вы можете использовать его в качестве личного ключа.
    Если он был передан вам кем-то другим, не используйте его в качестве личного.
key-personal-warning = Вы сами создали этот ключ и отображаемая информация о владельце относится к вам?
openpgp-personal-no-label =
    .label = Нет, не использовать его как мой личный ключ.
openpgp-personal-yes-label =
    .label = Да, рассматривать этот ключ как личный ключ.
openpgp-copy-cmd-label =
    .label = Копировать

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] В Thunderbird нет личного ключа OpenPGP для <b>{ $identity }</b>
        [one] Thunderbird обнаружил { $count } личный ключ OpenPGP, связанный с <b>{ $identity }</b>
        [few] Thunderbird обнаружил { $count } личных ключа OpenPGP, связанных с <b>{ $identity }</b>
       *[many] Thunderbird обнаружил { $count } личных ключей OpenPGP, связанных с <b>{ $identity }</b>
    }
#   $count (Number) - the number of configured keys associated with the current identity
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status =
    { $count ->
        [0] Выберите подходящий ключ, чтобы включить протокол OpenPGP.
        [one] Ваша текущая конфигурация использует идентификатор ключа <b>{ $key }</b>
        [few] Ваша текущая конфигурация использует идентификатор ключа <b>{ $key }</b>
       *[many] Ваша текущая конфигурация использует идентификатор ключа <b>{ $key }</b>
    }
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-have-key = Ваша текущая конфигурация использует идентификатор ключа <b>{ $key }</b>
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Ваша текущая конфигурация использует ключ <b>{ $key }</b>, срок которого истёк.
openpgp-add-key-button =
    .label = Добавить ключ…
    .accesskey = б
e2e-learn-more = Узнать больше
openpgp-keygen-success = Ключ OpenPGP успешно создан!
openpgp-keygen-import-success = Ключи OpenPGP успешно импортированы!
openpgp-keygen-external-success = Идентификатор внешнего ключа GnuPG сохранён!

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Нет
openpgp-radio-none-desc = Не использовать OpenPGP для этой учётной записи.
openpgp-radio-key-not-usable = Этот ключ нельзя использовать в качестве личного ключа, так как секретный ключ отсутствует!
openpgp-radio-key-not-accepted = Чтобы использовать этот ключ, вы должны одобрить его как личный ключ!
openpgp-radio-key-not-found = Не удалось найти этот ключ! Если вы хотите его использовать, вы должны импортировать его в { -brand-short-name }.
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Истекает: { $date }
openpgp-key-expires-image =
    .tooltiptext = Ключ истекает менее, чем через 6 месяцев
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Срок действия истёк: { $date }
openpgp-key-expired-image =
    .tooltiptext = Срок действия ключа истёк
openpgp-key-expires-within-6-months-icon =
    .title = Ключ истекает менее чем через 6 месяцев
openpgp-key-has-expired-icon =
    .title = Срок действия ключа истёк
openpgp-key-expand-section =
    .tooltiptext = Дополнительная информация
openpgp-key-revoke-title = Отозвать ключ
openpgp-key-edit-title = Изменить ключ OpenPGP
openpgp-key-edit-date-title = Продлить срок действия
openpgp-manager-description = Используйте Менеджер ключей OpenPGP, чтобы просматривать и управлять открытыми ключами ваших корреспондентов и всеми другими ключами, не перечисленными выше.
openpgp-manager-button =
    .label = Менеджер ключей OpenPGP
    .accesskey = ж
openpgp-key-remove-external =
    .label = Удалить идентификатор внешнего ключа
    .accesskey = л
key-external-label = Внешний ключ GnuPG
# Strings in keyDetailsDlg.xhtml
key-type-public = открытый ключ
key-type-primary = основной ключ
key-type-subkey = подчинённый ключ
key-type-pair = ключевая пара (секретный и открытый ключ)
key-expiry-never = никогда
key-usage-encrypt = Зашифровать
key-usage-sign = Подписать
key-usage-certify = Удостоверить
key-usage-authentication = Аутентификация
key-does-not-expire = У ключа нет срока действия
key-expired-date = Срок действия ключа истёк { $keyExpiry }
key-expired-simple = Срок действия ключа истёк
key-revoked-simple = Ключ был отозван
key-do-you-accept = Принимаете ли вы этот ключ для проверки цифровых подписей и шифрования сообщений?
key-accept-warning = Избегайте принятия мошеннических ключей. Используйте канал связи, отличный от электронной почты, чтобы проверить отпечаток ключа вашего корреспондента.
# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Не удалось отправить сообщение, так как есть проблема с вашим личным ключом. { $problem }
cannot-encrypt-because-missing = Не удалось отправить это сообщение с использованием сквозного шифрования, потому что есть проблемы с ключами следующих получателей: { $problem }
window-locked = Окно составления сообщения заблокировано; отправка отменена
# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Часть зашифрованного сообщения
mime-decrypt-encrypted-part-concealed-data = Это часть зашифрованного сообщения. Вам нужно открыть его в отдельном окне, щёлкнув по вложению.
# Strings in keyserver.jsm
keyserver-error-aborted = Прервано
keyserver-error-unknown = Произошла неизвестная ошибка
keyserver-error-server-error = Сервер ключей сообщил об ошибке.
keyserver-error-import-error = Не удалось импортировать загруженный ключ.
keyserver-error-unavailable = Сервер ключей недоступен.
keyserver-error-security-error = Сервер ключей не поддерживает безопасное соединение.
keyserver-error-certificate-error = Сертификат сервера ключей недействителен.
keyserver-error-unsupported = Сервер ключей не поддерживается.
# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Ваш провайдер электронной почты обработал ваш запрос на выгрузку вашего открытого ключа в каталог веб-ключей OpenPGP.
    Пожалуйста, подтвердите, чтобы завершить публикацию вашего открытого ключа.
wkd-message-body-process =
    Это электронное письмо, связанное с автоматической обработкой для выгрузки вашего открытого ключа в каталог веб-ключей OpenPGP.
    Вам не нужно предпринимать каких-либо ручных действий на этом этапе.
# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Не удалось расшифровать сообщение с темой
    { $subject }.
    Вы хотите повторить попытку с другой парольной фразой или пропустить сообщение?
# Strings in gpg.jsm
unknown-signing-alg = Неизвестный алгоритм подписи (Идентификатор: { $id })
unknown-hash-alg = Неизвестный криптографический хеш (Идентификатор: { $id })
# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Срок действия вашего ключа { $desc } истекает менее, чем через { $days } дней.
    Мы рекомендуем вам создать новую пару ключей и настроить соответствующие учётные записи для её использования.
expiry-keys-expire-soon =
    Срок действия следующих ключей истекает менее, чем через { $days } дней: { $desc }.
    Мы рекомендуем вам создать новые ключи и настроить соответствующие учётные записи для их использования.
expiry-key-missing-owner-trust =
    Ваш секретный ключ { $desc } не обладает доверием.
    Мы рекомендуем вам установить «Вы полагаетесь на сертификации» в вариант «окончательное» в свойствах ключа.
expiry-keys-missing-owner-trust =
    Следующие из ваших секретных ключей не обладают доверием.
    { $desc }.
    Мы рекомендуем вам установить «Вы полагаетесь на сертификации» в вариант «окончательное» в свойствах ключа.
expiry-open-key-manager = Открыть Менеджер ключей OpenPGP
expiry-open-key-properties = Открыть свойства ключа
# Strings filters.jsm
filter-folder-required = Вы должны выбрать целевую папку.
filter-decrypt-move-warn-experimental =
    Предупреждение — действие фильтра «Всегда расшифровывать» может привести к уничтожению сообщений.
    Мы настоятельно рекомендуем сначала попробовать фильтр «Создать расшифрованную копию», тщательно протестировать результат и начать использовать этот фильтр только после того, как вы будете удовлетворены результатом.
filter-term-pgpencrypted-label = Зашифровано OpenPGP
filter-key-required = Вы должны выбрать ключ получателя.
filter-key-not-found = Не удалось найти ключ шифрования для '{ $desc }'.
filter-warn-key-not-secret =
    Предупреждение — действие фильтра «Зашифровывать ключом» заменяет получателей.
    Если у вас нет секретного ключа для '{ $desc }', вы больше не сможете читать электронные письма.
# Strings filtersWrapper.jsm
filter-decrypt-move-label = Всегда расшифровывать (OpenPGP)
filter-decrypt-copy-label = Создать расшифрованную копию (OpenPGP)
filter-encrypt-label = Зашифровывать ключом (OpenPGP)
# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Успешно! Ключи импортированы
import-info-bits = Биты
import-info-created = Создано
import-info-fpr = Отпечаток
import-info-details = Просмотреть подробности и управлять принятием ключа
import-info-no-keys = Ключи не импортированы.
# Strings in enigmailKeyManager.js
import-from-clip = Вы хотите импортировать некоторые ключи из буфера обмена?
import-from-url = Загрузите открытый ключ по этому URL:
copy-to-clipbrd-failed = Не удалось скопировать выделенные ключи в буфер обмена.
copy-to-clipbrd-ok = Ключи скопированы в буфер обмена
delete-secret-key =
    ПРЕДУПРЕЖДЕНИЕ: Вы собираетесь удалить секретный ключ!
    
    Если вы удалите свой секретный ключ, вы больше не сможете расшифровывать любые сообщения, зашифрованные для расшифровки этим ключом, а также не сможете его отозвать.
    
    Вы действительно хотите удалить ОБА ключа, секретный и открытый
    '{ $userId }'?
delete-mix =
    ПРЕДУПРЕЖДЕНИЕ: Вы собираетесь удалить секретные ключи!
    Если вы удалите свой секретный ключ, вы больше не сможете расшифровывать любые сообщения, зашифрованные для расшифровки этим ключом.
    Вы действительно хотите удалить ОБА ключа, секретный и открытый?
delete-pub-key =
    Вы хотите удалить открытый ключ
    '{ $userId }'?
delete-selected-pub-key = Вы хотите удалить открытые ключи?
refresh-all-question = Вы не выбрали ни одного ключа. Хотите обновить ВСЕ ключи?
key-man-button-export-sec-key = Экспорт &секретных ключей
key-man-button-export-pub-key = Экспорт только &открытых ключей
key-man-button-refresh-all = &Обновить все ключи
key-man-loading-keys = Загрузка ключей, пожалуйста, подождите…
ascii-armor-file = Защищённые файлы ASCII (*.asc)
no-key-selected = Вы должны выбрать хотя бы один ключ, чтобы выполнить выбранную операцию
export-to-file = Экспорт открытого ключа в файл
export-keypair-to-file = Экспорт секретного и открытого ключа в файл
export-secret-key = Вы хотите добавить секретный ключ в сохранённый файл ключей OpenPGP?
save-keys-ok = Ключи успешно сохранены
save-keys-failed = Не удалось сохранить ключи
default-pub-key-filename = Экспортированные_открытые_ключи
default-pub-sec-key-filename = Резервная_копия_секретных_ключей
refresh-key-warn = Предупреждение: в зависимости от числа ключей и скорости соединения обновление всех ключей может быть довольно длительным процессом!
preview-failed = Не удалось прочитать файл с открытым ключом.
general-error = Ошибка: { $reason }
dlg-button-delete = &Удалить

## Account settings export output

openpgp-export-public-success = <b>Открытый ключ успешно экспортирован!</b>
openpgp-export-public-fail = <b>Не удалось экспортировать выбранный открытый ключ!</b>
openpgp-export-secret-success = <b>Секретный ключ успешно экспортирован!</b>
openpgp-export-secret-fail = <b>Не удалось экспортировать выбранный секретный ключ!</b>
# Strings in keyObj.jsm
key-ring-pub-key-revoked = Ключ { $userId } (идентификатор ключа { $keyId }) отозван.
key-ring-pub-key-expired = Срок действия ключа { $userId } (идентификатор ключа { $keyId }) истёк.
key-ring-no-secret-key = У вас, судя по всему, нет секретного ключа для { $userId } (идентификатор ключа { $keyId }) в вашем наборе ключей; вы не сможете использовать ключ для подписи.
key-ring-pub-key-not-for-signing = Ключ { $userId } (идентификатор ключа { $keyId }) нельзя использовать для подписи.
key-ring-pub-key-not-for-encryption = Ключ { $userId } (идентификатор ключа { $keyId }) нельзя использовать для шифрования.
key-ring-sign-sub-keys-revoked = Все подключи ключа для подписи { $userId } (идентификатор ключа { $keyId }) отозваны.
key-ring-sign-sub-keys-expired = Срок действия всех подключей ключа для подписи { $userId } (идентификатор ключа { $keyId }) истёк.
key-ring-enc-sub-keys-revoked = Все подключи ключа для шифрования { $userId } (идентификатор ключа { $keyId }) отозваны.
key-ring-enc-sub-keys-expired = Срок действия всех подключей ключа для шифрования { $userId } (идентификатор ключа { $keyId }) истёк.
# Strings in gnupg-keylist.jsm
keyring-photo = Фото
user-att-photo = Атрибут пользователя (изображение JPEG)
# Strings in key.jsm
already-revoked = Этот ключ уже был отозван.
#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Вы собираетесь отозвать ключ '{ $identity }'.
    Вы больше не сможете подписывать сообщения этим ключом, и после распространения сведений об отзыве другие не смогут более шифровать на этот ключ. Вы всё ещё сможете использовать этот ключ для расшифровки старых сообщений.
    Вы хотите продолжить?
#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    У вас нет ключа (0x{ $keyId }), который соответствует этому сертификату отзыва!!
    Если вы потеряли свой ключ, вы должны импортировать его (например, с сервера ключей) перед импортом сертификата отзыва!
#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = Ключ 0x{ $keyId } уже был отозван.
key-man-button-revoke-key = &Отозвать ключ
openpgp-key-revoke-success = Ключ успешно отозван.
after-revoke-info =
    Ключ был отозван.
    Поделитесь этим открытым ключом снова, отправив по электронной почте или выгрузив его на сервера ключей, чтобы сообщить другим, что вы отозвали свой ключ.
    Как только программное обеспечение, используемое другими людьми, узнает об отзыве, оно прекратит использовать ваш старый ключ.
    Если вы используете новый ключ для того же адреса электронной почты и прикрепляете новый открытый ключ к отправляемым сообщениям электронной почты, информация о вашем отозванном старом ключе будет автоматически включена.
# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Импортировать
delete-key-title = Удалить ключ OpenPGP
delete-external-key-title = Удалить внешний ключ GnuPG
delete-external-key-description = Вы хотите удалить этот идентификатор внешнего ключа GnuPG?
key-in-use-title = Ключ OpenPGP сейчас используется
delete-key-in-use-description = Операция не удалась! Выбранный вами ключ удалить нельзя, так как в настоящее время он используется этой учётной записью. Выберите другой ключ или не выбирайте ключей и попробуйте снова.
revoke-key-in-use-description = Операция не удалась! Выбранный вами ключ отозвать нельзя, так как в настоящее время он используется этой учётной записью. Выберите другой ключ или не выбирайте ключей и попробуйте снова.
# Strings used in errorHandling.jsm
key-error-key-spec-not-found = Адрес электронной почты '{ $keySpec }' не может быть сопоставлен с ключом в вашей связке.
key-error-key-id-not-found = Сконфигурированный идентификатор ключа '{ $keySpec }' не найден в вашей связке.
key-error-not-accepted-as-personal = Вы не подтвердили, что ключ с идентификатором '{ $keySpec }' является вашим личным ключом.
# Strings used in enigmailKeyManager.js & windows.jsm
need-online = Выбранная вами функция недоступна в автономном режиме. Пожалуйста, подключитесь к Интернету и попробуйте снова.
# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Мы не смогли найти ключ, соответствующий заданным критериям поиска.
# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Ошибка — Команда извлечения ключа не выполнена
# Strings used in keyRing.jsm
fail-cancel = Ошибка — Получение ключа отменено пользователем
not-first-block = Ошибка — Первый блок OpenPGP не является блоком открытого ключа
import-key-confirm = Импортировать открытые ключи, встроенные в сообщение?
fail-key-import = Ошибка — Не удалось импортировать ключ
file-write-failed = Не удалось записать в файл { $output }
no-pgp-block = Ошибка — Не найден действительный защищённый блок данных OpenPGP
confirm-permissive-import = Импорт не удался. Ключ, который вы пытаетесь импортировать, может быть повреждён или использовать неизвестные атрибуты. Вы хотите попытаться импортировать корректные части? Это может привести к импорту неполных ключей или ключей, которые невозможно использовать.
# Strings used in trust.jsm
key-valid-unknown = неизвестный
key-valid-invalid = недействительный
key-valid-disabled = отключён
key-valid-revoked = отозван
key-valid-expired = просрочен
key-trust-untrusted = нет доверия
key-trust-marginal = граничное
key-trust-full = полное
key-trust-ultimate = окончательное
key-trust-group = (группа)
# Strings used in commonWorkflows.js
import-key-file = Импорт файла ключей OpenPGP
import-rev-file = Импорт файла отзыва OpenPGP
gnupg-file = Файлы GnuPG
import-keys-failed = Не удалось импортировать ключи
passphrase-prompt = Пожалуйста, введите парольную фразу для разблокировки следующего ключа: { $key }
file-to-big-to-import = Этот файл слишком велик. Пожалуйста, не импортируйте большой набор ключей за один раз.
# Strings used in enigmailKeygen.js
save-revoke-cert-as = Создать и сохранить сертификат отзыва
revoke-cert-ok = Сертификат отзыва успешно создан. Вы можете использовать его для аннулирования вашего открытого ключа, например, в случае утери своего секретного ключа.
revoke-cert-failed = Сертификат отзыва не может быть создан.
gen-going = Генерация ключа уже выполняется!
keygen-missing-user-name = Не указано имя для выбранной учётной записи/личности. Введите, пожалуйста значение в поле  «Ваше имя» в параметрах учётной записи.
expiry-too-short = Ваш ключ должен быть действителен по меньшей мере один день.
expiry-too-long = Вы не можете создать ключ, срок действия которого истекает более чем через 100 лет.
key-confirm = Создать открытый и секретный ключ для { $id }?
key-man-button-generate-key = &Сгенерировать ключ
key-abort = Прервать генерацию ключа?
key-man-button-generate-key-abort = &Прервать генерацию ключа
key-man-button-generate-key-continue = &Продолжить генерацию ключа

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = Ошибка — Расшифровка не удалась
fix-broken-exchange-msg-failed = Не удалось восстановить сообщение.
attachment-no-match-from-signature = Не удалось сопоставить файл подписи '{ $attachment }' с вложением
attachment-no-match-to-signature = Не удалось сопоставить вложение '{ $attachment }' с файлом подписи
signature-verified-ok = Подпись для вложения { $attachment } была успешно проверена
signature-verify-failed = Подпись для вложения { $attachment } не может быть проверена
decrypt-ok-no-sig =
    Предупреждение
    Расшифровка прошла успешно, но подпись не была корректно проверена
msg-ovl-button-cont-anyway = &Продолжить в любом случае
enig-content-note = *Вложения этого сообщения не были подписаны или зашифрованы*
# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = &Отправить сообщение
msg-compose-details-button-label = Подробности…
msg-compose-details-button-access-key = н
send-aborted = Операция отправки прервана.
key-not-trusted = Недостаточно доверия к ключу '{ $key }'
key-not-found = Ключ '{ $key }' не найден
key-revoked = Ключ '{ $key }' отозван
key-expired = Срок действия ключа '{ $key }' истёк
msg-compose-internal-error = Произошла внутренняя ошибка.
keys-to-export = Выберите ключи OpenPGP для вставки
msg-compose-partially-encrypted-inlinePGP =
    Сообщение, на которое вы отвечаете, состоит как из незашифрованных, так и из зашифрованных частей. Если отправитель изначально не смог расшифровать некоторые части сообщения, возможно, происходит утечка конфиденциальной информации, которую отправитель не смог первоначально расшифровать сам.
    Пожалуйста, попробуйте удалить весь цитируемый текст из вашего ответа данному отправителю.
msg-compose-cannot-save-draft = Ошибка при сохранении черновика
msg-compose-partially-encrypted-short = Остерегайтесь утечки конфиденциальной информации — частично зашифрованной электронной почты.
quoted-printable-warn =
    Вы включили кодировку «quoted-printable» для отправляемых сообщений. Это может привести к неправильной расшифровке и/или проверке вашего сообщения.
    Вы хотите отключить отправку сообщений в «quoted-printable» сейчас?
minimal-line-wrapping =
    Вы настроили перенос строки после { $width } символов. Для корректного шифрования и/или подписи это значение должно быть не менее 68.
    Вы хотите установить перенос строки после 68 символов сейчас?
sending-hidden-rcpt = Получатели скрытых копий (BCC) не могут использоваться при отправке зашифрованного сообщения. Чтобы отправить это зашифрованное сообщение, либо удалите получателей скрытых копий, либо переместите их в поле копий.
sending-news =
    Операция зашифрованной отправки прервана.
    Это сообщение не может быть зашифровано, потому что есть получатели группы новостей. Пожалуйста, отправьте сообщение повторно без шифрования.
send-to-news-warning =
    Предупреждение: вы собираетесь отправить зашифрованное письмо в группу новостей.
    Это не рекомендуется, потому что это имеет смысл, только если все члены группы смогут дешифровать сообщение, то есть сообщение должно быть зашифровано ключами всех участников группы. Пожалуйста, отправляйте это сообщение, только если вы точно знаете, что делаете.
    Продолжить?
save-attachment-header = Сохранить расшифрованное вложение
no-temp-dir =
    Не удалось найти временную папку для записи
    Пожалуйста, установите переменную среды TEMP
possibly-pgp-mime = Возможно, сообщение зашифровано или подписано PGP/MIME; используйте функцию «Расшифровать/Подтвердить» для проверки
cannot-send-sig-because-no-own-key = Не удалось подписать это сообщение, потому что вы ещё не настроили сквозное шифрования для <{ $key }>
cannot-send-enc-because-no-own-key = Не удалось отправить это сообщение в зашифрованном виде, потому что вы ещё не настроили сквозное шифрования для <{ $key }>
# Strings used in decryption.jsm
do-import-multiple =
    Импортировать следующие ключи?
    { $key }
do-import-one = Импортировать { $name } ({ $id })?
cant-import = Ошибка импорта открытого ключа
unverified-reply = Часть сообщения с отступом (ответ), вероятно, была изменена
key-in-message-body = В теле сообщения был найден ключ. Щёлкните «Импортировать ключ», чтобы импортировать ключ.
sig-mismatch = Ошибка — Несоответствие подписи
invalid-email = Ошибка — Некорректные адреса электронной почты
attachment-pgp-key =
    Открываемое вложение «{ $name }», вероятно, является файлом ключей OpenPGP.
    Щёлкните «Импортировать», чтобы импортировать содержащиеся ключи, или «Просмотр», чтобы просмотреть содержимое файла в окне браузера
dlg-button-view = &Просмотр
# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Расшифрованное сообщение (возможно, восстановлен неправильный формат электронной почты PGP, вызванный старым сервером Exchange, так что результат может быть не идеальным для чтения)
# Strings used in encryption.jsm
not-required = Ошибка — Шифрование не требуется
# Strings used in windows.jsm
no-photo-available = Нет доступного фото
error-photo-path-not-readable = Путь к фотографии '{ $photo }' не читается
debug-log-title = Отладочный лог OpenPGP
# Strings used in dialog.jsm
repeat-prefix = Это предупреждение будет повторяться ещё { $count }
repeat-suffix-singular = раз.
repeat-suffix-plural = раз(а).
no-repeat = Это предупреждение больше не будет отображаться.
dlg-keep-setting = Запомнить мой ответ и не спрашивать меня снова
dlg-button-ok = &ОК
dlg-button-close = &Закрыть
dlg-button-cancel = &Отмена
dlg-no-prompt = Больше не показывать это окно
enig-prompt = Командная строка OpenPGP
enig-confirm = Подтверждение OpenPGP
enig-alert = Предупреждение OpenPGP
enig-info = Информация OpenPGP
# Strings used in persistentCrypto.jsm
dlg-button-retry = &Повторить
dlg-button-skip = Пропуст&ить
# Strings used in enigmailCommon.js
enig-error = Ошибка OpenPGP
# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = Предупреждение OpenPGP
