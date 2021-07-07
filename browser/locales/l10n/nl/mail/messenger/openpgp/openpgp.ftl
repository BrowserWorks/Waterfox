
# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = Om versleutelde of digitaal ondertekende berichten te verzenden, moet u een versleutelingstechnologie instellen, zijnde OpenPGP of S/MIME.
e2e-intro-description-more = Selecteer uw persoonlijke sleutel om het gebruik van OpenPGP mogelijk te maken, of uw persoonlijke certificaat om het gebruik van S/MIME mogelijk te maken. Voor een persoonlijke sleutel of certificaat bezit u de bijbehorende geheime sleutel.
e2e-advanced-section = Geavanceerde instellingen
e2e-attach-key =
    .label = Mijn publieke sleutel bijvoegen als ik een digitale OpenPGP-handtekening toevoeg
    .accesskey = p
e2e-encrypt-subject =
    .label = Het onderwerp van OpenPGP-berichten versleutelen
    .accesskey = d
e2e-encrypt-drafts =
    .label = Conceptberichten opslaan in versleutelde opmaak
    .accesskey = l

openpgp-key-user-id-label = Account / Gebruikers-ID
openpgp-keygen-title-label =
    .title = OpenPGP-sleutel aanmaken
openpgp-cancel-key =
    .label = Annuleren
    .tooltiptext = Aanmaken sleutel annuleren
openpgp-key-gen-expiry-title =
    .label = Geldigheidsduur sleutel
openpgp-key-gen-expire-label = Sleutel verloopt over
openpgp-key-gen-days-label =
    .label = dagen
openpgp-key-gen-months-label =
    .label = maanden
openpgp-key-gen-years-label =
    .label = jaar
openpgp-key-gen-no-expiry-label =
    .label = Sleutel vervalt niet
openpgp-key-gen-key-size-label = Sleutelgrootte
openpgp-key-gen-console-label = Aanmaken sleutel
openpgp-key-gen-key-type-label = Sleuteltype
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (Elliptische Curve)
openpgp-generate-key =
    .label = Sleutel aanmaken
    .tooltiptext = Maakt een nieuwe OpenPGP-sleutel aan voor versleuteling en/of ondertekening
openpgp-advanced-prefs-button-label =
    .label = Geavanceerd…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">OPMERKING: het aanmaken van de sleutel kan enkele minuten in beslag nemen.</a> Sluit de applicatie niet af terwijl het aanmaken van de sleutel bezig is. Actief navigeren of schijfintensieve bewerkingen uitvoeren tijdens het genereren van sleutels zal de ‘willekeurigheidspool’ aanvullen en het proces versnellen. U wordt gewaarschuwd wanneer het aanmaken van de sleutel is voltooid.

openpgp-key-expiry-label =
    .label = Vervaldatum

openpgp-key-id-label =
    .label = Sleutel-ID

openpgp-cannot-change-expiry = Dit is een sleutel met een complexe structuur, het wijzigen van de vervaldatum wordt niet ondersteund.

openpgp-key-man-title =
    .title = OpenPGP-sleutelbeheerder
openpgp-key-man-generate =
    .label = Nieuw sleutelpaar
    .accesskey = s
openpgp-key-man-gen-revoke =
    .label = Intrekkingscertificaat
    .accesskey = I
openpgp-key-man-ctx-gen-revoke-label =
    .label = Intrekkingscertificaat aanmaken en opslaan

openpgp-key-man-file-menu =
    .label = Bestand
    .accesskey = B
openpgp-key-man-edit-menu =
    .label = Bewerken
    .accesskey = w
openpgp-key-man-view-menu =
    .label = Weergeven
    .accesskey = r
openpgp-key-man-generate-menu =
    .label = Aanmaken
    .accesskey = A
openpgp-key-man-keyserver-menu =
    .label = Sleutelserver
    .accesskey = S

openpgp-key-man-import-public-from-file =
    .label = Publieke sleutel(s) importeren uit bestand
    .accesskey = P
openpgp-key-man-import-secret-from-file =
    .label = Geheime sleutel(s) importeren uit bestand
openpgp-key-man-import-sig-from-file =
    .label = Intrekking(en) importeren uit bestand
openpgp-key-man-import-from-clipbrd =
    .label = Sleutel(s) importeren vanaf klembord
    .accesskey = k
openpgp-key-man-import-from-url =
    .label = Sleutel(s) importeren vanuit URL
    .accesskey = U
openpgp-key-man-export-to-file =
    .label = Publieke sleutel(s) exporteren naar bestand
    .accesskey = x
openpgp-key-man-send-keys =
    .label = Publieke sleutel(s) per e-mail verzenden
    .accesskey = z
