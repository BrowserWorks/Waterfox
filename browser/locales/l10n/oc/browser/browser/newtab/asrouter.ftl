# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extension recomanda
cfr-doorhanger-feature-heading = Foncion recomandada
cfr-doorhanger-pintab-heading = Ensajatz aquò : penjar un onglet

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Perqué aquò se bota aquí ?

cfr-doorhanger-extension-cancel-button = Pas ara
    .accesskey = P

cfr-doorhanger-extension-ok-button = Apondre ara
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Penjar aqueste onglet
    .accesskey = P

cfr-doorhanger-extension-manage-settings-button = Gerir los paramètres de recomandacion
    .accesskey = G

cfr-doorhanger-extension-never-show-recommendation = Me mostrar pas aquela recomandacion
    .accesskey = M

cfr-doorhanger-extension-learn-more-link = Ne saber mai

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = per { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Recomandacions
cfr-doorhanger-extension-notification2 = Recomandacions
    .tooltiptext = Extensions recomandadas
    .a11y-announcement = Recomendacions d’extensions disponiblas

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Recomandacions
    .tooltiptext = Foncion de recomandacions
    .a11y-announcement = Foncion de recomandacions disponibla

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } estela
           *[other] { $total } estalas
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } utilizaire
       *[other] { $total } utilizaires
    }

cfr-doorhanger-pintab-description = Accedissètz facilament als sites mai utilizats. Gardatz los sites dobèrts dins un onglets (amai quand reaviatz)

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Clic drech</b> sus l’onglet que volètz penjar.
cfr-doorhanger-pintab-step2 = Seleccionatz <b>Penjar aqueste onglet</b> al menú.
cfr-doorhanger-pintab-step3 = Se lo site a una mesa a jorn, veiretz un punt blau sus vòstre onglet penjat.

cfr-doorhanger-pintab-animation-pause = Pausa
cfr-doorhanger-pintab-animation-resume = Reprendre


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sincronizatz vòstres marcapaginas pertot.
cfr-doorhanger-bookmark-fxa-body = Genial ! Ara, contunhetz pas sens aqueste marcapagina suls vòstres periferics mobils. Començatz amb { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Sincronizar los marcapaginas ara…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Boton tampar
    .title = Tampar

## Protections panel

cfr-protections-panel-header = Navegatz sens èsser seguit
cfr-protections-panel-body = Gardatz vòstras donadas per vos. { -brand-short-name } vos protegís de la màger part dels traçadors mai comuns que vos seguisson en linha.
cfr-protections-panel-link-text = Ne saber mai

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Novèla foncionalitat :

cfr-whatsnew-button =
    .label = Qué de nòu
    .tooltiptext = Qué de nòu

cfr-whatsnew-panel-header = Qué de nòu

cfr-whatsnew-release-notes-link-text = Legir la nòta de version

cfr-whatsnew-fx70-title = { -brand-short-name } luta encara mai per vòstra vida privada
cfr-whatsnew-fx70-body =
    La darrièra mesa a jorn melhora la foncion de proteccion
    contra lo seguiment e permet de crear de senhals segurs per cada site.

cfr-whatsnew-tracking-protect-title = Protegissètz-vos dels traçadors
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } bloca los elements de seguiment dels malhums socials e intersites
    mai populars  que vos pistan en linha.
cfr-whatsnew-tracking-protect-link-text = Consultar vòstre rapòrt

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Traçador blocat
       *[other] Traçadors blocats
    }
