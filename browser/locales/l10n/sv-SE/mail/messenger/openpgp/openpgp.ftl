
# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = För att skicka krypterade eller digitalt signerade meddelanden måste du konfigurera en krypteringsteknik, antingen OpenPGP eller S/MIME.

e2e-intro-description-more = Välj din personliga nyckel för att aktivera användning av OpenPGP eller ditt personliga certifikat för att aktivera användning av S/MIME. För en personlig nyckel eller certifikat äger du motsvarande hemlig nyckel.

e2e-advanced-section = Avancerade inställningar
e2e-attach-key =
    .label = Bifoga min publika nyckel när du lägger till en OpenPGP digital signatur
    .accesskey = B
e2e-encrypt-subject =
    .label = Kryptera ämnet för OpenPGP-meddelanden
    .accesskey = K
e2e-encrypt-drafts =
    .label = Lagra utkast till meddelanden i krypterat format
    .accesskey = L

openpgp-key-user-id-label = Konto / användar-ID
openpgp-keygen-title-label =
    .title = Generera OpenPGP-nyckel
openpgp-cancel-key =
    .label = Avbryt
    .tooltiptext = Avbryt nyckelgenerering
openpgp-key-gen-expiry-title =
    .label = Nyckeln upphör
openpgp-key-gen-expire-label = Nyckeln upphör om
openpgp-key-gen-days-label =
    .label = dagar
openpgp-key-gen-months-label =
    .label = månader
openpgp-key-gen-years-label =
    .label = år
openpgp-key-gen-no-expiry-label =
    .label = Nyckeln upphör inte
openpgp-key-gen-key-size-label = Nyckelstorlek
openpgp-key-gen-console-label = Nyckelgenerering
openpgp-key-gen-key-type-label = Nyckeltyp
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (elliptisk kurva)
openpgp-generate-key =
    .label = Generera nyckel
    .tooltiptext = Genererar en ny OpenPGP-kompatibel nyckel för kryptering och/eller signering
openpgp-advanced-prefs-button-label =
    .label = Avancerat…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">OBS: Nyckelgenerering kan ta upp till flera minuter att slutföra.</a> Stäng inte programmet medan nyckelgenerering pågår. Om du surfar eller utför en hårddiskaktivitet under nyckelgenerering kommer du att fylla på den "slumpmässiga poolen" och påskynda processen. Du får en varning när nyckelgenerering är klar.

openpgp-key-expiry-label =
    .label = Upphör

openpgp-key-id-label =
    .label = Nyckel-ID

openpgp-cannot-change-expiry = Detta är en nyckel med en komplex struktur, ändring av dess utgångsdatum stöds inte.

openpgp-key-man-title =
    .title = OpenPGP-nyckelhanterare
openpgp-key-man-generate =
    .label = Nytt nyckelpar
    .accesskey = N
openpgp-key-man-gen-revoke =
    .label = Återkallningscertifikat
    .accesskey = t
openpgp-key-man-ctx-gen-revoke-label =
    .label = Skapa och spara återkallningscertifikat

openpgp-key-man-file-menu =
    .label = Arkiv
    .accesskey = A
openpgp-key-man-edit-menu =
    .label = Redigera
    .accesskey = R
openpgp-key-man-view-menu =
    .label = Visa
    .accesskey = V
openpgp-key-man-generate-menu =
    .label = Generera
    .accesskey = G
openpgp-key-man-keyserver-menu =
    .label = Nyckelserver
    .accesskey = N

openpgp-key-man-import-public-from-file =
    .label = Importera publika nycklar från fil
    .accesskey = m
openpgp-key-man-import-secret-from-file =
    .label = Importera hemliga nycklar från fil
openpgp-key-man-import-sig-from-file =
    .label = Importera återkallelse från fil
openpgp-key-man-import-from-clipbrd =
    .label = Importera nycklar från Urklipp
    .accesskey = p
openpgp-key-man-import-from-url =
    .label = Importera nycklar från URL
    .accesskey = U
openpgp-key-man-export-to-file =
    .label = Exportera publika nycklar till fil
    .accesskey = E
openpgp-key-man-send-keys =
    .label = Skicka publika nycklar via e-post
    .accesskey = S
