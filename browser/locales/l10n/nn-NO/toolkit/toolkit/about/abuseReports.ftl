# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Rapport for { $addon-name }

abuse-report-title-extension = Rapporter denne utvidinga til { -vendor-short-name }
abuse-report-title-theme = Rapporter dette temaet til { -vendor-short-name }
abuse-report-subtitle = Kva er problemet?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = av <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Er du usikker på kva for problem du skal velje?
    <a data-l10n-name="learnmore-link">Les meir om rapportering av utvidingar og tema</a>

abuse-report-submit-description = Beskriv problemet (valfritt)
abuse-report-textarea =
    .placeholder = Det er lettare for oss å løyse eit problem viss vi har detaljar. Beskriv kva du opplever. Takk for at du hjelper oss med å gjere nettet til ein betre stad.
abuse-report-submit-note =
    Merkand: Ta ikkje med personleg informasjon (som namn, e-postadresse, telefonnummer eller postadresse).
    { -vendor-short-name } beheld ei permanent arkivering av desse rapportane.

## Panel buttons.

abuse-report-cancel-button = Avbryt
abuse-report-next-button = Neste
abuse-report-goback-button = Gå tilbake
abuse-report-submit-button = Send inn

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Rapport for <span data-l10n-name="addon-name">{ $addon-name }</span> vart anullert.
abuse-report-messagebar-submitting = Sender rapport for <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Takk for at du sende inn ein rapport. Vil du fjerne <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Takk for at du sende inn ein rapport.
abuse-report-messagebar-removed-extension = Takk for at du sende inn ein rapport. Du har fjerna utvidinga <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Takk for at du sende inn ein rapport. Du har fjerna temaet <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Det oppsto ein feil ved sending av rapporten for <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Rapporten for <span data-l10n-name="addon-name">{ $addon-name }</span> vart ikkje sendt fordi ein annan rapport nettopp vart sendt inn.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Ja, fjern han
abuse-report-messagebar-action-keep-extension = Nei, eg vil behalde han
abuse-report-messagebar-action-remove-theme = Ja, fjern han
abuse-report-messagebar-action-keep-theme = Nei, eg vil behalde han
abuse-report-messagebar-action-retry = Prøv ein gong til
abuse-report-messagebar-action-cancel = Avbryt

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Det skada datamaskina mi eller kompromitterte dattaa mine.
abuse-report-damage-example = Døme: Injiserte skadeleg kode eller stal data

abuse-report-spam-reason-v2 = Den inneheld spam eller legg inn uønskt annonsering
abuse-report-spam-example = Døme: Set inn reklame på nettsider

abuse-report-settings-reason-v2 = Den endra søkjemotoren min, startside eller ny fane utan å informere eller spørje meg
abuse-report-settings-suggestions = Før du rapporterer utvidinga, kan du prøve å endre innstillingane dine:
abuse-report-settings-suggestions-search = Endre standardinnstillingane dine for søking
abuse-report-settings-suggestions-homepage = Endre startside og ny fane-sida

abuse-report-deceptive-reason-v2 = Den gir seg ut for å vere noko den ikkje er
abuse-report-deceptive-example = Døme: villeiande skildring eller bilde

abuse-report-broken-reason-extension-v2 = Den fungerer ikk je, øydelegg nettstadar, eller gjer { -brand-product-name } treg
abuse-report-broken-reason-theme-v2 = Den verkar ikkje eller øydelegg utsjånaden til nettsidene
abuse-report-broken-example = Til dømes: Funksjonar er trege, vanskeleg å bruke, eller fungerar ikkje; delar av nettstadar vil ikkje laste eller ser uvanlege ut
abuse-report-broken-suggestions-extension =
    Det høyrest ut som om du har identifisert ein feil. I tillegg til å sende inn ein rapport her, så er den beste måten å få retta funksjonell feil på å kontakte utvidingsutviklaren.
    <a data-l10n-name="support-link">Besøk nettstaden til utvidinga</a> for å få informasjon om utviklaren.
abuse-report-broken-suggestions-theme =
    Det høyrest ut som om du har identifisert ein feil. I tillegg til å sende inn en rapport her, så er den beste måten
    å få retta funksjonelle feil på å kontakte temautviklaren.
    <a data-l10n-name="support-link">Besøk nettstaden til temaet</a> for å få informasjon om utviklaren.

abuse-report-policy-reason-v2 = Den inneheld hatefullt, valdeleg eller ulovleg innhald
abuse-report-policy-suggestions =
    Merknad: Opphavsrett- og varemerkerproblem vert rapporterte på ein annan måte.
    <a data-l10n-name="report-infringement-link">Bruk desse instruksjonane</a> for å
    rapportere problemet.

abuse-report-unwanted-reason-v2 = Eg har aldri ønskt den og eg veit ikkje korleis eg kan bli kvitt den
abuse-report-unwanted-example = Døme: Eit program installerte den utan løyve frå meg

abuse-report-other-reason = Noko anna

