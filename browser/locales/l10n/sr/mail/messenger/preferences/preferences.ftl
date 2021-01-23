# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Затвори

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Опције
           *[other] Поставке
        }

pane-general-title = Опште
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Састављање
category-compose =
    .tooltiptext = Састављање

pane-privacy-title = Приватност и безбедност
category-privacy =
    .tooltiptext = Приватност и безбедност

pane-chat-title = Ћаскање
category-chat =
    .tooltiptext = Ћаскање

pane-calendar-title = Календар
category-calendar =
    .tooltiptext = Календар

general-language-and-appearance-header = Језик и изглед

general-incoming-mail-header = Долазна пошта

general-files-and-attachment-header = Датотеке и прилози

general-tags-header = Ознаке

general-reading-and-display-header = Читање и приказ

general-updates-header = Ажурирања

general-network-and-diskspace-header = Мрежни и дисковни простор

general-indexing-label = Индексирање

composition-category-header = Састављање

composition-attachments-header = Прилози

composition-spelling-title = Правопис

compose-html-style-title = HTML стил

composition-addressing-header = Адресирање

privacy-main-header = Приватност

privacy-passwords-header = Лозинке

privacy-junk-header = Смеће

collection-privacy-notice = Обавештење о приватности

collection-health-report-telemetry-disabled-link = Сазнајте више

collection-health-report-link = Сазнајте више

collection-backlogged-crash-reports-link = Сазнајте више

privacy-security-header = Безбедност

privacy-scam-detection-title = Откривање превара

privacy-anti-virus-title = Антивирус

privacy-certificates-title = Сертификати

chat-pane-header = Ћаскање

chat-status-title = Статус

chat-notifications-title = Обавештења

chat-pane-styling-header = Стилови

choose-messenger-language-description = Изаберите језике који ће се користити за приказ менија, порука и обавештења у програму { -brand-short-name }.
manage-messenger-languages-button =
    .label = Подеси заменске…
    .accesskey = з
confirm-messenger-language-change-description = Поново покрени { -brand-short-name } за примену ових измена
confirm-messenger-language-change-button = Примени и поново покрени

update-setting-write-failure-title = Грешка приликом чувања подешавања ажурирања

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } је наишао на грешку и промена није сачувана. Напомена: да бисте подесили ово подешавање ажурирања, потребна вам је дозвола за писање у следеће датотеке. Ви или администратор система можда можете исправити грешку тако што ћете групи корисника одобрити потпун приступ овој датотеци.
    
    Није могуће писати у следећу датотеку: { $path }

update-in-progress-title = Ажурирање је у току

update-in-progress-message = Желите ли да { -brand-short-name } настави са овим ажурирањем?

update-in-progress-ok-button = &Одбаци
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Настави

addons-button = Проширења и теме

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = направи главну лозинку

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name } почетна страна

start-page-label =
    .label = Када се { -brand-short-name } покрене, прикажи почетну страну у делу за поруке
    .accesskey = К

location-label =
    .value = Место:
    .accesskey = о
restore-default-label =
    .label = Врати подразумевано
    .accesskey = В

default-search-engine = Подразумевани претраживач
add-search-engine =
    .label = Додајте из датотеке
    .accesskey = Д
remove-search-engine =
    .label = Уклоните
    .accesskey = У

new-message-arrival = Када нове поруке стигну:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Пусти следећу звучну датотеку:
           *[other] Пусти звук
        }
    .accesskey =
        { PLATFORM() ->
            [macos] д
           *[other] з
        }
mail-play-button =
    .label = Пусти
    .accesskey = П

change-dock-icon = Промени поставке за иконицу програма
app-icon-options =
    .label = Опције иконице програма…
    .accesskey = н

notification-settings = Узбуне и подразумевани звук могу бити онемогућени у површи за обавештења системских поставки.

animated-alert-label =
    .label = Прикажи узбуну
    .accesskey = б
customize-alert-label =
    .label = Прилагоди…
    .accesskey = д

tray-icon-label =
    .label = Прикажи иконицу у системској касети
    .accesskey = т

mail-custom-sound-label =
    .label = Користи следећу звучну датотеку
    .accesskey = р
mail-browse-sound-button =
    .label = Преглед…
    .accesskey = л

enable-gloda-search-label =
    .label = Омогући општу претрагу и пописивање
    .accesskey = О

datetime-formatting-legend = Форматирање времена и датума
language-selector-legend = Језик

allow-hw-accel =
    .label = Користи хардверско убрзање када је доступно
    .accesskey = х

