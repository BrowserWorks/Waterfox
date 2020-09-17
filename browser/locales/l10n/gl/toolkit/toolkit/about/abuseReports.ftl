# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title.
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Informe para { $addon-name }
abuse-report-title-extension = Denunciar esta extensión a { -vendor-short-name }
abuse-report-title-theme = Denunciar este tema a { -vendor-short-name }
abuse-report-subtitle = Cal é o problema?
# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = por <a data-l10n-name="author-name">{ $author-name }</a>
abuse-report-learnmore =
    Non sabe que problema seleccionar?
    <a data-l10n-name="learnmore-link">Saiba máis sobre como denunciar extensións e temas</a>
abuse-report-submit-description = Describa o problema (opcional)
abuse-report-textarea =
    .placeholder = É máis fácil para nós resolver un problema se contamos cos detalles. Describa o que está a experimentar. Grazas por axudarnos a manter o web san.
abuse-report-submit-note =
    Nota: non inclúa información persoal (como nome, enderezo de correo electrónico, número de teléfono, enderezo físico).
    { -vendor-short-name } mantén un rexistro permanente destes informes.

## Panel buttons.

abuse-report-cancel-button = Cancelar
abuse-report-next-button = Seguinte
abuse-report-goback-button = Retroceder
abuse-report-submit-button = Enviar

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Cancelouse o informe para <span data-l10n-name = "addon-name"> { $addon-name }</span>.
abuse-report-messagebar-submitting = Enviando un informe para <span data-l10n-name = "addon-name"> { $addon-name }</span>.
abuse-report-messagebar-submitted = Grazas por enviar un informe. Quere eliminar <span data-l10n-name = "addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Grazas por enviar un informe.
abuse-report-messagebar-removed-extension = Grazas por enviar un informe. Eliminou a extensión <span data-l10n-name = "addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Grazas por enviar un informe. Eliminou o tema <span data-l10n-name = "addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Houbo un erro ao enviar o informe sobre <span data-l10n-name = "addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = O informe sobre <span data-l10n-name = "addon-name">{ $addon-name }</span> non foi enviado porque outro informe foi enviado recentemente.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Si, elimíneo
abuse-report-messagebar-action-keep-extension = Non, vouna manter
abuse-report-messagebar-action-remove-theme = Si, elimíneo
abuse-report-messagebar-action-keep-theme = Non, vou mantelo
abuse-report-messagebar-action-retry = Intentar de novo
abuse-report-messagebar-action-cancel = Cancelar

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Danou o meu computador ou comprometeu os meus datos
abuse-report-damage-example = Exemplo: inxección de malware ou datos roubados
abuse-report-spam-reason-v2 = Contén spam ou insire publicidade non desexada
abuse-report-spam-example = Exemplo: Inserir anuncios en páxinas web
abuse-report-settings-reason-v2 = Cambiou o meu buscador, páxina de inicio ou nova lapela sen informarme nin preguntarme
abuse-report-settings-suggestions = Antes de informar da extensión, pode intentar cambiar a súa configuración:
abuse-report-settings-suggestions-search = Cambie a configuración de busca predeterminada
abuse-report-settings-suggestions-homepage = Cambie a súa páxina de inicio e nova lapela
abuse-report-deceptive-reason-v2 = Afirma que é algo que non é
abuse-report-deceptive-example = Exemplo: descrición ou imaxes enganosas
abuse-report-broken-reason-extension-v2 = Non funciona, rompe sitios web ou diminúe { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Non funciona nin rompe a visualización do navegador
abuse-report-broken-example = Exemplo: as funcións son lentas, difíciles de usar ou non funcionan; partes de sitios web non se cargarán nin parecen inusuales
abuse-report-broken-suggestions-extension =
    Parece que identificou un erro. Ademais de enviar un informe aquí, o mellor xeito
    para resolver un problema de funcionalidade é contactar co desenvolvedor de extensións.
    <a data-l10n-name="support-link">Visite o sitio web da extensión</a> para obter información do desenvolvedor.
abuse-report-broken-suggestions-theme =
    Parece que identificou un erro. Ademais de enviar un informe aquí, o mellor xeito
    para resolver un problema de funcionalidade é poñerse en contacto co creador de temas.
    <a data-l10n-name="support-link">Visite o sitio web do tema</a> para obter información do desenvolvedor.
abuse-report-policy-reason-v2 = Contén contido de odio, violento ou ilegal
abuse-report-policy-suggestions =
    Nota: os problemas de propiedade intelectual e marcas deben ser comunicados nun proceso separado.
    <a data-l10n-name="report-infringement-link">Use estas instrucións</a> para
    informar do problema.
abuse-report-unwanted-reason-v2 = Nunca o quixen e non sei como me desfacer del
abuse-report-unwanted-example = Exemplo: Unha aplicación instalouna sen o meu permiso
abuse-report-other-reason = Algo máis
