# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Закрыть
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Настройки
           *[other] Настройки
        }
preferences-tab-title =
    .title = Настройки
preferences-doc-title = Настройки
category-list =
    .aria-label = Категории
pane-general-title = Основные
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = Составление
category-compose =
    .tooltiptext = Составление
pane-privacy-title = Приватность и защита
category-privacy =
    .tooltiptext = Приватность и защита
pane-chat-title = Чат
category-chat =
    .tooltiptext = Чат
pane-calendar-title = Календарь
category-calendar =
    .tooltiptext = Календарь
general-language-and-appearance-header = Язык и внешний вид
general-incoming-mail-header = Входящие сообщения
general-files-and-attachment-header = Файлы и вложения
general-tags-header = Метки
general-reading-and-display-header = Чтение и отображение
general-updates-header = Обновления
general-network-and-diskspace-header = Сеть и дисковое пространство
general-indexing-label = Индексация
composition-category-header = Составление
composition-attachments-header = Вложения
composition-spelling-title = Орфография
compose-html-style-title = HTML-стиль
composition-addressing-header = Адресация
privacy-main-header = Приватность
privacy-passwords-header = Пароли
privacy-junk-header = Спам
collection-header = Сбор и использование данных { -brand-short-name }
collection-description = Мы стремимся предоставить вам выбор и собирать только то, что нам нужно, для выпуска и улучшения { -brand-short-name } для всех и каждого. Мы всегда спрашиваем разрешения перед получением личной информации.
collection-privacy-notice = Уведомление о конфиденциальности
collection-health-report-telemetry-disabled = Вы больше не разрешаете { -vendor-short-name } собирать технические данные и данные взаимодействия. Все собранные ранее данные будут удалены в течение 30 дней.
collection-health-report-telemetry-disabled-link = Подробнее
collection-health-report =
    .label = Разрешить { -brand-short-name } отправлять технические данные и данные взаимодействия в { -vendor-short-name }
    .accesskey = е
collection-health-report-link = Подробнее
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Для этой конфигурации сборки отправка данных отключена
collection-backlogged-crash-reports =
    .label = Разрешить { -brand-short-name } отправлять от вашего имени накопившиеся сообщения о падении
    .accesskey = ш
collection-backlogged-crash-reports-link = Подробнее
privacy-security-header = Защита
privacy-scam-detection-title = Обнаружение мошенничества
privacy-anti-virus-title = Антивирус
privacy-certificates-title = Сертификаты
chat-pane-header = Чат
chat-status-title = Статус
chat-notifications-title = Уведомления
chat-pane-styling-header = Стили
choose-messenger-language-description = Выберите язык отображения меню, сообщений и уведомлений от { -brand-short-name }.
manage-messenger-languages-button =
    .label = Выбрать альтернативные…
    .accesskey = ы
confirm-messenger-language-change-description = Перезапустите { -brand-short-name } для применения этих изменений
confirm-messenger-language-change-button = Применить и перезапустить
update-setting-write-failure-title = Ошибка при сохранении настроек обновления
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } столкнулся с ошибкой и не смог сохранить это изменение. Обратите внимание, что для установки этой настройки обновления необходимо разрешение на запись в файл, указанный ниже. Вы или системный администратор можете исправить эту проблему, если предоставите группе «Пользователи» полный доступ к этому файлу.
    
    Не удалось произвести запись в файл: { $path }
update-in-progress-title = Идёт обновление
update-in-progress-message = Вы хотите продолжить обновление { -brand-short-name }?
update-in-progress-ok-button = &Отменить
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Продолжить
addons-button = Расширения и темы
account-button = Параметры учётной записи
open-addons-sidebar-button = Дополнения и темы

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Чтобы создать мастер-пароль, введите ваши учётные данные для входа в Windows. Это поможет защитить безопасность ваших аккаунтов.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = создать мастер-пароль
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Чтобы создать мастер-пароль, введите ваши учётные данные для входа в Windows. Это поможет защитить безопасность ваших аккаунтов.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = создать мастер-пароль
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend = Стартовая страница { -brand-short-name }
start-page-label =
    .label = Показывать стартовую страницу в области просмотра сообщения при запуске { -brand-short-name }
    .accesskey = ы
location-label =
    .value = Адрес:
    .accesskey = е
