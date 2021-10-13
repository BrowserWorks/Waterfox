
# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = For at sende krypterede eller digitalt signerede meddelelser, skal du konfigurere en krypteringsteknologi, enten OpenPGP eller S/MIME.
e2e-intro-description-more = Vælg din personlige nøgle for at aktivere brugen af OpenPGP, eller dit personlige certifikat for at aktivere brugen af S/MIME. Du ejer selv den tilsvarende hemmelige nøgle til en personlig nøgle eller et certifikat.
e2e-advanced-section = Avancerede indstillinger
e2e-attach-key =
    .label = Vedhæft min offentlige nøgle, når jeg tilføjer en OpenPGP digital signatur
    .accesskey = f
e2e-encrypt-subject =
    .label = Krypter OpenPGP-meddelelsers emne
    .accesskey = K
e2e-encrypt-drafts =
    .label = Opbevar meddelelseskladder i krypteret format
    .accesskey = O

openpgp-key-user-id-label = Konto / bruger-id
openpgp-keygen-title-label =
    .title = Generer OpenPGP-nøgle
openpgp-cancel-key =
    .label = Fortryd
    .tooltiptext = Fortryd nøglegenerering
openpgp-key-gen-expiry-title =
    .label = Nøgleudløb
openpgp-key-gen-expire-label = Nøgle udløber om
openpgp-key-gen-days-label =
    .label = dage
openpgp-key-gen-months-label =
    .label = måneder
openpgp-key-gen-years-label =
    .label = år
openpgp-key-gen-no-expiry-label =
    .label = Nøglen udløber ikke
openpgp-key-gen-key-size-label = Nøglestørrelse
openpgp-key-gen-console-label = Nøglegenerering
openpgp-key-gen-key-type-label = Nøgletype
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (Elliptic Curve)
openpgp-generate-key =
    .label = Generer nøgle
    .tooltiptext = Genererer en ny OpenPGP-kompatibel nøgle til kryptering og/eller signering
openpgp-advanced-prefs-button-label =
    .label = Avanceret…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">OBS: Nøglegenerering kan tage flere minutter.</a> Luk ikke programmet mens nøglegenereringen er i gang. Hvis du aktivt browser eller udfører diskintensive operationer, mens nøglegenereringen står på, fylder du ‘tilfældigheds-puljen’ op, hvilket får processen til at gå hurtigere. Du får besked, når nøglen er færdig.

openpgp-key-expiry-label =
    .label = Udløbsdato

openpgp-key-id-label =
    .label = Nøgle-id

openpgp-cannot-change-expiry = Dette er en nøgle med en kompleks struktur. Ændring af udløbsdato understøttes ikke.

openpgp-key-man-title =
    .title = OpenPGP Nøgleadministration
openpgp-key-man-generate =
    .label = Nye nøglepar
    .accesskey = p
openpgp-key-man-gen-revoke =
    .label = Tilbagekaldelsescertifikat
    .accesskey = T
openpgp-key-man-ctx-gen-revoke-label =
    .label = Generer & gem tilbagekaldelsescertifikat

openpgp-key-man-file-menu =
    .label = Fil
    .accesskey = F
openpgp-key-man-edit-menu =
    .label = Rediger
    .accesskey = R
openpgp-key-man-view-menu =
    .label = Vis
    .accesskey = V
openpgp-key-man-generate-menu =
    .label = Generer
    .accesskey = G
openpgp-key-man-keyserver-menu =
    .label = Nøgleserver
    .accesskey = N

openpgp-key-man-import-public-from-file =
    .label = Importer offentlig(e) nøgle(r) fra fil
    .accesskey = I
openpgp-key-man-import-secret-from-file =
    .label = Importer hemmelig(e) nøgle(r) fra fil
openpgp-key-man-import-sig-from-file =
    .label = Importer tilbagekaldelse(r) fra fil
openpgp-key-man-import-from-clipbrd =
    .label = Importer nøgle(r) fra udklipsholderen
    .accesskey = I
openpgp-key-man-import-from-url =
    .label = Importer nøgle(r) fra URL
    .accesskey = U
openpgp-key-man-export-to-file =
    .label = Eksporter offentlig(e) nøgle(r) til fil
    .accesskey = E
openpgp-key-man-send-keys =
    .label = Send offentlig(e) nøgle(r) via mail
    .accesskey = S
