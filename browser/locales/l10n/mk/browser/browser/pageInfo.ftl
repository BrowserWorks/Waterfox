# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 500px;

copy =
    .key = C
menu-copy =
    .label = Копирај
    .accesskey = К

select-all =
    .key = A
menu-select-all =
    .label = Избери сè
    .accesskey = е

general-tab =
    .label = Општо
    .accesskey = О
general-title =
    .value = Наслов:
general-url =
    .value = Адреса:
general-type =
    .value = Тип:
general-mode =
    .value = Режим на рендерирање:
general-size =
    .value = Големина:
general-referrer =
    .value = Референтно URL:
general-modified =
    .value = Изменета:
general-encoding =
    .value = Текстуално кодирање:
general-meta-name =
    .label = Име
general-meta-content =
    .label = Содржина

media-tab =
    .label = Медиум
    .accesskey = М
media-location =
    .value = Локација:
media-text =
    .value = Поврзан текст:
media-alt-header =
    .label = Постојан текст
media-address =
    .label = Адреса
media-type =
    .label = Тип
media-size =
    .label = Големина
media-count =
    .label = Број
media-dimension =
    .value = Димензии:
media-long-desc =
    .value = Долг опис:
media-save-as =
    .label = Сними како…
    .accesskey = С
media-save-image-as =
    .label = Сними како…
    .accesskey = н

perm-tab =
    .label = Дозволи
    .accesskey = Д
permissions-for =
    .value = Дозволи за:

security-tab =
    .label = Безбедност
    .accesskey = с
security-view =
    .label = Прикажи сертификат
    .accesskey = ф
security-view-unknown = Непознато
    .value = Непознато
security-view-identity =
    .value = Идентитет на мрежно место
security-view-identity-owner =
    .value = Сопственик:
security-view-identity-domain =
    .value = Мрежно место:
security-view-identity-verifier =
    .value = Проверено од:
security-view-identity-validity =
    .value = Истекува на:
security-view-privacy =
    .value = Приватност и историја

security-view-privacy-history-value = Сум го посетил ли ова мрежно место пред денес?

security-view-privacy-clearsitedata =
    .label = Исчисти колачиња и податоци за мрежно место
    .accesskey = И

security-view-privacy-passwords-value = Дали снимив некои лозинки за оваа страница?

security-view-privacy-viewpasswords =
    .label = Прикажи снимени лозинки
    .accesskey = р
security-view-technical =
    .value = Технички детали

help-button =
    .label = Помош

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

image-size-unknown = Непозната
page-info-not-specified =
    .value = Неодредено
not-set-alternative-text = Неодредено
not-set-date = Неодредено
media-img = Слика
media-bg-img = Позадина
media-border-img = Граница
media-list-img = Точка
media-cursor = Покажувач
media-object = Објект
media-embed = Џебно
media-link = Икона
media-input = Инпут
media-video = Видео
media-audio = Аудио
saved-passwords-yes = Да
saved-passwords-no = Не

no-page-title =
    .value = Безимена страница:
general-quirks-mode =
    .value = Чуден режим
general-strict-mode =
    .value = Во согласност со стандардите
page-info-security-no-owner =
    .value = Ова мрежно место не доставува информации за сопственост
media-select-folder = Одберете папка за снимање на слики
media-unknown-not-cached =
    .value = Непознато (не е во кеш)
permissions-use-default =
    .label = Користи основни
security-no-visits = Не

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } слика

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (размер { $scaledx }px × { $scaledy }px)

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
    .label = Блокирај слики од { $website }
    .accesskey = Б

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Инфомации за страницата - { $website }
page-info-frame =
    .title = Информации за рамката - { $website }
