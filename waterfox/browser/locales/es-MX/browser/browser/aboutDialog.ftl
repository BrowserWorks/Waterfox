# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = Acerca de { -brand-full-name }

releaseNotes-link = Qué hay de nuevo

update-checkForUpdatesButton =
    .label = Buscar actualizaciones
    .accesskey = B

update-updateButton =
    .label = Reiniciar para actualizar { -brand-shorter-name }
    .accesskey = R

update-checkingForUpdates = Buscando actualizaciones…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>Descargando actualización — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Descargando actualización — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Aplicando actualización…

update-failed = La actualización falló. <label data-l10n-name="failed-link">Descarga la ultima versión</label>
update-failed-main = La actualización falló. <a data-l10n-name="failed-link-main">Descarga la versión más reciente</a>

update-adminDisabled = Actualizaciones deshabilitadas por el administrador del sistema
update-noUpdatesFound = { -brand-short-name } está actualizado
aboutdialog-update-checking-failed = Error al buscar actualizaciones.
update-otherInstanceHandlingUpdates = { -brand-short-name } está siendo actualizado por otra instancia

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Actualizaciones disponibles en <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = Actualizaciones disponibles en <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = No puedes realizar más actualizaciones en este sistema. <label data-l10n-name="unsupported-link">Más información</label>

update-restarting = Reiniciando…

update-internal-error2 = No se pueden buscar actualizaciones debido a un error interno. Actualizaciones disponibles en <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = Estás usando el canal de actualizaciones <label data-l10n-name="current-channel">{ $channel }</label>.

warningDesc-version = { -brand-short-name } es experimental y puede ser inestable.

aboutdialog-help-user = Ayuda de { -brand-product-name }
aboutdialog-submit-feedback = Enviar opinión

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> es una <label data-l10n-name="community-exp-creditsLink">comunidad global</label> trabajando unida para mantener la Web abierta, pública y accesible para todos.

community-2 = { -brand-short-name } es diseñado por <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>, una <label data-l10n-name="community-creditsLink">comunidad global</label> trabajando unida para mantener la Web abierta, pública y accesible para todos.

helpus = ¿Quieres ayudar? <label data-l10n-name="helpus-donateLink">¡Haz una donación</label> o <label data-l10n-name="helpus-getInvolvedLink">participa!</label>

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