openpgp-key-man-backup-secret-keys =
    .label = Säkerhetskopiera hemliga nycklar till fil
    .accesskey = S

openpgp-key-man-discover-cmd =
    .label = Hitta nycklar online
    .accesskey = H
openpgp-key-man-discover-prompt = Om du vill hitta OpenPGP-nycklar online, på nyckelservrar eller använda WKD-protokollet anger du antingen en e-postadress eller ett nyckel-ID.
openpgp-key-man-discover-progress = Söker…

openpgp-key-copy-key =
    .label = Kopiera publik nyckel
    .accesskey = K

openpgp-key-export-key =
    .label = Exportera publik nyckel till fil
    .accesskey = E

openpgp-key-backup-key =
    .label = Säkerhetskopiera hemlig nyckel till fil
    .accesskey = S

openpgp-key-send-key =
    .label = Skicka publik nyckel via e-post
    .accesskey = S

openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
            [one] Kopiera nyckel-ID till Urklipp
           *[other] Kopiera nyckel-ID till Urklipp
        }
    .accesskey = n

openpgp-key-man-copy-fprs =
    .label =
        { $count ->
            [one] Kopiera fingeravtryck till Urklipp
           *[other] Kopiera fingeravtryck till Urklipp
        }
    .accesskey = f

openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
            [one] Kopiera publik nyckel till Urklipp
           *[other] Kopiera publika nycklar till Urklipp
        }
    .accesskey = p

openpgp-key-man-ctx-expor-to-file-label =
    .label = Exportera nycklar till fil

openpgp-key-man-ctx-copy =
    .label = Kopiera
    .accesskey = K

openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
            [one] Fingeravtryck
           *[other] Fingeravtryck
        }
    .accesskey = F

openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
            [one] Nyckel-ID
           *[other] Nyckel-ID
        }
    .accesskey = N

openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
            [one] Publik nyckel
           *[other] Publika nycklar
        }
    .accesskey = P

openpgp-key-man-close =
    .label = Stäng
openpgp-key-man-reload =
    .label = Ladda om nyckelcache
    .accesskey = L
openpgp-key-man-change-expiry =
    .label = Ändra utgångsdatum
    .accesskey = n
openpgp-key-man-del-key =
    .label = Ta bort nycklar
    .accesskey = T
openpgp-delete-key =
    .label = Ta bort nyckel
    .accesskey = T
openpgp-key-man-revoke-key =
    .label = Återkalla nyckel
    .accesskey = t
openpgp-key-man-key-props =
    .label = Nyckelegenskaper
    .accesskey = N
openpgp-key-man-key-more =
    .label = Mer
    .accesskey = M
openpgp-key-man-view-photo =
    .label = Foto-ID
    .accesskey = F
openpgp-key-man-ctx-view-photo-label =
    .label = Visa foto-ID
openpgp-key-man-show-invalid-keys =
    .label = Visa ogiltiga nycklar
    .accesskey = V
openpgp-key-man-show-others-keys =
    .label = Visa nycklar från andra personer
    .accesskey = a
openpgp-key-man-user-id-label =
    .label = Namn
openpgp-key-man-fingerprint-label =
    .label = Fingeravtryck
openpgp-key-man-select-all =
    .label = Välj alla nycklar
    .accesskey = V
openpgp-key-man-empty-tree-tooltip =
    .label = Ange söktermer i rutan ovan
openpgp-key-man-nothing-found-tooltip =
    .label = Inga nycklar matchar dina söktermer
openpgp-key-man-please-wait-tooltip =
    .label = Vänta medan nycklar laddas…

openpgp-key-man-filter-label =
    .placeholder = Sök efter nycklar

openpgp-key-man-select-all-key =
    .key = a
openpgp-key-man-key-details-key =
    .key = I

openpgp-key-details-title =
    .title = Nyckelegenskaper
openpgp-key-details-signatures-tab =
    .label = Certifieringar
openpgp-key-details-structure-tab =
    .label = Strukturerad
openpgp-key-details-uid-certified-col =
    .label = Användar-ID / Certifierat av
openpgp-key-details-user-id2-label = Påstådd nyckelägare
openpgp-key-details-id-label =
    .label = ID
openpgp-key-details-key-type-label = Typ
openpgp-key-details-key-part-label =
    .label = Nyckeldel
