# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Informe para { $addon-name }

abuse-report-title-extension = Informar de esta Extensión a { -vendor-short-name }
abuse-report-title-theme = Informar de este Tema a { -vendor-short-name }
abuse-report-subtitle = ¿Cuál es el problema?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = por <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    ¿No está seguro de qué problema seleccionar?
    <a data-l10n-name="learnmore-link"> Conozca más información acerca informes de extensiones y temas  </a>

abuse-report-submit-description = Describa el problema (opcional)
abuse-report-textarea =
    .placeholder = Es más fácil para nosotros abordar un problema si tenemos detalles específicos. Por favor, describa lo que le está pasando. Gracias por ayudarnos a mantener la red saludable.
abuse-report-submit-note =
    Nota: no incluya información personal (como nombre, dirección de correo electrónico, número de teléfono, dirección física).
    { -vendor-short-name } mantiene un registro permanente de estos informes.

## Panel buttons.

abuse-report-cancel-button = Cancelar
abuse-report-next-button = Siguiente
abuse-report-goback-button = Retroceder
abuse-report-submit-button = Enviar

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Se canceló el informe para <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitting = Enviando el informe para <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Gracias por enviar el informe. ¿Quiere eliminar <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Gracias por enviar el informe.
abuse-report-messagebar-removed-extension = Gracias por enviar el informe. Elimiinó la extensión <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Gracias por enviar el informe. Eliminó el tema <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Hubo un error al enviar el informe sobre <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = No se envió el informe sobre <span data-l10n-name="addon-name">{ $addon-name }</span> porque recientemente se envió otro informe.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Sí, elimínenlo
abuse-report-messagebar-action-keep-extension = No, lo guardaré
abuse-report-messagebar-action-remove-theme = Sí, elimínenlo
abuse-report-messagebar-action-keep-theme = No, lo guardaré
abuse-report-messagebar-action-retry = Reintentar
abuse-report-messagebar-action-cancel = Cancelar

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Dañó mi computadora o comprometió mis datos
abuse-report-damage-example = Ejemplo: Inyectar malware o robar datos

abuse-report-spam-reason-v2 = Contiene basura o inserta publicidad no deseada
abuse-report-spam-example = Ejemplo: Insertar publicidad en páginas web

abuse-report-settings-reason-v2 = Cambió mi buscador, página de inicio o nueva pestaña sin informarme ni preguntarme
abuse-report-settings-suggestions = Antes de informar la extensión, intente cambiar la configuración:
abuse-report-settings-suggestions-search = Cambia la configuración de buscador predeterminado
abuse-report-settings-suggestions-homepage = Cambia la página de inicio y la nueva pestaña

abuse-report-deceptive-reason-v2 = Simula ser algo que no es
abuse-report-deceptive-example = Ejemplo: Descripción engañosa o imaginaria

abuse-report-broken-reason-extension-v2 = No funciona, rompe los sitios web o lentifica a { -brand-product-name }
abuse-report-broken-reason-theme-v2 = No funciona o rompe lo que muestra el navegador
abuse-report-broken-example = Ejemplo: las funciones son lentas, difíciles de usar o no funcionan; ciertas partes de los sitios web no se cargan o se muestran de forma incorrecta
abuse-report-broken-suggestions-extension = Parece que identificó un problema. Además de enviar un informe por aquí, lo mejor para conseguir que se resuelva un problema de funcionalidad es contactar con el desarrollador de la extensión. <a data-l10n-name="support-link">Acceda al sitio web de la extensión</a> para conseguir los datos de contacto del desarrollador.
abuse-report-broken-suggestions-theme = Parece que identificó un problema. Además de enviar un informe por aquí, lo mejor para conseguir que se resuelva un problema de funcionalidad es contactar con el desarrollador del tema. <a data-l10n-name="support-link">Acceda al sitio web del tema</a> para conseguir los datos de contacto del desarrollador.

abuse-report-policy-reason-v2 = Contenido de odio, violento o ilegal
abuse-report-policy-suggestions =
    Nota: Problemas de violación de derecho de autor y marcas registradas deben informarse en un proceso separado.
    <a data-l10n-name="report-infringement-link">Usar estas instrucciones</a> para
    informar el problema.

abuse-report-unwanted-reason-v2 = Nunca lo quise y no sé cómo deshacerme de él
abuse-report-unwanted-example = Ejemplo: Una aplicación instalada sin mi permiso

abuse-report-other-reason = Algo más