openpgp-key-man-backup-secret-keys =
    .label = Sikkerhedskopier hemmelig(e) nøgle(r) til fil
    .accesskey = h

openpgp-key-man-discover-cmd =
    .label = Find nøgler online
    .accesskey = F
openpgp-key-man-discover-prompt = For at finde OpenPGP-nøgler online, enten på nøgleservere eller ved hjælp af WKD-protokollen, skal du indtaste en mailadresse eller et nøgle-id.
openpgp-key-man-discover-progress = Søger…

openpgp-key-copy-key =
    .label = Kopier offentlig nøgle
    .accesskey = K

openpgp-key-export-key =
    .label = Eksporter offentlig nøgle til fil
    .accesskey = E

openpgp-key-backup-key =
    .label = Sikkerhedskopier hemmelig nøgle til fil
    .accesskey = h

openpgp-key-send-key =
    .label = Send offentlig nøgle via mail
    .accesskey = S

openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
            [one] Kopier nøgle-id til udklipsholderen
           *[other] Kopier nøgle-id'er til udklipsholderen
        }
    .accesskey = n

openpgp-key-man-copy-fprs =
    .label =
        { $count ->
            [one] Kopier fingeraftryk til udklipsholderen
           *[other] Kopier fingeraftryk til udklipsholderen
        }
    .accesskey = F

openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
            [one] Kopier offentlig nøgle til udklipsholderen
           *[other] Kopier offentlige nøgler til udklipsholderen
        }
    .accesskey = O

openpgp-key-man-ctx-expor-to-file-label =
    .label = Eksporter nøgler til fil

openpgp-key-man-ctx-copy =
    .label = Kopier
    .accesskey = K

openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
            [one] Fingeraftryk
           *[other] Fingeraftryk
        }
    .accesskey = F

openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
            [one] Nøgle-id
           *[other] Nøgle-id'er
        }
    .accesskey = N

openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
            [one] Offentlig nøgle
           *[other] Offentlige nøgler
        }
    .accesskey = O

openpgp-key-man-close =
    .label = Luk
openpgp-key-man-reload =
    .label = Genindlæs nøglecache
    .accesskey = G
openpgp-key-man-change-expiry =
    .label = Rediger udløbsdato
    .accesskey = e
openpgp-key-man-del-key =
    .label = Slet nøgle(r)
    .accesskey = l
openpgp-delete-key =
    .label = Slet nøgle
    .accesskey = l
openpgp-key-man-revoke-key =
    .label = Tilbagekald nøgle
    .accesskey = T
openpgp-key-man-key-props =
    .label = Nøgleegenskaber
    .accesskey = N
openpgp-key-man-key-more =
    .label = Mere
    .accesskey = M
openpgp-key-man-view-photo =
    .label = Billed-id
    .accesskey = B
openpgp-key-man-ctx-view-photo-label =
    .label = Vis billed-id
openpgp-key-man-show-invalid-keys =
    .label = Vis ugyldige nøgler
    .accesskey = V
openpgp-key-man-show-others-keys =
    .label = Vis nøgler fra andre personer
    .accesskey = A
openpgp-key-man-user-id-label =
    .label = Navn
openpgp-key-man-fingerprint-label =
    .label = Fingeraftryk
openpgp-key-man-select-all =
    .label = Vælg alle nøgler
    .accesskey = A
openpgp-key-man-empty-tree-tooltip =
    .label = Indtast søgeudtryk i feltet ovenfor
openpgp-key-man-nothing-found-tooltip =
    .label = Ingen nøgler matcher dine søgeudtryk
openpgp-key-man-please-wait-tooltip =
    .label = Vent mens nøglerne indlæses ...

openpgp-key-man-filter-label =
    .placeholder = Søg efter nøgler

openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I

openpgp-key-details-title =
    .title = Nøgleegenskaber
openpgp-key-details-signatures-tab =
    .label = Certificeringer
openpgp-key-details-structure-tab =
    .label = Struktur
openpgp-key-details-uid-certified-col =
    .label = Bruger-id / Certificeret af
openpgp-key-details-user-id2-label = Angivet nøgleejer
openpgp-key-details-id-label =
    .label = Id
openpgp-key-details-key-type-label = Type
openpgp-key-details-key-part-label =
    .label = Nøgledel
openpgp-key-details-algorithm-label =
    .label = Algoritme
openpgp-key-details-size-label =
    .label = Størrelse
