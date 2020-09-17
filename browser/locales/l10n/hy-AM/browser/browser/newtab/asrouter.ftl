# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Երաշխավորված ընդլայնում
cfr-doorhanger-feature-heading = Առաջարկվող հատկություն
cfr-doorhanger-pintab-heading = Փորձեք սա. Ամրացնել ներդիրը

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Ինչու եմ ես սա տեսնում

cfr-doorhanger-extension-cancel-button = Ոչ հիմա
    .accesskey = N

cfr-doorhanger-extension-ok-button = Ավելացնել հիմա
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Ամրացնել այս ներդիրը
    .accesskey = P

cfr-doorhanger-extension-manage-settings-button = Կառավարել երաշխավորվող կարգավորումները
    .accesskey = M

cfr-doorhanger-extension-never-show-recommendation = Չցուցադրել ինձ այս երաշխավորությունները
    .accesskey = S

cfr-doorhanger-extension-learn-more-link = Իմանալ ավելին

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = { $name }-ի կողմից

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Երաշխավորություն
cfr-doorhanger-extension-notification2 = Երաշխավորություն
    .tooltiptext = Ընդլայնման երաշխավորություն
    .a11y-announcement = Հասանելի ընդլայնման երաշխավորություն

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Երաշխավորություն
    .tooltiptext = Հատկության երաշխավորություն
    .a11y-announcement = Հասանլի հատկության երաշխավորություն

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } աստղ
           *[other] { $total } աստղեր
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } օգտվող
       *[other] { $total } օգտվող
    }

cfr-doorhanger-pintab-description = Մատչեք առավել շատ օգտագործվող կայքերը։ Պահեք կայքերը բացված ներդիրում, եթե անգամ վերագործարկում եք։

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Աջ սեղմում</b>՝ այն ներդիրի վրա, որը ցանկանում եք ամրացնել:
cfr-doorhanger-pintab-step2 = Ընտրեք<b>Ամրացնել ներդիրը</b>՝ ցանկից:
cfr-doorhanger-pintab-step3 = Եթե կայքը արդիացում ունի, դուք կտեսնեք կապույտ կետ ձեր ամրացված ներդիրում:

cfr-doorhanger-pintab-animation-pause = Դադար
cfr-doorhanger-pintab-animation-resume = Շարունակել


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Համաժամեցրեք ձեր էջանիշերը ամեն տեղ:
cfr-doorhanger-bookmark-fxa-body = Մեծ գտածո: Այժմ մի մնացեք առանց այս էջանիշի ձեր բջջային սարքերում: Խորհուրդ ենք տալիս սկսել { -fxaccount-brand-name }-ի հետ։
cfr-doorhanger-bookmark-fxa-link-text = Համաժամեցնել էջանիշերը...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Փակելու կոճակ
    .title = Փակել

## Protections panel

cfr-protections-panel-header = Զննել առանց հետևվելու
cfr-protections-panel-body = Ձեր տվյալները պահեք ձեզ մոտ: { -brand-short-name }-ը ձեզ պաշտպանում է ամենատարածված վնասներից, որոնք հետևում են այն ամենին, ինչ դուք անում եք առցանց:
cfr-protections-panel-link-text = Իմանալ ավելին

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Նոր հատկություն․

cfr-whatsnew-button =
    .label = Ինչն է նոր
    .tooltiptext = Ինչն է նոր

cfr-whatsnew-panel-header = Ինչն է նոր

cfr-whatsnew-release-notes-link-text = Կարդալ թողարկման գրառումները

cfr-whatsnew-fx70-title = { -brand-short-name } այժմ ավելի է պայքարում ձեր գաղտնիության համար
cfr-whatsnew-fx70-body = Վերջին թարմացումը ուժեղացնում է Պաշտպանումը Վնասներից առանձնահատկությունը և դարձնում է այն ավելի հեշտ, քան երբևե բոլոր կայքերի համար անվտանգ գաղտնաբառեր ստեղծելը։

cfr-whatsnew-tracking-protect-title = Պաշտպանեք ձեզ հետագծումներից
cfr-whatsnew-tracking-protect-body = { -brand-short-name } արգելափակում է շատ տարածված սոցիալական և խաչմերուկային վնասները, որոնք հետևում են ձեր առցանց գործողություններին։
cfr-whatsnew-tracking-protect-link-text = Դիտել ձեր զեկույցը

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Հետևումը արգելափակված է
       *[other] Հետևումները արգելափակված են
    }
