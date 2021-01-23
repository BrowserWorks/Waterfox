# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


close-button =
    .aria-label = Закрыць

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Наладжванні
           *[other] Перавагі
        }

pane-compose-title = Укладанне
category-compose =
    .tooltiptext = Укладанне

pane-chat-title = Гутарка
category-chat =
    .tooltiptext = Гутарка

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = Пачатковая старонка { -brand-short-name }

start-page-label =
    .label = Паказваць пачатковую старонку ў абсягу ліста, калі { -brand-short-name } запускаецца
    .accesskey = б

location-label =
    .value = Месцазнаходжанне(і):
    .accesskey = е
restore-default-label =
    .label = Узнавіць першапачатковую
    .accesskey = У

default-search-engine = Прадвызначаны пашукавік

new-message-arrival = Калі прыбываюць новыя лісты:
mail-play-button =
    .label = Граць
    .accesskey = Г

change-dock-icon = Змянненне перавагаў значка прыстасавання
app-icon-options =
    .label = Наладжванні значка прыстасавання…
    .accesskey = д

animated-alert-label =
    .label = Паказаць папярэджанне
    .accesskey = П
customize-alert-label =
    .label = Наладзіць…
    .accesskey = Н

tray-icon-label =
    .label = Паказаць значок у латку
    .accesskey = л

mail-custom-sound-label =
    .label = Карыстацца наступным файлам гуку
    .accesskey = К
mail-browse-sound-button =
    .label = Агляд…
    .accesskey = А

enable-gloda-search-label =
    .label = Дазволіць агульныя пошук і стварэнне паказнікаў
    .accesskey = а

allow-hw-accel =
    .label = Выкарыстоўваць, калі можна, апаратнае паскарэнне
    .accesskey = а

mbox-store-label =
    .label = Адзін файл на папку (mbox)
maildir-store-label =
    .label = Адзін файл на паведамленне (maildir)

scrolling-legend = Пракручванне
autoscroll-label =
    .label = Ужываць самапракручванне
    .accesskey = У
smooth-scrolling-label =
    .label = Ужываць плаўнае пракручванне
    .accesskey = У

system-integration-legend = Узаемадзеянне з сістэмай
always-check-default =
    .label = Заўсёды правяраць пры запуску, ці з'яўляецца { -brand-short-name } змоўчным спажыўцом пошты
    .accesskey = ў
check-default-button =
    .label = Праверыць зараз…
    .accesskey = з

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Пошук Windows
       *[other] { "" }
    }

search-integration-label =
    .label = Дазволіць { search-engine-name } шукаць лісты
    .accesskey = Д

config-editor-button =
    .label = Рэдактар наладкі…
    .accesskey = Р

return-receipts-description = Вызначыць, як { -brand-short-name } апрацоўвае квіткі атрымання
return-receipts-button =
    .label = Квіткі атрымання…
    .accesskey = К

update-app-legend = Абнаўленні { -brand-short-name }

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Версія { $version }

automatic-updates-label =
    .label = Самастойнае ўсталяванне абнаўленняў (раіцца: палепшаная бяспека)
    .accesskey = С
check-updates-label =
    .label = Правяраць, ці існуюць абнаўленні, але я сам буду вырашаць, ці ўсталёўваць іх
    .accesskey = П

update-history-button =
    .label = Паказаць гісторыю абнаўленняў
    .accesskey = г

use-service =
    .label = Ужываць фонаваю службу для ўсталявання абналенняў
    .accesskey = У

networking-legend = Злучэнне
proxy-config-description = Наладзіць, як { -brand-short-name } мусіць злучацца з Інтэрнэтам

network-settings-button =
    .label = Наладжванні…
    .accesskey = л

offline-legend = Па-за сеткаю
offline-settings = Наладзіць працу па-за сеткаю

offline-settings-button =
    .label = Па-за сеткаю…
    .accesskey = з

diskspace-legend = Месца на дыску
offline-compact-folder =
    .label = Ушчыльняць усе папкі, калі я захоўваю больш
    .accesskey = ш

compact-folder-size =
    .value = МБ

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Ужываць да
    .accesskey = У

use-cache-after = МБ прасторы для запасніку

##

smart-cache-label =
    .label = Перахапіць кіраванне кэшам
    .accesskey = а

clear-cache-button =
    .label = Ачысціць зараз
    .accesskey = ч

fonts-legend = Шрыфты і колеры

default-font-label =
    .value = Змоўчны шрыфт:
    .accesskey = З

default-size-label =
    .value = Памер:
    .accesskey = П

font-options-button =
    .label = Пашыраны…
    .accesskey = ш

color-options-button =
    .label = Колеры…
    .accesskey = К

display-width-legend = Простатэкставыя лісты

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Адлюстроўваць пачуццезнакі графічна
    .accesskey = ч