openpgp-key-man-backup-secret-keys =
    .label = Reservekopiebestand van geheime sleutel(s) maken
    .accesskey = R

openpgp-key-man-discover-cmd =
    .label = Sleutels online ontdekken
    .accesskey = o
openpgp-key-man-discover-prompt = Voer om OpenPGP-sleutels online, op sleutelservers of met het WKD-protocol te ontdekken een e-mailadres of een sleutel-ID in.
openpgp-key-man-discover-progress = Zoeken…

openpgp-key-copy-key =
    .label = Publieke sleutel kopiëren
    .accesskey = o

openpgp-key-export-key =
    .label = Publieke sleutel naar bestand exporteren
    .accesskey = x

openpgp-key-backup-key =
    .label = Reservekopiebestand van geheime sleutel maken
    .accesskey = R

openpgp-key-send-key =
    .label = Publieke sleutel via e-mail verzenden
    .accesskey = z

openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
            [one] Sleutel-ID naar klembord kopiëren
           *[other] Sleutel-ID’s naar klembord kopiëren
        }
    .accesskey = S

openpgp-key-man-copy-fprs =
    .label =
        { $count ->
            [one] Vingerafdruk naar klembord kopiëren
           *[other] Vingerafdrukken naar klembord kopiëren
        }
    .accesskey = V

openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
            [one] Publieke sleutel naar klembord kopiëren
           *[other] Publieke sleutels naar klembord kopiëren
        }
    .accesskey = P

openpgp-key-man-ctx-expor-to-file-label =
    .label = Sleutels naar bestand exporteren

openpgp-key-man-ctx-copy =
    .label = Kopiëren
    .accesskey = K

openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
            [one] Vingerafdruk
           *[other] Vingerafdrukken
        }
    .accesskey = V

openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
            [one] Sleutel-ID
           *[other] Sleutel-ID’s
        }
    .accesskey = S

openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
            [one] Publieke sleutel
           *[other] Publieke sleutels
        }
    .accesskey = P

openpgp-key-man-close =
    .label = Sluiten
openpgp-key-man-reload =
    .label = Sleutelbuffer opnieuw laden
    .accesskey = S
openpgp-key-man-change-expiry =
    .label = Vervaldatum wijzigen
    .accesskey = V
openpgp-key-man-del-key =
    .label = Sleutel(s) verwijderen
    .accesskey = w
openpgp-delete-key =
    .label = Sleutel verwijderen
    .accesskey = w
openpgp-key-man-revoke-key =
    .label = Sleutel intrekken
    .accesskey = i
openpgp-key-man-key-props =
    .label = Sleuteleigenschappen
    .accesskey = S
openpgp-key-man-key-more =
    .label = Meer
    .accesskey = M
openpgp-key-man-view-photo =
    .label = Foto-ID
    .accesskey = F
openpgp-key-man-ctx-view-photo-label =
    .label = Foto-ID bekijken
openpgp-key-man-show-invalid-keys =
    .label = Ongeldige sleutels weergeven
    .accesskey = O
openpgp-key-man-show-others-keys =
    .label = Sleutels van andere personen weergeven
    .accesskey = u
openpgp-key-man-user-id-label =
    .label = Naam
openpgp-key-man-fingerprint-label =
    .label = Vingerafdruk
openpgp-key-man-select-all =
    .label = Alle sleutels selecteren
    .accesskey = A
openpgp-key-man-empty-tree-tooltip =
    .label = Voer in het bovenstaande veld zoektermen in
openpgp-key-man-nothing-found-tooltip =
    .label = Geen enkele sleutel komt overeen met uw zoektermen
openpgp-key-man-please-wait-tooltip =
    .label = Een ogenblik geduld terwijl de sleutels worden geladen…

openpgp-key-man-filter-label =
    .placeholder = Zoeken naar sleutels

openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I

openpgp-key-details-title =
    .title = Sleuteleigenschappen
openpgp-key-details-signatures-tab =
    .label = Certificeringen
openpgp-key-details-structure-tab =
    .label = Structuur
openpgp-key-details-uid-certified-col =
    .label = Gebruikers-ID / Gecertificeerd door
openpgp-key-details-user-id2-label = Vermeende sleuteleigenaar
openpgp-key-details-id-label =
    .label = ID
openpgp-key-details-key-type-label = Type
openpgp-key-details-key-part-label =
    .label = Sleuteldeel
openpgp-key-details-algorithm-label =
    .label = Algoritme
openpgp-key-details-size-label =
    .label = Grootte
openpgp-key-details-created-label =
    .label = Aangemaakt
