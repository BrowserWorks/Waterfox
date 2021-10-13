# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Een persoonlijke OpenPGP-sleutel voor { $identity } toevoegen

key-wizard-button =
    .buttonlabelaccept = Doorgaan
    .buttonlabelhelp = Terug

key-wizard-warning = <b>Als u een bestaande persoonlijke sleutel hebt</b> voor dit e-mailadres, dan moet u deze importeren. Anders hebt u geen toegang tot uw archieven met versleutelde e-mailberichten en kunt u geen inkomende versleutelde e-mailberichten van mensen die uw bestaande sleutel nog steeds gebruiken lezen.

key-wizard-learn-more = Meer info

radio-create-key =
    .label = Een nieuwe OpenPGP-sleutel maken
    .accesskey = m

radio-import-key =
    .label = Een bestaande OpenPGP-sleutel importeren
    .accesskey = i

radio-gnupg-key =
    .label = Uw externe sleutel via GnuPG (b.v. vanaf een smartcard) gebruiken
    .accesskey = U

## Generate key section

openpgp-generate-key-title = OpenPGP-sleutel aanmaken

openpgp-generate-key-info = <b>Het aanmaken van een sleutel kan enkele minuten duren.</b> Sluit de toepassing niet af terwijl de sleutel wordt aangemaakt. Actief navigeren of schijfintensieve bewerkingen uitvoeren tijdens het aanmaken van de sleutel zal de ‘willekeurigheidspool’ aanvullen en het proces versnellen. U wordt gewaarschuwd wanneer het aanmaken van de sleutel is voltooid.

openpgp-keygen-expiry-title = Geldigheidsduur sleutel

openpgp-keygen-expiry-description = Definieer de geldigheidsduur van uw nieuw aangemaakte sleutel. U kunt later de datum aanpassen om deze indien nodig te verlengen.

radio-keygen-expiry =
    .label = Sleutel vervalt over
    .accesskey = e

radio-keygen-no-expiry =
    .label = Sleutel vervalt niet
    .accesskey = n

openpgp-keygen-days-label =
    .label = dagen
openpgp-keygen-months-label =
    .label = maanden
openpgp-keygen-years-label =
    .label = jaar

openpgp-keygen-advanced-title = Geavanceerde instellingen

openpgp-keygen-advanced-description = De geavanceerde instellingen van uw OpenPGP-sleutel beheren.

openpgp-keygen-keytype =
    .value = Sleuteltype:
    .accesskey = t

openpgp-keygen-keysize =
    .value = Sleutelgrootte:
    .accesskey = g

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (Elliptische Curve)

openpgp-keygen-button = Sleutel aanmaken

openpgp-keygen-progress-title = Uw nieuwe OpenPGP-sleutel wordt aangemaakt…

openpgp-keygen-import-progress-title = Uw OpenPGP-sleutels importeren…

openpgp-import-success = OpenPGP-sleutels met succes geïmporteerd!

openpgp-import-success-title = Het importproces voltooien

openpgp-import-success-description = Om uw geïmporteerde OpenPGP-sleutel voor het versleutelen van e-mail te gaan gebruiken, dient u dit dialoogvenster te sluiten en naar uw accountinstellingen te gaan om de sleutel te selecteren.

openpgp-keygen-confirm =
    .label = Bevestigen

openpgp-keygen-dismiss =
    .label = Annuleren

openpgp-keygen-cancel =
    .label = Proces annuleren…

openpgp-keygen-import-complete =
    .label = Sluiten
    .accesskey = S

openpgp-keygen-missing-username = Er is geen naam voor de huidige account opgegeven. Voer in de accountinstellingen een waarde in in het veld ‘Uw naam’.
openpgp-keygen-long-expiry = U kunt geen sleutel aanmaken die over meer dan 100 jaar verloopt.
openpgp-keygen-short-expiry = Uw sleutel moet ten minste een dag geldig zijn.

openpgp-keygen-ongoing = Er wordt al een sleutel aangemaakt!

openpgp-keygen-error-core = Kan OpenPGP Core Service niet initialiseren

openpgp-keygen-error-failed = Het aanmaken van de OpenPGP-sleutel is onverwacht mislukt

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = De OpenPGP-sleutel is met succes aangemaakt, maar de intrekking voor sleutel { $key } kon niet verkregen worden

openpgp-keygen-abort-title = Aanmaken sleutel afbreken?
openpgp-keygen-abort = Er wordt momenteel een OpenPGP-sleutel aangemaakt, weet u zeker dat u dit wilt annuleren?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Publieke en geheime sleutel voor { $identity } aanmaken?

## Import Key section

openpgp-import-key-title = Een bestaande persoonlijke OpenPGP-sleutel importeren

openpgp-import-key-legend = Selecteer een eerder reservekopiebestand.

openpgp-import-key-description = U kunt persoonlijke sleutels die zijn aangemaakt met andere OpenPGP-software importeren.

openpgp-import-key-info = Andere software beschrijft een persoonlijke sleutel mogelijk met alternatieve termen, zoals uw eigen sleutel, geheime sleutel, privésleutel of sleutelpaar.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird heeft een sleutel gevonden die kan worden geïmporteerd.
       *[other] Thunderbird heeft { $count } sleutels gevonden die kunnen worden geïmporteerd.
    }

openpgp-import-key-list-description = Bevestig welke sleutels mogen worden behandeld als persoonlijke sleutels. Alleen sleutels die u zelf hebt aangemaakt en uw eigen identiteit tonen mogen als persoonlijke sleutels worden gebruikt. U kunt deze optie later wijzigen in het dialoogvenster Sleuteleigenschappen.

openpgp-import-key-list-caption = Sleutels die worden gemarkeerd om als persoonlijke sleutels te worden behandeld, worden vermeld in de sectie End-to-end-versleuteling. De overige zijn beschikbaar in de Sleutelbeheerder.

openpgp-passphrase-prompt-title = Wachtwoordzin vereist

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Voer de wachtwoordzin in om de volgende sleutel te ontgrendelen: { $key }

openpgp-import-key-button =
    .label = Selecteer te importeren bestand…
    .accesskey = S

import-key-file = OpenPGP-sleutelbestand importeren

import-key-personal-checkbox =
    .label = Deze sleutel als een persoonlijke sleutel behandelen

gnupg-file = GnuPG-bestanden

import-error-file-size = <b>Fout!</b> Bestanden groter dan 5 MB worden niet ondersteund.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Fout!</b> Kon bestand niet importeren. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Fout!</b> Kon sleutels niet importeren. { $error }

openpgp-import-identity-label = Identiteit

openpgp-import-fingerprint-label = Vingerafdruk

openpgp-import-created-label = Aangemaakt

openpgp-import-bits-label = Bits

openpgp-import-key-props =
    .label = Sleuteleigenschappen
    .accesskey = S

## External Key section

openpgp-external-key-title = Externe GnuPG-sleutel

openpgp-external-key-description = Configureer een externe GnuPG-sleutel door de sleutel-ID in te voeren

openpgp-external-key-info = Daarnaast moet u Sleutelbeheerder gebruiken om de bijbehorende publieke sleutel te importeren en te accepteren.

openpgp-external-key-warning = <b>U mag slechts een externe GnuPG-sleutel configureren.</b> Uw vorige ingave wordt vervangen.

openpgp-save-external-button = Sleutel-ID opslaan

openpgp-external-key-label = Geheime sleutel-ID:

openpgp-external-key-input =
    .placeholder = 123456789341298340
