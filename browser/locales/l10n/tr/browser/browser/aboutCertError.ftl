# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } geçersiz bir güvenlik sertifikası kullanıyor.

cert-error-mitm-intro = Web siteleri, kimliklerini kanıtlamak için sertifika makamları tarafından verilen sertifakaları kullanır.

cert-error-mitm-mozilla = Kâr amacı gütmeyen Mozilla tarafından desteklenen { -brand-short-name }, tamamen açık bir sertifika makamı (CA) deposunu yönetmektedir. CA deposu, sertifika makamlarının kullanıcı güvenliğini sağlamak için en iyi uygulamaları izleyip izlemediğini kontrol eder.

cert-error-mitm-connection = { -brand-short-name } bir bağlantının güvenli olup olmadığını doğrulamak için işletim sisteminiz tarafından sağlanan sertifikaları değil, Mozilla CA deposunu kullanır. Dolayısıyla, bir antivirüs programı veya bir ağ, Mozilla CA deposunda bulunmayan bir CA tarafından verilen bir güvenlik sertifikasını kullanarak bağlantınızı dinlerse bağlantı güvensiz kabul edilir.

cert-error-trust-unknown-issuer-intro = Birisi bu siteyi taklit etmeye çalışıyor olabilir. Devam etmemelisiniz.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Web siteleri, kimliklerini kanıtlamak için sertifikaları kullanır. { -brand-short-name } { $hostname } sitesine güvenmiyor çünkü sertifika sağlayıcısı tanınmıyor, sertifika kendi kendine imzalanmış veya sunucu doğru ara sertifikaları göndermiyor.

cert-error-trust-cert-invalid = Sertifikaya güvenilmiyor çünkü geçersiz bir sertifika makamı sertifikası tarafından verilmiş.

cert-error-trust-untrusted-issuer = Yayıncısının sertifikasına güvenilmediği için bu sertifikaya güvenilmiyor.

cert-error-trust-signature-algorithm-disabled = Güvenli olmadığı için devre dışı bırakılmış bir imza algoritması ile imzalandığından, bu sertifikaya güvenilmiyor.

cert-error-trust-expired-issuer = Sertifikaya güvenilmiyor çünkü yayıncı sertifikasının süresi dolmuş.

cert-error-trust-self-signed = Bu sertifika kendi kendine imzalandığı için sertifikaya güvenilmiyor.

cert-error-trust-symantec = GeoTrust, RapidSSL, Symantec, Thawte ve VeriSign tarafından düzenlenen sertifikalar; bu sertifika makamları geçmişte güvenlik prosedürlerini yerine getiremediği için artık güvenli kabul edilmemektedir.

cert-error-untrusted-default = Sertifika güvenilir bir kaynaktan gelmiyor.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Web siteleri, kimliklerini kanıtlamak için sertifikaları kullanır. { $hostname } bu site için geçerli olmayan bir sertifika kullandığından { -brand-short-name } bu siteye güvenmiyor.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Web siteleri, kimliklerini kanıtlamak için sertifikaları kullanır. { $hostname } bu site için geçerli olmayan bir sertifika kullandığından { -brand-short-name } bu siteye güvenmiyor. Sertifika yalnızca <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> için geçerli.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Web siteleri, kimliklerini kanıtlamak için sertifikaları kullanır. { $hostname } bu site için geçerli olmayan bir sertifika kullandığından { -brand-short-name } bu siteye güvenmiyor. Sertifika yalnızca { $alt-name } için geçerli.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Web siteleri, kimliklerini kanıtlamak için sertifikaları kullanır. { $hostname } bu site için geçerli olmayan bir sertifika kullandığından { -brand-short-name } bu siteye güvenmiyor. Sertifika yalnızca şu alan adları için geçerli: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Web siteleri, kimliklerini kanıtlamak için sertifikaları kullanır. Bu sertifikalar belli bir süre boyunca geçerlidir. { $hostname } sertifikasının süresi { $not-after-local-time } tarihinde dolmuş.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Web siteleri, kimliklerini kanıtlamak için sertifikaları kullanır. Bu sertifikalar belli bir süre boyunca geçerlidir. { $hostname } sertifikası { $not-before-local-time } tarihine kadar geçerli olmayacak.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Hata kodu: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Web siteleri, kimliklerini kanıtlamak için sertifika makamlarının düzenlediği sertifikaları kullanır. Çoğu tarayıcı GeoTrust, RapidSSL, Symantec, Thawte ve VeriSign tarafından düzenlenen sertifikalara artık güvenmeme kararı almıştır. { $hostname } bu makamlardan birine ait bir sertifika kullandığı için sitenin kimliğini doğrulayamıyoruz.

cert-error-symantec-distrust-admin = Web sitesinin sahibine bu sorunla ilgili bilgi vermeyi deneyebilirsiniz.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Sertifika zinciri:

open-in-new-window-for-csp-or-xfo-error = Siteyi yeni pencerede aç

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Bu sayfayı başka bir site gömdüyse { $hostname } güvenliğinizi korumak için  { -brand-short-name } tarayıcınızın sayfayı görüntülemesine izin vermez. Bu sayfayı görmek için yeni bir pencerede açmanız gerekir.

## Messages used for certificate error titles

connectionFailure-title = Bağlanılamadı
deniedPortAccess-title = Bu adrese erişim kısıtlanmış
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Aradığınız siteyi bulamıyoruz.
fileNotFound-title = Dosya bulunamadı
fileAccessDenied-title = Dosyaya erişim reddedildi
generic-title = Hata oluştu.
captivePortal-title = Ağa giriş yap
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Bu adres gözümüze düzgün görünmedi.
netInterrupt-title = Bağlantı kesildi
notCached-title = Belge zaman aşımına uğradı
netOffline-title = Çevrimdışı kip
contentEncodingError-title = İçerik kodlama hatası
unsafeContentType-title = Güvensiz dosya türü
netReset-title = Bağlantı sıfırlandı
netTimeout-title = Bağlantı zaman aşımına uğradı
unknownProtocolFound-title = Adres anlaşılamadı
proxyConnectFailure-title = Vekil sunucu bağlantı kabul etmiyor
proxyResolveFailure-title = Vekil sunucu bulunamadı
redirectLoop-title = Sayfa doğru bir şekilde yönlendirilmiyor
unknownSocketType-title = Sunucudan beklenmeyen yanıt
nssFailure2-title = Güvenli bağlantı kurulamadı
csp-xfo-error-title = { -brand-short-name } bu sayfayı açamıyor
corruptedContentError-title = Hasarlı içerik hatası
remoteXUL-title = Uzak XUL
sslv3Used-title = Güvenli bağlantı kurulamadı
inadequateSecurityError-title = Bağlantınız güvenli değil
blockedByPolicy-title = Engellenmiş sayfa
clockSkewError-title = Bilgisayarınızın saati yanlış
networkProtocolError-title = Ağ Protokolü Hatası
nssBadCert-title = Uyarı: Güvenlik riskiyle karşılaşabilirsiniz
nssBadCert-sts-title = Bağlanılmadı: Olası Güvenlik Sorunu
certerror-mitm-title = { -brand-short-name } başka bir yazılım nedeniyle bu siteye güvenli bağlantı kuramıyor
