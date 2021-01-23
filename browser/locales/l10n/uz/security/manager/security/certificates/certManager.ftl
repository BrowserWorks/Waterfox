# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Sertifikat boshqaruvchisi

certmgr-tab-mine =
    .label = Sertifikatlaringiz

certmgr-tab-people =
    .label = Odamlar

certmgr-tab-servers =
    .label = Serverlar

certmgr-tab-ca =
    .label = Tasdiqdan oʻtkazishlar

certmgr-detail-general-tab-title =
    .label = Umumiy
    .accesskey = U

certmgr-detail-pretty-print-tab-title =
    .label = Tafsilotlar
    .accesskey = T

certmgr-pending-label =
    .value = Hozirda sertifikat tasdiqlanmoqda…

certmgr-subject-label = Ushbuga tegishli:

certmgr-issuer-label = Muallifi:

certmgr-period-of-validity = Yaroqlilik muddati

certmgr-fingerprints = Barmoq izlari

certmgr-cert-detail =
    .title = Sertifikat tafsilotlari
    .buttonlabelaccept = Yopish
    .buttonaccesskeyaccept = Y

certmgr-cert-detail-commonname = Umumiy nom (CN)

certmgr-cert-detail-org = Tashkilot (O)

certmgr-cert-detail-orgunit = Tashkilot qismi (OU)

certmgr-cert-detail-serial-number = Serial raqami

certmgr-cert-detail-sha-256-fingerprint = SHA-256 barmoq izi

certmgr-cert-detail-sha-1-fingerprint = SHA1 barmoq izi

certmgr-edit-ca-cert =
    .title = CA sertifikati ishonch sozlamalarini oʻzgartirish
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Ishonch sozlalamalarini oʻzgartirish:

certmgr-edit-cert-trust-ssl =
    .label = Ushbu sertifikat veb sayt haqida ma’lumotlarni aniqlashtira oladi.

certmgr-edit-cert-trust-email =
    .label = Ushbu sertifikat foydalanuvchilar pochtalari ma’lumotlarini aniqlay oladi.

certmgr-delete-cert =
    .title = Sertifikatni o‘chirish
    .style = width: 48em; height: 24em;

certmgr-cert-name =
    .label = Sertifikat nomi

certmgr-cert-server =
    .label = Server

certmgr-override-lifetime =
    .label = Foydalanish muddati

certmgr-token-name =
    .label = Qurilma xavfsizligi

certmgr-begins-on = Boshlanishi:

certmgr-begins-label =
    .label = Boshlanishi:

certmgr-expires-on = Tugashi:

certmgr-expires-label =
    .label = Tugashi:

certmgr-email =
    .label = E-pochta manzili

certmgr-serial =
    .label = Serial raqami

certmgr-view =
    .label = Ko‘rinishi…
    .accesskey = K

certmgr-edit =
    .label = Ishonchni tasdiqlash…
    .accesskey = E

certmgr-export =
    .label = Eksport qilish…
    .accesskey = E

certmgr-delete =
    .label = O‘chirish…
    .accesskey = O

certmgr-delete-builtin =
    .label = O‘chirish yoki ishonmaslik…
    .accesskey = O

certmgr-backup =
    .label = Zahiralash…
    .accesskey = Z

certmgr-backup-all =
    .label = Barchasini zahiralash…
    .accesskey = z

certmgr-restore =
    .label = Import qilish…
    .accesskey = I

certmgr-details =
    .value = Sertifikat maydonchalari
    .accesskey = m

certmgr-fields =
    .value = Qiymat maydoni
    .accesskey = Q

certmgr-hierarchy =
    .value = Sertifikat iyerarxiyasi
    .accesskey = H

certmgr-add-exception =
    .label = Istisno qoʻshish…
    .accesskey = I

exception-mgr =
    .title = Xavfsizlik istisnosini qo‘shish

exception-mgr-extra-button =
    .label = Xavfsizlik istisnosini tasdiqlash
    .accesskey = C

exception-mgr-supplemental-warning = Qonuniy banklar, do‘konlar va boshqa ommaviy saytlar sizdan buni qilishni so‘ramaydi.

