# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Rekomendata etendaĵo
cfr-doorhanger-feature-heading = Rekomendata trajto
cfr-doorhanger-pintab-heading = Konsileto: alpingli tiun ĉi langeton

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Kial mi vidas tion ĉi?

cfr-doorhanger-extension-cancel-button = Poste
    .accesskey = P

cfr-doorhanger-extension-ok-button = Aldoni nun
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Alpingli tiun ĉi langeton
    .accesskey = p

cfr-doorhanger-extension-manage-settings-button = Administri agordojn de rekomendoj
    .accesskey = A

cfr-doorhanger-extension-never-show-recommendation = Ne montri al mi tiun ĉi rekomendon
    .accesskey = N

cfr-doorhanger-extension-learn-more-link = Pli da informo

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = de { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Rekomendo
cfr-doorhanger-extension-notification2 = Rekomendo
    .tooltiptext = Rekomendo pri etendaĵo
    .a11y-announcement = Havebla rekomendo pri etendaĵo

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Rekomendo
    .tooltiptext = Rekomendo pri trajto
    .a11y-announcement = Havebla rekomendo pri trajto

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } stelo
           *[other] { $total } steloj
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } uzanto
       *[other] { $total } uzantoj
    }

cfr-doorhanger-pintab-description = Facila aliro al viaj plej uzataj retejoj. Teni retejojn malfermitaj en langeto (eĉ kiam vi restartigas).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Dekstre alklaku</b> por alpingli la langeton.
cfr-doorhanger-pintab-step2 = Elektu <b>Alpingli langeton</b> el la menuo.
cfr-doorhanger-pintab-step3 = Se la retejo aktualiĝos, vi vidos bluan punkton sur la alpinglita langeto.

cfr-doorhanger-pintab-animation-pause = Paŭzigi
cfr-doorhanger-pintab-animation-resume = Daŭrigi


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Spegulu viajn legosignojn ĉie.
cfr-doorhanger-bookmark-fxa-body = Bona trovaĵo! Nun, retrovu tiun ĉi legosignon en viaj poŝaparatoj. Komencu per { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Speguli legosignojn nun…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Ferma butono
    .title = Fermi

## Protections panel

cfr-protections-panel-header = Retumu sen esti observata
cfr-protections-panel-body = Gardu viajn datumojn por vi mem. { -brand-short-name } protektas vin de pluraj el la plej oftaj spuriloj, kiuj sekvas vian retumon.
cfr-protections-panel-link-text = Pli da informo

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nova trajto:

cfr-whatsnew-button =
    .label = Novaĵoj
    .tooltiptext = Novaĵoj

cfr-whatsnew-panel-header = Novaĵoj

cfr-whatsnew-release-notes-link-text = Legi la notojn pri liverado

cfr-whatsnew-fx70-title = { -brand-short-name } luktas pli forte por via privateco
cfr-whatsnew-fx70-body =
    La lasta ĝisdatigo plibonigas la protekton kontraŭ spurado kaj faciligas la
    kreadon de sekuraj pasvortoj por ĉiu retejo.

cfr-whatsnew-tracking-protect-title = Protektu vin kontraŭ spuriloj
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } blokas plurajn oftajn sociajn kaj interretejajn spurilojn,
    kiuj sekvas vian retumon.
cfr-whatsnew-tracking-protect-link-text = Vidi vian raporton

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] spurilo blokita
       *[other] spuriloj blokitaj
    }
