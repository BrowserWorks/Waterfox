# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Сертификат

## Error messages

certificate-viewer-error-message = Нам не удалось найти информацию о сертификате, или сертификат повреждён. Пожалуйста, попробуйте ещё раз.
certificate-viewer-error-title = Что-то пошло не так.

## Certificate information labels

certificate-viewer-algorithm = Алгоритм
certificate-viewer-certificate-authority = Центр сертификации
certificate-viewer-cipher-suite = Набор шифров
certificate-viewer-common-name = Общее имя
certificate-viewer-email-address = Адрес электронной почты
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Сертификат для { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Страна юридического лица
certificate-viewer-country = Страна
certificate-viewer-curve = Кривая
certificate-viewer-distribution-point = Адрес распространения
certificate-viewer-dns-name = DNS-имя
certificate-viewer-ip-address = IP-адрес
certificate-viewer-other-name = Другое имя
certificate-viewer-exponent = Экспонента
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Группа обмена ключами
certificate-viewer-key-id = Идентификатор ключа
certificate-viewer-key-size = Размер ключа
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Населённый пункт юридического лица
certificate-viewer-locality = Населённый пункт
certificate-viewer-location = Расположение
certificate-viewer-logid = ID лога
certificate-viewer-method = Метод
certificate-viewer-modulus = Модуль
certificate-viewer-name = Имя
certificate-viewer-not-after = Действителен по
certificate-viewer-not-before = Действителен с
certificate-viewer-organization = Организация
certificate-viewer-organizational-unit = Подразделение
certificate-viewer-policy = Политика
certificate-viewer-protocol = Протокол
certificate-viewer-public-value = Значение
certificate-viewer-purposes = Назначения
certificate-viewer-qualifier = Квалификатор
certificate-viewer-qualifiers = Квалификаторы
certificate-viewer-required = Обязательно
certificate-viewer-unsupported = &lt;неподдерживается&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Область/Регион юридического лица
certificate-viewer-state-province = Область/Регион
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Серийный номер
certificate-viewer-signature-algorithm = Алгоритм подписи
certificate-viewer-signature-scheme = Схема подписи
certificate-viewer-timestamp = Метка времени
certificate-viewer-value = Значение
certificate-viewer-version = Версия
certificate-viewer-business-category = Категория бизнеса
certificate-viewer-subject-name = Субъект
certificate-viewer-issuer-name = Издатель
certificate-viewer-validity = Срок действия
certificate-viewer-subject-alt-names = Дополнительное имя субъекта
certificate-viewer-public-key-info = Информация об открытом ключе
certificate-viewer-miscellaneous = Разное
certificate-viewer-fingerprints = Отпечатки
certificate-viewer-basic-constraints = Основные ограничения
certificate-viewer-key-usages = Использование ключа
certificate-viewer-extended-key-usages = Улучшенный ключ
certificate-viewer-ocsp-stapling = Прикрепление OCSP
certificate-viewer-subject-key-id = Идентификатор ключа субъекта
certificate-viewer-authority-key-id = Идентификатор ключа центра сертификатов
certificate-viewer-authority-info-aia = Доступ к информации о центрах сертификации
certificate-viewer-certificate-policies = Политики сертификата
certificate-viewer-embedded-scts = Список SCT
certificate-viewer-crl-endpoints = Точки распределения списков отзыва (CRL)

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Загрузить
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Да
       *[false] Нет
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (сертификат)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (цепочка сертификатов)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Это расширение помечено как критическое, что означает, что клиенты должны отклонить сертификат, если они его не понимают.
certificate-viewer-export = Экспортировать
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (неизвестно)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Ваши сертификаты
certificate-viewer-tab-people = Люди
certificate-viewer-tab-servers = Серверы
certificate-viewer-tab-ca = Центры сертификации
certificate-viewer-tab-unkonwn = Неизвестно
