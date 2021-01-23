# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Rapport foar { $addon-name }

abuse-report-title-extension = Dizze tafoeging rapportearje oan { -vendor-short-name }
abuse-report-title-theme = Dit tema rapportearje oan { -vendor-short-name }
abuse-report-subtitle = Wat is it probleem?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = troch <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Binne jo net wis hokker probleem jo selektearje moatte?
    <a data-l10n-name="learnmore-link">Mear ynfo oer it rapportearjen fan útwreidingen en tema’s</a>

abuse-report-submit-description = Beskriuw it probleem (opsjoneel)
abuse-report-textarea =
    .placeholder = It is makliker foar ús om in probleem te behanneljen as wy details hawwe. Beskriuw it probleem dat jo hawwe. Tank foar jo help by it sûn hâlden fan it web.
abuse-report-submit-note =
    Noat: foegje gjin persoanlike gegevens (lykas namme, e-mailadres, telefoannûmer of fysyk adres) ta.
    { -vendor-short-name } bewarret dizze rapporten permanint.

## Panel buttons.

abuse-report-cancel-button = Annulearje
abuse-report-next-button = Folgjende
abuse-report-goback-button = Tebek
abuse-report-submit-button = Yntsjinje

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Rapport foar <span data-l10n-name="addon-name">{ $addon-name }</span> annulearre.
abuse-report-messagebar-submitting = Rapport ferstjoere foar <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Tank foar it yntsjinjen fan in rapport. Wolle jo <span data-l10n-name="addon-name">{ $addon-name }</span> fuortsmite?
abuse-report-messagebar-submitted-noremove = Tank foar it yntsjinjen fan in rapport.
abuse-report-messagebar-removed-extension = Tank foar it yntsjinjen fan in rapport. Jo hawwe de útwreiding <span data-l10n-name="addon-name">{ $addon-name }</span> fuortsmiten.
abuse-report-messagebar-removed-theme = Tank foar it yntsjinjen fan in rapport. Jo hawwe it tema <span data-l10n-name="addon-name">{ $addon-name }</span> fuortsmiten.
abuse-report-messagebar-error = Der is in flater bard by it ferstjoeren fan in rapport foar <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = It rapport foar <span data-l10n-name="addon-name">{ $addon-name }</span> is net ferstjoerd, omdat jo resint in oar rapport ferstjoerd hawwe.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Ja, fuortsmite
abuse-report-messagebar-action-keep-extension = Nee, bewarje
abuse-report-messagebar-action-remove-theme = Ja, fuortsmite
abuse-report-messagebar-action-keep-theme = Nee, bewarje
abuse-report-messagebar-action-retry = Opnij probearje
abuse-report-messagebar-action-cancel = Annulearje

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = It hat myn kompjûter skansearre of myn gegevens kompromittearre
abuse-report-damage-example = Foarbyld: hat malware ynjektearre of gegevens stellen

abuse-report-spam-reason-v2 = It befettet spam of foeget net winske advertinsjes ta
abuse-report-spam-example = Foarbyld: foeget advertinsjes ta oan websiden

abuse-report-settings-reason-v2 = It hat sûnder dit te melden of te freegjen myn sykmasine, startside of nije ljepblêd wizige
abuse-report-settings-suggestions = Eardat jo de útwreiding meldt, kinne jo probearje jo ynstellingen te wizigjen:
abuse-report-settings-suggestions-search = Jo standert sykynstellingen wizigje
abuse-report-settings-suggestions-homepage = Jo startside en nij ljepblêd wizigje

abuse-report-deceptive-reason-v2 = It docht him foar as wat oars
abuse-report-deceptive-example = Foarbyld: misliedende beskriuwing of ôfbyldingen

abuse-report-broken-reason-extension-v2 = It wurket net, soarget derfoar dat websites net wurkje of fertraget { -brand-product-name }
abuse-report-broken-reason-theme-v2 = It wurket net of soarget derfoar dat de browserwerjefte net wurket
abuse-report-broken-example = Foarbyld: funksjes binne stadich, swier te brûken of wurkje net; dielen fan websites lade net of sjogge der ûngebrûklik út
abuse-report-broken-suggestions-extension = It liket as oft jo in bug fûn hawwe. Yn oanfolling op dizze melding kinne jo it bêste kontakt opnimme mei de ûntwikkeler fan de útwreiding. <a data-l10n-name="support-link">Besykje de startside fan de útwreiding</a> foar ynformaasje oer de ûntwikkeler.
abuse-report-broken-suggestions-theme =
    It klinkt as oft jo in bug fûn hawwe. Neist it hjir yntsjinjen fan in rapport, is de bêste manier
    om in funksjoneel probleem op te lossen, kontakt op te nimmen mei de ûntwikkeler fan it tema.
    <a data-l10n-name="support-link">Besykje de website fan it tema</a> foar ynformaasje oer de ûntwikkeler.

abuse-report-policy-reason-v2 = It befettet haatdragende, gewelddiedige of yllegale ynhâld
abuse-report-policy-suggestions =
    Opmerking: problemen mei auteursrjochten en hannelsmerken moatte yn in ôfsûnderlik proses melden wurde.
    <a data-l10n-name="report-infringement-link">Folgje dizze ynstruksjes</a> om it probleem te melden.

abuse-report-unwanted-reason-v2 = Ik haw it nea wold en wit net hoe't ik der fan ôf komme moat
abuse-report-unwanted-example = Foarbyld: in tapassing hat dizze sûnder myn tastimming ynstallearre

abuse-report-other-reason = Wat oars