exception-mgr-cert-location-url =
    .value = Manzili:

exception-mgr-cert-location-download =
    .label = Sertifikatni olish
    .accesskey = G

exception-mgr-cert-status-view-cert =
    .label = Ko‘rinishi…
    .accesskey = V

exception-mgr-permanent =
    .label = Ushbu istisnoni butunlay joylashtirish
    .accesskey = b

pk11-bad-password = Kiritilgan parol - xato.
pkcs12-decode-err = Faylni dekodlab bo‘lmadi. Yoki u PKCS #12 formatda emas va buzilgan, yoki kiritlgan parol noto‘g‘ri.
pkcs12-unknown-err-restore = Noma’lum sabablarga ko‘ra PKCS #12 faylni tiklab bo‘lmadi.
pkcs12-unknown-err-backup = Noma’lum sabablarga ko‘ra PKCS #12 zahira faylini yaratib bo‘lmadi.
pkcs12-unknown-err = Noma’lum sabablarga ko‘ra PKCS #12 jarayoni amalga oshmadi.
pkcs12-info-no-smartcard-backup = Kichik karta kabi xavfsizlik uskunasi bor qurilmadan sertifikatlarni zahiralab bo‘lmaydi.
pkcs12-dup-data = Xavfsizlik qurilmasida sertifikat va maxfiy kalit allaqachon mavjud.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Zahiralash uchun fayl nomi
file-browse-pkcs12-spec = PKCS12 fayllar
choose-p12-restore-file-dialog = Import qilish uchun sertifikat fayli

## Import certificate(s) file dialog

file-browse-certificate-spec = Sertifikat fayllari
import-ca-certs-prompt = CA sertifikat(lari)i bo‘lgan faylni import qilish uchun tanlang
import-email-cert-prompt = Biror kishining e-pochtasi sertifikati bo‘lgan faylni import qilish uchun tanlang

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = "{ $certName }" sertifikati tasdiqdan oʻtkazish sertifikatini qayta koʻrsatmoqda.

## For Deleting Certificates

delete-user-cert-title =
    .title = Sertifikatlaringizni o‘chirish
delete-user-cert-confirm = Ushbu sertifikatlarni o‘chirmoqchi ekanligingizga ishonchingiz komilmi?
delete-user-cert-impact = Shaxsiy sertifikatlaringizdan birini o'chirib yuborsangiz, o‘zingizni tasdiqdan o‘tkazishdan foydalana olmay qolasiz.


delete-ssl-cert-title =
    .title = Server sertifikati istisnolarini o‘chirish
delete-ssl-cert-confirm = Ushbu server istisnolarini oʻchirmoqchi ekanligingizga ishonchingiz komilmi?
delete-ssl-cert-impact = Agar server istisnosini oʻchirsangiz, ushbu server uchun odatdagi xavfsizlik tekshiruvlarini ham tiklaysiz va undan foydalanish yaroqli sertifikatni talab qiladi.

delete-ca-cert-title =
    .title = CA sertifikatlarni o‘chirish yoki ishonishni to‘xtatish
delete-ca-cert-confirm = Sizdan ushbu CA sertifikatlarni o‘chirish so‘raldi. Ichki sertifikatlar uchun xuddi shunday effekt bor barcha ishonchlar o‘chiriladi. O‘chirmoqchi ekanligingizga yoki ishonchni olib tashlashni xohlashingizga ishonchingiz komilmi?
delete-ca-cert-impact = Agar siz tasdiqdan o‘tkazish sertifikati (CA)ni o‘chirsangiz yoki ishonchni to‘xtatsangiz, ushbu ilova dastur ushbu CA’ga tegishli har qanday sertifikatlarga ishonmaydi.


delete-email-cert-title =
    .title = E-pochta sertifikatlrini oʻchirish
delete-email-cert-confirm = Ushbu odamlarning e-pochta sertifikatlarini o‘chirmoqchi ekanligingizga ishonchingiz komilmi?
delete-email-cert-impact = Agar shaxsning e-pochta sertifikatini o‘chsangiz, siz ushbu shaxsga kodlangan xatni jo‘nata olmaysiz.