cfr-whatsnew-tracking-blocked-subtitle = ekde { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Vidi raporton

cfr-whatsnew-lockwise-backup-title = Sekurkopii viajn pasvortojn
cfr-whatsnew-lockwise-backup-body = Nun kreu sekurajn pasvortojn, kiujn vi povas aliri ĉie, kie vi konektiĝas.
cfr-whatsnew-lockwise-backup-link-text = Ŝalti sekurkopiojn

cfr-whatsnew-lockwise-take-title = Kunportu viajn pasvortojn
cfr-whatsnew-lockwise-take-body =
    La poŝaparata programo { -lockwise-brand-short-name } permesas al vi sekure aliri viajn
    konservitajn pasvortojn, el ie ajn.
cfr-whatsnew-lockwise-take-link-text = Ricevi la programon

## Search Bar

cfr-whatsnew-searchbar-title = Tajpu malpli, trovu pli per la adresa strio
cfr-whatsnew-searchbar-body-topsites = Ekde nun, simple iru al la adresa strio kaj aperos kadro kun ligiloj al viaj plej vizititaj retejoj.
cfr-whatsnew-searchbar-icon-alt-text = Emblemo de lupeo

## Picture-in-Picture

cfr-whatsnew-pip-header = Spektu filmetojn dum vi retumas
cfr-whatsnew-pip-body = Bildo en bildo spruĉigas filmeton en flosantan fenestron, tiel ke vi povas plu spekti dum vi laboras en aliaj langetoj.
cfr-whatsnew-pip-cta = Pli da informo

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Malpli da tedaj retejaj ŝprucfenestroj
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } nun blokas la aŭtomatan peton pri permeso sendi al vi ŝprucmesaĝojn.
cfr-whatsnew-permission-prompt-cta = Pli da informo

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Blokita identigilo de ciferecaj spuroj
       *[other] Blokitaj identigiloj de ciferecaj spuroj
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } blokas plurajn identigilojn de ciferecaj spuroj, kiuj sekrete kolektas informon pri via aparato kaj agoj por krei reklaman profilon pri vi.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Identigiloj de ciferecaj spuroj
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } povas bloki plurajn identigilojn de ciferecaj spuroj, kiuj sekrete kolektas informon pri via aparato kaj agoj por krei reklaman profilon pri vi.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Ricevu tiun ĉi legosignon en via telefono
cfr-doorhanger-sync-bookmarks-body = Kunportu viajn legosignojn, pasvortojn, historion kaj pli da afero ĉien, kie vi komencis seancon de { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Ŝalti { -sync-brand-short-name }
    .accesskey = a

## Login Sync

cfr-doorhanger-sync-logins-header = Neniam denove perdu pasvorton
cfr-doorhanger-sync-logins-body = Sekure konservu kaj spegulu viajn pasvortojn en ĉiuj viaj aparatoj.
cfr-doorhanger-sync-logins-ok-button = Ŝalti { -sync-brand-short-name }
    .accesskey = a

## Send Tab

cfr-doorhanger-send-tab-header = Legu tion ĉi ie ajn
cfr-doorhanger-send-tab-recipe-header = Portu tiun ĉi recepton al la kuirejo
cfr-doorhanger-send-tab-body = "Sendi langeton" permesas al vi facile sendi tiun ĉi ligilon al via telefono aŭ ien ajn, kie vi komencis seancon de { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Provu la sendon de langeto
    .accesskey = P

## Firefox Send

cfr-doorhanger-firefox-send-header = Sekure dividi tiun ĉi PDF
cfr-doorhanger-firefox-send-body = Gardu viajn konfidecajn dokumentojn sekure kaj for de trudaj rigardoj per ĉifrado interklienta kaj ligiloj kiuj malaperas kiam vi finas.
cfr-doorhanger-firefox-send-ok-button = Provu { -send-brand-name }
    .accesskey = P

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Vidi protektojn
    .accesskey = V
cfr-doorhanger-socialtracking-close-button = Fermi
    .accesskey = F
cfr-doorhanger-socialtracking-dont-show-again = Ne montri al ĉi tiajn mesaĝojn denove
    .accesskey = N
cfr-doorhanger-socialtracking-heading = { -brand-short-name } evitis ke spurilo socireta sekvu vin ĉi tie
cfr-doorhanger-socialtracking-description = Via privateco gravas. { -brand-short-name } blokas nun oftajn sociretajn spurilojn, kio limigas la kvanton de datumoj pri via retumo, kiun ili povas kolekti.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } blokis identigilon de cifereca spuro en tiu ĉi paĝo
cfr-doorhanger-fingerprinters-description = Via privateco gravas. { -brand-short-name } nun blokas identigilojn de ciferecaj spuroj, kiuj kolektas informojn pri via aparato, kiu unike identigas vin, por povi sekvi vian retumon.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } blokis minilon de ĉifromono en tiu ĉi paĝo
cfr-doorhanger-cryptominers-description = Via privateco gravas. { -brand-short-name } nun blokas minilojn de ĉifromono, kiuj uzas la povon kalkulan de via aparato por mini ciferecan monon.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] { -brand-short-name } blokis pli ol <b>{ $blockedCount }</b> spurilojn ekde { $date }!
    }
