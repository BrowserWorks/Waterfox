# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = For å sende krypterte eller digitalt signerte meldinger, må du konfigurere en krypteringsteknologi, enten OpenPGP eller S/MIME.

e2e-intro-description-more = Velg din personlige nøkkel for å slå på OpenPGP, eller ditt personlige sertifikat for å slå på S/MIME. For en personlig nøkkel eller sertifikat eier du den tilsvarende hemmelige nøkkelen.

openpgp-key-user-id-label = Konto / bruker-ID
openpgp-keygen-title-label =
    .title = Generer OpenPGP-nøkkel
openpgp-cancel-key =
    .label = Avbryt
    .tooltiptext = Avbryt nøkkelgenerering
openpgp-key-gen-expiry-title =
    .label = Nøkkelen utløper
openpgp-key-gen-expire-label = Nøkkelen utløper om
openpgp-key-gen-days-label =
    .label = dager
openpgp-key-gen-months-label =
    .label = måneder
openpgp-key-gen-years-label =
    .label = år
openpgp-key-gen-no-expiry-label =
    .label = Nøkkelen utløper ikke
openpgp-key-gen-key-size-label = Nøkkelstørrelse
openpgp-key-gen-console-label = Nøkkelgenerering
openpgp-key-gen-key-type-label = Nøkkeltype
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (elliptisk kurve)
openpgp-generate-key =
    .label = Generer nøkkel
    .tooltiptext = Genererer en ny OpenPGP-kompatibel nøkkel for kryptering og/eller signering
openpgp-advanced-prefs-button-label =
    .label = Avansert…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">Merk: Nøkkelgenerering kan ta opptil flere minutter å fullføre.</a> Ikke avslutt applikasjonen mens nøkkelgenerering pågår. Hvis du aktivt surfer eller utfører diskintensive operasjoner under nøkkelgenerering, vil det fylle opp «randomness pool»-en og gjøre prosessen raskere. Du blir varslet når nøkkelgenerering er fullført.

openpgp-key-expiry-label =
    .label = Utløper

openpgp-key-id-label =
    .label = Nøkkel-ID

openpgp-cannot-change-expiry = Dette er en nøkkel med en kompleks struktur, det er ikke støtte for å endre utløpsdatoen.

openpgp-key-man-title =
    .title = OpenPGP-nøkkelbehandler
openpgp-key-man-generate =
    .label = Nytt nøkkelpar
    .accesskey = N
openpgp-key-man-gen-revoke =
    .label = Tilbakekallingssertifikat
    .accesskey = T
openpgp-key-man-ctx-gen-revoke-label =
    .label = Generer og lagre tilbakekallingssertifikat

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
    .label = Nøkkelserver
    .accesskey = N

openpgp-key-man-import-public-from-file =
    .label = Importer offentlig nøkler fra fil
    .accesskey = I
openpgp-key-man-import-secret-from-file =
    .label = Importer hemmelige nøkler fra fil
openpgp-key-man-import-sig-from-file =
    .label = Importer tilbakekallelse fra fil
openpgp-key-man-import-from-clipbrd =
    .label = Importer nøkler fra utklippstavle
    .accesskey = I
openpgp-key-man-import-from-url =
    .label = Importer nøkler fra nettadresse
    .accesskey = I
openpgp-key-man-export-to-file =
    .label = Eksporter offentlige nøkler til fil
    .accesskey = E
openpgp-key-man-send-keys =
    .label = Send offentlige nøkler via e-post
    .accesskey = S
openpgp-key-man-backup-secret-keys =
    .label = Sikkerhetskopier hemmelige nøkler til fil
    .accesskey = S

openpgp-key-man-discover-cmd =
    .label = Oppdag nøkler på nettet
    .accesskey = O
openpgp-key-man-discover-prompt = Skriv inn en e-postadresse eller en nøkkel-ID for å oppdage OpenPGP-nøkler på nettet, på nøkkelservere eller ved å bruke WKD-protokollen,
openpgp-key-man-discover-progress = Søker…

openpgp-key-copy-key =
    .label = Kopier offentlig nøkkel
    .accesskey = K

openpgp-key-export-key =
    .label = Eksporter offentlig nøkkel til fil
    .accesskey = E

openpgp-key-backup-key =
    .label = Sikkerhetskopier hemmelig nøkkel til fil
    .accesskey = S

