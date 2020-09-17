# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Hubo un error al enviar el informe. Pruebe de nuevo más tarde.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = ¿Sitio arreglado? Enviar informe

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
    .aria-label = Más información sobre la protección contra rastreo aumentada

protections-panel-etp-on-header = La protección contra rastreo aumentada ahora está habilitada para este sitio
protections-panel-etp-off-header = La protección contra rastreo aumentada ahora está deshabilitada para este sitio

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = ¿El sitio no funciona?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = ¿El sitio no funciona?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = ¿Por qué?
protections-panel-not-blocking-why-etp-on-tooltip = Bloquear estos podría dañar elementos de algunos sitios web. Sin rastreadores algunos botones, formularios y campos de inicio de sesión podrían no funcionar.
protections-panel-not-blocking-why-etp-off-tooltip = Todos los rastreadores en este sitio se cargaron porque las protecciones están desactivadas.

##

protections-panel-no-trackers-found = No se detectaron rastreadores conocidos para { -brand-short-name } en esta página.

protections-panel-content-blocking-tracking-protection = Contenido de rastreo

protections-panel-content-blocking-socialblock = Rastreadores de redes sociales
protections-panel-content-blocking-cryptominers-label = Cryptominers
protections-panel-content-blocking-fingerprinters-label = Detectores de huellas digitales

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Bloqueado
protections-panel-not-blocking-label = Permitido
protections-panel-not-found-label = Ninguno detectado

##

protections-panel-settings-label = Configuración de protección

# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Panel de protecciones

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Desactive las protecciones si tiene problemas con:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Campos de inicio de sesión
protections-panel-site-not-working-view-issue-list-forms = Formularios
protections-panel-site-not-working-view-issue-list-payments = Pagos
protections-panel-site-not-working-view-issue-list-comments = Comentarios
protections-panel-site-not-working-view-issue-list-videos = Videos

protections-panel-site-not-working-view-send-report = Enviar informe

##

protections-panel-cross-site-tracking-cookies = Estas cookies lo siguen de un sitio a otro para recopilar datos sobre lo que hace en línea. Las establecen terceros, como anunciantes y empresas de análisis.
protections-panel-cryptominers = Los criptomineros utilizan la potencia informática de su sistema para extraer dinero digital. Las secuencias de comandos de cifrado de los mismos agotan su batería, ralentizan su computadora y pueden aumentar su factura de electricidad.
protections-panel-fingerprinters = Los detectores de huellas digitales recolectan la configuración de su navegador y su computadora para crear un perfil suyo. Usando este detector de huella digital pueden seguirlo a través de diferentes sitios web.
protections-panel-tracking-content = Los sitios pueden cargar publicidades externas, videos y otro contenido con código de rastreo. Bloquear el contenido de rastreo puede ayudar a que los sitios carguen más rápido pero algunos botones, formularios y campos de ingreso pueden dejar de funcionar.
protections-panel-social-media-trackers = Las redes sociales ubican rastreadores en otros sitios web para seguir lo que hace, ve y mira en línea. Esto permite que las empresas de redes sociales aprendan más sobre usted más allá de lo que comparte en sus perfiles de redes sociales.

protections-panel-content-blocking-manage-settings =
    .label = Administrar la configuración de protección
    .accesskey = M

protections-panel-content-blocking-breakage-report-view =
    .title = Informar de un sitio que no se carga
protections-panel-content-blocking-breakage-report-view-description = El bloqueo de ciertos rastreadores puede causar problemas con algunos sitios web. Informar sobre estos problemas ayuda a que { -brand-short-name } sea mejor para todos. Al enviar este informe, se enviará a Mozilla una URL e información sobre la configuración de su navegador. <label data-l10n-name="learn-more">Aprender más</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Opcional: Describir el problema
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Opcional: Describir el problema
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Cancelar
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Enviar informe
