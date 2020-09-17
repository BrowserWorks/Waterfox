# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } заблакаваў { $count } трэкер за мінулы тыдзень
        [few] { -brand-short-name } заблакаваў { $count } трэкеры за мінулы тыдзень
       *[many] { -brand-short-name } заблакаваў { $count } трэкераў за мінулы тыдзень
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> трэкер заблакаваны з { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [few] <b>{ $count }</b> трэкеры заблакавана з { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[many] <b>{ $count }</b> трэкераў заблакавана з { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } працягвае блакаваць трэкеры ў  прыватных вокнах, але не  запісвае, што было заблакавана.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Трэкеры, якія { -brand-short-name } заблакаваў на гэтым тыдні

protection-report-webpage-title = Панэль стану аховы
protection-report-page-content-title = Панэль стану аховы
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } можа ахоўваць вашу прыватнасць за кадрам падчас аглядання. Гэта персаналізаваная зводка аб ахове, уключна з інструментамі для кантролю вашай бяспекі ў Інтэрнэце.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } ахоўвае вашу прыватнасць за кадрам падчас аглядання. Гэта персаналізаваная зводка аб ахове, уключна з інструментамі для кантролю вашай бяспекі ў Інтэрнэце.

protection-report-settings-link = Кіруйце сваімі наладамі прыватнасці і бяспекі

etp-card-title-always = Узмоцненая ахова ад сачэння: заўсёды ўключана
etp-card-title-custom-not-blocking = Узмоцненая ахова ад сачэння: ВЫКЛЮЧАНА
etp-card-content-description = { -brand-short-name } аўтаматычна спыняе таемнае сачэнне кампаній за вамі ў Інтэрнэце.
protection-report-etp-card-content-custom-not-blocking = Усе меры аховы зараз адключаны. Выберыце, якія трэкеры трэба заблакаваць, кіруючы наладамі аховы { -brand-short-name }.
protection-report-manage-protections = Кіраваць наладамі

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Сёння

# This string is used to describe the graph for screenreader users.
graph-legend-description = Графік змяшчае агульную колькасць трэкераў кожнага тыпу, заблакаваны на гэтым тыдні.

social-tab-title = Трэкеры сацыяльных сетак
social-tab-contant = Сацыяльныя сеткі размяшчаюць трэкеры на іншых сайтах, каб сачыць за тым, што вы робіце, бачыце і глядзіце ў сеціве. Гэта дазваляе кампаніям сацыяльных сетак даведацца пра вас больш за тое, чым вы дзяліцеся ў сваіх профілях у сацыяльных сетках. <a data-l10n-name="learn-more-link">Даведацца больш</a>

cookie-tab-title = Міжсайтавыя кукі асочвання
cookie-tab-content = Гэтыя кукі ідуць за вамі з сайта на сайт, каб сабраць дадзеныя пра тое, што вы робіце ў Інтэрнэце. Яны ўсталёўваюцца трэцім бокам, такімі як рэкламадаўцы і аналітычныя кампаніі. Блакіроўка трэцебаковых кукі асочвання зніжае колькасць рэкламы, якія ідзе за вамі. <a data-l10n-name="learn-more-link">Даведацца больш</a>

tracker-tab-title = Змест з элементамі сачэння
tracker-tab-description = Вэб-сайты могуць загружаць вонкавую рэкламу, відэа і іншае змесціва з кодам асочвання. Блакіроўка змесціва асочвання можа дапамагчы сайтам хутчэй загружацца, але некаторыя кнопкі, формы і палі ўваходу могуць не працаваць. <a data-l10n-name="learn-more-link">Даведацца больш</a>

fingerprinter-tab-title = Збіральнікі адбіткаў пальцаў
fingerprinter-tab-content = Збіральнікі адбіткаў пальцаў збіраюць налады вашага браўзера і камп'ютара для стварэння вашага профілю. Выкарыстоўваючы гэты лічбавы адбітак, яны могуць асочваць вас на розных сайтах. <a data-l10n-name="learn-more-link">Даведацца больш</a>

