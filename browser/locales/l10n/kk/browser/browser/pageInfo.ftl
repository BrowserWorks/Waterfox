# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 620px; min-height: 600px;

copy =
    .key = C
menu-copy =
    .label = Көшіріп алу
    .accesskey = К

select-all =
    .key = A
menu-select-all =
    .label = Барлығын ерекшелеу
    .accesskey = Б

close-dialog =
    .key = w

general-tab =
    .label = Жалпы
    .accesskey = Ж
general-title =
    .value = Атауы:
general-url =
    .value = Адрес:
general-type =
    .value = Түрі:
general-mode =
    .value = Визуализация түрі:
general-size =
    .value = Өлшемі:
general-referrer =
    .value = Сілтейтін URL:
general-modified =
    .value = Соңғы өзгерту:
general-encoding =
    .value = Мәтін кодталуы:
general-meta-name =
    .label = Аты
general-meta-content =
    .label = Құрамасы

media-tab =
    .label = Мультимедиа
    .accesskey = М
media-location =
    .value = Орналасуы:
media-text =
    .value = Байланысқан мәтін:
media-alt-header =
    .label = Балама мәтін
media-address =
    .label = Адрес
media-type =
    .label = Түрі
media-size =
    .label = Өлшемі
media-count =
    .label = Саны
media-dimension =
    .value = Өлшемдер:
media-long-desc =
    .value = Толық сипаттамасы:
media-save-as =
    .label = Қалайша сақтау…
    .accesskey = с
media-save-image-as =
    .label = Қалайша сақтау…
    .accesskey = а

perm-tab =
    .label = Рұқсаттар
    .accesskey = Р
permissions-for =
    .value = Келесі үшін рұқсаттар:

security-tab =
    .label = Қауіпсіздік
    .accesskey = а
security-view =
    .label = Сертификатты қарау
    .accesskey = ф
security-view-unknown = Белгісіз
    .value = Белгісіз
security-view-identity =
    .value = Веб-сайттың шындылығы
security-view-identity-owner =
    .value = Иесі:
security-view-identity-domain =
    .value = Веб-сайт:
security-view-identity-verifier =
    .value = Растаған:
security-view-identity-validity =
    .value = Мерзімі аяқталады:
security-view-privacy =
    .value = Жекешелік пен Тарихы

security-view-privacy-history-value = Бұл сайтта бүгінге дейін болдым ба?
security-view-privacy-sitedata-value = Бұл сайт компьютерімде ақпаратты сақтап отыр ма?

security-view-privacy-clearsitedata =
    .label = Cookies файлдары және сайт деректерін тазарту
    .accesskey = з

security-view-privacy-passwords-value = Осы веб-сайт үшін парольдерімді сақтадым ба?

security-view-privacy-viewpasswords =
    .label = Сақталып тұрған парольдерді қарау
    .accesskey = т
security-view-technical =
    .value = Техникалық ақпарат

help-button =
    .label = Көмек

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Иә, cookies файлдары және { $value } { $unit } сайт деректері
security-site-data-only = Иә, { $value } { $unit } сайт деректері

security-site-data-cookies-only = Иә, cookies файлдары
security-site-data-no = Жоқ

image-size-unknown = Белгісіз
page-info-not-specified =
    .value = Көрсетілмеген
not-set-alternative-text = Көрсетілмеген
not-set-date = Көрсетілмеген
media-img = Сурет
media-bg-img = Фон суреті
media-border-img = Шек
media-list-img = Нүкте
media-cursor = Курсор
media-object = Объект
media-embed = Құрамындағы объект
media-link = Белгі
media-input = Енгізу
media-video = Видео
media-audio = Аудио
saved-passwords-yes = Иә
saved-passwords-no = Жоқ

no-page-title =
    .value = Атаусыз парақ:
general-quirks-mode =
    .value = Үйлесу режимі
general-strict-mode =
    .value = Стандарттарға сәйкес режим
page-info-security-no-owner =
    .value = Осы сайт иелік туралы ақпарат жоқ
media-select-folder = Суреттерді сақтау үшін буманы таңдаңыз
media-unknown-not-cached =
    .value = Белгісіз (кэштелмеген)
permissions-use-default =
    .label = Негізгісін қолдану
security-no-visits = Жоқ

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
           *[other] Мета ({ $tags } тег)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Жоқ
       *[other] Yes, { $visits } рет
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
           *[other] { $kb } КБ ({ $bytes } байт)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
           *[other] { $type } Сурет (анимацияланған, { $frames } кадр)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } суреті

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px ({ $scaledx }px × { $scaledy }px масштабында)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx }px × { $dimy }px

# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } Кб

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = { $website } адресінен суреттерді блоктау
    .accesskey = б

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = { $website } парағы туралы ақпарат
page-info-frame =
    .title = { $website } фреймі туралы ақпарат