restore-default-label =
    .label = Восстановить
    .accesskey = н
default-search-engine = Поисковая система по умолчанию
add-search-engine =
    .label = Добавить из файла
    .accesskey = й
remove-search-engine =
    .label = Удалить
    .accesskey = л
minimize-to-tray-label =
    .label = При сворачивании перемещать { -brand-short-name } в системный трей
    .accesskey = ч
new-message-arrival = При появлении новых сообщений:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Воспроизвести следующий звуковой файл:
           *[other] Подавать звуковой сигнал
        }
    .accesskey =
        { PLATFORM() ->
            [macos] а
           *[other] в
        }
mail-play-button =
    .label = Прослушать
    .accesskey = ш
change-dock-icon = Изменить настройки значка приложения
app-icon-options =
    .label = Настройки значка приложения…
    .accesskey = ж
notification-settings = Уведомления и звук по умолчанию могут быть отключены на Панели Уведомления в «Системных настройках».
animated-alert-label =
    .label = Показывать уведомление
    .accesskey = к
customize-alert-label =
    .label = Настроить…
    .accesskey = и
tray-icon-label =
    .label = Показать значок в трее
    .accesskey = о
biff-use-system-alert =
    .label = Использовать системные уведомления
tray-icon-unread-label =
    .label = Показывать значок в трее для непрочитанных сообщений
    .accesskey = а
tray-icon-unread-description = Рекомендуется при использовании маленьких кнопок панели задач
mail-system-sound-label =
    .label = Системный звуковой сигнал о приходе почты
    .accesskey = м
mail-custom-sound-label =
    .label = Использовать следующий звуковой файл
    .accesskey = з
mail-browse-sound-button =
    .label = Обзор…
    .accesskey = б
enable-gloda-search-label =
    .label = Включить глобальный поиск и индексацию сообщений
    .accesskey = с
datetime-formatting-legend = Формат даты и времени
language-selector-legend = Язык
allow-hw-accel =
    .label = По возможности использовать аппаратное ускорение
    .accesskey = м
store-type-label =
    .value = Тип хранилища сообщений для новых учётных записей:
    .accesskey = л
mbox-store-label =
    .label = Каждая папка в отдельном файле (mbox)
maildir-store-label =
    .label = Каждое сообщение в отдельном файле (maildir)
scrolling-legend = Прокрутка
autoscroll-label =
    .label = Использовать автоматическую прокрутку
    .accesskey = ь
smooth-scrolling-label =
    .label = Использовать плавную прокрутку
    .accesskey = с
system-integration-legend = Интеграция с системой
always-check-default =
    .label = Всегда проверять при запуске, является ли { -brand-short-name } почтовым клиентом по умолчанию
    .accesskey = и
check-default-button =
    .label = Проверить сейчас…
    .accesskey = е
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Поиску Windows
       *[other] { "" }
    }
search-integration-label =
    .label = Разрешить { search-engine-name } производить поиск сообщений
    .accesskey = а
config-editor-button =
    .label = Редактор настроек…
    .accesskey = о
return-receipts-description = Определите, как { -brand-short-name } должен обрабатывать уведомления о прочтении
return-receipts-button =
    .label = Уведомления о прочтении…
    .accesskey = ч
update-app-legend = Обновления { -brand-short-name }
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Версия { $version }
allow-description = Разрешить { -brand-short-name }
automatic-updates-label =
    .label = Автоматически устанавливать обновления (рекомендовано: повышает безопасность)
    .accesskey = и
check-updates-label =
    .label = Проверять наличие обновлений, но позволять мне решать, устанавливать ли их или нет
    .accesskey = о
update-history-button =
    .label = Показать журнал обновлений
    .accesskey = й
use-service =
    .label = Использовать фоновую службу для установки обновлений
    .accesskey = у
cross-user-udpate-warning = Этот параметр применится ко всем учётным записям Windows и профилям { -brand-short-name }, использующим эту установку { -brand-short-name }.
networking-legend = Соединение
proxy-config-description = Настройка параметров соединения { -brand-short-name } с Интернетом
network-settings-button =
    .label = Настроить…
    .accesskey = а
offline-legend = Автономная работа
offline-settings = Настройка параметров автономной работы
offline-settings-button =
    .label = Автономная работа…
    .accesskey = в
