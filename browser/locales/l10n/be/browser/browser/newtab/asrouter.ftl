# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Рэкамендаванае пашырэнне
cfr-doorhanger-feature-heading = Рэкамендаваная функцыя
cfr-doorhanger-pintab-heading = Паспрабуйце: Прышпіліць картку

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Чаму я гэта бачу

cfr-doorhanger-extension-cancel-button = Не зараз
    .accesskey = Н

cfr-doorhanger-extension-ok-button = Дадаць
    .accesskey = Д
cfr-doorhanger-pintab-ok-button = Прышпіліць гэту картку
    .accesskey = П

cfr-doorhanger-extension-manage-settings-button = Кіраваць наладамі рэкамендацый
    .accesskey = ь

cfr-doorhanger-extension-never-show-recommendation = Не паказваць мне гэту рэкамендацыю
    .accesskey = ы

cfr-doorhanger-extension-learn-more-link = Даведацца больш

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = ад { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Рэкамендацыя
cfr-doorhanger-extension-notification2 = Рэкамендацыя
    .tooltiptext = Рэкамендацыя пашырэння
    .a11y-announcement = Даступна рэкамендацыя пашырэння

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Рэкамендацыя
    .tooltiptext = Рэкамендацыя функцыі
    .a11y-announcement = Даступна рэкамендацыя функцыі

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } зорка
            [few] { $total } зоркі
           *[many] { $total } зорак
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } карыстальнік
        [few] { $total } карыстальнікі
       *[many] { $total } карыстальнікаў
    }

cfr-doorhanger-pintab-description = Атрымайце зручны доступ да найчасцей наведаных сайтаў. Трымайце сайты адкрытымі ў картках (нават пасля перазапуску).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Націсніце правай кнопкай</b> на картцы, якую хочаце прышпіліць.
cfr-doorhanger-pintab-step2 = Выберыце <b>Прышпіліць картку</b> ў меню.
cfr-doorhanger-pintab-step3 = Калі сайт абнавіўся, вы ўбачыце блакітную кропку на прышпіленай картцы.

cfr-doorhanger-pintab-animation-pause = Прыпыніць
cfr-doorhanger-pintab-animation-resume = Працягнуць


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Сінхранізуйце свае закладкі ўсюды.
cfr-doorhanger-bookmark-fxa-body = Выдатная знаходка! Цяпер не заставайцеся без гэтай закладкі на вашых мабільных прыладах. Пачніце працу з { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Сінхранізаваць закладкі зараз…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Кнопка закрыцця
    .title = Закрыць

## Protections panel

cfr-protections-panel-header = Аглядайце без старонніх вачэй
cfr-protections-panel-body = Захоўвайце свае дадзеныя пры сабе. { -brand-short-name } абараняе вас ад многіх самых распаўсюджаных трэкераў, якія сочаць за тым, што вы робіце ў інтэрнэце.
cfr-protections-panel-link-text = Даведацца больш

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Новая функцыя:

cfr-whatsnew-button =
    .label = Што новага
    .tooltiptext = Што новага

cfr-whatsnew-panel-header = Што новага

cfr-whatsnew-release-notes-link-text = Прачытаць заўвагі да выпуску

cfr-whatsnew-fx70-title = { -brand-short-name } цяпер мацней змагаецца за вашу прыватнасць
cfr-whatsnew-fx70-body =
    Апошняе абнаўленне паляпшае функцыю аховы ад сачэння і робіць
    лягчэйшым стварэнне бяспечных пароляў для кожнага сайта.

cfr-whatsnew-tracking-protect-title = Абараніце сябе ад трэкераў
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } блакуе многія сацыяльныя і міжсайтавыя трэкеры,
    якія назіраюць за тым, што вы робіце ў Інтэрнэце.
cfr-whatsnew-tracking-protect-link-text = Паглядзець справаздачу

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Трэкер заблакаваны
        [few] Трэкеры заблакавана
       *[many] Трэкераў заблакавана
    }