openpgp-key-details-algorithm-label =
    .label = Algoritm
openpgp-key-details-size-label =
    .label = Storlek
openpgp-key-details-created-label =
    .label = Skapad
openpgp-key-details-created-header = Skapad
openpgp-key-details-expiry-label =
    .label = Upphör
openpgp-key-details-expiry-header = Upphör
openpgp-key-details-usage-label =
    .label = Användning
openpgp-key-details-fingerprint-label = Fingeravtryck
openpgp-key-details-sel-action =
    .label = Välj åtgärd…
    .accesskey = V
openpgp-key-details-also-known-label = Påstådda alternativa identiteter för nyckelägaren:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Stäng
openpgp-acceptance-label =
    .label = Dina accepterade
openpgp-acceptance-rejected-label =
    .label = Nej, avvisa den här nyckeln.
openpgp-acceptance-undecided-label =
    .label = Inte ännu, kanske senare.
openpgp-acceptance-unverified-label =
    .label = Ja, men jag har inte verifierat att det är rätt nyckel.
openpgp-acceptance-verified-label =
    .label = Ja, jag har personligen verifierat att denna nyckel har rätt fingeravtryck.
key-accept-personal =
    För denna nyckel har du både den publika och den hemliga delen. Du kan använda den som en personlig nyckel.
    Om du fick den här nyckeln av någon annan, använd inte den som en personlig nyckel.
key-personal-warning = Skapade du den här nyckeln själv och det visade ägarskapet av nyckeln hänvisar till dig själv?
openpgp-personal-no-label =
    .label = Nej, använd inte den som min personliga nyckel.
openpgp-personal-yes-label =
    .label = Ja, behandla den här nyckeln som en personlig nyckel.

openpgp-copy-cmd-label =
    .label = Kopiera

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbird har inte en personlig OpenPGP-nyckel för <b>{ $identity }</b>
        [one] Thunderbird hittade { $count } personlig OpenPGP-nyckel associerad med <b>{ $identity }</b>
       *[other] Thunderbird hittade { $count } personliga OpenPGP-nycklar associerade med <b>{ $identity }</b>
    }

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-have-key = Din nuvarande konfiguration använder nyckel-ID <b>{ $key }</b>

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Din nuvarande konfiguration använder nyckeln <b>{ $key }</b> som har upphört.

openpgp-add-key-button =
    .label = Lägg till nyckel…
    .accesskey = L

e2e-learn-more = Läs mer

openpgp-keygen-success = OpenPGP-nyckeln har skapats!

openpgp-keygen-import-success = OpenPGP-nycklar har importerats!

openpgp-keygen-external-success = Extern GnuPG nyckel-ID sparad!

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Ingen

openpgp-radio-none-desc = Använd inte OpenPGP för den här identiteten.

openpgp-radio-key-not-usable = Denna nyckel kan inte användas som en personlig nyckel, eftersom den hemliga nyckeln saknas!
openpgp-radio-key-not-accepted = För att använda den här nyckeln måste du godkänna den som en personlig nyckel!
openpgp-radio-key-not-found = Den här nyckeln kunde inte hittas! Om du vill använda den måste du importera den till { -brand-short-name }.

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Upphör: { $date }

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Upphört: { $date }

openpgp-key-expires-within-6-months-icon =
    .title = Nyckeln upphör om mindre än sex månader

openpgp-key-has-expired-icon =
    .title = Nyckeln har upphört

openpgp-key-expand-section =
    .tooltiptext = Mer information

openpgp-key-revoke-title = Återkalla nyckel

openpgp-key-edit-title = Ändra OpenPGP-nyckel

openpgp-key-edit-date-title = Förläng utgångsdatum

openpgp-manager-description = Använd OpenPGP-nyckelhanterare för att visa och hantera publika nycklar för dina korrespondenter och alla andra nycklar som inte listas ovan.

openpgp-manager-button =
    .label = OpenPGP-nyckelhanterare
    .accesskey = O

openpgp-key-remove-external =
    .label = Ta bort externt nyckel-ID
    .accesskey = T

key-external-label = Extern GnuPG-nyckel

