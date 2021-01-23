# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Informe sobre { $addon-name }

abuse-report-title-extension = Informeu sobre aquesta extensió a { -vendor-short-name }
abuse-report-title-theme = Informeu sobre aquest tema a { -vendor-short-name }
abuse-report-subtitle = Quin és el problema?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = per <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    No saps quin problema seleccionar?
    <a data-l10n-name="learnmore-link">Més informació sobre com informar sobre les extensions i els temes</a>

abuse-report-submit-description = Descriviu el problema (opcional)
abuse-report-textarea =
    .placeholder = Ens resulta més fàcil resoldre un problema si en tenim els detalls. Descriviu allò que us passa. Gràcies per ajudar-nos a mantenir Internet en bon estat de salut.
abuse-report-submit-note =
    Nota: No hi incloeu informació personal (com ara nom, adreça electrònica, número de telèfon, adreça física).
    { -vendor-short-name } conserva un registre permanent d'aquests informes.

## Panel buttons.

abuse-report-cancel-button = Cancel·la
abuse-report-next-button = Següent
abuse-report-goback-button = Vés enrere
abuse-report-submit-button = Envia

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = S'ha cancel·lat l'informe sobre <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitting = S'està enviant l'informe sobre <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Gràcies per enviar un informe. Voleu eliminar <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Gràcies per enviar un informe.
abuse-report-messagebar-removed-extension = Gràcies per enviar un informe. Heu eliminat l'extensió <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Gràcies per enviar un informe. Heu eliminat el tema <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = S'ha produït un error en enviar l'informe sobre <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = L'informe sobre <span data-l10n-name="addon-name">{ $addon-name }</span> no s'ha enviat perquè recentment ja s'ha enviat un altre informe.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Sí, elimina-la
abuse-report-messagebar-action-keep-extension = No, mantén-la
abuse-report-messagebar-action-remove-theme = Sí, elimina'l
abuse-report-messagebar-action-keep-theme = No, mantén-lo
abuse-report-messagebar-action-retry = Reintenta
abuse-report-messagebar-action-cancel = Cancel·la

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Ha malmès l'ordinador o ha posat les meves dades en risc
abuse-report-damage-example = Exemple: programari maliciós injectat o robatori de dades

abuse-report-spam-reason-v2 = Conté brossa o insereix publicitat no desitjada
abuse-report-spam-example = Exemple: insereix anuncis en les pàgines web

abuse-report-settings-reason-v2 = Ha canviat el meu motor de cerca, la pàgina d'inici o la de pestanya nova sense informar-me'n ni preguntar-m'ho
abuse-report-settings-suggestions = Abans d’informar sobre l'extensió, podeu provar de canviar els paràmetres:
abuse-report-settings-suggestions-search = Canvieu els paràmetres de cerca per defecte
abuse-report-settings-suggestions-homepage = Canvieu la vostra pàgina principal i de pestanya nova

abuse-report-deceptive-reason-v2 = Pretén ser quelcom que no és
abuse-report-deceptive-example = Exemple: imatges o descripcions enganyoses

abuse-report-broken-reason-extension-v2 = No funciona, deixa llocs web inutilitzables o fa que el { -brand-product-name } vagi lent
abuse-report-broken-reason-theme-v2 = No funciona o fa que el navegador es vegi malament
abuse-report-broken-example = Exemple: les funcions són lentes, difícils d’utilitzar o no funcionen; parts dels llocs web no es carreguen o tenen un aspecte inusual
abuse-report-broken-suggestions-extension =
    Sembla que heu identificat un error. A més d'enviar un informe aquí, la millor manera de resoldre un problema de funcionalitat, és contactar amb el desenvolupador de l'extensió.
    <a data-l10n-name="support-link">Visiteu el lloc web de l'extensió</a> per obtenir informació del desenvolupador.
abuse-report-broken-suggestions-theme =
    Sembla que heu identificat un error. A més d'enviar un informe aquí, la millor manera de resoldre un problema de funcionalitat és contactar amb el desenvolupador del tema.
    <a data-l10n-name="support-link">Visiteu el lloc web del tema</a> per obtenir la informació del desenvolupador.

abuse-report-policy-reason-v2 = Inclou contingut d'odi, violent o il·legal
abuse-report-policy-suggestions =
    Nota: els problemes de propietat intel·lectual i de marca s'han de notificar en un procés independent.
    <a data-l10n-name="report-infringement-link">Utilitzeu aquestes instruccions</a> per
    informar del problema.

abuse-report-unwanted-reason-v2 = No l'he volgut mai i no sé com desfer-me'n
abuse-report-unwanted-example = Exemple: una aplicació la va instal·lar sense el meu permís

abuse-report-other-reason = Una altra cosa

