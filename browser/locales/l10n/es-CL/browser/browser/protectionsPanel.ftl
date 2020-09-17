# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Hubo un error al enviar el informe. Por favor, vuelve a intentarlo más tarde.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = ¿Sitio arreglado? Enviar reporte

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Estricta
    .label = Estricta
protections-popup-footer-protection-label-custom = Personalizada
    .label = Personalizada
protections-popup-footer-protection-label-standard = Estándar
    .label = Estándar

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Más información sobre la protección de seguimiento mejorada

protections-panel-etp-on-header = La protección de seguimiento mejorada está ACTIVADA para este sitio
protections-panel-etp-off-header = La protección de seguimiento mejorada está DESACTIVADA para este sitio

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = ¿El sitio no funciona?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = ¿El sitio no funciona?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = ¿Por qué?
protections-panel-not-blocking-why-etp-on-tooltip = Bloquear esto podría hacer fallar elementos de algunos sitios web. Sin rastreadores, algunos botones, formularios y campos de conexión podrían no funcionar.
protections-panel-not-blocking-why-etp-off-tooltip = Todos los rastreadores en este sitio han sido cargados porque las protecciones están desactivadas.

##

protections-panel-no-trackers-found = No se detectaron rastreadores conocidos por { -brand-short-name } en esta página.

protections-panel-content-blocking-tracking-protection = Contenido de rastreo

protections-panel-content-blocking-socialblock = Rastreadores de redes sociales
protections-panel-content-blocking-cryptominers-label = Criptomineros
protections-panel-content-blocking-fingerprinters-label = Creadores de huellas (Fingerprinters)

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Bloqueado
protections-panel-not-blocking-label = Permitido
protections-panel-not-found-label = Nada detectado

##

protections-panel-settings-label = Ajustes de protección
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Panel de protecciones

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Desactiva las protecciones si tienes problemas con:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Campos de credenciales
protections-panel-site-not-working-view-issue-list-forms = Formularios
protections-panel-site-not-working-view-issue-list-payments = Pagos
protections-panel-site-not-working-view-issue-list-comments = Comentarios
protections-panel-site-not-working-view-issue-list-videos = Videos

protections-panel-site-not-working-view-send-report = Envía un reporte

##

protections-panel-cross-site-tracking-cookies = Estas cookies te siguen de sitio en sitio para recolectar datos sobre lo que haces en línea. Son colocadas por terceros, tales como compañías de publicidad y analítica.
protections-panel-cryptominers = Los criptomineros utilizan la potencia de cómputo de tu sistema para la minería de dinero digital. Los scripts utilizados para ello consumen tu batería, relentecen tu computador e incrementan el valor de tu boleta de electricidad.
protections-panel-fingerprinters = Los creadores de huellas (Fingerprinters) recolectan ajustes de tu navegador y computador para crear un perfil tuyo. Usando esta huella digital ellos pueden seguirte a través de diferentes sitios web.
protections-panel-tracking-content = Los sitios web pueden cargar anuncios publicitarios, videos y otros elementos con códigos para seguimiento. Bloquearlos contenidos de seguimiento puede ayudar a que los sitios carguen más rápido, pero algunos botones, formularios y campos para conectarse podrían dejar de funcionar.
protections-panel-social-media-trackers = Las redes sociales colocan rastreadores en otros sitios web para seguir lo que haces y miras en línea. Esto le permite a las compañías de redes sociales aprender más sobre tu comportamiento yendo más allá de lo que compartes en tus perfiles de redes sociales.

protections-panel-content-blocking-manage-settings =
    .label = Gestionar ajustes de protección
    .accesskey = M

protections-panel-content-blocking-breakage-report-view =
    .title = Informar de un sitio que no carga
protections-panel-content-blocking-breakage-report-view-description = Bloquear algunos rastreadores puede causar problemas con algunos sitios. Reportando estos problemas ayudas a mejorar { -brand-short-name } para todos. Enviar este reporte entregará la URL junto con información de la configuración del navegador a Mozilla. <label data-l10n-name="learn-more">Aprender más</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Opcional: Describe el problema
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Opcional: Describe el problema
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Cancelar
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Enviar reporte
