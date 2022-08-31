# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-key-assistant-title = OpenPGP nøgleassistent
openpgp-key-assistant-rogue-warning = Undgå at acceptere en forfalsket nøgle. For at sikre, at du har fået den rigtige nøgle, bør du bekræfte den. <a data-l10n-name="openpgp-link">Få flere oplysninger...</a>

## Encryption status

openpgp-key-assistant-recipients-issue-header = Kan ikke kryptere
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-issue-description =
    { $count ->
        [one] For at kryptere skal du anskaffe og acceptere en brugbar nøgle til én modtager. <a data-l10n-name="openpgp-link">Læs mere...</a>
       *[other] For at kryptere skal du anskaffe og acceptere brugbare nøgler til { $count } modtagere. <a data-l10n-name="openpgp-link">Læs mere...</a>
    }
openpgp-key-assistant-info-alias = { -brand-short-name } kræver normalt at modtagerens offentlige nøgle indeholder et bruger-ID med en tilhørende mailadresse. Dette kan tilsidesættes ved at benytte regler for OpenPGP-modtageralias. <a data-l10n-name="openpgp-link">Læs mere...</a>
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-description =
    { $count ->
        [one] Du har allerede en brugbar og accepteret nøgle til én modtager.
       *[other] Du har allerede brugbare og accepterede nøgler til { $count } modtagere.
    }
openpgp-key-assistant-recipients-description-no-issues = Denne meddelelse kan krypteres. Du har brugbare og accepterede nøgler til alle modtagere.

## Resolve section

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
# $numKeys (Number) - The number of keys.
openpgp-key-assistant-resolve-title =
    { $numKeys ->
        [one] { -brand-short-name } fandt følgende nøgle til { $recipient }.
       *[other] { -brand-short-name } fandt følgende nøgler til { $recipient }.
    }
openpgp-key-assistant-valid-description = Vælg den nøgle, du vil acceptere
# Variables:
# $numKeys (Number) - The number of available keys.
openpgp-key-assistant-invalid-title =
    { $numKeys ->
        [one] Følgende nøgle kan ikke bruges, medmindre du får en opdatering.
       *[other] Følgende nøgler kan ikke bruges, medmindre du får en opdatering.
    }
openpgp-key-assistant-no-key-available = Ingen nøgle tilgængelig.
openpgp-key-assistant-multiple-keys = Flere nøgler er tilgængelige.
# Variables:
# $count (Number) - The number of unaccepted keys.
openpgp-key-assistant-key-unaccepted =
    { $count ->
        [one] En nøgle er tilgængelig, men den er ikke blevet accepteret endnu.
       *[other] Flere nøgler er tilgængelige, men ingen af dem er blevet accepteret endnu.
    }
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = En accepteret nøgle er udløbet den { $date }.
openpgp-key-assistant-keys-accepted-expired = Flere accepterede nøgler er udløbet.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = Denne nøgle blev tidligere accepteret, men udløb den { $date }.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one = Nøglen udløb den: { $date }
openpgp-key-assistant-key-unaccepted-expired-many = Flere nøgler er udløbet.
openpgp-key-assistant-key-fingerprint = Fingeraftryk:
openpgp-key-assistant-key-source =
    { $count ->
        [one] Kilde
       *[other] Kilder
    }
openpgp-key-assistant-key-collected-attachment = vedhæftet fil
# Autocrypt is the name of a standard.
openpgp-key-assistant-key-collected-autocrypt = Autocrypt-header
openpgp-key-assistant-key-collected-keyserver = nøgleserver
# Web Key Directory (WKD) is a concept.
openpgp-key-assistant-key-collected-wkd = Web Key Directory
openpgp-key-assistant-keys-has-collected =
    { $count ->
        [one] Der blev fundet en nøgle, men den er ikke blevet accepteret endnu.
       *[other] Der blev fundet flere nøgler, men ingen af dem er blevet accepteret endnu.
    }
openpgp-key-assistant-key-rejected = Denne nøgle er tidligere blevet afvist.
openpgp-key-assistant-key-accepted-other = Denne nøgle er tidligere blevet accepteret for en anden mailadresse.
# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info = Find yderligere eller opdaterede nøgler til { $recipient } online, eller importer dem fra en fil.

## Discovery section

openpgp-key-assistant-discover-title = Online-søgning i gang.
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = Finder nøgler til { $recipient }...
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-expired-key-update =
    Der blev fundet en opdatering til en af de tidligere accepterede nøgler for { $recipient }.
    Den kan nu bruges, da den ikke længere er udløbet.

## Dialog buttons

openpgp-key-assistant-discover-online-button = Find offentlige nøgler online...
openpgp-key-assistant-import-keys-button = Importer offentlige nøgler fra fil...
openpgp-key-assistant-issue-resolve-button = Løs...
openpgp-key-assistant-view-key-button = Se nøgle...
openpgp-key-assistant-recipients-show-button = Vis
openpgp-key-assistant-recipients-hide-button = Skjul
openpgp-key-assistant-cancel-button = Annuller
openpgp-key-assistant-back-button = Tilbage
openpgp-key-assistant-accept-button = Accepter
openpgp-key-assistant-close-button = Luk
openpgp-key-assistant-disable-button = Deaktiver kryptering
openpgp-key-assistant-confirm-button = Send krypteret
# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = oprettet den { $date }