openpgp-key-send-key =
    .label = Send offentlig nøkkel via e-post
    .accesskey = S

openpgp-key-man-copy-to-clipbrd =
    .label = Kopier offentlige nøkler til utklippstavlen
    .accesskey = K
openpgp-key-man-ctx-expor-to-file-label =
    .label = Eksporter nøkler til fil
openpgp-key-man-ctx-copy-to-clipbrd-label =
    .label = Kopier offentlige nøkler til utklippstavlen

openpgp-key-man-close =
    .label = Lukk
openpgp-key-man-reload =
    .label = Last inn nøkkelbuffer på nytt
    .accesskey = L
openpgp-key-man-change-expiry =
    .label = Endre utløpsdato
    .accesskey = E
openpgp-key-man-del-key =
    .label = Slett nøkler
    .accesskey = S
openpgp-delete-key =
    .label = Slett nøkkel
    .accesskey = S
openpgp-key-man-revoke-key =
    .label = Tilbakekall nøkkel
    .accesskey = T
openpgp-key-man-key-props =
    .label = Nøkkelegenskaper
    .accesskey = N
openpgp-key-man-key-more =
    .label = Mer
    .accesskey = M
openpgp-key-man-view-photo =
    .label = Foto-ID
    .accesskey = F
openpgp-key-man-ctx-view-photo-label =
    .label = Vis foto-ID
openpgp-key-man-show-invalid-keys =
    .label = Vis ugyldige nøkler
    .accesskey = V
openpgp-key-man-show-others-keys =
    .label = Vis nøkler fra andre personer
    .accesskey = V
openpgp-key-man-user-id-label =
    .label = Navn
openpgp-key-man-fingerprint-label =
    .label = Fingeravtrykk
openpgp-key-man-select-all =
    .label = Velg alle nøkler
    .accesskey = V
openpgp-key-man-empty-tree-tooltip =
    .label = Skriv inn søkeord i boksen ovenfor
openpgp-key-man-nothing-found-tooltip =
    .label = Ingen nøkler samsvarer med søkeordene dine
openpgp-key-man-please-wait-tooltip =
    .label = Vent mens nøklene lastes inn…

openpgp-key-man-filter-label =
    .placeholder = Søk etter nøkler

openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I

openpgp-key-details-title =
    .title = Nøkkelegenskaper
openpgp-key-details-signatures-tab =
    .label = Sertifiseringer
openpgp-key-details-structure-tab =
    .label = Struktur
openpgp-key-details-uid-certified-col =
    .label = Bruker-ID / sertifisert av
openpgp-key-details-user-id2-label = Påstått nøkkeleier
openpgp-key-details-id-label =
    .label = ID
openpgp-key-details-key-type-label = Type
openpgp-key-details-key-part-label =
    .label = Nøkkeldel
openpgp-key-details-algorithm-label =
    .label = Algoritme
openpgp-key-details-size-label =
    .label = Størrelse
openpgp-key-details-created-label =
    .label = Opprettet
openpgp-key-details-created-header = Opprettet
openpgp-key-details-expiry-label =
    .label = Utløper
openpgp-key-details-expiry-header = Utløper
openpgp-key-details-usage-label =
    .label = Bruk
openpgp-key-details-fingerprint-label = Fingeravtrykk
openpgp-key-details-sel-action =
    .label = Velg handling…
    .accesskey = V
openpgp-key-details-also-known-label = Påståtte alternative identiteter til nøkkeleieren:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Lukk
openpgp-acceptance-label =
    .label = Din godkjennelse
openpgp-acceptance-rejected-label =
    .label = Nei, avvis denne nøkkelen.
openpgp-acceptance-undecided-label =
    .label = Ikke ennå, kanskje senere.
openpgp-acceptance-unverified-label =
    .label = Ja, men jeg har ikke bekreftet at det er riktig nøkkel.
openpgp-acceptance-verified-label =
    .label = Ja, jeg har bekreftet at denne nøkkelen har riktig fingeravtrykk.
key-accept-personal =
    For denne nøkkelen har du både den offentlige og den hemmelige delen. Du kan bruke den som en personlig nøkkel.
    Hvis denne nøkkelen ble gitt til deg av noen andre, bruk den ikke som en personlig nøkkel.
key-personal-warning = Har du opprettet denne nøkkelen selv, og det viste nøkkeleierskapet refererer til deg selv?
openpgp-personal-no-label =
    .label = Nei, ikke bruk den som min personlige nøkkel.
