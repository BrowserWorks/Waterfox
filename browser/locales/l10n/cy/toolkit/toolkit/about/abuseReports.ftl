# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Adrodd am { $addon-name }

abuse-report-title-extension = Adroddwch yr Estyniad hwn i { -vendor-short-name }
abuse-report-title-theme = Adroddwch y Thema hon i { -vendor-short-name }
abuse-report-subtitle = Beth yw'r broblem?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = gan <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Ddim yn siŵr pa fater i'w ddewis?
    <a data-l10n-name="learnmore-link">Dysgwch fwy am adrodd ar estyniadau a themâu</a>

abuse-report-submit-description = Disgrifiwch y broblem (dewisol)
abuse-report-textarea =
    .placeholder = Mae'n haws i ni fynd i'r afael â phroblem os oes gennym fanylion penodol. Disgrifiwch yr hyn rydych chi'n ei brofi. Diolch i chi am ein helpu i gadw'r we'n iach.
abuse-report-submit-note =
    Sylwer: Peidiwch â chynnwys gwybodaeth bersonol (fel enw, cyfeiriad e-bost, rhif ffôn, cyfeiriad corfforol).
    Mae { -vendor-short-name } yn cadw cofnod parhaol o'r adroddiadau hyn.

## Panel buttons.

abuse-report-cancel-button = Diddymu
abuse-report-next-button = Nesaf
abuse-report-goback-button = Mynd nôl
abuse-report-submit-button = Cyflwyno

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Diddymwyd yr adroddiad ar gyfer <span data-l10n-name="addon-name">{ $addon-name }</span>>.
abuse-report-messagebar-submitting = Anfon adroddiad ar gyfer <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Diolch i chi am gyflwyno adroddiad. Ydych chi am gael gwared ar <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Diolch am gyflwyno adroddiad.
abuse-report-messagebar-removed-extension = Diolch i chi am gyflwyno adroddiad. Rydych wedi tynnu'r estyniad <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Diolch i chi am gyflwyno adroddiad. Rydych chi wedi tynnu'r thema <span data-l10n-name="addon-name">{ $addon-name }</span>
abuse-report-messagebar-error = Roedd gwall wrth anfon yr adroddiad ar gyfer <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Nid yw'r adroddiad ar gyfer <span data-l10n-name="addon-name">{ $addon-name }</span> wedi ei anfon oherwydd bod adroddiad arall wedi'i gyflwyno'n ddiweddar.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Iawn, Dileu
abuse-report-messagebar-action-keep-extension = Na, rwyf am ei gadw
abuse-report-messagebar-action-remove-theme = Iawn, Dileu
abuse-report-messagebar-action-keep-theme = Na, rwyf am ei gadw
abuse-report-messagebar-action-retry = Ceisio eto
abuse-report-messagebar-action-cancel = Diddymu

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Fe wnaeth niweidio fy nghyfrifiadur neu gyfaddawdu ar fy nata
abuse-report-damage-example = Enghraifft: Chwistrellu data maleisus neu ddata wedi'i ddwyn

abuse-report-spam-reason-v2 = Mae'n cynnwys sbam neu'n mewnosod hysbysebu dieisiau
abuse-report-spam-example = Enghraifft: Mewnosod hysbysebion ar dudalennau gwe

abuse-report-settings-reason-v2 = Newidiodd fy mheiriant chwilio, hafan, neu dab newydd heb roi gwybod na gofyn imi
abuse-report-settings-suggestions = Cyn adrodd ar yr estyniad, gallwch roi cynnig ar newid eich gosodiadau:
abuse-report-settings-suggestions-search = Newid eich gosodiadau chwilio rhagosodedig
abuse-report-settings-suggestions-homepage = Newidiwch eich tudalen gartref a'ch tab newydd

abuse-report-deceptive-reason-v2 = Mae'n honni ei fod yn rhywbeth nad ydyw
abuse-report-deceptive-example = Enghraifft: Disgrifiad neu ddelweddau camarweiniol

abuse-report-broken-reason-extension-v2 = Nid yw'n gweithio, mae'n torri gwefannau, neu'n arafu { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Nid yw'n gweithio nac yn torri dangosydd y porwr
abuse-report-broken-example = Enghraifft: Mae nodwedd yn araf, yn anodd ei defnyddio, neu ddim yn gweithio; ni fydd rhannau o wefannau yn llwytho neu'n edrych yn rhyfedd
abuse-report-broken-suggestions-extension =
    Mae'n edrych fel eich bod wedi adnabod gwall. Yn ogystal â chyflwyno adroddiad yma, y ffordd orau
    orau i ddatrys mater ymarferoldeb wedi'i ddatrys yw cysylltu â datblygwr yr estyniad.
    <a data-l10n-name="support-link">Ewch i wefan yr estyniad</a> i gael gwybodaeth gan y datblygwr.
abuse-report-broken-suggestions-theme =
    Mae'n edrych fel eich bod wedi adnabod gwall. Yn ogystal â chyflwyno adroddiad yma, y ffordd orau
    orau i ddatrys mater ymarferoldeb wedi'i ddatrys yw cysylltu â datblygwr y thema.
    <a data-l10n-name="support-link"> Ewch i wefan y thema </a> i gael gwybodaeth y datblygwr.

abuse-report-policy-reason-v2 = Mae'n cynnwys cynnwys atgas, treisgar neu anghyfreithlon
abuse-report-policy-suggestions =
    Sylw: Rhaid rhoi gwybod am faterion hawlfraint a nod masnach mewn proses ar wahân.
    <a data-l10n-name="report-infringement-link"> Defnyddiwch y cyfarwyddiadau hyn</a> i
    adrodd am y broblem.

abuse-report-unwanted-reason-v2 = Doeddwn i erioed ei eisiau ac nid wyf yn gwybod sut i gael gwared arno
abuse-report-unwanted-example = Enghraifft: Gosodwyd y rhaglen heb fy nghaniatâd

abuse-report-other-reason = Rhywbeth arall

