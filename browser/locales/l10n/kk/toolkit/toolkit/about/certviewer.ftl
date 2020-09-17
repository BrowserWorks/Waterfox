# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Сертификат

## Error messages

certificate-viewer-error-message = Сертификат ақпараты табылмады, немесе сертификат зақымдалған болып тұр. Қайталап көріңіз.
certificate-viewer-error-title = Бірнәрсе қате кетті.

## Certificate information labels

certificate-viewer-algorithm = Алгоритм
certificate-viewer-certificate-authority = Сертификаттау орталығы
certificate-viewer-cipher-suite = Шифрлер отбасы
certificate-viewer-common-name = Жалпы аты
certificate-viewer-email-address = Эл. пошта адресі
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = { $firstCertName } үшін сертификат
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Тіркелу елі
certificate-viewer-country = Ел
certificate-viewer-curve = Қисық сызық
certificate-viewer-distribution-point = Тарату адресі
certificate-viewer-dns-name = DNS аты
certificate-viewer-ip-address = IP адресі
certificate-viewer-other-name = Басқа аты
certificate-viewer-exponent = Экспонента
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Кілттермен алмасу тобы
certificate-viewer-key-id = Кілт идентификаторы
certificate-viewer-key-size = Кілт өлшемі
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Заңды тұлғаның орналасқан жері
certificate-viewer-locality = Орналасуы
certificate-viewer-location = Орналасуы
certificate-viewer-logid = Лог идентификаторы
certificate-viewer-method = Тәсіл
certificate-viewer-modulus = Модуль
certificate-viewer-name = Аты
certificate-viewer-not-after = Кеш емес
certificate-viewer-not-before = Ертерек емес
certificate-viewer-organization = Ұйым
certificate-viewer-organizational-unit = Ұйым бөлімі
certificate-viewer-policy = Саясат
certificate-viewer-protocol = Хаттама
certificate-viewer-public-value = Мәні
certificate-viewer-purposes = Мақсаттары
certificate-viewer-qualifier = Квалификатор
certificate-viewer-qualifiers = Квалификаторлар
certificate-viewer-required = Міндетті
certificate-viewer-unsupported = &lt;қолдауы жоқ&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Тіркелу облысы/өлке/республикасы
certificate-viewer-state-province = Облыс/өлке/республика
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Сериялық нөмірі
certificate-viewer-signature-algorithm = Қолтаңба алгоритмі
certificate-viewer-signature-scheme = Қолтаңба сұлбасы
certificate-viewer-timestamp = Уақыт белгісі
certificate-viewer-value = Мәні
certificate-viewer-version = Нұсқасы
certificate-viewer-business-category = Бизнес санаты
certificate-viewer-subject-name = Субъект аты
certificate-viewer-issuer-name = Шығарушы аты
certificate-viewer-validity = Жарамдылық мерзімі
certificate-viewer-subject-alt-names = Субъекттің балама аттары
certificate-viewer-public-key-info = Ашық кілт ақпараты
certificate-viewer-miscellaneous = Әр түрлі
certificate-viewer-fingerprints = Баспалар
certificate-viewer-basic-constraints = Негізгі шектеулер
certificate-viewer-key-usages = Кілт пайдалануы
certificate-viewer-extended-key-usages = Кеңейтілген кілт пайдалануы
certificate-viewer-ocsp-stapling = OCSP бекітуі
certificate-viewer-subject-key-id = Субъект кілтінің идентификаторы
certificate-viewer-authority-key-id = Сертификаттау орталығы кілтінің идентификаторы
certificate-viewer-authority-info-aia = Сертификаттау орталықтары туралы ақпаратына қатынау
certificate-viewer-certificate-policies = Сертификат саясаттары
certificate-viewer-embedded-scts = Ендірілген SCT
certificate-viewer-crl-endpoints = Қайта шақыру тізімдерін тарату нүктелері (CRL)

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Жүктеп алу
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Иә
       *[false] Жоқ
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (сертификат)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (сертификаттар тізбегі)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Бұл кеңейту өте маңызды деп белгіленді, яғни клиенттер оны түсінбесе, сертификаттан бас тартуы керек.
certificate-viewer-export = Экспорттау
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Сіздің сертификаттарыңыз
certificate-viewer-tab-people = Адамдар
certificate-viewer-tab-servers = Серверлер
certificate-viewer-tab-ca = Сертификаттау орталықтары
certificate-viewer-tab-unkonwn = Белгісіз