openpgp-personal-yes-label =
    .label = Ja, behandle denne nøkkelen som en personlig nøkkel.

openpgp-copy-cmd-label =
    .label = Kopier

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbird har ikke en personlig OpenPGP-nøkkel for <b>{ $identity }</b>
        [one] Thunderbird fant { $count } personlig OpenPGP-nøkkel assosiert med <b>{ $identity }</b>
       *[other] Thunderbird fant { $count } personlige OpenPGP-nøkler assosierte med <b>{ $identity }</b>
    }

#   $count (Number) - the number of configured keys associated with the current identity
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status =
    { $count ->
        [0] Velg en gyldig nøkkel for å aktivere OpenPGP-protokollen.
       *[other] Din nåværende konfigurasjon bruker nøkkel-ID <b>{ $key }</b>
    }

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Din nåværende konfigurasjon bruker nøkkelen <b>{ $key }</b>, som er utløpt.

openpgp-add-key-button =
    .label = Legg til nøkkel…
    .accesskey = L

e2e-learn-more = Les mer

openpgp-keygen-success = OpenPGP-nøkkel opprettet!

openpgp-keygen-import-success = OpenPGP-nøkler importert!

openpgp-keygen-external-success = Ekstern GnuPG-nøkkel-ID lagret!

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Ingen

openpgp-radio-none-desc = Ikke bruk OpenPGP for denne identiteten.

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Utløper den: { $date }

openpgp-key-expires-image =
    .tooltiptext = Nøkkelen utløper om mindre enn 6 måneder

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Utløpt den: { $date }

openpgp-key-expired-image =
    .tooltiptext = Nøkkel utløpt

openpgp-key-expand-section =
    .tooltiptext = Mer informasjon

openpgp-key-revoke-title = Tilbakekall nøkkel

openpgp-key-edit-title = Endre OpenPGP-nøkkel

openpgp-key-edit-date-title = Utvid utløpsdato

openpgp-manager-description = Bruk OpenPGP-nøkkelbehandleren for å se og administrere offentlige nøkler til dine korrespondenter og alle andre nøkler som ikke er oppført ovenfor.

openpgp-manager-button =
    .label = OpenPGP-nøkkelbehandler
    .accesskey = k

openpgp-key-remove-external =
    .label = Fjern ekstern nøkkel-ID
    .accesskey = F

key-external-label = Ekstern GnuPG-nøkkel

# Strings in keyDetailsDlg.xhtml
key-type-public = offentlig nøkkel
key-type-primary = primærnøkkel
key-type-subkey = undernøkkel
key-type-pair = nøkkelpar (hemmelig nøkkel og offentlig nøkkel)
key-expiry-never = aldri
key-usage-encrypt = Krypter
key-usage-sign = Signer
key-usage-certify = Sertifiser
key-usage-authentication = Autentisering
key-does-not-expire = Nøkkelen utløper ikke
key-expired-date = Nøkkelen utløp den { $keyExpiry }
key-expired-simple = Nøkkelen er utløpt
key-revoked-simple = Nøkkelen ble tilbakekalt
key-do-you-accept = Godtar du denne nøkkelen for å bekrefte digitale signaturer og for å kryptere meldinger?
key-accept-warning = Unngå å akseptere en useriøs lurenøkkel. Bruk en annen kommunikasjonskanal enn e-post for å bekrefte fingeravtrykket til korrespondentens nøkkel.

# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Kan ikke sende meldingen, fordi det er et problem med din personlige nøkkel. { $problem }
cannot-encrypt-because-missing = Kan ikke sende denne meldingen med ende-til-ende-kryptering, fordi det er problemer med nøklene til følgende mottakere: { $problem }
window-locked = Meldingsvindu er låst; sending avbrutt

# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Kryptert meldingsdel
mime-decrypt-encrypted-part-concealed-data = Dette er en kryptert meldingsdel. Du må åpne det i et eget vindu ved å klikke på vedlegget.

# Strings in keyserver.jsm
keyserver-error-aborted = Avbrutt
keyserver-error-unknown = En ukjent feil oppstod
keyserver-error-server-error = Nøkkelserveren rapporterte en feil.
keyserver-error-import-error = Kunne ikke importere den nedlastede nøkkelen.
keyserver-error-unavailable = Nøkkelserveren er ikke tilgjengelig.
keyserver-error-security-error = Nøkkelserveren støtter ikke kryptert tilgang.
keyserver-error-certificate-error = Nøkkelserverens sertifikat er ikke gyldig.
keyserver-error-unsupported = Nøkkelserveren støttes ikke.

# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Din e-postleverandør behandlet forespørselen din om å laste opp den offentlige nøkkelen til OpenPGP Web Key Directory.
    Bekreft for å fullføre publiseringen av din offentlige nøkkel.
wkd-message-body-process =
    Dette er en e-postmelding relatert til automatisk prosessering for å laste opp din offentlige nøkkel til OpenPGP Web Key Directory.
    Du trenger ikke gjøre noen manuelle tiltak på dette tidspunktet.

# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Kunne ikke dekryptere melding med emnet
    { $subject }.
    Ønsker du å prøve på nytt med en annen passordfrase, eller vil du hoppe over meldingen?

# Strings in gpg.jsm
unknown-signing-alg = Ukjent signeringsalgoritme (ID: { $id })
unknown-hash-alg = Ukjent kryptografisk hash (ID: { $id })

# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Nøkkelen din { $desc } utløper om mindre enn { $days } dager.
    Vi anbefaler at du oppretter et nytt nøkkelpar og konfigurerer de tilsvarende kontoene for å bruke det.
expiry-keys-expire-soon =
    Følgende nøkler utløper om mindre enn { $days } dager:{ $desc }.
    Vi anbefaler at du oppretter nye nøkler og konfigurerer de tilsvarende kontoene for å bruke dem.
expiry-key-missing-owner-trust =
    Den hemmelige nøkkelen din { $desc } mangler tiltro.
    Vi anbefaler at du stiller inn «Du stoler på sertifiseringer» til «ultimat» i nøkkelegenskaper.
expiry-keys-missing-owner-trust =
    Følgende av dine hemmelige nøkler mangler tiltro.
    { $desc }.
    Vi anbefaler at du stiller inn «Du stoler på sertifiseringer» til «ultimat» i nøkkelegenskaper.
expiry-open-key-manager = Åpne OpenPGP-nøkkelbehandler
expiry-open-key-properties = Åpne nøkkelegenskaper

# Strings filters.jsm
filter-folder-required = Du må velge en målmappe
filter-decrypt-move-warn-experimental =
    Advarsel - filterhandlingen «Dekrypter permanent» kan føre til ødelagte meldinger.
    Vi anbefaler på det sterkeste at du først prøver filteret «Opprett dekryptert kopi», tester resultatet nøye, og begynner først å bruke dette filteret når du er fornøyd med resultatet.
filter-term-pgpencrypted-label = OpenPGP-kryptert
filter-key-required = Du må velge en mottakernøkkel.
filter-key-not-found = Kunne ikke finne en krypteringsnøkkel for «{ $desc }».
filter-warn-key-not-secret =
    Advarsel - filterhandlingen «Krypter til nøkkel» erstatter mottakerne.
    Hvis du ikke har den hemmelige nøkkelen for «{ $desc }», vil du ikke lenger kunne lese e-postene.

# Strings filtersWrapper.jsm
filter-decrypt-move-label = Dekrypter permanent (OpenPGP)
filter-decrypt-copy-label = Lag dekryptert kopi (OpenPGP)
filter-encrypt-label = Krypter til nøkkel (OpenPGP)

# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Nøkler importerte!
import-info-bits = Bit
import-info-created = Opprettet
import-info-fpr = Fingeravtrykk
import-info-details = Se detaljer og behandle nøkkelaksept
import-info-no-keys = Ingen nøkler importerte.

# Strings in enigmailKeyManager.js
import-from-clip = Vil du importere noen nøkler fra utklippstavlen?
import-from-url = Last ned offentlig nøkkel fra denne nettadressen:
copy-to-clipbrd-failed = Kunne ikke kopiere de valgte nøklene til utklippstavlen.
copy-to-clipbrd-ok = Nøkler kopierte til utklippstavlen
delete-secret-key =
    ADVARSEL: Du er i ferd med å slette en hemmelig nøkkel!
    
    Hvis du sletter den hemmelige nøkkel din, vil du ikke lenger kunne dekryptere meldinger som er krypterte for den nøkkelen, og du vil heller ikke kunne tilbakekalle den.
    
    Vil du virkelig slette BÅDE, den hemmelige nøkkelen og den offentlige nøkkelen
    «{ $userId }»?
