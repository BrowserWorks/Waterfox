# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extensión recomendada
cfr-doorhanger-feature-heading = Característica recomendada
cfr-doorhanger-pintab-heading = Probe con isto: ancorar lapelas

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Por que estou vendo isto?
cfr-doorhanger-extension-cancel-button = Agora non
    .accesskey = n
cfr-doorhanger-extension-ok-button = Engadir agora
    .accesskey = a
cfr-doorhanger-pintab-ok-button = Ancorar esta lapela
    .accesskey = A
cfr-doorhanger-extension-manage-settings-button = Xestionar a configuración de recomendación
    .accesskey = m
cfr-doorhanger-extension-never-show-recommendation = Non amosarme esta recomendación
    .accesskey = s
cfr-doorhanger-extension-learn-more-link = Máis información
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = por { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Recomendación
cfr-doorhanger-extension-notification2 = Recomendación
    .tooltiptext = Recomendación de extensión
    .a11y-announcement = Recomendación de extensión dispoñible
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Recomendación
    .tooltiptext = Características recomendadas
    .a11y-announcement = Características recomendadas dispoñibles

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } estrela
           *[other] { $total } estrelas
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } usuario
       *[other] { $total } usuarios
    }
cfr-doorhanger-pintab-description = Acceda facilmente aos sitios máis empregados. Manteña os sitios abertos nunha lapela (incluso cando reinicie).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b> Prema co botón dereito do rato</b> na lapela que desexe fixar.
cfr-doorhanger-pintab-step2 = Seleccione <b>Ancorar lapela</b> no menú.
cfr-doorhanger-pintab-step3 = Se o sitio ten unha actualización, verá un punto azul na súa lapela ancorada.
cfr-doorhanger-pintab-animation-pause = Deter
cfr-doorhanger-pintab-animation-resume = Retomar

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sincronice os seus marcadores en todas partes.
cfr-doorhanger-bookmark-fxa-body = Un gran achado! Agora non quedará sen este marcador nos seus dispositivos móbiles. Comece cun { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Sincronizar marcadores agora ...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Botón de peche
    .title = Pechar

## Protections panel

cfr-protections-panel-header = Navegar sen ser seguido
cfr-protections-panel-body = Manteña os seus datos para si mesmo. { -brand-short-name } protéxeo de moitos dos rastreadores máis comúns que seguen o que fai na Rede.
cfr-protections-panel-link-text = Máis información

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nova característica:
cfr-whatsnew-button =
    .label = Novidades
    .tooltiptext = Novidades
cfr-whatsnew-panel-header = Novidades
cfr-whatsnew-release-notes-link-text = Lea as notas de lanzamento
cfr-whatsnew-fx70-title = { -brand-short-name } agora loita máis pola súa privacidade
cfr-whatsnew-fx70-body =
    A última actualización mellora a función de protección de rastreo e fai
    máis doado que nunca crear contrasinais seguros para cada sitio.
cfr-whatsnew-tracking-protect-title = Protexerse dos rastreadores
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } bloquea moitos rastreadores sociais e procedentes doutros sitios que
    siguen o que vostede fai na Rede.
cfr-whatsnew-tracking-protect-link-text = Ver o seu informe
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Rastrexador bloqueado
       *[other] Rastrexadores bloqueados
    }
