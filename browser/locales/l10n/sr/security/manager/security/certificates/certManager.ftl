# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Менаџер сертификата

certmgr-tab-mine =
    .label = Ваши сертификати

certmgr-tab-remembered =
    .label = Одлуке о аутентификацији

certmgr-tab-people =
    .label = Људи

certmgr-tab-servers =
    .label = Сервери

certmgr-tab-ca =
    .label = Ауторитети

certmgr-mine = Имате сертификате ових организација које вас идентификују
certmgr-remembered = Ови сертификати се користе за вашу идентификацију на веб страницама.
certmgr-people = Имате сертификате датотеке која идентификује ове људе
certmgr-servers = Имате сертификате датотеке која идентификује ове сервере
certmgr-ca = Имате сертификате датотеке која идентификује ова сертификациона тела

certmgr-detail-general-tab-title =
    .label = Основне поставке
    .accesskey = О

certmgr-detail-pretty-print-tab-title =
    .label = Детаљи
    .accesskey = Д

certmgr-pending-label =
    .value = Провера сертификата је у току…

certmgr-subject-label = Издато за

certmgr-issuer-label = Издато од

certmgr-period-of-validity = Период важења

certmgr-fingerprints = Отисак кључа

certmgr-cert-detail =
    .title = Детаљи сертификата
    .buttonlabelaccept = Затвори
    .buttonaccesskeyaccept = З

certmgr-cert-detail-commonname = Општи назив (CN)

certmgr-cert-detail-org = Организација (O)

certmgr-cert-detail-orgunit = Организациона јединица (OU)

certmgr-cert-detail-serial-number = Серијски број

certmgr-cert-detail-sha-256-fingerprint = SHA-256 отисак кључа

certmgr-cert-detail-sha-1-fingerprint = SHA1 отисак кључа

certmgr-edit-ca-cert =
    .title = Измени поставке поверења сертификационог тела
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Измени поставке поверења:

certmgr-edit-cert-trust-ssl =
    .label = Овај сертификат може да идентификује веб сајтове.

certmgr-edit-cert-trust-email =
    .label = Овај сертификат може да идентификује кориснике е-поште.

certmgr-delete-cert =
    .title = Избриши сертификат
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Хост

certmgr-cert-name =
    .label = Назив сертификата

certmgr-cert-server =
    .label = Сервер

certmgr-override-lifetime =
    .label = Животни век

certmgr-token-name =
    .label = Безбедносни уређај

certmgr-begins-on = Важи од

certmgr-begins-label =
    .label = Важи од

certmgr-expires-on = Истиче

certmgr-expires-label =
    .label = Истиче

certmgr-email =
    .label = Адреса е-поште

certmgr-serial =
    .label = Серијски број

certmgr-view =
    .label = Преглед…
    .accesskey = П

certmgr-edit =
    .label = Уреди поверење…
    .accesskey = р

certmgr-export =
    .label = Извоз…
    .accesskey = И

certmgr-delete =
    .label = Уклони…
    .accesskey = к

certmgr-delete-builtin =
    .label = Уклони или укини поверење…
    .accesskey = в

certmgr-backup =
    .label = Архивирај…
    .accesskey = А

certmgr-backup-all =
    .label = Архивирај све…
    .accesskey = с

certmgr-restore =
    .label = Увоз…
    .accesskey = У

certmgr-details =
    .value = Поља сертификата
    .accesskey = П

certmgr-fields =
    .value = Вредност поља
    .accesskey = В

certmgr-hierarchy =
    .value = Хијерархија сертификата
    .accesskey = Х

certmgr-add-exception =
    .label = Додај изузетак…
    .accesskey = т

exception-mgr =
    .title = Додавање безбедносног изузетка

exception-mgr-extra-button =
    .label = Потврди безбедносни изузетак
    .accesskey = П

exception-mgr-supplemental-warning = Легитимне банке, продавнице и други јавни сајтови неће тражити да ово радите.

exception-mgr-cert-location-url =
    .value = Адреса:

exception-mgr-cert-location-download =
    .label = Добави сертификат
    .accesskey = В

exception-mgr-cert-status-view-cert =
    .label = Преглед…
    .accesskey = е

exception-mgr-permanent =
    .label = Трајно сачувај овај изузетак
    .accesskey = Т

pk11-bad-password = Унешена лозинка није исправна.
pkcs12-decode-err = Грешка при дешифровању датотеке. Можда то није датотека PKCS#12 , датотека није у реду или унешена лозинка није исправна.
pkcs12-unknown-err-restore = Немогуће је обновити датотеку PKCS #12 из непознатог разлога.
pkcs12-unknown-err-backup = Непозната грешка резервног копирања датотеке PKCS #12.
pkcs12-unknown-err = Операција PKCS #12 је неуспешно завршена из непознатог разлога.
pkcs12-info-no-smartcard-backup = Немогуће је обновити сертификат са механизма заштите као што је смарт-картица.
pkcs12-dup-data = Сертификат и затворени кључ већ постоји у механизму заштите.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Име датотеке за резервну копију
file-browse-pkcs12-spec = PKCS12 датотеке
choose-p12-restore-file-dialog = Датотека потврде за увоз