# Strings in keyDetailsDlg.xhtml
key-type-public = publik nyckel
key-type-primary = primär nyckel
key-type-subkey = undernyckel
key-type-pair = nyckelpar (hemlig nyckel och publik nyckel)
key-expiry-never = aldrig
key-usage-encrypt = Kryptera
key-usage-sign = Signera
key-usage-certify = Certifiera
key-usage-authentication = Autentisering
key-does-not-expire = Nyckeln upphör inte
key-expired-date = Nyckeln upphörde { $keyExpiry }
key-expired-simple = Nyckeln har upphört
key-revoked-simple = Nyckeln återkallades
key-do-you-accept = Accepterar du den här nyckeln för att verifiera digitala signaturer och för att kryptera meddelanden?
key-accept-warning = Undvik att acceptera en skurknyckel. Använd en annan kommunikationskanal än e-post för att verifiera fingeravtrycket på din korrespondents nyckel.

# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Det går inte att skicka meddelandet eftersom det finns ett problem med din personliga nyckel. { $problem }
cannot-encrypt-because-missing = Det går inte att skicka meddelandet med end-to-end kryptering eftersom det finns problem med nycklarna för följande mottagare: { $problem }
window-locked = Skrivfönstret är låst; skicka avbruten

# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Krypterad meddelandedel
mime-decrypt-encrypted-part-concealed-data = Detta är en krypterad meddelandedel. Du måste öppna det i ett separat fönster genom att klicka på bilagan.

# Strings in keyserver.jsm
keyserver-error-aborted = Avbruten
keyserver-error-unknown = Ett okänt fel uppstod
keyserver-error-server-error = Nyckelservern rapporterade ett fel.
keyserver-error-import-error = Det gick inte att importera den nedladdade nyckeln.
keyserver-error-unavailable = Nyckelservern är inte tillgänglig.
keyserver-error-security-error = Nyckelservern stöder inte krypterad åtkomst.
keyserver-error-certificate-error = Nyckelserverns certifikat är inte giltigt.
keyserver-error-unsupported = Nyckelservern stöds inte.

# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Din e-postleverantör behandlade din begäran om att ladda upp din publika nyckel till OpenPGP Web Key Directory.
    Bekräfta för att slutföra publiceringen av din publika nyckel.
wkd-message-body-process =
    Det här är ett e-postmeddelande relaterad till automatisk process för att ladda upp din publika nyckel till OpenPGP Web Key Directory.
    Du behöver inte vidta några manuella åtgärder vid denna tidpunkt.

# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Det gick inte att dekryptera meddelandet med ämnet
    { $subject }.
    Vill du försöka igen med en annan lösenfras eller vill du hoppa över meddelandet?

# Strings in gpg.jsm
unknown-signing-alg = Okänd signeringsalgoritm (ID: { $id })
unknown-hash-alg = Okänd kryptografisk hash (ID: { $id })

# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Din nyckel { $desc } upphör om mindre än { $days } dagar.
    Vi rekommenderar att du skapar ett nytt nyckelpar och konfigurerar motsvarande konton för att använda den.
expiry-keys-expire-soon =
    Följande nycklar upphör om mindre än { $days } dagar: { $desc }.
    Vi rekommenderar att du skapar nya nycklar och konfigurerar motsvarande konton för att använda dem.
expiry-key-missing-owner-trust =
    Din hemliga nyckel { $desc } saknar förtroende.
    Vi rekommenderar att du ställer in "Du litar på certifieringar" till "ultimat" i nyckelegenskaper.
expiry-keys-missing-owner-trust =
    Följande av dina hemliga nycklar saknar förtroende.
    { $desc }.
    Vi rekommenderar att du ställer in "Du litar på certifieringar" till "ultimat" i nyckelegenskaper.
expiry-open-key-manager = Öppna OpenPGP-nyckelhanterare
expiry-open-key-properties = Öppna nyckelegenskaper

# Strings filters.jsm
filter-folder-required = Du måste välja en målmapp.
filter-decrypt-move-warn-experimental =
    Varning - filteråtgärden "Dekryptera permanent" kan leda till förstörda meddelanden.
    Vi rekommenderar starkt att du först testar filtret "Skapa dekrypterad kopia", testar resultatet noggrant och börjar bara använda detta filter när du är nöjd med resultatet.
