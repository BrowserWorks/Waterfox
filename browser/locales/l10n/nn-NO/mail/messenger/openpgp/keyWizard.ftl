# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Legg til ein personleg OpenPGP-nøkkel for { $identity }

key-wizard-button =
    .buttonlabelaccept = Fortset
    .buttonlabelhelp = Gå tilbake

key-wizard-warning = <b>Dersom du har ein eksisterende personleg nøkkel</b> for denne e-postadressa, bør du importere henne. Ellers har du ikkje tilgang til arkiva dine med krypterte e-postmeldingar, og du kan heller ikkje lese innkomande krypterte e-postar frå folk som enno brukar den eksisterande nøkkelen din.

key-wizard-learn-more = Les meir

radio-create-key =
    .label = Lag ein ny OpenPGP-nøkkel
    .accesskey = L

radio-import-key =
    .label = Importer ein eksisterande OpenPGP-nøkkel
    .accesskey = I

radio-gnupg-key =
    .label = Bruk den eksterne nøkkelen din gjennom GnuPG (t.d. frå eit smartkort)
    .accesskey = A

## Generate key section

openpgp-generate-key-title = Generer OpenPGP-nøkkel

openpgp-generate-key-info = <b>Nøkkelgenerering kan ta opptil fleie minutt å fullføre.</b> Ikkje avslutt applikasjonen når nøkkelgenereringa held på. Dersom du aktivt surfar eller utfører diskintensive operasjonar under nøkkelgenerering, vil det fylle opp «randomness pool»-et og gjere prosessen raskare. Du blir varsla når nøkkelgenereringa er fullført.

openpgp-keygen-expiry-title = Nøkkelen går ut

openpgp-keygen-expiry-description = Definer når den nyleg genererte nøkkelenen skal gå ut. Du kan seinare kontrollere datoen for å forlenge den om nødvendig.

radio-keygen-expiry =
    .label = Nøkkelen går ut om
    .accesskey = N

radio-keygen-no-expiry =
    .label = Nøkkelen går ikkje ut
    .accesskey = N

openpgp-keygen-days-label =
    .label = dagar
openpgp-keygen-months-label =
    .label = månadar
openpgp-keygen-years-label =
    .label = år

openpgp-keygen-advanced-title = Avanserte innstillingar

openpgp-keygen-advanced-description = Kontroller dei avanserte innstillingane for OpenPGP-nøkkelen din.

openpgp-keygen-keytype =
    .value = Nøkkeltype:
    .accesskey = t

openpgp-keygen-keysize =
    .value = Nøkkelstørrelse:
    .accesskey = s

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (elliptisk kurve)

openpgp-keygen-button = Generer nøkkel

openpgp-keygen-progress-title = Genererer den nye OpenPGP-nøkkelen din…

openpgp-keygen-import-progress-title = Importerer OpenPGP-nøklane dine…

openpgp-import-success = OpenPGP-nøklar er importerte!

openpgp-import-success-title = Fullfør importprosessen

openpgp-import-success-description = For å begynne å bruke den importerte OpenPGP-nøkkelen for e-postkryptering, lèt du att denne dialogboksen og opnar kontoinnstillingane for å velje han.

openpgp-keygen-confirm =
    .label = Stadfest

openpgp-keygen-dismiss =
    .label = Avbryt

openpgp-keygen-cancel =
    .label = Avbryt prosess…

openpgp-keygen-import-complete =
    .label = Lat att
    .accesskey = L

openpgp-keygen-missing-username = Det er ikkje spesifisert noko namn på gjeldande konto. Skriv inn ein verdi i feltet «Namnet ditt» i kontoinnstillingane.
openpgp-keygen-long-expiry = Du kan ikkje lage ein nøkkel som går ut seinare enn 100 år.
openpgp-keygen-short-expiry = Nøkkelen din må minst vere gyldig i ein dag.

openpgp-keygen-ongoing = Nøkkelgenerering er allereie i gang!

openpgp-keygen-error-core = Klarte ikkje å initialisere OpenPGP Core Service

openpgp-keygen-error-failed = OpenPGP-nøkkelgenerering feila uventa

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = OpenPGP-nøkkel laga, men klarte ikkje å få tilbakekalling for nøkkel { $key }

openpgp-keygen-abort-title = Avbryte nøkkelgenerering?
openpgp-keygen-abort = OpenPGP-nøkkelgenerering er no i framdrift, er du sikker på at du vil avbryte henne?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Generer ein offentleg og hemmeleg nøkkel for { $identity }?

## Import Key section

openpgp-import-key-title = Importer ein eksisterande personleg OpenPGP-nøkkel

openpgp-import-key-legend = Vel ei tidlegare sikkerheitskopiert fil.

openpgp-import-key-description = Du kan importere personlege nøklar som vart laga med ei anna OpenPGP-programvare.

openpgp-import-key-info = Anna programvare kan beskrive ein personleg nøkkel ved å bruke alternative termar som din eigen nøkkel, hemmeleg nøkkel, privat nøkkel eller nøkkelpar.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird fann ein nøkkel som kan importerast.
       *[other] Thunderbird fann { $count } nøklar som kan importerast.
    }

openpgp-import-key-list-description = Bekreft hvilke nøklar som kan behandles som dine personlige nøkler. Bare nøkler som du opprettet selv og som viser din egen identitet, skal brukes som personlige nøkler. Du kan endre dette alternativet senere i dialogboksen Nøkkelegenskaper.

openpgp-import-key-list-caption = Nøklar merkte for å bli behandla som personlege nøklar vil bli oppførte i avsnittet ende-til-ende-kryptering. Dei andre vil vere tilgjengelege i nøkkelhandteraren.

openpgp-passphrase-prompt-title = Passordfrase påkravd

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Skriv inn passordfrasa for å låse opp følgjande nøkkel: { $key }

openpgp-import-key-button =
    .label = Vel ei fil å importere…
    .accesskey = V

import-key-file = Importer OpenPGP-nøkkelfil

import-key-personal-checkbox =
    .label = Behandle denne nøkkelen som ein personleg nøkkel

gnupg-file = GnuPG-filer

import-error-file-size = <b>Feil!</b> Filer som er større enn 5 MB er ikkje støtta.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Feil!</b> Klarte ikkje å importere fila. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Feil!</b> Klarte ikkje å importere nøklar. { $error }

openpgp-import-identity-label = Identitet

openpgp-import-fingerprint-label = Fingeravtrykk

openpgp-import-created-label = Laga

openpgp-import-bits-label = Bit

openpgp-import-key-props =
    .label = Nøkkeleigenskapar
    .accesskey = N

## External Key section

openpgp-external-key-title = Ekstern GnuPG-nøkkel

openpgp-external-key-description = Konfigurer ein ekstern GnuPG-nøkkel ved å skrive inn nøkkel-ID

openpgp-external-key-info = I tillegg må du bruke nøkkelhandteraren for å importere og godta den tilsvareande offentlege nøkkelen.

openpgp-external-key-warning = <b>Du kan berre konfigurere ein ekstern GnuPG-nøkkel.</b> Den tidlegare oppføringa di vert erstatta.

openpgp-save-external-button = Lagre nøkkel-ID

openpgp-external-key-label = Hemmeleg nøkkel-ID:

openpgp-external-key-input =
    .placeholder = 123456789341298340