cfr-whatsnew-tracking-blocked-subtitle = З { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Паглядзець справаздачу

cfr-whatsnew-lockwise-backup-title = Рэзервовае капіраванне пароляў
cfr-whatsnew-lockwise-backup-body = Цяпер можна генераваць бяспечныя паролі і атрымліваць доступ да іх у любым месцы.
cfr-whatsnew-lockwise-backup-link-text = Уключыць рэзервовае капіяванне

cfr-whatsnew-lockwise-take-title = Вазьміце свае паролі з сабой
cfr-whatsnew-lockwise-take-body =
    Праграма { -lockwise-brand-short-name } на тэлефоне дазваляе бяспечна
    атрымліваць доступ до захаваных пароляў з любога месца.
cfr-whatsnew-lockwise-take-link-text = Атрымаць праграму

## Search Bar

cfr-whatsnew-searchbar-title = Уводзьце менш, знаходзьце больш з адрасным радком
cfr-whatsnew-searchbar-body-topsites = Цяпер проста выберыце адрасны радок, і ён разгорнецца спасылкамі на вашы папулярныя сайты.
cfr-whatsnew-searchbar-icon-alt-text = Значок павелічальнага шкла

## Picture-in-Picture

cfr-whatsnew-pip-header = Глядзіце відэа падчас аглядання
cfr-whatsnew-pip-body = Функцыя выява-ў-выяве змяшчае відэа ў перасоўнае акно, каб вы маглі глядзець, працуючы ў іншых картках.
cfr-whatsnew-pip-cta = Даведацца больш

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Менш раздражняльных усплыўных акон
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } цяпер блакуе аўтаматычныя запыты на адпраўку вам усплыўных паведамленняў.
cfr-whatsnew-permission-prompt-cta = Даведацца больш

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Збіральнік лічбавых адбіткаў заблакаваны
        [few] Збіральнікі лічбавых адбіткаў заблакавана
       *[many] Збіральнікаў лічбавых адбіткаў заблакавана
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } блакуе мноства збіральнікаў лічбавых адбіткаў, якія таемна збіраюць інфармацыю пра вашу прыладу і дзеянні для стварэння вашага рэкламнага профілю.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Збіральнікі лічбавых адбіткаў
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } можа блакаваць збіральнікаў лічбавых адбіткаў, якія таемна збіраюць інфармацыю пра вашу прыладу і дзеянні для стварэння вашага рэкламнага профілю.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Атрымаць гэтую закладку на свой тэлефон
cfr-doorhanger-sync-bookmarks-body = Вазьміце свае закладкі, паролі, гісторыю і іншае ўсюды, дзе вы карыстаецеся { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Уключыць { -sync-brand-short-name }
    .accesskey = У

## Login Sync

cfr-doorhanger-sync-logins-header = Ніколі не губляйце пароль ізноў
cfr-doorhanger-sync-logins-body = Бяспечна захоўвайце і сінхранізуйце паролі на ўсіх сваіх прыладах.
cfr-doorhanger-sync-logins-ok-button = Уключыць { -sync-brand-short-name }
    .accesskey = У

## Send Tab

cfr-doorhanger-send-tab-header = Чытайце гэта на хаду
cfr-doorhanger-send-tab-recipe-header = Вазьміце гэты рэцэпт на кухню
cfr-doorhanger-send-tab-body = Адпраўка картак дазваляе лёгка дзяліцца гэтай спасылкай на ваш тэлефон або ў любое іншае месца, дзе вы ўвайшлі ў { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Паспрабуйце адпраўку картак
    .accesskey = П

## Firefox Send

cfr-doorhanger-firefox-send-header = Дзяліцеся гэтым PDF бяспечна
cfr-doorhanger-firefox-send-body = Трымайце свае далікатныя дакументы далей ад старонніх вачэй з дапамогай скразнога шыфравання і спасылкі, якая знікае пасля выкарыстання.
cfr-doorhanger-firefox-send-ok-button = Паспрабуйце { -send-brand-name }
    .accesskey = П

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Паглядзець меры аховы
    .accesskey = з
cfr-doorhanger-socialtracking-close-button = Закрыць
    .accesskey = ц
cfr-doorhanger-socialtracking-dont-show-again = Больш не паказваць такія паведамленні
    .accesskey = в
cfr-doorhanger-socialtracking-heading = { -brand-short-name } не дазволіў сацыяльнай сетцы сачыць за вамі тут
cfr-doorhanger-socialtracking-description = Ваша прыватнасць мае значэнне. Цяпер { -brand-short-name } блакуе звычайныя трэкеры сацыяльных сетак, абмяжоўваючы колькасць дадзеных, якія яны могуць сабраць пра тое, што вы робіце ў сеціве.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } заблакаваў збіральнік лічбавых адбіткаў на гэтай старонцы
cfr-doorhanger-fingerprinters-description = Ваша прыватнасць мае значэнне. { -brand-short-name } цяпер блакуе збіральнікі лічбавых адбіткаў, якія збіраюць фрагменты адназначнай інфармацыі пра вашу прыладу, каб асочваць вас.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } заблакаваў майнер крыптавалют на гэтай старонцы
cfr-doorhanger-cryptominers-description = Ваша прыватнасць мае значэнне. { -brand-short-name } цяпер блакуе майнеры крыптавалют, якія выкарыстоўваюць вылічальную магутнасць вашай сістэмы для здабычы лічбавых грошай.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } заблакаваў больш за  <b>{ $blockedCount }</b> трэкер з { $date }!
        [few] { -brand-short-name } заблакаваў больш за  <b>{ $blockedCount }</b> трэкеры з { $date }!
       *[many] { -brand-short-name } заблакаваў больш за  <b>{ $blockedCount }</b> трэкераў з { $date }!
    }