openpgp-key-details-created-label =
    .label = Oprettet
openpgp-key-details-created-header = Oprettet
openpgp-key-details-expiry-label =
    .label = Udløb
openpgp-key-details-expiry-header = Udløb
openpgp-key-details-usage-label =
    .label = Brug
openpgp-key-details-fingerprint-label = Fingeraftryk
openpgp-key-details-sel-action =
    .label = Vælg handling...
    .accesskey = V
openpgp-key-details-also-known-label = Nøgleejerens angivne alternative identiteter:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Luk
openpgp-acceptance-label =
    .label = Din accept
openpgp-acceptance-rejected-label =
    .label = Nej, afvis denne nøgle.
openpgp-acceptance-undecided-label =
    .label = Ikke endnu, måske senere.
openpgp-acceptance-unverified-label =
    .label = Ja, men jeg har ikke verificeret, at det er den rigtige nøgle.
openpgp-acceptance-verified-label =
    .label = Ja, jeg har personligt bekræftet, at denne nøgle har det rigtige fingeraftryk.
key-accept-personal =
    Til denne nøgle har du både den offentlige og den hemmelige del. Du kan bruge den som en personlig nøgle.
    Hvis du har fået denne nøgle af en anden, skal du ikke bruge den som en personlig nøgle.
key-personal-warning = Oprettede du selv denne nøgle, og henviser det viste nøgleejerskab til dig selv?
openpgp-personal-no-label =
    .label = Nej, brug den ikke som min personlige nøgle.
openpgp-personal-yes-label =
    .label = Ja, behandl denne nøgle som en personlig nøgle.

openpgp-copy-cmd-label =
    .label = Kopier

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbird har ingen personlig OpenPGP-nøgle for <b>{ $identity }</b>
        [one] Thunderbird fandt { $count } personlig OpenPGP-nøgle knyttet til <b>{ $identity }</b>
       *[other] Thunderbird fandt { $count } personlige OpenPGP-nøgler knyttet til <b>{ $identity }</b>
    }

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-have-key = Din nuværende konfiguration bruger nøgle-id <b>{ $key }</b>

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Din nuværende konfiguration bruger nøglen <b>{ $key }</b>, som er udløbet.

openpgp-add-key-button =
    .label = Tilføj nøgle...
    .accesskey = T

e2e-learn-more = Læs mere

openpgp-keygen-success = OpenPGP-nøgle oprettet!

openpgp-keygen-import-success = OpenPGP-nøgler importeret!

openpgp-keygen-external-success = Eksternt GnuPG-nøgle-id gemt!

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Ingen

openpgp-radio-none-desc = Benyt ikke OpenPGP til denne identitet.

openpgp-radio-key-not-usable = Denne nøgle kan ikke bruges som en personlig nøgle, fordi den hemmelige nøgle mangler!
openpgp-radio-key-not-accepted = For at bruge denne nøgle, skal du godkende den som en personlig nøgle!
openpgp-radio-key-not-found = Denne nøgle kunne ikke findes! Hvis du vil bruge den, skal du importere den til { -brand-short-name }.

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Udløber den: { $date }

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Udløb den: { $date }

openpgp-key-expires-within-6-months-icon =
    .title = Nøglen udløber om mindre end 6 måneder

openpgp-key-has-expired-icon =
    .title = Nøgle udløbet

openpgp-key-expand-section =
    .tooltiptext = Flere oplysninger

openpgp-key-revoke-title = Tilbagekald nøgle

openpgp-key-edit-title = Skift OpenPGP-nøgle

openpgp-key-edit-date-title = Forlæng udløbsdato

openpgp-manager-description = Brug OpenPGP Nøgleaministration for at se og administrere offentlige nøgler fra dine korrespondenter og alle andre nøgler, der ikke er anført ovenfor.

openpgp-manager-button =
    .label = OpenPGP Nøgleadministration
    .accesskey = N

openpgp-key-remove-external =
    .label = Fjern eksternt nøgle-id
    .accesskey = E

key-external-label = Ekstern GnuPG-nøgle

