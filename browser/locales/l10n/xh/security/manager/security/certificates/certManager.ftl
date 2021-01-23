# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Umphathi Wesatifikethi

certmgr-tab-mine =
    .label = Izatifikethi Zakho

certmgr-tab-ca =
    .label = Oogunyaziwe

certmgr-subject-label = Zinikelwa Ku

certmgr-issuer-label = Zinikelwa Ngu

certmgr-period-of-validity = Ithuba Lokusebenza

certmgr-fingerprints = Izishicilelo zeminwe

certmgr-cert-detail-commonname = Igama Eliqhelekileyo (CN)

certmgr-cert-detail-org = Umbutho (O)

certmgr-cert-detail-orgunit = Icandelo Lombutho (OU)

certmgr-cert-detail-serial-number = Inombolo Yolandelelwano

certmgr-cert-detail-sha-256-fingerprint = Ushicilelo lweminwe lwe-SHA-256

certmgr-cert-detail-sha-1-fingerprint = Ushicileleo lweminwe lwe-SHA1

certmgr-edit-ca-cert =
    .title = Hlela Imimiselo yentembeko yesatifikethi se-CA
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Hlela imimiselo yentembeko:

certmgr-edit-cert-trust-email =
    .label = Esi satifikethi sinako ukuchonga abasebenzisi bemeyile.

certmgr-delete-cert =
    .title = Cima Isatifikethi
    .style = width: 48em; height: 24em;

certmgr-cert-name =
    .label = Igama Lesatifikethi

certmgr-token-name =
    .label = Isixhobo Sokhuseleko

certmgr-begins-on = Iqala Ngo

certmgr-begins-label =
    .label = Iqala Ngo

certmgr-expires-on = Iphelelwa Ngeli Xesha

certmgr-expires-label =
    .label = Iphelelwa Ngeli Xesha

certmgr-email =
    .label = Idilesi Yemeyile

certmgr-serial =
    .label = Inombolo Yolandelelwano

certmgr-view =
    .label = Jonga…
    .accesskey = J

certmgr-export =
    .label = Thumela ngaphandle…
    .accesskey = p

certmgr-delete-builtin =
    .label = Cima okanye Ungathembi…
    .accesskey = C

certmgr-backup =
    .label = Eyogcino…
    .accesskey = E

certmgr-backup-all =
    .label = Gcina Iikopi Zako Konke…
    .accesskey = G

certmgr-restore =
    .label = Okuthathwa ngaphandle…
    .accesskey = t

certmgr-details =
    .value = IsatifikethiImimandla
    .accesskey = I

certmgr-fields =
    .value = IfildiIxabiso
    .accesskey = I

certmgr-hierarchy =
    .value = Amabakala Ezatifikethi
    .accesskey = H

certmgr-add-exception =
    .label = Yongeza ieksepshini…
    .accesskey = e

pk11-bad-password = Igama logqithiso elingenisiweyo alichanekanga.
pkcs12-decode-err = Akuphumelelanga ukususa ikhowudi kwifayili.  Mhlawumbi ayikho kulungiselelo lwe-PKCS #12, yonakalisiwe, okanye igama lokugqithisa olingenisileyo belingachanekanga.
pkcs12-unknown-err-restore = Akuphumelelanga ukubuyisela ifayili ye-PKCS #12 ngezizathu ezingaziwayo.
pkcs12-unknown-err-backup = Akuphumelelanga ukuyila ifayili yokugcina ikopi ye-PKCS #12 ngezizathu ezingaziwayo.
pkcs12-unknown-err = Umsebenzi we-PKCS #12 awuphumelelanga ngezizathu ezingaziwayo.
pkcs12-info-no-smartcard-backup = Asiyonto inokwenzeka ukugcina iikopi zezatifikethi ezivela kwisixhobo sokhuselo sikamatshini esifana ne-smart card.
pkcs12-dup-data = Isatifikethi nokubalulekileyo kwabucala sekukhona kwisixhobo sokhuselo.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Igama Lefayili Egcinelwa Ikopi
file-browse-pkcs12-spec = Iifayili ze-PKCS12

