# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Управление на сертификати

certmgr-tab-mine =
    .label = Вашите сертификати

certmgr-tab-remembered =
    .label = Решения при удостоверяване

certmgr-tab-people =
    .label = Хора

certmgr-tab-servers =
    .label = Сървъри

certmgr-tab-ca =
    .label = Удостоверители

certmgr-mine = Имате сертификати от тези организации, които ви идентифицират
certmgr-remembered = Тези сертификати се използват, за да ви идентифицират пред уеб сайтове
certmgr-people = Имате сертификати, които идентифицират следните хора
certmgr-servers = Имате сертификати, които идентифицират следните сървъри
certmgr-ca = Имате сертификати, които идентифицират следните удостоверители на сертификати

certmgr-detail-general-tab-title =
    .label = Основни
    .accesskey = О

certmgr-detail-pretty-print-tab-title =
    .label = Подробности
    .accesskey = П

certmgr-pending-label =
    .value = Проверяване на сертификат…

certmgr-subject-label = Издаден на

certmgr-issuer-label = Издаден от

certmgr-period-of-validity = Период на валидност

certmgr-fingerprints = Отпечатъци

certmgr-cert-detail =
    .title = Подробности на сертификат
    .buttonlabelaccept = Затваряне
    .buttonaccesskeyaccept = З

certmgr-cert-detail-commonname = Име (CN)

certmgr-cert-detail-org = Организация (О)

certmgr-cert-detail-orgunit = Организационно подразделение (OU)

certmgr-cert-detail-serial-number = Сериен номер

certmgr-cert-detail-sha-256-fingerprint = Отпечатък SHA-256

certmgr-cert-detail-sha-1-fingerprint = Отпечатък SHA1

certmgr-edit-ca-cert =
    .title = Редактиране на настройките за доверие в сертификат на CA
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Редактиране на настройките за доверие:

certmgr-edit-cert-trust-ssl =
    .label = Този сертификат може да идентифицира уеб сайтове.

certmgr-edit-cert-trust-email =
    .label = Този сертификат може да идентифицира пощенски потребители.

certmgr-delete-cert =
    .title = Изтриване на сертификат
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Хост

certmgr-cert-name =
    .label = Име на сертификат

certmgr-cert-server =
    .label = Сървър

certmgr-override-lifetime =
    .label = Време на живот

certmgr-token-name =
    .label = Устройство по безопасността

certmgr-begins-on = Започва на

certmgr-begins-label =
    .label = Започва на

certmgr-expires-on = Изтича на

certmgr-expires-label =
    .label = Изтича на

certmgr-email =
    .label = Е-поща

certmgr-serial =
    .label = Сериен номер

certmgr-view =
    .label = Подробности…
    .accesskey = П

certmgr-edit =
    .label = Редактиране на доверието…
    .accesskey = Р

certmgr-export =
    .label = Изнасяне…
    .accesskey = И

certmgr-delete =
    .label = Изтриване…
    .accesskey = т

certmgr-delete-builtin =
    .label = Изтриване или недоверяване…
    .accesskey = д

certmgr-backup =
    .label = Резервно копие…
    .accesskey = Р

certmgr-backup-all =
    .label = Резервно копие на всичко…
    .accesskey = в

certmgr-restore =
    .label = Внасяне…
    .accesskey = В

certmgr-details =
    .value = Полета на сертификата
    .accesskey = П

certmgr-fields =
    .value = Стойност на полето
    .accesskey = С

certmgr-hierarchy =
    .value = Йерархия на сертификата
    .accesskey = е

certmgr-add-exception =
    .label = Добавяне на изключение…
    .accesskey = к

exception-mgr =
    .title = Добавяне на изключение по безопасността

exception-mgr-extra-button =
    .label = Потвърждаване на изключение по безопасността
    .accesskey = П

exception-mgr-supplemental-warning = Законни банки, магазини и други публични сайтове няма да искат да го правите.

exception-mgr-cert-location-url =
    .value = Адрес:

exception-mgr-cert-location-download =
    .label = Изтегляне на сертификата
    .accesskey = И

exception-mgr-cert-status-view-cert =
    .label = Преглед…
    .accesskey = П

exception-mgr-permanent =
    .label = Запазване като постоянно изключение
    .accesskey = З

pk11-bad-password = Въведената парола е грешна.
pkcs12-decode-err = Неуспешно декодиране на файла. Може би той не е в формат PKCS #12, повреден е или сте въвели грешна парола.
pkcs12-unknown-err-restore = Неуспешно възстановяване на PKCS #12 файла поради неизвестни причини.
pkcs12-unknown-err-backup = Неуспешно създаване на резервен PKCS #12 файл поради неизвестни причини.
pkcs12-unknown-err = PKCS #12 операцията е неуспешна по неизвестни причини.
pkcs12-info-no-smartcard-backup = Невъзможно е резервирането на сертификати от хардуерно сигурно устройство, каквото е смарт-картата.
pkcs12-dup-data = Сертификатът и личният ключ вече съществуват в сигурното устройство.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Име на файл за резервно копие
file-browse-pkcs12-spec = PKCS12 файлове
choose-p12-restore-file-dialog = Сертификатен файл за внасяне

