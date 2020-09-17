# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Gomendatutako gehigarria
cfr-doorhanger-feature-heading = Gomendatutako eginbidea
cfr-doorhanger-pintab-heading = Probatu hau: ainguratu fitxa

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Zergatik ari naizen hau ikusten

cfr-doorhanger-extension-cancel-button = Une honetan ez
    .accesskey = n

cfr-doorhanger-extension-ok-button = Gehitu orain
    .accesskey = G
cfr-doorhanger-pintab-ok-button = Ainguratu fitxa hau
    .accesskey = A

cfr-doorhanger-extension-manage-settings-button = Kudeatu gomendioen ezarpenak
    .accesskey = K

cfr-doorhanger-extension-never-show-recommendation = Ez erakutsi gomendio hau
    .accesskey = z

cfr-doorhanger-extension-learn-more-link = Argibide gehiago

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = egilea: { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Gomendioa
cfr-doorhanger-extension-notification2 = Gomendioa
    .tooltiptext = Hedapenaren gomendioa
    .a11y-announcement = Hedapenaren gomendioa erabilgarri dago

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Gomendioa
    .tooltiptext = Eginbidearen gomendioa
    .a11y-announcement = Eginbidearen gomendioa erabilgarri dago

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] izar bat
           *[other] { $total } izar
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] erabiltzaile bat
       *[other] { $total } erabiltzaile
    }

cfr-doorhanger-pintab-description = Eskuratu gehien erabilitako guneetarako sarbide azkarra. Mantendu guneak zabalik fitxa batean (berrabiarazita ere bai).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = Egin <b>eskuin-klika</b> ainguratu nahi duzun fitxan.
cfr-doorhanger-pintab-step2 = Hautatu <b>Ainguratu fitxa</b> menu-aukera.
cfr-doorhanger-pintab-step3 = Gunea eguneratzen bada, puntu urdin bat ikusiko duzu ainguratutako fitxan.

cfr-doorhanger-pintab-animation-pause = Pausatu
cfr-doorhanger-pintab-animation-resume = Berrekin


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sinkronizatu laster-markak edonon.
cfr-doorhanger-bookmark-fxa-body = Ondo ikusia! Orain ez galdu laster-marka hau zure gailu mugikorretan. Hasi { -fxaccount-brand-name } erabiltzen.
cfr-doorhanger-bookmark-fxa-link-text = Sinkronizatu laster-markak orain…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Ixteko botoia
    .title = Itxi

## Protections panel

cfr-protections-panel-header = Nabigatu inor atzetik izan gabe
cfr-protections-panel-body = Mantendu zure datuak zuretzat. Lineako zure jardueraren jarraipena egiten duten elementu ohikoenetatik babesten zaitu { -brand-short-name }(e)k.
cfr-protections-panel-link-text = Argibide gehiago

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Eginbide berria:

cfr-whatsnew-button =
    .label = Nobedadeak
    .tooltiptext = Nobedadeak

cfr-whatsnew-panel-header = Nobedadeak

cfr-whatsnew-release-notes-link-text = Irakurri bertsio-oharrak

cfr-whatsnew-fx70-title = { -brand-short-name }(e)k zure pribatutasunarengatik gogorrago egiten du borrokan orain
cfr-whatsnew-fx70-body = Azken eguneraketak jarraipenaren babesaren eginbidea hobetzen du eta inoiz baino gehiago errazten du gune bakoitzerako pasahitzak sortzea.

cfr-whatsnew-tracking-protect-title = Babestu zure burua jarraipen-elementuetatik
cfr-whatsnew-tracking-protect-body = Zure jarraipena egiten duten sare sozialetako eta guneen arteko ohiko elementuak blokeatzen ditu orain { -brand-short-name }(e)k.
cfr-whatsnew-tracking-protect-link-text = Ikusi zure txostena

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Blokeatutako elementua
       *[other] Blokeatutako elementuak
    }
