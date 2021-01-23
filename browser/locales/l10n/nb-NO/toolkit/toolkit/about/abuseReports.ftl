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

abuse-report-title-extension = Rapporter denne utvidelsen til { -vendor-short-name }
abuse-report-title-theme = Rapporter dette temaet til { -vendor-short-name }
abuse-report-subtitle = Hva er problemet?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = av <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Er du usikker på hvilket problem du skal velge?
    <a data-l10n-name="learnmore-link">Les mer om rapportering av utvidelser og temaer</a>

abuse-report-submit-description = Beskriv problemet (valgfritt)
abuse-report-textarea =
    .placeholder = Det er lettere for oss å løse et problem hvis vi har detaljer. Beskriv hva du opplever. Takk for at du hjelper oss med å gjøre nettet til et bedre sted.
abuse-report-submit-note =
    Merkand: Ta ikke med personlig informasjon (som navn, e-postadresse, telefonnummer eller postadresse).
    { -vendor-short-name } beholder en permanent arkivering av disse rapportene.

## Panel buttons.

abuse-report-cancel-button = Avbryt
abuse-report-next-button = Neste
abuse-report-goback-button = Gå tilbake
abuse-report-submit-button = Send

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Rapport for <span data-l10n-name="addon-name">{ $addon-name }</span> ble anullert.
abuse-report-messagebar-submitting = Sender rapport for <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Takk for at du sendte inn en rapport. Vil du fjerne <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Takk for at du sendte inn en rapport.
abuse-report-messagebar-removed-extension = Takk for at du sendte inn en rapport. Du har fjernet utvidelsen <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Takk for at du sendte inn en rapport. Du har fjernet temaet <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Det oppsto en feil ved sending av rapporten for <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Rapporten for <span data-l10n-name="addon-name">{ $addon-name }</span> ble ikke sendt fordi en annen rapport ble sendt inn nylig.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Ja, fjern den
abuse-report-messagebar-action-keep-extension = Nei, jeg vil beholde den
abuse-report-messagebar-action-remove-theme = Ja, fjern den
abuse-report-messagebar-action-keep-theme = Nei, jeg vil beholde den
abuse-report-messagebar-action-retry = Prøv igjen
abuse-report-messagebar-action-cancel = Avbryt

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Det skadet datamaskinen min eller kompromitterte mine data
abuse-report-damage-example = Eksempel: Injiserte skadelig kode eller stjal data

abuse-report-spam-reason-v2 = Den inneholder spam eller legger inn uønsket annonsering
abuse-report-spam-example = Eksempel: Setter inn reklamer på nettsider

abuse-report-settings-reason-v2 = Den endret min søkmotor, startside eller ny fane uten å informere eller spørre meg
abuse-report-settings-suggestions = Før du rapporterer utvidelsen, kan du prøve å endre dine innstillinger:
abuse-report-settings-suggestions-search = Endre dine standardinnstillinger for søkemotor
abuse-report-settings-suggestions-homepage = Endre startside og ny fane-siden

abuse-report-deceptive-reason-v2 = Den gir seg ut for å være noe den ikke er
abuse-report-deceptive-example = Eksempel: Villedende beskrivelse eller bilder

abuse-report-broken-reason-extension-v2 = Den fungerer ikke, ødelegger nettsteder, eller gjør { -brand-product-name } treg
abuse-report-broken-reason-theme-v2 = Den virker ikke eller ødelegger nettsidens utseende
abuse-report-broken-example = For eksempel: Funksjoner er trege, vanskelig å bruke, eller fungerer ikke; deler av nettsteder vil ikke laste eller ser uvanlige ut
abuse-report-broken-suggestions-extension =
    Det høres ut som om du har identifisert en feil. I tillegg til å sende inn en rapport her, så er den beste måten
    for å få en funksjonell feil løst på er å kontakte utvidelsesutvikleren.
    <a data-l10n-name="support-link">Besøk utvidelsens nettsted</a> for å få informasjon om utvikleren.
abuse-report-broken-suggestions-theme =
    Det høres ut som om du har identifisert en feil. I tillegg til å sende inn en rapport her, så er den beste måten
    for å få en funksjonell feil løst på er å kontakte temautvikleren.
    <a data-l10n-name="support-link">Besøk temaets nettsted</a> for å få informasjon om utvikleren.

abuse-report-policy-reason-v2 = Den inneholder hatefullt, voldelig eller ulovlig innhold
abuse-report-policy-suggestions =
    Merknad: Opphavsrett- og varemerkerproblemer rapporteres på en annen måte.
    <a data-l10n-name="report-infringement-link">Bruk disse instruksjonene</a> for å
    rapportere problemet.

abuse-report-unwanted-reason-v2 = Jeg har aldri ønsket den og jeg vet ikke hvordan jeg kan bli kvitt den
abuse-report-unwanted-example = Eksempel: Et program installerte den uten min tillatelse

abuse-report-other-reason = Noe annet

