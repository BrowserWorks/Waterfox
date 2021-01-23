# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Сертифікат

## Error messages

certificate-viewer-error-message = Нам не вдалося знайти інформацію про сертифікат, або сертифікат пошкоджено. Будь ласка, спробуйте знову.
certificate-viewer-error-title = Щось пішло не так.

## Certificate information labels

certificate-viewer-algorithm = Алгоритм
certificate-viewer-certificate-authority = Центр сертифікації
certificate-viewer-cipher-suite = Набір шифрів
certificate-viewer-common-name = Загальна назва
certificate-viewer-email-address = Адреса е-пошти
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Сертифікат для { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Країна
certificate-viewer-country = Країна
certificate-viewer-curve = Крива
certificate-viewer-distribution-point = Адреса розповсюдження
certificate-viewer-dns-name = Ім’я DNS
certificate-viewer-ip-address = IP-адреса
certificate-viewer-other-name = Інша назва
certificate-viewer-exponent = Експонент
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Група обміну ключами
certificate-viewer-key-id = Ідентифікатор ключа
certificate-viewer-key-size = Розмір ключа
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Місце розташування компанії
certificate-viewer-locality = Місце розташування
certificate-viewer-location = Розташування
certificate-viewer-logid = Ідентифікатор журналу
certificate-viewer-method = Метод
certificate-viewer-modulus = Модуль
certificate-viewer-name = Назва
certificate-viewer-not-after = Не пізніше
certificate-viewer-not-before = Не раніше
certificate-viewer-organization = Організація
certificate-viewer-organizational-unit = Організаційний підрозділ
certificate-viewer-policy = Політика
certificate-viewer-protocol = Протокол
certificate-viewer-public-value = Громадська цінність
certificate-viewer-purposes = Призначення
certificate-viewer-qualifier = Кваліфікатор
certificate-viewer-qualifiers = Кваліфікатори
certificate-viewer-required = Обов'язково
certificate-viewer-unsupported = &lt;не підтримується&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Область/Регіон
certificate-viewer-state-province = Область/Регіон
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Серійний номер
certificate-viewer-signature-algorithm = Алгоритм підпису
certificate-viewer-signature-scheme = Схема підпису
certificate-viewer-timestamp = Мітка часу
certificate-viewer-value = Значення
certificate-viewer-version = Версія
certificate-viewer-business-category = Бізнес-категорія
certificate-viewer-subject-name = Суб'єкт
certificate-viewer-issuer-name = Видавець
certificate-viewer-validity = Термін дії
certificate-viewer-subject-alt-names = Альтернативні імена суб'єктів
certificate-viewer-public-key-info = Інформація про відкритий ключ
certificate-viewer-miscellaneous = Різне
certificate-viewer-fingerprints = Відбитки
certificate-viewer-basic-constraints = Основні обмеження
certificate-viewer-key-usages = Використання ключа
certificate-viewer-extended-key-usages = Розширене використання ключа
certificate-viewer-ocsp-stapling = Прикріплення OCSP
certificate-viewer-subject-key-id = ID ключа суб'єкта
certificate-viewer-authority-key-id = ID ключа центру сертифікації
certificate-viewer-authority-info-aia = Інформація про центри сертифікації (AIA)
certificate-viewer-certificate-policies = Політики сертифіката
certificate-viewer-embedded-scts = Вбудовані SCT
certificate-viewer-crl-endpoints = Точки розподілу списків відгуку (CRL)

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Завантажити
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Так
       *[false] Ні
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (сертифікат)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (ланцюжок сертифікатів)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Це розширення було позначене критичним, тобто клієнти повинні відхилити сертифікат, якщо вони його не розуміють.
certificate-viewer-export = Експорт
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Ваші сертифікати
certificate-viewer-tab-people = Люди
certificate-viewer-tab-servers = Сервери
certificate-viewer-tab-ca = Центри сертифікації
certificate-viewer-tab-unkonwn = Невідомо