filter-term-pgpencrypted-label = OpenPGP krypterat
filter-key-required = Du måste välja en mottagarnyckel.
filter-key-not-found = Det gick inte att hitta en krypteringsnyckel för '{ $desc }'.
filter-warn-key-not-secret =
    Varning - filteråtgärden "Kryptera till nyckel" ersätter mottagarna.
    Om du inte har den hemliga nyckeln för '{ $desc }' kommer du inte längre att kunna läsa e-postmeddelandena.

# Strings filtersWrapper.jsm
filter-decrypt-move-label = Dekryptera permanent (OpenPGP)
filter-decrypt-copy-label = Skapa dekrypterad kopia (OpenPGP)
filter-encrypt-label = Kryptera till nyckel (OpenPGP)

# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Nycklar har importerats!
import-info-bits = Bitar
import-info-created = Skapad
import-info-fpr = Fingeravtryck
import-info-details = Visa detaljer och hantera nyckelacceptans
import-info-no-keys = Inga nycklar importerade.

# Strings in enigmailKeyManager.js
import-from-clip = Vill du importera några nycklar från urklipp?
import-from-url = Ladda ner publik nyckel från denna URL:
copy-to-clipbrd-failed = Det gick inte att kopiera de valda nycklarna till urklippet.
copy-to-clipbrd-ok = Nycklar kopierade till urklipp
delete-secret-key =
    VARNING: Du håller på att radera en hemlig nyckel!
    
    Om du tar bort din hemliga nyckel kommer du inte längre att kunna dekryptera några meddelanden som är krypterade för den nyckeln och du kan inte heller återkalla den.
    
    Vill du verkligen ta bort BÅDE, den hemliga nyckeln och den publika nyckeln
    '{ $userId }'?
delete-mix =
    VARNING: Du håller på att radera hemliga nycklar!
    Om du tar bort din hemliga nyckel kommer du inte längre att kunna dekryptera några meddelanden som är krypterade för den nyckeln.
    Vill du verkligen ta bort BÅDE, de valda hemliga och publika nycklarna?
delete-pub-key =
    Vill du ta bort den publika nyckeln
    '{ $userId }'?
delete-selected-pub-key = Vill du ta bort de publika nycklarna?
refresh-all-question = Du valde ingen nyckel. Vill du uppdatera ALLA nycklar?
key-man-button-export-sec-key = Exportera &hemliga nycklar
key-man-button-export-pub-key = Exportera endast &publika nycklar
key-man-button-refresh-all = &Uppdatera alla nycklar
key-man-loading-keys = Laddar nycklar, vänta…
ascii-armor-file = ASCII armerade filer (*.asc)
no-key-selected = Du bör välja minst en nyckel för att utföra den valda åtgärden
export-to-file = Exportera publik nyckel till fil
export-keypair-to-file = Exportera hemlig och publik nyckel till fil
export-secret-key = Vill du inkludera den hemliga nyckeln i den sparade OpenPGP-nyckelfilen?
save-keys-ok = Nycklarna har sparats
save-keys-failed = Det gick inte att spara nycklarna
default-pub-key-filename = Exporterade-publika-nycklar
default-pub-sec-key-filename = Backup-av-hemliga-nycklar
refresh-key-warn = Varning: beroende på antalet nycklar och anslutningshastighet, kan uppdatering av alla nycklar ta en ganska lång tid!
preview-failed = Kan inte läsa filen publik nyckelfil.
general-error = Fel: { $reason }
dlg-button-delete = &Ta bort

## Account settings export output

openpgp-export-public-success = <b>Publik nyckel har exporterats!</b>
openpgp-export-public-fail = <b>Det går inte att exportera den valda publika nyckeln!</b>

openpgp-export-secret-success = <b>Hemlig nyckel har exporterats!</b>
openpgp-export-secret-fail = <b>Det går inte att exportera den valda hemliga nyckeln!</b>

