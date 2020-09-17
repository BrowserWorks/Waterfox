# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Ұсынылатын кеңейту
cfr-doorhanger-feature-heading = Ұсынылатын мүмкіндік
cfr-doorhanger-pintab-heading = Осыны көріңіз: Бетті бекіту

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Мен бұны неге көріп отырмын

cfr-doorhanger-extension-cancel-button = Қазір емес
    .accesskey = м

cfr-doorhanger-extension-ok-button = Қазір қосу
    .accesskey = а
cfr-doorhanger-pintab-ok-button = Бұл бетті бекіту
    .accesskey = б

cfr-doorhanger-extension-manage-settings-button = Ұсыныстар параметрлерін басқару
    .accesskey = б

cfr-doorhanger-extension-never-show-recommendation = Бұл ұсынысты маған көрсетпеу
    .accesskey = к

cfr-doorhanger-extension-learn-more-link = Көбірек білу

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = { $name } шығарған

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Ұсыныс
cfr-doorhanger-extension-notification2 = Ұсыныс
    .tooltiptext = Кеңейту ұсынысы
    .a11y-announcement = Кеңейту ұсынысы қолжетерлік

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Ұсыныс
    .tooltiptext = Мүмкіндік ұсынысы
    .a11y-announcement = Мүмкіндік ұсынысы қолжетерлік

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
           *[other] { $total } жұлдызша
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
       *[other] { $total } пайдаланушы
    }

cfr-doorhanger-pintab-description = Жиі қолданатын сайттарыңызға ыңғайлы қатынаңыз. Сайттарды бетте ашық ұстаңыз (қайта қосылсаңыз да).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = Бекіткіңіз келетін бетке <b>оң жақпен шертіңіз</b>.
cfr-doorhanger-pintab-step2 = Мәзірден <b>Бетті бекітуді</b> таңдаңыз.
cfr-doorhanger-pintab-step3 = Сайтта жаңарту болса, бекітілген бетте көк нүктені көретін боласыз.

cfr-doorhanger-pintab-animation-pause = Аялдату
cfr-doorhanger-pintab-animation-resume = Жалғастыру


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Бетбелгілерді барлық жерде синхрондаңыз.
cfr-doorhanger-bookmark-fxa-body = Тамаша табу! Енді мобильді құрылғыларыңызда бұл бетбелгісіз қалмаңыз. { -fxaccount-brand-name } қызметімен жұмысты бастаңыз.
cfr-doorhanger-bookmark-fxa-link-text = Бетбелгілерді қазір синхрондау…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Жабу батырмасы
    .title = Жабу

## Protections panel

cfr-protections-panel-header = Бақылаусыз шолу
cfr-protections-panel-body = Деректеріңізді тек өзіңіз үшін қалдырыңыз. { -brand-short-name } желіде сіздің соңыңыздан еретін ең кең тараған трекерлердің көбінен қорғайды.
cfr-protections-panel-link-text = Көбірек білу

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Жаңа мүмкіндік:

cfr-whatsnew-button =
    .label = Не жаңалық
    .tooltiptext = Не жаңалық

cfr-whatsnew-panel-header = Не жаңалық

cfr-whatsnew-release-notes-link-text = Шығарылым ескертпесін оқу

cfr-whatsnew-fx70-title = { -brand-short-name } сіздің жекелігіңіз үшін енді күштірек күреседі
cfr-whatsnew-fx70-body =
    Соңғы жаңарту Бақылаудан Қорғанысты жақсартып, әр сайт үшін
    күштірек парольдерді жасауды оңайырақ қылады.

cfr-whatsnew-tracking-protect-title = Өзіңізді трекерлерден қорғаңыз
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } желіде сіздің соңыңыздан еретін көптеген әлеуметтік
    және сайтаралық трекерлерді бұғаттайды.
cfr-whatsnew-tracking-protect-link-text = Есепті қарау

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
       *[other] Блокталған трекерлер
    }
cfr-whatsnew-tracking-blocked-subtitle = { DATETIME($earliestDate, month: "long", year: "numeric") } бастап
cfr-whatsnew-tracking-blocked-link-text = Есептемені қарау

cfr-whatsnew-lockwise-backup-title = Парольдеріңіздің қор көшірмесін жасаңыз
cfr-whatsnew-lockwise-backup-body = Қайда кірсеңіз де. қолдана алатын қауіпсіз парольдерді жасаңыз.
cfr-whatsnew-lockwise-backup-link-text = Қор көшірмелерді іске қосу

