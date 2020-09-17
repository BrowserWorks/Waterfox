# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = I hai habiu una error en ninviar l'informe. Torna a intentar-lo mas tarde.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Puesto apanyau? Ninviar informe

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Estricto
    .label = Estricto
protections-popup-footer-protection-label-custom = Personalizada
    .label = Personalizada
protections-popup-footer-protection-label-standard = Standard
    .label = Standard

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Mas información sobre la protección contra seguimiento amillorada

protections-panel-etp-on-header = La protección contra seguimiento amillorada ye habilitada pa este puesto
protections-panel-etp-off-header = La protección contra seguimiento amillorada ye deshabilitada pa este puesto

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Lo puesto no funciona?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Lo puesto no funciona?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Per qué?
protections-panel-not-blocking-why-etp-on-tooltip = Blocar-los puede interferir con elementos en qualques puestos. Sin elementos de seguimiento, qualques botons, formularios y campos d'inicio de sesión podrían no funcionar.
protections-panel-not-blocking-why-etp-off-tooltip = Totz los elementos de seguimiento en este puesto s'han cargau perque las proteccions son desactivadas.

##

protections-panel-no-trackers-found = No s'han detectau elementos de seguimiento conoixius per { -brand-short-name } en esta pachina.

protections-panel-content-blocking-tracking-protection = Conteniu de seguimiento

protections-panel-content-blocking-socialblock = Elementos de seguimiento de retz socials
protections-panel-content-blocking-cryptominers-label = Criptominers
protections-panel-content-blocking-fingerprinters-label = Ditaladas dichitals

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Blocau
protections-panel-not-blocking-label = Permitiu
protections-panel-not-found-label = Garra detectau

##

protections-panel-settings-label = Achustes de protección
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Panel de proteccions

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Desactiva las proteccions si tiens problemas con:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Campos d'inicio de sesión
protections-panel-site-not-working-view-issue-list-forms = Formularios
protections-panel-site-not-working-view-issue-list-payments = Pagos
protections-panel-site-not-working-view-issue-list-comments = Comentarios
protections-panel-site-not-working-view-issue-list-videos = Videos

protections-panel-site-not-working-view-send-report = Ninviar un informe

##

protections-panel-cross-site-tracking-cookies = Estas cookies te siguen de pachina en pachina pa recopilar información sobre la tuya vida en linia. Gosan estar las achencias de publicidat y d'analisi las que las configuran.
protections-panel-cryptominers = Los criptominers emplegan la potencia informatica d'o tuyo sistema pa obtener diners dichitals. Los scripts de criptominería acotolan la batería d'o tuyo ordinador, lo ralentizan y pueden aumentar la tuya factura d'electricidat.
protections-panel-fingerprinters = Los detectores de ditaladas dichitals recolectan la configuración d'o tuyo navegador y lo tuyo ordinador pa crear lo tuyo perfil. Fende servir este detector de ditaladas seguir-te a traviés de diferents puestos web.
protections-panel-tracking-content = Los puestos web pueden cargar anuncios externos, videos y unatro tipo de conteniu gracias a un codigo de seguimiento. Si blocas lo conteniu de seguimiento, los puestos se cargarán mas rapido, pero puede que qualques botons y formularios deixen de funcionar.
protections-panel-social-media-trackers = Los retz socials plazan elementos de seguimiento en atros puestos web pa seguir lo que fas, lo que veyes y lo que miras en linia. Esto les permite a las companyías de medios socials de saber mas sobre tu, dillá d'o que compartes en os tuyos perfils de retz socials.

protections-panel-content-blocking-manage-settings =
    .label = Chestionar los achustes de protección
    .accesskey = M

protections-panel-content-blocking-breakage-report-view =
    .title = Informar de problemas con un puesto
protections-panel-content-blocking-breakage-report-view-description = Si blocas bell elementos de seguimiento, puede que qualques puestos deixen de funcionar. Si nos informas d'estes problemas, nos aduyarás a amillorar { -brand-short-name }. En ninviar este informe, Mozilla recibirá una URL y información sobre la configuración d'o tuyo navegador. <label data-l10n-name="learn-more">Saber mas</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Opcional: describe lo problema
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Opcional: describe lo problema
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Cancelar
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Ninviar reporte
