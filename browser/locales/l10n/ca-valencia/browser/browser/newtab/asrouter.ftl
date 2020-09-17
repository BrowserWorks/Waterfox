# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extensió recomanada
cfr-doorhanger-feature-heading = Funció recomanada
cfr-doorhanger-pintab-heading = Proveu això: Fixa la pestanya

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Per què veig això?

cfr-doorhanger-extension-cancel-button = Ara no
    .accesskey = n

cfr-doorhanger-extension-ok-button = Afig-la ara
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Fixa esta pestanya
    .accesskey = F

cfr-doorhanger-extension-manage-settings-button = Gestiona els paràmetres de recomanacions
    .accesskey = G

cfr-doorhanger-extension-never-show-recommendation = No em mostres esta recomanació
    .accesskey = m

cfr-doorhanger-extension-learn-more-link = Més informació

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = per { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Recomanació
cfr-doorhanger-extension-notification2 = Recomanació
    .tooltiptext = Recomanació d'extensió
    .a11y-announcement = Recomanació d'extensió disponible

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Recomanació
    .tooltiptext = Recomanació de característica
    .a11y-announcement = Recomanació de característica disponible

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } estrella
           *[other] { $total } estrelles
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } usuari
       *[other] { $total } usuaris
    }

cfr-doorhanger-pintab-description = Accediu fàcilment als llocs més utilitzats. Manteniu els llocs oberts en una pestanya (fins i tot quan reinicieu).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Feu clic amb el botó dret</b> a la pestanya que voleu fixar.
cfr-doorhanger-pintab-step2 = Trieu <b>Fixa la pestanya</b> al menú.
cfr-doorhanger-pintab-step3 = Si el contingut del lloc s'actualitza, veureu un punt blau a la pestanya fixa.

cfr-doorhanger-pintab-animation-pause = Pausa
cfr-doorhanger-pintab-animation-resume = Reprén


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sincronitzeu les adreces d'interés a tot arreu.
cfr-doorhanger-bookmark-fxa-body = Una gran troballa! No vos quedeu sense esta adreça d'interés en els vostres dispositius mòbils. Creeu un { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Sincronitza ara les adreces d'interés…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Botó Tanca
    .title = Tanca

## Protections panel

cfr-protections-panel-header = Navegueu sense sentir-vos observat
cfr-protections-panel-body = Protegiu les vostres dades. El { -brand-short-name } vos protegeix de molts dels elements de seguiment més habituals que recopilen dades sobre allò que feu a Internet.
cfr-protections-panel-link-text = Més informació

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Novetat:

cfr-whatsnew-button =
    .label = Novetats
    .tooltiptext = Novetats

cfr-whatsnew-panel-header = Novetats

cfr-whatsnew-release-notes-link-text = Llegiu les notes de la versió

cfr-whatsnew-fx70-title = Ara el { -brand-short-name } lluita encara més per la vostra privadesa
cfr-whatsnew-fx70-body = La darrera actualització millora la funció de protecció contra el seguiment i permet crear contrasenyes segures per a cada lloc molt fàcilment.

cfr-whatsnew-tracking-protect-title = Protegiu-vos dels elements de seguiment
cfr-whatsnew-tracking-protect-body = El { -brand-short-name } bloca els elements de seguiment de xarxes socials i entre llocs més habituals que recopilen dades sobre allò que feu a Internet.
cfr-whatsnew-tracking-protect-link-text = Vegeu el vostre informe

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Element de seguiment blocat
       *[other] Elements de seguiment blocats
    }
