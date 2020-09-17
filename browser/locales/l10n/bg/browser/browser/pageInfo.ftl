# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 1000px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Копиране
    .accesskey = К

select-all =
    .key = A
menu-select-all =
    .label = Избиране на всичко
    .accesskey = в

close-dialog =
    .key = w

general-tab =
    .label = Основни
    .accesskey = О
general-title =
    .value = Заглавие:
general-url =
    .value = Адрес:
general-type =
    .value = Вид:
general-mode =
    .value = Изчертаване:
general-size =
    .value = Големина:
general-referrer =
    .value = Препращащ адрес:
general-modified =
    .value = Последна промяна:
general-encoding =
    .value = Кодиране на текста:
general-meta-name =
    .label = Наименование
general-meta-content =
    .label = Съдържание

media-tab =
    .label = Медия
    .accesskey = М
media-location =
    .value = Адрес:
media-text =
    .value = Описание:
media-alt-header =
    .label = Алтернативен текст
media-address =
    .label = Адрес
media-type =
    .label = Вид
media-size =
    .label = Размер
media-count =
    .label = Брой
media-dimension =
    .value = Размер:
media-long-desc =
    .value = Дълго описание:
media-save-as =
    .label = Запазване като…
    .accesskey = З
media-save-image-as =
    .label = Запазване като…
    .accesskey = к

perm-tab =
    .label = Права
    .accesskey = П
permissions-for =
    .value = Правата на:

security-tab =
    .label = Защита
    .accesskey = З
security-view =
    .label = Преглед на сертификата
    .accesskey = П
security-view-unknown = Неизвестен
    .value = Неизвестен
security-view-identity =
    .value = Идентичност на сайта
security-view-identity-owner =
    .value = Собственик:
security-view-identity-domain =
    .value = Уеб сайт:
security-view-identity-verifier =
    .value = Проверено от:
security-view-identity-validity =
    .value = Изтича на:
security-view-privacy =
    .value = Поверителност и история

security-view-privacy-history-value = Посещавал(-а) ли съм този сайт и преди, изключвайки днес?
security-view-privacy-sitedata-value = Пази ли тази страница информация на компютъра?

security-view-privacy-clearsitedata =
    .label = Изчистване на бисквитки и данни на страници
    .accesskey = И

security-view-privacy-passwords-value = Имам ли запазени пароли за този сайт?

security-view-privacy-viewpasswords =
    .label = Преглед на запазените пароли
    .accesskey = п
security-view-technical =
    .value = Технически подробности

help-button =
    .label = Помощ

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Да, бисквитки и { $value } { $unit } данни от страницата
security-site-data-only = Да, { $value } { $unit } данни на страници

security-site-data-cookies-only = Да, бисквитките
security-site-data-no = Не

image-size-unknown = Неизвестно
page-info-not-specified =
    .value = Не е посочено
not-set-alternative-text = Неизвестно
not-set-date = Неизвестно
media-img = Изображение
media-bg-img = Фон
media-border-img = Рамка
media-list-img = Водач
media-cursor = Курсор
media-object = Обект
media-embed = Вграден обект
media-link = Пиктограма
media-input = Вход
media-video = Видео
media-audio = Аудио
saved-passwords-yes = Да
saved-passwords-no = Не

no-page-title =
    .value = Неозаглавена страница:
general-quirks-mode =
    .value = Нестандартен режим
general-strict-mode =
    .value = Стандартен режим
page-info-security-no-owner =
    .value = Сайтът не предоставя информация за собственост.
media-select-folder = Изберете папка за запазване на изображенията
media-unknown-not-cached =
    .value = Неизвестно (не е буферирано)
permissions-use-default =
    .label = Както е по подразбиране
security-no-visits = Не

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Мета информация (1 етикет)
           *[other] Мета информация ({ $tags } етикета)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Няма
        [one] Да, 1 път
       *[other] Да, { $visits } пъти
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } байта)
           *[other] { $kb } KB ({ $bytes } байта)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } Изображение (анимирано, { $frames } кадър)
           *[other] { $type } Изображение (анимирано, { $frames } кадъра)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } изображение

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx } × { $dimy } пиксела (мащабирано до { $scaledx } × { $scaledy } пиксела)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx } × { $dimy } пиксела

# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } КБ

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Блокиране на изображенията от { $website }
    .accesskey = Б

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Информация за страница – { $website }
page-info-frame =
    .title = Информация за рамка – { $website }