# Strings in keyDetailsDlg.xhtml
key-type-public = offentlig nøgle
key-type-primary = primærnøgle
key-type-subkey = undernøgle
key-type-pair = nøglepar (hemmelig nøgle og offentlig nøgle)
key-expiry-never = aldrig
key-usage-encrypt = Krypter
key-usage-sign = Signer
key-usage-certify = Certificer
key-usage-authentication = Godkendelse
key-does-not-expire = Nøglen udløber ikke
key-expired-date = Nøglen udløb den { $keyExpiry }
key-expired-simple = Nøglen er udløbet
key-revoked-simple = Nøglen er blevet tilbagekaldt
key-do-you-accept = Accepterer du, at denne nøgle bruges til verificering af digitale signaturer og kryptering af meddelelser?
key-accept-warning = Undgå at acceptere en uberegnelig nøgle. Brug en anden kommunikationskanal end mail til at bekræfte fingeraftrykket på din korrespondents nøgle.

# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Kunne ikke sende meddelelsen, fordi der er et problem med din personlige nøgle. { $problem }
cannot-encrypt-because-missing = Kunne ikke sende denne meddelelse med end to end-kryptering, fordi der er problemer med nøglerne for følgende modtagere: { $problem }
window-locked = Skrivevinduet er låst; afsendelse annulleret

# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Krypteret meddelelsesdel
mime-decrypt-encrypted-part-concealed-data = Dette er en krypteret meddelelsesdel. Du skal åbne det i et separat vindue ved at klikke på den vedhæftede fil.

# Strings in keyserver.jsm
keyserver-error-aborted = Afbrudt
keyserver-error-unknown = Der opstod en ukendt fejl
keyserver-error-server-error = Nøgleserveren rapporterede en fejl.
keyserver-error-import-error = Kunne ikke importere den downloadede nøgle.
keyserver-error-unavailable = Nøgleserveren er ikke tilgængelig.
keyserver-error-security-error = Nøgleserveren understøtter ikke krypteret adgang.
keyserver-error-certificate-error = Nøgleserverens certifikat er ikke gyldigt.
keyserver-error-unsupported = Nøgleserveren understøttes ikke.

# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Din mailudbyder behandlede din anmodning om at uploade din offentlige nøgle til OpenPGP Web Key Directory.
    Bekræft for at fuldføre udgivelsen af din offentlige nøgle.
wkd-message-body-process =
    Denne mail er relateret til den den automatiske procedure for upload af din offentlige nøgle til OpenPGP Web Key Directory.
    Du behøver ikke at foretage dig noget på nuværende tidspunkt.

# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Kunne ikke dekryptere meddelelsen med emnet
    { $subject }.
    Vil du prøve igen med et andet adgangsudtryk, eller vil du springe meddelelsen over?

# Strings in gpg.jsm
unknown-signing-alg = Ukendt signeringsalgoritme (ID: { $id })
unknown-hash-alg = Ukendt kryptografisk hash (ID: { $id })

# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Din nøgle { $desc } udløber om mindre end { $days } dage.
    Vi anbefaler, at du opretter et nyt nøglepar og indstiller de tilsvarende konti til at bruge det.
expiry-keys-expire-soon =
    De følgende af dine nøgler udløber om mindre end { $days } dage: { $desc }.
    Vi anbefaler, at du opretter nye nøgler og indstiller de tilsvarende konti til at bruge dem.
expiry-key-missing-owner-trust =
    Din hemmelige nøgle { $desc } har manglende tillid.
    Vi anbefaler, at du sætter "Du stoler på certificeringer" til "ultimativ" i nøgleegenskaber.
expiry-keys-missing-owner-trust =
    De følgende af dine hemmelige nøgler har manglende tillid.
    { $desc }.
    Vi anbefaler, at du indstiller "Du stoler på certificeringer" til "ultimativ" i nøgleegenskaber.
expiry-open-key-manager = Åbn OpenPGP Nøgleadministration
expiry-open-key-properties = Åbn nøgleegenskaber

# Strings filters.jsm
filter-folder-required = Du skal vælge en destinationsmappe.
filter-decrypt-move-warn-experimental =
    Advarsel - filterhandlingen "Dekrypter permanent" kan føre til ødelagte meddelelser.
    Vi anbefaler kraftigt, at du først prøver filteret "Opret dekrypteret kopi", tester resultatet omhyggeligt og først begynder at bruge dette filter, når du er tilfreds med resultatet.
filter-term-pgpencrypted-label = OpenPGP-krypteret
filter-key-required = Du skal vælge en modtagernøgle.
filter-key-not-found = Kunne ikke finde en krypteringsnøgle til ‘{ $desc }’.
filter-warn-key-not-secret =
    Advarsel - filterhandlingen "Krypter til nøgle" erstatter modtagerne.
    Hvis du ikke har den hemmelige nøgle til '{ $desc }', kan du ikke længere læse disse mails.

