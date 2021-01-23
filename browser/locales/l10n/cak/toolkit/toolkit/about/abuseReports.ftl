# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title.
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Tiya' rutzijol richin { $addon-name }

abuse-report-title-extension = Tiya' Rutzijol Re K'amal Re' pa { -vendor-short-name }
abuse-report-title-theme = Tiya' Rutzijol Re Wachinel Re' pa { -vendor-short-name }
abuse-report-subtitle = ¿Achike ri k'ayewal?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = ruma <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    ¿La man at jikïl ta achike k'ayewal nacha'?
    <a data-l10n-name="learnmore-link">Tawetamaj ch'aqa' chik etamab'äl chi rij kitzijol taq k'amal chuqa' taq wachinel</a>

abuse-report-submit-description = Tacholo' ri k'ayewal (cha'el)
abuse-report-textarea =
    .placeholder = Man k'ayew ta nub'än chi qawäch jun k'ayewal we k'o jikïl taq rub'anikil chi qawäch. Tab'ana' utzil, tatzijoj achike xak'ulwachij. Matyox ruma yojato' chi niqab'än raxinäq chi re ri k'amab'ey.
abuse-report-submit-note =
    Ch'utitzijol: Man tatz'ib'aj awetamab'al (achi'el ab'i', rochochib'al ataqoya'l, rajilab'al awoyonib'al, awochochib'al).
    { -vendor-short-name } tik'oje' jun junelïk rutz'ib'axik re rutzijol re'.

## Panel buttons.

abuse-report-cancel-button = Tiq'at
abuse-report-next-button = Jun chik
abuse-report-goback-button = Titzolin
abuse-report-submit-button = Titaq

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Xq'at ri rutzijol <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitting = Nitaq ri rutzijol richin <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Matyox ruma xatäq ri rutzijol. ¿La nawajo' nayüj el <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Matyox ruma xatäq ri rutzijol.
abuse-report-messagebar-removed-extension = Matyox ruma natäq re rutzijol. Xayüj ri k'amal <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Matyox ruma natäq ri rutzijol. Xayüj ri wachinel <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Xk'ulwachitäj jun sachoj toq nitaq ri rutzijol pa ruwi' <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Man xtaq ta ri rutzijol pa ruwi' <span data-l10n-name="addon-name">{ $addon-name }</span> ruma taqon chik jun rutzijol.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Ja', Tiyuj
abuse-report-messagebar-action-keep-extension = Manäq. Xa Xtinyäk
abuse-report-messagebar-action-remove-theme = Ja', Tiyuj
abuse-report-messagebar-action-keep-theme = Manäq. Xa Xtinyäk
abuse-report-messagebar-action-retry = Titojtob'ëx chik
abuse-report-messagebar-action-cancel = Tiq'at

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Xutz'ila' nukematz'ib' o ri taq nutzij xek'utub'ëx
abuse-report-damage-example = Achi'el: Nujäq malwar o nreleq'aj tzij

abuse-report-spam-reason-v2 = Ruk'wan seq' tzijol o nuyäk eltzijol, ri man k'utun ta
abuse-report-spam-example = Achi'el: Yeruju' taq eltzijol pa ajk'amaya'l ruxaq

abuse-report-settings-reason-v2 = Xjal ri wokik'amaya'l, tikirib'äl ruxaq o k'ak'a' ruwi', akuchi' man xya' ta rutzijol chwe ni xa ta xk'utüx pe chwe
abuse-report-settings-suggestions = Chuwäch niya' rutzijol ri k'amal, tatojtob'ej najäl ri runuk'ulem:
abuse-report-settings-suggestions-search = Tajala' runuk'ulem okik'amaya'l k'o wi
abuse-report-settings-suggestions-homepage = Tajala' ri tikirib'äl ruxaq chuqa' ri k'ak'a' ruwi'

abuse-report-deceptive-reason-v2 = Nuna' ri' achi'el ri man ja ta rija'
abuse-report-deceptive-example = Achi'el: Q'olonel o achik'anel rutzijoxik

abuse-report-broken-reason-extension-v2 = Man nisamäj ta, yeruyüj ri ajk'amaya'l ruxaq o eqal nub'än chi re { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Man nisamäj ta o nuyüj ri nuk'üt ri okik'amaya'l
abuse-report-broken-example = Achi'el: Eqal nisamäj, k'ayew ye'okisäx o man yesamäj ta; peraj chi ke ri taq ajk'amaya'l ruxaq man yesamäj ta o man relik ta kib'anikil.
abuse-report-broken-suggestions-extension =
    Achi'exa xaya' retal jun k'ayewal. Rik'in natäq jun rutzijol wawe', richin nisol jun k'ayewal
    chi rij rub'eyal nisamäj ja ri yatzijon rik'in ri rub'anonel k'amal.
    <a data-l10n-name="support-link">Tab'etz'eta' ri ajk'amaya'l ruxaq k'amal</a> richin ye'ak'ül ri taq tzij richin yatzijon rik'in ri b'anonel.
abuse-report-broken-suggestions-theme =
    Achi'exa xaya' retal jun k'ayewal. Rik'in natäq jun rutzijol wawe', richin nisol jun k'ayewal
    chi rij rub'eyal nisamäj ja ri yatzijon rik'in ri rub'anonel wachinel.
    <a data-l10n-name="support-link">Tab'etz'eta' ri ajk'amaya'l ruxaq wachinel</a> richin ye'ak'ül ri taq tzij richin yatzijon rik'in ri b'anonel.

abuse-report-policy-reason-v2 = Nuk'üt oyowal, itzel uchuq'a' o man ütz ta etamab'äl
abuse-report-policy-suggestions =
    Ch'utitzijol: Ri k'ayewal pa ruwi' ruch'ojib'al b'anel chuqa' tz'ib'an kib'i' etal k'o chi niya' kitzijol pa jachon b'anoj.
    <a data-l10n-name="report-infringement-link">Ke'awokisaj re taq rutzijol b'eyal re'</a>
    richin naya' rutzijol ri k'ayewal.

abuse-report-unwanted-reason-v2 = Majub'ey xinwajo' chuqa' man wetaman ta achike rub'eyal ninwelesaj el
abuse-report-unwanted-example = Achi'el: Jun chokoy xyak, akuchi' man xinya' ta q'ij

abuse-report-other-reason = Jun chik wachinäq