cfr-whatsnew-tracking-blocked-subtitle = Data honetatik: { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Ikusi txostena

cfr-whatsnew-lockwise-backup-title = Egin zure pasahitzen babeskopia
cfr-whatsnew-lockwise-backup-body = Sortu saioa hasi behar duzun toki orotan atzi ditzakezun pasahitz seguruak.
cfr-whatsnew-lockwise-backup-link-text = Aktibatu babeskopiak

cfr-whatsnew-lockwise-take-title = Eraman pasahitzak zurekin
cfr-whatsnew-lockwise-take-body = { -lockwise-brand-short-name } mugikorrerako aplikazioarekin babeskopian dituzun pasahitzak edonondik atzitu ahal izango dituzu.
cfr-whatsnew-lockwise-take-link-text = Eskuratu aplikazioa

## Search Bar

cfr-whatsnew-searchbar-title = Idatzi gutxiago eta aurkitu gehiago helbide-barra erabiliz
cfr-whatsnew-searchbar-body-topsites = Orain, hautatu helbide-barra eta kutxa bat hedatuko da zure zure gune erabilienetarako loturekin.
cfr-whatsnew-searchbar-icon-alt-text = Luparen ikonoa

## Picture-in-Picture

cfr-whatsnew-pip-header = Ikusi bideoak nabigatu ahala
cfr-whatsnew-pip-body = Bideoa beste leiho batean erabiliz, bideoa leiho mugikor batera mugitzen denez, beste fitxetan lan egin bitartean bideoa ikusten jarrai dezakezu.
cfr-whatsnew-pip-cta = Argibide gehiago

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Guneetako popup gogaikarri gutxiago
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name }(e)k guneak blokeatuko ditu orain, zuri popup mezuak bidaltzea automatikoki ez galdetzeko
cfr-whatsnew-permission-prompt-cta = Argibide gehiago

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Hatz-marka bidezko jarraipena blokeatuta
       *[other] Hatz-marka bidezko jarraipena blokeatuta
    }
cfr-whatsnew-fingerprinter-counter-body = Zuri buruzko iragarki-profila sortzeko asmoz zure gailuaren eta zure ekintzei buruzko informazioa sekretupean biltzen dituzten hatz-marka bidezko jarraipen-elementuak blokeatzen ditu { -brand-shorter-name }(e)k.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Hatz-marka bidezko jarraipena
cfr-whatsnew-fingerprinter-counter-body-alt = Zuri buruzko iragarki-profila sortzeko asmoz zure gailuaren eta zure ekintzei buruzko informazioa sekretupean biltzen dituzten hatz-marka bidezko jarraipen-elementuak blokea ditzake { -brand-shorter-name }(e)k.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Eskuratu laster-marka hau zure telefonoan
cfr-doorhanger-sync-bookmarks-body = Eraman zure laster-markak, pasahitzak, historia eta gehiago { -brand-product-name }(e)n saioa hasita duzun toki orotara.
cfr-doorhanger-sync-bookmarks-ok-button = Aktibatu { -sync-brand-short-name }
    .accesskey = A

## Login Sync

cfr-doorhanger-sync-logins-header = Ez galdu sekula pasahitzik berriro
cfr-doorhanger-sync-logins-body = Gorde eta sinkronizatu zure pasahitzak modu seguruan zure gailu guztietara.
cfr-doorhanger-sync-logins-ok-button = Aktibatu { -sync-brand-short-name }
    .accesskey = A

## Send Tab

cfr-doorhanger-send-tab-header = Irakurri hau edonon
cfr-doorhanger-send-tab-recipe-header = Eraman errezeta hau sukaldera
cfr-doorhanger-send-tab-body = Fitxa bidaltzeko aukeraren bitartez lotura hau zure telefonoarekin edo { -brand-product-name }(e)n saioa hasita duzun gailu ororekin parteka dezakezu modu errazean.
cfr-doorhanger-send-tab-ok-button = Probatu fitxa bidaltzeko aukera
    .accesskey = P

## Firefox Send

cfr-doorhanger-firefox-send-header = Partekatu PDF hau modu seguruan
cfr-doorhanger-firefox-send-body = Mantendu zure dokumentu sentikorrak kuxkuxeroengandik seguru muturretik muturrerako zifraketarekin eta erabili ondoren desagertzen den lotura batekin.
cfr-doorhanger-firefox-send-ok-button = Probatu { -send-brand-name }
    .accesskey = P

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Ikusi babesak
    .accesskey = k