store-type-label =
    .value = Врста складишта порука за нове налоге:
    .accesskey = л

mbox-store-label =
    .label = Датотека по фасцикли (mbox)
maildir-store-label =
    .label = Датотека по поруци (maildir)

scrolling-legend = Клизање
autoscroll-label =
    .label = Користи самоклизање
    .accesskey = К
smooth-scrolling-label =
    .label = Користи глатко клизање
    .accesskey = г

system-integration-legend = Интеграција са системом
always-check-default =
    .label = Увек провери да ли је { -brand-short-name } подразумевани поштански клијент при покретању
    .accesskey = в
check-default-button =
    .label = Провери сада…
    .accesskey = с

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows претрага
       *[other] { "" }
    }

search-integration-label =
    .label = Дозволи { search-engine-name } да претражује поруке
    .accesskey = в

config-editor-button =
    .label = Уређивач подешавања…
    .accesskey = п

return-receipts-description = Начин на који { -brand-short-name } барата са потврдама о пријему
return-receipts-button =
    .label = Потврде о пријему…
    .accesskey = П

update-app-legend = { -brand-short-name } ажурирања

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Верзија { $version }

allow-description = Дозволите { -brand-short-name } да
automatic-updates-label =
    .label = Аутоматски инсталирај ажурирања (препоручено: побољшава безбедност)
    .accesskey = А
check-updates-label =
    .label = Провери да ли има ажурирања али мени допусти да изаберем када да се инсталирају
    .accesskey = П

update-history-button =
    .label = Прикажи историјат ажурирања
    .accesskey = П

use-service =
    .label = Користи услугу у позадини за инсталирање ажурирања
    .accesskey = л

cross-user-udpate-warning = Ово подешавање ће утицати на све Windows налоге и { -brand-short-name } профиле који користе ову { -brand-short-name } инсталацију.

networking-legend = Веза
proxy-config-description = Подесите начин на који се { -brand-short-name } повезује на интернет

network-settings-button =
    .label = Подешавања…
    .accesskey = П

offline-legend = Ван мреже
offline-settings = Подесите подешавања рада ван мреже

offline-settings-button =
    .label = Ван мреже…
    .accesskey = В

diskspace-legend = Простор на диску
offline-compact-folder =
    .label = Сажми све фасцикле када се тиме уштеди више од
    .accesskey = а

compact-folder-size =
    .value = мегабајта укупно

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Користи до
    .accesskey = К

use-cache-after = мегабајта простора за кеш

##

smart-cache-label =
    .label = Премости аутоматско управљање кешом
    .accesskey = м

clear-cache-button =
    .label = Очисти сада
    .accesskey = д

fonts-legend = Фонтови и боје

default-font-label =
    .value = Подразумевани фонт:
    .accesskey = д

default-size-label =
    .value = Величина:
    .accesskey = В

font-options-button =
    .label = Напредно…
    .accesskey = Н

color-options-button =
    .label = Боје…
    .accesskey = Б

display-width-legend = Обичне текстуалне поруке

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Прикажи емотиконе као сличице
    .accesskey = е

display-text-label = Приликом цитирања обичних текстуалних порука:

style-label =
    .value = Стил:
    .accesskey = т

regular-style-item =
    .label = Обичан
bold-style-item =
    .label = Подебљан
italic-style-item =
    .label = Искошен
bold-italic-style-item =
    .label = Подебљан искошен

size-label =
    .value = Величина:
    .accesskey = л

regular-size-item =
    .label = Обична
bigger-size-item =
    .label = Већа
smaller-size-item =
    .label = Мања

quoted-text-color =
    .label = Боја:
    .accesskey = о

search-input =
    .placeholder = Претрага

type-column-label =
    .label = Врста садржаја
    .accesskey = т

action-column-label =
    .label = Радња
    .accesskey = д

save-to-label =
    .label = Сачувај датотеке у
    .accesskey = С

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Изабери…
           *[other] Преглед…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] И
           *[other] П
        }

always-ask-label =
    .label = Увек питај где да се сачувају датотеке
    .accesskey = У


display-tags-text = Ознаке се могу користити за сврставање и приоритизацију ваших порука.

new-tag-button =
    .label = Нова…
    .accesskey = Н

edit-tag-button =
    .label = Уреди…
    .accesskey = е

delete-tag-button =
    .label = Обриши
    .accesskey = О

auto-mark-as-read =
    .label = Аутоматски означи поруке као прочитане
    .accesskey = А