## Import certificate(s) file dialog

file-browse-certificate-spec = Iifayili Zesatifikethi
import-ca-certs-prompt = Khetha ifayile equlethe is(z)atifikethi zegunya lezatifikhethi ezisiwa ngaphandle
import-email-cert-prompt = Khetha Ifayili equlethe isatifikethi somntu Semeyile esithathwa ngaphandle

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Isatifikethi i- "{ $certName }" simele Ugunyaziwe Wesatifikethi.

## For Deleting Certificates

delete-user-cert-title =
    .title = Cima Izatifikethi zakho
delete-user-cert-confirm = Uqinisekile ufuna ukucima ezi zatifikethi?
delete-user-cert-impact = Ukuba ucima esinye sezatifikethi ezizezakho, akunakukwazi ukuphinga usisebenzisele ukuzichonga.


delete-ssl-cert-confirm = Uqinisekile ufuna ukucima ezi zikhethekileyo zeseva?

delete-ca-cert-impact = Ukuba ucima okanye akuthembanga igunya (CA), le aplikheyishini ayisayi kuthemba naziphi na izatifikethi ezinikezelwe lelo gunya (CA).


delete-email-cert-title =
    .title = Cima Izatifikethi Zemeyile
delete-email-cert-confirm = Uqinisekile ufuna ukucima izatifikethi zemeyile zaba bantu?
delete-email-cert-impact = Ukuba ucima isatifikethi semeyile, akusayi kuphinda ukwazi ukuthumela imeyile yoguqulelo oluntsonkothileyo kwabo bantu.

## Cert Viewer

not-present =
    .value = <Asiyonxalenye Yesatifikethi>

# Cert verification
cert-verified = Esi satifikethi sinyanisekiselwe ukusetyenziswa kokulandelayo:

# Add usage
verify-ssl-client =
    .value = Isatifikethi se-SSL Somxumi

verify-ssl-server =
    .value = Isatifikethi se-SSL seSeva

verify-ssl-ca =
    .value = Igunya Lesatifikethi se-SSL

verify-email-signer =
    .value = Isatifikethi Somsayini Wemeyile

verify-email-recip =
    .value = Isatifikethi Somamkeli Wemeyile

# Cert verification
cert-not-verified-cert-revoked = Asikwazanga kuqinisekiswa esi satifikethi kuba asikabuyiswa.
cert-not-verified-cert-expired = Asikwazanga kuqinisekiswa esi satifikethi kuba sesiphelelwe lixesha.
cert-not-verified-cert-not-trusted = Asikwazanga kuqinisekiswa esi satifikethi kuba asithenjwa.
cert-not-verified-issuer-not-trusted = Asikwazanga kuqinisekiswa esi satifikethi kuba umnikeli akathenjwa.
cert-not-verified-issuer-unknown = Asikwazanga kuqinisekiswa esi satifikethi kuba umnikeli akaziwa.
cert-not-verified-ca-invalid = Asikwazanga kuqinisekiswa esi satifikethi kuba isatifikethi se-CA asisebenzi.
cert-not-verified-unknown = Asikwazanga kuqinisekiswa esi satifikethi ngenxa yesizathu ezingaziwayo.

## Add Security Exception dialog

add-exception-unverified-or-bad-signature-short = Ubunini Obungaziwayo
add-exception-unverified-or-bad-signature-long = Isatifiketi asithenjwa ngenxa yokuba asikhange siqinisekiswe njengesikhutshwe ligunya elithenjiweyo kusetyenziswa usayino olukhuselekileyo.
add-exception-checking-long = Izama ukufumanisa le sayithi…
add-exception-no-cert-short = Akukho Nkcazelo Ikhoyo

## Certificate export "Save as" and error dialogs

save-cert-as = Gcina Isatifiketi Kwifayili
write-file-failure = Impazamo Yefayile