# Strings filtersWrapper.jsm
filter-decrypt-move-label = Dekrypter permanent (OpenPGP)
filter-decrypt-copy-label = Opret dekrypteret kopi (OpenPGP)
filter-encrypt-label = Krypter til nøgle (OpenPGP)

# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Succes! Nøgler importeret
import-info-bits = Bits
import-info-created = Oprettet
import-info-fpr = Fingeraftryk
import-info-details = Se detaljer og administrer nøgleaccept
import-info-no-keys = Ingen nøgler importeret.

# Strings in enigmailKeyManager.js
import-from-clip = Vil du importere nøgler fra udklipsholderen?
import-from-url = Download offentlig nøgle fra denne URL:
copy-to-clipbrd-failed = Kunne ikke kopiere de(n) valgte nøgle(r) til udklipsholderen.
copy-to-clipbrd-ok = Nøgle(r) kopieret til udklipsholder
delete-secret-key =
    ADVARSEL: Du er ved at slette en hemmelig nøgle!
    
    Hvis du sletter din hemmelige nøgle, vil du ikke længere kunne dekryptere meddelelser, der er krypteret til den nøgle, og du vil heller ikke kunne tilbagekalde den.
    
    Vil du virkelig slette BÅDE den hemmelige nøgle og den offentlige nøgle
    '{ $userId }'?
delete-mix =
    ADVARSEL: Du er ved at slette hemmelige nøgler!
    Hvis du sletter din hemmelige nøgle, vil du ikke længere kunne dekryptere meddelelser, der er krypteret til den nøgle.
    Vil du virkelig slette BÅDE den valgte hemmelige og offentlige nøgle?
delete-pub-key =
    Vil du slette den offentlige nøgle
    '{ $userId }'?
delete-selected-pub-key = Vil du slette de offentlige nøgler?
refresh-all-question = Du valgte ikke nogen nøgle. Vil du opdatere ALLE nøgler?
key-man-button-export-sec-key = Eksporter &hemmelige nøgler
key-man-button-export-pub-key = Eksporter kun &offentlige nøgler
key-man-button-refresh-all = &Opdater alle nøgler
key-man-loading-keys = Indlæser nøgler, vent venligst...
ascii-armor-file = ASCII Armored-filer (*.asc)
no-key-selected = Du skal vælge mindst én nøgle for at udføre den valgte handling
export-to-file = Eksporter offentlig nøgle til fil
export-keypair-to-file = Eksporter hemmelig og offentlig nøgle til fil
export-secret-key = Vil du medtage den hemmelige nøgle i den gemte OpenPGP-nøglefil?
save-keys-ok = Nøglerne blev gemt korrekt.
save-keys-failed = Kunne ikke gemme nøglerne
default-pub-key-filename = Eksporterede-offentlige-nøgler
default-pub-sec-key-filename = Sikkerhedskopi-af-hemmelige-nøgler
refresh-key-warn = Advarsel: Afhængigt af antallet af nøgler og din forbindelseshastighed, kan opdatering af alle nøgler tage ganske lang tid!
preview-failed = Kan ikke læse den offentlige nøglefil.
general-error = Fejl: { $reason }
dlg-button-delete = &Slet

## Account settings export output

openpgp-export-public-success = <b>Offentlig nøgle eksporteret!</b>
openpgp-export-public-fail = <b>Den valgte offentlige nøgle kunne ikke eksporteres!</b>

openpgp-export-secret-success = <b>Hemmelig nøgle blev eksporteret!</b>
openpgp-export-secret-fail = <b>Den valgte hemmelige nøgle kunne ikke eksporteres!</b>

