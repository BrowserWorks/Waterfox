# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Kontoopsætning

## Header

account-setup-title = Tilføj din eksisterende mailadresse

account-setup-description = For at bruge din nuværende mailadresse, skal du indtaste dine login-oplysninger.

account-setup-secondary-description = { -brand-product-name } vil automatisk søge efter en anbefalet serverkonfiguration, der virker.

account-setup-success-title = Kontoen blev oprettet

account-setup-success-description = Du kan nu bruge denne konto med { -brand-short-name }.

account-setup-success-secondary-description = Du kan forbedre oplevelsen ved at oprette forbindelse til relaterede tjenester og konfigurere avancerede kontoindstillinger.

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

# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Undersøger konfiguration: Waterfoxs database over mailudbydere…

account-setup-looking-up-mx = Undersøger konfiguration: Indgående maildomæne…

account-setup-looking-up-exchange = Undersøger konfiguration: Exchange-server…

account-setup-checking-password = Kontrollerer adgangskode…

account-setup-installing-addon = Henter og installerer tilføjelse…

account-setup-success-half-manual = Følgende indstillinger blev fundet ved at forespørge serveren:

account-setup-success-guess = Konfiguration fundet ved at prøve almindelige servernavne.

account-setup-success-guess-offline = Du er offline. Vi har gættet på nogle af indstillingerne, men du skal selv angive de rigtige indstillinger for at oprette kontoen.

account-setup-success-password = Adgangskode OK

account-setup-success-addon = Tilføjelsen blev installeret

# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = Konfiguration fundet i Waterfoxs database over mailudbydere.

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

account-setup-step5-image =
    .title = Konto oprettet

account-setup-privacy-footnote2 = Dine login-oplysninger vil kun blive gemt lokalt på din computer.

account-setup-selection-help = Ved du ikke, hvad du skal vælge?

account-setup-selection-error = Har du brug for hjælp?

account-setup-success-help = Usikker på, hvad du skal nu?

account-setup-documentation-help = Dokumentation om opsætning

account-setup-forum-help = Supportforum

account-setup-privacy-help = Privatlivspolitik

account-setup-getting-started = Sådan kommer du i gang

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

# Note: Exchange, Office365 are the name of products.
account-setup-result-exchange2-description = Brug Microsoft Exchange-serveren eller Office365-cloudtjenester

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

## Dismiss account creation dialog

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

account-setup-settings-button = Kontoindstillinger

account-setup-encryption-button = End to end-kryptering

account-setup-signature-button = Tilføj en signatur

account-setup-dictionaries-button = Hent ordbøger

account-setup-address-book-carddav-button = Opret forbindelse til en CardDAV-adressebog

account-setup-address-book-ldap-button = Opret forbindelse til en LDAP-adressebog

account-setup-calendar-button = Opret forbindelse til en fjernkalender

account-setup-linked-services-title = Tilslut dine tilknyttede tjenester

account-setup-linked-services-description = { -brand-short-name } fandt andre tjenester, der er knyttet til din mailkonto.

account-setup-no-linked-description = Konfigurer andre tjenester for at få mest muligt ud af din { -brand-short-name }-oplevelse.

# Variables:
# $count (Number) - The number of address books found during autoconfig.
account-setup-found-address-books-description =
    { $count ->
        [one] { -brand-short-name } fandt en adressebog, der er knyttet til din mailkonto.
       *[other] { -brand-short-name } fandt { $count } adressebøger, der er knyttet til din mailkonto.
    }

# Variables:
# $count (Number) - The number of calendars found during autoconfig.
account-setup-found-calendars-description =
    { $count ->
        [one] { -brand-short-name } fandt en kalender, der er knyttet til din mailkonto.
       *[other] { -brand-short-name } fandt { $count } kalendere, der er knyttet til din mailkonto.
    }

account-setup-button-finish = Afslut
    .accesskey = A

account-setup-looking-up-address-books = Undersøger adressebøger…

account-setup-looking-up-calendars = Undersøger kalendere…

account-setup-address-books-button = Adressebøger

account-setup-calendars-button = Kalendere

account-setup-connect-link = Opret forbindelse

account-setup-existing-address-book = Forbundet
    .title = Der er allerede forbindelse til adressebogen

account-setup-existing-calendar = Forbundet
    .title = Der er allerede forbindelse til kalenderen

account-setup-connect-all-calendars = Opret forbindelse til alle kalendere

account-setup-connect-all-address-books = Opret forbindelse til alle adressebøger

## Calendar synchronization dialog

calendar-dialog-title = Opret forbindelse til kalender

calendar-dialog-cancel-button = Annuller
    .accesskey = A

calendar-dialog-confirm-button = Opret forbindelse
    .accesskey = f

account-setup-calendar-name-label = Navn

account-setup-calendar-name-input =
    .placeholder = Min kalender

account-setup-calendar-color-label = Farve

account-setup-calendar-refresh-label = Opdater

account-setup-calendar-refresh-manual = Manuelt

account-setup-calendar-refresh-interval =
    { $count ->
        [one] Hvert minut
       *[other] Hvert { $count }. minut
    }

account-setup-calendar-read-only = Skrivebeskyttet
    .accesskey = S

account-setup-calendar-show-reminders = Vis alarmer
    .accesskey = V

account-setup-calendar-offline-support = Offline-understøttelse
    .accesskey = O
