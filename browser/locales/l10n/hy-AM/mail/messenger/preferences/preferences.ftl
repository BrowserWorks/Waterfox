# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Փակել

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Կարգավորումներ
           *[other] Կարգավորումներ…
        }

pane-general-title = Գլխավոր
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Նամակը
category-compose =
    .tooltiptext = Նամակը

pane-privacy-title = Գաղտնիություն և անվտանգություն
category-privacy =
    .tooltiptext = Գաղտնիություն և անվտանգություն

pane-chat-title = Զրույց
category-chat =
    .tooltiptext = Զրույց

pane-calendar-title = Օրացույց
category-calendar =
    .tooltiptext = Օրացույց

general-language-and-appearance-header = Լեզուն և տեսքը

general-incoming-mail-header = Մուտքային նամակներ

general-files-and-attachment-header = Նիշքեր և հավելվածներ

general-tags-header = Պիտակներ

general-reading-and-display-header = Ընթերցանություն և ցուցադրում

general-updates-header = Թարմացումներ

general-network-and-diskspace-header = Ցանցի և սկավառակի տարածություն

general-indexing-label = Դասում

composition-category-header = Կազմվածք

composition-attachments-header = Կցորդներ

composition-spelling-title = Ուղղագրություն

compose-html-style-title = HTML ոճ

composition-addressing-header = Հասցեագրում

privacy-main-header = Գաղտնիություն

privacy-passwords-header = Գաղտնաբառեր

privacy-junk-header = Թափոն

collection-header = { -brand-short-name } տվյալների հավաքում և օգտագործում

collection-description = Մենք փորձում ենք տրամադրել ձեզ ընտրություն և հավաքել միայն այն, ինչ մեզ պետք է { -brand-short-name }-ը բարելավելու համար: ՄԵնք միշտ հարցնում ենք թույլտվությյուն՝ մինչև անձնական տեղեկություններ ստանալը:
collection-privacy-notice = Գաղտնիության ծանուցում

collection-health-report-telemetry-disabled = Դուք այլևս թույլ չեք տալիս { -vendor-short-name }֊ին կորզել տեխնիկական և փոխգործակցության տվյալներ։ Անցյալ բոլոր տվյալները կջնջվեն 30 օրվա ընթացքում։
collection-health-report-telemetry-disabled-link = Իմանալ ավելին

collection-health-report =
    .label = Թույլատրել { -brand-short-name }-ին ուղարկել տեխնիկական և փոխգործակցության տվյալներ { -vendor-short-name }-ին
    .accesskey = r
collection-health-report-link = Իմանալ ավելին

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Տվյալների զեկուցումը անջատված է կազմաձևի այս կառուցման համար

collection-backlogged-crash-reports =
    .label = Թույլատրե՞լ { -brand-short-name }-ին ուղարկել հետին վթարի զեկուցներ առանց հարցնելու:
    .accesskey = c
collection-backlogged-crash-reports-link = Իմանալ ավելին

privacy-security-header = Անվտանգություն

privacy-scam-detection-title = Խաբեության հայտնաբերում

privacy-anti-virus-title = Հակավիրուս

privacy-certificates-title = Վկայագրեր

chat-pane-header = Զրույց

chat-status-title = Վիճակ

chat-notifications-title = Ծանուցումներ

chat-pane-styling-header = Ոճավորում

choose-messenger-language-description = Ընտրեք օգտագործված լեզուները ցանկերը, հաղորդագրություններ և ծանուցումները { -brand-short-name }-ից ցուցադրելու համար։
manage-messenger-languages-button =
    .label = Սահմանել այլընտրանքներ…
    .accesskey = I
confirm-messenger-language-change-description = Այս փոփոխությունները կիրառելու համար վերագործարկեք { -brand-short-name }
confirm-messenger-language-change-button = Գործադրել և վերագործարկել

