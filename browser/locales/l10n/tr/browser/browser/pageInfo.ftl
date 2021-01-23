# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 620px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Kopyala
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Tümünü seç
    .accesskey = s

close-dialog =
    .key = w

general-tab =
    .label = Genel
    .accesskey = G
general-title =
    .value = Başlık:
general-url =
    .value = Adres:
general-type =
    .value = Tür:
general-mode =
    .value = Yorum kipi:
general-size =
    .value = Boyut:
general-referrer =
    .value = Yönlendiren URL:
general-modified =
    .value = Değişme tarihi:
general-encoding =
    .value = Metin kodlaması:
general-meta-name =
    .label = Adı
general-meta-content =
    .label = İçerik

media-tab =
    .label = Ortam
    .accesskey = O
media-location =
    .value = Konum:
media-text =
    .value = İlgili metin:
media-alt-header =
    .label = Alternatif metin
media-address =
    .label = Adres
media-type =
    .label = Türü
media-size =
    .label = Boyut
media-count =
    .label = Sayaç
media-dimension =
    .value = Ölçüler:
media-long-desc =
    .value = Uzun açıklama:
media-save-as =
    .label = Farklı kaydet…
    .accesskey = F
media-save-image-as =
    .label = Farklı kaydet…
    .accesskey = e

perm-tab =
    .label = İzinler
    .accesskey = z
permissions-for =
    .value = İzinler:

security-tab =
    .label = Güvenlik
    .accesskey = e
security-view =
    .label = Sertifikayı göster
    .accesskey = S
security-view-unknown = Bilinmiyor
    .value = Bilinmiyor
security-view-identity =
    .value = Web sitesi kimliği
security-view-identity-owner =
    .value = Sahibi:
security-view-identity-domain =
    .value = Web sitesi:
security-view-identity-verifier =
    .value = Doğrulayan:
security-view-identity-validity =
    .value = Bitiş tarihi:
security-view-privacy =
    .value = Gizlilik ve geçmiş

security-view-privacy-history-value = Bu siteyi daha önce ziyaret ettim mi?
security-view-privacy-sitedata-value = Bu site bilgisayarımda bilgi depoluyor mu?

security-view-privacy-clearsitedata =
    .label = Çerezleri ve site verilerini temizle
    .accesskey = t

security-view-privacy-passwords-value = Bu siteye ait parola kaydettim mi?

security-view-privacy-viewpasswords =
    .label = Kayıtlı parolaları göster
    .accesskey = K
security-view-technical =
    .value = Teknik ayrıntılar

help-button =
    .label = Yardım

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Evet, çerezler ve { $value } { $unit } site verisi
security-site-data-only = Evet, { $value } { $unit } site verisi

security-site-data-cookies-only = Evet, çerezler
security-site-data-no = Hayır

image-size-unknown = Bilinmiyor
page-info-not-specified =
    .value = Belirtilmemiş
not-set-alternative-text = Belirtilmemiş
not-set-date = Belirtilmemiş
media-img = Resim
media-bg-img = Arka plan
media-border-img = Kenar
media-list-img = Madde imi
media-cursor = İşaretçi
media-object = Nesne
media-embed = Gömülü
media-link = Simge
media-input = Girdi
media-video = Video
media-audio = Ses
saved-passwords-yes = Evet
saved-passwords-no = Hayır

no-page-title =
    .value = Başlıksız sayfa:
general-quirks-mode =
    .value = Quirks kipi
general-strict-mode =
    .value = Standartlarla uyumluluk kipi
page-info-security-no-owner =
    .value = Bu site, sahibiyle ilgili bilgi sağlamıyor.
media-select-folder = Resimleri kaydetmek için bir klasör seçin
media-unknown-not-cached =
    .value = Bilinmiyor (önbelleğe alınmadı)
permissions-use-default =
    .label = Varsayılanı kullan
security-no-visits = Hayır

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 etiket)
           *[other] Meta ({ $tags } etiket)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Hayır
        [one] Evet, bir kere
       *[other] Evet, { $visits } kere
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } bayt)
           *[other] { $kb } KB ({ $bytes } bayt)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } resmi (animasyonlu, { $frames } kare)
           *[other] { $type } resmi (animasyonlu, { $frames } kare)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } resmi

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx } px × { $dimy } px ({ $scaledx } px × { $scaledy } px olarak yeniden boyutlandırıldı)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx } px × { $dimy } px

# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } KB

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = { $website } resimlerini engelle
    .accesskey = e

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Sayfa Bilgileri - { $website }
page-info-frame =
    .title = Çerçeve Bilgileri - { $website }