diskspace-legend = Дисковое пространство
offline-compact-folder =
    .label = Сжимать все папки, если при этом освободится всего более
    .accesskey = э
compact-folder-size =
    .value = МБ

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Использовать до
    .accesskey = ь
use-cache-after = МБ на диске для кэша

##

smart-cache-label =
    .label = Отключить автоматическое управление кэшем
    .accesskey = ю
clear-cache-button =
    .label = Очистить сейчас
    .accesskey = о
fonts-legend = Шрифты и цвета
default-font-label =
    .value = Шрифт по умолчанию:
    .accesskey = и
default-size-label =
    .value = Размер:
    .accesskey = м
font-options-button =
    .label = Дополнительно…
    .accesskey = о
color-options-button =
    .label = Цвета…
    .accesskey = а
display-width-legend = Простые текстовые сообщения
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Отображать смайлики как графику
    .accesskey = б
display-text-label = При отображении цитат в простых текстовых сообщениях:
style-label =
    .value = Стиль:
    .accesskey = л
regular-style-item =
    .label = Обычный
bold-style-item =
    .label = Полужирный
italic-style-item =
    .label = Курсив
bold-italic-style-item =
    .label = Полужирный курсив
size-label =
    .value = Размер:
    .accesskey = з
regular-size-item =
    .label = Обычный
bigger-size-item =
    .label = Больше
smaller-size-item =
    .label = Меньше
quoted-text-color =
    .label = Цвет:
    .accesskey = в
search-input =
    .placeholder = Поиск
search-handler-table =
    .placeholder = Фильтр типов контента и действий
type-column-label =
    .label = Тип содержимого
    .accesskey = о
action-column-label =
    .label = Действие
    .accesskey = е
save-to-label =
    .label = Путь для сохранения файлов
    .accesskey = х
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Выбрать…
           *[other] Обзор…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ы
           *[other] б
        }
always-ask-label =
    .label = Всегда выдавать запрос на сохранение файлов
    .accesskey = п
display-tags-text = Метки могут быть использованы для классификации и изменения приоритета сообщений.
new-tag-button =
    .label = Создать…
    .accesskey = о
edit-tag-button =
    .label = Изменить…
    .accesskey = е
delete-tag-button =
    .label = Удалить
    .accesskey = и
auto-mark-as-read =
    .label = Автоматически отмечать сообщения как прочитанные
    .accesskey = в
mark-read-no-delay =
    .label = Сразу после открытия
    .accesskey = а

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = После просмотра в течение
    .accesskey = т
seconds-label = сек.

##

open-msg-label =
    .value = Открывать сообщения в:
open-msg-tab =
    .label = новой вкладке
    .accesskey = к
open-msg-window =
    .label = новом окне
    .accesskey = о
open-msg-ex-window =
    .label = уже существующем окне
    .accesskey = ж
close-move-delete =
    .label = Закрывать окно/вкладку сообщения при его перемещении или удалении
    .accesskey = к
display-name-label =
    .value = Отображаемое имя:
condensed-addresses-label =
    .label = Показывать только имя для людей, находящихся в моей адресной книге
    .accesskey = к

## Compose Tab

forward-label =
    .value = Пересылать сообщения:
    .accesskey = с
inline-label =
    .label = Внутри сообщения
as-attachment-label =
    .label = Как вложение
extension-label =
    .label = добавлять расширение к имени файла
    .accesskey = ф

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Автоматически сохранять сообщение каждые
    .accesskey = х
auto-save-end = минут

##

warn-on-send-accel-key =
    .label = Запрашивать подтверждение при использовании сочетаний клавиш для отправки сообщений
    .accesskey = п
spellcheck-label =
    .label = Проверять орфографию перед отправкой сообщения
    .accesskey = г
spellcheck-inline-label =
    .label = Проверять орфографию при наборе текста
    .accesskey = н
language-popup-label =
    .value = Язык:
    .accesskey = з
download-dictionaries-link = Загрузить дополнительные словари
font-label =
    .value = Шрифт:
    .accesskey = р
font-size-label =
    .value = Размер:
    .accesskey = е
default-colors-label =
    .label = Использовать цвета пользователя по умолчанию
    .accesskey = ь
