# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Управление сертификатами

certmgr-tab-mine =
    .label = Ваши сертификаты

certmgr-tab-remembered =
    .label = Решения по аутентификации

certmgr-tab-people =
    .label = Люди

certmgr-tab-servers =
    .label = Серверы

certmgr-tab-ca =
    .label = Центры сертификации

certmgr-mine = У вас хранятся сертификаты от следующих организаций, служащие для вашей идентификации
certmgr-remembered = Эти сертификаты используются для идентификации вас на веб-сайтах
certmgr-people = У вас хранятся сертификаты, служащие для идентификации следующих лиц
certmgr-server = В этих записях перечислены исключения для ошибок серверных сертификатов
certmgr-ca = У вас хранятся сертификаты, служащие для идентификации следующих центров сертификации

certmgr-edit-ca-cert2 =
    .title = Изменение степени доверия сертификату CA
    .style = min-width: 48em;

certmgr-edit-cert-edit-trust = Изменить степень доверия:

certmgr-edit-cert-trust-ssl =
    .label = Этот сертификат может служить для идентификации веб-сайтов.

certmgr-edit-cert-trust-email =
    .label = Этот сертификат может служить для идентификации пользователей электронной почты.

certmgr-delete-cert2 =
    .title = Удаление сертификата
    .style = min-width: 48em; min-height: 24em;

certmgr-cert-host =
    .label = Узел

certmgr-cert-name =
    .label = Имя сертификата

certmgr-cert-server =
    .label = Сервер

certmgr-token-name =
    .label = Устройство защиты

certmgr-begins-label =
    .label = Действителен с

certmgr-expires-label =
    .label = Действителен по

certmgr-email =
    .label = Адрес электронной почты

certmgr-serial =
    .label = Серийный номер

certmgr-fingerprint-sha-256 =
    .label = Отпечаток SHA-256

certmgr-view =
    .label = Просмотреть…
    .accesskey = о

certmgr-edit =
    .label = Изменить доверие…
    .accesskey = е

certmgr-export =
    .label = Экспортировать…
    .accesskey = п

certmgr-delete =
    .label = Удалить…
    .accesskey = д

certmgr-delete-builtin =
    .label = Удалить или не доверять…
    .accesskey = л

certmgr-backup =
    .label = Сохранить копию…
    .accesskey = х

certmgr-backup-all =
    .label = Сохранить все…
    .accesskey = в

certmgr-restore =
    .label = Импортировать…
    .accesskey = м

certmgr-add-exception =
    .label = Добавить исключение…
    .accesskey = ю

exception-mgr =
    .title = Добавить исключение безопасности

exception-mgr-extra-button =
    .label = Подтвердить исключение безопасности
    .accesskey = т

exception-mgr-supplemental-warning = Серьёзные банки, магазины и другие публичные сайты не будут просить вас делать это.

exception-mgr-cert-location-url =
    .value = Адрес:

exception-mgr-cert-location-download =
    .label = Получить сертификат
    .accesskey = е

exception-mgr-cert-status-view-cert =
    .label = Просмотреть…
    .accesskey = с

exception-mgr-permanent =
    .label = Постоянно хранить это исключение
    .accesskey = т

pk11-bad-password = Введённый пароль неверен.
pkcs12-decode-err = Ошибка расшифровки файла. Или это не файл PKCS#12, или файл повреждён, или введённый вами пароль неверен.
pkcs12-unknown-err-restore = Не удалось восстановить файл PKCS#12 по неизвестным причинам.
pkcs12-unknown-err-backup = Не удалось создать резервную копию файла PKCS#12 по неизвестным причинам.
pkcs12-unknown-err = Операция PKCS #12 завершилась неудачей по неизвестным причинам.
pkcs12-info-no-smartcard-backup = Не удалось создать резервную копию сертификатов, находящихся в аппаратном устройстве защиты, таком как смарт-карта.
pkcs12-dup-data = Сертификат и закрытый ключ уже существуют в устройстве защиты.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Имя файла резервной копии
file-browse-pkcs12-spec = Файлы PKCS12
choose-p12-restore-file-dialog = Импортируемый файл сертификата

