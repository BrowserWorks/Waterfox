# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extension recommendate
cfr-doorhanger-feature-heading = Function recommendate
cfr-doorhanger-pintab-heading = Prova isto: Fixar scheda

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Proque vide io isto?
cfr-doorhanger-extension-cancel-button = Non ora
    .accesskey = N
cfr-doorhanger-extension-ok-button = Adder ora
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Fixar iste scheda
    .accesskey = F
cfr-doorhanger-extension-manage-settings-button = Gerer le configurationes de recommendation
    .accesskey = G
cfr-doorhanger-extension-never-show-recommendation = Non monstrar me iste recommendation
    .accesskey = N
cfr-doorhanger-extension-learn-more-link = Saper plus
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = per { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Recommendation
cfr-doorhanger-extension-notification2 = Recommendation
    .tooltiptext = Extension recommendate
    .a11y-announcement = Un recommendation pro un extension es disponibile
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Recommendation
    .tooltiptext = Functionalitate recommendate
    .a11y-announcement = Un recommendation de functionalitate es disponibile

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } stella
           *[other] { $total } stellas
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } usator
       *[other] { $total } usatores
    }
cfr-doorhanger-pintab-description = Accede facilemente al sitos web que tu usa le plus frequentemente. Mantene le sitos aperte in un scheda (mesmo quando tu reinitia).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Face clic dextre</b> sur le scheda que tu vole fixar.
cfr-doorhanger-pintab-step2 = Elige <b>Fixar scheda</b> in le menu.
cfr-doorhanger-pintab-step3 = Si le sito se actualisa, un puncto blau apparera sur le scheda fixate.
cfr-doorhanger-pintab-animation-pause = Pausar
cfr-doorhanger-pintab-animation-resume = Reprender

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synchronisa tu marcapaginas ubique.
cfr-doorhanger-bookmark-fxa-body = Grande discoperta! Ora non restar sin iste marcapaginas sur tu apparatos mobile. Comencia con un { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Synchronisar marcapaginas ora…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Button Clauder
    .title = Clauder

## Protections panel

cfr-protections-panel-header = Naviga sin lassar te sequer
cfr-protections-panel-body = Mantene tu datos pro te mesme. { -brand-short-name } te protege ab multes del plus commun traciatores que seque lo que tu face in linea.
cfr-protections-panel-link-text = Saper plus

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nove function:
cfr-whatsnew-button =
    .label = Novas
    .tooltiptext = Novas
cfr-whatsnew-panel-header = Novas
cfr-whatsnew-release-notes-link-text = Leger le notas de version
cfr-whatsnew-fx70-title = { -brand-short-name } lucta ora plus forte pro tu vita private
cfr-whatsnew-fx70-body = Le ultime actualisation meliora le protection contra le traciamento e rende plus facile que jammais crear contrasignos secur pro cata sito.
cfr-whatsnew-tracking-protect-title = Protege te ab le traciatores
cfr-whatsnew-tracking-protect-body = { -brand-short-name } bloca multe traciatores commun social e inter sitos que seque lo que tu face in linea.
cfr-whatsnew-tracking-protect-link-text = Vider tu reporto
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Traciator blocate
       *[other] Traciatores blocate
    }