cfr-whatsnew-tracking-blocked-subtitle = Des de: { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Vegeu l'informe

cfr-whatsnew-lockwise-backup-title = Feu una còpia de seguretat de les vostres contrasenyes
cfr-whatsnew-lockwise-backup-body = Ara podeu generar contrasenyes segures i accedir-hi des de tot arreu on inicieu la sessió.
cfr-whatsnew-lockwise-backup-link-text = Activeu la còpia de seguretat

cfr-whatsnew-lockwise-take-title = Les vostres contrasenyes, a tot arreu
cfr-whatsnew-lockwise-take-body = L'aplicació mòbil del { -lockwise-brand-short-name } vos permet accedir de manera segura a les contrasenyes guardades des de qualsevol lloc.
cfr-whatsnew-lockwise-take-link-text = Baixa l'aplicació

## Search Bar

cfr-whatsnew-searchbar-title = Escriviu menys i trobeu més amb la barra d'adreces
cfr-whatsnew-searchbar-body-topsites = Ara, podeu seleccionar la barra d'adreces i es desplegarà un quadre amb enllaços als vostres llocs principals.
cfr-whatsnew-searchbar-icon-alt-text = Icona de lupa

## Picture-in-Picture

cfr-whatsnew-pip-header = Mireu vídeos mentre navegueu
cfr-whatsnew-pip-body = La imatge sobre imatge mostra el vídeo en una finestra flotant perquè pugueu mirar-lo mentre treballeu en altres pestanyes.
cfr-whatsnew-pip-cta = Més informació

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Menys missatges emergents molestos
cfr-whatsnew-permission-prompt-body = Ara el { -brand-shorter-name } impedeix que els llocs vos demanen automàticament enviar-vos missatges emergents.
cfr-whatsnew-permission-prompt-cta = Més informació

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Generador d'empremtes digitals blocat
       *[other] Generadors d'empremtes digitals blocats
    }
cfr-whatsnew-fingerprinter-counter-body = El { -brand-shorter-name } bloca molts generadors d'empremtes digitals que secretament recullen informació sobre el vostre dispositiu i les vostres accions per crear un perfil publicitari vostre.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Generadors d'empremtes digitals
cfr-whatsnew-fingerprinter-counter-body-alt = El { -brand-shorter-name } pot blocar els generadors d'empremtes digitals que secretament recullen informació sobre el vostre dispositiu i les vostres accions per crear un perfil publicitari vostre.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Accediu a esta adreça d'interés des del vostre telèfon
cfr-doorhanger-sync-bookmarks-body = Accediu a les adreces d'interés, les contrasenyes, l'historial i molt més arreu on tingueu una sessió iniciada en el { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Activa el { -sync-brand-short-name }
    .accesskey = A

## Login Sync

cfr-doorhanger-sync-logins-header = No perdeu mai més cap contrasenya
cfr-doorhanger-sync-logins-body = Emmagatzemeu i sincronitzeu de forma segura les contrasenyes en tots els vostres dispositius.
cfr-doorhanger-sync-logins-ok-button = Activa el { -sync-brand-short-name }
    .accesskey = A

## Send Tab

cfr-doorhanger-send-tab-header = Llegiu-ho sobre la marxa
cfr-doorhanger-send-tab-recipe-header = Emporta't esta recepta a la cuina
cfr-doorhanger-send-tab-body = «Envia la pestanya» vos permet compartir fàcilment este enllaç amb el vostre telèfon o arreu on tingueu una sessió iniciada en el { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Prova «Envia la pestanya»
    .accesskey = P

## Firefox Send

cfr-doorhanger-firefox-send-header = Compartiu este PDF de forma segura
cfr-doorhanger-firefox-send-body = Manteniu els vostres documents confidencials lluny de mirades indiscretes amb un xifratge d'extrem a extrem i un enllaç que desapareix quan hàgeu acabat.
cfr-doorhanger-firefox-send-ok-button = Prova el { -send-brand-name }
    .accesskey = P

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Mostra les proteccions
    .accesskey = M
cfr-doorhanger-socialtracking-close-button = Tanca
    .accesskey = T
cfr-doorhanger-socialtracking-dont-show-again = No em tornes a mostrar cap missatge com este
    .accesskey = N
cfr-doorhanger-socialtracking-heading = El { -brand-short-name } ha impedit que una xarxa social vos faça el seguiment fins ací
cfr-doorhanger-socialtracking-description = La vostra privadesa és important. Ara el { -brand-short-name } bloca els elements de seguiment de les xarxes socials més comunes. Això limita la quantitat de dades que poden recopilar sobre allò que feu a Internet.
cfr-doorhanger-fingerprinters-heading = El { -brand-short-name } ha blocat un generador d'empremtes digitals en esta pàgina
cfr-doorhanger-fingerprinters-description = La vostra privadesa és important. Ara el { -brand-short-name } bloca els generadors d'empremtes digitals, que recopilen informació del vostre dispositiu que vos podria identificar per a fer-vos el seguiment.
cfr-doorhanger-cryptominers-heading = El { -brand-short-name } ha blocat un miner de criptomonedes en esta pàgina
cfr-doorhanger-cryptominers-description = La vostra privadesa és important. Ara el { -brand-short-name } bloca els miners de criptomonedes, que utilitzen la potència de càlcul del vostre ordinador per a la mineria de diners digitals.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] El { -brand-short-name } ha blocat més de <b>{ $blockedCount }</b> elements de seguiment des del { $date }
    }
