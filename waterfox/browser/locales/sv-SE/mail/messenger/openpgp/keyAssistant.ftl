# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-key-assistant-title = OpenPGP-nyckelassistent
openpgp-key-assistant-rogue-warning = Undvik att acceptera en förfalskad nyckel. För att säkerställa att du har fått rätt nyckel bör du verifiera den. <a data-l10n-name="openpgp-link">Läs mer…</a>

## Encryption status

openpgp-key-assistant-recipients-issue-header = Kan inte kryptera
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-issue-description =
    { $count ->
        [one] För att kryptera måste du skaffa och acceptera en användbar nyckel för en mottagare. <a data-l10n-name="openpgp-link">Läs mer…</a>
       *[other] För att kryptera måste du skaffa och acceptera användbara nycklar för { $count } mottagare. <a data-l10n-name="openpgp-link">Läs mer…</a>
    }
openpgp-key-assistant-info-alias = { -brand-short-name } kräver normalt att mottagarens publika nyckel innehåller ett användar-ID med en matchande e-postadress. Detta kan åsidosättas genom att använda reglerna för OpenPGP-mottagaralias. <a data-l10n-name="openpgp-link">Läs mer…</a>
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-description =
    { $count ->
        [one] Du har redan en användbar och godkänd nyckel för en mottagare.
       *[other] Du har redan användbara och godkända nycklar för { $count } mottagare.
    }
openpgp-key-assistant-recipients-description-no-issues = Detta meddelande kan krypteras. Du har användbara och godkända nycklar för alla mottagare.

## Resolve section

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
# $numKeys (Number) - The number of keys.
openpgp-key-assistant-resolve-title =
    { $numKeys ->
        [one] { -brand-short-name } hittade följande nyckel för { $recipient }.
       *[other] { -brand-short-name } hittade följande nycklar för { $recipient }.
    }
openpgp-key-assistant-valid-description = Välj den nyckel som du vill acceptera
# Variables:
# $numKeys (Number) - The number of available keys.
openpgp-key-assistant-invalid-title =
    { $numKeys ->
        [one] Följande nyckel kan inte användas om du inte skaffar en uppdatering.
       *[other] Följande nycklar kan inte användas om du inte skaffar en uppdatering.
    }
openpgp-key-assistant-no-key-available = Ingen nyckel tillgänglig.
openpgp-key-assistant-multiple-keys = Flera nycklar är tillgängliga.
# Variables:
# $count (Number) - The number of unaccepted keys.
openpgp-key-assistant-key-unaccepted =
    { $count ->
        [one] En nyckel är tillgänglig, men den har inte godkänts ännu.
       *[other] Flera nycklar är tillgängliga, men ingen av dem har godkänts ännu.
    }
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = En godkänd nyckel har upphört att gälla { $date }.
openpgp-key-assistant-keys-accepted-expired = Flera godkända nycklar har upphört att gälla.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = Denna nyckel har tidigare godkänts men upphörde { $date }.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one = Nyckeln upphörde { $date }.
openpgp-key-assistant-key-unaccepted-expired-many = Flera nycklar har upphört.
openpgp-key-assistant-key-fingerprint = Fingeravtryck
openpgp-key-assistant-key-source =
    { $count ->
        [one] Källa
       *[other] Källor
    }
openpgp-key-assistant-key-collected-attachment = e-postbilaga
openpgp-key-assistant-key-collected-autocrypt = Kryptera rubrik automatiskt
openpgp-key-assistant-key-collected-keyserver = nyckelserver
openpgp-key-assistant-key-collected-wkd = Nyckelkatalog på webben
openpgp-key-assistant-keys-has-collected =
    { $count ->
        [one] En nyckel hittades, men den har inte godkänts ännu.
       *[other] Flera nycklar hittades, men ingen av dem har godkänts ännu.
    }
openpgp-key-assistant-key-rejected = Denna nyckel har tidigare avvisats.
openpgp-key-assistant-key-accepted-other = Denna nyckel har tidigare godkänts för en annan e-postadress.
# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info = Upptäck ytterligare eller uppdaterade nycklar för { $recipient } online eller importera dem från en fil.

## Discovery section

openpgp-key-assistant-discover-title = Letar efter nycklar online.
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = Letar efter nycklar för { $recipient }…
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-expired-key-update =
    En uppdatering hittades för en av de tidigare godkända nycklarna för { $recipient }.
    Den kan nu användas eftersom den inte längre är upphörd.

## Dialog buttons

openpgp-key-assistant-discover-online-button = Upptäck publika nycklar online…
openpgp-key-assistant-import-keys-button = Importera offentliga nycklar från fil…
openpgp-key-assistant-issue-resolve-button = Lös…
openpgp-key-assistant-view-key-button = Visa nyckel…
openpgp-key-assistant-recipients-show-button = Visa
openpgp-key-assistant-recipients-hide-button = Dölj
openpgp-key-assistant-cancel-button = Avbryt
openpgp-key-assistant-back-button = Tillbaka
openpgp-key-assistant-accept-button = Acceptera
openpgp-key-assistant-close-button = Stäng
openpgp-key-assistant-disable-button = Inaktivera kryptering
openpgp-key-assistant-confirm-button = Skicka krypterat
# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = skapad { $date }
