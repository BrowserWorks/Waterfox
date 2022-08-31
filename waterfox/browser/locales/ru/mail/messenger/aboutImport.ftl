# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = Импорт
export-page-title = Экспорт

## Header

import-start = Инструмент импорта
import-start-title = Импорт настроек или данных из приложения или файла.
import-start-description = Выберите источник, из которого вы хотите импортировать. Позже вам будет предложено выбрать, какие данные необходимо импортировать.
import-from-app = Импорт из приложения
import-file = Импорт из файла
import-file-title = Выберите файл для импорта его содержимого.
import-file-description = Выберите для импорта резервную копию профиля, адресных книг или календарей.
import-address-book-title = Импорт файла адресной книги
import-calendar-title = Импорт файла календаря
export-profile = Экспорт

## Buttons

button-back = Назад
button-continue = Продолжить
button-export = Экспортировать
button-finish = Завершить

## Import from app steps

app-name-thunderbird = Thunderbird
app-name-seamonkey = SeaMonkey
app-name-outlook = Outlook
app-name-becky = Becky! Internet Mail
app-name-apple-mail = Apple Mail
source-thunderbird = Импорт из другой установки { app-name-thunderbird }
source-thunderbird-description = Импорт настроек, фильтров, сообщений и других данных из профиля { app-name-thunderbird }.
source-seamonkey = Импорт из установки { app-name-seamonkey }
source-seamonkey-description = Импорт настроек, фильтров, сообщений и других данных из профиля { app-name-seamonkey }.
source-outlook = Импорт из { app-name-outlook }
source-outlook-description = Импорт учётных записей, адресных книг и сообщений из { app-name-outlook }.
source-becky = Импорт из { app-name-becky }
source-becky-description = Импорт адресных книг и сообщений из { app-name-becky }.
source-apple-mail = Импорт из { app-name-apple-mail }
source-apple-mail-description = Импорт сообщений из { app-name-apple-mail }.
source-file2 = Импорт из файла
source-file-description = Выберите файл для импорта адресных книг, календарей или резервной копии профиля (ZIP-файл).

## Import from file selections

file-profile2 = Импорт резервной копии профиля
file-profile-description = Выберите ранее сохранённый профиль Thunderbird (.zip)
file-calendar = Импорт календарей
file-calendar-description = Выберите файл, содержащий экспортированные календари или события (.ics)
file-addressbook = Импорт адресных книг
file-addressbook-description = Выберите файл, содержащий экспортированные адресные книги и контакты.

## Import from app profile steps

from-app-thunderbird = Импорт из профиля { app-name-thunderbird }
from-app-seamonkey = Импорт из профиля { app-name-seamonkey }
from-app-outlook = Импорт из { app-name-outlook }
from-app-becky = Импорт из { app-name-becky }
from-app-apple-mail = Импорт из { app-name-apple-mail }
profiles-pane-title-thunderbird = Импорт настроек и данных из профиля { app-name-thunderbird }.
profiles-pane-title-seamonkey = Импорт настроек и данных из профиля { app-name-seamonkey }.
profiles-pane-title-outlook = Импорт данных из { app-name-outlook }.
profiles-pane-title-becky = Импорт данных из { app-name-becky }.
profiles-pane-title-apple-mail = Импорт сообщений из { app-name-apple-mail }.
profile-source = Импорт из профиля
# $profileName (string) - name of the profile
profile-source-named = Импорт из профиля <strong>«{ $profileName }»</strong>
profile-file-picker-directory = Выберите папку профиля
profile-file-picker-archive = Выберите <strong>ZIP</strong>-файл.
profile-file-picker-archive-description = Размнер ZIP-файла не должен превышать 2 ГБ.
profile-file-picker-archive-title = Выберите ZIP-файл (до 2ГБ)
items-pane-title2 = Выберите, что импортировать:
items-pane-directory = Каталог:
items-pane-profile-name = Имя профиля:
items-pane-checkbox-accounts = Учётные записи и настройки
items-pane-checkbox-address-books = Адресные книги
items-pane-checkbox-calendars = Календари
items-pane-checkbox-mail-messages = Почтовые сообщения
items-pane-override = Любые существующие или идентичные данные не будут перезаписаны.