# Strings in keyObj.jsm
key-ring-pub-key-revoked = Nøglen { $userId } (nøgle-id { $keyId }) er tilbagekaldt.
key-ring-pub-key-expired = Nøglen { $userId } (nøgle-id { $keyId }) er udløbet.
key-ring-no-secret-key = Det ser ikke ud til, at du har den hemmelige nøgle til { $userId } (nøgle-id { $keyId }) på din nøglering; du kan ikke bruge nøglen til signering.
key-ring-pub-key-not-for-signing = Nøglen { $userId } (nøgle-id { $keyId }) kan ikke bruges til signering.
key-ring-pub-key-not-for-encryption = Nøglen { $userId } (nøgle-id { $keyId }) kan ikke bruges til kryptering.
key-ring-sign-sub-keys-revoked = Alle signeringsundernøgler på nøglen { $userId } (nøgle-id { $keyId }) er tilbagekaldt.
key-ring-sign-sub-keys-expired = Alle signeringsundernøgler på nøglen { $userId } (nøgle-id { $keyId }) er udløbet.
key-ring-enc-sub-keys-revoked = Alle krypteringsundernøgler på nøglen { $userId } (nøgle-id { $keyId }) er tilbagekaldt.
key-ring-enc-sub-keys-expired = Alle krypteringsundernøgler på nøglen { $userId } (nøgle-id { $keyId }) er udløbet.

# Strings in gnupg-keylist.jsm
keyring-photo = Billede
user-att-photo = Brugerattribut (JPEG-billede)

# Strings in key.jsm
already-revoked = Denne nøgle er allerede blevet tilbagekaldt.

#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Du er ved at tilbagekalde nøglen '{ $identity }'.
    Du vil ikke længere kunne underskrive med denne nøgle, og når den er distribueret, kan andre ikke længere kryptere med den nøgle. Du kan stadig bruge nøglen til at dekryptere gamle meddelelser.
    Ønsker du at fortsætte?

#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    Du har ingen nøgle (0x { $keyId }), der matcher dette tilbagekaldelsescertifikat!
    Hvis du har mistet din nøgle, skal du importere den (fx fra en nøgleserver), inden du importerer tilbagekaldelsescertifikatet!

#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = Nøglen 0x{ $keyId } er allerede tilbagekaldt.

key-man-button-revoke-key = &Tilbagekald nøgle

openpgp-key-revoke-success = Nøglen blev tilbagekaldt.

after-revoke-info =
    Nøglen er blevet tilbagekaldt.
    Del denne offentlige nøgle igen ved at sende den via mail eller ved at uploade den til nøgleservere for at fortælle andre, at du har tilbagekaldt din nøgle.
    Så andre personers programmer registrerer tilbagekaldelsen, stopper de med at bruge din gamle nøgle.
    Hvis du bruger en ny nøgle til den samme mailadresse, og du vedhæfter den nye offentlige nøgle til mails, du sender, inkluderes oplysninger om din tilbagekaldte gamle nøgle automatisk.

# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Importer

delete-key-title = Slet OpenPGP-nøgle

delete-external-key-title = Fjern den eksterne GnuPG-nøgle

delete-external-key-description = Ønsker du at fjerne dette eksterne GnuPG-nøgle-id?

key-in-use-title = OpenPGP-nøgle i brug

delete-key-in-use-description = Kan ikke fortsætte! Den nøgle, du vil slette, bruges i øjeblikket af denne identitet. Vælg en anden nøgle, eller vælg ingen og prøv igen.

revoke-key-in-use-description = Kan ikke fortsætte! Den nøgle, du vil tilbagekalde, bruges i øjeblikket af denne identitet. Vælg en anden nøgle, eller vælg ingen og prøv igen.

# Strings used in errorHandling.jsm
key-error-key-spec-not-found = Mailadressen '{ $keySpec }' matcher ingen nøgle på din nøglering.
key-error-key-id-not-found = Det konfigurerede nøgle-id '{ $keySpec }' kan ikke findes på din nøglering.
key-error-not-accepted-as-personal = Du har ikke bekræftet, at nøglen med id'et '{ $keySpec }' er din personlige nøgle.

# Strings used in enigmailKeyManager.js & windows.jsm
need-online = Den valgte funktion er ikke tilgængelig i offline-tilstand. Gå online og prøv igen.

# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Vi kunne ikke finde nogen nøgle, der matcher de angivne søgekriterier.

# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Fejl - kommandoen til nøgleudtrækning mislykkedes

# Strings used in keyRing.jsm
fail-cancel = Fejl - Nøglemodtagelse annulleret af brugeren
not-first-block = Fejl - Første OpenPGP-blok ikke offentlig nøgleblok
import-key-confirm = Importer offentlig(e) nøgle(r) indlejret i meddelelsen?
fail-key-import = Fejl - nøgleimport mislykkedes
file-write-failed = Kunne ikke skrive til filen { $output }
no-pgp-block = Fejl - Ingen gyldig beskyttet OpenPGP-datablok fundet
confirm-permissive-import = Import mislykkedes. Den nøgle, du prøver at importere, kan være beskadiget eller bruge ukendte attributter. Vil du prøve at importere de korrekte dele? Dette kan resultere i import af ufuldstændige og ubrugelige nøgler.