openpgp-key-details-created-header = Aangemaakt
openpgp-key-details-expiry-label =
    .label = Vervaldatum
openpgp-key-details-expiry-header = Vervaldatum
openpgp-key-details-usage-label =
    .label = Gebruik
openpgp-key-details-fingerprint-label = Vingerafdruk
openpgp-key-details-sel-action =
    .label = Selecteer actie…
    .accesskey = S
openpgp-key-details-also-known-label = Vermeende alternatieve identiteiten van de sleuteleigenaar:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Sluiten
openpgp-acceptance-label =
    .label = Uw acceptatie
openpgp-acceptance-rejected-label =
    .label = Nee, deze sleutel weigeren.
openpgp-acceptance-undecided-label =
    .label = Nog niet, misschien later.
openpgp-acceptance-unverified-label =
    .label = Ja, maar ik heb niet gecontroleerd of dit de juiste sleutel is.
openpgp-acceptance-verified-label =
    .label = Ja, ik heb persoonlijk geverifieerd dat deze sleutel de juiste vingerafdruk heeft.
key-accept-personal =
    Voor deze sleutel hebt u zowel het publieke als het geheime deel. U mag hem gebruiken als een persoonlijke sleutel.
    Als deze sleutel door iemand anders aan u is gegeven, gebruik hem dan niet als persoonlijke sleutel.
key-personal-warning = Hebt u deze sleutel zelf aangemaakt en verwijst het getoonde sleuteleigendom naar uzelf?
openpgp-personal-no-label =
    .label = Nee, niet als mijn persoonlijke sleutel gebruiken.
openpgp-personal-yes-label =
    .label = Ja, deze sleutel als een persoonlijke sleutel behandelen.

openpgp-copy-cmd-label =
    .label = Kopiëren

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbird heeft geen persoonlijke OpenPGP-sleutel voor <b>{ $identity }</b>
        [one] Thunderbird heeft { $count } persoonlijke OpenPGP-sleutel gevonden die is gekoppeld aan <b>{ $identity }</b>
       *[other] Thunderbird heeft { $count } persoonlijke OpenPGP-sleutels gevonden die zijn gekoppeld aan <b>{ $identity }</b>
    }

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-have-key = Uw huidige configuratie gebruikt sleutel-ID <b>{ $key }</b>

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Uw huidige configuratie gebruikt de sleutel <b>{ $key }</b>, die is vervallen.

openpgp-add-key-button =
    .label = Sleutel toevoegen…
    .accesskey = v

e2e-learn-more = Meer info

openpgp-keygen-success = OpenPGP-sleutel met succes aangemaakt!

openpgp-keygen-import-success = OpenPGP-sleutels met succes geïmporteerd!

openpgp-keygen-external-success = Externe GnuPG-sleutel-ID opgeslagen!

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Geen

openpgp-radio-none-desc = Gebruik OpenPGP niet voor deze identiteit.

openpgp-radio-key-not-usable = Deze sleutel is niet bruikbaar als persoonlijke sleutel, omdat de geheime sleutel ontbreekt!
openpgp-radio-key-not-accepted = Om deze sleutel te gebruiken, moet u deze goedkeuren als een persoonlijke sleutel!
openpgp-radio-key-not-found = Deze sleutel kan niet worden gevonden! Als u deze wilt gebruiken, moet u hem importeren in { -brand-short-name }.

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Vervalt op: { $date }

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Vervallen op: { $date }

openpgp-key-expires-within-6-months-icon =
    .title = Sleutel vervalt over minder dan 6 maanden

openpgp-key-has-expired-icon =
    .title = Sleutel vervallen

openpgp-key-expand-section =
    .tooltiptext = Meer informatie

openpgp-key-revoke-title = Sleutel intrekken

openpgp-key-edit-title = OpenPGP-sleutel wijzigen

openpgp-key-edit-date-title = Vervaldatum verlengen

openpgp-manager-description = Gebruik de OpenPGP-sleutelbeheerder om publieke sleutels van uw correspondenten en alle andere niet hierboven genoemde sleutels te bekijken en te beheren.

openpgp-manager-button =
    .label = OpenPGP-sleutelbeheerder
    .accesskey = P

openpgp-key-remove-external =
    .label = Externe sleutel-ID verwijderen
    .accesskey = E

key-external-label = Externe GnuPG-sleutel