delete-mix =
    ADVARSEL: Du er i ferd med å slette hemmelige nøkler!
    Hvis du sletter din hemmelige nøkkel, vil du ikke lenger kunne dekryptere noen meldinger som er kryptert for den nøkkelen.
    Vil du virkelig slette BÅDE, de valgte hemmelige og offentlige nøklene?
delete-pub-key =
    Vil du slette den offentlige nøkkelen
    «{ $userId }»?
delete-selected-pub-key = Vil du slette de offentlige nøklene?
refresh-all-question = Du valgte ingen nøkkel. Vil du oppdatere ALLE nøkler?
key-man-button-export-sec-key = Eksporter &hemmelige nøkler
key-man-button-export-pub-key = Eksporter kun &offentlige nøkler
key-man-button-refresh-all = &Oppdater alle nøklene
key-man-loading-keys = Laster inn nøkler, vent litt…
ascii-armor-file = ASCII armerte filer (* .asc)
no-key-selected = Du bør velge minst en nøkkel for å utføre den valgte handlingen
export-to-file = Eksporter offentlig nøkkel til fil
export-keypair-to-file = Eksporter hemmelig og offentlig nøkkel til fil
export-secret-key = Vil du inkludere den hemmelige nøkkelen i den lagrede OpenPGP-nøkkelfilen?
save-keys-ok = Nøklene ble lagret
save-keys-failed = Lagring av nøklene mislyktes
default-pub-key-filename = Eksporterte-offentlige-nøkler
default-pub-sec-key-filename = Sikkerhetskopi-av-hemmelige-nøkler
refresh-key-warn = Advarsel: Avhengig av antall nøkler og tilkoblingshastighet, kan det være en lang prosess å oppdatere alle nøklene!
preview-failed = Kan ikke lese inn offentlig nøkkelfil.
general-error = Feil: { $reason }
dlg-button-delete = &Slett

## Account settings export output

openpgp-export-public-success = <b>Offentlig nøkkel eksportert!</b>
openpgp-export-public-fail = <b>Det gikk ikke å eksportere den valgte offentlige nøkkelen!</b>

openpgp-export-secret-success = <b>Hemmelig nøkkel eksportert!</b>
openpgp-export-secret-fail = <b>Det gikk ikke å eksportere den valgte hemmelige nøkkelen!</b>

# Strings in keyObj.jsm
key-ring-pub-key-revoked = Nøkkelen { $userId } (nøkkel-ID { $keyId }) er tilbakekalt.
key-ring-pub-key-expired = Nøkkelen { $userId } (nøkkel-ID { $keyId }) er utløpt.
key-ring-key-disabled = Nøkkelen { $userId } (nøkkel-ID { $keyId }) er deaktivert; den kan ikke brukes.
key-ring-key-invalid = Nøkkelen { $userId } (nøkkel-ID { $keyId }) er ikke gyldig. Vurder å bekrefte den korrekt.
key-ring-key-not-trusted = Nøkkelen { $userId } (nøkkel-ID { $keyId }) er ikke tiltrodd nok. Angi klareringsnivået for nøkkelen din til «ultimat» for å bruke den til signering.
key-ring-no-secret-key = Det ser ikke ut til at du har den hemmelige nøkkelen for { $userId } (nøkkel-ID { $keyId }) på nøkkelringen din; du kan ikke bruke nøkkelen til signering.
key-ring-pub-key-not-for-signing = Nøkkelen { $userId } (nøkkel-ID { $keyId }) kan ikke brukes til signering.
key-ring-pub-key-not-for-encryption = Nøkkelen { $userId } (nøkkel-ID { $keyId }) kan ikke brukes til kryptering.
key-ring-sign-sub-keys-revoked = Alle signerings-undernøklene til nøkkel { $userId } (nøkkel-ID { $keyId }) er tilbakekalt.
key-ring-sign-sub-keys-expired = Alle signerings-undernøklene til nøkkel { $userId } (nøkkel-ID { $keyId }) er utløpt.
key-ring-sign-sub-keys-unusable = Alle signerings-undernøklene til nøkkel { $userId } (nøkkel-ID { $keyId }) er tilbakekalt, utgått eller på annen måte ubrukelig.
key-ring-enc-sub-keys-revoked = Alle krypteringsundernøklene til nøkkel { $userId } (nøkkel-ID { $keyId }) er tilbakekalt.
key-ring-enc-sub-keys-expired = Alle krypteringsundernøklene til nøkkel { $userId } (nøkkel-ID { $keyId }) er utløpt.
key-ring-enc-sub-keys-unusable = Alle krypteringsundernøklene for nøkkelen { $userId } (nøkkel-ID { $keyId }) er tilbakekalt, utgått eller på annen måte ubrukelige.