font-color-label =
    .value = Цвет текста:
    .accesskey = т
bg-color-label =
    .value = Цвет фона:
    .accesskey = в
restore-html-label =
    .label = Восстановить значения по умолчанию
    .accesskey = м
default-format-label =
    .label = Использовать формат Абзаца вместо Обычного текста по умолчанию
    .accesskey = п
format-description = Текстовый формат:
send-options-label =
    .label = Параметры отправки…
    .accesskey = т
autocomplete-description = При вводе адреса искать подходящие почтовые адреса в:
ab-label =
    .label = Локальных адресных книгах
    .accesskey = к
directories-label =
    .label = Сервере каталогов:
    .accesskey = р
directories-none-label =
    .none = Нет
edit-directories-label =
    .label = Изменить каталоги…
    .accesskey = з
email-picker-label =
    .label = Автоматически добавлять адреса из исходящих писем в адресную книгу:
    .accesskey = в
default-directory-label =
    .value = Каталог по умолчанию при открытии окна адресной книги:
    .accesskey = ю
default-last-label =
    .none = Последний использованный каталог
attachment-label =
    .label = Проверять на забытые вложения
    .accesskey = в
attachment-options-label =
    .label = Ключевые слова…
    .accesskey = л
enable-cloud-share =
    .label = Предлагать службу хранения для файлов больше чем
cloud-share-size =
    .value = МБ
add-cloud-account =
    .label = Добавить…
    .accesskey = в
    .defaultlabel = Добавить…
remove-cloud-account =
    .label = Удалить
    .accesskey = д
find-cloud-providers =
    .value = Найти больше провайдеров…
cloud-account-description = Добавить новую службу хранения Filelink

## Privacy Tab

mail-content = Содержимое электронной почты
remote-content-label =
    .label = Разрешить в сообщениях показ содержимого из Интернета
    .accesskey = а
exceptions-button =
    .label = Исключения…
    .accesskey = к
remote-content-info =
    .value = Узнайте больше о приватности содержимого из Интернета
web-content = Содержимое веб-сайтов
history-label =
    .label = Помнить посещённые мной веб-сайты и ссылки
    .accesskey = м
cookies-label =
    .label = Принимать куки с сайтов
    .accesskey = н
third-party-label =
    .value = Принимать куки со сторонних сайтов:
    .accesskey = и
third-party-always =
    .label = Всегда
third-party-never =
    .label = Никогда
third-party-visited =
    .label = С посещённых
keep-label =
    .value = Сохранять куки:
    .accesskey = я
keep-expire =
    .label = до истечения срока их действия
keep-close =
    .label = до закрытия мною { -brand-short-name }
keep-ask =
    .label = спрашивать каждый раз
cookies-button =
    .label = Показать куки…
    .accesskey = з
do-not-track-label =
    .label = Отправлять веб-сайтам сигнал «Не отслеживать», означающий, чтобы вы не хотите, чтобы вас отслеживали
    .accesskey = я
learn-button =
    .label = Подробнее
passwords-description = { -brand-short-name } может запоминать пароли всех ваших учётных записей.
passwords-button =
    .label = Сохранённые пароли…
    .accesskey = х
master-password-description = Мастер-пароль защищает все ваши пароли, но вам нужно будет вводить его один раз в сессию.
master-password-label =
    .label = Использовать мастер-пароль
    .accesskey = о
master-password-button =
    .label = Сменить мастер-пароль…
    .accesskey = е
primary-password-description = Мастер-пароль защищает все ваши пароли, но вам нужно будет вводить его один раз в сессию.
primary-password-label =
    .label = Использовать мастер-пароль
    .accesskey = п
primary-password-button =
    .label = Сменить мастер-пароль…
    .accesskey = м
forms-primary-pw-fips-title = Вы работаете в режиме соответствия FIPS. При работе в этом режиме необходимо установить мастер-пароль.
forms-master-pw-fips-desc = Смена пароля не удалась
junk-description = Здесь вы можете установить настройки анти-спам фильтра по умолчанию. Настройки анти-спам фильтра, специфичные для учётной записи, могут быть установлены в параметрах учётной записи.
junk-label =
    .label = Когда я помечаю сообщения как спам:
    .accesskey = с
junk-move-label =
    .label = Перемещать их в папку «Спам» учётной записи
    .accesskey = м
