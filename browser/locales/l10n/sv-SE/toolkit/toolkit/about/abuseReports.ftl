# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Rapportera för { $addon-name }

abuse-report-title-extension = Rapportera detta tillägg till { -vendor-short-name }
abuse-report-title-theme = Rapportera detta tema till { -vendor-short-name }
abuse-report-subtitle = Vad är problemet?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = av <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Är du osäker på vilket problem du vill välja?
    <a data-l10n-name="learnmore-link"><a data-l10n-name="learnmore-link">Läs mer om rapportering av tillägg och teman</a>

abuse-report-submit-description = Beskriv problemet (valfritt)
abuse-report-textarea =
    .placeholder = Det är lättare för oss att ta itu med ett problem om vi har detaljer. Beskriv vad du upplever. Tack för att du har hjälpt oss att hålla nätet hälsosamt.
abuse-report-submit-note =
    Obs! Ta inte med personlig information (t.ex. namn, e-postadress, telefonnummer, fysisk adress).
    { -vendor-short-name } håller en permanent registrering av dessa rapporter.

## Panel buttons.

abuse-report-cancel-button = Avbryt
abuse-report-next-button = Nästa
abuse-report-goback-button = Gå tillbaka
abuse-report-submit-button = Skicka in

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Rapport för <span data-l10n-name="addon-name">{ $addon-name }</span> avbruten.
abuse-report-messagebar-submitting = Skickar rapport för <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Tack för att du skickade in en rapport. Vill du ta bort <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Tack för att du skickade in en rapport.
abuse-report-messagebar-removed-extension = Tack för att du skickade in en rapport. Du har tagit bort tillägget <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Tack för att du skickade in en rapport. Du har tagit bort temat <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Det gick inte att skicka rapporten för <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Rapporten för <span data-l10n-name="addon-name">{ $addon-name }</span> skickades inte eftersom en annan rapport skickades nyligen.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Ja, ta bort det
abuse-report-messagebar-action-keep-extension = Nej, jag behåller det
abuse-report-messagebar-action-remove-theme = Ja, ta bort det
abuse-report-messagebar-action-keep-theme = Nej, jag behåller det
abuse-report-messagebar-action-retry = Försök igen
abuse-report-messagebar-action-cancel = Avbryt

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Den skadade min dator eller äventyrade mina data
abuse-report-damage-example = Exempel: Injicerad skadlig kod eller stulit data

abuse-report-spam-reason-v2 = Det innehåller spam eller infogar oönskad reklam
abuse-report-spam-example = Exempel: Infogar annonser på webbsidor

abuse-report-settings-reason-v2 = Det ändrade min sökmotor, startsida eller nya flikar utan att informera eller fråga mig
abuse-report-settings-suggestions = Innan du anmäler tillägget kan du försöka ändra dina inställningar:
abuse-report-settings-suggestions-search = Ändra dina standardinställningar för sökning
abuse-report-settings-suggestions-homepage = Ändra din startsida och ny flik

abuse-report-deceptive-reason-v2 = Sidan påstår sig vara något som den inte är
abuse-report-deceptive-example = Exempel: Vilseledande beskrivning eller bilder

abuse-report-broken-reason-extension-v2 = Det fungerar inte, stör webbplatser eller slöar ner { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Det fungerar inte eller stör webbläsarens utseende
abuse-report-broken-example = Exempel: Funktionen är långsam, svår att använda, eller fungerar inte. delar av webbplatser laddas inte eller ser ovanliga ut
abuse-report-broken-suggestions-extension =
    Det låter som om du har identifierat ett fel. Förutom att skicka en rapport här, det bästa sättet
    för att få ett funktionalitetsproblem löst är att kontakta tilläggets utvecklare.
    <a data-l10n-name="support-link">Besök tilläggets webbplats</a> för att få utvecklarinformation.
abuse-report-broken-suggestions-theme =
    Det låter som om du har identifierat ett fel. Förutom att skicka en rapport här, det bästa sättet
    för att få ett funktionalitetsproblem löst, är att kontakta utvecklaren av temat.
    <a data-l10n-name="support-link">Besök temats webbplats</a> för att få utvecklarinformation.

abuse-report-policy-reason-v2 = Den innehåller hatfullt, våldsamt eller olagligt innehåll
abuse-report-policy-suggestions =
    Obs! Upphovsrätt och varumärkesproblem måste rapporteras i en separat process.
    <a data-l10n-name="report-infringement-link">Använd dessa anvisningar</a> till
    att rapportera problemet.

abuse-report-unwanted-reason-v2 = Jag ville aldrig ha det och vet inte hur jag ska bli av med det
abuse-report-unwanted-example = Exempel: En applikation installerade den utan min tillåtelse

abuse-report-other-reason = Något annat