# Strings in gnupg-keylist.jsm
keyring-photo = Foto
user-att-photo = Brukerattributt (JPEG-bilde)

# Strings in key.jsm
already-revoked = Denne nøkkelen er allerede trukket tilbake.

#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Du er i ferd med å tilbakekalle nøkkelen «{ $identity }».
    Du vil ikke lenger kunne signere med denne nøkkelen, og når den er distribuert, vil andre ikke lenger kunne kryptere med den nøkkelen. Du kan fremdeles bruke nøkkelen til å dekryptere gamle meldinger.
    Vil du fortsette?

#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    Du har ingen nøkkel (0x{ $keyId }) som samsvarer med dette tilbakekallingssertifikatet!
    Hvis du har mistet nøkkelen, må du importere den (f.eks. fra en nøkkelserver) før du importerer tilbakekallingssertifikatet!

#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = Nøkkelen 0x{ $keyId } er allerede trukket tilbake.

key-man-button-revoke-key = &Tilbakekall nøkkel

openpgp-key-revoke-success = Nøkkel er tilbakekalt.

after-revoke-info =
    Nøkkelen er trukket tilbake.
    Del denne offentlige nøkkelen igjen, ved å sende den via e-post, eller ved å laste den opp til nøkkelserverne, for å la andre få vite at du har tilbakekalt nøkkelen din.
    Så snart programvaren som brukes av andre mennesker får vite om tilbakekallingen, vil den slutte å bruke den gamle nøkkelen.
    Hvis du bruker en ny nøkkel for den samme e-postadressen, og du legger ved den nye offentlige nøkkelen til e-postmeldinger du sender, vil informasjon om den tilbakekalte gamle nøkkelen automatisk bli inkludert.

# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Importer

delete-key-title = Slett OpenPGP-nøkkel

delete-external-key-title = Fjern den eksterne GnuPG-nøkkelen

delete-external-key-description = Vil du fjerne denne eksterne GnuPG nøkkel-ID-en?

key-in-use-title = OpenPGP-nøkkel for tiden i bruk

delete-key-in-use-description = Kan ikke fortsette! Nøkkelen du valgte for sletting, brukes for øyeblikket av denne identiteten. Velg en annen nøkkel, eller velg ingen, og prøv igjen.

revoke-key-in-use-description = Kan ikke fortsette! Nøkkelen du valgte for tilbakekalling, brukes for øyeblikket av denne identiteten. Velg en annen nøkkel, eller velg ingen, og prøv igjen.

# Strings used in errorHandling.jsm
key-error-key-spec-not-found = E-postadressen «{ $keySpec }» kan ikke matches med en nøkkel på nøkkelringen.
key-error-key-id-not-found = Fant ikke den konfigurerte nøkkel-ID-en «{ $keySpec }» på nøkkelringen.
key-error-not-accepted-as-personal = Du har ikke bekreftet at nøkkelen med ID «{ $keySpec }» er din personlige nøkkel.

# Strings used in enigmailKeyManager.js & windows.jsm
need-online = Funksjonen du har valgt er ikke tilgjengelig i frakoblet modus. Koble til og prøv igjen.

# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Vi kunne ikke finne noen nøkkel som samsvarer med de spesifiserte søkekriteriene.

# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Feil - nøkkelekstraksjonskommandoen mislyktes

# Strings used in keyRing.jsm
fail-cancel = Feil - Mottak av nøkkel avbrutt av bruker
not-first-block = Feil - Første OpenPGP-blokk ikke offentlig nøkkelblokk
import-key-confirm = Vil du importere den offentlige nøkkelen innebygd i meldingen?
fail-key-import = Feil - import av nøkkel mislyktes
file-write-failed = Kunne ikke skrive til filen { $output }
no-pgp-block = Feil - Ingen gyldig, armert OpenPGP-datablokk funnet
confirm-permissive-import = Import mislyktes. Nøkkelen du prøver å importere kan være korrupt eller bruke ukjente attributter. Vil du prøve å importere de riktige delene? Dette kan føre til import av ufullstendige og ubrukelige nøkler.