cfr-doorhanger-milestone-ok-button = Mostra-ho tot
    .accesskey = M

cfr-doorhanger-milestone-close-button = Tanca
    .accesskey = T

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Creeu contrasenyes segures fàcilment
cfr-whatsnew-lockwise-body = És complicat pensar en contrasenyes úniques i segures per a cada compte. Quan creeu una contrasenya, seleccioneu el camp de contrasenya per utilitzar una contrasenya segura generada pel { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Icona del { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Rebeu alertes sobre contrasenyes vulnerables
cfr-whatsnew-passwords-body = Els furoners saben que la gent reutilitza les mateixes contrasenyes. Si heu utilitzat la mateixa contrasenya en diversos llocs i un d'estos llocs ha aparegut en alguna filtració de dades, veureu una alerta en el { -lockwise-brand-short-name } perquè canvieu la contrasenya d'estos llocs.
cfr-whatsnew-passwords-icon-alt = Icona de clau de contrasenya vulnerable

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = La imatge sobre imatge, ara a pantalla completa
cfr-whatsnew-pip-fullscreen-body = Quan obriu un vídeo en una finestra flotant, ara podeu fer doble clic a la finestra per canviar-lo a pantalla completa.
cfr-whatsnew-pip-fullscreen-icon-alt = Icona d'Imatge sobre imatge

## Protections Dashboard message

cfr-whatsnew-protections-header = Totes les proteccions d'un cop d'ull
cfr-whatsnew-protections-body = El Tauler de proteccions inclou un resum de les filtracions de dades i gestió de contrasenyes. Ara podeu fer el seguiment de les filtracions que heu resolt i comprovar si alguna de les vostres contrasenyes guardades podrien haver estat exposades en una filtració de dades.
cfr-whatsnew-protections-cta-link = Mostra el tauler de proteccions
cfr-whatsnew-protections-icon-alt = Icona d'escut

## Better PDF message

cfr-whatsnew-better-pdf-header = Millor experiència amb els PDF
cfr-whatsnew-better-pdf-body = Ara els documents PDF s'obren directament en el { -brand-short-name }, per tindre-los més a mà.

## DOH Message

cfr-doorhanger-doh-body = La vostra privadesa és important. Ara el { -brand-short-name } encamina de forma segura les vostres sol·licituds DNS, sempre que siga possible, a un servei associat per protegir-vos mentre navegueu.
cfr-doorhanger-doh-header = Consultes DNS més segures i xifrades
cfr-doorhanger-doh-primary-button = Entesos
    .accesskey = o
cfr-doorhanger-doh-secondary-button = Inhabilita
    .accesskey = h

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Protecció automàtica contra les tàctiques de seguiment més elaborades
cfr-whatsnew-clear-cookies-body = Alguns elements de seguiment vos redirigeixen a altres llocs web que guarden galetes en secret. Ara el { -brand-short-name } esborra automàticament estes galetes perquè no vos puguen fer el seguiment.
cfr-whatsnew-clear-cookies-image-alt = Il·lustració d'una galeta blocada