## Import from address book file steps

import-from-addr-book-file-description = Выберите формат файла, содержащего данные вашей адресной книги.
addr-book-csv-file = Файл данных, разделенных запятыми или табуляциями (.csv, .tsv)
addr-book-ldif-file = LDIF-файл (.ldif)
addr-book-vcard-file = vCard-файл (.vcf, .vcard)
addr-book-sqlite-file = Файл базы данных SQLite (.sqlite)
addr-book-mab-file = Файл базы данных Mork (.mab)
addr-book-file-picker = Выберите файл адресной книги
addr-book-csv-field-map-title = Сопоставление имен полей
addr-book-csv-field-map-desc = Выберите поля адресной книги, соответствующие полям источника. Снимите флажки с полей, которые не хотите импортировать.
addr-book-directories-title = Выберите, куда импортировать выбранные данные
addr-book-directories-pane-source = Исходный файл:
# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = Создать новый каталог с именем <strong>«{ $addressBookName }»</strong>
# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = Импорт выбранных данных в каталог «{ $addressBookName }»
# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = Будет создана новая адресная книга с именем «{ $addressBookName }».

## Import from calendar file steps

import-from-calendar-file-desc = Выберите файл iCalendar (.ics), который вы хотите импортировать.
calendar-items-title = Выберите элементы для импорта.
calendar-items-loading = Загрузка элементов…
calendar-items-filter-input =
    .placeholder = Фильтр элементов…
calendar-select-all-items = Выделить все
calendar-deselect-all-items = Снять выделение со всех
calendar-target-title = Выберите, куда импортировать выбранные объекты.
# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = Создать новый календарь с именем <strong>«{ $targetCalendar }»</strong>
# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
    { $itemCount ->
        [one] Импорт { $itemCount } элемента в календарь «{ $targetCalendar }»
        [few] Импорт { $itemCount } элементов в календарь «{ $targetCalendar }»
       *[many] Импорт { $itemCount } элементов в календарь «{ $targetCalendar }»
    }
# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = Будет создан новый календарь с именем «{ $targetCalendar }».

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = Импорт… { $progressPercent }
# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = Экспорт… { $progressPercent }
progress-pane-finished-desc2 = Завершен.
error-pane-title = Ошибка
error-message-zip-file-too-big2 = Размер выбранного ZIP-файла превышает 2 ГБ. Пожалуйста, сначала распакуйте его, а затем импортируйте из распакованной папки.
error-message-extract-zip-file-failed2 = Не удалось распаковать ZIP-файл. Распакуйте его вручную, а затем импортируйте из распакованной папки.
error-message-failed = В процессе импорта произошёл непредвиденный сбой. Более подробная информация может быть доступна в Консоли ошибок.
error-failed-to-parse-ics-file = В файле не найдены элементы для импорта.
error-export-failed = В процессе экспорта произошёл непредвиденный сбой. Более подробная информация может быть доступна в Консоли ошибок.
error-message-no-profile = Профиль не найден.

## <csv-field-map> element

csv-first-row-contains-headers = Первая строка содержит заголовки полей
csv-source-field = Исходное поле
csv-source-first-record = Первая запись
csv-source-second-record = Вторая запись
csv-target-field = Поле адресной книги

## Export tab

export-profile-title = Экспорт учётных записей, сообщений, адресных книг и настроек в ZIP-файл.
export-profile-description = Если размер вашего текущего профиля превышает 2ГБ, мы рекомендуем вам создать его резервную копию самостоятельно.
export-open-profile-folder = Открыть папку профиля
export-file-picker2 = Экспорт в ZIP-файл
export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = Данные для импорта
summary-pane-start = Начать импорт
summary-pane-warning = После завершения импорта будет необходимо перезапустить { -brand-product-name }.
summary-pane-start-over = Перезапуск инструмента импорта

## Footer area

footer-help = Нужна помощь?
footer-import-documentation = Документация по импорту
footer-export-documentation = Документация по экспорту
footer-support-forum = Форум поддержки

## Step navigation on top of the wizard pages

step-list =
    .aria-label = Пошаговый импорт
step-confirm = Подтвердить
# Variables:
# $number (number) - step number
step-count = { $number }