mark-read-no-delay =
    .label = Одмах при приказивању
    .accesskey = р

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Након приказивања од
    .accesskey = з

seconds-label = секунди

##

open-msg-label =
    .value = Отвори поруке у:

open-msg-tab =
    .label = Новом језичку
    .accesskey = ј

open-msg-window =
    .label = Новом прозору поруке
    .accesskey = з

open-msg-ex-window =
    .label = Већ постојећем прозору поруке
    .accesskey = к

close-move-delete =
    .label = Затвори прозор/језичак поруке при померању или брисању
    .accesskey = З

display-name-label =
    .value = Име за приказ:

condensed-addresses-label =
    .label = Прикажи само име за приказ за људе у мом именику
    .accesskey = П

## Compose Tab

forward-label =
    .value = Прослеђивање порука:
    .accesskey = л

inline-label =
    .label = Унутар линије

as-attachment-label =
    .label = Као прилог

extension-label =
    .label = додај екстензију на име датотеке
    .accesskey = е

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Аутоматски чувај на
    .accesskey = А

auto-save-end = минута

##

warn-on-send-accel-key =
    .label = Тражи потврду када се порука шаље са пречицом на тастатури
    .accesskey = Т

spellcheck-label =
    .label = Провери правопис пре слања
    .accesskey = в

spellcheck-inline-label =
    .label = Омогући проверу правописа приликом куцања
    .accesskey = г

language-popup-label =
    .value = Језик:
    .accesskey = Ј

download-dictionaries-link = Преузми још речника

font-label =
    .value = Фонт:
    .accesskey = н

font-size-label =
    .value = Величина:
    .accesskey = В

default-colors-label =
    .label = Користите унапред подешену боју читача
    .accesskey = д

font-color-label =
    .value = Боја текста:
    .accesskey = Т

bg-color-label =
    .value = Боја позадине:
    .accesskey = Б

restore-html-label =
    .label = Врати подразумевано
    .accesskey = д

default-format-label =
    .label = Подразумевано користи пасусе уместо текста тела поруке
    .accesskey = П

format-description = Подеси понашање форматирања текста

send-options-label =
    .label = Опције слања…
    .accesskey = с

autocomplete-description = Приликом адресирања порука, тражи одговарајуће уносе у:

ab-label =
    .label = Локалним именицима
    .accesskey = Л

directories-label =
    .label = Сервер фасцикле:
    .accesskey = ф

directories-none-label =
    .none = Ништа

edit-directories-label =
    .label = Уреди фасцикле…
    .accesskey = У

email-picker-label =
    .label = Аутоматски додај одлазне мејл адресе у моје:
    .accesskey = А

default-directory-label =
    .value = Подразумевана почетна фасцикла у прозору именика:
    .accesskey = з

default-last-label =
    .none = Последње коришћена фасцикла

attachment-label =
    .label = Провери да ли недостају прилози
    .accesskey = ј

attachment-options-label =
    .label = Кључне речи…
    .accesskey = К

enable-cloud-share =
    .label = Понуди дељење за датотеке веће од
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Додај…
    .accesskey = ј
    .defaultlabel = Додај…

remove-cloud-account =
    .label = Уклони
    .accesskey = У

find-cloud-providers =
    .value = Пронађите више провајдера…

cloud-account-description = Додај нову Filelink услугу складиштења


## Privacy Tab

mail-content = Садржај поште

remote-content-label =
    .label = Дозволи удаљени садржај у порукама
    .accesskey = д

exceptions-button =
    .label = Изузеци…
    .accesskey = И

remote-content-info =
    .value = Сазнајте више о проблемима приватности код удаљеног садржаја

web-content = Веб садржај

history-label =
    .label = Памти веб странице и везе које сам посетио
    .accesskey = м

cookies-label =
    .label = Прихватај колачиће са страница
    .accesskey = х

third-party-label =
    .value = Прихватај колачиће трећих странки:
    .accesskey = л

third-party-always =
    .label = Увек
third-party-never =
    .label = Никада
third-party-visited =
    .label = Са посећених

keep-label =
    .value = Чувај док:
    .accesskey = в

keep-expire =
    .label = они не истекну
keep-close =
    .label = Док не затворим { -brand-short-name }
keep-ask =
    .label = питај ме сваки пут

cookies-button =
    .label = Прикажи колачиће…
    .accesskey = р

do-not-track-label =
    .label = Пошаљите веб страници сигнал “Не прати” који показује да не желите да вас прате
    .accesskey = н

