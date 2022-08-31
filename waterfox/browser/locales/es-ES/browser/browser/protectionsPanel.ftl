# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Ha habido un error al enviar el informe. Vuelva a intentarlo más tarde.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = ¿Sitio arreglado? Enviar informe

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
    .aria-label = Más información sobre la protección contra rastreo mejorada

protections-panel-etp-on-header = La protección contra rastreo mejorada está habilitada para este sitio
protections-panel-etp-off-header = La protección contra rastreo mejorada está deshabilitada para este sitio

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = ¿El sitio no funciona?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = ¿El sitio no funciona?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = ¿Por qué?
protections-panel-not-blocking-why-etp-on-tooltip = Bloquearlos puede interferir con elementos en algunos sitios. Sin rastreadores, algunos botones, formularios y campos de inicio de sesión podrían no funcionar.
protections-panel-not-blocking-why-etp-off-tooltip = Todos los rastreadores en este sitio se han cargado porque las protecciones están desactivadas.

##

protections-panel-no-trackers-found = No se detectaron rastreadores conocidos por { -brand-short-name } en esta página.

protections-panel-content-blocking-tracking-protection = Contenido de rastreo

protections-panel-content-blocking-socialblock = Rastreadores de redes sociales
protections-panel-content-blocking-cryptominers-label = Criptomineros
protections-panel-content-blocking-fingerprinters-label = Fingerprinters

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Bloqueado
protections-panel-not-blocking-label = Permitido
protections-panel-not-found-label = Ninguno detectado

##

protections-panel-settings-label = Ajustes de protección
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
protections-panel-site-not-working-view-issue-list-videos = Vídeos

protections-panel-site-not-working-view-send-report = Enviar un informe

##

protections-panel-cross-site-tracking-cookies = Estas cookies le siguen de página en página para recopilar información sobre su vida en línea. Suelen ser las agencias de publicidad y de analítica las que las configuran.
protections-panel-cryptominers = Los criptomineros utilizan la potencia informática de su sistema para obtener dinero digital. Los scripts de criptominería agotan la batería de su ordenador, lo ralentizan y pueden aumentar su factura de electricidad.
protections-panel-fingerprinters = Los detectores de huellas digitales recolectan la configuración de su navegador y su ordenador para crear un perfil de usted. Usando este detector de huella digital pueden seguirle a través de diferentes sitios web.
protections-panel-tracking-content = Los sitios web pueden cargar anuncios externos, videos y otro tipo de contenido gracias a un código de rastreo. Si bloquea el contenido de rastreo, los sitios se cargarán más rápido, pero puede que algunos botones y formularios dejen de funcionar.
protections-panel-social-media-trackers = Las redes sociales colocan rastreadores en otros sitios web para saber qué hace, ve y mira en línea. Ese rastreo les permite saber mucho más de lo que comparte en sus perfiles de las redes sociales.

protections-panel-description-shim-allowed = Algunos rastreadores marcados debajo han sido parcialmente desbloqueados en esta página porque ha interactuado con ellos.
protections-panel-description-shim-allowed-learn-more = Saber más
protections-panel-shim-allowed-indicator =
    .tooltiptext = Rastreador parcialmente desbloqueado

protections-panel-content-blocking-manage-settings =
    .label = Gestionar los ajustes de protección
    .accesskey = M

protections-panel-content-blocking-breakage-report-view =
    .title = Informar de problemas con un sitio
protections-panel-content-blocking-breakage-report-view-description = Si bloquea ciertos rastreadores, puede que algunos sitios dejen de funcionar. Si nos informa de estos problemas, nos ayudará a mejorar { -brand-short-name }. Al enviar este informe, Waterfox recibirá una URL e información sobre la configuración de su navegador. <label data-l10n-name="learn-more">Saber más</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Opcional: describa el problema
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Opcional: describa el problema
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Cancelar
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Enviar reporte