cfr-whatsnew-tracking-blocked-subtitle = Desde { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Ver o informe
cfr-whatsnew-lockwise-backup-title = Faga unha copia de seguridade dos seus contrasinais
cfr-whatsnew-lockwise-backup-body = Xere agora contrasinais seguras ás que pode acceder en calquera lugar que inicie sesión.
cfr-whatsnew-lockwise-backup-link-text = Activar copias de seguridade
cfr-whatsnew-lockwise-take-title = Leve os seus contrasinais con vostede
cfr-whatsnew-lockwise-take-body =
    A aplicación para móbil { -lockwise-brand-short-name } permítelle acceder de xeito seguro
    á súa copia de seguridade de contrasinais desde calquera lugar.
cfr-whatsnew-lockwise-take-link-text = Obter a aplicación

## Search Bar

cfr-whatsnew-searchbar-title = Escriba menos, atope máis coa barra de enderezos
cfr-whatsnew-searchbar-body-topsites = Agora, só ten que seleccionar a barra de enderezos e unha caixa expandirase con ligazóns aos seus sitios máis importantes.
cfr-whatsnew-searchbar-icon-alt-text = Icona da lupa

## Picture-in-Picture

cfr-whatsnew-pip-header = Vexa vídeos mentres navega
cfr-whatsnew-pip-body = A función de imaxe en imaxe mostra os vídeos nunha xanela flotante para que os poida ver mentres traballa noutras lapelas.
cfr-whatsnew-pip-cta = Máis información

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Menos xanelas emerxentes irritantes dos sitios
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } agora bloquea que os sitios soliciten automaticamente que lle envíen mensaxes emerxentes.
cfr-whatsnew-permission-prompt-cta = Máis información

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Pegada dixital bloqueada
       *[other] Pegadas dixitais bloqueadas
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } bloquea moitas pegadas dixitais que recollen secretamente información sobre o dispositivo e accións para crear un perfil de publicidade sobre vostede.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Pegadas dixitais
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } pode bloquear pegadas dixitais que recollan secretamente información sobre o dispositivo e accións para crear un perfil de publicidade sobre vostede.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Obteña este marcador no seu teléfono
cfr-doorhanger-sync-bookmarks-body = Leve os seus marcadores, contrasinais, historial e moito máis a todos os lugares nos que inicie sesión no { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Activar { -sync-brand-short-name }
    .accesskey = A

## Login Sync

cfr-doorhanger-sync-logins-header = Non perda nunca máis un contrasinal
cfr-doorhanger-sync-logins-body = Almacene e sincronice os seus contrasinais con seguridade en todos os seus dispositivos.
cfr-doorhanger-sync-logins-ok-button = Activar { -sync-brand-short-name }
    .accesskey = A

## Send Tab

cfr-doorhanger-send-tab-header = Lea isto de camiño
cfr-doorhanger-send-tab-recipe-header = Leve esta receita á cociña
cfr-doorhanger-send-tab-body = Enviar lapela permítelle compartir esta ligazón no seu teléfono ou en calquera lugar onde teña iniciado sesión no { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Probar a enviar lapela
    .accesskey = P

## Firefox Send

cfr-doorhanger-firefox-send-header = Comparta este PDF con seguridade
cfr-doorhanger-firefox-send-body = Manteña os seus documentos sensibles a salvo de ollos indiscretos con cifraxe de extremo a extremo e unha ligazón que desapareza cando vostede remate.
cfr-doorhanger-firefox-send-ok-button = Probar { -send-brand-name }
    .accesskey = P

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Ver Proteccións
    .accesskey = V
cfr-doorhanger-socialtracking-close-button = Pechar
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = Non mostrar de novo mensaxes coma esta
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } impediu que unha rede social rastrexase a súa presenza aquí
cfr-doorhanger-socialtracking-description = A súa privacidade importa. { -brand-short-name } agora bloquea os rastrexadores de redes sociais comúns, limitando o número de datos que poden recompilar sobre o que fai na Rede.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } bloqueou unha pegada dixital nesta páxina
cfr-doorhanger-fingerprinters-description = A súa privacidade importa. { -brand-short-name } agora bloquea pegadas dixitais, que recollen pezas de información identificable exclusivamente sobre o seu dispositivo para rastrexar a súa presenza.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } bloqueou un criptomineiro nesta páxina
cfr-doorhanger-cryptominers-description = A súa privacidade importa. { -brand-short-name } agora bloquea criptomineiros, que usan o poder informático do seu sistema para minar diñeiro dixital.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } bloqueou máis de <b> { $blockedCount }</b> rastrexadores desde { $date }!
       *[other] { -brand-short-name } bloqueou máis de <b>{ $blockedCount }</b> rastrexadores desde { $date }!
    }
cfr-doorhanger-milestone-ok-button = Ver todo
    .accesskey = V
cfr-doorhanger-milestone-close-button = Pechar
    .accesskey = C

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Cree facilmente contrasinais seguros
cfr-whatsnew-lockwise-body = É difícil pensar en contrasinais únicos e seguros para cada conta. Ao crear un contrasinal, seleccione o campo de contrasinal para empregar un contrasinal seguro xerado por { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Icona { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Reciba alertas sobre contrasinais vulnerables
cfr-whatsnew-passwords-body = Os hackers saben que a xente reutiliza os mesmos contrasinais. Se usou o mesmo contrasinal en varios sitios e un deses sitios foi vítima dun roubo de datos, verá unha alerta no { -lockwise-brand-short-name } para cambiar o seu contrasinal neses sitios.
cfr-whatsnew-passwords-icon-alt = Icona de clave de contrasinal vulnerable

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Pasar de imaxe en imaxe a pantalla completa
cfr-whatsnew-pip-fullscreen-body = Ao enviar un vídeo nunha xanela flotante, agora pode premer dúas veces nesta xanela para pasar a pantalla completa.
cfr-whatsnew-pip-fullscreen-icon-alt = Icona de imaxe en imaxe

## Protections Dashboard message

cfr-whatsnew-protections-header = Proteccións dunha soa ollada
cfr-whatsnew-protections-body = O Panel de proteccións inclúe informes resumidos sobre incumprimentos de datos e xestión de contrasinais. Agora pode rastrear cantas infraccións resolveu e ver se algún dos seus contrasinais gardados estivo exposto nun roubo de datos.
cfr-whatsnew-protections-cta-link = Ver panel de proteccións
cfr-whatsnew-protections-icon-alt = Icona do escudo

## Better PDF message

cfr-whatsnew-better-pdf-header = Mellor experiencia cos PDF
cfr-whatsnew-better-pdf-body = Os documentos PDF agora abren directamente en { -brand-short-name }, mantendo o seu fluxo de traballo de fácil acceso.

## DOH Message

cfr-doorhanger-doh-body = A súa privacidade importa. { -brand-short-name } dirixe agora as súas solicitudes de DNS de forma segura sempre que sexa posible para un servizo asociado para protexelo mentres navega.
cfr-doorhanger-doh-header = Consultas aos DNS cifradas e máis seguras
cfr-doorhanger-doh-primary-button = Entendín
    .accesskey = E
cfr-doorhanger-doh-secondary-button = Desactivar
    .accesskey = D

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Protección automática contra tácticas de rastreo
cfr-whatsnew-clear-cookies-body = Algúns rastreadores redirixen a outros sitios web que configuran secretamente as cookies. { -brand-short-name } agora elimine automaticamente esas cookies para que non poidan rastrexar a súa presenza.
cfr-whatsnew-clear-cookies-image-alt = Ilustración de bloqueo de cookies
