# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Oanrekommandearre útwreiding
cfr-doorhanger-feature-heading = Oanrekommandearre funksje
cfr-doorhanger-pintab-heading = Probearje dit: Ljepblêd fêstsette

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Wêrom sjoch ik dit

cfr-doorhanger-extension-cancel-button = No net
    .accesskey = N

cfr-doorhanger-extension-ok-button = No tafoegje
    .accesskey = t
cfr-doorhanger-pintab-ok-button = Dit ljepblêd fêstsette
    .accesskey = f

cfr-doorhanger-extension-manage-settings-button = Ynstellingen foar oanrekommandaasjes beheare
    .accesskey = o

cfr-doorhanger-extension-never-show-recommendation = Dizze oanrekommandaasje net toane
    .accesskey = D

cfr-doorhanger-extension-learn-more-link = Mear ynfo

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = troch { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Oanrekommandaasje
cfr-doorhanger-extension-notification2 = Oanrekommandaasje
    .tooltiptext = Oanrekommandaasje foar útwreiding
    .a11y-announcement = Oanrekommandaasje foar útwreiding beskikber

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Oanrekommandaasje
    .tooltiptext = Oanrekommandaasje foar funksje
    .a11y-announcement = Oanrekommandaasje foar funksje beskikber

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } stjer
           *[other] { $total } stjerren
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } brûker
       *[other] { $total } brûkers
    }

cfr-doorhanger-pintab-description = Maklike tagong ta jo meastbrûkte websites. Hâld websites iepen yn in ljepblêd (sels wannear't jo opnij starte).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Klik mei de rjochtermûsknop</b> op it ljepblêd dat jo fêstmeitsje wolle.
cfr-doorhanger-pintab-step2 = Selektearje <b>Ljepblêd fêstmeitsje</b> fan it menu út.
cfr-doorhanger-pintab-step3 = As de website in fernijing befettet, sjogge jo in blauwe stip op jo fêstmakke ljepblêd.

cfr-doorhanger-pintab-animation-pause = Pausearje
cfr-doorhanger-pintab-animation-resume = Ferfetsje


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Syngronisearje jo blêdwizers oeral.
cfr-doorhanger-bookmark-fxa-body = Goed fûn! Soargje der no foar dat jo net sûnder blêdwizers sitte op jo mobile apparaten. Start no mei { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Blêdwizers no syngronisearje…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Knop Slute
    .title = Slute

## Protections panel

cfr-protections-panel-header = Sneup sûnder folge te wurden
cfr-protections-panel-body = Hâld jo gegevens foar josels. { -brand-short-name } beskermet jo tsjin in protte fan de meast foarkommende trackers dy't folgje wat jo online dogge.
cfr-protections-panel-link-text = Mear ynfo

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nije funksje:

cfr-whatsnew-button =
    .label = Wat is der nij
    .tooltiptext = Wat is der nij

cfr-whatsnew-panel-header = Wat is der nij

cfr-whatsnew-release-notes-link-text = Utjefteopmerkingen lêze

cfr-whatsnew-fx70-title = { -brand-short-name } fjochtet no noch hurder foar jo privacy
cfr-whatsnew-fx70-body =
    De lêste fernijing ferbetteret de funksje Beskerming tsjin folgjen en makket it
    makliker as ea om feilige wachtwurden foar elke website te meitsjen.

cfr-whatsnew-tracking-protect-title = Beskermje josels tsjin trackers
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } blokkearret in protte gebrûklike sosjale en cross-site-trackers dy't
    folgje wat jo online dogge.
cfr-whatsnew-tracking-protect-link-text = Jo rapport besjen

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Tracker blokkearre
       *[other] Trackers blokkearre
    }
