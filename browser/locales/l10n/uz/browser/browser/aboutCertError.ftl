# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } yaroqsiz xavfsizlik sertifikatidan foydalanmoqda.

cert-error-mitm-intro = Saytlar haqiqiyligi maxsus sertifikat taqdim etuvchi markazlar tomonidan tadiqlanadi.

cert-error-mitm-mozilla = { -brand-short-name } Mozilla deb nomlangan notijorat tashkilot tomonidan qoʻllab-quvvatlanadi. U oʻzining sertifikat berish markazlari sertifikatlarini saqlovchi ochiq omboriga ega. Bu omborxona sertifikat berish markazlarini foydalanuvchilarning xavfsizligini taʼminlashda yordam beradi.

cert-error-trust-unknown-issuer-intro = Kimdir saytni qalbakilashtirganga oʻxshaydi, shuning uchun davom ettirmaganingiz maʼqul.

cert-error-trust-cert-invalid = Sertifikat ishonchli emas, chunki u yaroqsiz CA sertifikat tomonidan berilgan.

cert-error-trust-untrusted-issuer = Sertifikat ishonchli emas, chunki sertifikatni beruvchi ishonchli emas.

cert-error-trust-signature-algorithm-disabled = Ushbu sertifikat ishonchli emas, chunki  xavfsiz bo‘lmagan algoritmdan foydalanib yozilgan imzo bo‘lganligi uchun o‘chirib qo‘yilgan.

cert-error-trust-expired-issuer = Sertifikat ishonchli emas, chunki sertifikatni beruvchi eskirgan.

cert-error-trust-self-signed = Sertifikat ishonchli emas, chunki uni o‘zi kiritgan.

cert-error-untrusted-default = Sertifikat ishonchli manbadan emas.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Xatolik kodi: <a data-l10n-name="error-code-link">{ $error }</a>

cert-error-symantec-distrust-admin = Sayt administratoriga bu muammo haqida xabar berishingiz mumkin.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP mustahkam transport xavfsizligi: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP ochiq kalitni qistirish: { $hasHPKP }

cert-error-details-cert-chain-label = Sertifikat zanjiri:

## Messages used for certificate error titles

connectionFailure-title = Ulana olmadi
deniedPortAccess-title = Bu manzil cheklangan
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Bu sayt topilmadi.
fileNotFound-title = Fayl topilmadi
fileAccessDenied-title = Fayldan foydalanishga ruxsat berilmadi
generic-title = Obbo.
captivePortal-title = Tarmoqqa kirish
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Manzil xato kiritilganga oʻxshayapti
netInterrupt-title = Aloqa uzilib qoldi
notCached-title = Hujjat mavjud emas
netOffline-title = Oflayn usuli
contentEncodingError-title = Kontentni kodlashda xato
unsafeContentType-title = Xavfli fayl turi
netReset-title = Ulanish uzilib qolgan
netTimeout-title = Ulanish vaqti o‘tib ketdi
unknownProtocolFound-title = Manzil tushunilmadi
proxyConnectFailure-title = Proksi server ulanishlarni rad qilmoqda
proxyResolveFailure-title = Proksi server topilmadi
redirectLoop-title = Sahifa to‘g‘ri yo‘naltirilmagan
unknownSocketType-title = Serverdan kutilmagan javob
nssFailure2-title = Xavfsiz ulanib bo‘lmadi
corruptedContentError-title = Buzilgan kontent xatosi
remoteXUL-title = Masofadagi XUL
sslv3Used-title = Xavfsiz ulanish amalga oshmadi
inadequateSecurityError-title = Ulanish xavfsiz emas
blockedByPolicy-title = Bloklangan sahifa
clockSkewError-title = Kompyuteringiz soati notoʻgʻri
networkProtocolError-title = Tarmoq protokolida xatolik bor
nssBadCert-title = Diqqat: xavfsizlikka tahdid ehtimoli mavjud
nssBadCert-sts-title = Ulanmadi: xavfsizlikka tahdid ehtimoli mavjud
certerror-mitm-title = Dasturiy taʼminot { -brand-short-name }ga bu saytga xavfsiz ulanish uchun ruxsat bermayapti
