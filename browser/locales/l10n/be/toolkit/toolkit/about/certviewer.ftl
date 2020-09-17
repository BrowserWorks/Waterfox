# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Сертыфікат

## Error messages

certificate-viewer-error-message = Мы не змаглі знайсці інфармацыю пра сертыфікат, альбо сертыфікат пашкоджаны. Калі ласка, паспрабуйце ізноў.
certificate-viewer-error-title = Нешта пайшло не так.

## Certificate information labels

certificate-viewer-algorithm = Алгарытм
certificate-viewer-certificate-authority = Орган сертыфікацыі
certificate-viewer-cipher-suite = Набор шыфраў
certificate-viewer-common-name = Агульная назва
certificate-viewer-email-address = Адрас электроннай пошты
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Сертыфікат для { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Краіна рэгістрацыі
certificate-viewer-country = Краіна
certificate-viewer-curve = Крывая
certificate-viewer-distribution-point = Пункт распаўсюджання
certificate-viewer-dns-name = Назва DNS
certificate-viewer-ip-address = IP-адрас
certificate-viewer-other-name = Іншая назва
certificate-viewer-exponent = Экспанента
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Група абмену ключамі
certificate-viewer-key-id = Ідэнтыфікатар ключа
certificate-viewer-key-size = Памер ключа
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Месцазнаходжанне
certificate-viewer-locality = Месцазнаходжанне
certificate-viewer-location = Размяшчэнне
certificate-viewer-logid = Ідэнтыфікатар журнала
certificate-viewer-method = Метад
certificate-viewer-modulus = Модуль
certificate-viewer-name = Назва
certificate-viewer-not-after = Не пасля
certificate-viewer-not-before = Не раней
certificate-viewer-organization = Арганізацыя
certificate-viewer-organizational-unit = Падраздзяленне
certificate-viewer-policy = Палітыка
certificate-viewer-protocol = Пратакол
certificate-viewer-public-value = Грамадская каштоўнасць
certificate-viewer-purposes = Прызначэнні
certificate-viewer-qualifier = Кваліфікатар
certificate-viewer-qualifiers = Кваліфікатары
certificate-viewer-required = Абавязкова
certificate-viewer-unsupported = &lt;не падтрымліваецца&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Вобласць/Край рэгістрацыі
certificate-viewer-state-province = Вобласць/Рэгіён
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Серыйны нумар
certificate-viewer-signature-algorithm = Алгарытм подпісу
certificate-viewer-signature-scheme = Схема подпісу
certificate-viewer-timestamp = Пазнака часу
certificate-viewer-value = Значэнне
certificate-viewer-version = Версія
certificate-viewer-business-category = Катэгорыя бізнесу
certificate-viewer-subject-name = Суб'ект
certificate-viewer-issuer-name = Выдавец
certificate-viewer-validity = Тэрмін дзеяння
certificate-viewer-subject-alt-names = Альтэрнатыўныя назвы суб'екта
certificate-viewer-public-key-info = Інфармацыя пра адкрыты ключ
certificate-viewer-miscellaneous = Рознае
certificate-viewer-fingerprints = Адбіткі
certificate-viewer-basic-constraints = Асноўныя абмежаванні
certificate-viewer-key-usages = Выкарыстанне ключа
certificate-viewer-extended-key-usages = Пашыранае выкарыстанне ключа
certificate-viewer-ocsp-stapling = Сшыванне OCSP
certificate-viewer-subject-key-id = Ідэнтыфікатар ключа суб'екта
certificate-viewer-authority-key-id = Ідэнтыфікатар ключа органа
certificate-viewer-authority-info-aia = Інфармацыя пра орган (AIA)
certificate-viewer-certificate-policies = Палітыкі сертыфіката
certificate-viewer-embedded-scts = Убудаваныя SCT
certificate-viewer-crl-endpoints = Канцавыя пункты CRL

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Сцягнуць
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Так
       *[false] Не
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (сертыфікат)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (ланцужок)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Гэта пашырэнне пазначана як крытычнае, гэта значыць, што кліенты павінны адхіліць сертыфікат, калі не разумеюць яго.
certificate-viewer-export = Экспарт
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Вашы сертыфікаты
certificate-viewer-tab-people = Асобы
certificate-viewer-tab-servers = Серверы
certificate-viewer-tab-ca = Установы
certificate-viewer-tab-unkonwn = Невядома
