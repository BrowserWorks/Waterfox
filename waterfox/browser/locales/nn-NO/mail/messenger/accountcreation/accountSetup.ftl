# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Kontoinnstillingar

## Header

account-setup-secondary-description = { -brand-product-name } vil automatiskt søkje etter ein fungerande og tilrådd serverkonfigurasjon.
account-setup-success-title = Kontoen er oppretta

## Form fields

account-setup-name-label = Fullt namn
    .accesskey = F
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = Ola Nordmann
account-setup-name-info-icon =
    .title = Namnet ditt som det skal visast for andre
account-setup-name-warning-icon =
    .title = Skriv inn namnet ditt
account-setup-email-label = E-postadresse
    .accesskey = E
account-setup-email-input =
    .placeholder = ola.nordmann@døme.no
account-setup-email-info-icon =
    .title = Eksisterande e-postadresse
account-setup-email-warning-icon =
    .title = Ugyldig e-postadresse
account-setup-password-label = Passord
    .accesskey = P
    .title = Valfritt, vil berre brukast for å validere brukarnamnet
account-provisioner-button = Få ei ny e-postadresse
    .accesskey = F
account-setup-password-toggle-show =
    .title = Vis passordet i klartekt
account-setup-password-toggle-hide =
    .title = Gøym passordet
account-setup-remember-password = Hugs passord
    .accesskey = H
account-setup-exchange-label = Di innlogging:
    .accesskey = D

## Action buttons

account-setup-button-cancel = Avbryt
    .accesskey = A
account-setup-button-stop = Stopp
    .accesskey = S
account-setup-button-continue = Fortset
    .accesskey = F

## Notifications

account-setup-checking-password = Kontrollerer passord…

## Illustrations

account-setup-step2-image =
    .title = Lastar…
account-setup-step5-image =
    .title = Konto opretta
account-setup-selection-error = Treng du hjelp?
account-setup-forum-help = Brukarstøtteforum
account-setup-getting-started = Kom i gang

## Results area

account-setup-incoming-title = Innkomande
account-setup-outgoing-title = Utgåande
account-setup-username-title = Brukarnamn
account-setup-exchange-title = Server
account-setup-result-no-encryption = Inga kryptering
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS

## Error messages


## Manual configuration area

account-setup-incoming-server-legend = Innkomande tenar
account-setup-protocol-label = Protokoll:

## Incoming/Outgoing SSL Authentication options

ssl-encrypted-password-option = Kryptert passord

## Incoming/Outgoing SSL options

ssl-noencryption-option = Ingen
account-setup-auth-label = Godkjenningsmetode:
account-setup-username-label = Brukarnamn:

## Warning insecure server dialog

account-setup-insecure-title = Åtvaring!
account-setup-insecure-incoming-title = Innkomande innstillingar:
account-setup-insecure-outgoing-title = Utgåande innstillingar:
# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = <b>{ $server }</b> brukar ikkje kryptering.
insecure-dialog-cancel-button = Endre innstillingar
    .accesskey = n
insecure-dialog-confirm-button = Stadfest
    .accesskey = S

## Warning Exchange confirmation dialog

exchange-dialog-confirm-button = Innlogging
exchange-dialog-cancel-button = Avbryt

## Dismiss account creation dialog


## Alert dialogs


## Addon installation section

account-setup-addon-install-title = Installer

## Success view

account-setup-settings-button = Kontoinnstillingar
account-setup-encryption-button = Ende-til-ende-kryptering
account-setup-signature-button = Legg til ein signatur
account-setup-dictionaries-button = Last ned ordlister
account-setup-address-book-carddav-button = Kople til ei CardDAV-adressebok
account-setup-address-book-ldap-button = Kople til ei LDAP-adressebok
account-setup-calendar-button = Kople til ein ekstern kalender
account-setup-linked-services-title = Kople til dei tilknytte tenestene dine
account-setup-button-finish = Fullfør
    .accesskey = F
account-setup-address-books-button = Adressebøker
account-setup-calendars-button = Kalendrar
account-setup-connect-link = Kople til
account-setup-existing-address-book = Tilkopla
    .title = Adresseboka er allereie tilkopla
account-setup-existing-calendar = Tilkopla
    .title = Kalender allereie tilkopla

## Calendar synchronization dialog

calendar-dialog-cancel-button = Avbryt
    .accesskey = A
account-setup-calendar-name-label = Namn
account-setup-calendar-name-input =
    .placeholder = Min kalender
account-setup-calendar-color-label = Farge
account-setup-calendar-refresh-label = Oppdater
account-setup-calendar-refresh-manual = Manuelt