display-text-label = Калі адлюстроўваюцца цытаваныя простатэкставыя лісты:

style-label =
    .value = Стыль:
    .accesskey = С

regular-style-item =
    .label = Звычайны
bold-style-item =
    .label = Выразны
italic-style-item =
    .label = Рукапісны
bold-italic-style-item =
    .label = Выразны рукапісны

size-label =
    .value = Памер:
    .accesskey = П

regular-size-item =
    .label = Звычайны
bigger-size-item =
    .label = Большы
smaller-size-item =
    .label = Меншы

quoted-text-color =
    .label = Колер:
    .accesskey = К

search-input =
    .placeholder = Пошук

type-column-label =
    .label = Тып змесціва
    .accesskey = Т

action-column-label =
    .label = Дзеянне
    .accesskey = Д

save-to-label =
    .label = Захоўваць файлы ў
    .accesskey = З

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Выбар…
           *[other] Агляд…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] В
           *[other] А
        }

always-ask-label =
    .label = Заўсёды пытаць мяне, дзе захоўваць файлы
    .accesskey = ў


display-tags-text = Меціны могуць ужывацца для размеркавання вашых лістоў па катэгорыям і надання ім прыярытэтаў.

new-tag-button =
    .label = Стварыць…
    .accesskey = С

edit-tag-button =
    .label = Рэдагаваць…
    .accesskey = Р

delete-tag-button =
    .label = Выдаліць
    .accesskey = В

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

seconds-label = секунд

##

open-msg-label =
    .value = Адкрыць паведамленні ў:

open-msg-tab =
    .label = новай картцы
    .accesskey = к

open-msg-window =
    .label = новым акне
    .accesskey = н

open-msg-ex-window =
    .label = ужо існуючым акне
    .accesskey = і

## Compose Tab

forward-label =
    .value = Накіроўваць лісты:
    .accesskey = Н

inline-label =
    .label = Усярэдзіне

as-attachment-label =
    .label = Як далучэнне

extension-label =
    .label = дадаць пашырэнне да назвы файла
    .accesskey = ф

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Самазахаванне кожныя
    .accesskey = з

auto-save-end = хвілінаў

##

warn-on-send-accel-key =
    .label = Пацвярджаць дасыланне ліста, калі яно выклікана клавіятурным выклічнікам
    .accesskey = в

spellcheck-label =
    .label = Правяраць правапіс перад дасыланнем
    .accesskey = п

spellcheck-inline-label =
    .label = Дазволіць праверку правапісу падчас набору
    .accesskey = п

language-popup-label =
    .value = Мова:
    .accesskey = М

download-dictionaries-link = Загрузіць іншыя слоўнікі

font-label =
    .value = Шрыфт:
    .accesskey = Ш

font-color-label =
    .value = Колер тэксту:
    .accesskey = т

bg-color-label =
    .value = Колер фону:
    .accesskey = ф

restore-html-label =
    .label = Аднавіць змоўчныя
    .accesskey = А

format-description = Наладжванне паводзінаў пры фарматаванні тэксту

send-options-label =
    .label = Наладжванні дасылання…
    .accesskey = с

autocomplete-description = Калі адрасуюцца лісты, шукаць адпаведныя запісы:

ab-label =
    .label = У мясцовых адрасных кнігах
    .accesskey = м

directories-label =
    .label = На паслугачу дырэкторыяў:
    .accesskey = д

directories-none-label =
    .none = Няма

edit-directories-label =
    .label = Рэдагаваць дырэкторыі…
    .accesskey = Р

email-picker-label =
    .label = Самастойна дадаваць выходныя э-паштовыя адрасы ў маю:
    .accesskey = С

default-last-label =
    .none = Апошні выкарыстаны каталог

attachment-label =
    .label = Правяраць, ці адсутнічаюць далучэнні
    .accesskey = д

attachment-options-label =
    .label = Ключавыя словы…
    .accesskey = К

enable-cloud-share =
    .label = Прапанова дзяліцца файламі большымі, чым
cloud-share-size =
    .value = МБ

add-cloud-account =
    .label = Дадаць…
    .accesskey = Д
    .defaultlabel = Дадаць…

remove-cloud-account =
    .label = Прыняць
    .accesskey = П

cloud-account-description = Дадаць новую службу сховішчаў Filelink


## Privacy Tab

mail-content = Змесціва пошты

remote-content-label =
    .label = Дазваляць адлеглае змесціва ў лістах
    .accesskey = Д

exceptions-button =
    .label = Выключэнні…
    .accesskey = ы

remote-content-info =
    .value = Даведацца пра заганы адасаблення адлеглага змесціва

web-content = Сеціўнае змесціва

cookies-label =
    .label = Набываць біркі з пляцовак
    .accesskey = Н