cfr-whatsnew-tracking-blocked-subtitle = Քանի որ { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Դիտել զեկույցը

cfr-whatsnew-lockwise-backup-title = Կրկնօրինակել ձեր գաղտնաբառերը
cfr-whatsnew-lockwise-backup-body = Այժմ ստեղծեք անվտանգ գաղտնաբառեր, որոնցից կարող եք մուտք գործել ցանկացած մուտք:
cfr-whatsnew-lockwise-backup-link-text = Միացնել կրկնօրինակումները

cfr-whatsnew-lockwise-take-title = Վերցրեք ձեր գաղտնաբառերը ձեզ հետ
cfr-whatsnew-lockwise-take-body =
    { -lockwise-brand-short-name } բջջային հավելվածը հնարավորություն է տալիս ապահով կերպով մուտք գործել ձեր
    կրկնօրինակված գաղտնաբառերը ցանկացած վայրից:
cfr-whatsnew-lockwise-take-link-text = Ստանալ հավելվածը

## Search Bar

cfr-whatsnew-searchbar-title = Մուտքագրեք ավելի քիչ, ավելին գտնեք հասցեի տողի հետ
cfr-whatsnew-searchbar-body-topsites = Այժմ պարզապես ընտրեք հասցեների գոտին և տուփը կլրացվի ձեր լավագույն կայքերի հղումներով:
cfr-whatsnew-searchbar-icon-alt-text = Խոշորացույցի պատկերակ

## Picture-in-Picture

cfr-whatsnew-pip-header = Դիտել տեսահոլովակներ զննարկելիս
cfr-whatsnew-pip-body = Նկարով նկարում տեսանյութը լողում է լողացող պատուհանի մեջ, որպեսզի կարողանաք դիտել այլ ներդիրներում աշխատելիս:
cfr-whatsnew-pip-cta = Իմանալ ավելին

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Ավելի քիչ նյարդայնացնող կայքի թռուցիկներ
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } այժմ արգելափակում է կայքերը ինքնաբերաբար խնդրելով ձեզ ուղարկել թռուցիկ հաղորդագրություններ:
cfr-whatsnew-permission-prompt-cta = Իմանալ ավելին

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Մատնահետքը արգելափակվեց
       *[other] Մատնահետքերը արգելափակվեցին
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } արգելափակում է մատնահետքերից շատերը, որոնք գաղտնի հավաքում են տեղեկատվություն ձեր սարքի և գործողությունների մասին ՝ ձեր կողմից գովազդային պրոֆիլ ստեղծելու համար:

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Մատնահետքեր
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } արգելափակում է մատնահետքերից շատերը, որոնք գաղտնի հավաքում են տեղեկատվություն ձեր սարքի և գործողությունների մասին ՝ ձեր կողմից գովազդային պրոֆիլ ստեղծելու համար:

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Ստացեք այս էջանիշը ձեր հեռախոսի վրա
cfr-doorhanger-sync-bookmarks-body = Վերցնել ձեր էջանիշները, գաղտնաբառերը, պատմությունը և ավելին, որտեղ դուք մուտք եք գործել { -brand-product-name }։
cfr-doorhanger-sync-bookmarks-ok-button = Միացնել { -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = Այլևս երբեք մի կորցրեք գաղտնաբառ
cfr-doorhanger-sync-logins-body = Ապահով պահեք և համաժամացրեք ձեր գաղտնաբառերը ձեր բոլոր սարքերում:
cfr-doorhanger-sync-logins-ok-button = Միացնել { -sync-brand-short-name }
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = Կարդացեք սա անմիջապես
cfr-doorhanger-send-tab-recipe-header = Վերցրեք այս բաղադրատոմսը խոհանոց
cfr-doorhanger-send-tab-body = Ուղարկել ներդիրը հնարավորություն է տալիս հեշտությամբ ուղարկել այս հղումը ձեր հեռախոսին կամ այն վայրից, որտեղ դուք մուտք եք գործել { -brand-product-name }:
cfr-doorhanger-send-tab-ok-button = Փորձեք ուղարկել ներդիր
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Համօգտագործել այս PDF- ն անվտանգ կերպով
cfr-doorhanger-firefox-send-body = Պահպանեք ձեր զգայուն փաստաթղթերը զերծ հայացք նետելուց՝վերջնական ծածկագրմամբ և այն հղմամբ, որն անհայտանում է, երբ ավարտվում եք։
cfr-doorhanger-firefox-send-ok-button = Փորձեք { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Տեսնել Պաշտպանությունները
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = Փակել
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = Այլևս ցույց մի տվեք այսպիսի հաղորդագրություններ
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name }-ը դադարեցրել է սոցիալական ցանցի հետագծումը
cfr-doorhanger-socialtracking-description = Ձեր գաղտնիությունը կարևոր է: { -brand-short-name }-ը այժմ արգելափակում է հանրային մեդիայի ընդհանուր վտանգները, սահմանելով, թե որքան տվյալներ կարող են հավաքել ձեր առցանց գործողությունների մասին։
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } արգելափակում է մատնահետքը այս էջում
cfr-doorhanger-fingerprinters-description = Ձեր գաղտնիությունը կարևոր է: { -brand-short-name }-ն այժմ արգելափակում է մատնահետքեր, որոնք հավաքում են ձեր սարքի մասին եզակի անձնական տեղեկություններ վնասելու համար։
cfr-doorhanger-cryptominers-heading = { -brand-short-name } արգելափակեց գաղտնազերծիչը այս էջում
cfr-doorhanger-cryptominers-description = Ձեր գաղտնիությունը կարևոր է։ { -brand-short-name }-ը կարճ անունը հիմա արգելափակում է ծպտյալ սարքերը, որոնք օգտագործում են ձեր համակարգի հաշվարկային ուժը թվային փողերը հանելու համար։

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } արգելափակել է <b>{ $blockedCount }</b> հետևումը սկսած { $date }։
       *[other] { -brand-short-name } արգելափակել է <b>{ $blockedCount }</b> հետևումները սկսած { $date }։
    }
