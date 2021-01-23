# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Rozprawa za { $addon-name }

abuse-report-title-extension = { -vendor-short-name } tute rozšěrjenje zdźělić
abuse-report-title-theme = { -vendor-short-name } tutu drastu zdźělić
abuse-report-subtitle = Kotry je problem?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = wot <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Sće sej njewěsty, kotry problem maće wubrać?
    <a data-l10n-name="learnmore-link">Zhońće wjace wo zdźělenju rozšěrjenjow a drastow</a>

abuse-report-submit-description = Wopisajće problem (na přeće)
abuse-report-textarea =
    .placeholder = Je lóšo za nas, so problemej wěnować, hdyž podrobnosće mamy. Prošu wopisajće, na což sće storčił. Dźakujemy so wam, zo nam pomhaće, web strowy wobchować.
abuse-report-submit-note =
    Kedźbu: Njezapřijimajće prošu wosobinske informacije (na přikład mjeno, e-mejlowu adresu, telefonowe čisło, bydlensku adresu).
    { -vendor-short-name } trajnu kopiju tutych rozprawow wobchowuje.

## Panel buttons.

abuse-report-cancel-button = Přetorhnyć
abuse-report-next-button = Dale
abuse-report-goback-button = Wróćo hić
abuse-report-submit-button = Wotpósłać

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Zdźělenje za <span data-l10n-name="addon-name">{ $addon-name }</span> je so přetorhnyło.
abuse-report-messagebar-submitting = Zdźělenka za <span data-l10n-name="addon-name">{ $addon-name }</span> so sćele.
abuse-report-messagebar-submitted = Dźakujemy so, zo sće zdźělenku pósłał. Chceće <span data-l10n-name="addon-name">{ $addon-name }</span> wotstronić?
abuse-report-messagebar-submitted-noremove = Dźakujemy so, zo sće zdźělenku pósłał.
abuse-report-messagebar-removed-extension = Dźakujemy so, zo sće zdźělenku pósłał. Sće rozšěrjenje <span data-l10n-name="addon-name">{ $addon-name }</span> wotstronił.
abuse-report-messagebar-removed-theme = Dźakujemy so, zo sće zdźělenku pósłał. Sće drastu <span data-l10n-name="addon-name">{ $addon-name }</span> wotstronił.
abuse-report-messagebar-error = Zmylk při słanju rozprawy za <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Rozprawa za <span data-l10n-name="addon-name">{ $addon-name }</span> njeje so pósłała, dokelž je so druha rozprawa njedawno wotpósłała.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Haj, wotstronić
abuse-report-messagebar-action-keep-extension = Ně, wobchować
abuse-report-messagebar-action-remove-theme = Haj, wotstronić
abuse-report-messagebar-action-keep-theme = Ně, wobchować
abuse-report-messagebar-action-retry = Wospjetować
abuse-report-messagebar-action-cancel = Přetorhnyć

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Je mój ličak wobškodźił abo moje daty wohrozył
abuse-report-damage-example = Přikład: Zašćěpjena škódna softwara abo pokradnjene daty

abuse-report-spam-reason-v2 = Wobsahuje spam abo zasadźuje njewitane wabjenje
abuse-report-spam-example = Přikład: wabjenje na webstronach zasadźić

abuse-report-settings-reason-v2 = Je moju pytawu, startowu stronu abo nowy rajtark změniło, bjez toho zo by mje informowało abo so mje prašało
abuse-report-settings-suggestions = Prjedy hač rozšěrjenje zdźěliće, móžeće spytać, swoje nastajenja změnić:
abuse-report-settings-suggestions-search = Změńće swoje standardne pytanske nastajenja
abuse-report-settings-suggestions-homepage = Změńće swoju startowu stronu a nowy rajtark

abuse-report-deceptive-reason-v2 = Twjerdźi, zo to njeje
abuse-report-deceptive-example = Přikład: Zamylace wopisanje abo zamylaca wobraznosć

abuse-report-broken-reason-extension-v2 = Njefunguje, wobškodźa websydła abo spomala { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Njefunguje abo skóncuje zwobraznjenje wobhladowaka
abuse-report-broken-example = Přikład: Funkcije su pomałe, ćežko wužiwajomne abo njefunguja; dźěle websydła so njezačitaja abo wupadaja njezwučene
abuse-report-broken-suggestions-extension = Zda so, zo sće zmylk identifikował. Chibazo móžeće rozprawu wotpósłać, stajće so najlěpje z wuwiwarjom rozšěrjenja do zwiska, zo byšće problem z funkcionalnosću rozrisał. <a data-l10n-name="support-link">Wopytajće websydło rozšěrjenja</a>, zo byšće sej informacije wo wuwiwarju wobstarał.
abuse-report-broken-suggestions-theme = Zda so, zo sće zmylk identifikował. Chibazo móžeće rozprawu wotpósłać, stajće so najlěpje z wuwiwarjom drasty do zwiska, zo byšće problem z funkcionalnosću rozrisał. <a data-l10n-name="support-link">Wopytajće websydło drasty</a>, zo byšće sej informacije wo wuwiwarju wobstarał.

abuse-report-policy-reason-v2 = Wobsahuje hidypołny, namócny abo ilegalny wobsah
abuse-report-policy-suggestions = Kedźbu: Problemy z awtorstwom a wikowanskim znamjenjom dyrbja so na druhe wašnje zdźělić. <a data-l10n-name="report-infringement-link">Sćěhujće tute instrukcije</a>, zo byšće problem zdźělił.

abuse-report-unwanted-reason-v2 = Njejsym to ženje chył a njewěm, kak móžu to wotbyć
abuse-report-unwanted-example = Přikład: Nałoženje je jón bjez dowolnosće zainstalowało

abuse-report-other-reason = Něšto druhe