update-setting-write-failure-title = Նախընտրությունների թարմեցման Սխալ

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message = { -brand-short-name } բախվել է սխալի և չի պահպանել այս փոփոխությունը։ Նկատի ունեցեք, որ այս թարմացման նախընտրանքի կարգավորումը պահանջում է թույլատվություն ստորին նիշքում գրելու համար։ Դուք կամ համակարգի վարիչը կարող եք լուծել սխալը օգտագործողների խմբին շնորհելով այս նիշքի ողջ կառավարումը։

update-in-progress-title = Թարմացումն ընթացքի մեջ է

update-in-progress-message = Ցանկանո՞ւմ եք, որ { -brand-short-name } -ը շարունակի այս թարմեցումով:

update-in-progress-ok-button = &Հրաժարվել
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Շարունակել

addons-button = Ընդլայնումներ և Ոճեր

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Գլխավոր գաղտնաբառ ստեղծելու համար մուտքագրեք ձեր Windows-ի մուտքի հավատարմագրերը: Սա օգնում է պաշտպանել ձեր հաշիվների անվտանգությունը:

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = Ստեղծել Գլխավոր գաղտնաբառ

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name }-ի մեկնարկային էջը

start-page-label =
    .label = { -brand-short-name }-ը բացելիս ցուցադրել Մեկնարկային էջը
    .accesskey = W

location-label =
    .value = Տեղադրություն.
    .accesskey = o
restore-default-label =
    .label = Վերականգնել հիմնականը
    .accesskey = R

default-search-engine = Հիմնական որոնիչ
add-search-engine =
    .label = Ավելացնել նիշքից
    .accesskey = A
remove-search-engine =
    .label = Հեռացնել
    .accesskey = v

minimize-to-tray-label =
    .label = Երբ { -brand-short-name }-ը նվազեցված է, տեղափոխել այն տակդիր
    .accesskey = m

new-message-arrival = Նոր նամակ ստանալիս.
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Նվագարկել հետևյալ ձայնային ֆայլը.
           *[other] Նվագարկել ձայն
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ի
           *[other] d
        }
mail-play-button =
    .label = Նվագարկել
    .accesskey = Ն

change-dock-icon = Ծրագրի պատկերակի կարգավորումների փոփոխում
app-icon-options =
    .label = Ծրագրի պատկերակի ընտրանքներ...
    .accesskey = կ

notification-settings = Ահազանգերը և լռելյայն ձայնը կարող են անջատվել համակարգի նախապատվությունների ծանուցման վահանակում:

animated-alert-label =
    .label = Ցուցադրել ազդի ժամանակ
    .accesskey = Ց
customize-alert-label =
    .label = Կարգավորել…
    .accesskey = C

tray-icon-label =
    .label = Ցուցադրել էկրանի ներքևի պատկերը
    .accesskey = t

mail-system-sound-label =
    .label = Համակարգային ձայնը՝ նոր նամակի դեպքում
    .accesskey = D
mail-custom-sound-label =
    .label = Օգտ. հետևյալ ձայնային ֆայլը
    .accesskey = U
mail-browse-sound-button =
    .label = Ընտրել…
    .accesskey = B

enable-gloda-search-label =
    .label = Միացնել Ընդհանուր Որոնումը և Ինդեքսավորումը
    .accesskey = Մ

datetime-formatting-legend = Ամսաթվի և ժամանակի ձևաչափ
language-selector-legend = Լեզու

allow-hw-accel =
    .label = Հնարավորության դեպքում օգտագործել սարքակազմի արագացում
    .accesskey = ս

store-type-label =
    .value = Նամակները պահելու եղանակը՝ նոր հաշիվների համար.
    .accesskey = ե

mbox-store-label =
    .label = Ֆայլ թղթապանակում (mbox)
maildir-store-label =
    .label = Ֆայլ ամեն նամակի համար (maildir)

scrolling-legend = Թերթումը
autoscroll-label =
    .label = Օգտագործել ինքնավար թերթում
    .accesskey = U
smooth-scrolling-label =
    .label = Օգտագործել կոկիկ թերթում
    .accesskey = m