cfr-doorhanger-milestone-ok-button = Пабачыць усе
    .accesskey = ы

cfr-doorhanger-milestone-close-button = Закрыць
    .accesskey = З

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Лёгка стварайце надзейныя паролі
cfr-whatsnew-lockwise-body = Цяжка прыдумваць унікальныя і надзейныя паролі для кожнага ўліковага запісу. Пры стварэнні пароля выберыце поле пароля, каб выкарыстаць надзейны згенераваны пароль ад { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Значок { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Атрымлівайце папярэджанні аб уразлівых паролях
cfr-whatsnew-passwords-body = Хакеры ведаюць, што людзі паўторна выкарыстоўваюць адны і тыя ж паролі. Калі вы выкарыстоўвалі аднолькавы пароль на некалькіх сайтах, і адзін з гэтых сайтаў стаў часткай уцечкі звестак, вы ўбачыце папярэджанне ў { -lockwise-brand-short-name } з парадай змяніць свой пароль на гэтых сайтах.
cfr-whatsnew-passwords-icon-alt = Значок «ключ уразлівага пароля»

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Зрабіце поўнаэкраннай выяву ў выяве
cfr-whatsnew-pip-fullscreen-body = Па з'яўленні відэа ў выплыўным акне вы можаце двойчы пстрыкнуць па гэтым акне, каб перайсці ў поўны экран.
cfr-whatsnew-pip-fullscreen-icon-alt = Значок «выява ў выяве»

## Protections Dashboard message

cfr-whatsnew-protections-header = Хуткі агляд стану аховы
cfr-whatsnew-protections-body = Панэль стану аховы змяшчае зводныя справаздачы аб уцечках дадзеных і кіраванні паролямі. Цяпер вы можаце асочваць колькасць уцечак, з якімі вы разабраліся, і бачыць, ці быў які-небудзь з захаваных пароляў выкрыты пры ўцечцы дадзеных.
cfr-whatsnew-protections-cta-link = Адкрыць панэль стану аховы
cfr-whatsnew-protections-icon-alt = Значок шчыта

## Better PDF message

cfr-whatsnew-better-pdf-header = Лепшая праца з PDF
cfr-whatsnew-better-pdf-body = Цяпер дакументы PDF адкрываюцца наўпрост у { -brand-short-name }, трымаючы ваш працоўны працэс зручным.

## DOH Message

cfr-doorhanger-doh-body = Ваша прыватнасць мае значэнне. { -brand-short-name } зараз бяспечна накіроўвае вашы запыты DNS, калі гэта магчыма, у партнёрскі сэрвіс, каб абараніць вас у час аглядання.
cfr-doorhanger-doh-header = Больш бяспечны, зашыфраваны пошук DNS
cfr-doorhanger-doh-primary-button = OK, зразумела
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Адключыць
    .accesskey = А

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Аўтаматычная абарона ад падступнай тактыкі сачэння
cfr-whatsnew-clear-cookies-body = Некаторыя трэкеры перанакіроўваюць вас на іншыя сайты, якія таемна ўсталёўваюць кукі. { -brand-short-name } зараз аўтаматычна ачышчае гэтыя кукі, каб за вамі не маглі сачыць.
cfr-whatsnew-clear-cookies-image-alt = Прыклад блакавання кукаў
