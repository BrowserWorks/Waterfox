# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Zgjerim i Këshilluar
cfr-doorhanger-feature-heading = Veçori e Këshilluar
cfr-doorhanger-pintab-heading = Provoni Këtë: Fiksoni Skedë

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Pse më del kjo?

cfr-doorhanger-extension-cancel-button = Jo Tani
    .accesskey = J

cfr-doorhanger-extension-ok-button = Shtoje Tani
    .accesskey = S
cfr-doorhanger-pintab-ok-button = Fiksojeni Këtë Skedë
    .accesskey = F

cfr-doorhanger-extension-manage-settings-button = Administroni Rregullimet Mbi Rekomandimet
    .accesskey = A

cfr-doorhanger-extension-never-show-recommendation = Mos Ma Shfaq Këtë Rekomandim
    .accesskey = o

cfr-doorhanger-extension-learn-more-link = Mësoni më tepër

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = nga { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Rekomandim
cfr-doorhanger-extension-notification2 = Rekomandim
    .tooltiptext = Rekomandim zgjerimi
    .a11y-announcement = Ka gati një rekomandim zgjerimi

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Rekomandim
    .tooltiptext = Rekomandim veçorie
    .a11y-announcement = Ka gati një rekomandim veçorie

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } yll
           *[other] { $total } yje
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } përdorues
       *[other] { $total } përdorues
    }

cfr-doorhanger-pintab-description = Hyni kollaj te sajtet tuaj më të përdorur. Mbajini sajtet hapur në një skedë (madje edhe kur bëni rinisje).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Djathtasklikoni</b> te skeda që doni të fiksohet.
cfr-doorhanger-pintab-step2 = Përzgjidhni <b>Fiksoje Skedën</b> që nga menuja.
cfr-doorhanger-pintab-step3 = Nëse sajti ka një përditësim, do të shihni një pikë blu te skeda juaj e fiksuar.

cfr-doorhanger-pintab-animation-pause = Ndalesë
cfr-doorhanger-pintab-animation-resume = Vazhdoje


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Njëkohësoni faqerojtësit tuaj kudo.
cfr-doorhanger-bookmark-fxa-body = Gjetje e fortë! Tani, mos rrini pa këtë faqerojtës në pajisjet tuaja celulare. Fillojani me një { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Njëkohësoni faqerojtës që tani…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Buton mbylljeje
    .title = Mbylle

## Protections panel

cfr-protections-panel-header = Shfletoni pa qenë i ndjekur
cfr-protections-panel-body = Mbajini për vete të dhënat tuaja. { -brand-short-name } ju mbron nga shumë prej gjurmuesve më të rëndomtë që ndjekin ç’bëni në internet.
cfr-protections-panel-link-text = Mësoni më tepër

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Veçori e re:

cfr-whatsnew-button =
    .label = Ç’ka të Re
    .tooltiptext = Ç’ka të Re

cfr-whatsnew-panel-header = Ç’ka të Re

cfr-whatsnew-release-notes-link-text = Lexoni shënimet mbi hedhjen në qarkullim

cfr-whatsnew-fx70-title = { -brand-short-name } tanimë ndeshet më fort për privatësinë tuaj
cfr-whatsnew-fx70-body = Përditësimet më të reja thellojnë veçorinë e Mbrojtjes Nga Gjurmimi dhe e bëjnë më të lehtë se kurrë krijimin e fjalëkalimeve të siguruar për çdo sajt.

cfr-whatsnew-tracking-protect-title = Mbroni veten nga gjurmuesit
cfr-whatsnew-tracking-protect-body = { -brand-short-name } bllokon mjaft gjurmues të rëndomtë rrjetesh shoqërorë dhe të tjerë që ju ndjekin nga sajti në sajt për të gjurmuar ç’bëni në internet.
cfr-whatsnew-tracking-protect-link-text = Shihni Raportin Tuaj

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Gjurmues i bllokuar
       *[other] Gjurmues të bllokuar
    }