# Strings in keyDetailsDlg.xhtml
key-type-public = publieke sleutel
key-type-primary = hoofdsleutel
key-type-subkey = subsleutel
key-type-pair = sleutelpaar (geheime sleutel en publieke sleutel)
key-expiry-never = nooit
key-usage-encrypt = Versleutelen
key-usage-sign = Ondertekenen
key-usage-certify = Certificeren
key-usage-authentication = Authenticatie
key-does-not-expire = De sleutel vervalt niet
key-expired-date = De sleutel is vervallen op { $keyExpiry }
key-expired-simple = De sleutel is vervallen
key-revoked-simple = De sleutel is ingetrokken
key-do-you-accept = Accepteert u deze sleutel voor het verifiëren van digitale handtekeningen en voor het versleutelen van berichten?
key-accept-warning = Accepteer geen frauduleuze sleutel. Gebruik een ander communicatiekanaal dan e-mail om de vingerafdruk van de sleutel van uw correspondent te verifiëren.

# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Kan het bericht niet verzenden, omdat er een probleem is met uw persoonlijke sleutel. { $problem }
cannot-encrypt-because-missing = Kan dit bericht niet verzenden met end-to-end-versleuteling, omdat er problemen zijn met de sleutels van de volgende ontvangers: { $problem }
window-locked = Het opstelvenster is vergrendeld; verzenden geannuleerd

# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Versleuteld berichtgedeelte
mime-decrypt-encrypted-part-concealed-data = Dit is een versleuteld berichtgedeelte. U moet het in een apart venster openen door op de bijlage te klikken.

# Strings in keyserver.jsm
keyserver-error-aborted = Afgebroken
keyserver-error-unknown = Er is een onbekende fout opgetreden
keyserver-error-server-error = De sleutelserver heeft een fout gemeld.
keyserver-error-import-error = Kan de gedownloade sleutel niet importeren.
keyserver-error-unavailable = De sleutelserver is niet beschikbaar.
keyserver-error-security-error = De sleutelserver ondersteunt geen versleutelde toegang.
keyserver-error-certificate-error = Het certificaat van de sleutelserver is niet geldig.
keyserver-error-unsupported = De sleutelserver wordt niet ondersteund.

# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Uw e-mailprovider heeft uw verzoek om uw publieke sleutel te uploaden naar de OpenPGP Web Key Directory verwerkt.
    Stuur een bevestiging om de publicatie van uw publieke sleutel te voltooien.
wkd-message-body-process =
    Dit is een e-mailbericht voor de automatische verwerking om uw publieke sleutel te uploaden naar de OpenPGP Web Key Directory.
    U hoeft op dit moment geen handmatige actie te ondernemen.

# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Kan bericht met onderwerp { $subject }
    niet ontsleutelen.
    Wilt u het opnieuw proberen met een andere wachtwoordzin of wilt u het bericht overslaan?

# Strings in gpg.jsm
unknown-signing-alg = Onbekend ondertekeningsalgoritme (ID: { $id })
unknown-hash-alg = Onbekende cryptografische hash (ID: { $id })

# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Uw sleutel { $desc } vervalt over minder dan { $days } dagen.
    We raden u aan een nieuw sleutelpaar te maken en de bijbehorende accounts voor gebruik ervan te configureren.
expiry-keys-expire-soon =
    Uw volgende sleutels vervallen over minder dan { $days } dagen: { $desc }.
    We raden u aan nieuwe sleutels te maken en de bijbehorende accounts te voor gebruik ervan te configureren.
expiry-key-missing-owner-trust =
    Uw geheime sleutel { $desc } is niet vertrouwd.
    We raden u aan ‘U vertrouwt op certificeringen’ in de sleuteleigenschappen in te stellen op ‘maximaal’.
expiry-keys-missing-owner-trust =
    Het volgende van uw geheime sleutels zijn niet vertrouwd.
    { $desc }.
    We raden u aan ‘U vertrouwt op certificeringen’ in de sleuteleigenschappen in te stellen op ‘maximaal’.
expiry-open-key-manager = OpenPGP-sleutelbeheerder openen
expiry-open-key-properties = Sleuteleigenschappen openen

# Strings filters.jsm
filter-folder-required = U moet een doelmap selecteren.
filter-decrypt-move-warn-experimental =
    Waarschuwing – de filteractie ‘Permanent ontsleutelen’ kan leiden tot vernietigde berichten.
    We raden u sterk aan om eerst het filter ‘Ontsleutelde kopie maken’ te proberen, het resultaat zorgvuldig te testen en dit filter pas te gaan gebruiken als u tevreden bent met het resultaat.
filter-term-pgpencrypted-label = OpenPGP-versleuteld
filter-key-required = U moet een ontvangersleutel selecteren.
filter-key-not-found = Kan geen versleutelingssleutel vinden voor ‘{ $desc }’.
filter-warn-key-not-secret =
    Waarschuwing – de filteractie ‘Versleutelen naar sleutel’ vervangt de ontvangers.
    Als u de geheime sleutel voor ‘{ $desc }’ niet hebt, kunt u de e-mailberichten niet meer lezen.