# Strings used in trust.jsm
key-valid-unknown = ukendt
key-valid-invalid = ugyldig
key-valid-disabled = deaktiveret
key-valid-revoked = tilbagekaldt
key-valid-expired = udløbet
key-trust-untrusted = upålidelig
key-trust-marginal = marginal
key-trust-full = pålidelig
key-trust-ultimate = ultimativ
key-trust-group = (gruppe)

# Strings used in commonWorkflows.js
import-key-file = Importer OpenPGP-nøglefil
import-rev-file = Importer OpenPGP-tilbagekaldelsesfil
gnupg-file = GnuPG-filer
import-keys-failed = Import af nøgler mislykkedes
passphrase-prompt = Indtast adgangsudtrykket, der låser følgende nøgle op: { $key }
file-to-big-to-import = Denne fil er for stor. Undlad at importere mange nøgler på én gang.

# Strings used in enigmailKeygen.js
save-revoke-cert-as = Opret & gem tilbagekaldelsescertifikat
revoke-cert-ok = Tilbagekaldelsescertifikatet er oprettet. Du kan bruge det til at ugyldiggøre din offentlige nøgle, fx hvis du mister din hemmelige nøgle.
revoke-cert-failed = Tilbagekaldelsescertifikatet kunne ikke oprettes.
gen-going = Nøglegenerering allerede i gang!
keygen-missing-user-name = Der er ikke angivet noget navn for den valgte konto/identitet. Indtast venligst en værdi i feltet "Dit navn" i kontoindstillingerne.
expiry-too-short = Din nøgle skal være gyldig i mindst en dag.
expiry-too-long = Du kan ikke oprette en nøgle, der udløber om mere end 100 år.
key-confirm = Generer offentlig og hemmelig nøgle til ‘{ $id }’?
key-man-button-generate-key = &Generer nøgle
key-abort = Afbryd nøglegenerering?
key-man-button-generate-key-abort = &Afbryd nøglegenerering
key-man-button-generate-key-continue = &Fortsæt nøglegenerering

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = Fejl - dekryptering mislykkedes
fix-broken-exchange-msg-failed = Denne meddelelse kunne ikke repareres.

attachment-no-match-from-signature = Kunne ikke matche signaturfilen '{ $attachment }' til en vedhæftet fil
attachment-no-match-to-signature = Kunne ikke matche vedhæftet fil ‘{ $attachment }’ til en signaturfil
signature-verified-ok = Signaturen for vedhæftet fil { $attachment } blev bekræftet
signature-verify-failed = Signaturen for vedhæftet fil { $attachment } kunne ikke bekræftes
decrypt-ok-no-sig =
    Advarsel
    Dekryptering lykkedes, men signaturen kunne ikke bekræftes
msg-ovl-button-cont-anyway = &Fortsæt alligevel
enig-content-note = *Vedhæftede filer til denne meddelelse er hverken underskrevet eller krypteret*

# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = &Send meddelelse
msg-compose-details-button-label = Detaljer…
msg-compose-details-button-access-key = D
send-aborted = Afsendelse afbrudt.
key-not-trusted = Ikke nok tillid til nøglen ‘{ $key }’
key-not-found = Nøglen ‘{ $key }’ ikke fundet
key-revoked = Nøglen ‘{ $key }’ tilbagekaldt
key-expired = Nøglen ‘{ $key }’ udløbet
msg-compose-internal-error = Der er opstået en intern fejl.
keys-to-export = Vælg OpenPGP-nøgler, der skal indsættes
msg-compose-partially-encrypted-inlinePGP =
    Meddelelsen du svarer på, indeholdt både ukrypterede og krypterede dele. Hvis afsenderen ikke oprindeligt kunne dekryptere nogle dele af meddelelsen, afslører du muligvis fortrolige oplysninger, som afsenderen ikke oprindeligt kunne dekryptere selv.
    Overvej at fjerne al citeret tekst fra dit svar til denne afsender.