cryptominer-tab-title = Майнеры крыптавалют
cryptominer-tab-content = Майнеры крыптавалют выкарыстоўваюць вылічальную магутнасць вашай сістэмы, каб здабываць лічбавыя грошы. Скрыпты для здабычы крыптавалют разраджаюць вашу батарэю, запавольваюць працу камп'ютара і могуць павялічыць ваш выдаткі на электраэнергію. <a data-l10n-name="learn-more-link">Даведацца больш</a>

protections-close-button2 =
    .aria-label = Закрыць
    .title = Закрыць
  
mobile-app-title = Блакуйце рэкламныя трэкеры на некалькіх прыладах
mobile-app-card-content = Выкарыстоўвайце мабільны браўзер з убудаванай аховай ад рэкламнага сачэння.
mobile-app-links = { -brand-product-name } Браўзер для <a data-l10n-name="android-mobile-inline-link">Android</a> і <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Больш ніколі не забывайце свой пароль
lockwise-title-logged-in2 = Кіраванне паролямі
lockwise-header-content = { -lockwise-brand-name } надзейна захоўвае вашы паролі ў вашым браўзеры.
lockwise-header-content-logged-in = Бяспечна захоўвайце і сінхранізуйце паролі на ўсіх сваіх прыладах.
protection-report-save-passwords-button = Захоўваць паролі
    .title = Захоўваць паролі ў { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Кіраваць паролямі
    .title = Кіраваць паролямі ў { -lockwise-brand-short-name }
lockwise-mobile-app-title = Вазьміце свае паролі ўсюды
lockwise-no-logins-card-content = Выкарыстоўвайце паролі, захаваныя ў { -brand-short-name }, на любой прыладзе.
lockwise-app-links = { -lockwise-brand-name } для <a data-l10n-name="lockwise-android-inline-link">Android</a> і <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 пароль, імаверна, выкрыты ў выніку ўцечкі дадзеных.
        [few] { $count } паролі, імаверна, выкрыты ў выніку ўцечкі дадзеных.
       *[many] { $count } пароляў, імаверна, выкрыта ў выніку ўцечкі дадзеных.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] Надзейна захоўваецца { $count } пароль.
        [few] Вашы паролі надзейна захоўваюцца.
       *[many] Вашы паролі надзейна захоўваюцца.
    }
lockwise-how-it-works-link = Як гэта працуе

turn-on-sync = Уключыць { -sync-brand-short-name }…
    .title = Перайсці да налад сінхранізацыі

monitor-title = Сачыце за ўцечкамі дадзеных
monitor-link = Як гэта працуе
monitor-header-content-no-account = Паспрабуйце { -monitor-brand-name }, каб спраўдзіць, ці не ўцяклі вашы дадзеныя у вядомых узломах, і атрымліваць апавяшчэнні аб новых уцечках.
monitor-header-content-signed-in = { -monitor-brand-name } папярэдзіць, калі вашы звесткі з'явяцца ў вядомым парушэнні дадзеных.
monitor-sign-up-link = Падпісацца на абвесткі аб уцечках
    .title = Падпісацца на абвесткі аб уцечках ад { -monitor-brand-name }
auto-scan = Аўтаматычна прасканавана сёння

