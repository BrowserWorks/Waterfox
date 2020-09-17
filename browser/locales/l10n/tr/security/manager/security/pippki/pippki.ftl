# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Parola kalite ölçümü

## Change Password dialog

change-password-window =
    .title = Ana parolayı değiştir

change-device-password-window =
    .title = Parola değiştir

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Güvenlik aygıtı: { $tokenName }
change-password-old = Şu anki parola:
change-password-new = Yeni parola:
change-password-reenter = Yeni parola (tekrar):

## Reset Password dialog

reset-password-window =
    .title = Ana Parolayı Sıfırla
    .style = width: 40em

pippki-failed-pw-change = Parola değiştirilemedi.
pippki-incorrect-pw = Mevcut parolanızı doğru şekilde girmediniz. Lütfen tekrar deneyin.
pippki-pw-change-ok = Parola başarıyla değiştirildi.

pippki-pw-empty-warning = Kayıtlı parolalarınız ve özel anahtarlarınız korunmayacak.
pippki-pw-erased-ok = Parolanızı sildiniz. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Uyarı! Parola kullanmamaya karar verdiniz. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Şu anda FIPS kipindesiniz. FIPS için boş olmayan bir ana parola gereklidir.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Ana parolayı sıfırla
    .style = width: 40em
reset-password-button-label =
    .label = Sıfırla
reset-password-text = Ana parolanızı sıfırlarsanız tüm kayıtlı web ve e-posta parolalarınız, form verileriniz, kişisel sertifikalarınız ve özel anahtarlarınız silinecektir. Ana parolanızı sıfırlamak istediğinizden emin misiniz?

reset-primary-password-text = Ana parolanızı sıfırlarsanız tüm kayıtlı web ve e-posta parolalarınız, kişisel sertifikalarınız ve özel anahtarlarınız silinecektir. Ana parolanızı sıfırlamak istediğinizden emin misiniz?

pippki-reset-password-confirmation-title = Ana Parolayı Sıfırla
pippki-reset-password-confirmation-message = Ana parolanız sıfırlandı.

## Downloading cert dialog

download-cert-window =
    .title = Sertifika indiriliyor
    .style = width: 46em
download-cert-message = Yeni bir Sertifika Makamına (CA) güvenmeniz istendi.
download-cert-trust-ssl =
    .label = Web sitelerini tanımlamak için bu CA'ya güven.
download-cert-trust-email =
    .label = E-posta kullanıcılarını tanımlamak için bu CA'ya güven.
download-cert-message-desc = Herhangi bir amaçla bu CA'ya güvenmeden önce sertifikasını, ilkelerini ve prosedürlerini (varsa) incelemelisiniz.
download-cert-view-cert =
    .label = Göster
download-cert-view-text = CA sertifikasını incele

## Client Authorization Ask dialog

client-auth-window =
    .title = Kullanıcı Tanımlama İsteği
client-auth-site-description = Bu site, kendinizi bir sertifikayla tanıtmanızı istiyor:
client-auth-choose-cert = Sizi tanıtmak için gösterilecek sertifikayı seçin:
client-auth-cert-details = Seçilen sertifikanın ayrıntıları:

## Set password (p12) dialog

set-password-window =
    .title = Sertifika yedeği için bir parola seçin
set-password-message = Burada belirttiğiniz sertifika yedeği parolası, oluşturmak üzere olduğunuz yedek dosyasını korur. Yedeklemeye devam etmek için bu parolayı koymak zorundasınız.
set-password-backup-pw =
    .value = Sertifika yedek parolası:
set-password-repeat-backup-pw =
    .value = Sertifika yedek parolası (tekrar):
set-password-reminder = Önemli: Eğer sertifika yedek parolanızı unutursanız bu yedeği daha sonra geri yükleyemezsiniz.  Lütfen bunu güvenli bir yere kaydedin.

## Protected Auth dialog

protected-auth-window =
    .title = Korumalı Jeton Kimlik Doğrulaması
protected-auth-msg = Lütfen jetonda kimliğinizi doğrulayın. Kimlik doğrulama yöntemi jeton türüne göre değişir.
protected-auth-token = Jeton:
