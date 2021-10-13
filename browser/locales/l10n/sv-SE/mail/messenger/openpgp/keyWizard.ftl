# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Lägg till en personlig OpenPGP-nyckel för { $identity }

key-wizard-button =
    .buttonlabelaccept = Fortsätt
    .buttonlabelhelp = Gå tillbaka

key-wizard-warning = <b>Om du har en befintlig personlig nyckel</b> för den här e-postadressen, bör du importera den. Annars har du inte tillgång till dina arkiv med krypterade e-postmeddelanden och du kan inte heller läsa inkommande krypterade e-postmeddelanden från personer som fortfarande använder din befintliga nyckel.

key-wizard-learn-more = Läs mer

radio-create-key =
    .label = Skapa en ny OpenPGP-nyckel
    .accesskey = S

radio-import-key =
    .label = Importera en befintlig OpenPGP-nyckel
    .accesskey = m

radio-gnupg-key =
    .label = Använd din externa nyckel genom GnuPG (t.ex. från ett smartkort)
    .accesskey = A

## Generate key section

openpgp-generate-key-title = Generera OpenPGP-nyckel

openpgp-generate-key-info = <b>Nyckelgenerering kan ta upp till flera minuter att slutföra.</b> Avsluta inte applikationen medan nyckelgenerering pågår. Om du surfar eller utför en hårddiskaktivitet under nyckelgenerering kommer du att fylla på den "slumpmässiga poolen" och påskynda processen. Du får en varning när nyckelgenerering är klar.

openpgp-keygen-expiry-title = Nyckeln upphör

openpgp-keygen-expiry-description = Definiera giltighetstiden för din nyligen genererade nyckel. Du kan senare kontrollera datumet för att förlänga det vid behov.

radio-keygen-expiry =
    .label = Nyckeln upphör om
    .accesskey = N

radio-keygen-no-expiry =
    .label = Nyckeln upphör inte
    .accesskey = N

openpgp-keygen-days-label =
    .label = dagar
openpgp-keygen-months-label =
    .label = månader
openpgp-keygen-years-label =
    .label = år

openpgp-keygen-advanced-title = Avancerade inställningar

openpgp-keygen-advanced-description = Kontrollera de avancerade inställningarna för din OpenPGP-nyckel.

openpgp-keygen-keytype =
    .value = Nyckeltyp:
    .accesskey = t

openpgp-keygen-keysize =
    .value = Nyckelstorlek:
    .accesskey = s

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (elliptisk kurva)

openpgp-keygen-button = Generera nyckel

openpgp-keygen-progress-title = Genererar din nya OpenPGP-nyckel…

openpgp-keygen-import-progress-title = Importerar dina OpenPGP-nycklar…

openpgp-import-success = OpenPGP-nycklar har importerats!

openpgp-import-success-title = Slutför importprocessen

openpgp-import-success-description = För att börja använda din importerade OpenPGP-nyckel för kryptering av e-post stänger du den här dialogrutan och öppnar dina kontoinställningar för att välja den.

openpgp-keygen-confirm =
    .label = Bekräfta

openpgp-keygen-dismiss =
    .label = Avbryt

openpgp-keygen-cancel =
    .label = Avbryt process…

openpgp-keygen-import-complete =
    .label = Stäng
    .accesskey = S

openpgp-keygen-missing-username = Det finns inget namn angivet för det aktuella kontot. Ange ett värde i fältet "Ditt namn" i kontoinställningarna.
openpgp-keygen-long-expiry = Du kan inte skapa en nyckel som upphör senare än 100 år.
openpgp-keygen-short-expiry = Din nyckel måste vara giltig i minst en dag.

openpgp-keygen-ongoing = Nyckelgenerering pågår redan!

openpgp-keygen-error-core = Det går inte att initiera OpenPGP Core Service

openpgp-keygen-error-failed = OpenPGP-nyckelgenerering misslyckades oväntat

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = OpenPGP-nyckeln skapades framgångsrikt, men misslyckades med att få återkallelse för nyckeln { $key }

openpgp-keygen-abort-title = Avbryta nyckelgenerering?
openpgp-keygen-abort = OpenPGP-nyckelgenerering pågår för närvarande, är du säker på att du vill avbryta den?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Generera en publik och hemlig nyckel för { $identity }?

## Import Key section

openpgp-import-key-title = Importera en befintlig personlig OpenPGP-nyckel

openpgp-import-key-legend = Välj en tidigare säkerhetskopierad fil.

openpgp-import-key-description = Du kan importera personliga nycklar som skapades med annan OpenPGP-programvara.

openpgp-import-key-info = Annan programvara kan beskriva en personlig nyckel med alternativa termer som din egen nyckel, hemlig nyckel, privat nyckel eller nyckelpar.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird hittade en nyckel som kan importeras.
       *[other] Thunderbird hittade { $count } nycklar som kan importeras.
    }

openpgp-import-key-list-description = Bekräfta vilka nycklar som kan behandlas som dina personliga nycklar. Endast nycklar som du skapade själv och som visar din egen identitet bör användas som personliga nycklar. Du kan ändra det här alternativet senare i dialogrutan Nyckelegenskaper.

openpgp-import-key-list-caption = Nycklar markerade för att behandlas som personliga nycklar kommer att listas i avsnittet End-to-end kryptering. De andra kommer att finnas tillgängliga i Nyckelhanteraren.

openpgp-passphrase-prompt-title = Lösenfras krävs

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Ange lösenfrasen för att låsa upp följande nyckel: { $key }

openpgp-import-key-button =
    .label = Välj fil att importera...
    .accesskey = V

import-key-file = Importera OpenPGP-nyckelfil

import-key-personal-checkbox =
    .label = Behandla den här nyckeln som en personlig nyckel

gnupg-file = GnuPG-filer

import-error-file-size = <b>Fel!</b> Filer som är större än 5MB stöds inte.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Fel!</b> Det gick inte att importera filen. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Fel!</b> Det gick inte att importera nycklar. { $error }

openpgp-import-identity-label = Identitet

openpgp-import-fingerprint-label = Fingeravtryck

openpgp-import-created-label = Skapad

openpgp-import-bits-label = Bitar

openpgp-import-key-props =
    .label = Nyckelegenskaper
    .accesskey = N

## External Key section

openpgp-external-key-title = Extern GnuPG-nyckel

openpgp-external-key-description = Konfigurera en extern GnuPG-nyckel genom att ange nyckel-ID

openpgp-external-key-info = Dessutom måste du använda Nyckelhanteraren för att importera och acceptera motsvarande publika nyckel.

openpgp-external-key-warning = <b>Du får bara konfigurera en extern GnuPG-nyckel.</b> Din tidigare post kommer att ersättas.

openpgp-save-external-button = Spara nyckel-ID

openpgp-external-key-label = Hemligt nyckel-ID:

openpgp-external-key-input =
    .placeholder = 123456789341298340
