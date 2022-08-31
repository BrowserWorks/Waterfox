# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-key-assistant-title = OpenPGP-sleutelassistent
openpgp-key-assistant-rogue-warning = Vermijd het accepteren van een valse sleutel. Om er zeker van te zijn dat u de juiste sleutel hebt gekregen, dient u deze te verifiëren. <a data-l10n-name="openpgp-link">Meer info…</a>

## Encryption status

openpgp-key-assistant-recipients-issue-header = Kan niet versleutelen
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-issue-description =
    { $count ->
        [one] Om te versleutelen, moet u een bruikbare sleutel verkrijgen en accepteren voor een ontvanger. <a data-l10n-name="openpgp-link">Meer info…</a>
       *[other] Om te versleutelen, moet u bruikbare sleutels verkrijgen en accepteren voor { $count } ontvangers. <a data-l10n-name="openpgp-link">Meer info…</a>
    }
openpgp-key-assistant-info-alias = { -brand-short-name } vereist normaal gesproken dat de publieke sleutel van de ontvanger een gebruikers-ID met een overeenkomend e-mailadres bevat. Dit kan worden vervangen door aliasregels voor OpenPGP-ontvangers te gebruiken. <a data-l10n-name="openpgp-link">Meer info…</a>
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-description =
    { $count ->
        [one] U hebt al een bruikbare en geaccepteerde sleutel voor een ontvanger.
       *[other] U hebt al bruikbare en geaccepteerde sleutels voor { $count } ontvangers.
    }
openpgp-key-assistant-recipients-description-no-issues = Dit bericht kan worden versleuteld. U hebt bruikbare en geaccepteerde sleutels voor alle ontvangers.

## Resolve section

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
# $numKeys (Number) - The number of keys.
openpgp-key-assistant-resolve-title =
    { $numKeys ->
        [one] { -brand-short-name } heeft de volgende sleutel gevonden voor { $recipient }.
       *[other] { -brand-short-name } heeft de volgende sleutels gevonden voor { $recipient }.
    }
openpgp-key-assistant-valid-description = Selecteer de sleutel die u wilt accepteren
# Variables:
# $numKeys (Number) - The number of available keys.
openpgp-key-assistant-invalid-title =
    { $numKeys ->
        [one] De volgende sleutel kan niet worden gebruikt, tenzij u een update verkrijgt.
       *[other] De volgende sleutels kunnen niet worden gebruikt, tenzij u een update verkrijgt.
    }
openpgp-key-assistant-no-key-available = Geen sleutel beschikbaar.
openpgp-key-assistant-multiple-keys = Er zijn meerdere sleutels beschikbaar.
# Variables:
# $count (Number) - The number of unaccepted keys.
openpgp-key-assistant-key-unaccepted =
    { $count ->
        [one] Er is een sleutel beschikbaar, maar deze is nog niet geaccepteerd.
       *[other] Er zijn meerdere sleutels beschikbaar, maar er is er nog geen enkele geaccepteerd.
    }
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = Een geaccepteerde sleutel is verlopen op { $date }.
openpgp-key-assistant-keys-accepted-expired = Meerdere geaccepteerde sleutels zijn verlopen.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = Deze sleutel is eerder geaccepteerd, maar is verlopen op { $date }.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one = De sleutel is verlopen op { $date }.
openpgp-key-assistant-key-unaccepted-expired-many = Meerdere sleutels zijn verlopen.
openpgp-key-assistant-key-fingerprint = Vingerafdruk
openpgp-key-assistant-key-source =
    { $count ->
        [one] Bron
       *[other] Bronnen
    }
openpgp-key-assistant-key-collected-attachment = e-mailbijlage
openpgp-key-assistant-key-collected-autocrypt = Koptekst automatisch versleutelen
openpgp-key-assistant-key-collected-keyserver = sleutelserver
openpgp-key-assistant-key-collected-wkd = Websleutelmap
openpgp-key-assistant-keys-has-collected =
    { $count ->
        [one] Er is een sleutel gevonden, maar deze is nog niet geaccepteerd.
       *[other] Er zijn meerdere sleutels gevonden, maar er is er nog geen enkele geaccepteerd.
    }
openpgp-key-assistant-key-rejected = Deze sleutel is eerder afgewezen.
openpgp-key-assistant-key-accepted-other = Deze sleutel is eerder geaccepteerd voor een ander e-mailadres.
# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info = Online aanvullende of bijgewerkte sleutels ontdekken voor { $recipient }, of ze importeren uit een bestand.

## Discovery section

openpgp-key-assistant-discover-title = Online ontdekking bezig.
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = Sleutels ontdekken voor { $recipient }…
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-expired-key-update =
    Er is een update gevonden voor een van de eerder geaccepteerde sleutels voor { $recipient }.
    Deze kan nu worden gebruikt omdat hij niet langer verlopen is.

## Dialog buttons

openpgp-key-assistant-discover-online-button = Openbare sleutels online ontdekken…
openpgp-key-assistant-import-keys-button = Publieke sleutels importeren uit bestand…
openpgp-key-assistant-issue-resolve-button = Oplossen…
openpgp-key-assistant-view-key-button = Sleutel bekijken…
openpgp-key-assistant-recipients-show-button = Tonen
openpgp-key-assistant-recipients-hide-button = Verbergen
openpgp-key-assistant-cancel-button = Annuleren
openpgp-key-assistant-back-button = Terug
openpgp-key-assistant-accept-button = Accepteren
openpgp-key-assistant-close-button = Sluiten
openpgp-key-assistant-disable-button = Versleuteling uitschakelen
openpgp-key-assistant-confirm-button = Versleuteld verzenden
# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = gemaakt op { $datum }
