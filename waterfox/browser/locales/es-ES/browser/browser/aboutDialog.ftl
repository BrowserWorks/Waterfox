# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = Acerca de { -brand-full-name }

releaseNotes-link = Novedades

update-checkForUpdatesButton =
    .label = Buscar actualizaciones
    .accesskey = B

update-updateButton =
    .label = Reinicie para actualizar { -brand-shorter-name }
    .accesskey = R

update-checkingForUpdates = Comprobando actualizaciones…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>Descargando actualización — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Descargando actualización — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Aplicando actualización…

update-failed = La actualización falló. <label data-l10n-name="failed-link">Descargar la última versión</label>
update-failed-main = La actualización falló. <a data-l10n-name="failed-link-main">Descargar la última versión</a>

update-adminDisabled = Actualizaciones desactivadas por su administrador
update-noUpdatesFound = { -brand-short-name } está actualizado
aboutdialog-update-checking-failed = Error al buscar actualizaciones.
update-otherInstanceHandlingUpdates = { -brand-short-name } está siendo actualizado por otra instancia

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Actualización disponible en <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = Actualización disponible en <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = No puede ejecutar más actualizaciones en este sistema. <label data-l10n-name="unsupported-link">Saber más</label>

update-restarting = Reiniciando…

update-internal-error2 = No se pueden buscar actualizaciones debido a un error interno. Actualizaciones disponibles en <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = Está usando el canal <label data-l10n-name="current-channel">{ $channel }</label> para actualizar.

warningDesc-version = { -brand-short-name } es experimental y puede ser inestable.

aboutdialog-help-user = Ayuda de { -brand-product-name }
aboutdialog-submit-feedback = Enviar opinión

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> es una <label data-l10n-name="community-exp-creditsLink">comunidad global</label> que trabaja unida para mantener la Web abierta, pública y accesible para todos.

community-2 = { -brand-short-name } está diseñado por <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>, una <label data-l10n-name="community-creditsLink">comunidad global</label> que trabaja unida para mantener la Web abierta, pública y accesible para todos.

helpus = ¿Quiere ayudar? <label data-l10n-name="helpus-donateLink">¡Haga una donación</label> o <label data-l10n-name="helpus-getInvolvedLink">involúcrese!</label>

bottomLinks-license = Información de licencia
bottomLinks-rights = Derechos del usuario final
bottomLinks-privacy = Política de privacidad

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits }-bit)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits }-bit)