# Strings used in trust.jsm
key-valid-unknown = ukjent
key-valid-invalid = ugyldig
key-valid-disabled = slått av
key-valid-revoked = tilbakekalt
key-valid-expired = utløpt
key-trust-untrusted = ikke tiltrodd
key-trust-marginal = marginal
key-trust-full = tiltrodd
key-trust-ultimate = ultimat
key-trust-group = (gruppe)

# Strings used in commonWorkflows.js
import-key-file = Importer OpenPGP-nøkkelfil
import-rev-file = Importer OpenPGP-tilbakekallingsfil
gnupg-file = GnuPG-filer
import-keys-failed = Import av nøklene mislyktes
passphrase-prompt = Skriv inn passordfrasen som låser opp følgende nøkkel: { $key }
file-to-big-to-import = Denne filen er for stor. Ikke importer et stort sett med nøkler på en gang.

# Strings used in enigmailKeygen.js
save-revoke-cert-as = Opprett og lagre tilbakekallingssertifikat
revoke-cert-ok = Tilbakekallingssertifikatet er opprettet. Du kan bruke det til å ugyldiggjøre den offentlige nøkkelen, f.eks. i tilfelle du mister den hemmelige nøkkelen.
revoke-cert-failed = Tilbakekallingssertifikatet kunne ikke opprettes.
gen-going = Nøkkelgenerering er allerede i gang!
keygen-missing-user-name = Det er ikke angitt noe navn for den valgte kontoen/identiteten. Skriv inn en verdi i feltet «Ditt navn» i kontoinnstillingene.
expiry-too-short = Nøkkelen din må være gyldig i minst en dag.
expiry-too-long = Du kan ikke opprette en nøkkel som går ut senere enn 100 år.
key-confirm = Generere en offentlig og hemmelig nøkkel for «{ $id }»?
key-man-button-generate-key = &Generer nøkkel
key-abort = Avbryte nøkkelgenerering?
key-man-button-generate-key-abort = &Avbryte nøkkelgenerering?
key-man-button-generate-key-continue = &Fortsett nøkkelgenerering

# Strings used in enigmailMessengerOverlay.js
failed-decrypt = Feil - dekryptering mislyktes
fix-broken-exchange-msg-failed = Klarte ikke å reparere meldingen.
attachment-no-match-from-signature = Kunne ikke samsvare signaturfilen «{ $attachment }» til et vedlegg
attachment-no-match-to-signature = Kunne ikke samsvare vedlegg «{ $attachment }» til en signaturfil
signature-verified-ok = Signaturen for vedlegget { $attachment } ble bekreftet
signature-verify-failed = Signaturen for vedlegget { $attachment } kunne ikke bekreftes
decrypt-ok-no-sig =
    Advarsel
    Dekryptering var vellykket, men signaturen kunne ikke bekreftes riktig
msg-ovl-button-cont-anyway = &Fortsett likevel
enig-content-note = *Vedlegg til denne meldingen er ikke signerte eller krypterte*

# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = &Send melding
msg-compose-details-button-label = Detaljer…
msg-compose-details-button-access-key = D
send-aborted = Sendingsoperasjonen avbrutt.
key-not-trusted = Ikke nok tillit til nøkkelen «{ $key }»
key-not-found = Nøkkel «{ $key }» ikke funnet
key-revoked = Nøkkel «{ $key }» tilbakekalt
key-expired = Nøkkel «{ $key }» utløpt
msg-compose-internal-error = En intern feil har oppstått.
keys-to-export = Velg OpenPGP-nøkler du vil sette inn
msg-compose-partially-encrypted-inlinePGP =
    Meldingen du svarer på inneholder både ukrypterte og krypterte deler. Hvis avsenderen ikke kunne dekryptere noen meldingsdeler opprinnelig, kan det hende du lekker konfidensiell informasjon om at avsenderen ikke var i stand til å kunne dekryptere selv.
    Vurder å fjerne all sitert tekst fra svaret til denne avsenderen.