msg-compose-cannot-save-draft = Fejl under lagring af kladde
msg-compose-partially-encrypted-short = Pas på ikke at afsløre følsomme oplysninger - delvist krypteret mail.
quoted-printable-warn =
    Du har aktiveret 'quoted-printable'-kodning til afsendelse af meddelelser. Dette kan resultere i forkert dekryptering og/eller verifikation af din meddelelse.
    Ønsker du at deaktivere afsendelse af 'quoted-printable'-meddelelser nu?
minimal-line-wrapping =
    Du har indstillet linjeombrydning til { $width } tegn. For korrekt kryptering og/eller signering skal denne værdi være mindst 68.
    Ønsker du at ændre linjeombrydning til 68 tegn nu?
sending-news =
    Krypteret sendehandling blev afbrudt.
    Denne meddelelse kan ikke krypteres, fordi den indeholder nyhedsgruppemodtagere. Send beskeden igen uden kryptering.
send-to-news-warning =
    Advarsel: Du er ved at sende en krypteret mail til en nyhedsgruppe.
    Dette frarådes, fordi det kun giver mening, hvis alle medlemmer af gruppen kan dekryptere meddelelsen, dvs. meddelelsen skal krypteres med nøglerne til alle gruppedeltagere. Send kun denne meddelelse, hvis du ved præcis, hvad du laver.
    Fortsæt?
save-attachment-header = Gem dekrypteret vedhæftet fil
no-temp-dir =
    Kunne ikke finde en midlertidig mappe at skrive til
    Indstil venligst TEMP-miljøvariablen
possibly-pgp-mime = Mulig PGP/MIME-krypteret eller underskrevet meddelelse; brug funktionen 'Dekrypter/Verificer' for at verificere
cannot-send-sig-because-no-own-key = Kan ikke signere denne meddelelse digitalt, fordi du endnu ikke har konfigureret end to end-kryptering for <{ $key }>
cannot-send-enc-because-no-own-key = Kan ikke sende denne meddelelse krypteret, fordi du endnu ikke har konfigureret end to end-kryptering for <{ $key }>

compose-menu-attach-key =
    .label = Vedhæft min offentlige nøgle
    .accesskey = V
compose-menu-encrypt-subject =
    .label = Emnekryptering
    .accesskey = m

# Strings used in decryption.jsm
do-import-multiple =
    Importer følgende nøgler?
    { $key }
do-import-one = Importer { $name } ({ $id })?
cant-import = Fejl ved import af offentlig nøgle
unverified-reply = Indrykket meddelelsesdel (svar) er sandsynligvis ændret
key-in-message-body = En nøgle blev fundet i meddelelsesteksten. Klik på 'Importer nøgle' for at importere nøglen
sig-mismatch = Fejl - Uoverensstemmelse i signatur
invalid-email = Fejl - ugyldig mailadresse
attachment-pgp-key =
    Den vedhæftede fil '{ $name }', du åbner, ser ud til at være en OpenPGP-nøglefil.
    Klik på 'Importer' for at importere de indeholdte nøgler eller 'Vis' for at få vist filindholdet i et browservindue
dlg-button-view = &Vis

# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Dekrypteret meddelelse (gendannet ødelagt PGP-mailformat, sandsynligvis forårsaget af en gammel Exchange-server. Resultatet er derfor muligvis ikke er perfekt)

# Strings used in encryption.jsm
not-required = Fejl - ingen kryptering påkrævet

# Strings used in windows.jsm
no-photo-available = Intet billede tilgængeligt
error-photo-path-not-readable = Fotostien ‘{ $photo }’ kan ikke læses
debug-log-title = OpenPGP fejllog

# Strings used in dialog.jsm
repeat-prefix = Denne advarsel gentages { $count }
repeat-suffix-singular = gang mere.
repeat-suffix-plural = gange mere.
no-repeat = Denne advarsel vises ikke igen.
dlg-keep-setting = Husk mit svar og spørg mig ikke igen
dlg-button-ok = &OK
dlg-button-close = &Luk
dlg-button-cancel = &Annuller
dlg-no-prompt = Vis ikke denne dialogboks igen.
enig-prompt = OpenPGP-prompt
enig-confirm = OpenPGP-bekræftelse
enig-alert = OpenPGP-advarsel
enig-info = OpenPGP-oplysninger

# Strings used in persistentCrypto.jsm
dlg-button-retry = &Forsøg igen
dlg-button-skip = &Spring over

# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = OpenPGP-advarsel