cfr-whatsnew-lockwise-take-title = Парольдіріңізді өзіңізбен бірге ұстаңыз
cfr-whatsnew-lockwise-take-body =
    { -lockwise-brand-short-name } мобильді қолданбасы әр жерден сіздің қор
    көшірмедегі парольдерге қауіпсіз қатынауды мүмкін етеді.
cfr-whatsnew-lockwise-take-link-text = Қолданбаны алу

## Search Bar

cfr-whatsnew-searchbar-title = Адрестік жолақ көмегімен азырақ теріп, көбірек табыңыз.
cfr-whatsnew-searchbar-body-topsites = Енді адрестік жолағын таңдасаңыз, ол топ сайттарыңыз бар сілтемелермен кеңейеді.
cfr-whatsnew-searchbar-icon-alt-text = Үлкейту әйнегі таңбашасы

## Picture-in-Picture

cfr-whatsnew-pip-header = Шолу кезінде видеоларды қараңыз
cfr-whatsnew-pip-body = Суреттегі сурет режимі видеоны қалқымалы терезеде көрсетеді, оның көмегімен сіз басқа беттерде жасаған кезде де қарай аласыз.
cfr-whatsnew-pip-cta = Көбірек білу

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Сайттардың мазаны алатын азырақ қалқымалы хабарламалар.
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } енді сізге автоматты түрде қалқымалы хабарламаларды жіберуді сұрайтын сайттарды бұғаттайды.
cfr-whatsnew-permission-prompt-cta = Көбірек білу

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
       *[other] Цифрлық баспаны жинаушы бұғатталды
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } сіздің жарнамалық профиліңізді жасау мақсатында, құрылғыңыз және әрекеттеріңіз туралы ақпаратты жасырын жинайтын цифрлық баспаны жинаушылардың көбін бұғаттайды.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Баспаны жинаушылар
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } сіздің жарнамалық профиліңізді жасау мақсатында, құрылғыңыз және әрекеттеріңіз туралы ақпаратты жасырын жинайтын цифрлық баспаны жинаушыларды бұғаттай алады.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Бұл бетбелгіні өз телефоныңызға алыңыз
cfr-doorhanger-sync-bookmarks-body = Сіз { -brand-product-name } ішінде кірген барлық жерде бетбелгілер, парольдер, шолу тарихы және т.б. өзіңізбен бірге ұстаңыз.
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name } іске қосу
    .accesskey = с

## Login Sync

cfr-doorhanger-sync-logins-header = Парольдерді енді ешқашан ұмытпаңыз
cfr-doorhanger-sync-logins-body = Парольдерді қауіпсіз түрде сақтаңыз және құрылғыларыңыз арасында синхрондаңыз.
cfr-doorhanger-sync-logins-ok-button = { -sync-brand-short-name } іске қосу
    .accesskey = с

## Send Tab

cfr-doorhanger-send-tab-header = Мұны жолда оқыңыз
cfr-doorhanger-send-tab-recipe-header = Бұл рецептті ас үйге апарыңыз
cfr-doorhanger-send-tab-body = Беттерді жіберу мүмкіндігі арқылы бұл сілтемені телефоныңызға немесе сіз { -brand-product-name } ішіне кірген кез келген құрылғыға оңай жібере аласыз.
cfr-doorhanger-send-tab-ok-button = Бетті жіберуді қолданып көріңіз
    .accesskey = т

## Firefox Send

cfr-doorhanger-firefox-send-header = Бұл PDF файлымен қауіпсіз түрде бөлісіңіз
cfr-doorhanger-firefox-send-body = Құпия құжаттарыңызбен бөтен көзден тыс, толық шифрлеумен және дайын болғаннан кейін өшірілетін сілтеме арқылы бөлісіңіз.
cfr-doorhanger-firefox-send-ok-button = { -send-brand-name } қолданып көріңіз
    .accesskey = п

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Қорғанысты қарау
    .accesskey = р
cfr-doorhanger-socialtracking-close-button = Жабу
    .accesskey = Ж
cfr-doorhanger-socialtracking-dont-show-again = Енді осындай хабарламаларды көрсетпеу
    .accesskey = д
