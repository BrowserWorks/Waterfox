# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] Անցած շաբաթվա ընթացքում { -brand-short-name }-- արգելափակված { $count }-ի հետևում
       *[other] Անցած շաբաթվա ընթացքում { -brand-short-name }--արգելափակված { $count }-ի հետևումներ
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> հետևումը արգելափակվել է սկսած { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }-ից
       *[other] <b>{ $count }</b> հետևումները արգելափակվել են սկսած { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }-ից
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name }-ը շարունակում է արգելափակել հետքերը անձնական Windows- ում, բայց չի պահում գրառումը, թե ինչն է արգելափակված:
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = { -brand-short-name }-ի հետագծումները այս շաբաթ արգելափակել են

protection-report-webpage-title = Պաշտպանության վահանակ
protection-report-page-content-title = Պաշտպանության վահանակ
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name }-ը կարող է պաշտպանել ձեր գաղտնիությունը կուլիսների հետևում՝ երբ զննարկում եք: Սա այդ պաշտպանության անհատականացված ամփոփագիրն է, ներառյալ գործիքները`ձեր առցանց անվտանգությունը վերահսկելու համար:
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name }-ը պաշտպանում է ձեր գաղտնիությունը կուլիսների հետևում՝ երբ զննարկում եք: Սա այդ պաշտպանության անհատականացված ամփոփագիրն է, ներառյալ գործիքները`ձեր առցանց անվտանգությունը վերահսկելու համար:

protection-report-settings-link = Կառավարեք ձեր գաղտնիության և անվտանգության կարգավորումները

etp-card-title-always = Բարելավված հետագծման պաշտպանություն. միշտ միաց. է
etp-card-title-custom-not-blocking = Բարելավված հետագծման պաշտպանություն. ԱՆՋ.
etp-card-content-description = { -brand-short-name }-ը ինքնաբար կանգնեցնում է ընկերություններին՝  համացանցում Ձեզ գաղտնի հետևելուց:
protection-report-etp-card-content-custom-not-blocking = Ներկայումս բոլոր պաշտպանություններն անջատված են։Ընտրեք, թե որ թիրախն է արգելափակել՝կառավարելով ձեր { -brand-short-name } կարգավորումները։
protection-report-manage-protections = Փոխել կարգավորումները

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Այսօր

# This string is used to describe the graph for screenreader users.
graph-legend-description = Գրաֆիկ, որը պարունակում է այս շաբաթվա ընթացքում խցանված յուրաքանչյուր տեսակի հետախուզողի ընդհանուր թիվը։

social-tab-title = Ընդհանուր միջավայրի հետևումներ
social-tab-contant = Սոցցանցերը հետագծումը են ձեզ այլ կայքերում, ձեր գործողությունները իմանալու համար։ Սա թույլատրում է սոցմեդիայի կազմակերպություններին իմանալ ավելին ձեր մասին ըստ նրա, թե ինչով եք  կիսվում ձեր սոցմեդիա հաշիվներով։ <a data-l10n-name="learn-more-link">Իմանալ ավելին</a>

cookie-tab-title = Միջակայքի հետևող նշոցիկներ
cookie-tab-content = Այս նշոցիկները հետևում են ձեզ՝ կայքից կայք, ձեր գործողությունների մասին տեղեկանալու համար։ Նրանք սահմանվել են կազմակերպությունների վերլուծումների և գովազդատուների կողմից։ Արգելփակելով խաչվող կայքի հետապնդող նշոցիկների նվազեցնում եք գովազդի քանակը ձեր շրջապատում։ <a data-l10n-name="learn-more-link">Իմանալ ավելին</a>

tracker-tab-title = Հետագծող բովանդակություն
tracker-tab-description = Կայքերը կարող են բեռնել արտաքին գովազդ և այլ բովանդակություն հետապնդվող կոդով։ Հետապնդվող բովանդակությանը արգելափակումը կարող է օգնել կայքերին ավելի արագ բեռնվել, բայց որոշ կոճակներ ձևեր և մուտքային դաշտեր կարող են չաշխատել։ <a data-l10n-name="learn-more-link">Իմանալ ավելին</a>