# Strings in keyObj.jsm
key-ring-pub-key-revoked = Nyckeln { $userId } (nyckel-ID { $keyId }) har återkallats.
key-ring-pub-key-expired = Nyckeln { $userId } (nyckel-ID { $keyId }) har upphört.
key-ring-no-secret-key = Du verkar inte ha den hemliga nyckeln för { $userId } (nyckel-ID { $keyId }) på din nyckelring; du kan inte använda nyckeln för att signera.
key-ring-pub-key-not-for-signing = Nyckeln { $userId } (nyckel-ID { $keyId }) kan inte användas för signering.
key-ring-pub-key-not-for-encryption = Nyckeln { $userId } (nyckel-ID { $keyId }) kan inte användas för kryptering.
key-ring-sign-sub-keys-revoked = Alla signerings-undernycklar för nyckel { $userId } (nyckel-ID { $keyId }) har återkallats.
key-ring-sign-sub-keys-expired = Alla signerings-undernycklar för nyckel { $userId } (nyckel-ID { $keyId }) har upphört.
key-ring-enc-sub-keys-revoked = Alla krypteringsundernycklar för nyckel { $userId } (nyckel-ID { $keyId }) har återkallats.
key-ring-enc-sub-keys-expired = Alla krypteringsundernycklar för nyckel { $userId } (nyckel-ID { $keyId }) har upphört.

# Strings in gnupg-keylist.jsm
keyring-photo = Foto
user-att-photo = Användarattribut (JPEG-bild)

# Strings in key.jsm
already-revoked = Denna nyckel har redan återkallats.

#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Du håller på att återkalla nyckeln '{ $identity }'.
    Du kommer inte längre att kunna signera med den här nyckeln och när den har distribuerats kommer andra inte längre att kunna kryptera med den nyckeln. Du kan fortfarande använda nyckeln för att dekryptera gamla meddelanden.
    Vill du fortsätta?

#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    Du har ingen nyckel (0x{ $keyId }) som matchar detta återkallningscertifikat!
    Om du har tappat nyckeln måste du importera den (t.ex. från en nyckelserver) innan du importerar återkallningscertifikatet!

#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = Nyckeln 0x{ $keyId } har redan återkallats.

key-man-button-revoke-key = &Återkalla nyckel

openpgp-key-revoke-success = Nyckel har återkallats.

after-revoke-info =
    Nyckeln har återkallats.
    Dela den här publika nyckeln igen, genom att skicka den via e-post eller genom att ladda upp den till nyckelservrar, för att låta andra veta att du har återkallat din nyckel.
    Så fort den programvara som används av andra människor lär sig om återkallelsen kommer den att sluta använda din gamla nyckel.
    Om du använder en ny nyckel för samma e-postadress och bifogar den nya publika nyckeln till e-postmeddelanden som du skickar kommer information om din återkallade gamla nyckel att inkluderas automatiskt.

# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Importera

delete-key-title = Ta bort OpenPGP-nyckel

delete-external-key-title = Ta bort den externa GnuPG-nyckeln

delete-external-key-description = Vill du ta bort detta externa GnuPG nyckel-ID?

key-in-use-title = OpenPGP-nyckel som för närvarande används

delete-key-in-use-description = Det går inte att fortsätta! Den nyckel som du valde för borttagning används för närvarande av denna identitet. Välj en annan nyckel eller välj ingen och försök igen.

revoke-key-in-use-description = Det går inte att fortsätta! Den nyckel du valt för återkallelse används för närvarande av denna identitet. Välj en annan nyckel eller välj ingen och försök igen.

# Strings used in errorHandling.jsm
key-error-key-spec-not-found = E-postadressen '{ $keySpec }' kan inte matchas med en nyckel på din nyckelring.
key-error-key-id-not-found = Det konfigurerade nyckel-ID '{ $keySpec }' kan inte hittas på din nyckelring.
key-error-not-accepted-as-personal = Du har inte bekräftat att nyckeln med ID '{ $keySpec }' är din personliga nyckel.

# Strings used in enigmailKeyManager.js & windows.jsm
need-online = Funktionen du har valt är inte tillgänglig i offline-läge. Gå online och försök igen.

# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Vi kunde inte hitta någon nyckel som matchar de angivna sökkriterierna.

# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Fel - nyckelutvinning misslyckades