# Strings filtersWrapper.jsm
filter-decrypt-move-label = Permanent ontsleutelen (OpenPGP)
filter-decrypt-copy-label = Ontsleutelde kopie maken (OpenPGP)
filter-encrypt-label = Versleutelen naar sleutel (OpenPGP)

# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Succes! Sleutels geïmporteerd
import-info-bits = Bits
import-info-created = Aangemaakt
import-info-fpr = Vingerafdruk
import-info-details = Details bekijken en sleutelacceptatie beheren
import-info-no-keys = Geen sleutels geïmporteerd.

# Strings in enigmailKeyManager.js
import-from-clip = Wilt u een of enkele sleutel(s) van het klembord importeren?
import-from-url = Publieke sleutel van deze URL downloaden:
copy-to-clipbrd-failed = Kan de geselecteerde sleutel(s) niet naar het klembord kopiëren.
copy-to-clipbrd-ok = Sleutel(s) naar klembord gekopieerd
delete-secret-key =
    WAARSCHUWING: U staat op het punt een geheime sleutel te verwijderen!
    
    Als u uw geheime sleutel verwijdert, kunt u geen berichten meer ontsleutelen die voor die sleutel zijn versleuteld, en kunt u deze ook niet intrekken.
    
    Wilt u echt ZOWEL de geheime sleutel ALS de publieke sleutel ‘{ $userId }’
    verwijderen?
delete-mix =
    WAARSCHUWING: U staat op het punt geheime sleutels te verwijderen!
    Als u uw geheime sleutel verwijdert, kunt u geen berichten meer ontsleutelen die voor die sleutel zijn versleuteld.
    Wilt u echt ZOWEL de geselecteerde geheime ALS de publieke sleutels verwijderen?
delete-pub-key =
    Wilt u de publieke sleutel ‘{ $userId }’
    verwijderen?
delete-selected-pub-key = Wilt u de publieke sleutels verwijderen?
refresh-all-question = U heeft geen enkele sleutel geselecteerd. Wilt u ALLE sleutels vernieuwen?
key-man-button-export-sec-key = &Geheime sleutels exporteren
key-man-button-export-pub-key = Alleen publieke sleutels e&xporteren
key-man-button-refresh-all = Alle sleutels &vernieuwen
key-man-loading-keys = Sleutels worden geladen, een moment geduld…
ascii-armor-file = ASCII-armored-bestanden (*.asc)
no-key-selected = U dient minstens een sleutel selecteren om de geselecteerde bewerking uit te voeren
export-to-file = Publieke sleutel naar bestand exporteren
export-keypair-to-file = Geheime en publieke sleutel naar bestand exporteren
export-secret-key = Wilt u de geheime sleutel opnemen in het opgeslagen OpenPGP-sleutelbestand?
save-keys-ok = De sleutels zijn met succes opgeslagen
save-keys-failed = Het opslaan van de sleutels is mislukt
default-pub-key-filename = Export-van-publieke-sleutels
default-pub-sec-key-filename = Reservekopie-van-geheime-sleutels
refresh-key-warn = Waarschuwing: afhankelijk van het aantal sleutels en de verbindingssnelheid kan het vernieuwen van alle sleutels een behoorlijk langdurig proces zijn!
preview-failed = Kan bestand met publieke sleutel niet lezen.
general-error = Fout: { $reason }
dlg-button-delete = &Verwijderen

## Account settings export output

openpgp-export-public-success = <b>Publieke sleutel met succes geëxporteerd!</b>
openpgp-export-public-fail = <b>Kan de geselecteerde publieke sleutel niet exporteren!</b>

openpgp-export-secret-success = <b>Geheime sleutel met succes geëxporteerd!</b>
openpgp-export-secret-fail = <b>Kan de geselecteerde geheime sleutel niet exporteren!</b>