## Import certificate(s) file dialog

file-browse-certificate-spec = Датотеке сертификата
import-ca-certs-prompt = Изабери датотеку који садржи сертификате за увоз
import-email-cert-prompt = Изаберите датотеку која садржи нечији сертификат е-поште за увоз

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Сертификат "{ $certName }" представља сертификационо тело.

## For Deleting Certificates

delete-user-cert-title =
    .title = Брисање сертификата
delete-user-cert-confirm = Да ли сигурно желите да уклоните ове сертификате?
delete-user-cert-impact = Ако избришете један од сертификата, нећете бити у могућности да се представите.


delete-ssl-cert-title =
    .title = Уклони изузетак о серверском сертификату
delete-ssl-cert-confirm = Да ли сигурно желите да уклоните ове серверске изузетке?
delete-ssl-cert-impact = Ако уклоните серверски изузетак, враћате уобичајену проверу безбедности за сервер и захтевате да поседује важећи сертификат.

delete-ca-cert-title =
    .title = Избриши или укини поверење сертификационом телу
delete-ca-cert-confirm = Захтевали сте да се избришу ови сертификати. За уграђене сертификате, све дозволе и поверења ће бити уклоњени, што има исти ефекат. Желите ли да их избришете или укинете поверења?
delete-ca-cert-impact = Ако избришете или укинете сертификат сертификационог тела (CA), ова апликација неће више веровати ни једном сертификату који је тај издавач издао.


delete-email-cert-title =
    .title = Избришите сертификат е-поште
delete-email-cert-confirm = Да ли сте сигурни да желите да избришете сертификате е-поште за следеће кориснике?
delete-email-cert-impact = Ако уклоните сертификат за е-пошту неке особе, више нећете моћи да јој шаљете е-пошту.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Сертификат са серијским бројем: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Прегледач сертификата: “{ $certName }”

not-present =
    .value = <Није део сертификата>

# Cert verification
cert-verified = Сертификат је потврђен за следеће кориснике:

# Add usage
verify-ssl-client =
    .value = SSL сертификат клијента

verify-ssl-server =
    .value = SSL сертификат сервера

verify-ssl-ca =
    .value = SSL сертификационо тело

verify-email-signer =
    .value = Сертификат потписника е-поште

verify-email-recip =
    .value = Сертификат примаоца е-поште

# Cert verification
cert-not-verified-cert-revoked = Провера сертификата није могућа зато што је отказана.
cert-not-verified-cert-expired = Провера сертификата није могућа зато што је рок трајања истекао.
cert-not-verified-cert-not-trusted = Провера сертификата није могућа зато што је небезбедна.
cert-not-verified-issuer-not-trusted = Провера сертификата није могућа зато што је страна која га је издала небезбедна.
cert-not-verified-issuer-unknown = Провера сертификата није могућа зато што је страна која га је издала непозната.
cert-not-verified-ca-invalid = Провера сертификата није могућа зато што је сертификационо тело непостојеће.
cert-not-verified_algorithm-disabled = Провера сертификата није могућа зато што је алгоритам који служи за учитавање небезбедан.
cert-not-verified-unknown = Провера сертификата није могућа.

## Add Security Exception dialog

add-exception-branded-warning = Само што нисте преиначили механизам за идентификацију сајта за програм { -brand-short-name }.
add-exception-invalid-header = Сајт покушава да се представи помоћу неважећих информација.
add-exception-domain-mismatch-short = Погрешан сајт
add-exception-domain-mismatch-long = Сертификат припада другом сајту, то може да указује на покушај имитирања сајта.
add-exception-expired-short = Застарели подаци
add-exception-expired-long = Сертификат је тренутно неважећи. Могуће да је украден или изгубљен и неко може да имитира овај сајт.
add-exception-unverified-or-bad-signature-short = Непознат идентитет
add-exception-unverified-or-bad-signature-long = Сертификату се не може веровати, зато што још није верификован од стране сертификационог тела.
add-exception-valid-short = Важећи сертификат
add-exception-valid-long = Сајт је дао важећи, проверени сертификат.  Нема потребе да додајете изузетак.
add-exception-checking-short = Провера података
add-exception-checking-long = Покушај да се идентификује сајт…
add-exception-no-cert-short = Нема доступних података
add-exception-no-cert-long = Није могуће добавити статус о идентитету наведеног сајта.

## Certificate export "Save as" and error dialogs

save-cert-as = Чување сертификата у датотеци
cert-format-base64 = Сертификат X.509 (PEM)
cert-format-base64-chain = Сертификат X.509 са ланцем (PEM)
cert-format-der = Сертификат X.509 (DER)
cert-format-pkcs7 = Сертификат X.509 (PKCS#7)
cert-format-pkcs7-chain = Сертификат X.509 са ланцем (PKCS#7)
write-file-failure = Грешка у датотеци