cfr-doorhanger-milestone-ok-button = Vidi ĉiujn
    .accesskey = V

cfr-doorhanger-milestone-close-button = Fermi
    .accesskey = F

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Facile krei pasvortojn
cfr-whatsnew-lockwise-body = Estas malfacile pensi unikajn kaj sekurajn pasvortojn por ĉiu konto. Kiam vi kreas pasvorton, elektu la pasvortan kampon por uzi sekuran pasvorton kreitan de { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Emblemo de { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Ricevu atentigojn pri sendefendaj pasvortoj.
cfr-whatsnew-passwords-body = Fiuloj scias ke personoj reuzas la samajn pasvortojn. Se vi uzis la saman pasvorton en pluraj retejoj kaj unu el ili havas datumfuĝojn, vi vidos atentigon en { -lockwise-brand-short-name } por ke vi ŝanĝu la pasvorton en tiuj retejoj.
cfr-whatsnew-passwords-icon-alt = Emblemo de sendefenda pasvorto

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Iri el la eta al la granda ekrano
cfr-whatsnew-pip-fullscreen-body = Kiam vi ŝprucigas filmeton en ŝvebantan fenestron, vi povas nun duoble alklaki tiun fenestro por vidi ĝin plenekrane.
cfr-whatsnew-pip-fullscreen-icon-alt = Emblemo de bildo en bildo.

## Protections Dashboard message

cfr-whatsnew-protections-header = Superrigardo de protektoj
cfr-whatsnew-protections-body = La panelo de protektoj inkluzivas resumajn raportojn pri datumfuĝoj kaj administro de pasvortoj. Vi nun povas sevki la kvanton de solvitaj datumfuĝoj kaj vidi ĉu iu ajn el viaj konservitaj pasvortoj povus esti elmetita de datumfuĝo.
cfr-whatsnew-protections-cta-link = Vidi panelon de protektoj
cfr-whatsnew-protections-icon-alt = Emblemo de ŝildo

## Better PDF message

cfr-whatsnew-better-pdf-header = Pli bona sperto kun PDF
cfr-whatsnew-better-pdf-body = Dokumentoj PDF malfermiĝas nun rekte en { -brand-short-name }, kio helpas teni viajn aferojn ĉemane.

## DOH Message

cfr-doorhanger-doh-body = Via privateco gravas. Ekde nun, se tio eblas, { -brand-short-name } sendos viajn petojn DNS al servo provizata de asociito por protekti vin dum vi retumas.
cfr-doorhanger-doh-header = Petoj DNS pli sekuraj kaj ĉifritaj
cfr-doorhanger-doh-primary-button = En ordo, mi komprenis
    .accesskey = E
cfr-doorhanger-doh-secondary-button = Malaktivigi
    .accesskey = M

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Aŭtomata proteko kontraŭ kaŝitaj spurilaj taktikoj
cfr-whatsnew-clear-cookies-body = Kelkaj retejoj redirektas vin al aliaj retejoj, kiuj sekrete konservas kuketojn. { -brand-short-name } nun aŭtomate viŝas tiujn kuketojn, tiel ke ili ne povos sekvi vin.
cfr-whatsnew-clear-cookies-image-alt = Ilustraĵo de blokita kuketo
