# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 690px; min-height: 610px;

copy =
    .key = C
menu-copy =
    .label = Копировать
    .accesskey = п

select-all =
    .key = A
menu-select-all =
    .label = Выделить всё
    .accesskey = д

close-dialog =
    .key = w

general-tab =
    .label = Основная
    .accesskey = н
general-title =
    .value = Заголовок:
general-url =
    .value = Адрес:
general-type =
    .value = Тип:
general-mode =
    .value = Тип визуализации:
general-size =
    .value = Размер:
general-referrer =
    .value = Ссылающийся URL:
general-modified =
    .value = Последнее изменение:
general-encoding =
    .value = Кодировка текста:
general-meta-name =
    .label = Имя
general-meta-content =
    .label = Содержимое

media-tab =
    .label = Мультимедиа
    .accesskey = л
media-location =
    .value = Адрес:
media-text =
    .value = Связанный текст:
media-alt-header =
    .label = Альтернативный текст
media-address =
    .label = Адрес
media-type =
    .label = Тип
media-size =
    .label = Размер
media-count =
    .label = Количество
media-dimension =
    .value = Размеры:
media-long-desc =
    .value = Длинное описание:
media-save-as =
    .label = Сохранить как…
    .accesskey = к
media-save-image-as =
    .label = Сохранить как…
    .accesskey = х

perm-tab =
    .label = Разрешения
    .accesskey = з
permissions-for =
    .value = Разрешения для:

security-tab =
    .label = Защита
    .accesskey = щ
security-view =
    .label = Просмотреть сертификат
    .accesskey = с
security-view-unknown = Неизвестно
    .value = Неизвестно
security-view-identity =
    .value = Подлинность веб-сайта
security-view-identity-owner =
    .value = Владелец:
security-view-identity-domain =
    .value = Веб-сайт:
security-view-identity-verifier =
    .value = Подтверждено:
security-view-identity-validity =
    .value = Действителен по:
security-view-privacy =
    .value = Приватность и История

security-view-privacy-history-value = Посещал ли я этот сайт до сегодняшнего дня?
security-view-privacy-sitedata-value = Хранит ли этот веб-сайт информацию на моём компьютере?

security-view-privacy-clearsitedata =
    .label = Удалить куки и данные сайта
    .accesskey = а

security-view-privacy-passwords-value = Сохранял ли я для этого веб-сайта какие-либо пароли?

security-view-privacy-viewpasswords =
    .label = Просмотреть сохранённые пароли
    .accesskey = о
security-view-technical =
    .value = Технические детали

help-button =
    .label = Справка

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Да, куки и { $value } { $unit } данных сайта
security-site-data-only = Да, { $value } { $unit } данных сайта

security-site-data-cookies-only = Да, куки
security-site-data-no = Нет

##

image-size-unknown = Неизвестно
page-info-not-specified =
    .value = Не указано
not-set-alternative-text = Не указано
not-set-date = Не указано
media-img = Изображение
media-bg-img = Фоновое изображение
media-border-img = Граница
media-list-img = Маркер
media-cursor = Курсор
media-object = Объект
media-embed = Встроенный объект
media-link = Значок
media-input = Поле ввода
media-video = Видео
media-audio = Аудио
saved-passwords-yes = Да
saved-passwords-no = Нет

no-page-title =
    .value = Безымянная страница:
general-quirks-mode =
    .value = Режим совместимости
general-strict-mode =
    .value = Режим соответствия стандартам
page-info-security-no-owner =
    .value = Информация о владельце этого веб-сайта отсутствует.
media-select-folder = Выберите папку для сохранения изображений
media-unknown-not-cached =
    .value = Неизвестно (не кэшировано)
permissions-use-default =
    .label = По умолчанию
security-no-visits = Нет

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Мета-теги ({ $tags } тег)
            [few] Мета-теги ({ $tags } тега)
           *[many] Мета-теги ({ $tags } тегов)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Нет
        [one] Да, { $visits } раз
        [few] Да, { $visits } раза
       *[many] Да, { $visits } раз
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } КБ ({ $bytes } байт)
            [few] { $kb } КБ ({ $bytes } байта)
           *[many] { $kb } КБ ({ $bytes } байт)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type }-изображение (анимируемое, { $frames } кадр)
            [few] { $type }-изображение (анимируемое, { $frames } кадра)
           *[many] { $type }-изображение (анимируемое, { $frames } кадров)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Изображение { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (в масштабе { $scaledx }px × { $scaledy }px)

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
    .label = Блокировать изображения с { $website }
    .accesskey = л

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) — The url of the website pageInfo is getting info for
page-info-page =
    .title = Информация о странице — { $website }
page-info-frame =
    .title = Информация о фрейме — { $website }