## Import certificate(s) file dialog

file-browse-certificate-spec = Файлы сертификатов
import-ca-certs-prompt = Выберите для импорта файл, содержащий сертификат центра
import-email-cert-prompt = Выберите для импорта файл, содержащий сертификат электронной почты

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Сертификат «{ $certName }» представляет центр сертификации.

## For Deleting Certificates

delete-user-cert-title =
    .title = Удаление собственных сертификатов
delete-user-cert-confirm = Вы уверены, что хотите удалить эти сертификаты?
delete-user-cert-impact = После удаления одного из собственных сертификатов, вы больше не сможете использовать его для своей идентификации.


delete-ssl-override-title =
    .title = Удаление исключения для сертификата сервера
delete-ssl-override-confirm = Вы уверены, что хотите удалить исключение для данного сервера?
delete-ssl-override-impact = Если вы удалите исключение для сервера, вы восстановите для данного сервера обычную процедуру проверки безопасности и потребуете от него использования действительного сертификата.

delete-ca-cert-title =
    .title = Удаление или объявление недоверия сертификатам центров сертификации
delete-ca-cert-confirm = Вы хотите удалить эти сертификаты центра сертификации. Если в списке этих сертификатов имеются встроенные сертификаты, то они будут объявлены недоверенными, что имеет тот же эффект. Вы уверены, что хотите удалить их или объявить их недоверенными?
delete-ca-cert-impact = Если вы удалите или объявите недоверенным сертификат центра сертификации, это приложение больше не будет доверять ни одному из сертификатов, выданных этим центром сертификации.


delete-email-cert-title =
    .title = Удаление сертификатов электронной почты
delete-email-cert-confirm = Вы уверены, что хотите удалить сертификаты электронной почты этих пользователей?
delete-email-cert-impact = Если вы удалите сертификат электронной почты данного пользователя, то больше не сможете отправлять ему почтовые сообщения в зашифрованном виде.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Сертификат с серийным номером: { $serialNumber }

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Не отправлять сертификат клиента

# Used when no cert is stored for an override
no-cert-stored-for-override = (не сохранён)

# When a certificate is unavailable (for example, it has been deleted or the token it exists on has been removed).
certificate-not-available = (Недоступен)

## Used to show whether an override is temporary or permanent

permanent-override = Постоянно
temporary-override = Временно

## Add Security Exception dialog

add-exception-branded-warning = Вы собираетесь принудительно изменить идентификацию сайта в { -brand-short-name }.
add-exception-invalid-header = Этот сайт пытается идентифицировать себя, используя некорректную информацию.
add-exception-domain-mismatch-short = Неверный сайт
add-exception-domain-mismatch-long = Сертификат принадлежит другому сайту, что может значить, что кто-то пытается подменить этот сайт другим.
add-exception-expired-short = Устаревшая информация
add-exception-expired-long = Сертификат в данное время недействителен. Он мог быть украден или потерян, и мог быть использовать кем-то, чтобы подменить этот сайт другим.
add-exception-unverified-or-bad-signature-short = Неизвестный центр сертификации
add-exception-unverified-or-bad-signature-long = К сертификату нет доверия, так как он не был верифицирован в качестве изданного доверенным центром сертификации с использованием безопасной подписи.
add-exception-valid-short = Действительный сертификат
add-exception-valid-long = Идентификация этого сайта действительна и проверена. Нет необходимости добавлять исключение.
add-exception-checking-short = Идёт проверка информации
add-exception-checking-long = Попытка идентификации этого сайта…
add-exception-no-cert-short = Нет доступной информации
add-exception-no-cert-long = Не удалось получить информацию о подлинном статусе этого сайта.

## Certificate export "Save as" and error dialogs

save-cert-as = Сохранить сертификат в файл
cert-format-base64 = Сертификат X.509 в формате PEM
cert-format-base64-chain = Цепочка сертификатов X.509 в формате PEM
cert-format-der = Сертификат X.509 в формате DER
cert-format-pkcs7 = Сертификат X.509 в формате PKCS#7
cert-format-pkcs7-chain = Цепочка сертификатов X.509 в формате PKCS#7
write-file-failure = Ошибка файла
