# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Препоручене екстензије
cfr-doorhanger-feature-heading = Препоручена могућност
cfr-doorhanger-pintab-heading = Пробајте ово: закачи језичак

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Зашто видим ово

cfr-doorhanger-extension-cancel-button = Не сада
    .accesskey = N

cfr-doorhanger-extension-ok-button = Додај сада
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Закачи овај језичак
    .accesskey = P

cfr-doorhanger-extension-manage-settings-button = Управљај препорукама
    .accesskey = M

cfr-doorhanger-extension-never-show-recommendation = Не приказуј ми ову препоруку
    .accesskey = S

cfr-doorhanger-extension-learn-more-link = Сазнајте више

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = по { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Препоруке
cfr-doorhanger-extension-notification2 = Препорука
    .tooltiptext = Препорука за проширење
    .a11y-announcement = Препорука за проширење је доступна

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Препорука
    .tooltiptext = Препорука за својство
    .a11y-announcement = Препорука за својство је доступна

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } звезда
            [few] { $total } звезде
           *[other] { $total } звезди
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } корисник
        [few] { $total } корисника
       *[other] { $total } корисника
    }

cfr-doorhanger-pintab-description = Имајте брз приступ сајтовима које најчешће користите. Оставите сајтове отвореним у језичку (чак и након поновног покретања).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = Кликните <b>десним кликом</b> на језичак који желите закачити.
cfr-doorhanger-pintab-step2 = Изаберите <b>„Закачи језичак“</b> опцију из менија.
cfr-doorhanger-pintab-step3 = Уколико има новости на сајту, видећете плаву тачку на вашем закаченом језичку.

cfr-doorhanger-pintab-animation-pause = Заустави
cfr-doorhanger-pintab-animation-resume = Настави


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Синхронизујте своје забелешке свуда.
cfr-doorhanger-bookmark-fxa-body = Одлично откриће! Да бисте имали ову забелешку и на вашем мобилном уређају, крените са коришћењем услуге { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Синхронизуј забелешке сада…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Тастер затвори
    .title = Затвори

## Protections panel

cfr-protections-panel-header = Прегледајте без праћења
cfr-protections-panel-body = Задржите своје податке. { -brand-short-name } пружа заштиту од уобичајених трагача који прате ваше радње на мрежи.
cfr-protections-panel-link-text = Сазнајте више

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Нова функција:

cfr-whatsnew-button =
    .label = Шта је ново
    .tooltiptext = Шта је ново

cfr-whatsnew-panel-header = Шта је ново

cfr-whatsnew-release-notes-link-text = Прочитајте напомене о издању

cfr-whatsnew-fx70-title = { -brand-short-name } се сада бори још више за вашу приватност
cfr-whatsnew-fx70-body =
    Заштита од праћења је побољшана у најновијој верзији и олакшава вам
    стварање сигурних лозинки за појединачне веб странице.

cfr-whatsnew-tracking-protect-title = Заштитите се од софтвера за праћење
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } блокира многе уобичајене софтвере за праћење с друштвених мрежа и других веб страница
    који завирују у вашу активност прегледавања.
cfr-whatsnew-tracking-protect-link-text = Погледајте извештај о праћењу

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Блокиран софтвер за праћење
        [few] Блокирана софтвера за праћење
       *[other] Блокираних софтвера за праћење
    }
