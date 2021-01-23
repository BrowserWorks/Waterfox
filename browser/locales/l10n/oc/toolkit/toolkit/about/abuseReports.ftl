# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Rapòrt per { $addon-name }

abuse-report-title-extension = Senhalar aquesta extension a { -vendor-short-name }
abuse-report-title-theme = Senhalar aqueste tèma a { -vendor-short-name }
abuse-report-subtitle = Qual es lo problèma ?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = per <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Sabètz pas quin problèma causir ?
    <a data-l10n-name="learnmore-link">Ne saber mai a prepaus del senhalament d'extensions e tèmas</a>

abuse-report-submit-description = Descrivètz lo problèma (opcional)
abuse-report-textarea =
    .placeholder = Es mai aisit de resòlvre un problèma s'avèm de detalhs. Descrivètz çò que vos arriba. Mercé de nos ajudar a gardar lo Web sanitós.
abuse-report-submit-note = Remarca : donetz pas d'informacions personalas (coma lo nom, adreça electronica, numèro de telefòn, adreça fisica). { -vendor-short-name } garda de contunh aquestes rapòrts.

## Panel buttons.

abuse-report-cancel-button = Anullar
abuse-report-next-button = Seguent
abuse-report-goback-button = Tornar
abuse-report-submit-button = Mandar

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Senhalament de <span data-l10n-name="addon-name">{ $addon-name }</span> anullat.
abuse-report-messagebar-submitting = Mandadís d’un senhalament de <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Mercés d’aver enviat un rapòrt. Volètz suprimir <span data-l10n-name="addon-name">{ $addon-name }</span> ?
abuse-report-messagebar-submitted-noremove = Mercés d’aver enviat un rapòrt.
abuse-report-messagebar-removed-extension = Mercés d’aver enviat un rapòrt. Avètz suprimit l’extension <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Mercés d’aver enviat un rapòrt. Avètz suprimit lo tèma <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Una error s’es producha en mandar lo senhalament de <span data-l10n-name="addon-name"> { $addon-name } </span>.
abuse-report-messagebar-error-recent-submit = Lo senhalament de <span data-l10n-name="addon-name">{ $addon-name }</span> es pas estat mandat qu'un autre senhalament foguèt enviat recentament.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Òc, la suprimir
abuse-report-messagebar-action-keep-extension = Non, la gardarai
abuse-report-messagebar-action-remove-theme = Òc, la suprimir
abuse-report-messagebar-action-keep-theme = Non, lo gardarai
abuse-report-messagebar-action-retry = Tornar ensajar
abuse-report-messagebar-action-cancel = Anullar

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Damatgèt mon ordenador o mas donadas
abuse-report-damage-example = Exemple : logicial malvolent introduch o donada panada

abuse-report-spam-reason-v2 = Conten d'spam e de publicitat non desirada
abuse-report-spam-example = Exemple : inserís publicitats sus las paginas web

abuse-report-settings-reason-v2 = A cambiat mon motor de recèrca, pagina d’acuèlh, o d’onglets nòus sens m'avertir o me demandar
abuse-report-settings-suggestions = Abans de senhalar l’extension, podètz enssajar de modificar vòstres paramètres :
abuse-report-settings-suggestions-search = Càmbia vòstres paramètres de recèrca per defaut
abuse-report-settings-suggestions-homepage = Càmbia vòstra pagina d’acuèlh e d’onglet nòu

abuse-report-deceptive-reason-v2 = Pretend èsser quicòm qu’es pas
abuse-report-deceptive-example = Exemple : descripcion e imatges enganaires

abuse-report-broken-reason-extension-v2 = Fonciona pas, còpa los sites web, o alentís { -brand-product-name }
abuse-report-broken-reason-theme-v2 = fonciona pas o còpa l’afichatge del navegador
abuse-report-broken-example = Exemple : las foncionalitats son lentas, malaisidas d’utilizar o foncionan pas ; d’unas partidas dels sites Web se cargan pas o an una aparéncia inabituala.
abuse-report-broken-suggestions-extension =
    Sembla qu'avètz identificar un bug. En mai de sometre un rapòrt aquí, lo melhor biais
    per resòlvre un problèma de foncionalitat es de contactar lo desvolopaire de l'extension.
    <a data-l10n-name="support-link">Consultatz lo site Web de l'extension</a> per obténer las informacions sul desvolopaire.
abuse-report-broken-suggestions-theme =
    Sembla qu'avètz identificar un bug. En mai de sometre un rapòrt aquí, lo melhor biais
    per resòlvre un problèma de foncionalitat es de contactar lo desvolopaire del tèma.
    <a data-l10n-name="support-link">Consultatz lo site Web del tèma</a> per obténer las informacions suls desvolopaires.

abuse-report-policy-reason-v2 = Conten de contengut asirós, violent o illegal
abuse-report-policy-suggestions =
    Remarca : los problèmas de drech d'autor e de marca devon èsser senhalats dins un processús diferent.
    <a data-l10n-name="report-infringement-link">Utilisatz aquestas instruccions</a> per
    senhalar lo problèma.

abuse-report-unwanted-reason-v2 = Ai pas jamai volgut aquò e sabi pas cossí me’n desfar
abuse-report-unwanted-example = Exemple : una aplicacion l’installèt sens ma permission

abuse-report-other-reason = Quicòm mai

