# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Hubo un error al enviar el mensaje. Por favor, intenta de nuevo más tarde.
# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = ¿Sitio reparado? Envía un reporte

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Estricto
    .label = Estricto
protections-popup-footer-protection-label-custom = Personalizada
    .label = Personalizada
protections-popup-footer-protection-label-standard = Estándar
    .label = Estándar

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Más información sobre la protección antirrastreo mejorada
protections-panel-etp-on-header = La protección antirrastreo mejorada está ACTIVADA en este sitio
protections-panel-etp-off-header = La protección antirrastreo mejorada está DESACTIVADA en este sitio
# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = ¿No funciona el sitio?
# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = ¿No funciona el sitio?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = ¿Por qué?
protections-panel-not-blocking-why-etp-on-tooltip = Bloquear esto puede interferir con elementos en algunos sitios. Sin rastreadores, algunos botones, formularios y campos de inicio de sesión no trabajen.
protections-panel-not-blocking-why-etp-off-tooltip = Todos los rastreadores en este sitio web han sido cargados porque la protección está desactivada.

##

protections-panel-no-trackers-found = Ningún rastreador conocido por { -brand-short-name } fue detectado en esta página.
protections-panel-content-blocking-tracking-protection = Contenido de rastreo
protections-panel-content-blocking-socialblock = Rastreadores de redes sociales
protections-panel-content-blocking-cryptominers-label = Criptomineros
protections-panel-content-blocking-fingerprinters-label = Huellas dactilares

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Bloqueado
protections-panel-not-blocking-label = Permitido
protections-panel-not-found-label = No detectado

##

protections-panel-settings-label = Configuración de protección
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Panel de protección

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Desactiva las protecciones si experimentas problemas con:
# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Campos de inicio de sesión
protections-panel-site-not-working-view-issue-list-forms = Formularios
protections-panel-site-not-working-view-issue-list-payments = Pagos
protections-panel-site-not-working-view-issue-list-comments = Comentarios
protections-panel-site-not-working-view-issue-list-videos = Videos
protections-panel-site-not-working-view-send-report = Envía un reporte

##

protections-panel-cross-site-tracking-cookies = Esas cookies te siguen de sitio en sitio para recolectar datos sobre lo que haces en línea. Ellos son creados por terceros, como anunciantes y empresas de análisis.
protections-panel-cryptominers = Los criptomineros utilizan la potencia informática de tu sistema para extraer dinero digital. Los scripts de criptominería agotan tu batería, ralentizan tu computadora y pueden aumentar tu factura de energía.
protections-panel-fingerprinters = Las huellas digitales recopilan configuraciones de tu navegador y computadora para crear un perfil tuyo. Con esta huella digital, pueden rastrearte a través de diferentes sitios web.
protections-panel-tracking-content = Los sitios web pueden cargar anuncios externos, videos y otro tipo de contenido gracias a un código de rastreo. Si bloqueas el contenido de rastreo, los sitios se cargarán más rápido, pero puede que algunos botones y formularios dejen de funcionar.
protections-panel-social-media-trackers = Las redes sociales ubican rastreadores en otros sitios web para seguir lo que haces, ves y miras en línea. Esto permite que las empresas de redes sociales aprendan más sobre ti, más allá de lo que compartes en tus perfiles de redes sociales.
protections-panel-description-shim-allowed = Algunos rastreadores marcados abajo han sido parcialmente desbloqueados en esta página porque interactuaste con ellos.
protections-panel-description-shim-allowed-learn-more = Saber más
protections-panel-shim-allowed-indicator =
    .tooltiptext = Rastreador parcialmente desbloqueado
protections-panel-content-blocking-manage-settings =
    .label = Administrar ajustes de protección
    .accesskey = M
protections-panel-content-blocking-breakage-report-view =
    .title = Informar de un sitio no funcional
protections-panel-content-blocking-breakage-report-view-description = El bloqueo de ciertos rastreadores puede causar problemas con algunos sitios web. Informar sobre estos problemas ayuda a que { -brand-short-name } sea mejor para todos. Al enviar este informe, se enviará a Mozilla una URL e información sobre la configuración de tu navegador. <label data-l10n-name="learn-more">Más información</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Opcional: describe el problema
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Opcional: describe el problema
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Cancelar
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Enviar reporte