# Strings used in keyRing.jsm
fail-cancel = Fel - nyckelmottagning avbruten av användaren
not-first-block = Fel - första OpenPGP-blocket inte blocket för en publik nyckel
import-key-confirm = Importera publika nycklar som är inbäddade i meddelandet?
fail-key-import = Fel - nyckelimport misslyckades
file-write-failed = Det gick inte att skriva till filen { $output }
no-pgp-block = Fel - inget giltigt, armerat OpenPGP-datablock hittades
confirm-permissive-import = Importen misslyckades. Nyckeln du försöker importera kan vara skadad eller använda okända attribut. Vill du försöka importera de korrekta delarna? Detta kan resultera i import av ofullständiga och oanvändbara nycklar.

# Strings used in trust.jsm
key-valid-unknown = okänd
key-valid-invalid = ogiltig
key-valid-disabled = inaktiverad
key-valid-revoked = återkallad
key-valid-expired = upphörd
key-trust-untrusted = ej betrodd
key-trust-marginal = marginellt
key-trust-full = betrodd
key-trust-ultimate = ultimat
key-trust-group = (grupp)

# Strings used in commonWorkflows.js
import-key-file = Importera OpenPGP-nyckelfil
import-rev-file = Importera OpenPGP-återkallningsfil
gnupg-file = GnuPG-filer
import-keys-failed = Importering av nycklarna misslyckades
passphrase-prompt = Ange lösenfrasen som låser upp följande nyckel: { $key }
file-to-big-to-import = Denna fil är för stor. Importera inte en stor uppsättning nycklar på en gång.

# Strings used in enigmailKeygen.js
save-revoke-cert-as = Skapa och spara återkallningscertifikat
revoke-cert-ok = Återkallningscertifikatet har skapats. Du kan använda det för att upphäva din publika nyckel, t.ex. om du skulle förlora din hemliga nyckel.
revoke-cert-failed = Återkallningscertifikatet kunde inte skapas.
gen-going = Nyckelgenerering pågår redan!
keygen-missing-user-name = Det finns inget namn angivet för det aktuella kontot/identiteten. Ange ett värde i fältet "Ditt namn" i kontoinställningarna.
expiry-too-short = Din nyckel måste vara giltig i minst en dag.
expiry-too-long = Du kan inte skapa en nyckel som upphör senare än 100 år.
key-confirm = Generera publik och hemlig nyckel för '{ $id }'?
key-man-button-generate-key = &Generera nyckel
key-abort = Vill du avbryta nyckelgenerering?
key-man-button-generate-key-abort = &Avbryt nyckelgenerering
key-man-button-generate-key-continue = &Fortsätt nyckelgenerering

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = Fel - dekryptering misslyckades
fix-broken-exchange-msg-failed = Lyckades inte reparera meddelandet.

attachment-no-match-from-signature = Det gick inte att matcha signaturfilen '{ $attachment }' till en bilaga
attachment-no-match-to-signature = Det gick inte att matcha bilagan '{ $attachment }' till en signaturfil
signature-verified-ok = Signaturen för bilaga { $attachment } har verifierats
signature-verify-failed = Signaturen för bilaga { $attachment } kunde inte verifieras
decrypt-ok-no-sig =
    Varning
    Dekryptering var framgångsrik, men signaturen kunde inte verifieras korrekt
msg-ovl-button-cont-anyway = &Fortsätt ändå
enig-content-note = *Bilagor till detta meddelande har inte signerats eller krypterats*

# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = &Skicka meddelande
msg-compose-details-button-label = Detaljer…
msg-compose-details-button-access-key = D
send-aborted = Sändningen avbröts.
key-not-trusted = Inte tillräckligt förtroende för nyckel '{ $key }'
key-not-found = Nyckel '{ $key }' hittades inte
key-revoked = Nyckel '{ $key }' återkallad
key-expired = Nyckel '{ $key }' upphörd
msg-compose-internal-error = Ett internt fel har inträffat.
keys-to-export = Välj OpenPGP-nycklar att infoga
msg-compose-partially-encrypted-inlinePGP =
    Meddelandet du svarar innehöll både okrypterade och krypterade delar. Om avsändaren ursprungligen inte kunde dekryptera vissa meddelandedelar, kanske du läcker konfidentiell information som avsändaren inte ursprungligen kunde dekryptera själv.
    Överväg att ta bort all citerad text från ditt svar till den här avsändaren.
