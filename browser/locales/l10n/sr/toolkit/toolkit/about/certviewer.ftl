# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Сертификат

## Error messages

certificate-viewer-error-message = Нисмо успели да пронађемо информације о сертификату или је сертификат оштећен. Покушајте поново.
certificate-viewer-error-title = Нешто је пошло наопако.

## Certificate information labels

certificate-viewer-algorithm = Алгоритам
certificate-viewer-certificate-authority = Сертификационо тело
certificate-viewer-cipher-suite = Cipher Suite
certificate-viewer-common-name = Уобичајено име
certificate-viewer-email-address = Адреса е-поште
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Сертификат за { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Држава оснивања
certificate-viewer-country = Држава
certificate-viewer-curve = Крива
certificate-viewer-distribution-point = Тачка расподеле
certificate-viewer-dns-name = DNS име
certificate-viewer-ip-address = IP адреса
certificate-viewer-other-name = Друго име
certificate-viewer-exponent = Експонент
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Група размене кључева
certificate-viewer-key-id = ID кључа
certificate-viewer-key-size = Величина кључа
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Место оснивања
certificate-viewer-locality = Место
certificate-viewer-location = Локација
certificate-viewer-logid = ID дневника
certificate-viewer-method = Метода
certificate-viewer-modulus = Модул
certificate-viewer-name = Име
certificate-viewer-not-after = Не после
certificate-viewer-not-before = Не пре
certificate-viewer-organization = Организација
certificate-viewer-organizational-unit = Организациона јединица
certificate-viewer-policy = Политика
certificate-viewer-protocol = Протокол
certificate-viewer-public-value = Јавна вредност
certificate-viewer-purposes = Сврхе
certificate-viewer-qualifier = Квалификатор
certificate-viewer-qualifiers = Квалификатори
certificate-viewer-required = Обавезно
certificate-viewer-unsupported = &lt;неподржано&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Држава/покрајина оснивања
certificate-viewer-state-province = Држава/покрајина
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Серијски број
certificate-viewer-signature-algorithm = Алгоритам потписа
certificate-viewer-signature-scheme = Шема потписа
certificate-viewer-timestamp = Временска ознака
certificate-viewer-value = Вредност
certificate-viewer-version = Верзија
certificate-viewer-business-category = Категорија пословања
certificate-viewer-subject-name = Име предмета
certificate-viewer-issuer-name = Име издавача
certificate-viewer-validity = Ваљаност
certificate-viewer-subject-alt-names = Алтернативна имена предмета
certificate-viewer-public-key-info = Информације о јавном кључу
certificate-viewer-miscellaneous = Разно
certificate-viewer-fingerprints = Отисци прстију
certificate-viewer-basic-constraints = Основна ограничења
certificate-viewer-key-usages = Употребе кључа
certificate-viewer-extended-key-usages = Проширене употребе кључа
certificate-viewer-ocsp-stapling = OCSP потврђивање
certificate-viewer-subject-key-id = ID кључа предмета
certificate-viewer-authority-key-id = ID кључа сертификационог тела
certificate-viewer-authority-info-aia = Подаци сертификационог тела (AIA)
certificate-viewer-certificate-policies = Сертификационе политике
certificate-viewer-embedded-scts = Уграђени SCTs
certificate-viewer-crl-endpoints = Крајње тачке CRL-а

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Преузми
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Да
       *[false] Не
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (сертификат)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (ланац)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Ово проширење је означено као критично, што значи да би купци требало да одбаце сертификат ако га не разумеју.
certificate-viewer-export = Извоз
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Ваши сертификати
certificate-viewer-tab-people = Људи
certificate-viewer-tab-servers = Сервери
certificate-viewer-tab-ca = Тела
certificate-viewer-tab-unkonwn = Непознато