cfr-whatsnew-tracking-blocked-subtitle = Desde { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Vider reporto
cfr-whatsnew-lockwise-backup-title = Face un copia de reserva de tu contrasignos
cfr-whatsnew-lockwise-backup-body = Ora genera contrasignos secur al quales tu pote acceder non importa ab ubi tu te connecte.
cfr-whatsnew-lockwise-backup-link-text = Activar le copias de reserva
cfr-whatsnew-lockwise-take-title = Porta tu contrasignos con te
cfr-whatsnew-lockwise-take-body = Le application mobile { -lockwise-brand-short-name } te permitte acceder con securitate al copia de reserva de tu contrasignos, non importa ubi tu te trova.
cfr-whatsnew-lockwise-take-link-text = Obtener le application

## Search Bar

cfr-whatsnew-searchbar-title = Scribe minus, trova plus con le barra de adresse
cfr-whatsnew-searchbar-body-topsites = Ora, selige le barra de adresse, e un quadro apparera con un lista de ligamines a tu sitos principal.
cfr-whatsnew-searchbar-icon-alt-text = Icone de lupa

## Picture-in-Picture

cfr-whatsnew-pip-header = Reguarda videos durante que tu naviga
cfr-whatsnew-pip-body = Le function imagine-in-imagine mitte le video in un fenestra flottante de maniera que tu pote reguardar lo durante que tu travalia in altere schedas.
cfr-whatsnew-pip-cta = Saper plus

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Reduce le enoio de fenestras emergente
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } ora impedi que sitos demanda automaticamente de inviar te messages emergente.
cfr-whatsnew-permission-prompt-cta = Saper plus

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Dactylogrammator blocate
       *[other] Dactylogrammatores blocate
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } bloca multe dactylogrammatores que collige secretemente informationes re tu apparato e tu actiones pro crear de te un profilo publicitari.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Dactylogrammatores
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } pote blocar dactylogrammatores que collige secretemente informationes re tu apparato e tu actiones pro crear de te un profilo publicitari.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Recipe iste marcapaginas sur tu telephono
cfr-doorhanger-sync-bookmarks-body = Retene tu marcapaginas, contrasignos, chronologia, etc. sur tote le apparatos connectite a tu conto { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Activar { -sync-brand-short-name }
    .accesskey = A

## Login Sync

cfr-doorhanger-sync-logins-header = Nunquam perder ancora un contrasigno
cfr-doorhanger-sync-logins-body = Salva e synchronisa con securitate tu contrasignos sur tote tu apparatos.
cfr-doorhanger-sync-logins-ok-button = Activa { -sync-brand-short-name }
    .accesskey = A

## Send Tab

cfr-doorhanger-send-tab-header = Lege isto in viage
cfr-doorhanger-send-tab-recipe-header = Porta iste recepta al cocina
cfr-doorhanger-send-tab-body = Inviar Scheda te permitte compartir facilemente iste ligamine a tu telephono o altere apparatos connectite a tu conto de { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Proba Inviar Scheda
    .accesskey = P

## Firefox Send

cfr-doorhanger-firefox-send-header = Comparti con securitate iste PDF
cfr-doorhanger-firefox-send-body = Mantene secur del oculos indiscrete tu documentos sensibile con cryptographia bilateral e un ligamine que dispare quando tu ha finite.
cfr-doorhanger-firefox-send-ok-button = Prova { -send-brand-name }
    .accesskey = P

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Vider protectiones
    .accesskey = p
cfr-doorhanger-socialtracking-close-button = Clauder
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = Non plus monstrar me messages como iste
    .accesskey = N
cfr-doorhanger-socialtracking-heading = { -brand-short-name } ha impedite que un rete social te tracia hic
cfr-doorhanger-socialtracking-description = Tu vita private es importante. Ora { -brand-short-name } bloca traciatores de retes social commun, limitante le quantitate de datos que illos pote colliger sur tu activitates in linea.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } ha blocate un dactylogrammator in iste pagina
cfr-doorhanger-fingerprinters-description = Tu vita private es importante. { -brand-short-name } bloca ora le dactylogrammatores que collige pecias de information unic sur tu apparato pro traciar te.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } ha blocate un cryptominator in iste pagina
cfr-doorhanger-cryptominers-description = Tu vita private es importante. Ora { -brand-short-name } bloca cryptominatores, que usa le ressources computational de tu systemas pro excavar moneta digital.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] { -brand-short-name } ha blocate plus de <b>{ $blockedCount }</b> traciatores desde { $date }!
    }
cfr-doorhanger-milestone-ok-button = Vider toto
    .accesskey = t
cfr-doorhanger-milestone-close-button = Clauder
    .accesskey = C

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Crea facilemente contrasignos secur
cfr-whatsnew-lockwise-body = Trovar un contrasigno unic e secur pro cata conto es difficile. Quando tu crea un nove contrasigno, selige le campo de contrasigno pro usar un contrasigno secur, generate automaticamente per { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Icone de { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Recipe un aviso in caso de contrasignos vulnerabile
cfr-whatsnew-passwords-body = Le piratas informatic sape que le gente reusa le mesme contrasignos. Si tu usa le mesme contrasigno in sitos differente e un de iste sitos es implicate in un violation de datos, tu videra un aviso in { -lockwise-brand-short-name } pro cambiar tu contrasigno in tote iste sitos.
cfr-whatsnew-passwords-icon-alt = Icone de clave pro contrasigno vulnerabile

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Mitter imagine-in-imagine a plen schermo
cfr-whatsnew-pip-fullscreen-body = Quando tu mitte un video in un fenestra flottante, tu pote ora duple-cliccar sur illo pro passar al plen schermo.
cfr-whatsnew-pip-fullscreen-icon-alt = Icone imagine-in-imagine

## Protections Dashboard message

cfr-whatsnew-protections-header = Protectiones al prime colpo de oculos
cfr-whatsnew-protections-body = Le Pannello de controlo protectiones include  reportos summari re gestion de violationes de datos e contrasignos. Tu pote ora traciar quante violationes tu ha resolvite e vider si tote tu contrasignos salvate ha forsan essite exponite in un violation de datos.
cfr-whatsnew-protections-cta-link = Vider pannello de protectiones
cfr-whatsnew-protections-icon-alt = Icone escudo

## Better PDF message

cfr-whatsnew-better-pdf-header = Melior experientia PDF
cfr-whatsnew-better-pdf-body = Le documentos PDF ora aperi directemente in { -brand-short-name }, sin molestar tu fluxo de labor.

## DOH Message

cfr-doorhanger-doh-body = Tu confidentialitate es importante. { -brand-short-name } ora adressa con securitate tu requestas de DNS quandocunque possibile a un servicio partner pro proteger te durante tu navigation.
cfr-doorhanger-doh-header = Recercas DNS plus secur e ciphrate
cfr-doorhanger-doh-primary-button = De accordo
    .accesskey = a
cfr-doorhanger-doh-secondary-button = Disactivar
    .accesskey = D

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Protection automatic contra tacticas de traciamento perfide
cfr-whatsnew-clear-cookies-body = Alcun traciatores re-adresse te a altere sitos web que configura cookies secretemente. { -brand-short-name } ora automaticamente clara ille cookies de sorta que tu non pote esser sequite.
cfr-whatsnew-clear-cookies-image-alt = Illustration cookie blocate
