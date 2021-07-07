# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Rapport for { $addon-name }

abuse-report-title-extension = Rapporter denne udvidelse til { -vendor-short-name }
abuse-report-title-theme = Rapporter dette tema til { -vendor-short-name }
abuse-report-subtitle = Hvad er problemet?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = af <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
  Usikker på, hvad du skal vælge?
  <a data-l10n-name="learnmore-link">Læs mere om at rapportere udvidelser og temaer</a>

abuse-report-submit-description = Beskriv problemet (valgfrit)
abuse-report-textarea =
  .placeholder = Det er nemmere for os at løse et problem, hvis vi kender detaljerne. Så beskriv præcis, hvad du oplever. Tak for at du hjælper os med at gøre nettet til et bedre sted.
abuse-report-submit-note =
  Bemærk: Inkluder ikke personlig information (som navn, mailadresse, telefonnummer eller postadresse).
  { -vendor-short-name } arkiverer disse rapporter uden frist for sletning.

## Panel buttons.

abuse-report-cancel-button = Annuller
abuse-report-next-button = Næste
abuse-report-goback-button = Gå tilbage
abuse-report-submit-button = Send

## Message bars descriptions.

## Variables:
##   $addon-name (string) - Name of the add-on

## Message bars descriptions.
##
## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Rapport for <span data-l10n-name="addon-name">{ $addon-name }</span> blev annulleret.
abuse-report-messagebar-submitting = Sender rapport for <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Tak for at du indsendte rapporten. Vil du fjerne <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Tak for at du indsendte rapporten.
abuse-report-messagebar-removed-extension = Tak for at du indsendte rapporten. Du har fjernet udvidelsen <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Tak for at du indsendte rapporten. Du har fjernet temaet <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Der opstod et problem med at sende rapporten for <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Rapporten for <span data-l10n-name="addon-name">{ $addon-name }</span> blev ikke sendt, fordi en anden rapport blev sendt for nylig.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Ja, fjern den
abuse-report-messagebar-action-keep-extension = Nej, jeg beholder den
abuse-report-messagebar-action-remove-theme = Ja, fjern det.
abuse-report-messagebar-action-keep-theme = Nej, jeg beholder det
abuse-report-messagebar-action-retry = Prøv igen
abuse-report-messagebar-action-cancel = Fortryd

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Skadede min computer eller kompromitterede mine data
abuse-report-damage-example = Eksempel: Medførte malware eller stjal data

abuse-report-spam-reason-v2 = Indeholder spam eller indsætter uønskede reklamer
abuse-report-spam-example = Eksempel: Indsætter reklamer på websider

abuse-report-settings-reason-v2 = Ændrede min søgetjeneste, startside eller siden nyt faneblad ude at informere eller spørge mig først.
abuse-report-settings-suggestions = Før du rapporterer udvidelsen, kan du prøve at ændre dine indstillinger:
abuse-report-settings-suggestions-search = Skift dine standard-indstillinger for søgning
abuse-report-settings-suggestions-homepage = Skift din startside og siden nyt faneblad

abuse-report-deceptive-reason-v2 = Den hævder at være noget, den ikke er
abuse-report-deceptive-example = Eksempel: Vildledende beskrivelse eller billeder

abuse-report-broken-reason-extension-v2 = Virker ikke, forhindrer websteder i at fungere eller gør { -brand-product-name } langsom
abuse-report-broken-reason-theme-v2 = Virker ikke eller forhindrer websteder i at blive vist korrekt
abuse-report-broken-example =
  Eksempel: Funktioner er langsomme, svære at bruge eller virker slet ikke; dele af websider indlæses ikke eller ser udsædvanlige ud
abuse-report-broken-suggestions-extension =
  Det lyder til, at du er stødt på en fejl. Udover at rapportere fejlen hér, så er den bedste
  måde at få rettet funktionelle fejl på at kontakte udvikleren bag udvidelsen.
  <a data-l10n-name="support-link">Besøg udvidelsens websted</a> for at få information om udvikleren.
abuse-report-broken-suggestions-theme =
  Det lyder til, at du er stødt på en fejl. Udover at rapportere fejlen hér, så er den bedste
  måde at få rettet funktionelle fejl på at kontakte udvikleren bag temaet.
  <a data-l10n-name="support-link">Besøg temaets websted</a> for at få information om udvikleren.

abuse-report-policy-reason-v2 = Indeholder hadsk, voldeligt eller ulovligt indhold
abuse-report-policy-suggestions =
  Bemærk: Overtrædelser af ophavsrettigheder og varemærker rapporteres på en anden måde.
  <a data-l10n-name="report-infringement-link">Følg disse instruktioner</a> for at
  rapportere problemet.

abuse-report-unwanted-reason-v2 = Jeg ville ikke have udvidelsen og ved ikke, hvordan jeg skal slippe af med den igen
abuse-report-unwanted-example = Eksempel: Et program installerede den uden min tilladelse

abuse-report-other-reason = Andet

