# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 600px;

copy =
    .key = C
menu-copy =
    .label = Копирај
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = Изабери све
    .accesskey = A

close-dialog =
    .key = w

general-tab =
    .label = Опште
    .accesskey = G
general-title =
    .value = Наслов:
general-url =
    .value = Адреса:
general-type =
    .value = Тип:
general-mode =
    .value = Тип приказа:
general-size =
    .value = Величина:
general-referrer =
    .value = Референтни URL:
general-modified =
    .value = Последња измена:
general-encoding =
    .value = Кодирање текста:
general-meta-name =
    .label = Назив
general-meta-content =
    .label = Садржај

media-tab =
    .label = Медији
    .accesskey = M
media-location =
    .value = Адреса:
media-text =
    .value = Придружени текст:
media-alt-header =
    .label = Резервни текст
media-address =
    .label = Адреса
media-type =
    .label = Тип
media-size =
    .label = Величина
media-count =
    .label = Укупно
media-dimension =
    .value = Димензије:
media-long-desc =
    .value = Дуги опис:
media-save-as =
    .label = Сачувај као…
    .accesskey = A
media-save-image-as =
    .label = Сачувај као…
    .accesskey = e

perm-tab =
    .label = Дозволе
    .accesskey = P
permissions-for =
    .value = Дозволе за:

security-tab =
    .label = Безбедност
    .accesskey = S
security-view =
    .label = Преглед сертификата
    .accesskey = с
security-view-unknown = Непознат
    .value = Непознат
security-view-identity =
    .value = Идентитет сајта
security-view-identity-owner =
    .value = Власник:
security-view-identity-domain =
    .value = Веб сајт:
security-view-identity-verifier =
    .value = Проверио:
security-view-identity-validity =
    .value = Истиче:
security-view-privacy =
    .value = Приватност и историјат

security-view-privacy-history-value = Да ли сте раније посетили овај сајт?
security-view-privacy-sitedata-value = Да ли овај веб сајт складишти информације на мој рачунар?

security-view-privacy-clearsitedata =
    .label = Обриши колачиће и податке сајта
    .accesskey = C

security-view-privacy-passwords-value = Да ли чувам неку лозинку за овај сајт?

security-view-privacy-viewpasswords =
    .label = Преглед сачуваних лозинки
    .accesskey = w
security-view-technical =
    .value = Технички детаљи

help-button =
    .label = Помоћ

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Да, колачиће и { $value } { $unit } података сајта
security-site-data-only = Да, { $value } { $unit } података сајта

security-site-data-cookies-only = Да, колачиће
security-site-data-no = Не

image-size-unknown = Непознат
page-info-not-specified =
    .value = Неодређено
not-set-alternative-text = Неодређено
not-set-date = Неодређено
media-img = Слика
media-bg-img = Позадинска слика
media-border-img = Ивица
media-list-img = Знак
media-cursor = Показивач
media-object = Објекат
media-embed = Уграђени објекат
media-link = Иконица
media-input = Поље уноса
media-video = Видео
media-audio = Звук
saved-passwords-yes = Да
saved-passwords-no = Не

no-page-title =
    .value = Безимена страница:
general-quirks-mode =
    .value = Толерантан начин рада
general-strict-mode =
    .value = Поштовање стандарда
page-info-security-no-owner =
    .value = Овај веб сајт не објављује податке о власништву.
media-select-folder = Изаберите фасциклу за чување слика
media-unknown-not-cached =
    .value = Непозната (није кеширана)
permissions-use-default =
    .label = Користи подразумевано
security-no-visits = Не

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Мета ({ $tags } ознака)
            [few] Мета ({ $tags } ознаке)
           *[other] Мета ({ $tags } ознака)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Не
        [one] Да, један
        [few] Да, више
       *[other] Да, { $visits } пута
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } КВ ({ $bytes } бајт)
            [few] { $kb } КВ ({ $bytes } бајта)
           *[other] { $kb } КВ ({ $bytes } бајтова)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } Слика (анимирана, { $frames } фрејм)
            [few] { $type } Слика (анимирана, { $frames } фрејма)
           *[other] { $type } Слика (анимирана, { $frames } фрејмова)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Слика: { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (скалирано на { $scaledx }px × { $scaledy }px)

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
media-file-size = { $size } KB

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Блокирај слике са: { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Подаци о страници - { $website }
page-info-frame =
    .title = Подаци о оквиру - { $website }