## Import certificate(s) file dialog

file-browse-certificate-spec = Файлове със сертификати
import-ca-certs-prompt = Изберете файл, съдържащ сертификат(и) на CA за внасяне
import-email-cert-prompt = Изберете файл за внасяне, съдържащ нечий сертификат за е-поща

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Сертификатът „{ $certName }“ представя сертификатен удостоверител (CA).

## For Deleting Certificates

delete-user-cert-title =
    .title = Изтриване на вашите сертификати
delete-user-cert-confirm = Сигурни ли сте, че искате да изтриете тези сертификати?
delete-user-cert-impact = Ако изтриете някой от вашите сертификати, няма да може да го използвате, за да се идентифицирате.


delete-ssl-cert-title =
    .title = Изтриване на изключенията за сървърски сертификати
delete-ssl-cert-confirm = Сигурни ли сте, че искате да изтриете тези изключения?
delete-ssl-cert-impact = Ако изтриете изключение за сървър, възстановявате проверките по безопасността за този сървър и изискването за валиден сертификат.

delete-ca-cert-title =
    .title = Изтриване или премахване на доверие от сертификати на CA
delete-ca-cert-confirm = Поискахте да изтриете тези сертификати на CA. При вградените сертификати цялото доверие ще бъде премахнато, което има същият ефект. Сигурни ли сте, че искате да изтриете или премахнете доверието?
delete-ca-cert-impact = Ако изтриете или премахнете доверие от сертификат на сертификатен удостоверител (CA), това приложение повече няма да се доверява на сертификати, издадени от този CA.


delete-email-cert-title =
    .title = Изтриване на сертификати за е-поща
delete-email-cert-confirm = Сигурни ли сте, че искате да изтриете сертификатите за е-поща на тези хора?
delete-email-cert-impact = Ако изтриете сертификат на е-поща на човек, няма да може да изпращате шифрована поща до този човек.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Сертификат със сериен номер: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Преглед на сертификат: „{ $certName }“

not-present =
    .value = <Не е част от сертификат>

# Cert verification
cert-verified = Този сертификат е потвърден за следните цели:

# Add usage
verify-ssl-client =
    .value = Сертификат на SSL клиент

verify-ssl-server =
    .value = Сертификат на SSL сървър

verify-ssl-ca =
    .value = Удостоверител на сертификат за SSL

verify-email-signer =
    .value = Сертификат на подписващия е-поща

verify-email-recip =
    .value = Сертификат на получаващия е-поща

# Cert verification
cert-not-verified-cert-revoked = Сертификатът не е приет, защото е анулиран.
cert-not-verified-cert-expired = Сертификатът не е приет, защото е с изтекъл срок на валидност.
cert-not-verified-cert-not-trusted = Сертификатът не е приет, защото не е доверен.
cert-not-verified-issuer-not-trusted = Сертификатът не е приет, защото издателят не е доверен.
cert-not-verified-issuer-unknown = Сертификатът не е приет, защото издателят е неизвестен.
cert-not-verified-ca-invalid = Сертификатът не е приет, защото сертификатът на неговия CA е невалиден.
cert-not-verified_algorithm-disabled = Сертификатът не може да се провери, защото е подписан с алгоритъм за подписване, който е деактивиран, защото не е безопасен.
cert-not-verified-unknown = Сертификатът не е приет по неизвестни причини.

## Add Security Exception dialog

add-exception-branded-warning = Променяте начина, по който { -brand-short-name } идентифицира този сайт.
add-exception-invalid-header = Сайтът се опита да се представи с невалидна информация.
add-exception-domain-mismatch-short = Сбъркана страница
add-exception-domain-mismatch-long = Сертификатът е за друг сайт, което може да означава, че някой се опитва измамнически да се представя за този сайт.
add-exception-expired-short = Невярна информация
add-exception-expired-long = Сертификатът не е валиден. Може да е бил откраднат или изгубен, и така да се използва измамнически от някой, за да се представя за този сайт.
add-exception-unverified-or-bad-signature-short = Неизвестна идентичност
add-exception-unverified-or-bad-signature-long = Сертификатът не е доверен, защото не е проверен от надежден удостоверител и не използва сигурен подпис.
add-exception-valid-short = Валиден сертификат
add-exception-valid-long = Сайтът има валиден и проверен сертификат. Няма нужда от добавяне на изключение.
add-exception-checking-short = Проверка на информация
add-exception-checking-long = Опит за идентифициране на този сайт…
add-exception-no-cert-short = Няма информация
add-exception-no-cert-long = Не може да се провери идентификацията на този сайт.

## Certificate export "Save as" and error dialogs

save-cert-as = Запазване на сертификат във файл
cert-format-base64 = Сертификат X.509 (PEM)
cert-format-base64-chain = Сертификат X.509 с поредица (PEM)
cert-format-der = Сертификат X.509 (DER)
cert-format-pkcs7 = Сертификат X.509 (PKCS#7)
cert-format-pkcs7-chain = Сертификат X.509 с поредица (PKCS#7)
write-file-failure = Файлова грешка
