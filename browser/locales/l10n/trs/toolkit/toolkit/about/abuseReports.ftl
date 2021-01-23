# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Ganatà’ riña { $addon-name }

abuse-report-title-extension = Natà' sa hua yi'î Ekstensiûn nan riña { -vendor-short-name }
abuse-report-title-theme = Natà' sa hua ti'î Tema nan riña { -vendor-short-name }
abuse-report-subtitle = ¿Nù huin si hua a'nan' nanj?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = guendâ <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore = ¿Nu ni'înt nùj huin si hua hia a'? <a data-l10n-name="learnmore-link">Gahia doj sa ga'ue gi'iát nga nej ekstensiûn ni nej tema</a>

abuse-report-submit-description = Natà' nù huin sa hua a'nan' (si ruhuât)
abuse-report-textarea =
    .placeholder = Hìo doj ga'ue nagi'iaj ñûnj nej sa ahui a'nan' sisi gini'in ñûnj sa 'iaj. Gi'iaj 'ngo sunuj u ni ganatà't sa nitaj si 'iaj sun hue'ê. Guruhuât ruguñu'unjt da' ga hue'ê red riña daran' nê'.
abuse-report-submit-note = 'Ngo nuguan'an: Si gachrûnt 'ngo nuguan' hua rayi'ît (dàj rûn' si yuguît, si korreôt, si numerôt, si yugui riña nêt). { -vendor-short-name } Naran'anj 'ngo nej nuguan' hua rayi'î nej rasun nan.

## Panel buttons.

abuse-report-cancel-button = Duyichin'
abuse-report-next-button = Guij ne' ñaan
abuse-report-goback-button = Nanikàj rukù
abuse-report-submit-button = Gà'nïnj gan'an

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Nuguan' huaj guendâ <span data-l10n-name="addon-name">{ $addon-name }</span> giyichin' man.
abuse-report-messagebar-submitting = Hìaj na'nïn nuguan'an gan'anj guendâ <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Guruhuât nata' snan'anjt. Ruhuât nadurê' raj? <span data-l10n-name="addon-name">{ $addon-name }</span>
abuse-report-messagebar-submitted-noremove = Guruhuât nata' snan'anjt.
abuse-report-messagebar-removed-extension = Guruhuât nata' snan'anjt. Nadurê't ekstensiun <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Guruhuât nata' snan'anjt. Nadurê't têma <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Ga 'ngo sa gahui' a'nan' ngà na'nïnt nuguan'an <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Nuguan' huaj guendâ <span data-l10n-name="addon-name">{ $addon-name }</span> nu gan'an dadin' ngà hua a'ngô nuguan' nukui' riñanj.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Ga'ue, Guxun man
abuse-report-messagebar-action-keep-extension = Si ga'ue, Ruhuâj na'nïnj sa'àj man
abuse-report-messagebar-action-remove-theme = Ga'ue, Guxun man
abuse-report-messagebar-action-keep-theme = Si ga'ue, Ruhuâj na'nïnj sa'àj man
abuse-report-messagebar-action-retry = A'ngô ñûn
abuse-report-messagebar-action-cancel = Duyichin'

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Dure’ej si aga’á asi ganatsi nej sa màn ‘iá
abuse-report-damage-example = Dàj rû': yi'ì atûj asi nuguan' huan'anj ni'ia

abuse-report-spam-reason-v2 = Nīka spam asi duguachinj sa nitāj sa aran’ ruhuô’ ni’io’
abuse-report-spam-example = Dàj rû': A'nïn nuguan' nitaj si ruhuô' ni'io' riña pajina

abuse-report-settings-reason-v2 = Nitāj si nachin' nan'an nī nadunaj sa riña nana'uí nuguan'an, pajinâ ayi'ìj asi rakïj ñanj nakàa.
abuse-report-settings-suggestions = Asij achin gutà't gakïn' rayi'î ekstensiûn ni naduna sinïn si configurasiûnt:
abuse-report-settings-suggestions-search = Naduna sa hua riña sa nana'nuî't 'na' niñaa
abuse-report-settings-suggestions-homepage = Naduna si pajinât riña ayi'ìt ni rakïj ñanj nakàa

abuse-report-deceptive-reason-v2 = Gahuin 'ngō sa sêj huin ruhuaj
abuse-report-deceptive-example = Dàj rû': Nuguan' asi ñadu'ua diga'ñun'unj un

abuse-report-broken-reason-extension-v2 = Nitāj si 'iaj sunj, dure'ej nej sîtio, asi nagi'iaj nna { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Nitāj si 'iaj sunj asi dure'ej riña sa nana'uî' nuguan'an
abuse-report-broken-example = Dàj rû': 'Iaj sun nnaj nej sa nika, chì' gi'iaj sun' ngàj asi nu ni'ñan; na'ue na'nïn da'àj sa ruhuô' ni'io' asi ninïn huaj
abuse-report-broken-suggestions-extension = Rû' huaj si nari't 'ngo sa hua a'nan'an. Dunâj 'ngo nuguan' hiuj nan, ni ga'nïnj a'ngoj gan'anj riña nej duguî' girirà ekstensiûn nan da' nagi'iaj si man. <a data-l10n-name="support-link">Gatu ni'iajt si pajinâ ekstensiûn</a> da' narì't doj nuguan'an rayi'ij.
abuse-report-broken-suggestions-theme = Rû' huaj si narî't 'ngo sa hua a'nan'an. Dunâj 'ngo nuguan' hiuj nan ni ga'nïnjt 'ngo gan'anj riña duguî' girirà tema nan. <a data-l10n-name="support-link">Gatu ni'iaj riña si pajinâ têma</a> da' gini'înt doj dàj hua rayi'ij.

abuse-report-policy-reason-v2 = Nīka sa nitāj si ruhuô ni'io', sa kïj ï asi sa ahīi
abuse-report-policy-suggestions = Nuguan'an: Nej sa hua rayi'î diguî riràa ni sa 'iaj registrandô' da'ui ngè ga ninïnj. <a data-l10n-name="report-infringement-link">Garasun nej nuguan nan</a> da' natà't sa hua rayi'ij.

abuse-report-unwanted-reason-v2 = Nu garan’ ruhuâj ni’ín man nī nu ni’ín dàj gi’iâ guxùnj man
abuse-report-unwanted-example = Dà rû': Ga'nïn 'ngo App nu garayinâj ga'nïn

abuse-report-other-reason = Doj sa huaa