# Strings in keyObj.jsm
key-ring-pub-key-revoked = De sleutel { $userId } (sleutel-ID { $keyId }) is ingetrokken.
key-ring-pub-key-expired = De sleutel { $userId } (sleutel-ID { $keyId }) is vervallen.
key-ring-no-secret-key = Het lijkt erop dat u de geheime sleutel voor { $userId } (key ID { $keyId }) niet aan uw sleutelhanger hebt; u kunt de sleutel niet gebruiken om te ondertekenen.
key-ring-pub-key-not-for-signing = De sleutel { $userId } (sleutel-ID { $keyId }) kan niet worden gebruikt voor ondertekening.
key-ring-pub-key-not-for-encryption = De sleutel { $userId } (sleutel-ID { $keyId }) kan niet worden gebruikt voor versleuteling.
key-ring-sign-sub-keys-revoked = Alle ondertekeningssubsleutels van sleutel { $userId } (sleutel-ID { $keyId }) zijn ingetrokken.
key-ring-sign-sub-keys-expired = Alle ondertekeningssubsleutels van sleutel { $userId } (sleutel-ID { $keyId }) zijn vervallen.
key-ring-enc-sub-keys-revoked = Alle versleutelingssubsleutels van sleutel { $userId } (sleutel-ID { $keyId }) zijn ingetrokken.
key-ring-enc-sub-keys-expired = Alle versleutelingssubsleutels van sleutel { $userId } (sleutel-ID { $keyId }) zijn vervallen.

# Strings in gnupg-keylist.jsm
keyring-photo = Foto
user-att-photo = Gebruikerskenmerk (JPEG-afbeelding)

# Strings in key.jsm
already-revoked = Deze sleutel is al ingetrokken.

#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    U staat op het punt de sleutel ‘{ $identity }’ in te trekken.
    U kunt met deze sleutel niet meer ondertekenen en na distributie kunnen anderen niet meer met die sleutel coderen. U kunt de sleutel nog steeds gebruiken om oude berichten te ontsleutelen.
    Wilt u doorgaan?

#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    U heeft geen sleutel (0x{ $keyId }) die overeenkomt met dit intrekkingscertificaat!
    Als u uw sleutel kwijt bent, moet u deze importeren (bijvoorbeeld van een sleutelserver) voordat u het intrekkingscertificaat importeert!

#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = De sleutel 0x{ $keyId } is al ingetrokken.

key-man-button-revoke-key = Sleutel &intrekken

openpgp-key-revoke-success = Sleutel met succes ingetrokken.

after-revoke-info =
    De sleutel is ingetrokken.
    Deel deze publieke sleutel opnieuw door deze per e-mail te verzenden of door deze naar sleutelservers te uploaden, zodat anderen weten dat u uw sleutel hebt ingetrokken.
    Zodra de software die door andere mensen wordt gebruikt over de intrekking wordt geïnformeerd, zal deze uw oude sleutel niet meer gebruiken.
    Als u een nieuwe sleutel gebruikt voor hetzelfde e-mailadres en u voegt de nieuwe publieke sleutel toe aan e-mailberichten die u verzendt, dan wordt automatisch informatie over uw ingetrokken oude sleutel toegevoegd.

# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Importeren

delete-key-title = OpenPGP-sleutel verwijderen

delete-external-key-title = De externe GnuPG-sleutel verwijderen

delete-external-key-description = Wilt u deze externe GnuPG-sleutel-ID verwijderen?

key-in-use-title = OpenPGP-sleutel wordt momenteel gebruikt

delete-key-in-use-description = Kan niet doorgaan! De sleutel die u hebt geselecteerd voor verwijdering wordt momenteel gebruikt door deze identiteit. Selecteer een andere sleutel of selecteer er geen en probeer het opnieuw.

revoke-key-in-use-description = Kan niet doorgaan! De sleutel die u hebt geselecteerd voor intrekking wordt momenteel gebruikt door deze identiteit. Selecteer een andere sleutel of selecteer er geen en probeer het opnieuw.

# Strings used in errorHandling.jsm
key-error-key-spec-not-found = Het e-mailadres ‘{ $keySpec }’ kan niet worden gekoppeld aan een sleutel aan uw sleutelhanger.
key-error-key-id-not-found = De geconfigureerde sleutel-ID ‘{ $keySpec }’ kan niet worden gevonden aan uw sleutelhanger.
key-error-not-accepted-as-personal = U heeft niet bevestigd dat de sleutel met ID ‘{ $keySpec }’ uw persoonlijke sleutel is.

# Strings used in enigmailKeyManager.js & windows.jsm
need-online = De geselecteerde functie is niet beschikbaar in de offlinemodus. Ga online en probeer het opnieuw.

# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = We kunnen geen sleutel vinden die overeenkomt met de opgegeven zoekcriteria.

# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Fout – sleutelextractieopdracht mislukt

# Strings used in keyRing.jsm
fail-cancel = Fout – sleutelontvangst geannuleerd door gebruiker
not-first-block = Fout – eerste OpenPGP-blok is geen publiek sleutelblok
import-key-confirm = In bericht ingesloten publieke sleutel(s) importeren?
fail-key-import = Fout – importeren van sleutel mislukt
file-write-failed = Kan niet naar bestand { $output } schrijven
no-pgp-block = Fout – geen geldig armored OpenPGP-gegevensblok gevonden
confirm-permissive-import = Importeren mislukt. De sleutel die u probeert te importeren, is mogelijk beschadigd of gebruikt onbekende attributen. Wilt u proberen de juiste delen te importeren? Dit kan ertoe leiden dat onvolledige en onbruikbare sleutels worden geïmporteerd.