cfr-whatsnew-tracking-blocked-subtitle = Që prej { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Shihni Raportin

cfr-whatsnew-lockwise-backup-title = Kopjeruani fjalëkalimet tuaj
cfr-whatsnew-lockwise-backup-body = Tanimë prodhoni fjalëkalime të siguruar që mund t’i përdorni kudo që bëni hyrje.
cfr-whatsnew-lockwise-backup-link-text = Aktivizoni kopjeruajtjet

cfr-whatsnew-lockwise-take-title = Merrini fjalëkalimet tuaj me vete
cfr-whatsnew-lockwise-take-body = Aplikacioni { -lockwise-brand-short-name } për celular ju lejon të përdorni në mënyrë të parrezik prej ngado fjalëkalimet që keni kopjeruajtur.
cfr-whatsnew-lockwise-take-link-text = Merrni aplikacionin

## Search Bar

cfr-whatsnew-searchbar-title = Shtypni më pak, gjeni më shumë me shtyllën e adresave
cfr-whatsnew-searchbar-body-topsites = Tani, thjesht përzgjidhni shtyllën e adresave, dhe do të zgjerohet një kuadrat me lidhje për te sajtet tuaj kryesues.
cfr-whatsnew-searchbar-icon-alt-text = Ikonë thjerrëze zmadhimi

## Picture-in-Picture

cfr-whatsnew-pip-header = Shihni video teksa shfletoni
cfr-whatsnew-pip-body = “Picture-in-picture” e hap videon në një dritare përsipër, kështu që mundeni ta shihni teksa punoni në skeda të tjera.
cfr-whatsnew-pip-cta = Mësoni më tepër

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Më pak flluska të bezdisshme nga sajte
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name }-i tani u bllokon sajteve të kërkojnë automatikisht t’ju dërgojnë mesazhe flluska.
cfr-whatsnew-permission-prompt-cta = Mësoni më tepër

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Krijues shenjash gishtash i bllokuar
       *[other] Krijues shenjash gishtash të bllokuar
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name }-i bllokon mjaft nga krijuesit e shenjave të gishtave që grumbullojnë fshehtas informacion mbi pajisjen dhe veprimet tuaja, për të krijuar një profil tuajin të synuar nga reklamuesit.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Krijues shenjash gishtash
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name }-i mund të bllokojë krijues shenjash gishtash që grumbullojnë fshehtas informacion mbi pajisjen dhe veprimet tuaja, për të krijuar një profil tuajin të synuar nga reklamuesit.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Merreni këtë faqerojtës në telefonin tuaj
cfr-doorhanger-sync-bookmarks-body = Merrini faqerojtësit tuaj, fjalëkalimet, historikun, etj, kudo ku keni bërë hyrjen në { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Aktivizoni { -sync-brand-short-name }
    .accesskey = A

## Login Sync

cfr-doorhanger-sync-logins-header = Mos Humbni Kurrë Më një Fjalëkalim
cfr-doorhanger-sync-logins-body = Depozitoni dhe njëkohësoni në mënyrë të sigurt fjalëkalimet tuaj në krejt pajisjet tuaja.
cfr-doorhanger-sync-logins-ok-button = Aktivizoni { -sync-brand-short-name }
    .accesskey = A

## Send Tab

cfr-doorhanger-send-tab-header = Lexojeni në rrugë e sipër
cfr-doorhanger-send-tab-recipe-header = Merreni këtë recetë gatimi me vete në kuzhinë
cfr-doorhanger-send-tab-body = Dërgoni Skeda ju lejon ta ndani lehtësisht këtë lidhje në telefonin tuaj ose kudo ku keni bërë hyrjen te { -brand-product-name }-i.
cfr-doorhanger-send-tab-ok-button = Provoni Dërgim Skedash
    .accesskey = P

## Firefox Send

cfr-doorhanger-firefox-send-header = Ndajeni me të tjerët në mënyrë të parrezik këtë PDF
cfr-doorhanger-firefox-send-body = Mbajini dokumentet tuaj rezervat të parrezikuar nga sy përgjues, me fshehtëzim skaj-më-skaj dhe një lidhje që zhduket pasi të keni mbaruar punë.
cfr-doorhanger-firefox-send-ok-button = Provoni { -send-brand-name }
    .accesskey = P

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Shihni Mbrojtje
    .accesskey = o
cfr-doorhanger-socialtracking-close-button = Mbylle
    .accesskey = M
cfr-doorhanger-socialtracking-dont-show-again = Mos më shfaq më mesazhe të tillë
    .accesskey = M
cfr-doorhanger-socialtracking-heading = { -brand-short-name } ndali gjurmimin tuaj këtu nga një rrjet shoqëror
cfr-doorhanger-socialtracking-description = Privatësia juaj ka vlerë. { -brand-short-name } tanimë bllokon gjurmues prej rrjetesh të zakonshëm mediash shoqërore, duke kufizuar sa të dhëna mund të grumbullojnë rreth asaj çka bëni në internet.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } bllokoi në këtë faqe nëj krijuesh shenjash gishtash
cfr-doorhanger-fingerprinters-description = Privatësia juaj ka vlerë. { -brand-short-name } tanimë bllokon krijues shenjash gishtash, të cilët grumbullojnë rreth pajisjes tuaj të dhëna të identifikueshme në mënyrë unike për t’ju gjurmuar.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } bllokoi në këtë faqe një nxjerrës kriptomonedhash
cfr-doorhanger-cryptominers-description = Privatësia juaj ka vlerë. { -brand-short-name } tanimë bllokon nxjerrës kriptomonedhash, të cilët përdorin fuqinë e përllogaritjes së sistemit tuaj për të nxjerrë para dixhitale.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] 	{ -brand-short-name } bllokoi mbi <b>{ $blockedCount }</b> gjurmues që prej { $date }!
       *[other] 	{ -brand-short-name } bllokoi mbi <b>{ $blockedCount }</b> gjurmues që prej { $date }!
    }
