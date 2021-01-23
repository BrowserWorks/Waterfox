# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Reporte para { $addon-name }

abuse-report-title-extension = Reportar esta extensión a { -vendor-short-name }
abuse-report-title-theme = Reportar este tema a { -vendor-short-name }
abuse-report-subtitle = ¿Cuál es el problema?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = por <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore = ¿No sabes que problema seleccionar? <a data-l10n-name="learnmore-link">Aprende más acerca de reportar extensiones y temas</a>

abuse-report-submit-description = Describe el problema (opcional)
abuse-report-textarea =
    .placeholder = Es más fácil para nosotros abordar un problema si tenemos detalles específicos. por favor, describe lo que estás experimentando. Gracias por ayudarnos a mantener la web saludable.
abuse-report-submit-note = Nota: No incluyas información personal (tales como el nombre, correo, teléfono y dirección). { -vendor-short-name } mantiene un registro permanente de estos reportes.

## Panel buttons.

abuse-report-cancel-button = Cancelar
abuse-report-next-button = Siguiente
abuse-report-goback-button = Atrás
abuse-report-submit-button = Enviar

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Reporte para <span data-l10n-name="addon-name">{ $addon-name }</span> cancelado.
abuse-report-messagebar-submitting = Enviando reporte para <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Gracias por enviar un reporte. ¿Quieres eliminar <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Gracias por enviar un reporte.
abuse-report-messagebar-removed-extension = Gracias por enviar un reporte. Has eliminado la extensión <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Gracias por enviar un reporte. Has eliminado el tema <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Ocurrió un error al enviar el reporte para <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = El reporte para <span data-l10n-name="addon-name">{ $addon-name }</span> no fue enviado por que otro reporte fue enviado recientemente.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Sí, eliminarla
abuse-report-messagebar-action-keep-extension = No, mantenerla
abuse-report-messagebar-action-remove-theme = Sí, eliminarlo
abuse-report-messagebar-action-keep-theme = No, mantenerlo
abuse-report-messagebar-action-retry = Reintentar
abuse-report-messagebar-action-cancel = Cancelar

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Dañó mi computador o comprometió mis datos
abuse-report-damage-example = Ejemplo: Malware inyectado o datos robados

abuse-report-spam-reason-v2 = Contiene spam o inserta publicidad no deseada
abuse-report-spam-example = Ejemplo: Inserta publicidad en sitios web

abuse-report-settings-reason-v2 = Cambió mi buscador, página de inicio o nueva pestaña sin informarme ni preguntarme
abuse-report-settings-suggestions = Antes de reportar la extensión, puedes intentar cambiar tus ajustes:
abuse-report-settings-suggestions-search = Cambia tus ajustes de búsqueda predeterminados
abuse-report-settings-suggestions-homepage = Cambia tu página de inicio y nueva pestaña

abuse-report-deceptive-reason-v2 = Dice ser algo que no es
abuse-report-deceptive-example = Ejemplo: Descripción o imágenes engañosas

abuse-report-broken-reason-extension-v2 = No funciona, provoca errores en sitios o enlentece { -brand-product-name }
abuse-report-broken-reason-theme-v2 = No funciona o corrompe la vista del navegador
abuse-report-broken-example = Ejemplo: Las funciones son lentas, difíciles de usar o no funciona; partes de los sitios web no cargan o tienen un aspecto inusual
abuse-report-broken-suggestions-extension = Parece que has identificado un bug. Junto con enviar un reporte aquí, la mejor forma de que un problema de funcionalidad sea resuelto es contactar al desarrollador de la extensión. <a data-l10n-name="support-link">Visita el sitio web de la extensión</a> para conseguir la información del desarrollador.
abuse-report-broken-suggestions-theme = Parece que has identificado un bug. Junto con enviar un reporte aquí, la mejor forma de que un problema de funcionalidad sea resuelto es contactar al desarrollador del tema. <a data-l10n-name="support-link">Visita el sitio web del tema</a> para conseguir la información del desarrollador.

abuse-report-policy-reason-v2 = Muestra contenido de odio, violencia o ilegal
abuse-report-policy-suggestions = Nota: Problemas de derechos de autor y uso de marca deben ser reportados en un proceso separado. <a data-l10n-name="report-infringement-link">Usa estas instrucciones</a> para reportar el problema.

abuse-report-unwanted-reason-v2 = Nunca lo quise y no sé cómo deshacerme de él
abuse-report-unwanted-example = Ejemplo: Una aplicación instalada sin mi permiso

abuse-report-other-reason = Otra cosa

