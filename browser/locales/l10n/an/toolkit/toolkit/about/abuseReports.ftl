# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title.
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Informe pa { $addon-name }

abuse-report-title-extension = Informar d'esta extensión a { -vendor-short-name }
abuse-report-title-theme = Informar d'este tema a { -vendor-short-name }
abuse-report-subtitle = Quál ye lo problema?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = per <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore = No sabe qué problema triar? <a data-l10n-name="learnmore-link">Descubre mas sobre cómo informar d'extensions y temas</a>

abuse-report-submit-description = Describir lo problema (opcional)
abuse-report-textarea =
    .placeholder = Pa nusatros ye mas facil apanyar un problema si tenemos detalles especificos. Describa lo suyo problema. Gracias per aduyar-nos a que Internet siga estando saludable.
abuse-report-submit-note = Nota: no incluiga información personal (como nombres, adreza de correu, numero de telefono, adreza postal). { -vendor-short-name } alza un rechistro d'estes informes.

## Panel buttons.

abuse-report-cancel-button = Cancelar
abuse-report-next-button = Siguient
abuse-report-goback-button = Tornar dezaga
abuse-report-submit-button = Ninviar

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Se canceló l'informe sobre <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitting = Ninviando informe sobre <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Gracias per ninviar l'informe. Quiere eliminar <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Gracias per ninviar l'informe.
abuse-report-messagebar-removed-extension = Gracias per ninviar un reporte. Has borrau la extensión <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Gracias per ninviar un reporte. Has borrau lo tema <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = I habió una error en ninviar l'informe sobre <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = No se ninvió l'informe sobre <span data-l10n-name="addon-name">{ $addon-name }</span> perque unatro informe se ninvió recientment.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Sí, eliminar-lo
abuse-report-messagebar-action-keep-extension = No, alzar-lo
abuse-report-messagebar-action-remove-theme = Sí, eliminar-lo
abuse-report-messagebar-action-keep-theme = No, alzar-lo
abuse-report-messagebar-action-retry = Reintentar
abuse-report-messagebar-action-cancel = Cancelar

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Ha danyau lo mío ordinador u los míos datos s'han visto compromesos
abuse-report-damage-example = Eixemplo: instalar malware u furtar información

abuse-report-spam-reason-v2 = Contiene spam u inserta publicidat no deseyada
abuse-report-spam-example = Eixemplo: fica publicidat en pachinas web

abuse-report-settings-reason-v2 = Ha cambiau la mía buscador, pachina d'inicio u nueva pestanya sin informar-me ni preguntar-me
abuse-report-settings-suggestions = Antes d'informar sobre la extensión, prebe a cambiar la configuración:
abuse-report-settings-suggestions-search = Cambie la configuración predeterminada d'as busquedas
abuse-report-settings-suggestions-homepage = Cambie la pachina d'inicio y de nueva pestanya

abuse-report-deceptive-reason-v2 = Simula estar bella cosa que no ye
abuse-report-deceptive-example = Eixemplo: descripción u imachens erronias

abuse-report-broken-reason-extension-v2 = No funciona, provoca errors en puestos u ralentiza { -brand-product-name }
abuse-report-broken-reason-theme-v2 = No funciona u estorba lo que amuestra lo navegador
abuse-report-broken-example = Eixemplo: la función ye lenta, dificil d'usar u no funciona; bellas partes d'os puestos web no se cargan u s'amuestran de forma incorrecta
abuse-report-broken-suggestions-extension = Pareixe que ha identificau un problema. Amás de ninviar un informe per aquí, lo millor pa aconseguir que se resuelta un problema de funcionalidat ye contactar con o desembolicador d'a extensión. <a data-l10n-name="support-link">Acceda a lo puesto web d'a extensión</a> pa aconseguir los datos de contacto d'o desembolicador.
abuse-report-broken-suggestions-theme = Pareixe que ha identificau un problema. Amás de ninviar un informe per aquí, lo millor pa aconseguir que se resuelta un problema de funcionalidat ye contactar con o desembolicador d'o tema. <a data-l10n-name="support-link">Acceda a lo puesto web d'o tema</a> pa aconseguir los datos de contacto d'o desenvolvedor.

abuse-report-policy-reason-v2 = Tiene conteniu d'odio, violento u ilegal
abuse-report-policy-suggestions =
    Nota: Los problemas relacionaus con dreitos d'autor y marcas rechistradas han d'informar-se en un proceso separau.
    <a data-l10n-name="report-infringement-link">Utilice estas instruccions</a> pa
    informar d'o problema

abuse-report-unwanted-reason-v2 = Nunca lo querié y no sé cómo desfer-me d'ell
abuse-report-unwanted-example = Eixemplo: una aplicación la instaló sin lo mío permiso

abuse-report-other-reason = Unatra coseta