system-integration-legend = Համակարգային ինտեգրում
always-check-default =
    .label = Բացելիս միշտ ստուգել, թե արդյոք { -brand-short-name }-ը փոստային հիմնական ծրագիրն է
    .accesskey = A
check-default-button =
    .label = Ստուգել...
    .accesskey = N

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

search-integration-label =
    .label = Թույլատրել { search-engine-name }-ին որոնել նամակներ
    .accesskey = s

config-editor-button =
    .label = Խմբագրիչի կարգ...
    .accesskey = C

return-receipts-description = Որոշեք, թե { -brand-short-name }-ը ինչպես վարվի ստացականների հետ։
return-receipts-button =
    .label = Ստացականներ...
    .accesskey = R

update-app-legend = { -brand-short-name }-ի թարմացումներ

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Տարբերակ՝ { $version }

allow-description = Թույլատրել { -brand-short-name } դեպի
automatic-updates-label =
    .label = Ինքնաշխատ տեղադրել թարմացումները (խորհուրդ է տրվում)
    .accesskey = Ի
check-updates-label =
    .label = Ստուգել թարմացումները, բայց ես ինքս կորոշեմ տեղադրել, թե ոչ
    .accesskey = Ս

update-history-button =
    .label = Ցուցադրել թարմացումների պատմությունը
    .accesskey = ա

use-service =
    .label = Թարմացումները տեղադրել խորապատկերում
    .accesskey = b

cross-user-udpate-warning = Այս կարգաբերումը կկիրառվի Windows- ի բոլոր հաշիվների և { -brand-short-name }- ի համար; { -brand-short-name }- ի այս տեղադրումը օգտագործող հաշիվներ:

networking-legend = Կապակցում
proxy-config-description = Կարգավորել, թե ինչպես { -brand-short-name }-ը մուտք գործի համացանց

network-settings-button =
    .label = Կարգավորումներ...
    .accesskey = S

offline-legend = Անցանց
offline-settings = Կարգավորել անցանցը

offline-settings-button =
    .label = Անցանց...
    .accesskey = O

diskspace-legend = Ազատ տեղ
offline-compact-folder =
    .label = Սեղմել թղթապանակները, եթե դա կխնայի՝
    .accesskey = a

compact-folder-size =
    .value = ՄԲ ընդամենը

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Օգտագործել մինչև
    .accesskey = U

use-cache-after = ՄԲ պահոցի համար

##

smart-cache-label =
    .label = Վերագրել շտեմի ինքնաշխատ կառավարումը
    .accesskey = v

clear-cache-button =
    .label = Մաքրել Հիմա
    .accesskey = C

fonts-legend = Տառատեսակները և Գույները

default-font-label =
    .value = Հիմ. տառատեսակ.
    .accesskey = Հ

default-size-label =
    .value = Չափը.
    .accesskey = S

font-options-button =
    .label = Ընդլայնված...
    .accesskey = Ը

color-options-button =
    .label = Գույներ…
    .accesskey = C

display-width-legend = Սովորական տեքստային նամակ

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Ցուցարդել զգացմունքները որպես գրաֆիկա
    .accesskey = e

display-text-label = Մեջբերված սովորական տեքստային նամակները ցուցադրելիս.

style-label =
    .value = Ոճը.
    .accesskey = y

regular-style-item =
    .label = Կանոնավոր
bold-style-item =
    .label = Թավ
italic-style-item =
    .label = Շեղ
bold-italic-style-item =
    .label = Թավ շեղ

size-label =
    .value = Չափը.
    .accesskey = z

regular-size-item =
    .label = Կանոնավոր
bigger-size-item =
    .label = Մեծ
smaller-size-item =
    .label = Փոքր

quoted-text-color =
    .label = Գույնը.
    .accesskey = o

search-input =
    .placeholder = Որոնում

type-column-label =
    .label = Պարունակությունը
    .accesskey = T

action-column-label =
    .label = Գործողություն
    .accesskey = A