msg-compose-cannot-save-draft = Feil ved lagring av utkast
msg-compose-partially-encrypted-short = Se opp for å lekke sensitiv informasjon - delvis kryptert e-post.
quoted-printable-warn =
    Du har slått på «quoted-printable»-koding for sending av meldinger. Dette kan føre til feil under dekryptering og/eller bekreftelse av meldingen.
    Ønsker du å slå av å sende «quoted-printable»-meldinger nå?
minimal-line-wrapping =
    Du har satt linjeskift til { $width } tegn. For riktig kryptering og/eller signering, må denne verdien være minst 68.
    Ønsker du å endre linjeskiftet til 68 tegn nå?
sending-hidden-rcpt = BCC-mottakere (blindkopi) kan ikke brukes når du sender en kryptert melding. For å sende denne krypterte meldingen, fjern enten BCC-mottakerne eller flytt dem til CC-feltet.
sending-news =
    Kryptert sendingsoperasjon avbrutt.
    Denne meldingen kan ikke krypteres fordi det er mottakere av temagrupper. Send meldingen på nytt uten kryptering.
send-to-news-warning =
    Advarsel: du er i ferd med å sende en kryptert e-post til en temagruppe.
    Dette frarådes fordi det bare er fornuftig hvis alle medlemmene i gruppen kan dekryptere meldingen, dvs. meldingen må krypteres med nøkkelen til alle gruppedeltakerne. Send denne meldingen kun om du vet nøyaktig hva du gjør.
    Fortsette?
save-attachment-header = Lagre dekryptert vedlegg
no-temp-dir =
    Kunne ikke finne en midlertidig katalog å skrive til
    Angi TEMP-miljøvariabelen
possibly-pgp-mime = Mulig PGP-/MIME-kryptert eller signert melding; bruk «Dekrypter/verifiser»-funksjonen for å bekrefte
cannot-send-sig-because-no-own-key = Kan ikke signere denne meldingen digitalt, fordi du ennå ikke har konfigurert ende-til-ende-kryptering for <{ $key }>
cannot-send-enc-because-no-own-key = Kan ikke sende denne meldingen kryptert, fordi du ennå ikke har konfigurert ende-til-ende-kryptering for <{ $key }>

# Strings used in decryption.jsm
do-import-multiple =
    Importere følgende nøkler?
    { $key }
do-import-one = Importere { $name } ({ $id })?
cant-import = Feil ved import av offentlig nøkkel
unverified-reply = Innrykket meldingsdel (svar) ble trolig endret
key-in-message-body = En nøkkel ble funnet i meldingen. Klikk «Importer nøkkel» for å importere nøkkelen
sig-mismatch = Feil - signaturen samsvarer ikke
invalid-email = Feil - ugyldige e-postadresser
attachment-pgp-key =
    Vedlegget «{ $name }» du åpner ser ut til å være en OpenPGP-nøkkelfil.
    Klikk på «Importer» for å importere nøklene eller «Vis» for å se filinnholdet i nettleservinduet
dlg-button-view = &Vis

# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Dekryptert melding (gjenopprettet ødelagt PGP-e-postformat sannsynligvis forårsaket av en gammel Exchange-server, slik at resultatet kanskje ikke er perfekt å lese)

# Strings used in encryption.jsm
not-required = Feil - ingen kryptering nødvendig

# Strings used in windows.jsm
no-photo-available = Ingen foto tilgjengelig
error-photo-path-not-readable = Fotostien «{ $photo }» er ikke lesbar
debug-log-title = OpenPGP-feilsøkingslogg

# Strings used in dialog.jsm
repeat-prefix = Denne varselen vil bli gjentatt { $count }
repeat-suffix-singular = gang til.
repeat-suffix-plural = ganger til.
no-repeat = Dette varselet vises ikke igjen.
dlg-keep-setting = Husk svaret mitt, og ikke spør meg igjen
dlg-button-ok = &OK
dlg-button-close = &Lukk
dlg-button-cancel = &Avbryt
dlg-no-prompt = Ikke vis denne dialogen igjen.
enig-prompt = OpenPGP Prompt
enig-confirm = OpenPGP-bekreftelse
enig-alert = OpenPGP-varsel
enig-info = OpenPGP-informasjon

# Strings used in persistentCrypto.jsm
dlg-button-retry = &Prøv igjen
dlg-button-skip = &Hopp over

# Strings used in enigmailCommon.js
enig-error = OpenPGP-feil
enig-alert-title =
    .title = OpenPGP-varsel
