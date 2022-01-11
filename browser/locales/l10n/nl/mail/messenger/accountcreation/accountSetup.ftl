# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Account instellen

## Header

account-setup-title = Uw bestaande e-mailadres instellen
account-setup-description =
    Vul om uw huidige e-mailadres te gebruiken uw aanmeldgegevens in.<br/>
    { -brand-product-name } zoekt automatisch naar een werkende en aanbevolen serverconfiguratie.

## Form fields

account-setup-name-label = Uw volledige naam
    .accesskey = n
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = Jan Jansen
account-setup-name-info-icon =
    .title = Uw naam, zoals getoond aan anderen
account-setup-name-warning-icon =
    .title = { account-setup-name-warning }
account-setup-email-label = E-mailadres
    .accesskey = E
account-setup-email-input =
    .placeholder = jan.jansen@voorbeeld.com
account-setup-email-info-icon =
    .title = Uw bestaande e-mailadres
account-setup-email-warning-icon =
    .title = { account-setup-email-warning }
account-setup-password-label = Wachtwoord
    .accesskey = W
    .title = Optioneel, wordt alleen gebruikt om de gebruikersnaam te valideren
account-provisioner-button = Een nieuw e-mailadres aanvragen
    .accesskey = v
account-setup-password-toggle =
    .title = Wachtwoord tonen/verbergen
account-setup-remember-password = Wachtwoord onthouden
    .accesskey = h
account-setup-exchange-label = Uw aanmelding
    .accesskey = a
#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = UWDOMEIN\gebruikersnaam
#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Domeingebruikersnaam

## Action buttons

account-setup-button-cancel = Annuleren
    .accesskey = A
account-setup-button-manual-config = Handmatig configureren
    .accesskey = H
account-setup-button-stop = Stoppen
    .accesskey = S
account-setup-button-retest = Opnieuw testen
    .accesskey = t
account-setup-button-continue = Doorgaan
    .accesskey = D
account-setup-button-done = Gereed
    .accesskey = G

## Notifications

account-setup-looking-up-settings = Configuratie opzoeken…
account-setup-looking-up-settings-guess = Configuratie opzoeken: algemene servernamen proberen…
account-setup-looking-up-settings-half-manual = Configuratie opzoeken: server zoeken…
account-setup-looking-up-disk = Configuratie opzoeken: installatie van { -brand-short-name }…
account-setup-looking-up-isp = Configuratie opzoeken: e-mailprovider…
# Note: Do not translate or replace Mozilla. It stands for the public project mozilla.org, not Mozilla Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Configuratie opzoeken: Mozilla ISP-database…
account-setup-looking-up-mx = Configuratie opzoeken: domein inkomende e-mail…
account-setup-looking-up-exchange = Configuratie opzoeken: Exchange-server…
account-setup-checking-password = Wachtwoord controleren…
account-setup-installing-addon = Add-on downloaden en installeren…
account-setup-success-half-manual = De volgende instellingen zijn gevonden door de opgegeven server te zoeken:
account-setup-success-guess = Configuratie gevonden door algemene servernamen te proberen.
account-setup-success-guess-offline = U bent offline. Een aantal instellingen is verondersteld, maar u dient de juiste in te voeren.
account-setup-success-password = Wachtwoord ok!
account-setup-success-addon = Add-on met succes geïnstalleerd
# Note: Do not translate or replace Mozilla. It stands for the public project mozilla.org, not Mozilla Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = Configuratie gevonden in de Mozilla ISP-database.
account-setup-success-settings-disk = Configuratie gevonden bij installatie van { -brand-short-name }.
account-setup-success-settings-isp = Configuratie gevonden bij e-mailprovider.
# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = Configuratie gevonden voor een Microsoft Exchange-server.

## Illustrations

account-setup-step1-image =
    .title = Initiële instellingen
account-setup-step2-image =
    .title = Laden…
account-setup-step3-image =
    .title = Configuratie gevonden
account-setup-step4-image =
    .title = Verbindingsfout
account-setup-privacy-footnote = Uw aanmeldgegevens worden gebruikt in overeenstemming met ons <a data-l10n-name="privacy-policy-link">privacybeleid</a> en worden alleen lokaal op uw computer opgeslagen.
account-setup-selection-help = Weet u niet wat u moet selecteren?
account-setup-selection-error = Hulp nodig?
account-setup-documentation-help = Insteldocumentatie
account-setup-forum-help = Ondersteuningsforum

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
        [one] Beschikbare configuratie
       *[other] Beschikbare configuraties
    }
# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP
account-setup-result-imap-description = Uw mappen en e-mailberichten gesynchroniseerd op uw server bewaren
# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3
account-setup-result-pop-description = Uw mappen en e-mailberichten op uw computer bewaren
# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange
account-setup-result-exchange-description = Microsoft Exchange-server
account-setup-incoming-title = Inkomend
account-setup-outgoing-title = Uitgaand
account-setup-username-title = Gebruikersnaam
account-setup-exchange-title = Server
account-setup-result-smtp = SMTP
account-setup-result-no-encryption = Geen versleuteling
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS
account-setup-result-outgoing-existing = Bestaande uitgaande (SMTP-)server gebruiken
# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = Inkomend: { $incoming }, uitgaand: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Authenticatie mislukt. De ingevoerde gegevens zijn onjuist of er is een aparte gebruikersnaam vereist om aan te melden. Deze gebruikersnaam is meestal uw Windows-domeinaanmelding met of zonder het domein (bijvoorbeeld janedoe of AD\\janedoe)
account-setup-credentials-wrong = Authenticatie mislukt. Controleer de gebruikersnaam en het wachtwoord
account-setup-find-settings-failed = { -brand-short-name } kan de instellingen voor uw e-mailaccount niet vinden
account-setup-exchange-config-unverifiable = Configuratie kan niet worden geverifieerd. Als uw gebruikersnaam en wachtwoord juist zijn, heeft de serverbeheerder waarschijnlijk de geselecteerde configuratie voor uw account uitgeschakeld. Probeer een ander protocol te selecteren.

## Manual configuration area

account-setup-manual-config-title = Serverinstellingen
account-setup-incoming-server-legend = Inkomende server
account-setup-protocol-label = Protocol:
protocol-imap-option = { account-setup-result-imap }
protocol-pop-option = { account-setup-result-pop }
protocol-exchange-option = { account-setup-result-exchange }
account-setup-hostname-label = Hostnaam:
account-setup-port-label = Poort:
    .title = Stel het poortnummer in op 0 voor autodetectie
account-setup-auto-description = { -brand-short-name } probeert velden die leeg zijn gelaten automatisch te detecteren.
account-setup-ssl-label = Verbindingsbeveiliging:
account-setup-outgoing-server-legend = Uitgaande server

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Autodetectie
ssl-no-authentication-option = Geen authenticatie
ssl-cleartext-password-option = Normaal wachtwoord
ssl-encrypted-password-option = Versleuteld wachtwoord

## Incoming/Outgoing SSL options

ssl-noencryption-option = Geen
account-setup-auth-label = Authenticatiemethode:
account-setup-username-label = Gebruikersnaam:
account-setup-advanced-setup-button = Uitgebreide configuratie
    .accesskey = U

## Warning insecure server dialog

account-setup-insecure-title = Waarschuwing!
account-setup-insecure-incoming-title = Instellingen inkomend:
account-setup-insecure-outgoing-title = Instellingen uitgaand:
# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = <b>{ $server }</b> gebruikt geen versleuteling.
account-setup-warning-cleartext-details = Niet-beveiligde mailservers gebruiken geen versleutelde verbindingen om uw wachtwoorden en privégegevens te beschermen. Door verbinding te maken met deze server kunt u uw wachtwoorden en privégegevens onthullen.
account-setup-insecure-server-checkbox = Ik begrijp de risico’s
    .accesskey = b
account-setup-insecure-description = { -brand-short-name } kan u toegang tot uw e-mail geven met de opgegeven configuratie. U zou echter contact moeten opnemen met uw systeembeheerder of e-mailprovider vanwege deze onjuiste verbindingen. Zie de <a data-l10n-name="thunderbird-faq-link">Thunderbird-FAQ</a> voor meer informatie.
insecure-dialog-cancel-button = Instellingen wijzigen
    .accesskey = I
insecure-dialog-confirm-button = Bevestigen
    .accesskey = B

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = { -brand-short-name } heeft uw accountinstellingen op { $domain } gevonden. Wilt u doorgaan en uw aanmeldgegevens versturen?
exchange-dialog-confirm-button = Aanmelden
exchange-dialog-cancel-button = Annuleren

## Alert dialogs

account-setup-creation-error-title = Fout bij aanmaken van account
account-setup-error-server-exists = Inkomende server bestaat al.
account-setup-confirm-advanced-title = Uitgebreide configuratie bevestigen
account-setup-confirm-advanced-description = Dit dialoogvenster zal worden gesloten en er wordt een account met de huidige instellingen aangemaakt, ook als de configuratie onjuist is. Wilt u doorgaan?

## Addon installation section

account-setup-addon-install-title = Installeren
account-setup-addon-install-intro = Een add-on van derden kan het mogelijk maken om toegang tot uw e-mailaccount op deze server te krijgen:
account-setup-addon-no-protocol = Deze e-mailserver ondersteunt helaas geen open protocollen. { account-setup-addon-install-intro }
