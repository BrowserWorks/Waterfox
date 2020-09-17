# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 690px; min-height: 610px;

copy =
    .key = C
menu-copy =
    .label = Копіювати
    .accesskey = о

select-all =
    .key = A
menu-select-all =
    .label = Вибрати все
    .accesskey = и

close-dialog =
    .key = w

general-tab =
    .label = Основна
    .accesskey = с
general-title =
    .value = Назва:
general-url =
    .value = Адреса:
general-type =
    .value = Тип:
general-mode =
    .value = Режим відображення:
general-size =
    .value = Розмір:
general-referrer =
    .value = URL, що посилається:
general-modified =
    .value = Остання зміна:
general-encoding =
    .value = Кодування тексту:
general-meta-name =
    .label = Назва
general-meta-content =
    .label = Вміст

media-tab =
    .label = Мультимедіа
    .accesskey = М
media-location =
    .value = Розташування:
media-text =
    .value = Пов’язаний текст:
media-alt-header =
    .label = Замінний текст
media-address =
    .label = Адреса
media-type =
    .label = Тип
media-size =
    .label = Розмір
media-count =
    .label = Кількість
media-dimension =
    .value = Виміри:
media-long-desc =
    .value = Розширений опис:
media-save-as =
    .label = Зберегти як…
    .accesskey = З
media-save-image-as =
    .label = Зберегти як…
    .accesskey = з

perm-tab =
    .label = Дозволи
    .accesskey = Д
permissions-for =
    .value = Дозволи для:

security-tab =
    .label = Безпека
    .accesskey = з
security-view =
    .label = Переглянути сертифікат
    .accesskey = ф
security-view-unknown = Невідомий
    .value = Невідомий
security-view-identity =
    .value = Справжність сайту
security-view-identity-owner =
    .value = Власник:
security-view-identity-domain =
    .value = Сайт:
security-view-identity-verifier =
    .value = Засвідчено:
security-view-identity-validity =
    .value = Завершується:
security-view-privacy =
    .value = Конфіденційність та історія

security-view-privacy-history-value = Чи відвідувався цей сайт раніше?
security-view-privacy-sitedata-value = Чи зберігає цей вебсайт інформацію на моєму комп’ютері?

security-view-privacy-clearsitedata =
    .label = Стерти куки і дані сайтів
    .accesskey = т

security-view-privacy-passwords-value = Чи зберігаю я паролі для цього сайту?

security-view-privacy-viewpasswords =
    .label = Переглянути збережені паролі
    .accesskey = п
security-view-technical =
    .value = Технічні подробиці

help-button =
    .label = Допомога

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Так, куки і { $value } { $unit } даних сайтів
security-site-data-only = Так, { $value } { $unit } даних сайтів

security-site-data-cookies-only = Так, куки
security-site-data-no = Ні

image-size-unknown = Невідомо
page-info-not-specified =
    .value = Не вказано
not-set-alternative-text = Не вказано
not-set-date = Не вказано
media-img = Зображення
media-bg-img = Тло
media-border-img = Рамка
media-list-img = Маркер
media-cursor = Курсор
media-object = Об’єкт
media-embed = Вбудований об’єкт
media-link = Піктограма
media-input = Поле введення
media-video = Відео
media-audio = Аудіо
saved-passwords-yes = Так
saved-passwords-no = Ні

no-page-title =
    .value = Сторінка без назви:
general-quirks-mode =
    .value = Режим сумісності
general-strict-mode =
    .value = Режим дотримання стандартів
page-info-security-no-owner =
    .value = Цей вебсайт не надає інформації про власника.
media-select-folder = Оберіть теку для збереження зображень
media-unknown-not-cached =
    .value = Невідомо (не закешовано)
permissions-use-default =
    .label = Типово
security-no-visits = Ні

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Мета (1 мітка)
            [few] Мета ({ $tags } мітки)
           *[many] Мета ({ $tags } міток)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Немає
        [one] Так, один раз
        [few] Так, { $visits } рази
       *[many] Так, { $visits } разів
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } КБ ({ $bytes } байт)
            [few] { $kb } КБ ({ $bytes } байти)
           *[many] { $kb } КБ ({ $bytes } байтів)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] Зображення { $type } (анімація, { $frames } кадр)
            [few] Зображення { $type } (анімація, { $frames } кадри)
           *[many] Зображення { $type } (анімація, { $frames } кадрів)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } Зображення

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (масштабовано до { $scaledx }px × { $scaledy }px)

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
media-file-size = { $size } КБ

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Заблокувати зображення з { $website }
    .accesskey = Р

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Інформація про сторінку - { $website }
page-info-frame =
    .title = Інформація про фрейм - { $website }