cfr-whatsnew-tracking-blocked-subtitle = Sûnt { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Rapport besjen

cfr-whatsnew-lockwise-backup-title = Meitsje in reservekopy fan jo wachtwurden
cfr-whatsnew-lockwise-backup-body = Meitsje no feilige wachtwurden dy't jo oeral wêr't jo jo oanmelde benaderje kinne.
cfr-whatsnew-lockwise-backup-link-text = Reservekopyen ynskeakelje

cfr-whatsnew-lockwise-take-title = Nim jo wachtwurden mei
cfr-whatsnew-lockwise-take-body =
    Mei de mobile app { -lockwise-brand-short-name } hawwe jo oeral feilich
    tagong ta jo wachtwurden.
cfr-whatsnew-lockwise-take-link-text = App downloade

## Search Bar

cfr-whatsnew-searchbar-title = Typ minder, fyn mear mei de adresbalke
cfr-whatsnew-searchbar-body-topsites = Selektearje no ienfâldichwei de adresbalke en in fek sil útwreidzje mei fluchkeppelingen nei jo topwebsites.
cfr-whatsnew-searchbar-icon-alt-text = Fergrutglêspiktogram

## Picture-in-Picture

cfr-whatsnew-pip-header = Besjoch fideo's wylst jo sneupe
cfr-whatsnew-pip-body = Picture-in-picture set in fideo yn in swevend finster, sadat jo sjen kinne wylst jo op oare ljepblêden wurkje.
cfr-whatsnew-pip-cta = Mear ynfo

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Minder ferfelende pop-ups fan websites
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } ferhinderet no dat websites jo automatysk freegje of se jo pop-upberjochten stjoere meie.
cfr-whatsnew-permission-prompt-cta = Mear ynfo

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Fingerprinter blokkearre
       *[other] Fingerprinters blokkearre
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } blokkearret in protte fingerprinters, dy't stikem ynformaasje oer jo apparaat en hannelingen sammelje om in advertinsjeprofyl fan jo te meitsjen.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Fingerprinters
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } kin fingerprinters, dy't stikem ynformaasje oer jo apparaat en hannelingen sammelje om in advertinsjeprofyl fan jo te meitsjen, blokkearje.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Dizze blêdwizer op jo telefoan ûntfange
cfr-doorhanger-sync-bookmarks-body = Nim jo blêdwizers, wachtwurden, skiednis en mear mei nei oeral wêr't jo oanmeld binne by { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name } ynskeakelje
    .accesskey = y

## Login Sync

cfr-doorhanger-sync-logins-header = Ferlies nea mear in wachtwurd
cfr-doorhanger-sync-logins-body = Bewarje en syngronisearje jo wachtwurden feilich op al jo apparaten.
cfr-doorhanger-sync-logins-ok-button = { -sync-brand-short-name } ynskeakelje
    .accesskey = y

## Send Tab

cfr-doorhanger-send-tab-header = Dit ûnderweis lêze
cfr-doorhanger-send-tab-recipe-header = Dit resept meinimme nei de keuken
cfr-doorhanger-send-tab-body = Mei Send Tab kinne jo ienfâldich dizze keppeling mei jo telefoan diele, of wêr't jo ek mar oanmeld binne by { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Send Tab probearje
    .accesskey = p

## Firefox Send

cfr-doorhanger-firefox-send-header = Dit pdf-dokumint feilich diele
cfr-doorhanger-firefox-send-body = Hâld jo gefoelige dokuminten wei fan nijsgjirrige blikken mei end-to-end-fersifering en in keppeling dy't ferdwynt as jo klear binne.
cfr-doorhanger-firefox-send-ok-button = { -send-brand-name } probearje
    .accesskey = p

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Beskermingen besjen
    .accesskey = B
cfr-doorhanger-socialtracking-close-button = Slute
    .accesskey = S