cfr-whatsnew-tracking-blocked-subtitle = Dempuèi { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Veire lo rapòrt

cfr-whatsnew-lockwise-backup-title = Salvagardatz vòstres senhals
cfr-whatsnew-lockwise-backup-body = Ara podètz generar vòstres senhals securizats e i accedir de pertot ont vos connectatz.
cfr-whatsnew-lockwise-backup-link-text = Activar las salvagardas

cfr-whatsnew-lockwise-take-title = Emportatz vòstres senhals amb vos
cfr-whatsnew-lockwise-take-body =
    L'aplicacion mobila { -lockwise-brand-short-name } vos permet d'accedir en tota seguretat vòstres
    senhals salvats d'ont que siá.
cfr-whatsnew-lockwise-take-link-text = Obténer l’aplicacion

## Search Bar

cfr-whatsnew-searchbar-title = Escrivètz mens, trobatz mai amb la barra d’adreça
cfr-whatsnew-searchbar-body-topsites = Ara, seleccionatz simplament la barra d'adreça, e una bóstia s'agrandirà amb de ligams cap a vòstres melhors sites.
cfr-whatsnew-searchbar-icon-alt-text = Icòna de la lópia

## Picture-in-Picture

cfr-whatsnew-pip-header = Agachatz de vidèos en navegant
cfr-whatsnew-pip-body = L'imatge dins l'imatge fa aparéisser la vidèo dins una fenèstra flotanta que poscatz la gaitar tot en trabalhant dins d'autres onglets.
cfr-whatsnew-pip-cta = Ne saber mai

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Mens de fenèstras surgissentas tediosas
cfr-whatsnew-permission-prompt-body = Ara { -brand-shorter-name } bloca los sites que demandan automaticament de vos enviar de messatges sorgissents.
cfr-whatsnew-permission-prompt-cta = Ne saber mai

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Generador d’emprentas numericas
       *[other] Generadors d’emprentas numericas
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } bloca fòrça generadors d’empruntas numericas qu’amassan d‘informacions tocant vòstre periferic e vòstras accions per crear un perfil publicitari vòstre.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Generadors d’emprentas numericas
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } pòt blocar los generadors d’empruntas numericas qu’amassan d‘informacions tocant vòstre periferic e vòstras accions per crear un perfil publicitari vòstre.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Accedissètz a aqueste onglet de vòstre mobil estant
cfr-doorhanger-sync-bookmarks-body = Emportatz vòstres marcapaginas, senhals, istoric e mai pertot ont vos connectat a { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Activar { -sync-brand-short-name }
    .accesskey = A

## Login Sync

cfr-doorhanger-sync-logins-header = Perdatz pas jamai vòstre senhal
cfr-doorhanger-sync-logins-body = Gardatz e sincronizatz d’un biais segur los senhals de totes vòstres periferics.
cfr-doorhanger-sync-logins-ok-button = Activar { -sync-brand-short-name }
    .accesskey = A

## Send Tab

cfr-doorhanger-send-tab-header = Legissètz aquò en desplaçament
cfr-doorhanger-send-tab-recipe-header = Emportatz aquesta recepta a la cosina
cfr-doorhanger-send-tab-body = « Enviar l’onglet » vos permet de partejar aisidament aqueste ligam sus vòstre mobil o pertot ont siatz connectat a { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Ensajatz d’enviar un onglet
    .accesskey = t

## Firefox Send

cfr-doorhanger-firefox-send-header = Partejatz aqueste PDF de forma segura
cfr-doorhanger-firefox-send-body = Gardatz vòstres documents sensibles a l'abric dels agaches indiscrèts amb un chiframent del cap a la fin e un ligam que dispareis quand avètz acabat.
cfr-doorhanger-firefox-send-ok-button = Ensajatz { -send-brand-name }
    .accesskey = t

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Veire las proteccions
    .accesskey = V
cfr-doorhanger-socialtracking-close-button = Tampar
    .accesskey = T
cfr-doorhanger-socialtracking-dont-show-again = Me mostrar pas mai de messatges coma aqueste
    .accesskey = d
cfr-doorhanger-socialtracking-heading = { -brand-short-name } a empachat un traçador de malhum social de vos pistar aquí
cfr-doorhanger-socialtracking-description = Vòstra vida privada es importanta. Ara { -brand-short-name } bloca los elements de seguiment dels malhums socials mai populars, per limitar atal la quantitat de donadas que pòdon reculhir sus vòstra activitat en linha.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } a blocat un traçador d’emprunta numerica sus aquesta pagina
cfr-doorhanger-fingerprinters-description = Lo respècte de vòstra vida privada es important. Ara { -brand-short-name } bloca los generadors d’emprentas numericas, que reculhisson d’informacions unicas e identificablas de vòstre periferic per vos pistar.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } a blocat un minaire de criptomonedas sus aquesta pagina
cfr-doorhanger-cryptominers-description = Vòstra vida privada es importanta. Ara { -brand-short-name } bloca los minaires de criptomonedas, qu’utilizan la poténcia de calcul de vòstre ordenador per minar de moneda numerica.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } a blocat <b>{ $blockedCount }</b> traçador dempuèi { $date } !
       *[other] { -brand-short-name } a blocat <b>{ $blockedCount }</b> traçadors dempuèi { $date } !
    }