cfr-doorhanger-milestone-ok-button = Shihini Krejt
    .accesskey = S

cfr-doorhanger-milestone-close-button = Mbylle
    .accesskey = M

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Krijoni me lehtësi fjalëkalime të sigurt
cfr-whatsnew-lockwise-body = Është e vështirë të mendohen fjalëkalime unikë, të sigurt, për çdo llogari. Kur krijohet një fjalëkalim, përzgjidhni fushën e fjalëkalimit për të përdorur një fjalëkalim të sigurt, të prodhuar nga { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Ikonë { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Merrni sinjalizime rreth fjalëkalimesh të cenueshëm
cfr-whatsnew-passwords-body = Hacker-ët e dinë që njerësit përdorin të njëjtët fjalëkalime. Nëse përdorni të njëjtin fjalëkalim në shumë sajte, dhe një nga këta sajte është parë në një cenim të dhënash, do të shihni një sinjalizim te { -lockwise-brand-short-name } për të ndryshuar fjalëkalimin tuaj në këto sajte.
cfr-whatsnew-passwords-icon-alt = Ikonë dry fjalëkalimi të cenueshëm

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Bëni foto-në-foto sa krejt ekrani
cfr-whatsnew-pip-fullscreen-body = Kur hapni një video brenda një dritareje pezull, tani mundeni të dyklikoni mbi atë dritare për ta kaluar sa krejt ekrani.
cfr-whatsnew-pip-fullscreen-icon-alt = Ikonë foto-në foto

## Protections Dashboard message

cfr-whatsnew-protections-header = Mbrojtje përmbledhtasi
cfr-whatsnew-protections-body = Pulti i Mbrojtjeve përfshin raporte përmbledhëse rreth cenimesh të dhënash dhe administrimi fjalëkalimesh. Tani mund të ndiqni se sa cenime keni zgjidhur, dhe të shihni nëse ndonjë nga fjalëkalimet tuaj të ruajtur është ekspozuar në një cenim të dhënash.
cfr-whatsnew-protections-cta-link = Shihni Pult Mbrojtjesh
cfr-whatsnew-protections-icon-alt = Ikona mburojë

## Better PDF message

cfr-whatsnew-better-pdf-header = Punim më i mirë me PDF-të
cfr-whatsnew-better-pdf-body = Dokumentet PDF tani hapen drejt e në { -brand-short-name }, duke e lehtësuar rrjedhën tuaj të punës.

## DOH Message

cfr-doorhanger-doh-body = Privatësia juaj ka rëndësi. { -brand-short-name }-i tani e tutje ia kalon në mënyrë të siguruar kërkesat tuaja DNS, kurdo që është e mundur, një shërbimi partner, për t’ju mbrojtur teksa shfletoni.
cfr-doorhanger-doh-header = Kërkesa DNS të fshehtëzuara, më të sigurta
cfr-doorhanger-doh-primary-button = OK, e mora vesh
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Çaktivizoje
    .accesskey = Ç

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Mbrojtje e automatizuar nga taktika gjurmimi dredharak
cfr-whatsnew-clear-cookies-body = Disa gjurmues ju ridrejtojnë te sajte të tjerë që depozitojnë fshehtazi cookies. { -brand-short-name }-i tanimë i spastron automatikisht këto cookies, ndaj s’mund të ndiqeni.
cfr-whatsnew-clear-cookies-image-alt = Ilustrim bllokimi cookie-sh
