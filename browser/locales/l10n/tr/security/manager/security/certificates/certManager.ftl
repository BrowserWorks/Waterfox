# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Sertifika Yöneticisi
certmgr-tab-mine =
    .label = Sertifikalarınız
certmgr-tab-remembered =
    .label = Kimlik doğrulama kararları
certmgr-tab-people =
    .label = Kişiler
certmgr-tab-servers =
    .label = Sunucular
certmgr-tab-ca =
    .label = Makamlar
certmgr-mine = Sizi tanımlayan aşağıdaki kuruluşlardan sertifikalarınız var
certmgr-remembered = Bu sertifikalar sizi web sitelerine tanıtmak için kullanılır
certmgr-people = Aşağıdaki kişileri tanımlayan kayıtlı sertifikalarınız var
certmgr-servers = Aşağıdaki sunucuları tanımlayan kayıtlı sertifikalarınız var
certmgr-ca = Aşağıdaki sertifika makamlarını tanımlayan kayıtlı sertifikalarınız var
certmgr-detail-general-tab-title =
    .label = Genel
    .accesskey = G
certmgr-detail-pretty-print-tab-title =
    .label = Ayrıntılar
    .accesskey = A
certmgr-pending-label =
    .value = Sertifika şu anda doğrulanıyor…
certmgr-subject-label = Verilen
certmgr-issuer-label = Yayıncı
certmgr-period-of-validity = Geçerlilik dönemi
certmgr-fingerprints = Parmak izleri
certmgr-cert-detail =
    .title = Sertifika ayrıntısı
    .buttonlabelaccept = Kapat
    .buttonaccesskeyaccept = K
certmgr-cert-detail-commonname = Genel isim (CN)
certmgr-cert-detail-org = Kurum (O)
certmgr-cert-detail-orgunit = Kurumsal birim (OU)
certmgr-cert-detail-serial-number = Seri numarası
certmgr-cert-detail-sha-256-fingerprint = SHA-256 parmak izi
certmgr-cert-detail-sha-1-fingerprint = SHA1 parmak izi
certmgr-edit-ca-cert =
    .title = CA sertifikası güven ayarlarını düzenle
    .style = width: 48em;
certmgr-edit-cert-edit-trust = Güven ayarlarını düzenle:
certmgr-edit-cert-trust-ssl =
    .label = Bu sertifika, web sitelerini tanımlayabilir.
certmgr-edit-cert-trust-email =
    .label = Bu sertifika posta kullanıcılarını tanımlayabilir.
certmgr-delete-cert =
    .title = Sertifikayı sil
    .style = width: 48em; height: 24em;
certmgr-cert-host =
    .label = Ana makine
certmgr-cert-name =
    .label = Sertifika adı
certmgr-cert-server =
    .label = Sunucu
certmgr-override-lifetime =
    .label = Yaşam süresi
certmgr-token-name =
    .label = Güvenlik aygıtı
certmgr-begins-on = Başlangıç tarihi
certmgr-begins-label =
    .label = Başlangıç tarihi
certmgr-expires-on = Bitiş tarihi
certmgr-expires-label =
    .label = Bitiş tarihi
certmgr-email =
    .label = E-posta adresi
certmgr-serial =
    .label = Seri numarası
certmgr-view =
    .label = Görüntüle…
    .accesskey = G
certmgr-edit =
    .label = Güven ayarları…
    .accesskey = n
certmgr-export =
    .label = Dışa aktar…
    .accesskey = D
certmgr-delete =
    .label = Sil…
    .accesskey = S
certmgr-delete-builtin =
    .label = Sil veya güvenme…
    .accesskey = S
certmgr-backup =
    .label = Yedekle…
    .accesskey = Y
certmgr-backup-all =
    .label = Hepsini yedekle…
    .accesskey = d
certmgr-restore =
    .label = İçe aktar…
    .accesskey = a
certmgr-details =
    .value = Sertifika alanları
    .accesskey = a
certmgr-fields =
    .value = Alan değeri
    .accesskey = d
