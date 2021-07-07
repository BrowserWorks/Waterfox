# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Føj en personlig OpenPGP-nøgle til { $identity }

key-wizard-button =
    .buttonlabelaccept = Fortsæt
    .buttonlabelhelp = Gå tilbage

key-wizard-warning = <b>Hvis du har en eksisterende privat nøgle</b> til denne mailadresse, bør du importere den. Ellers vil du ikke have adgang til tidligere arkiverede krypterede mails, og du vil heller ikke kunne læse indkommende krypterede mails fra afsendere, der stadig benytter din eksisterende nøgle.

key-wizard-learn-more = Læs mere

radio-create-key =
    .label = Opret en ny OpenPGP-nøgle
    .accesskey = O

radio-import-key =
    .label = Importer en eksisterende OpenPGP-nøgle
    .accesskey = I

radio-gnupg-key =
    .label = Benyt din eksterne nøgle via GnuPG (fx fra et chipkort)
    .accesskey = B

## Generate key section

openpgp-generate-key-title = Generer OpenPGP-nøgle

openpgp-generate-key-info = <b>Nøglegenerering kan tage flere minutter.</b> Luk ikke programmet mens nøglegenereringen er i gang. Hvis du aktivt browser eller udfører diskintensive operationer, mens nøglegenereringen står på, fylder du ‘tilfældigheds-puljen’ op, hvilket får processen til at gå hurtigere. Du får besked, når nøglen er færdig.

openpgp-keygen-expiry-title = Nøgleudløb

openpgp-keygen-expiry-description = Angiv udløbsdatoen for din netop genererede nøgle. Du kan senere tjekke datoen og forlænge den, hvis det bliver nødvendigt.

radio-keygen-expiry =
    .label = Nøgle udløber om
    .accesskey = ø

radio-keygen-no-expiry =
    .label = Nøgle udløber ikke
    .accesskey = i

openpgp-keygen-days-label =
    .label = dage
openpgp-keygen-months-label =
    .label = måneder
openpgp-keygen-years-label =
    .label = år

openpgp-keygen-advanced-title = Avancerede indstillinger

openpgp-keygen-advanced-description = Kontroller de avancerede indstillinger for din OpenPGP-nøgle.

openpgp-keygen-keytype =
    .value = Nøgletype
    .accesskey = t

openpgp-keygen-keysize =
    .value = Nøglestørrelse:
    .accesskey = s

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (Elliptic Curve)

openpgp-keygen-button = Generer nøgle

openpgp-keygen-progress-title = Genererer din nye OpenPGP-nøgle…

openpgp-keygen-import-progress-title = Importerer dine OpenPGP-nøgler…

openpgp-import-success = OpenPGP-nøgler importeret!

openpgp-import-success-title = Færdiggør import

openpgp-import-success-description = For at begynde at bruge din importerede OpenPGP-nøgle til at kryptere mails, skal du lukke dette vindue og vælge den under Kontoindstillinger.

openpgp-keygen-confirm =
    .label = Bekræft

openpgp-keygen-dismiss =
    .label = Annuller

openpgp-keygen-cancel =
    .label = Annuller proces…

openpgp-keygen-import-complete =
    .label = Luk
    .accesskey = L

openpgp-keygen-missing-username = Der er ikke angivet et navn for denne konto. Indtast en værdi i feltet “Dit navn” i kontoindstillingerne.
openpgp-keygen-long-expiry = Du kan ikke oprette en nøgle, der udløber om mere end 100 år.
openpgp-keygen-short-expiry = Din nøgle skal være gyldig i mindst en dag.

openpgp-keygen-ongoing = Nøglegenerering er allerede i gang!

openpgp-keygen-error-core = Kunne ikke initialisere OpenPGP-kernetjenesten

openpgp-keygen-error-failed = OpenPGP-nøglegenerering mislykkedes uventet

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = OpenPGP-nøgle oprettet, men der kunne ikke skaffes en tilbagekaldelsesnøgle til nøglen { $key }

openpgp-keygen-abort-title = Afbryd nøglegenerering?
openpgp-keygen-abort = OpenPGP-nøglegenerering er i gang. Er du sikker på, du vil afbryde den?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Generer offentlig og hemmelig nøgle for { $identity }?

## Import Key section

openpgp-import-key-title = Importer en eksisterende, personlig OpenPGP-nøgle

openpgp-import-key-legend = Vælg en tidligere sikkerhedskopieret fil.

openpgp-import-key-description = Du kan importere personlige nøgler, der er oprettet med andre OpenPGP-programmer.

openpgp-import-key-info = Andre programmer bruger måske andre betegnelser for en personlig nøgle, fx. "din egen nøgle", "hemmelig nøgle", "privat nøgle" eller "nøglepar".

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird fandt én nøgle, der kan importeres.
       *[other] Thunderbird fandt { $count } nøgler, der kan importeres.
    }

openpgp-import-key-list-description = Bekræft hvilke nøgler, der kan betragtes som dine personlige nøgler. Du bør kun bruge nøgler, som du selv har oprettet, og som viser din identitet, som personlige nøgler. Du kan ændre denne indstilling senere under Nøgleegenskaber.

openpgp-import-key-list-caption = Nøgler der er markeret som personlige nøgler vil optræde i sektionen for end to end-kryptering. Øvrige nøgler vises under Nøgleadministration.

openpgp-passphrase-prompt-title = Adgangsudtryk påkrævet

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Indtast adgangsudtrykket for at låse følgende nøgle op: { $key }

openpgp-import-key-button =
    .label = Vælg fil til import…
    .accesskey = V

import-key-file = Importer OpenPGP-nøglefil

import-key-personal-checkbox =
    .label = Betragt denne nøgle som en personlig nøgle

gnupg-file = GnuPG-filer

import-error-file-size = <b>Fejl!</b> Filer over 5MB understøttes ikke.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Fejl!</b> Kunne ikke importere fil. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Fejl!</b> Kunne ikke importere nøgler. { $error }

openpgp-import-identity-label = Identitet

openpgp-import-fingerprint-label = Fingeraftryk

openpgp-import-created-label = Oprettet

openpgp-import-bits-label = Bits

openpgp-import-key-props =
    .label = Nøgleegenskaber
    .accesskey = N

## External Key section

openpgp-external-key-title = Ekstern GnuPG-nøgle

openpgp-external-key-description = Konfigurer en ekstern GnuPG-nøgle ved at angive dens nøgle-id

openpgp-external-key-info = Derudover skal du bruge Nøgleadministration til at importere og acceptere den tilsvarende offentlige nøgle.

openpgp-external-key-warning = <b>Du kan kun konfigurere én ekstern GnuPG-nøgle.</b> Den tidligere nøgle vil blive erstattet.

openpgp-save-external-button = Gem nøgle-id

openpgp-external-key-label = Hemmeligt nøgle-id:

openpgp-external-key-input =
    .placeholder = 123456789341298340