# Strings used in trust.jsm
key-valid-unknown = onbekend
key-valid-invalid = ongeldig
key-valid-disabled = uitgeschakeld
key-valid-revoked = ingetrokken
key-valid-expired = verlopen
key-trust-untrusted = onbetrouwbaar
key-trust-marginal = weinig
key-trust-full = vertrouwd
key-trust-ultimate = maximaal
key-trust-group = (groep)

# Strings used in commonWorkflows.js
import-key-file = OpenPGP-sleutelbestand importeren
import-rev-file = OpenPGP-intrekkingsbestand importeren
gnupg-file = GnuPG-bestanden
import-keys-failed = Het importeren van de sleutels is mislukt
passphrase-prompt = Voer de wachtwoordzin in waarmee de volgende sleutel wordt ontgrendeld: { $key }
file-to-big-to-import = Dit bestand is te groot. Importeer geen grote set sleutels tegelijk.

# Strings used in enigmailKeygen.js
save-revoke-cert-as = Intrekkingscertificaat maken en opslaan
revoke-cert-ok = Het intrekkingscertificaat is met succes gemaakt. U kunt het gebruiken om uw publieke sleutel ongeldig te maken, b.v. voor het geval u uw geheime sleutel zou verliezen.
revoke-cert-failed = Het intrekkingscertificaat kan niet worden gemaakt.
gen-going = Sleutel wordt al aangemaakt!
keygen-missing-user-name = Er is geen naam opgegeven voor de geselecteerde account/identiteit. Voer in de accountinstellingen een waarde in het veld ‘Uw naam’ in.
expiry-too-short = Uw sleutel moet ten minste een dag geldig zijn.
expiry-too-long = U kunt geen sleutel maken die over meer dan 100 jaar vervalt.
key-confirm = Publieke en geheime sleutel voor ‘{ $id }’ aanmaken?
key-man-button-generate-key = Sleutel &aanmaken
key-abort = Sleutelaanmaak afbreken?
key-man-button-generate-key-abort = Sleutelaanmaak &afbreken
key-man-button-generate-key-continue = Sleutelaanmaak &voortzetten

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = Fout – ontsleuteling mislukt
fix-broken-exchange-msg-failed = Kon bericht niet repareren.

attachment-no-match-from-signature = Kan handtekeningbestand ‘{ $attachment }’ niet koppelen aan een bijlage
attachment-no-match-to-signature = Kan bijlage ‘{ $attachment }’ niet koppelen aan een handtekeningbestand
signature-verified-ok = De handtekening voor bijlage { $attachment } is met succes geverifieerd
signature-verify-failed = De handtekening voor bijlage { $attachment } kan niet worden geverifieerd
decrypt-ok-no-sig =
    Waarschuwing
    Het ontsleutelen is gelukt, maar de handtekening kan niet correct worden geverifieerd
msg-ovl-button-cont-anyway = Toch &doorgaan
enig-content-note = *Bijlagen bij dit bericht zijn niet ondertekend of versleuteld*

# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = &Bericht verzenden
msg-compose-details-button-label = Details…
msg-compose-details-button-access-key = D
send-aborted = Het verzenden is afgebroken.
key-not-trusted = Onvoldoende vertrouwen voor sleutel ‘{ $key }’
key-not-found = Sleutel ‘{ $key }’ niet gevonden
key-revoked = Sleutel ‘{ $key }’ ingetrokken
key-expired = Sleutel ‘{ $key }’ is vervallen
msg-compose-internal-error = Er is een interne fout opgetreden.
keys-to-export = Selecteer in te voegen OpenPGP-sleutels
msg-compose-partially-encrypted-inlinePGP =
    Het bericht waarop u reageert bevat zowel onversleutelde als versleutelde delen. Als de afzender sommige berichtgedeelten oorspronkelijk niet kon ontsleutelen, lekt u mogelijk vertrouwelijke informatie die de afzender oorspronkelijk niet heeft ontsleuteld.
    Overweeg om alle geciteerde tekst te verwijderen uit uw antwoord aan deze afzender.