cfr-doorhanger-milestone-ok-button = O mostrar tot
    .accesskey = m

cfr-doorhanger-milestone-close-button = Tampar
    .accesskey = T

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Creatz de senhals segurs facilament
cfr-whatsnew-lockwise-body = Es complicat de pensar a un senhal unic e segur per cada compte. Pendent la creacion d’un senhal, seleccionatz lo camp de senhal per utilizar un senhal segur generat amb { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = icòna { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Obtenètz d’alertas al subjècte dels senhals vulnerables
cfr-whatsnew-passwords-body = Los piratas sabon que lo monde tòrnan utilizar los meteisses senhals. S’avètz utilizat lo meteis senhal sus mantun sites e qu’un d’aqueles sites a agut una divulgacion de donadas, veiretz una alèrta de { -lockwise-brand-short-name } per vos dire de cambiar vòstre senhal sus aqueles sites.
cfr-whatsnew-passwords-icon-alt = icòna d’una clau pas fisabla

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Passar la vidèo incrustada en plen ecran
cfr-whatsnew-pip-fullscreen-body = Quand plaçatz una vidèo dins una fenèstra bandejanta, podètz ara doble-clicar dessús per la passar en plen ecran.
cfr-whatsnew-pip-fullscreen-icon-alt = icòna vidèos incrustada

## Protections Dashboard message

cfr-whatsnew-protections-header = Proteccion en una ulhada
cfr-whatsnew-protections-body = La teula de bòrd de las proteccions conten los rapòrts resumits tocant las divulgacions de donadas e la gestion dels senhals. D’ara endavant seguir lo nombre de divulgacions qu’avètz resolgudas e veire s’un de vòstres senhals salvats pòt aver èsser exposat a una pèrd de donadas.
cfr-whatsnew-protections-cta-link = Veire la taula de bòrd de las proteccions
cfr-whatsnew-protections-icon-alt = Icòna d’escut

## Better PDF message

cfr-whatsnew-better-pdf-header = Melhora experiéncia PDF
cfr-whatsnew-better-pdf-body = Los documents se dobrisson ara dirèctament dins { -brand-short-name }, per contunhar vòstre trabalh fòra distraccion.

## DOH Message

cfr-doorhanger-doh-body = Vòstra vida privada es importanta. Ara { -brand-short-name } encamina de forma segura vòstras requèstas DNS tant coma se pòt via un servici partenari per vos protegir pendent la navegacion.
cfr-doorhanger-doh-header = Requèstas DNS mai seguras e chifradas
cfr-doorhanger-doh-primary-button = Òc, plan comprés
    .accesskey = c
cfr-doorhanger-doh-secondary-button = Desactivar
    .accesskey = D

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Proteccion automatica contra las tacticas de seguiment enganairas
cfr-whatsnew-clear-cookies-body = D’unes traçadors vos redirigisson cap d’autres sites web que depausan secrètament de cookies. Ara { -brand-short-name } escafa aqueles cookies per que siatz pas seguit.
cfr-whatsnew-clear-cookies-image-alt = Illustracion d’un cookie blocat