cfr-doorhanger-socialtracking-dont-show-again = Dit soarte fan berjochten net mear toane
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } hat opkeard dat in sosjaal netwurk jo hjir folget
cfr-doorhanger-socialtracking-description = Jo privacy is wichtich. { -brand-short-name } blokkearret no faak brûkte sosjale-mediatrackers en beheint sa, hoefolle gegevens se sammelje oer wat jo online dogge.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } hat in fingerprinter op dizze side blokkearre
cfr-doorhanger-fingerprinters-description = Jo privacy is wichtich. { -brand-short-name } blokkearret no fingerprinters, dy't stikjes unyk identifisearbere ynformaasje oer jo apparaat sammelje om jo te folgjen.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } hat in cryptominer op dizze side blokkearre
cfr-doorhanger-cryptominers-description = Jo privacy is wichtich. { -brand-short-name } blokkearret no cryptominers, dy't de kompjûterkrêft fan jo systeem brûke om digitaal jild te minen.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } hat <b>{ $blockedCount }</b> tracker blokkearre sûnt { $date }!
       *[other] { -brand-short-name } hat mear as <b>{ $blockedCount }</b> trackers blokkearre sûnt { $date }!
    }
cfr-doorhanger-milestone-ok-button = Alles besjen
    .accesskey = A

cfr-doorhanger-milestone-close-button = Slute
    .accesskey = S

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Meitsje ienfâldich feilige wachtwurden
cfr-whatsnew-lockwise-body = It is swier om foar elke account unike, feilige wachtwurden te betinken. Selektearje by it meitsjen fan in wachtwurd it wachtwurdfjild om in feilich, oanmakke wachtwurd fan { -brand-shorter-name } te brûken.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name }-piktogram

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Untfang meldingen oer kwetsbere wachtwurden
cfr-whatsnew-passwords-body = Hackers witte dat minsken deselde wachtwurden opnij brûke. As jo itselde wachtwurd op meardere websites brûkt hawwe en ien fan dy websites troffen is troch in datalek, dan sjogge jo in melding yn { -lockwise-brand-short-name } om jo wachtwurd op dy websites te wizigjen.
cfr-whatsnew-passwords-icon-alt = Kaaipiktogram foar kwetsber wachtwurd

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Meitsje picture-in-picture skermfullend
cfr-whatsnew-pip-fullscreen-body = Wannear't jo in fideo yn in swevend skerm pleatse, kinne jo dêr no op dûbelklikke om it skermfullend te meitsjen.
cfr-whatsnew-pip-fullscreen-icon-alt = Piktogram Picture-in-Picture

## Protections Dashboard message

cfr-whatsnew-protections-header = Beskerming yn ien eachopslach
cfr-whatsnew-protections-body = It Befeiligingsdashboerd befettet gearfettingen oer datalekken en wachtwurdbehear. Jo kinne no folgje hofolle datalekken jo oplost hawwe en besjen oft jo bewarre wachtwurden mooglik troffen binne troch in datalek.
cfr-whatsnew-protections-cta-link = Befeiligingsdashboerd besjen
cfr-whatsnew-protections-icon-alt = Skildpiktogram

## Better PDF message

cfr-whatsnew-better-pdf-header = Bettere PDF-ûnderfining
cfr-whatsnew-better-pdf-body = PDF-dokuminten wurde no streekrjocht iepene yn { -brand-short-name }, wêrtroch jo wurk deunby bliuwt.

## DOH Message

cfr-doorhanger-doh-body = Jo privacy is wichtich. { -brand-short-name } liedt no wêr mooglik jo DNS-fersiken feilich nei in partnerservice om jo te beskermjen wylst jo sneupe.
cfr-doorhanger-doh-header = Feiligere, fersifere DNS-lookups
cfr-doorhanger-doh-primary-button = OK, begrepen
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Utskeakelje
    .accesskey = U

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Automatyske beskerming tsjin stikeme folchtaktiken
cfr-whatsnew-clear-cookies-body = Guon trackers liede jo troch nei oare websites dy't yn it geheim cookies pleatse. { -brand-short-name } wisket dy cookies no automatysk, sadat jo net folge wurde kin.
cfr-whatsnew-clear-cookies-image-alt = Ofbylding Cookie blokkearre