certmgr-hierarchy =
    .value = Sertifika hiyerarşisi
    .accesskey = H
certmgr-add-exception =
    .label = Ayrıcalık tanı…
    .accesskey = t
exception-mgr =
    .title = Güvenlik ayrıcalığı tanı
exception-mgr-extra-button =
    .label = Güvenlik ayrıcalığını doğrula
    .accesskey = d
exception-mgr-supplemental-warning = Bankalar, mağazalar ve diğer kamu siteleri bunu yapmanızı istemez.
exception-mgr-cert-location-url =
    .value = Konum:
exception-mgr-cert-location-download =
    .label = Sertifikayı al
    .accesskey = a
exception-mgr-cert-status-view-cert =
    .label = Göster…
    .accesskey = G
exception-mgr-permanent =
    .label = Bu ayrıcalığı kalıcı olarak kaydet
    .accesskey = k
pk11-bad-password = Geçerli parola girişi hatalı.
pkcs12-decode-err = Dosyanın çözülmesi başarısız. Ya PKCS #12 biçiminde değil ve bozuldu ya da girdiğiniz şifre hatalı.
pkcs12-unknown-err-restore = PKCS #12 dosyasının yenilenmesi bilinmeyen sebeplerden dolayı başarısız oldu.
pkcs12-unknown-err-backup = Bilinmeyen nedenlerden dolayı PKCS #12 yedekleme dosyası oluşturulamadı.
pkcs12-unknown-err = PKCS #12 işlemi bilinmeyen sebeplerden dolayı başarısız oldu.
pkcs12-info-no-smartcard-backup = Akıllı kart gibi bir donanım güvenlik aygıtından sertifika yedeklemek mümkün değildir.
pkcs12-dup-data = Sertifika ve özel anahtar zaten güvenlik aygıtında mevcut.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Yedekleme için dosya adı
file-browse-pkcs12-spec = PKSC12 Dosyaları
choose-p12-restore-file-dialog = İçe aktarılacak sertifika dosyası

## Import certificate(s) file dialog

file-browse-certificate-spec = Sertifika dosyaları
import-ca-certs-prompt = İçe aktarım için CA sertifikalarını içeren dosyayı seçin
import-email-cert-prompt = İçe aktarım için birisinin e-posta sertifikasını içeren dosyayı seçin

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = "{ $certName }" sertifikası bir Sertifika Makamını temsil ediyor.

## For Deleting Certificates

delete-user-cert-title =
    .title = Sertifikalarınızı silin
delete-user-cert-confirm = Bu sertifikaları silmek istediğinizden emin misiniz?
delete-user-cert-impact = Kendi sertifikalarınızdan birini silerseniz artık kendinizi tanıtmak için onu kullanamazsınız.
delete-ssl-cert-title =
    .title = Sunucu sertifikası ayrıcalıklarını sil
delete-ssl-cert-confirm = Bu sunucu ayrıcalıklarını silmek istediğinizden emin misiniz?
delete-ssl-cert-impact = Bir sunucu ayrıcalığını silerseniz, o sunucu için olağan güvenlik kontrollerini geri yüklemiş ve sunucunun geçerli bir sertifika kullanmasını zorunlu tutmuş olursunuz.
delete-ca-cert-title =
    .title = CA sertifikalarını sil veya güvenme
delete-ca-cert-confirm = Bu CA sertifikalarını silmeyi istediniz. Dahili sertifikalar için tüm güvenler kaldırılacaktır ki bu da aynı etkiye sahiptir. Silmek veya güvenmemek istediğinizden emin misiniz?
delete-ca-cert-impact = Bir sertifika makamının (CA) sertifikasını silerseniz veya ona güvenmezseniz, bu uygulama artık o CA tarafından yayımlanan hiçbir sertifikaya güvenmeyecektir.
delete-email-cert-title =
    .title = E-posta sertifikalarını sil