## Cert Viewer

not-present =
    .value = <Sertifikat qismi emas>

# Cert verification
cert-verified = Ushbu sertifikat quyidagi foydalanuvchilar uchun tekshirilgan:

# Add usage
verify-ssl-client =
    .value = SSL mijoz sertifikati

verify-ssl-server =
    .value = SSL server sertifikati

verify-ssl-ca =
    .value = SSL tasdiqdan oʻtkazish sertifikati

verify-email-signer =
    .value = E-pochtaga kirish sertifikati

verify-email-recip =
    .value = E-pochta qabul qilish sertifikati

# Cert verification
cert-not-verified-cert-revoked = Ushbu sertifikat tekshirilmadi, chunki u bekor qilingan.
cert-not-verified-cert-expired = Ushbu sertifikat tekshirilmadi, chunki u eskirgan.
cert-not-verified-cert-not-trusted = Ushbu sertifikat tekshirilmadi, chunki u ishonchli emas.
cert-not-verified-issuer-not-trusted = Ushbu sertifikat tekshirilmadi, chunki sertifikat beruvchisi ishonchli emas.
cert-not-verified-issuer-unknown = Ushbu sertifikat tekshirilmadi, chunki sertifikat beruvchisi noma`lum.
cert-not-verified-ca-invalid = Ushbu sertifikat tekshirilmadi, chunki CA sertifikati - xato.
cert-not-verified_algorithm-disabled = Ushbu sertifikat tekshirilmadi, chunki  xavfsiz boʻlmagan algoritmdan foydalanib yozilgan imzo boʻlganligi uchun oʻchirib qoʻyilgan.
cert-not-verified-unknown = Noma`lum sabablarga koʻra ushbu sertifikat tekshirilmadi.

## Add Security Exception dialog

add-exception-branded-warning = Ushbu saytning { -brand-short-name } tasdiqlarini almashtirish arafasidasiz.
add-exception-invalid-header = Ushbu sayt xato ma’lumot bilan o‘zini tasdiqdan o‘tkazishga urinmoqda.
add-exception-domain-mismatch-short = Xato sayt
add-exception-domain-mismatch-long = Sertifikat biror kishi tomonidan sayt ma’lumotlarini o‘girlashga urinayotgan bo‘lishi mumkin bo‘lgan boshqa saytga tegishli.
add-exception-expired-short = Eskirgan ma’lumot
add-exception-expired-long = Joriy sertifikat yaroqli emas. U o‘girlangan yoki yo‘qolgan va ushbu sayt ma’lumotlari biror kishi o‘g‘irlashga urinilayotgan bo‘lishi mumkin.
add-exception-unverified-or-bad-signature-short = Noma’lum tasdiqdan o‘tkazish
add-exception-unverified-or-bad-signature-long = Sertifikat ishonchli emas, chunki u xavfsizlik imzosidan foydalanadigan ishonchli tasdiqdan o‘tkazish asosida tasdiqlanmagan.S
add-exception-valid-short = To‘g‘ri sertifikat
add-exception-valid-long = Sayt to‘g‘ri va tekshirilgan tasdiqni ko‘rsatmoqda. Istisno qo‘shish shart emas.
add-exception-checking-short = Ma’lumotni tekshirish
add-exception-checking-long = Ushbu sayt tasdiqdan o‘tkazishga urinilmoqda…
add-exception-no-cert-short = Ma’lumot mavjud emas
add-exception-no-cert-long = Ushbu sayt holati tasdig‘ini olib bo‘lmadi.

## Certificate export "Save as" and error dialogs

save-cert-as = Sertifikatni faylga saqlash
cert-format-base64 = X.509 sertifikat (PEM)
cert-format-base64-chain = X.509 zanjirli sertifikat (PEM)
cert-format-der = X.509 sertifikat (DER)
cert-format-pkcs7 = X.509 sertifikat (PKCS#7)
cert-format-pkcs7-chain = X.509 zanjirli sertifikat (PKCS#7)
write-file-failure = Fayl xato
