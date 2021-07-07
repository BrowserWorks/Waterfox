# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = t
#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] Berichtbeveiliging tonen (⌘ ⌥ { message-header-show-security-info-key })
           *[other] Berichtbeveiliging tonen (Ctrl+Alt+{ message-header-show-security-info-key })
        }
openpgp-view-signer-key =
    .label = Sleutel ondertekenaar bekijken
openpgp-view-your-encryption-key =
    .label = Uw ontsleutelingssleutel bekijken
openpgp-openpgp = OpenPGP
openpgp-no-sig = Geen digitale handtekening
openpgp-uncertain-sig = Onzekere digitale handtekening
openpgp-invalid-sig = Ongeldige digitale handtekening
openpgp-good-sig = Goede digitale handtekening
openpgp-sig-uncertain-no-key = Dit bericht bevat een digitale handtekening, maar het is onzeker of deze correct is. Om de handtekening te verifiëren, moet u een kopie van de publieke sleutel van de afzender verkrijgen.
openpgp-sig-uncertain-uid-mismatch = Dit bericht bevat een digitale handtekening, maar er is een verkeerde combinatie gedetecteerd. Het bericht is verzonden vanaf een e-mailadres dat niet overeenkomt met de publieke sleutel van de ondertekenaar.
openpgp-sig-uncertain-not-accepted = Dit bericht bevat een digitale handtekening, maar u hebt nog niet besloten of de sleutel van de ondertekenaar acceptabel voor u is.
openpgp-sig-invalid-rejected = Dit bericht bevat een digitale handtekening, maar u hebt eerder besloten de sleutel van de ondertekenaar te weigeren.
openpgp-sig-invalid-technical-problem = Dit bericht bevat een digitale handtekening, maar er is een technische fout gedetecteerd. Het bericht is beschadigd of het bericht is door iemand anders gewijzigd.
openpgp-sig-valid-unverified = Dit bericht bevat een geldige digitale handtekening van een sleutel die u al hebt geaccepteerd. U hebt echter nog niet geverifieerd dat de sleutel daadwerkelijk van de afzender is.
openpgp-sig-valid-verified = Dit bericht bevat een geldige digitale handtekening van een geverifieerde sleutel.
openpgp-sig-valid-own-key = Dit bericht bevat een geldige digitale handtekening van uw persoonlijke sleutel.
openpgp-sig-key-id = Sleutel-ID ondertekenaar: { $key }
openpgp-sig-key-id-with-subkey-id = Sleutel-ID ondertekenaar: { $key } (subsleutel-ID: { $subkey })
openpgp-enc-key-id = Uw ontsleutelingssleutel-ID: { $key }
openpgp-enc-key-with-subkey-id = Uw ontsleutelingssleutel-ID: { $key } (subsleutel-ID: { $subkey })
openpgp-unknown-key-id = Onbekende sleutel
openpgp-other-enc-additional-key-ids = Daarnaast is het bericht versleuteld naar de eigenaren van de volgende sleutels:
openpgp-other-enc-all-key-ids = Het bericht is versleuteld naar de eigenaren van de volgende sleutels:
openpgp-message-header-encrypted-ok-icon =
    .alt = Met succes ontsleuteld
openpgp-message-header-encrypted-notok-icon =
    .alt = Ontsleutelen mislukt
openpgp-message-header-signed-ok-icon =
    .alt = Goede handtekening
# Mismatch icon is used for notok state as well
openpgp-message-header-signed-mismatch-icon =
    .alt = Slechte handtekening
openpgp-message-header-signed-unknown-icon =
    .alt = Onbekende handtekeningstatus
openpgp-message-header-signed-verified-icon =
    .alt = Geverifieerde handtekening
openpgp-message-header-signed-unverified-icon =
    .alt = Niet-geverifieerde handtekening