third-party-label =
    .value = Набываць пабочныя біркі:
    .accesskey = ч

third-party-always =
    .label = Заўсёды
third-party-never =
    .label = Ніколі
third-party-visited =
    .label = З наведаных

keep-label =
    .value = Трымаць пакуль:
    .accesskey = Т

keep-expire =
    .label = яны не састарэюць
keep-close =
    .label = Я не закрыю { -brand-short-name }
keep-ask =
    .label = пытаць мяне кожнага разу

cookies-button =
    .label = Паказаць біркі…
    .accesskey = б

passwords-description = { -brand-short-name } можа запомніць паролі для ўсіх вашых рахункаў.

passwords-button =
    .label = Захаваныя паролі…
    .accesskey = З

master-password-description = Галоўны пароль абараняе ўсе вашы паролі - аднак вы мусіце ўвесці яго аднойчы за сэсію.

master-password-label =
    .label = Ужываць галоўны пароль
    .accesskey = г

master-password-button =
    .label = Змяніць галоўны пароль…
    .accesskey = м


junk-description = Прызначэнне змоўчных наладжванняў пошты-лухты. Асаблівыя для рахункаў наладжванні могуць быць вызначаны ў Наладжваннях Рахунку.

junk-label =
    .label = Калі я пазначаю лісты як лухту:
    .accesskey = К

junk-move-label =
    .label = Перамясціць іх у папку "Лухта" рахунку
    .accesskey = е

junk-delete-label =
    .label = Выдаліць іх
    .accesskey = і

junk-read-label =
    .label = Пазначыць лісты, вызначаныя як лухта, прачытанымі
    .accesskey = з

junk-log-label =
    .label = Дазволіць запіс метрыкі прыстасоўных сітаў лухты
    .accesskey = м

junk-log-button =
    .label = Паказаць метрыку
    .accesskey = м

reset-junk-button =
    .label = Скінуць вывучаныя даныя
    .accesskey = д

phishing-description = { -brand-short-name } можа аналізаваць лісты на наяўнасць магчымых э-паштовых ашукаў, адшукваючы прыкметы распаўсюджаных спосабаў падману.

phishing-label =
    .label = Папярэджваць мяне, калі ліст, які я чытаю, падазраецца як э-паштовая ашука
    .accesskey = П

antivirus-description = { -brand-short-name } можа палегчыць антывірусным праграмам аналіз уваходных паштовых лістоў да іх мясцовага захавання.

antivirus-label =
    .label = Дазволіць спажыўцам-антывірусам змяшчаць асобныя ўваходныя лісты ў карантын
    .accesskey = а

certificate-description = Калі паслугач патрабуе маё асабістае пасведчанне:

certificate-auto =
    .label = Выбраць адно самастойна
    .accesskey = с

certificate-ask =
    .label = Пытацца ў мяне кожны раз
    .accesskey = р

ocsp-label =
    .label = Звяртацца да сервера OCSP за пацверджаннем дзейснасці сертыфікатаў
    .accesskey = З

## Chat Tab

startup-label =
    .value = Пасля запуску { -brand-short-name }:
    .accesskey = з

offline-label =
    .label = Трымаць мае гутарковыя рахункі па-за сеткай

auto-connect-label =
    .label = Злучыцца з маімі гутарковымі рахункамі самастойна

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Паведаміць маім сябрам, што я бяздзейны пасля
    .accesskey = в

idle-time-label = хвілінаў бяздзейнасці

##

away-message-label =
    .label = і прызначыць статус "Зніклы" з гэтым паведамленнем:
    .accesskey = ы

send-typing-label =
    .label = Дасылаць апавяшчэнне набору ў гутарках
    .accesskey = н

notification-label = Калі прыбываюць паведамленні, накіраваныя вам:

show-notification-label =
    .label = Паказаць апавяшчэнне
    .accesskey = в

chat-play-sound-label =
    .label = Прайграць гук
    .accesskey = г

chat-play-button =
    .label = Граць
    .accesskey = Г

chat-system-sound-label =
    .label = Змоўчны сістэмны гук для новай пошты
    .accesskey = З

chat-custom-sound-label =
    .label = Карыстацца наступным файлам гуку
    .accesskey = У

chat-browse-sound-button =
    .label = Агляд…
    .accesskey = г

theme-label =
    .value = Тэма:
    .accesskey = Т

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Бурбалкі
style-dark =
    .label = Цёмная
style-paper =
    .label = Лісты паперы
style-simple =
    .label = Простая

preview-label = Перадпрагляд:
no-preview-label = Папярэдні прагляд недаступны

chat-variant-label =
    .value = Варыянт:
    .accesskey = В

chat-header-label =
    .label = Паказваць загаловак
    .accesskey = П

## Preferences UI Search Results

