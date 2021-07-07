# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Rapport voor { $addon-name }

abuse-report-title-extension = Deze extensie rapporteren aan { -vendor-short-name }
abuse-report-title-theme = Dit thema rapporteren aan { -vendor-short-name }
abuse-report-subtitle = Wat is het probleem?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = door <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Weet u niet zeker welk probleem u moet selecteren?
    <a data-l10n-name="learnmore-link">Meer info over het rapporteren van extensies en thema’s</a>

abuse-report-submit-description = Beschrijf het probleem (optioneel)
abuse-report-textarea =
    .placeholder = Het is makkelijker voor ons om een probleem te behandelen als we details hebben. Beschrijf het probleem dat u ondervindt. Bedankt voor uw hulp bij het gezond houden van het web.
abuse-report-submit-note =
    Noot: voeg geen persoonlijke gegevens (zoals naam, e-mailadres, telefoonnummer of fysiek adres) toe.
    { -vendor-short-name } bewaart deze rapporten permanent.

## Panel buttons.

abuse-report-cancel-button = Annuleren
abuse-report-next-button = Volgende
abuse-report-goback-button = Terug
abuse-report-submit-button = Verzenden

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Rapport voor <span data-l10n-name="addon-name">{ $addon-name }</span> geannuleerd.
abuse-report-messagebar-submitting = Rapport verzenden voor <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Bedankt voor het indienen van een rapport. Wilt u <span data-l10n-name="addon-name">{ $addon-name }</span> verwijderen?
abuse-report-messagebar-submitted-noremove = Bedankt voor het indienen van een rapport.
abuse-report-messagebar-removed-extension = Bedankt voor het indienen van een rapport. U hebt de extensie <span data-l10n-name="addon-name">{ $addon-name }</span> verwijderd.
abuse-report-messagebar-removed-theme = Bedankt voor het indienen van een rapport. U hebt het thema <span data-l10n-name="addon-name">{ $addon-name }</span> verwijderd.
abuse-report-messagebar-error = Er is een fout opgetreden bij het verzenden van een rapport voor <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Het rapport voor <span data-l10n-name="addon-name">{ $addon-name }</span> is niet verzonden, omdat u recent een ander rapport hebt verzonden.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Ja, verwijderen
abuse-report-messagebar-action-keep-extension = Nee, bewaren
abuse-report-messagebar-action-remove-theme = Ja, verwijderen
abuse-report-messagebar-action-keep-theme = Nee, bewaren
abuse-report-messagebar-action-retry = Opnieuw proberen
abuse-report-messagebar-action-cancel = Annuleren

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Het heeft mijn computer beschadigd of mijn gegevens gecompromitteerd
abuse-report-damage-example = Voorbeeld: heeft malware geïnjecteerd of gegevens gestolen

abuse-report-spam-reason-v2 = Het bevat spam of voegt ongewenste advertenties in
abuse-report-spam-example = Voorbeeld: voegt advertenties toe aan webpagina’s

abuse-report-settings-reason-v2 = Het heeft zonder dit te melden of te vragen mijn zoekmachine, startpagina of nieuwe tabblad gewijzigd
abuse-report-settings-suggestions = Voordat u de extensie meldt, kunt u proberen uw instellingen te wijzigen:
abuse-report-settings-suggestions-search = Uw standaard zoekinstellingen wijzigen
abuse-report-settings-suggestions-homepage = Uw startpagina en nieuwe tabblad wijzigen

abuse-report-deceptive-reason-v2 = Het doet zich als iets anders voor
abuse-report-deceptive-example = Voorbeeld: misleidende beschrijving of afbeeldingen

abuse-report-broken-reason-extension-v2 = Het werkt niet, zorgt ervoor dat websites niet werken of vertraagt { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Het werkt niet of zorgt ervoor dat de browserweergave niet werkt
abuse-report-broken-example = Voorbeeld: functies zijn langzaam, moeilijk te gebruiken of werken niet; delen van websites laden niet of zien er ongebruikelijk uit
abuse-report-broken-suggestions-extension = Het lijkt alsof u een bug hebt gevonden. In aanvulling op deze melding kunt u het beste contact opnemen met de ontwikkelaar van de extensie. <a data-l10n-name="support-link">Bezoek de startpagina van de extensie</a> voor informatie over de ontwikkelaar.
abuse-report-broken-suggestions-theme =
    Het klinkt alsof u een bug hebt gevonden. Naast het hier indienen van een rapport, is de beste manier
    om een functioneel probleem op te lossen, contact op te nemen met de ontwikkelaar van het thema.
    <a data-l10n-name="support-link">Bezoek de website van het thema</a> voor informatie over de ontwikkelaar.

abuse-report-policy-reason-v2 = Het bevat haatdragende, gewelddadige of illegale inhoud
abuse-report-policy-suggestions =
    Opmerking: problemen met auteursrechten en handelsmerken moeten in een afzonderlijk proces worden gemeld.
    <a data-l10n-name="report-infringement-link">Volg deze instructies</a> om het probleem te melden.

abuse-report-unwanted-reason-v2 = Ik heb het nooit gewild en weet niet hoe ik er vanaf moet komen
abuse-report-unwanted-example = Voorbeeld: een toepassing heeft deze zonder mijn toestemming geïnstalleerd

abuse-report-other-reason = Iets anders