msg-compose-cannot-save-draft = Fel vid sparande av utkast
msg-compose-partially-encrypted-short = Se upp för att läcka känslig information - delvis krypterad e-post.
quoted-printable-warn =
    Du har aktiverat 'quoted-printable'-kodning för att skicka meddelanden. Detta kan leda till felaktigt dekryptering och/eller verifiering av ditt meddelande.
    Vill du stänga av att skicka 'quoted-printable' meddelanden nu?
minimal-line-wrapping =
    Du har ställt in radomslag till { $width } tecken. För korrekt kryptering och/eller signering måste detta värde vara minst 68.
    Vill du ändra radomslag till 68 tecken nu?
sending-news =
    Krypterad skickaoperation avbröts.
    Det här meddelandet kan inte krypteras eftersom det finns nyhetsgruppsmottagare. Skicka meddelandet igen utan kryptering.
send-to-news-warning =
    Varning: du håller på att skicka ett krypterat e-postmeddelande till en nyhetsgrupp.
    Detta är inte klockt eftersom det bara är vettigt om alla medlemmar i gruppen kan dekryptera meddelandet, dvs meddelandet måste krypteras med tangenterna för alla gruppdeltagare. Skicka detta meddelande bara om du vet exakt vad du gör.
    Fortsätt?
save-attachment-header = Spara dekrypterad bilaga
no-temp-dir =
    Det gick inte att hitta en tillfällig katalog att skriva till
    Ställ in TEMP-miljövariabeln
possibly-pgp-mime = Eventuellt PGP/MIME-krypterat eller signerat meddelande; använd 'Dekryptera/verifiera'-funktionen för att verifiera
cannot-send-sig-because-no-own-key = Det här meddelandet kan inte signeras digitalt, eftersom du ännu inte har konfigurerat end-to-end kryptering för <{ $key }>
cannot-send-enc-because-no-own-key = Det går inte att skicka det här meddelandet krypterat eftersom du inte har konfigurerat end-to-end kryptering för <{ $key }>

compose-menu-attach-key =
    .label = Bifoga min publika nyckel
    .accesskey = B
compose-menu-encrypt-subject =
    .label = Ämneskryptering
    .accesskey = m

# Strings used in decryption.jsm
do-import-multiple =
    Importera följande nycklar?
    { $key }
do-import-one = Importera { $name } ({ $id })?
cant-import = Fel vid import av publik nyckel
unverified-reply = Indragen meddelandedel (svar) har troligen ändrats
key-in-message-body = En nyckel hittades i meddelandet. Klicka på 'Importera nyckel' för att importera nyckeln
sig-mismatch = Fel - Signatur matchar inte
invalid-email = Fel - ogiltiga e-postadresser
attachment-pgp-key =
    Bilagan '{ $name }' du öppnar verkar vara en OpenPGP-nyckelfil.
    Klicka på 'Importera' för att importera nycklarna eller 'Visa' för att se filinnehållet i ett webbläsarfönster
dlg-button-view = &Visa

# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Dekrypterat meddelande (återställ trasigt PGP e-postformat förmodligen orsakat av en gammal Exchange-server, så resultatet kanske inte går att läsa)

# Strings used in encryption.jsm
not-required = Fel - ingen kryptering krävs

# Strings used in windows.jsm
no-photo-available = Inget foto tillgängligt
error-photo-path-not-readable = Fotosökväg '{ $photo }' är inte läsbar
debug-log-title = OpenPGP Felsökningslogg

# Strings used in dialog.jsm
repeat-prefix = Denna varning kommer att upprepas { $count }
repeat-suffix-singular = gång till.
repeat-suffix-plural = gånger till.
no-repeat = Denna varning visas inte igen.
dlg-keep-setting = Kom ihåg mitt svar och fråga mig inte igen
dlg-button-ok = &OK
dlg-button-close = &Stäng
dlg-button-cancel = &Avbryt
dlg-no-prompt = Visa inte denna dialogruta igen.
enig-prompt = OpenPGP Prompt
enig-confirm = OpenPGP Bekräftelse
enig-alert = OpenPGP Varning
enig-info = OpenPGP Information

# Strings used in persistentCrypto.jsm
dlg-button-retry = &Försök igen
dlg-button-skip = &Hoppa över

# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = OpenPGP-varning