fingerprinter-tab-title = Մատնահետքեր
fingerprinter-tab-content = Մատնահետքերը հավաքում են կարգավորումներ ձեր զննարկչից և համակարգչից ձեր հատկագրից ստեղծելու համար։ Օգտագործելով այդ թվային մատնահետքերը նրանք կարող են հետապնդել ձեզ տարբեր վեբ կայքերում։ <a data-l10n-name="learn-more-link">Իմանա ավելին</a>

cryptominer-tab-title = Ծպտյալ արժույթներ
cryptominer-tab-content = Կրիպտոարժույթները օգտագործում են ձեր համակարգի հաշվարկային ուժը թվային փողը հանելու համար։ Ծպտյալ արժեքների գրվածքները սպառում են ձեր մարտկոցը, դանդաղեցնում ձեր համակարգիչը և կարող են մեծացնել ձեր էներգիայի հաշիվը։ <a data-l10n-name="learn-more-link"> Իմանալ ավելին</a>

protections-close-button2 =
    .aria-label = Փակել
    .title = Փակել
  
mobile-app-title = Արգելափակել գովազդի հետքերը ավելի շատ սարքերում
mobile-app-card-content = Օգտագործեք բջջային զննարկիչը ներկառուցված պաշտպանությամբ `գովազդի հետևման դեմ:
mobile-app-links = { -brand-product-name } զննարկիչը <a data-l10n-name="android-mobile-inline-link">Android</a>-ի և <a data-l10n-name="ios-mobile-inline-link">iOS</a>-ի համար

lockwise-title = Այլևս երբեք չմոռանալ գաղտնաբառը
lockwise-title-logged-in2 = Գաղտնաբառերի կառավարում
lockwise-header-content = { -lockwise-brand-name } ապահով պահպանում է ձեր գաղտնաբառերը ձեր զննարկիչում:
lockwise-header-content-logged-in = Ապահով պահեք և համաժամացրեք ձեր գաղտնաբառերը ձեր բոլոր սարքերում:
protection-report-save-passwords-button = Պահպանել գաղտնաբառեր
    .title = Պահպանել գաղտնաբառերը { -lockwise-brand-short-name }-ում
protection-report-manage-passwords-button = Պահպանել գաղտնաբառեր
    .title = Պահպանել գաղտնաբառեր { -lockwise-brand-short-name }-ում
lockwise-mobile-app-title = Վերցրեք ձեր գաղտնաբառերը ամենուր
lockwise-no-logins-card-content = Ցանկացած սարքում օգտագործեք { -brand-short-name }-ով պահված գաղտնաբառերը:
lockwise-app-links = { -lockwise-brand-name }-ը <a data-l10n-name="lockwise-android-inline-link">Android</a>-ի և <a data-l10n-name="lockwise-ios-inline-link">iOS</a>-ի համար

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 գաղտնաբառ կարող է հանգեցնել տվյալների խախտման:
       *[other] { $count } գաղտնաբառեր կարող են հանգեցնել տվյալների խախտման:
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 գաղտնաբառ անվտանգ պահվել է:
       *[other] Ձեր գաղտնաբառերը անվտանգ պահվել են:
    }
lockwise-how-it-works-link = Ինչպես է այն աշխատում

turn-on-sync = Միացնել { -sync-brand-short-name }
    .title = Անցնել համաժամեցման հատկություններին

monitor-title = Փնտրել տվյալների խախտումներ
monitor-link = Ինչպես է դա աշխատում
monitor-header-content-no-account = Ստուգեք { -monitor-brand-name }՝իմանալու համար, թե արդյոք դուք եղել եք հայտնի տվյալների խախտման մաս, և ահազանգեր ստացեք նոր խախտումների մասին։
monitor-header-content-signed-in = { -monitor-brand-name }-ը զգուշացնում է Ձեզ, եթե Ձեր տեղեկութիւնները բախուել են յայտնի խախտման հետ։
monitor-sign-up-link = Գրանցվեք խախտումների մասին զգուշացվելու համար
    .title = Գրանցվեք խախտումների մասին զգուշացվելու համար { -monitor-brand-name }-ում
auto-scan = Այսօր ինքնուրույն պատկերահանվել է։

monitor-emails-tooltip =
    .title = Դիտել դիտազննված էլ. փոստի հասցեները { -monitor-brand-short-name }-ում
monitor-breaches-tooltip =
    .title = Դիտել տվյալների հայտնի խախտումները { -monitor-brand-short-name }-ում
monitor-passwords-tooltip =
    .title = Դիտել վտանգված գաղտնաբառերը { -monitor-brand-short-name }-ում

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Էլ. փոստի հասցեն վերահսկվում են
       *[other] Էլ. փոստի հասցեները վերահսկվում են
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Հայտնի տվյալների խախտումները բացահայտեցին ձեր տեղեկատվությունը
       *[other] Հայտնի տվյալների խախտումները բացահայտեցին ձեր տեղեկատվությունը
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Հայտնի տվյալների խախտումը նշվել է որպես լուծված
       *[other] Հայտնի տվյալների խախտումները նշվել են որպես լուծված
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Գաղտնաբառերը ենթարկվում են խախտումների
       *[other] Գաղտնաբառերը ենթարկվում են խախտումների
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Գաղտնաբառը ենթարկվում է չլուծված խախտումների
       *[other] Գաղտնաբառերը ենթարկվում են չլուծված խախտումների
    }

monitor-no-breaches-title = Լավ նորություն:
monitor-no-breaches-description = Դուք հայտնի խախտումներ չունեք: Եթե դա փոխվի, մենք ձեզ կտեղեկացնենք:
monitor-view-report-link = Դիտել զեկույցը
    .title = Ուղղել խախտումները { -monitor-brand-short-name }-ում
monitor-breaches-unresolved-title = Ուղղեք ձեր խախտումները
monitor-breaches-unresolved-description = Խախտումների մանրամասները վերանայելուց և ձեր տեղեկությունները պաշտպանելու համար քայլեր ձեռնարկելուց հետո կարող եք խախտումները նշել որպես ուղղված:
monitor-manage-breaches-link = Կառավարել խախտումները
    .title = Կառավարեք խախտումները { -monitor-brand-short-name }-ում
monitor-breaches-resolved-title = Լավ է: Դուք ուղղել եք բոլոր հայտնի խախտումները:
monitor-breaches-resolved-description = Եթե ձեր էլ. փոստը երևա որևէ նոր խախտումում, մենք ձեզ կտեղեկացնենք:

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved }-ը՝ { $numBreaches } խախտումից նշվել է որպես ուղղված:
       *[other] { $numBreachesResolved }-ը՝ { $numBreaches } խախտումներից նշվել է որպես ուղղված:
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }%-ը արված է

monitor-partial-breaches-motivation-title-start = Հիանալի մեկնարկ:
monitor-partial-breaches-motivation-title-middle = Շարունակիր նույն ձեւով:
monitor-partial-breaches-motivation-title-end = Գրեթե պատրաստ է: Շարունակիր նույն ձեւով:
monitor-partial-breaches-motivation-description = Ուղղեք ձեր մնացած խախտումները { -monitor-brand-short-name }-ում:
monitor-resolve-breaches-link = Ուղղել խախտումները
    .title = Ուղղել խախտումները { -monitor-brand-short-name }-ում

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Սոց մեդիայի հետևումներ
    .aria-label =
        { $count ->
            [one] { $count } սոց մեդիայի հետևում ({ $percentage }%)
           *[other] { $count } սոց մեդիայի հետևումներ ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Միջակայքի հետևման նշոցիկներ
    .aria-label =
        { $count ->
            [one] { $count } միջակայքի հետևման նշոցիկ ({ $percentage }%)
           *[other] { $count } միջակայքի հետևման նշոցիկներ ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Հետևող բովանդակություն
    .aria-label =
        { $count ->
            [one] { $count }հետևող բովանդակություն ({ $percentage }%)
           *[other] { $count }հետևող բովանդակություն ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Մատնահետքեր
    .aria-label =
        { $count ->
            [one] { $count }Մատնահետք ({ $percentage }%)
           *[other] { $count }Մատնահետքեր ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Ծպտյալ արժույթներ
    .aria-label =
        { $count ->
            [one] { $count } ծպտյալ արժույթներ ({ $percentage }%)
           *[other] { $count } ծպտյալ արժույթներ ({ $percentage }%)
        }