delete-email-cert-confirm = Bu kişilerin e-posta sertifikalarını silmek istediğinizden emin misiniz?
delete-email-cert-impact = Bir şahsın e-posta sertifikasını silerseniz, artık o kişiye şifrelenmiş e-posta gönderemezsiniz.
# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Sertifika seri numarası: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Sertifika Görüntüleyicisi: “{ $certName }”
not-present =
    .value = <Sertifikanın parçası değil>
# Cert verification
cert-verified = Bu sertifika şu amaçlar için doğrulandı:
# Add usage
verify-ssl-client =
    .value = SSL İstemci Sertifikası
verify-ssl-server =
    .value = SSL Sunucu Sertifikası
verify-ssl-ca =
    .value = SSL Setifika Makamı
verify-email-signer =
    .value = E-posta İmzalayan Sertifikası
verify-email-recip =
    .value = E-Posta Alıcı Sertifikası
# Cert verification
cert-not-verified-cert-revoked = Bu sertifika iptal edildiği için doğrulanamadı.
cert-not-verified-cert-expired = Bu sertifika zaman aşımına uğradığı için doğrulanamadı.
cert-not-verified-cert-not-trusted = Bu sertifika güvenilir olmadığı için doğrulanamadı.
cert-not-verified-issuer-not-trusted = Yayıncıya güvenilmediği için bu sertifika doğrulanamadı.
cert-not-verified-issuer-unknown = Yayıncısı bilinmediği için bu sertifika doğrulanamadı.
cert-not-verified-ca-invalid = CA sertifikası geçersiz olduğu için bu sertifika doğrulanamadı.
cert-not-verified_algorithm-disabled = Güvenli olmadığı için devre dışı bırakılmış bir imza algoritması ile imzalandığından, bu sertifika doğrulanamadı.
cert-not-verified-unknown = Bu sertifika bilinmeyen sebeplerden dolayı doğrulanamadı.
# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = İstemci sertifikası gönderme

## Used to show whether an override is temporary or permanent

permanent-override = Kalıcı
temporary-override = Geçici

## Add Security Exception dialog

add-exception-branded-warning = { -brand-short-name } uygulamasının siteyi tanımlama şeklini geçersiz kılmak üzeresiniz.
add-exception-invalid-header = Bu site kendini geçersiz bilgilerle tanımlamaya çalışıyor.
add-exception-domain-mismatch-short = Yanlış site
add-exception-domain-mismatch-long = Sertifika başka bir siteye ait. Bu, sitenin başka birisi tarafından taklit edilmeye çalışıldığı anlamına gelebilir.
add-exception-expired-short = Güncelliğini yitirmiş bilgi
add-exception-expired-long = Sertifika şu anda geçerli değil. Çalınmış veya kaybedilmiş olabilir ve birisi tarafından bu siteyi taklit etmek için kullanılabilir.
add-exception-unverified-or-bad-signature-short = Bilinmeyen kimlik
add-exception-unverified-or-bad-signature-long = Güvenilir bir makam tarafından yayımlandığını gösteren güvenli bir imza ile doğrulanmadığı için bu sertifikaya güvenilmiyor.
add-exception-valid-short = Geçerli sertifika
add-exception-valid-long = Bu site geçerli ve doğrulanmış tanımlama bilgisi sunuyor.  Güvenlik ayrıcalığı tanımaya gerek yok.
add-exception-checking-short = Bilgiler denetleniyor
add-exception-checking-long = Site tanımlanmaya çalışılıyor…
add-exception-no-cert-short = Bilgi yok
add-exception-no-cert-long = Bu sitenin tanımlanma durumuna ulaşılamıyor.

## Certificate export "Save as" and error dialogs

save-cert-as = Sertifikayı dosyaya kaydet
cert-format-base64 = X.509 sertifikası (PEM)
cert-format-base64-chain = X.509 sertifikası (PEM)
cert-format-der = X.509 sertifikası (DER)
cert-format-pkcs7 = X.509 sertifikası (PKCS#7)
cert-format-pkcs7-chain = X.509 sertifikası (PKCS#7)
write-file-failure = Dosya hatası