cfr-doorhanger-socialtracking-heading = { -brand-short-name } әлеуметтік желіні сізді осында бақылаудан блоктады
cfr-doorhanger-socialtracking-description = Жекелігіңіз маңызды. { -brand-short-name } енді әлеуметтік желілер трекерлерін бұғаттап, оларға сіз туралы қанша мәліметті жинай алатынын шектейді.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } бұл бетте цифрлық баспаны жинаушыны бұғаттады
cfr-doorhanger-fingerprinters-description = Жекелігіңіз маңызды. { -brand-short-name } енді цифрлық баспаны жинаушыларды бұғаттап, олар болса, сізді бақылау мақсатында сізді бірегей түрде анықтайтын ақпаратты жинайды.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } бұл бетте криптомайнерді бұғаттады
cfr-doorhanger-cryptominers-description = Жекелігіңіз маңызды. { -brand-short-name } енді сіздің компьютеріңіздің қуатын цифрлық валютаны табу үшін қолданатын криптомайнерлерді бұғаттайды.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] { -brand-short-name } { $date } <b>{ $blockedCount }</b> шамасынан көп трекерді бұғаттаған!
    }
cfr-doorhanger-milestone-ok-button = Барлығын қарау
    .accesskey = р

cfr-doorhanger-milestone-close-button = Жабу
    .accesskey = Ж

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Қауіпсіз парольдерді оңай жасау
cfr-whatsnew-lockwise-body = Әр тіркелгі үшін бірегей, қауіпсіз парольді ойлап табу оңай емес. Парольді жасау кезінде, { -brand-shorter-name } ұсынатын қауіпсіз, генерацияланған парольді қолдану үшін, пароль өрісін таңдаңыз.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } таңбашасы

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Осал парольдер жөнінде ескертулерді алыңыз
cfr-whatsnew-passwords-body = Хакерлер адамдардың бірдей парольдерді қайта қолданатынын біледі. Егер сіз бір парольді бірнеше сайтта қолданған болсаңыз және сол сайттардың бірінде деректер бұзылған болса, сол сайттардағы паролін өзгерту туралы { -lockwise-brand-short-name } ескертуін көресіз.
cfr-whatsnew-passwords-icon-alt = Осал паролі кілтінің белгісі

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Суреттегі суретті толық экранға шығарыңыз
cfr-whatsnew-pip-fullscreen-body = Видеоны қалқымалы терезеге бөліп жібергеннен кейін, оны енді қос шерту арқылы толық экран режиміне ауыстыруға болады.
cfr-whatsnew-pip-fullscreen-icon-alt = Суреттегі сурет таңбашасы

## Protections Dashboard message

cfr-whatsnew-protections-header = Қорғаныс көрінісі
cfr-whatsnew-protections-body = Қорғаныс панелінде деректерді бұзу және парольдерді басқару туралы жиынтық есептері бар. Енді сіз қанша деректер бұзушылығын шешкеніңізді және сақталған парольдеріңіздің қайсысы болса да, деректер бұзушылықтарда ашылғаны туралы ақпаратты бақылай аласыз.
cfr-whatsnew-protections-cta-link = Қорғаныс панелін қарау
cfr-whatsnew-protections-icon-alt = Қалқан таңбашасы

## Better PDF message

cfr-whatsnew-better-pdf-header = PDF-пен жақсырақ жұмыс
cfr-whatsnew-better-pdf-body = PDF құжаттары енді тікелей { -brand-short-name } ішінде ашылып, жұмыс үрдісіңізді жеңілдетеді.

## DOH Message

cfr-doorhanger-doh-body = Сіздің жекелігіңіз маңызды. { -brand-short-name } енді шолу кезінде сізді қорғау үшін DNS сұранымдарыңызды мүмкін болған кезде серіктес қызметі арқылы қауіпсіз түрде бағыттайды.
cfr-doorhanger-doh-header = Одан әрі қауіпсіз, шифрленген DNS іздеулері
cfr-doorhanger-doh-primary-button = Жақсы, түсіндім
    .accesskey = а
cfr-doorhanger-doh-secondary-button = Сөндіру
    .accesskey = д

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Жасырын бақылау техникасынан автоматты қорғаныс
cfr-whatsnew-clear-cookies-body = Кейбір трекерлер сізді cookie файлдарын құпия түрде орнататын басқа веб-сайттарға бағыттайды. { -brand-short-name } енді бұл cookie файлдарын автоматты түрде тазартады, сондықтан олар сізді бақылай алмайды.
cfr-whatsnew-clear-cookies-image-alt = Cookie файлы блокталған кескін