learn-button =
    .label = Сазнајте више

passwords-description = { -brand-short-name } може памтити лозинке за све ваше налоге.

passwords-button =
    .label = Сачуване лозинке…
    .accesskey = С

master-password-description = Главна лозинка може заштити све ваше лозинке али је морате уносити једном по сесији.

master-password-label =
    .label = Користи главну лозинку
    .accesskey = р

master-password-button =
    .label = Промени главну лозинку…
    .accesskey = м


junk-description = Поставите ваша подразумевана подешавања непожељне поште. Специфична подешавања за сваки налог понаособ можете поставити у подешавањима тог налога.

junk-label =
    .label = Када означим поруке као непожељне:
    .accesskey = К

junk-move-label =
    .label = Помери их у фасциклу "Непожељно" тог налога
    .accesskey = о

junk-delete-label =
    .label = Обриши их
    .accesskey = б

junk-read-label =
    .label = Означи поруке за које је утврђено да су непожељне као прочитане
    .accesskey = О

junk-log-label =
    .label = Омогући записивање адаптивног филтрирања непожељног
    .accesskey = г

junk-log-button =
    .label = Прикажи записник
    .accesskey = и

reset-junk-button =
    .label = Ресетуј податке тренирања
    .accesskey = н

phishing-description = { -brand-short-name } може да проучава поруке тако да тражи оне поруке које садрже честе технике којима се преваранти служе да би вас преварили.

phishing-label =
    .label = Кажи ми ако порука коју читам делује као поштанска превара
    .accesskey = К

antivirus-description = { -brand-short-name } може олакшати вашем антивирусу анализирање долазне поште на вирусе пре него што се они ускладиште локално.

antivirus-label =
    .label = Дозволи антивирусима да ставе појединачне долазне поруке у карантин
    .accesskey = Д

certificate-description = Када сервер затражи мој лични сертификат:

certificate-auto =
    .label = Изабери један аутоматски
    .accesskey = б

certificate-ask =
    .label = Питај ме сваки пут
    .accesskey = в

ocsp-label =
    .label = Упитај OCSP сервер за одговарање да би потврдио тренутну исправност сертификата
    .accesskey = У

certificate-button =
    .label = Управљајте сертификатима…
    .accesskey = У

security-devices-button =
    .label = Сигурносни уређаји…
    .accesskey = С

## Chat Tab

startup-label =
    .value = Када се { -brand-short-name } покрене:
    .accesskey = п

offline-label =
    .label = Остави моје налоге ћаскања ван мреже

auto-connect-label =
    .label = Повежи моје налоге ћаскања аутоматски

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Покажи мојим контактима да сам у мировању након
    .accesskey = к

idle-time-label = минута неактивности

##

away-message-label =
    .label = и подеси моје стање у „Ван рачунара“ са овом поруком стања:
    .accesskey = д

send-typing-label =
    .label = Шаљи обавештења о куцању у разговорима
    .accesskey = к

notification-label = Када порука адресирана на вас стигне:

show-notification-label =
    .label = Прикажи обавештење:
    .accesskey = в

notification-all =
    .label = са именом пошиљаоца и прегледом поруке
notification-name =
    .label = само са именом пошиљаоца
notification-empty =
    .label = без било каквог податка

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Анимирај иконицу у доку
           *[other] Затрепери ставку у траци задатака
        }
    .accesskey =
        { PLATFORM() ->
            [macos] н
           *[other] З
        }

chat-play-sound-label =
    .label = Пусти звук
    .accesskey = т

chat-play-button =
    .label = Пусти
    .accesskey = П

chat-system-sound-label =
    .label = Подразумевани системски звук за нову поруку
    .accesskey = з

chat-custom-sound-label =
    .label = Користи следећу звучну датотеку
    .accesskey = К

chat-browse-sound-button =
    .label = Преглед…
    .accesskey = П

theme-label =
    .value = Тема:
    .accesskey = Т

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Балончићи
style-dark =
    .label = Тама
style-paper =
    .label = Листови папира
style-simple =
    .label = Једноставност

preview-label = Претпреглед:
no-preview-label = Нема претпрегледа
no-preview-description = Ова тема није исправна или није тренутно доступна (онемогућен додатак, безбедни режим, …).

chat-variant-label =
    .value = Варијанта:
    .accesskey = В

chat-header-label =
    .label = Прикажи заглавље
    .accesskey = г

## Preferences UI Search Results

search-results-header = Резултати претраге

## Preferences UI Search Results

