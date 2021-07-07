# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Kontoopsætning

## Header

account-setup-title = Tilføj din eksisterende mailadresse
account-setup-description = For at bruge din nuværende mailadresse, skal du indtaste dine login-oplysninger.

## Form fields

account-setup-name-label = Dit fulde navn
    .accesskey = D
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = Jane Hansen
account-setup-name-info-icon =
    .title = Dit navn som andre skal se det
account-setup-name-warning-icon =
    .title = Indtast dit navn
account-setup-email-label = Mailadresse
    .accesskey = M
account-setup-email-input =
    .placeholder = jane.hansen@eksempel.dk
account-setup-email-info-icon =
    .title = Din eksisterende mailadresse
account-setup-email-warning-icon =
    .title = Ugyldig mailadresse
account-setup-password-label = Adgangskode
    .accesskey = d
    .title = Valgfri, vil kun blive brugt til at validere brugernavnet
account-provisioner-button = Få en ny mailadresse
    .accesskey = F
account-setup-password-toggle =
    .title = Vis/skjul adgangskode
account-setup-remember-password = Husk adgangskode
    .accesskey = H
account-setup-exchange-label = Dit login
    .accesskey = l
#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = DITDOMÆNE\ditbrugernavn
#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Domæne-login

## Action buttons

account-setup-button-cancel = Annuller
    .accesskey = A
account-setup-button-manual-config = Manuel opsætning
    .accesskey = o
account-setup-button-stop = Stop
    .accesskey = S
account-setup-button-retest = Afprøv konfigurationen
    .accesskey = ø
account-setup-button-continue = Fortsæt
    .accesskey = F
account-setup-button-done = Opret konto
    .accesskey = O

## Notifications

account-setup-looking-up-settings = Undersøger konfiguration…
account-setup-looking-up-settings-guess = Undersøger konfiguration: Prøver almindelige servernavne…
account-setup-looking-up-settings-half-manual = Undersøger konfiguration: Forespørger serveren…
account-setup-looking-up-disk = Undersøger konfiguration: { -brand-short-name }-installation…
account-setup-looking-up-isp = Undersøger konfiguration: Mailudbyder…
# Note: Do not translate or replace Mozilla. It stands for the public project mozilla.org, not Mozilla Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Undersøger konfiguration: Mozillas database over mailudbydere…
account-setup-looking-up-mx = Undersøger konfiguration: Indgående maildomæne…
account-setup-looking-up-exchange = Undersøger konfiguration: Exchange-server…
account-setup-checking-password = Kontrollerer adgangskode…
account-setup-installing-addon = Henter og installerer tilføjelse…
account-setup-success-half-manual = Følgende indstillinger blev fundet ved at forespørge serveren:
account-setup-success-guess = Konfiguration fundet ved at prøve almindelige servernavne.
account-setup-success-guess-offline = Du er offline. Vi har gættet på nogle af indstillingerne, men du skal selv angive de rigtige indstillinger for at oprette kontoen.
account-setup-success-password = Adgangskode OK
account-setup-success-addon = Tilføjelsen blev installeret
# Note: Do not translate or replace Mozilla. It stands for the public project mozilla.org, not Mozilla Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = Konfiguration fundet i Mozillas database over mailudbydere.
account-setup-success-settings-disk = Konfiguration fundet på { -brand-short-name }-installation.
account-setup-success-settings-isp = Konfiguration fundet hos mailudbyderen.
# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = Fandt konfiguration for en Microsoft Exchange-server.

## Illustrations

account-setup-step1-image =
    .title = Indledende opsætning
account-setup-step2-image =
    .title = Indlæser…
account-setup-step3-image =
    .title = Konfiguration fundet
account-setup-step4-image =
    .title = Forbindelsesfejl
account-setup-privacy-footnote = Dine login-informationer bruges i henhold til vores <a data-l10n-name="privacy-policy-link">privatlivspolitik</a> og gemmes kun lokalt på din computer.
account-setup-selection-help = Ved du ikke, hvad du skal vælge?
account-setup-selection-error = Har du brug for hjælp?
account-setup-documentation-help = Dokumentation om opsætning
account-setup-forum-help = Supportforum

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
        [one] Tilgængelig konfiguration
       *[other] Tilgængelige konfigurationer
    }
# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP
account-setup-result-imap-description = Hold dine mapper og meddelelser synkroniseret på din server
# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3
account-setup-result-pop-description = Hold dine mapper og meddelelser på din computer
# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange
account-setup-result-exchange-description = Microsoft Exchange-server
account-setup-incoming-title = Indgående
account-setup-outgoing-title = Udgående
account-setup-username-title = Brugernavn
account-setup-exchange-title = Server
account-setup-result-smtp = SMTP
account-setup-result-no-encryption = Ingen kryptering
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS
account-setup-result-outgoing-existing = Brug eksisterende udgående SMTP-server
# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = Indgående: { $incoming }, Udgående: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Godkendelse mislykkedes. Enten er de indtastede oplysninger forkerte, eller der skal bruges et separat brugernavn for at logge ind. Dette er normalt brugernavnet til dit Windows-domæne med eller uden domænet (for eksempel janehansen eller AD\\janehansen)
account-setup-credentials-wrong = Godkendelse mislykkedes. Kontroller brugernavn og adgangskode
account-setup-find-settings-failed = { -brand-short-name } kunne ikke finde indstillinger til din mailkonto
account-setup-exchange-config-unverifiable = Konfigurationen kunne ikke bekræftes. Hvis brugernavn og adgangskode er indtastet korrekt, skyldes det sandsynligvis, at serveradministratoren har deaktiveret den valgte indstilling for din konto. Prøv at vælge en anden protokol.

## Manual configuration area

account-setup-manual-config-title = Serverindstillinger
account-setup-incoming-server-legend = Indgående server
account-setup-protocol-label = Protokol:
protocol-imap-option = { account-setup-result-imap }
protocol-pop-option = { account-setup-result-pop }
protocol-exchange-option = { account-setup-result-exchange }
account-setup-hostname-label = Værtsnavn:
account-setup-port-label = Port:
    .title = Sæt portnummeret til 0 for autodetektion
account-setup-auto-description = { -brand-short-name } forsøger automatisk at udfylde tomme felter.
account-setup-ssl-label = Forbindelsessikkerhed:
account-setup-outgoing-server-legend = Udgående server

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Find automatisk
ssl-no-authentication-option = Ingen godkendelse
ssl-cleartext-password-option = Almindelig adgangskode
ssl-encrypted-password-option = Krypteret adgangskode

## Incoming/Outgoing SSL options

ssl-noencryption-option = Ingen
account-setup-auth-label = Godkendelsesmetode:
account-setup-username-label = Brugernavn:
account-setup-advanced-setup-button = Avanceret konfiguration
    .accesskey = v

## Warning insecure server dialog

account-setup-insecure-title = Advarsel!
account-setup-insecure-incoming-title = Indstillinger for indgående:
account-setup-insecure-outgoing-title = Indstillinger for udgående:
# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = <b>{ $server }</b> bruger ikke kryptering.
account-setup-warning-cleartext-details = Usikre mailservere benytter ikke kryptering til at beskytte din adgangskode og indholdet i dine mails. Ved at forbinde til denne server risikerer du at få afluret din adgangskode og indholdet i dine mails.
account-setup-insecure-server-checkbox = Jeg accepterer risikoen
    .accesskey = a
account-setup-insecure-description = { -brand-short-name } lader dig bruge mailkontoen med den angivne konfiguration. Du bør dog kontakte din administrator eller mailudbyder angående disse usikre forbindelsesindstillinger. Se <a data-l10n-name="thunderbird-faq-link">Thunderbirds FAQ</a> for yderligere oplysninger.
insecure-dialog-cancel-button = Rediger indstillinger
    .accesskey = R
insecure-dialog-confirm-button = Bekræft
    .accesskey = B

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = { -brand-short-name } fandt oplysninger om dine kontoindstillinger på { $domain }. Vil du fortsætte og indsende dine login-informationer?
exchange-dialog-confirm-button = Login
exchange-dialog-cancel-button = Annuller

## Alert dialogs

account-setup-creation-error-title = Kunne ikke oprette konto
account-setup-error-server-exists = Indgående server er allerede oprettet.
account-setup-confirm-advanced-title = Bekræft avanceret opsætning
account-setup-confirm-advanced-description = Denne besked lukkes og en konto med de aktuelle indstillinger bliver oprettet, også selvom de måske er forkerte. Ønsker du at fortsætte?

## Addon installation section

account-setup-addon-install-title = Installer
account-setup-addon-install-intro = En tilføjelse fra tredjepart kan give dig adgang til din mailkonto på denne server:
account-setup-addon-no-protocol = Denne mailserver understøtter desværre ikke åbne protokoller. { account-setup-addon-install-intro }

## Success view


## Calendar synchronization dialog