save-to-label =
    .label = Պահել ֆայլերը՝
    .accesskey = S

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Ընտրել…
           *[other] Ընտրել…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] B
        }

always-ask-label =
    .label = Միշտ հարցնել ֆայլերը պահելու տեղադրությունը
    .accesskey = Մ


display-tags-text = Պիտակներով կարող եք կարգավորել և դասակարգել Ձեր նամակները։

new-tag-button =
    .label = Նոր...
    .accesskey = Ն

edit-tag-button =
    .label = Խմբագրել...
    .accesskey = Խ

delete-tag-button =
    .label = Ջնջել
    .accesskey = D

auto-mark-as-read =
    .label = Նշել նամակները ընթերցված՝
    .accesskey = A

mark-read-no-delay =
    .label = Միանգամից, երբ նայում ես
    .accesskey = o

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Ժամանակ անց՝
    .accesskey = d

seconds-label = վայրկյան

##

open-msg-label =
    .value = Բացել նամակը՝

open-msg-tab =
    .label = Նոր էջ
    .accesskey = t

open-msg-window =
    .label = Նոր պատուհանում
    .accesskey = n

open-msg-ex-window =
    .label = Տվյալ պատուհանում
    .accesskey = e

close-move-delete =
    .label = Փակել նամակի էջը/պատուհանը ջնջելուց հետո
    .accesskey = C

display-name-label =
    .value = Ցուցադրել անունը․

condensed-addresses-label =
    .label = Հասցեագրքում ցուցադրել միայն մարդկանց ցուցադրվող անունը
    .accesskey = S

## Compose Tab

forward-label =
    .value = Փոխանցել նամակները՝
    .accesskey = F

inline-label =
    .label = Ներտող

as-attachment-label =
    .label = Որպես կցորդ

extension-label =
    .label = ավելացնել բացառություն ֆայլի անվանը
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Պահել յուրաքանչյուր՝
    .accesskey = Պ

auto-save-end = րոպե

##

warn-on-send-accel-key =
    .label = Հաստատել՝ նամակը ուղարկելիս հիմնաբառի պիտակը օգտ.
    .accesskey = C

spellcheck-label =
    .label = Ուղարկելուց առաջ ստուգել ուղղագրությունը
    .accesskey = C

spellcheck-inline-label =
    .label = Միացնել ուղղագրության ստուգումը
    .accesskey = E

language-popup-label =
    .value = Լեզուն.
    .accesskey = Լ

download-dictionaries-link = Ներբեռնել բառարաններ

font-label =
    .value = Տառը.
    .accesskey = n

font-size-label =
    .value = Չափը.
    .accesskey = z

default-colors-label =
    .label = Օգտագործել ընթերցողի լռելյայն գույները
    .accesskey = d

font-color-label =
    .value = Տեքստի գույնը.
    .accesskey = T

bg-color-label =
    .value = Խորապատկերի գույնը.
    .accesskey = B

restore-html-label =
    .label = Ըստ ծրագրայինի
    .accesskey = R

default-format-label =
    .label = Օգտագործեք Պարբերություն ձևաչափը՝ Հիմնական գրվածքի փոխարեն
    .accesskey = Պ

format-description = Կարգավորել տեքստայինի վարքը

send-options-label =
    .label = Ուղարկելու ընտրանքներ...
    .accesskey = S

autocomplete-description = Նամակները հասցեավորելիս, նայել համապատասխանեցումը.

ab-label =
    .label = Հասցեագրքում
    .accesskey = L

directories-label =
    .label = Սպասարկիչում.
    .accesskey = D

directories-none-label =
    .none = Չկա

edit-directories-label =
    .label = Խմբագրել թղթապանակները...
    .accesskey = E

email-picker-label =
    .label = Միանգամից ավելացնել ելքային հասցեները իմ՝
    .accesskey = A

default-directory-label =
    .value = Հասցեների նախնական ցուցակը հասցեների գրքի պատուհանում.
    .accesskey = S

default-last-label =
    .none = Վերջին օգտագործված նշարանը