msg-compose-cannot-save-draft = Fout bij opslaan van concept
msg-compose-partially-encrypted-short = Pas op voor het lekken van gevoelige informatie – gedeeltelijk versleuteld e-mailbericht.
quoted-printable-warn =
    U heeft codering ‘quoted-printable’ ingeschakeld voor het verzenden van berichten. Dit kan resulteren in een onjuiste ontsleuteling en/of verificatie van uw bericht.
    Wilt u het verzenden van ‘quoted-printable’-berichten nu uitschakelen?
minimal-line-wrapping =
    U hebt regelafbreking ingesteld op { $width } tekens. Voor een correcte versleuteling en/of ondertekening moet deze waarde ten minste 68 zijn.
    Wilt u de regelafbreking nu wijzigen in 68 tekens?
sending-news =
    Versleutelde verzendbewerking afgebroken.
    Dit bericht kan niet worden versleuteld omdat de ontvangers nieuwsgroepen bevatten. Verzend het bericht opnieuw zonder versleuteling.
send-to-news-warning =
    Waarschuwing: u staat op het punt een versleuteld e-mailbericht naar een nieuwsgroep te sturen.
    Dit wordt ontmoedigd, omdat het alleen zinvol is als alle leden van de groep het bericht kunnen ontsleutelen, d.w.z. het bericht moet worden versleuteld met de sleutels van alle groepsdeelnemers. Stuur dit bericht alleen als u precies weet wat u doet.
    Doorgaan?
save-attachment-header = Ontsleutelde bijlage opslaan
no-temp-dir =
    Kan geen tijdelijke map vinden om naar te schrijven
    Stel de omgevingsvariabele TEMP in
possibly-pgp-mime = Mogelijk PGP/MIME-versleuteld of -ondertekend bericht; gebruik de functie ‘Ontsleutelen/Verifiëren’ om te verifiëren
cannot-send-sig-because-no-own-key = Kan dit bericht niet digitaal ondertekenen, omdat u nog geen end-to-end-versleuteling voor <{ $key }> heeft geconfigureerd
cannot-send-enc-because-no-own-key = Kan dit bericht niet versleuteld verzenden, omdat u nog geen end-to-end-versleuteling voor <{ $key }> heeft geconfigureerd

compose-menu-attach-key =
    .label = Mijn openbare sleutel toevoegen
    .accesskey = v
compose-menu-encrypt-subject =
    .label = Versleutelde onderwerpregel
    .accesskey = n

# Strings used in decryption.jsm
do-import-multiple =
    De volgende sleutels importeren?
    { $key }
do-import-one = { $name } ({ $id }) importeren?
cant-import = Fout bij importeren publieke sleutel
unverified-reply = Het ingesprongen berichtgedeelte (antwoord) is waarschijnlijk gewijzigd
key-in-message-body = Er is een sleutel gevonden in de berichttekst. Klik op ‘Sleutel importeren’ om de sleutel te importeren
sig-mismatch = Fout – handtekening komt niet overeen
invalid-email = Fout – ongeldig(e) e-mailadres(sen)
attachment-pgp-key =
    De bijlage ‘{ $name }’ die u probeert te openen lijkt een OpenPGP-sleutelbestand te zijn.
    Klik op ‘Importeren’ om de sleutels te importeren of op ‘Weergeven’ om de inhoud van het bestand in een browservenster te bekijken
dlg-button-view = &Weergeven

# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Ontsleuteld bericht (beschadigde PGP-e-mailindeling, waarschijnlijk veroorzaakt door een oude Exchange-server, is hersteld, daarom is het resultaat mogelijk niet perfect te lezen)

# Strings used in encryption.jsm
not-required = Fout – geen versleuteling vereist

# Strings used in windows.jsm
no-photo-available = Geen foto beschikbaar
error-photo-path-not-readable = Fotopad ‘{ $photo }’ is niet leesbaar
debug-log-title = OpenPGP-debuglogboek

# Strings used in dialog.jsm
repeat-prefix = Herhalingsfrequentie waarschuwing: { $count }
repeat-suffix-singular = keer.
repeat-suffix-plural = keer.
no-repeat = Deze waarschuwing wordt niet meer getoond.
dlg-keep-setting = Mijn antwoord onthouden en het me niet nog een keer vragen
dlg-button-ok = &OK
dlg-button-close = &Sluiten
dlg-button-cancel = &Annuleren
dlg-no-prompt = Dit dialoogvenster niet meer tonen
enig-prompt = OpenPGP-vraag
enig-confirm = OpenPGP-bevestiging
enig-alert = OpenPGP-waarschuwing
enig-info = OpenPGP-informatie

# Strings used in persistentCrypto.jsm
dlg-button-retry = &Opnieuw proberen
dlg-button-skip = Over&slaan

# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = OpenPGP-waarschuwing