cfr-doorhanger-socialtracking-close-button = Itxi
    .accesskey = x
cfr-doorhanger-socialtracking-dont-show-again = Ez erakutsi honelako mezu gehiago
    .accesskey = z
cfr-doorhanger-socialtracking-heading = Sare sozial batek zure jarraipena egitea eragotzi du { -brand-short-name }(e)k
cfr-doorhanger-socialtracking-description = Garrantzitsua da zure pribatutasuna. Sare sozialetako ohiko jarraipen-elementuak blokeatzen ditu orain { -brand-short-name }(e)k, zure lineako jarduerari buruz bil ditzaketen datuak mugatuz.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name }-ek hatz-marka bidezko jarraipena blokeatu du orri honetan
cfr-doorhanger-fingerprinters-description = Garrantzitsua da zure pribatutasuna. Hatz-marka bidezko jarraipena blokeatzen du orain { -brand-short-name }(e)k, zeinak zure gailuari buruzko identifikazio bakarreko datuak biltzen dituen zure jarraipena egiteko.
cfr-doorhanger-cryptominers-heading = { -brand-short-name }-ek kriptomeatzari bat blokeatu du orri honetan
cfr-doorhanger-cryptominers-description = Garrantzitsua da zure pribatutasuna. Kriptomeatzariak blokeatzen ditu orain { -brand-short-name }(e)k, zeinak zure sistemaren konputazio-ahalmena erabiltzen duten diru digitala ustiatzeko.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name }(e)k <b>{ $blockedCount }</b> jarraipen-elementu baino gehiago blokeatu ditu data honetatik aurrera: { $date }
       *[other] { -brand-short-name }(e)k <b>{ $blockedCount }</b> jarraipen-elementu baino gehiago blokeatu ditu data honetatik aurrera: { $date }
    }
cfr-doorhanger-milestone-ok-button = Ikusi guztiak
    .accesskey = I

cfr-doorhanger-milestone-close-button = Itxi
    .accesskey = x

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Sortu erraz pasahitz seguruak
cfr-whatsnew-lockwise-body = Zaila da kontu bakoitzerako pasahitz seguru eta bakarrak erabiltzea. Pasahitz bat sortzean, hautatu pasahitz eremua { -brand-shorter-name }(e)k sortutako pasahitz segurua erabiltzeko.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } ikonoa

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Jaso babesik gabeko pasahitzei buruzko abisuak
cfr-whatsnew-passwords-body = Hackerrek badakite jendeak pasahitz berdinak berrerabiltzen dituztela. Hainbat gunetan pasahitz berdina erabili eta gune horietakoren bat datu-urratze batean balego, abisua ikusiko duzu { -lockwise-brand-short-name }(e)n gune horietako zure pasahitza alda dezazun.
cfr-whatsnew-passwords-icon-alt = Babesik gabeko pasahitzaren giltzaren ikonoa

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Bideoa beste leiho batean pantaila osoan ikusteko aukera
cfr-whatsnew-pip-fullscreen-body = Bideo bat leiho mugikor batera eramatean, orain klik bikoitzarekin pantaila osora ere eraman dezakezu.
cfr-whatsnew-pip-fullscreen-icon-alt = Bideoa beste leiho batean eginbideko ikonoa

## Protections Dashboard message

cfr-whatsnew-protections-header = Babesak laburrean
cfr-whatsnew-protections-icon-alt = Babesaren ikonoa

## Better PDF message

cfr-whatsnew-better-pdf-header = PDF esperientzia hobetua
cfr-whatsnew-better-pdf-body = PDF dokumentuak orain zuzenean { -brand-short-name }(e)n irekitzen dira, zure lan egiteko modua erraztuz.

## DOH Message

cfr-doorhanger-doh-primary-button = Ados, ulertuta
    .accesskey = A
cfr-doorhanger-doh-secondary-button = Desgaitu
    .accesskey = D

## What's new: Cookies message