cfr-whatsnew-tracking-blocked-subtitle = Од { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Погледајте извештај

cfr-whatsnew-lockwise-backup-title = Направите резервну копију лозинки
cfr-whatsnew-lockwise-backup-body = Гениришите сигурне лозинке којима можете приступити било где да се пријављујете.
cfr-whatsnew-lockwise-backup-link-text = Укључите резерве

cfr-whatsnew-lockwise-take-title = Понесите ваше лозинке са собом
cfr-whatsnew-lockwise-take-body =
    { -lockwise-brand-short-name } апликација омогућава сигуран приступ вашој
    резервној копији лозинки на свим уређајима.
cfr-whatsnew-lockwise-take-link-text = Преузмите апликацију

## Search Bar

cfr-whatsnew-searchbar-title = Куцајте мање, нађите више помоћу адресне траке
cfr-whatsnew-searchbar-body-topsites = Сада само одаберите адресну траку и оквир ће се проширити са везама до ваших најпосећенијих страница.
cfr-whatsnew-searchbar-icon-alt-text = Иконица лупе

## Picture-in-Picture

cfr-whatsnew-pip-header = Гледајте видео записе док прегледате
cfr-whatsnew-pip-body = Слика-у-слици режим избаци видео у плутајући прозор, тако да можете гледати док радите у другим језичцима.
cfr-whatsnew-pip-cta = Сазнајте више

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Мање иритантних искакајућих прозора
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } сада блокира странице од аутоматског захтевања да вам шаљу искакајуће поруке.
cfr-whatsnew-permission-prompt-cta = Сазнајте више

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Блокиран узимач дигиталних отисака
        [few] Блокирана узимача дигиталних отисака
       *[other] Блокирано узимача дигиталних отисака
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } блокира многе узимаче дигиталних отисака, који тајно прикупљају информације о вашем уређају и радњама у сврху израде рекламног профила за вас.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Узимачи дигиталних отисака
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } може да блокира узимаче дигиталних отисака који тајно прикупљају информације о вашем уређају и радњама у сврху израде рекламног профила за вас.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Добијте ову забелешку на свом телефону
cfr-doorhanger-sync-bookmarks-body = Синхронизујте забелешке, лозинке, историју и друго на свим уређајима који су пријављени у { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Укључите { -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = Немојте поново изгубити лозинку
cfr-doorhanger-sync-logins-body = Безбедно чувајте и синхронизујте ваше лозинке на свим вашим уређајима.
cfr-doorhanger-sync-logins-ok-button = Укључите { -sync-brand-short-name }
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = Читајте ово у покрету
cfr-doorhanger-send-tab-recipe-header = Понесите овај рецепт у кухињу
cfr-doorhanger-send-tab-body = Слање језичка олакшава дељење веза између вашег телефона и било којих уређаја пријављених у { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Испробајте слање језичака
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Делите овај PDF безбедно
cfr-doorhanger-firefox-send-body = Користите шифровање с-краја-на-крај и везе које ће аутоматски нестати након употребе како бисте обезбедили сигурност осетљивих датотека.
cfr-doorhanger-firefox-send-ok-button = Испробајте { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Погледај заштите
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = Затвори
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = Немој ми више показивати овакве поруке
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } је блокирао друштвену мрежу да вас прати овде
cfr-doorhanger-socialtracking-description = Ваша приватност је битна. Од сада надаље, { -brand-short-name } блокира уобичајене софтвере за праћење с друштвених мрежа и ограничава ове веб странице да прикупљају вашу мрежну активност.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } је блокирао програм за праћење дигиталних отисака на овој страници
cfr-doorhanger-fingerprinters-description = Ваша приватност је битна. Од сада надаље, { -brand-short-name } блокира програме за праћење дигиталних отисака, који прикупљају делове јединствено препознатљивих података о вашем уређају да би вас пратили.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } је блокирао програм за ископавање криптовалута на овој страници
cfr-doorhanger-cryptominers-description = Ваша приватност је битна. Од сада надаље, { -brand-short-name } блокира програме за ископавање криптовалута, који користе рачунарску моћ вашег система да рударе дигитални новац.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] Од { $date }, { -brand-short-name } је блокирао више од <b>{ $blockedCount }</b> програма за праћење!
        [few] Од { $date }, { -brand-short-name } је блокирао више од <b>{ $blockedCount }</b> програма за праћење!
       *[other] Од { $date }, { -brand-short-name } је блокирао више од <b>{ $blockedCount }</b> програма за праћење!
    }
cfr-doorhanger-milestone-ok-button = Погледај све
    .accesskey = S

cfr-doorhanger-milestone-close-button = Затвори
    .accesskey = C

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Лако правите сигурне лозинке
cfr-whatsnew-lockwise-body = Није лако смислити јединствене и сигурне лозинке за сваки налог. Када правите лозинку, изаберите одговарајуће поље да бисте добили сигурну лозинку, коју смишља { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } иконица

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Добијајте упозорења о рањивим лозинкама
cfr-whatsnew-passwords-body = Хакери знају да људи понављају своје лозинке. Ако сте користили исту лозинку на више страница и једна од њих је била жртва цурења података, видећете упозорење у { -lockwise-brand-short-name }-у са захтевом да измените вашу лозинку на тим страницама.
cfr-whatsnew-passwords-icon-alt = Иконица рањиве лозинке

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Проширите слика-у-слици режим на цели екран
cfr-whatsnew-pip-fullscreen-body = Када видео поставите у плутајући прозор, сада га можете двапут кликнути да бисте прешли на цео екран.
cfr-whatsnew-pip-fullscreen-icon-alt = Слика-у-слици иконица

## Protections Dashboard message

cfr-whatsnew-protections-header = Заштита на први поглед
cfr-whatsnew-protections-body = Контролна табла заштите укључује сажетке извештаја о цурењу података и управљању лозинком. Сада можете пратити број решених цурења и видети да ли је и нека од ваших сачуваних лозинки била изложена цурењу података.
cfr-whatsnew-protections-cta-link = Погледај контролну таблу заштите
cfr-whatsnew-protections-icon-alt = Иконица штита

## Better PDF message

cfr-whatsnew-better-pdf-header = Боље PDF искуство
cfr-whatsnew-better-pdf-body = PDF документи се сада отварају директно у { -brand-short-name }-у, олакшавајући ток рада.

## DOH Message

cfr-doorhanger-doh-body = Ваша приватност је битна. { -brand-short-name } сада безбедно усмерава ваше DNS захтеве, кад год је то могуће, до партнерског сервиса како би вас заштитио док прегледате.
cfr-doorhanger-doh-header = Још сигурнији, шифровани DNS упити
cfr-doorhanger-doh-primary-button = У реду, разумем
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Онемогући
    .accesskey = D

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Аутоматска заштита од подмуклих тактика праћења
cfr-whatsnew-clear-cookies-body = Неки пратиоци вас преусмеравају на друге странице које тајно постављају колачиће. { -brand-short-name } сада аутоматски брише ове колачиће тако да вас не прате.
cfr-whatsnew-clear-cookies-image-alt = Колачић је блокирао илустрацију