monitor-emails-tooltip =
    .title = Пабачыць адрасы пошты, якія назіраюцца ў { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Пабачыць вядомыя ўцечкі дадзеных на { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Пабачыць выкрытыя паролі на { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Адрас электроннай пошты асочваецца
        [few] Адрасы электроннай пошты асочваецца
       *[many] Адрасоў электроннай пошты асочваецца
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Вядомае парушэнне дадзеных раскрыла вашу інфармацыю
        [few] Вядомыя парушэнні дадзеных раскрылі вашу інфармацыю
       *[many] Вядомых парушэнняў дадзеных раскрылі вашу інфармацыю
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Вядомая ўцечка дадзеных пазначана як вырашаная
        [few] Вядомыя ўцечкі дадзеных адзначаны як вырашаныя
       *[many] Вядомых уцечак дадзеных адзначана як вырашаныя
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Пароль выяўлены ва ўсіх уцечках
        [few] Паролі выяўлена ва ўсіх уцечках
       *[many] Пароляў выяўлена ва ўсіх уцечках
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Пароль выяўлены ў нявырашаных уцечках
        [few] Паролі выяўлены ў нявырашаных уцечках
       *[many] Пароляў выяўлена ў нявырашаных уцечках
    }

monitor-no-breaches-title = Добрыя навіны!
monitor-no-breaches-description = У вас няма вядомых уцечак дадзеных. Калі гэта зменіцца, мы вам паведамім.
monitor-view-report-link = Паглядзець справаздачу
    .title = Вырашыць праблемы, звязаныя з уцечкамі звестак, на { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Вырашыце свае ўцечкі
monitor-breaches-unresolved-description = Прааналізаваўшы падрабязнасці уцечкі і прыняўшы меры па абароне сваёй інфармацыі, вы можаце адзначыць уцечкі як вырашаныя.
monitor-manage-breaches-link = Кіраваць уцечкамі дадзеных
    .title = Кіраваць уцечкамі дадзеных на { -monitor-brand-short-name }
monitor-breaches-resolved-title = Нядрэнна! Вы вырашылі ўсе вядомыя ўцечкі дадзеных.
monitor-breaches-resolved-description = Калі ваш адрас пошты з'явіцца ў любых новых уцечках, мы паведамім вам.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } з { $numBreaches } уцечак пазначана як вырашаная
        [few] { $numBreachesResolved } з { $numBreaches } уцечак пазначаны як вырашаныя
       *[many] { $numBreachesResolved } з { $numBreaches } уцечак пазначана як вырашаныя
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved } завершана

monitor-partial-breaches-motivation-title-start = Выдатны пачатак!
monitor-partial-breaches-motivation-title-middle = Так трымаць!
monitor-partial-breaches-motivation-title-end = Амаль гатова! Так трымаць.
monitor-partial-breaches-motivation-description = Развяжыце рэшту сваіх уцечак дадзеных на { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Вырашыць уцечкі
    .title = Вырашыць уцечкі на { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Трэкеры сацыяльных сетак
    .aria-label =
        { $count ->
            [one] { $count } трэкер сацыяльных сетак ({ $percentage }%)
            [few] { $count } трэкеры сацыяльных сетак ({ $percentage }%)
           *[many] { $count } трэкераў сацыяльных сетак ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Міжсайтавыя кукі асочвання
    .aria-label =
        { $count ->
            [one] { $count } міжсайтавы кукі-файл асочвання ({ $percentage }%)
            [few] { $count } міжсайтавыя кукі-файлы асочвання ({ $percentage }%)
           *[many] { $count } міжсайтавых кукі-файлаў асочвання ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Змест з элементамі сачэння
    .aria-label =
        { $count ->
            [one] { $count } элемент сачэння ({ $percentage }%)
            [few] { $count } элементы сачэння ({ $percentage }%)
           *[many] { $count } элементаў сачэння ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Збіральнікі адбіткаў пальцаў
    .aria-label =
        { $count ->
            [one] { $count } збіральнік адбіткаў пальцаў ({ $percentage }%)
            [few] { $count } збіральнікі адбіткаў пальцаў ({ $percentage }%)
           *[many] { $count } збіральнікаў адбіткаў пальцаў ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Майнеры крыптавалют
    .aria-label =
        { $count ->
            [one] { $count } майнер крыптавалют ({ $percentage }%)
            [few] { $count } майнеры крыптавалют ({ $percentage }%)
           *[many] { $count } майнераў крыптавалют ({ $percentage }%)
        }
