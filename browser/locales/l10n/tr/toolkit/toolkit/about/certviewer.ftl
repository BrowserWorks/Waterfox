# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Sertifika

## Error messages

certificate-viewer-error-message = Sertifika bilgilerini bulamadık veya sertifika bozuk. Lütfen yeniden deneyin.
certificate-viewer-error-title = Yanlış giden bir şeyler var.

## Certificate information labels

certificate-viewer-algorithm = Algoritma
certificate-viewer-certificate-authority = Sertifika makamı
certificate-viewer-cipher-suite = Şifre paketi
certificate-viewer-common-name = Yaygın ad
certificate-viewer-email-address = E-posta adresi
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = { $firstCertName } Sertifikası
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Kuruluş ülkesi
certificate-viewer-country = Ülke
certificate-viewer-curve = Eğri
certificate-viewer-distribution-point = Dağıtım noktası
certificate-viewer-dns-name = DNS adı
certificate-viewer-ip-address = IP adresi
certificate-viewer-other-name = Diğer adı
certificate-viewer-exponent = Üs
certificate-viewer-id = Kimlik
certificate-viewer-key-exchange-group = Anahtar değişim grubu
certificate-viewer-key-id = Anahtar kimliği
certificate-viewer-key-size = Anahtar boyutu
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Kuruluş yeri
certificate-viewer-locality = Bölge
certificate-viewer-location = Konum
certificate-viewer-logid = Log kimliği
certificate-viewer-method = Yöntem
certificate-viewer-modulus = Modülüs
certificate-viewer-name = Adı
certificate-viewer-not-after = Bitiş
certificate-viewer-not-before = Başlangıç
certificate-viewer-organization = Kurum
certificate-viewer-organizational-unit = Kurum birimi
certificate-viewer-policy = İlke
certificate-viewer-protocol = Protokol
certificate-viewer-public-value = Açık değer
certificate-viewer-purposes = Amaçlar
certificate-viewer-qualifier = Niteleyici
certificate-viewer-qualifiers = Niteleyiciler
certificate-viewer-required = Gerekli
certificate-viewer-unsupported = &lt;desteklenmiyor&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Kuruluş ili
certificate-viewer-state-province = Eyalet/il
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Seri numarası
certificate-viewer-signature-algorithm = İmza algoritması
certificate-viewer-signature-scheme = İmza şeması
certificate-viewer-timestamp = Zaman damgası
certificate-viewer-value = Değer
certificate-viewer-version = Sürüm
certificate-viewer-business-category = İş kategorisi
certificate-viewer-subject-name = Özne Adı
certificate-viewer-issuer-name = Düzenleyenin Adı
certificate-viewer-validity = Geçerlilik
certificate-viewer-subject-alt-names = Özne alternatif adları
certificate-viewer-public-key-info = Açık Anahtar Bilgileri
certificate-viewer-miscellaneous = Diğer
certificate-viewer-fingerprints = Parmak İzleri
certificate-viewer-basic-constraints = Temel Kısıtlamalar
certificate-viewer-key-usages = Anahtar Kullanımları
certificate-viewer-extended-key-usages = Genişletilmiş Anahtar Kullanımları
certificate-viewer-ocsp-stapling = OCSP Zımbalama
certificate-viewer-subject-key-id = Özne Anahtar Kimliği
certificate-viewer-authority-key-id = Makam Anahtar Kimliği
certificate-viewer-authority-info-aia = Makam Bilgileri (AIA)
certificate-viewer-certificate-policies = Sertifika İlkeleri
certificate-viewer-embedded-scts = Gömülü SCT’ler
certificate-viewer-crl-endpoints = CRL uç noktaları

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = İndir
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Evet
       *[false] Hayır
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (sertifika)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (zincir)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Bu eklenti kritik olarak işaretlenmiş. Yani istemciler sertifikayı anlamadılarsa sertifikayı reddetmeleri gerekir.
certificate-viewer-export = Dışa aktar
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Sertifikalarınız
certificate-viewer-tab-people = Kişiler
certificate-viewer-tab-servers = Sunucular
certificate-viewer-tab-ca = Makamlar
certificate-viewer-tab-unkonwn = Bilinmeyen