attachment-label =
    .label = Ստուգել բացակայող կցորդները
    .accesskey = m

attachment-options-label =
    .label = Հիմնաբառեր...
    .accesskey = K

enable-cloud-share =
    .label = Առաջարկել տարածել ֆայլերը, որոնք մեծ են՝
cloud-share-size =
    .value = ՄԲ

add-cloud-account =
    .label = Ավելացնել...
    .accesskey = Ա
    .defaultlabel = Ավելացնել...

remove-cloud-account =
    .label = Ջնջել
    .accesskey = Ջ

find-cloud-providers =
    .value = Գտել ավել մատակարարներ…

cloud-account-description = Ավելացնել նոր Ֆայլի հղման կրիչ սարք


## Privacy Tab

mail-content = Նամակի բովանդակությունը

remote-content-label =
    .label = Թույլատրել նամակի հեռակա բովանդակությունը
    .accesskey = կ

exceptions-button =
    .label = Բացառություններ...
    .accesskey = E

remote-content-info =
    .value = Մանրամասներ՝ հեռակա բովանդակության անվտանգության մասին

web-content = Վեբ բովանդակություն

history-label =
    .label = Հիշել իմ այցելած կայքերը և հղումները
    .accesskey = Հ

cookies-label =
    .label = Ընդունել cookie-ներ հետևյալ կայքերից՝
    .accesskey = Ը

third-party-label =
    .value = Ընդունել երրորդ կողմի cookie-ները.
    .accesskey = ն

third-party-always =
    .label = Միշտ
third-party-never =
    .label = Երբեք
third-party-visited =
    .label = Այցելածներից

keep-label =
    .value = Պահել մինչև՝
    .accesskey = Պ

keep-expire =
    .label = ավարտման ժամկերը
keep-close =
    .label = { -brand-short-name }-ի փակումը
keep-ask =
    .label = հարցնել ամեն անգամ

cookies-button =
    .label = Ցուցադրել Cookie-ները...
    .accesskey = S

do-not-track-label =
    .label = Ուղարկել կայքերին “Չհետագծել“ ազդանշանը, որ դուք չեք ցանկանում հետագծվել
    .accesskey = n

learn-button =
    .label = Իմանալ ավելին

passwords-description = { -brand-short-name }-ը կարող է հիշել Ձեր բոլոր փոստարկղերի գաղտնաբառերը։

passwords-button =
    .label = Պահպանված գաղտնաբառեր…
    .accesskey = S

master-password-description = Գաղտնաբառի կառավարիչը կպաշտպանի Ձեր բոլոր գաղտնաբառերը, բայց պետք է գոնե մեկ անգամ մուտքագրեք։

master-password-label =
    .label = Օգտագործել գաղտնաբառ վարպետին
    .accesskey = U

master-password-button =
    .label = Փոխել գաղտնաբառ վարպետին…
    .accesskey = C


junk-description = Նշեք փոստաղբի հիմնական կարգավորումները փոստարկղի կարգավորումներում։

junk-label =
    .label = Երբ ես նշում եմ նամակը որպես թափոն՝
    .accesskey = W

junk-move-label =
    .label = Տեղափոխել փոստարկղի "Թափոն" թղթապանակ
    .accesskey = o

junk-delete-label =
    .label = Ջնջել դրանք
    .accesskey = D

junk-read-label =
    .label = Նշել թափոն նամակները որպես ընթերցված
    .accesskey = M

junk-log-label =
    .label = Միացնել թափոնի հարմարողական զտիչի մատյանը
    .accesskey = Մ

junk-log-button =
    .label = Ցուցադրել մատյանը
    .accesskey = S

reset-junk-button =
    .label = Վերակայել ուսուցման տվյալը
    .accesskey = Վ

phishing-description = { -brand-short-name }-ը կարող է ստուգել նամակները՝ որոշելու համար խաբկանք նամակները։

phishing-label =
    .label = Տեղեկացնել, երբ որևէ նամակը կասկածվում է որպես խաբկանք
    .accesskey = T

