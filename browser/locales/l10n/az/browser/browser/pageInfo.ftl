# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Köçür
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Hamısını Seç
    .accesskey = S

close-dialog =
    .key = w

general-tab =
    .label = Ümumi
    .accesskey = m
general-title =
    .value = Başlıq:
general-url =
    .value = URL:
general-type =
    .value = Format:
general-mode =
    .value = Göstərmə rejimi:
general-size =
    .value = Həcm:
general-referrer =
    .value = Yönləndirən URL:
general-modified =
    .value = Dəyişmə tarixi:
general-encoding =
    .value = Mətn Kodlaması:
general-meta-name =
    .label = Ad
general-meta-content =
    .label = Məzmun

media-tab =
    .label = Ortam
    .accesskey = M
media-location =
    .value = Ünvan:
media-text =
    .value = Alternativ mətn:
media-alt-header =
    .label = Alternativ mətn
media-address =
    .label = Adres
media-type =
    .label = Format
media-size =
    .label = Həcm
media-count =
    .label = Sayğaç
media-dimension =
    .value = Ölçülər:
media-long-desc =
    .value = Uzun Açıqlama:
media-save-as =
    .label = Fərqli saxla
    .accesskey = F
media-save-image-as =
    .label = Fərqli saxla
    .accesskey = a

perm-tab =
    .label = İcazələr
    .accesskey = z
permissions-for =
    .value = İcazələr:

security-tab =
    .label = Təhlükəsizlik
    .accesskey = T
security-view =
    .label = Sertifikatı göstər
    .accesskey = G
security-view-unknown = Bilinmir
    .value = Bilinmir
security-view-identity =
    .value = Səhifə kimliyi
security-view-identity-owner =
    .value = Sahibi:
security-view-identity-domain =
    .value = Web sayt:
security-view-identity-verifier =
    .value = Təsdiqləyən:
security-view-identity-validity =
    .value = Vaxtı çıxma:
security-view-privacy =
    .value = Məxfilik və Tarixçə

security-view-privacy-history-value = Bu saytı daha əvvəl açmışam?
security-view-privacy-sitedata-value = Bu sayt kompüterimdə məlumat saxlayırmı?

security-view-privacy-clearsitedata =
    .label = Çərəz və Sayt Məlumatlarını Təmizlə
    .accesskey = T

security-view-privacy-passwords-value = Bu sayta aid hər hansı bir parol saxlamışam?

security-view-privacy-viewpasswords =
    .label = Saxlanılmış Parolları Gör
    .accesskey = P
security-view-technical =
    .value = Texniki Təfərrüatlar

help-button =
    .label = Kömək

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Bəli, çərəzlər və { $value } { $unit } sayt məlumatı
security-site-data-only = Bəli, { $value } { $unit } sayt məlumatı

security-site-data-cookies-only = Bəli, çərəzlər
security-site-data-no = Xeyr

image-size-unknown = Bilinmir
page-info-not-specified =
    .value = Dəqiqləşdirilməyib
not-set-alternative-text = Göstərilməyib
not-set-date = Göstərilməyib
media-img = Şəkil
media-bg-img = Arxa fon
media-border-img = Kənar
media-list-img = Maddə favoriti
media-cursor = Kursor
media-object = Nesne
media-embed = Yerləşdirilmiş
media-link = Simvol
media-input = Daxil etmə
media-video = Video
media-audio = Ses
saved-passwords-yes = Bəli
saved-passwords-no = Xeyr

no-page-title =
    .value = Başlıqsız səhifə:
general-quirks-mode =
    .value = Quirks kipi
general-strict-mode =
    .value = Standartlarla uyğunluluq rejimi
page-info-security-no-owner =
    .value = Bu sayt, sahibi ilə əlaqədar məlumat vermir.
media-select-folder = Şəkilləri saxlamaq üçün bir qovluq seçin
media-unknown-not-cached =
    .value = Naməlum (yaddaşda saxlanmadı)
permissions-use-default =
    .label = Standartdan istifadə et
security-no-visits = Xeyr

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
        [0] Xeyr
        [one] Hə, bir dəfə
       *[other] Hə, { $visits } dəfə
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
            [one] { $type } şəkli (animasiyalı, { $frames } çərçivə)
           *[other] { $type } şəkli (animasiyalı, { $frames } çərçivə)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } şəkili

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx } px × { $dimy } px ({ $scaledx } px × { $scaledy } px olaraq yenidən ölçüləndirildi)

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
    .label = { $website } şəkillərini blokla
    .accesskey = O

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Səhifə məlumatı - { $website }
page-info-frame =
    .title = Çərçivə məlumatı - { $website }