junk-delete-label =
    .label = Удалять их
    .accesskey = д
junk-read-label =
    .label = Отмечать сообщения, определённые как спам, как прочитанные
    .accesskey = ч
junk-log-label =
    .label = Включить журнал работы адаптивного анти-спам фильтра
    .accesskey = ж
junk-log-button =
    .label = Показать журнал
    .accesskey = к
reset-junk-button =
    .label = Удалить данные обучения
    .accesskey = б
phishing-description = { -brand-short-name } может анализировать сообщения для выявления подозрительных писем, рассылаемых мошенниками, проверяя их на наличие определённых приёмов и техник, используемых для ввода вас в заблуждение.
phishing-label =
    .label = Информировать, не является ли читаемое мною сообщение подозрительным письмом, рассылаемым мошенниками
    .accesskey = ф
antivirus-description = { -brand-short-name } может облегчить работу антивируса по проверке входящих сообщений на наличие вирусов перед тем, как сохранять их в почтовые папки.
antivirus-label =
    .label = Разрешить антивирусу помещать в карантин отдельные входящие сообщения
    .accesskey = в
certificate-description = Когда сервер запрашивает личный сертификат:
certificate-auto =
    .label = Отправлять автоматически
    .accesskey = а
certificate-ask =
    .label = Спрашивать каждый раз
    .accesskey = и
ocsp-label =
    .label = Запрашивать у OCSP-серверов подтверждение текущего статуса сертификатов
    .accesskey = ш
certificate-button =
    .label = Управление сертификатами…
    .accesskey = ф
security-devices-button =
    .label = Устройства защиты…
    .accesskey = ы

## Chat Tab

startup-label =
    .value = При запуске { -brand-short-name }:
    .accesskey = а
offline-label =
    .label = Не подключать учётные записи чата
auto-connect-label =
    .label = Автоматически подключать учётные записи чата

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Уведомить контакты о моём бездействии через
    .accesskey = е
idle-time-label = минут неактивности

##

away-message-label =
    .label = и установить мой статус как «Отошёл» вместе с этим сообщением:
    .accesskey = ш
send-typing-label =
    .label = Отправлять уведомления о вводе в разговорах
    .accesskey = я
notification-label = Когда прибывают направленные вам сообщения:
show-notification-label =
    .label = Отображать уведомление:
    .accesskey = ж
notification-all =
    .label = с именем отправителя и предпросмотром сообщения
notification-name =
    .label = только с именем отправителя
notification-empty =
    .label = без какой-либо информации
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Анимировать иконку в доке
           *[other] Мигать на панели задач
        }
    .accesskey =
        { PLATFORM() ->
            [macos] н
           *[other] и
        }
chat-play-sound-label =
    .label = Подавать звуковой сигнал
    .accesskey = в
chat-play-button =
    .label = Воспроизвести
    .accesskey = п
chat-system-sound-label =
    .label = Системный звуковой сигнал о приходе почты
    .accesskey = м
chat-custom-sound-label =
    .label = Использовать следующий звуковой файл
    .accesskey = о
chat-browse-sound-button =
    .label = Обзор…
    .accesskey = з
theme-label =
    .value = Тема:
    .accesskey = е
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Пузырьки
style-dark =
    .label = Тёмная
style-paper =
    .label = Листы бумаги
style-simple =
    .label = Простая
preview-label = Предпросмотр:
no-preview-label = Предпросмотр недоступен
no-preview-description = Эта тема повреждена или в настоящее время недоступна (отключено дополнение, включен безопасный режим…).
chat-variant-label =
    .value = Вариант:
    .accesskey = а
chat-header-label =
    .label = Отображать заголовок
    .accesskey = ж
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Найти в Настройках
           *[other] Найти в Настройках
        }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-preferences-input =
    .style = width: 15.4em
    .placeholder = Поиск в Настройках

## Preferences UI Search Results

search-results-header = Результаты поиска
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Извините! В настройках не найдено результатов для «<span data-l10n-name="query"></span>».
       *[other] Извините! В настройках не найдено результатов для «<span data-l10n-name="query"></span>».
    }
search-results-help-link = Нужна помощь? Посетите <a data-l10n-name="url">Сайт поддержки { -brand-short-name }</a>