cfr-doorhanger-milestone-ok-button = Պահպանել բոլորը
    .accesskey = S

cfr-doorhanger-milestone-close-button = Փակել
    .accesskey = C

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Հեշտությամբ ստեղծեք անվտանգ գաղտնաբառեր
cfr-whatsnew-lockwise-body = Յուրաքանչյուր հաշվի համար դժվար է մտածել եզակի, անվտանգ գաղտնաբառ: Գաղտնաբառ ստեղծելիս ընտրեք գաղտնաբառի դաշտը՝ օգտագործելու համար անվտանգ, { -brand-shorter-name }-ի կողմից ստեղծված գաղտնաբառ:
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } պատկերակ

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Զգուշացումներ ստանալ խոցելի գաղտնաբառերի մասին
cfr-whatsnew-passwords-body = Հակերները գիտեն, որ մարդիկ օգտագործում են նույն գաղտնաբառերը: Եթե դուք օգտագործում եք նույն գաղտնաբառը բազմաթիվ կայքերում, և այդ կայքերից մեկը տվյալների խախտման մեջ է, ապա այդ կայքերում ձեր գաղտնաբառը փոխելու համար կտեսնեք ազդանշան { -lockwise-brand-short-name }-ում:
cfr-whatsnew-passwords-icon-alt = Խոցելի գաղտնաբառի բանալու պատկերակ

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Ստանալ լիաէկրանի նկարը նկարում
cfr-whatsnew-pip-fullscreen-body = Երբ դուք տեսանյութը տեղափոխում եք լողացող պատուհան՝ այժմ կարող եք կրկնակի սեղմել այդ պատուհանին և անցնել լիաէկրան:
cfr-whatsnew-pip-fullscreen-icon-alt = Նկար-նկարում պատկերակ

## Protections Dashboard message

cfr-whatsnew-protections-header = Պաշտպանություն առաջին հայացքից
cfr-whatsnew-protections-body = Պաշտպանությունների վահանակը ներառում է տվյալների խախտումների և գաղտնաբառերի կառավարման ընդհանրական զեկույցներ: Այժմ կարող եք հետևել, թե որքան խախտումներ եք դուք ուղղել և տեսնել, թե ձեր պահպանած գաղտնաբառերից քանիսին են ներառվել տվյալների խախտումներում:
cfr-whatsnew-protections-cta-link = Դիտել պաշտպանության վահանակը
cfr-whatsnew-protections-icon-alt = Վահանի պատկերակը

## Better PDF message

cfr-whatsnew-better-pdf-header = Ավելի լավ PDF փորձառություն
cfr-whatsnew-better-pdf-body = PDF փաստաթղթերն այժմ բացվում են ուղղակիորեն { -brand-short-name }-ում, պահպանելով ձեր աշխատահոսքը հասանելիության պայմաններում:

## DOH Message

cfr-doorhanger-doh-body = Ձեր գաղտնիությունը կարևոր է: { -brand-short-name }-ն այժմ ապահով կերպով ուղարկում է ձեր DNS հարցումները, երբ դա հնարավոր է, գործընկեր ծառայությանը՝ զններկելիս Ձեզ պաշտպանվելու համար:
cfr-doorhanger-doh-header = Ավելի անվտանգ, գաղտնագրված DNS որոնումներ
cfr-doorhanger-doh-primary-button = Լավ, հասկացա
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Անջատել
    .accesskey = D

## What's new: Cookies message