antivirus-description = { -brand-short-name }-ը կարող է հեշտացնել ստացված նամակների հակավիրուսային ստուգումը՝ մինչև դրանք համակարգիչ ներբեռնելը։

antivirus-label =
    .label = Թույլատրել հակավիրուսին նամակները տեղափոխել մեկուսարան։
    .accesskey = A

certificate-description = Երբ սպասարկիչը պահանջում է հավաստագիր.

certificate-auto =
    .label = Ընտրել որևէ մեկը
    .accesskey = S

certificate-ask =
    .label = Ամեն անգամ հարցնել
    .accesskey = A

ocsp-label =
    .label = OCSP հարցման պատասխանիչ սպասարկիչը՝ հաստատելու ընթացիկ վավերության վկայագիրը
    .accesskey = O

certificate-button =
    .label = Կառավարել վկայագրերը…
    .accesskey = M

security-devices-button =
    .label = Անվտանգության սարքեր...
    .accesskey = D

## Chat Tab

startup-label =
    .value = { -brand-short-name } -ի մեկնարկի ժամանակ`
    .accesskey = s

offline-label =
    .label = Պահել Զրույցի իմ հաշիվը անցանց

auto-connect-label =
    .label = Կապակցել Զրույցի իմ հաշվեկշռին միանգամից

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Տեղեկացնել իմ կոնտակներին, որ ես Թաքնված եմ՝
    .accesskey = ի

idle-time-label = րոպե պասսիվ լինելուց հետո

##

away-message-label =
    .label = և դարձնել իմ կարգավիճակը Հեռու եմ այս գրությամբ.
    .accesskey = և

send-typing-label =
    .label = Ուղարկել մուտքագրվող ծանուցումները զրուցաշարով
    .accesskey = մ

notification-label = Երբ ձեզ հասցեագրված նամակները հասնում են.

show-notification-label =
    .label = Ցուցադրել ծանուցումները.
    .accesskey = ո

notification-all =
    .label = ուղարկողի անունով և նախադիտումով
notification-name =
    .label = միայն ուղարկողի անունով
notification-empty =
    .label = առանց որևէ տեղեկության

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Շարժապատկերված հարակցման պատկերակ
           *[other] Բռնկել առաջադրանքագոտու միույթ
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] F
        }

chat-play-sound-label =
    .label = Նվագարկել ձայն
    .accesskey = ա

chat-play-button =
    .label = Նվագարկել
    .accesskey = Ն

chat-system-sound-label =
    .label = Համակարգային ձայն՝ նոր նամակի դեպքում
    .accesskey = Հ

chat-custom-sound-label =
    .label = Օգտ. հետևյալ ձայնային ֆայլը
    .accesskey = U

chat-browse-sound-button =
    .label = Ընտրել...
    .accesskey = Ը

theme-label =
    .value = Թեման.
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Պղպջակներ
style-dark =
    .label = Մուգ
style-paper =
    .label = Թղթի թերթեր
style-simple =
    .label = Պարզ

preview-label = Նախադիտում.
no-preview-label = Նախադիտումը հասանելի չէ
no-preview-description = Այս թեման վավեր չէ կամ ներկայումս անհասանելի է (անջատված լրացում, անվտանգ աշխատակերպ,…):

chat-variant-label =
    .value = Տարբերակ․
    .accesskey = V

chat-header-label =
    .label = Ցուցադրել վերնագիրը
    .accesskey = H

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
            [windows] Գտնել Ընտրանքներում
           *[other] Գտնել Նախապատվություններում
        }

## Preferences UI Search Results

search-results-header = Որոնման արդյունքներ

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Ընտրանքերում այլ արդյունքներ չկան “<span data-l10n-name="query"></span>”-ի համար:
       *[other] Նախապատվություններում այլ արդյունքներ չկան “<span data-l10n-name="query"></span>”-ի համար:
    }

search-results-help-link = Օգնությո՞ւն է պետք: Այցելեք { -brand-short-name }-ի աջակցում</a>
