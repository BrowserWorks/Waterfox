
# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = Titkosított vagy digitálisan aláírt üzenetek küldéséhez be kell állítania egy titkosítási technológiát, az OpenPGP-t vagy az S/MIME-ot.

e2e-intro-description-more = Válassza ki a személyes kulcsát az OpenPGP használatának engedélyezéséhez, vagy a személyes tanúsítványát az S/MIME használatához. Személyes kulcs vagy tanúsítvány esetén Ön a titkos kulcs tulajdonosa.

e2e-advanced-section = Speciális beállítások
e2e-attach-key =
    .label = Saját nyilvános kulcs csatolása az OpenPGP digitális aláírás hozzáadásakor
    .accesskey = n
e2e-encrypt-subject =
    .label = Az OpenPGP üzenetek tárgyának titkosítása
    .accesskey = t
e2e-encrypt-drafts =
    .label = Piszkozatok titkosított formátumban tárolása
    .accesskey = P

openpgp-key-user-id-label = Fiók / felhasználói azonosító
openpgp-keygen-title-label =
    .title = OpenPGP-kulcs előállítása
openpgp-cancel-key =
    .label = Mégse
    .tooltiptext = Kulcselőállítás megszakítása
openpgp-key-gen-expiry-title =
    .label = Kulcs lejárata
openpgp-key-gen-expire-label = A kulcs lejár:
openpgp-key-gen-days-label =
    .label = nap múlva
openpgp-key-gen-months-label =
    .label = hónap múlva
openpgp-key-gen-years-label =
    .label = év múlva
openpgp-key-gen-no-expiry-label =
    .label = A kulcs nem jár le
openpgp-key-gen-key-size-label = Kulcsméret
openpgp-key-gen-console-label = Kulcselőállítás
openpgp-key-gen-key-type-label = Kulcs típusa
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (elliptikus görbe)
openpgp-generate-key =
    .label = Kulcs előállítása
    .tooltiptext = Új OpenPGP-nek megfelelő kulcsot állít elő titkosításhoz és aláíráshoz
openpgp-advanced-prefs-button-label =
    .label = Speciális…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">MEGJEGYZÉS: A kulcs előállítása akár néhány percet is igénybe vehet.</a> Ne zárja be az alkalmazást, amíg a kulcs előállítása folyamatban van. A kulcselőállítás során az aktív böngészés vagy a lemezintenzív műveletek feltöltik a „véletlenszerűségi készletet”, és ez felgyorsítja a folyamatot. Értesítést kap, amikor a kulcselőállítás befejeződött.

openpgp-key-expiry-label =
    .label = Lejárat

openpgp-key-id-label =
    .label = Kulcsazonosító

openpgp-cannot-change-expiry = Ez egy komplex felépítésű kulcs, lejárati idejének megváltoztatása nem támogatott.

openpgp-key-man-title =
    .title = OpenPGP-kulcskezelő
openpgp-key-man-generate =
    .label = Új kulcspár
    .accesskey = k
openpgp-key-man-gen-revoke =
    .label = Visszavonási tanúsítvány
    .accesskey = V
openpgp-key-man-ctx-gen-revoke-label =
    .label = Visszavonási tanúsítvány létrehozása és mentése

openpgp-key-man-file-menu =
    .label = Fájl
    .accesskey = F
openpgp-key-man-edit-menu =
    .label = Szerkesztés
    .accesskey = e
openpgp-key-man-view-menu =
    .label = Megtekintés
    .accesskey = M
openpgp-key-man-generate-menu =
    .label = Előállítás
    .accesskey = E
openpgp-key-man-keyserver-menu =
    .label = Kulcskiszolgáló
    .accesskey = K

openpgp-key-man-import-public-from-file =
    .label = Nyilvános kulcsok importálása fájlból
    .accesskey = i
openpgp-key-man-import-secret-from-file =
    .label = Titkos kulcsok importálása fájlból
openpgp-key-man-import-sig-from-file =
    .label = Visszavonások importálása fájlból
openpgp-key-man-import-from-clipbrd =
    .label = Kulcsok importálása a vágólapra
    .accesskey = i
openpgp-key-man-import-from-url =
    .label = Kulcsok importálása URL-ből
    .accesskey = U
openpgp-key-man-export-to-file =
    .label = Nyilvános kulcsok exportálása fájlba
    .accesskey = e
openpgp-key-man-send-keys =
    .label = Nyilvános kulcsok küldése e-mailben
    .accesskey = k
openpgp-key-man-backup-secret-keys =
    .label = Titkos kulcsok biztonsági mentése fájlba
    .accesskey = b

openpgp-key-man-discover-cmd =
    .label = Kulcsok felfedezése online
    .accesskey = f
openpgp-key-man-discover-prompt = Az OpenPGP-kulcsok online felfedezéséhez – kulcskiszolgálókon vagy a WKD protokoll használatával – adjon meg egy e-mail-címet vagy egy kulcsazonosítót.
openpgp-key-man-discover-progress = Keresés…

openpgp-key-copy-key =
    .label = Nyilvános kulcs másolása
    .accesskey = m

openpgp-key-export-key =
    .label = Nyilvános kulcs exportálása fájlba
    .accesskey = e

openpgp-key-backup-key =
    .label = Titkos kulcs biztonsági mentése fájlba
    .accesskey = b

openpgp-key-send-key =
    .label = Nyilvános kulcs küldése e-mailben
    .accesskey = k

openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
            [one] Kulcsazonosító vágólapra másolása
           *[other] Kulcsazonosítók vágólapra másolása
        }
    .accesskey = K

openpgp-key-man-copy-fprs =
    .label =
        { $count ->
            [one] Ujjlenyomat vágólapra másolása
           *[other] Ujjlenyomatok vágólapra másolása
        }
    .accesskey = U

openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
            [one] Nyilvános kulcs vágólapra másolása
           *[other] Nyilvános kulcsok vágólapra másolása
        }
    .accesskey = N

openpgp-key-man-ctx-expor-to-file-label =
    .label = Kulcsok exportálása fájlba

openpgp-key-man-ctx-copy =
    .label = Másolás
    .accesskey = M

openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
            [one] Ujjlenyomat
           *[other] Ujjlenyomatok
        }
    .accesskey = U

openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
            [one] Kulcsazonosító
           *[other] Kulcsazonosítók
        }
    .accesskey = K

openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
            [one] Nyilvános kulcs
           *[other] Nyilvános kulcsok
        }
    .accesskey = N

openpgp-key-man-close =
    .label = Bezárás
openpgp-key-man-reload =
    .label = Kulcsok gyorsítótárának újratöltése
    .accesskey = j
openpgp-key-man-change-expiry =
    .label = Lejárati dátum módosítása
    .accesskey = L
openpgp-key-man-del-key =
    .label = Kulcsok törlése
    .accesskey = t
openpgp-delete-key =
    .label = Kulcs törlése
    .accesskey = t
openpgp-key-man-revoke-key =
    .label = Kulcs visszavonása
    .accesskey = v
openpgp-key-man-key-props =
    .label = Kulcs tulajdonságai
    .accesskey = K
openpgp-key-man-key-more =
    .label = Továbbiak
    .accesskey = T
openpgp-key-man-view-photo =
    .label = Fotóazonosító
    .accesskey = F
openpgp-key-man-ctx-view-photo-label =
    .label = Fotóazonosító megtekintése
openpgp-key-man-show-invalid-keys =
    .label = Érvénytelen kulcsok megjelenítése
    .accesskey = m
openpgp-key-man-show-others-keys =
    .label = Kulcsok megjelenítése másoktól
    .accesskey = m
openpgp-key-man-user-id-label =
    .label = Név
openpgp-key-man-fingerprint-label =
    .label = Ujjlenyomat
openpgp-key-man-select-all =
    .label = Összes kulcs kiválasztása
    .accesskey = s
openpgp-key-man-empty-tree-tooltip =
    .label = Írja be a keresési kifejezéseket a fenti mezőbe
openpgp-key-man-nothing-found-tooltip =
    .label = Egyik kulcs sem felel meg a keresési kifejezéseknek
openpgp-key-man-please-wait-tooltip =
    .label = Várjon amíg a kulcsok betöltésre kerülnek…

openpgp-key-man-filter-label =
    .placeholder = Kulcsok keresése

openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I

openpgp-key-details-title =
    .title = Kulcs tulajdonságai
openpgp-key-details-signatures-tab =
    .label = Tanúsítványok
openpgp-key-details-structure-tab =
    .label = Szerkezet
openpgp-key-details-uid-certified-col =
    .label = Felhasználói azonosító / hitelesítette
openpgp-key-details-user-id2-label = Állítólagos kulcstulajdonos
openpgp-key-details-id-label =
    .label = Azonosító
openpgp-key-details-key-type-label = Típus
openpgp-key-details-key-part-label =
    .label = Kulcsrész
openpgp-key-details-algorithm-label =
    .label = Algoritmus
openpgp-key-details-size-label =
    .label = Méret
openpgp-key-details-created-label =
    .label = Létrehozva
openpgp-key-details-created-header = Létrehozva
openpgp-key-details-expiry-label =
    .label = Lejárat
openpgp-key-details-expiry-header = Lejárat
openpgp-key-details-usage-label =
    .label = Használat
openpgp-key-details-fingerprint-label = Ujjlenyomat
openpgp-key-details-sel-action =
    .label = Válasszon műveletet…
    .accesskey = V
openpgp-key-details-also-known-label = A kulcstulajdonos állítólagos alternatív személyazonosságai:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Bezárás
openpgp-acceptance-label =
    .label = Az Ön elfogadása
openpgp-acceptance-rejected-label =
    .label = Nem, utasítsa el ezt a kulcsot.
openpgp-acceptance-undecided-label =
    .label = Még nem, talán később.
openpgp-acceptance-unverified-label =
    .label = Igen, de nem ellenőriztem, hogy a kulcs helyes-e.
openpgp-acceptance-verified-label =
    .label = Igen, személyesen ellenőriztem, hogy valóban ez a helyes ujjlenyomat.
key-accept-personal =
    Ennél a kulcsnál megvan a nyilvános és a titkos rész is. Használhatja személyes kulcsként.
    Ha ezt a kulcsot valaki más adta Önnek, akkor ne használja személyes kulcsként.
key-personal-warning = Ön készítette ezt a kulcsot, és a megjelenített kulcstulajdon Önre vonatkozik?
openpgp-personal-no-label =
    .label = Nem, ne használja személyes kulcsként.
openpgp-personal-yes-label =
    .label = Igen, kezelje ezt a kulcsot személyes kulcsként.

openpgp-copy-cmd-label =
    .label = Másolás

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] A Thunderbird nem rendelkezik OpenPGP-kulccsal a következőhöz: <b>{ $identity }</b>
        [one] A Thunderbird { $count } személyes OpenPGP-kulcsot köt a következőhöz: <b>{ $identity }</b>
       *[other] A Thunderbird { $count } személyes OpenPGP-kulcsot köt a következőhöz: <b>{ $identity }</b>
    }

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-have-key = A jelenlegi konfiguráció a(z) <b>{ $key }</b> kulcsazonosítót használja.

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = A jelenlegi konfiguráció a(z) <b>{ $key }</b> kulcsot használja, ami lejárt.

openpgp-add-key-button =
    .label = Kulcs hozzáadása…
    .accesskey = a

e2e-learn-more = További tudnivalók

openpgp-keygen-success = Az OpenPGP-kulcs sikeresen létrehozva.

openpgp-keygen-import-success = Az OpenPGP-kulcsok importálása sikeres.

openpgp-keygen-external-success = Külső GnuPG kulcsazonosító elmentve.

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Nincs

openpgp-radio-none-desc = Ne használjon OpenPGP-t ehhez a személyazonossághoz.

openpgp-radio-key-not-usable = Ez a kulcs nem használható személyes kulcsként, mert hiányzik a titkos kulcs.
openpgp-radio-key-not-accepted = A kulcs használatához jóvá kell hagynia személyes kulcsként.
openpgp-radio-key-not-found = Ez a kulcs nem található. Ha használná, akkor importálnia kell a { -brand-short-name }be.

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Lejár: { $date }

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Lejárt: { $date }

openpgp-key-expires-within-6-months-icon =
    .title = A kulcs kevesebb, mint 6 hónap múlva lejár

openpgp-key-has-expired-icon =
    .title = A kulcs lejárt

openpgp-key-expand-section =
    .tooltiptext = További információ

openpgp-key-revoke-title = Kulcs visszavonása

openpgp-key-edit-title = OpenPGP-kulcs módosítása

openpgp-key-edit-date-title = Lejárati dátum kitolása

openpgp-manager-description = Az OpenPGP kulcskezelővel megtekintheti és kezelheti levelezőpartnerei nyilvános kulcsait, és az összes többi, a fentiekben fel nem sorolt kulcsot.

openpgp-manager-button =
    .label = OpenPGP-kulcskezelő
    .accesskey = k

openpgp-key-remove-external =
    .label = Külső kulcsazonosító eltávolítása
    .accesskey = K

key-external-label = Külső GnuPG-kulcs

# Strings in keyDetailsDlg.xhtml
key-type-public = nyilvános kulcs
key-type-primary = elsődleges kulcs
key-type-subkey = alkulcs
key-type-pair = kulcspár (titkos kulcs és nyilvános kulcs)
key-expiry-never = soha
key-usage-encrypt = Titkosítás
key-usage-sign = Aláírás
key-usage-certify = Tanúsítás
key-usage-authentication = Hitelesítés
key-does-not-expire = A kulcs nem jár le
key-expired-date = A kulcs ekkor lejárt: { $keyExpiry }
key-expired-simple = A kulcs lejárt
key-revoked-simple = A kulcsot visszavonták
key-do-you-accept = Elfogadja ezt a kulcsot a digitális aláírások ellenőrzéséhez és az üzenetek titkosításához?
key-accept-warning = Kerülje le a hamis kulcsok elfogadását. Használjon egy az e-mailtől eltérő kommunikációs csatornát a levelezőpartner kulcsának ujjlenyomatának ellenőrzéséhez.

# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Az üzenet nem küldhető el, mert probléma van a személyes kulcsával. { $problem }
cannot-encrypt-because-missing = Az üzenetet nem lehet végpontok közötti titkosítással elküldeni, mert problémák vannak a következő címzettek kulcsaival: { $problem }
window-locked = Az írási ablak zárolva van; küldés megszakítva

# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Titkosított üzenetrész
mime-decrypt-encrypted-part-concealed-data = Ez egy titkosított üzenetrész. A mellékletre kattintva, egy külön ablakban kell megnyitnia.

# Strings in keyserver.jsm
keyserver-error-aborted = Megszakítva
keyserver-error-unknown = Ismeretlen hiba történt
keyserver-error-server-error = A kulcskiszolgáló hibát jelentett.
keyserver-error-import-error = A letöltött kulcs importálása sikertelen.
keyserver-error-unavailable = A kulcskiszolgáló nem érhető el.
keyserver-error-security-error = A kulcskiszolgáló nem támogatja a titkosított hozzáférést.
keyserver-error-certificate-error = A kulcskiszolgáló tanúsítványa nem érvényes.
keyserver-error-unsupported = A kulcskiszolgáló nem támogatott.

# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Az e-mail szolgáltatója feldolgozta a nyilvános kulcs feltöltésére vonatkozó kérését az OpenPGP webes kulcstárba.
    Erősítse meg, hogy befejezze a nyilvános kulcs közzétételét.
wkd-message-body-process =
    Ez az e-mail az OpenPGP webes kulcstárba feltöltött nyilvános kulcs automatikus feldolgozásával kapcsolatos.
    Jelenleg nincs semmilyen teendője.

# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Nem sikerült visszafejteni a következő tárgyú üzenetet:
    { $subject }.
    Újrapróbálkozik egy másik jelszóval, vagy ki akarja hagyni az üzenetet?

# Strings in gpg.jsm
unknown-signing-alg = Ismeretlen aláírási algoritmus (azonosító: { $id })
unknown-hash-alg = Ismeretlen kriptográfiai ujjlenyomat (azonosító: { $id })

# Strings in keyUsability.jsm
expiry-key-expires-soon =
    A(z) { $desc } kulcsa kevesebb, mint { $days } nap múlva lejár.
    Javasoljuk, hogy hozzon létre egy új kulcspárt, és konfigurálja a megfelelő fiókokat annak használatához.
expiry-keys-expire-soon =
    A következő kulcsok kevesebb, mint { $days } napon belül lejárnak: { $desc }.
    Javasoljuk, hogy hozzon létre új kulcsokat, és konfigurálja a megfelelő fiókokat azok használatához.
expiry-key-missing-owner-trust =
    A(z) { $desc } titkos kulcs nem eléggé megbízható.
    Javasoljuk, hogy a kulcstulajdonságokban állítsa be a „Tanúsítványokra támaszkodik” értékét „teljesen megbízhatóra”.
expiry-keys-missing-owner-trust =
    A következő titkos kulcsok nem eléggé megbízhatók.
    { $desc }.
    Javasoljuk, hogy a kulcstulajdonságokban állítsa be a „Tanúsítványokra támaszkodik” értékét „teljesen megbízhatóra”.
expiry-open-key-manager = OpenPGP-kulcskezelő megnyitása
expiry-open-key-properties = Kulcstulajdonságok megnyitása

# Strings filters.jsm
filter-folder-required = Ki kell választania a célmappát.
filter-decrypt-move-warn-experimental =
    Figyelmeztetés – a „Végleges visszafejtés” szűrési művelet tönkrement üzeneteket eredményezhet.
    Erősen javasolt, hogy először használja a „Visszafejtett másolat létrehozása” szűrőt, ellenőrizze az eredményt, és csak akkor kezdje el a szűrőt használni, ha elégedett az eredménnyel.
filter-term-pgpencrypted-label = OpenPGP-vel titkosított
filter-key-required = Ki kell választania a címzett kulcsát.
filter-key-not-found = Nem található titkosítási kulcs a következőhöz: „{ $desc }”.
filter-warn-key-not-secret =
    Figyelmeztetés – a „Titkosítás kulcshoz” szűrési művelet lecseréli a címzetteket.
    Ha nincs meg a titkos kulcs ehhez: „{ $desc }”, akkor többé nem fogja tudni elolvasni az e-maileket.

# Strings filtersWrapper.jsm
filter-decrypt-move-label = Végleges visszafejtés (OpenPGP)
filter-decrypt-copy-label = Visszafejtett másolat létrehozása (OpenPGP)
filter-encrypt-label = Titkosítás a kulcshoz (OpenPGP)

# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Sikeres! Kulcsok importálva
import-info-bits = Bitek
import-info-created = Létrehozva
import-info-fpr = Ujjlenyomat
import-info-details = Részletek megtekintése és a kulcselfogadás kezelése
import-info-no-keys = Nem lett kulcs importálva.

# Strings in enigmailKeyManager.js
import-from-clip = Szeretne kulcsokat importálni a vágólapról?
import-from-url = Nyilvános kulcsok letöltése erről az URL-ről:
copy-to-clipbrd-failed = A kiválasztott kulcsok nem másolhatók a vágólapra.
copy-to-clipbrd-ok = Kulcsok a vágólapra másolva
delete-secret-key =
    FIGYELEM: Egy titkos kulcs törlésére készül!
    
    Ha törli a titkos kulcsot, akkor többé nem fogja tudni visszafejteni az ahhoz a kulcshoz titkosított üzeneteket, és vissza sem fogja tudni vonni.
    
    Biztos, hogy törli a következő titkos ÉS nyilvános kulcsot is:
    „{ $userId }”?
delete-mix =
    FIGYELEM: Egy titkos kulcs törlésére készül!
    Ha törli a titkos kulcsot, akkor többé nem fogja tudni visszafejteni az ahhoz a kulcshoz titkosított üzeneteket.
    Biztos, hogy törli a következő titkos ÉS nyilvános kulcsot is?
delete-pub-key =
    Biztos, hogy törli a következő nyilvános kulcsot:
    „{ $userId }”?
delete-selected-pub-key = Biztos, hogy törli a nyilvános kulcsokat?
refresh-all-question = Nem választott ki egyetlen kulcsot sem. Frissíti az ÖSSZES kulcsot?
key-man-button-export-sec-key = &Titkos kulcsok exportálása
key-man-button-export-pub-key = Csak a &nyilvános kulcsok exportálása
key-man-button-refresh-all = Az összes kulcs f&rissítése
key-man-loading-keys = Kulcsok betöltése, kis türelmet…
ascii-armor-file = ASCII páncélozott fájlok (*.asc)
no-key-selected = Legalább egy kulcsot ki kell választania a kiválasztott művelet végrehajtásához
export-to-file = Nyilvános kulcs exportálása fájlba
export-keypair-to-file = Titkos és nyilvános kulcs exportálása fájlba
export-secret-key = Biztos, hogy felveszi a titkos kulcsot az elmentett OpenPGP-kulcsfájlba?
save-keys-ok = A kulcsok sikeresen elmentve
save-keys-failed = A kulcsok mentése sikertelen
default-pub-key-filename = Exportált nyilvános kulcsok
default-pub-sec-key-filename = Titkos kulcsok biztonsági mentése
refresh-key-warn = Figyelmeztetés: a kulcsok számától és a kapcsolat sebességétől függően, az összes kulcs frissítése meglehetősen hosszú folyamat lehet.
preview-failed = Nem olvasható a nyilvános kulcs fájlja.
general-error = Hiba: { $reason }
dlg-button-delete = Tör&lés

## Account settings export output

openpgp-export-public-success = <b>A nyilvános kulcs exportálása sikeres!</b>
openpgp-export-public-fail = <b>A kiválasztott nyilvános kulcs nem exportálható!</b>

openpgp-export-secret-success = <b>A titkos kulcs exportálása sikeres!</b>
openpgp-export-secret-fail = <b>A kiválasztott titkos kulcs nem exportálható!</b>

# Strings in keyObj.jsm
key-ring-pub-key-revoked = A(z) { $userId } kulcsot (kulcsazonosító: { $keyId }) visszavonták.
key-ring-pub-key-expired = A(z) { $userId } kulcs (kulcsazonosító: { $keyId }) lejárt.
key-ring-no-secret-key = Úgy tűnik, hogy nem rendelkezik a(z) { $userId } kulccsal (kulcsazonosító: { $keyId }) a kulcstartójában: nem használhatja a kulcsot aláíráshoz.
key-ring-pub-key-not-for-signing = A(z) { $userId } kulcs (kulcsazonosító: { $keyId }) nem használható aláíráshoz.
key-ring-pub-key-not-for-encryption = A(z) { $userId } kulcs (kulcsazonosító: { $keyId }) nem használható titkosításhoz.
key-ring-sign-sub-keys-revoked = A(z) { $userId } kulcs (kulcsazonosító: { $keyId }) összes aláírási alkulcsát visszavonták.
key-ring-sign-sub-keys-expired = A(z) { $userId } kulcs (kulcsazonosító: { $keyId }) összes aláírási alkulcsa lejárt.
key-ring-enc-sub-keys-revoked = A(z) { $userId } kulcs (kulcsazonosító: { $keyId }) összes titkosítási alkulcsát visszavonták.
key-ring-enc-sub-keys-expired = A(z) { $userId } kulcs (kulcsazonosító: { $keyId }) összes titkosítási alkulcsa lejárt.

# Strings in gnupg-keylist.jsm
keyring-photo = Fénykép
user-att-photo = Felhasználói attribútum (JPEG-kép)

# Strings in key.jsm
already-revoked = Ezt a kulcsot már visszavonták.

#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Arra készül, hogy visszavonja a(z) „{ $identity }” kulcsot.
    A továbbiakban már nem fog tud aláírni ezzel a kulccsal, és miután elosztották, mások sem fognak tudni titkosítani ezzel a kulccsal. A kulcsot továbbra is használhatja a régi üzenetek visszafejtéséhez.
    Folytatná?

#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    Nincs olyan kulcsa (0x{ $keyId }), mely megfelel ennek a visszavonási tanúsítványnak!
    Ha elveszett a kulcsa, akkor a visszavonási tanúsítvány importálása előtt importálnia kell azt (pl. egy kulcskiszolgálóból)!

#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = A 0x{ $keyId } kulcsot már visszavonták.

key-man-button-revoke-key = Kulcs &visszavonása

openpgp-key-revoke-success = A kulcs visszavonása sikeres.

after-revoke-info =
    A kulcsot visszavonták.
    Ossza meg újra ezt a nyilvános kulcsot, e-mailben elküldve, vagy kulcskiszolgálókra feltöltve, hogy mások tudják, hogy visszavonta a kulcsot.
    Amint a mások által használt szoftver megtudja a visszavonást, az már nem használja a régi kulcsot.
    Ha ugyanahhoz az e-mail-címhez új kulcsot használ, és az új nyilvános kulcsot csatolja az elküldött e-mailekhez, akkor a visszavont régi kulcsra vonatkozó információk automatikusan belekerülnek.

# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Importálás

delete-key-title = OpenPGP-kulcs törlése

delete-external-key-title = Külső GnuPG-kulcs eltávolítása

delete-external-key-description = Eltávolítaná ezt a külső GnuPG-kulcsazonosítót?

key-in-use-title = Jelenleg használt OpenPGP-kulcs

delete-key-in-use-description = Nem lehet folytatni. A törlésre kiválasztott kulcsot jelenleg ez a személyazonosság használja. Válasszon egy másik kulcsot, vagy szüntesse meg a kiválasztást, és próbálja újra.

revoke-key-in-use-description = Nem lehet folytatni. A visszavonásra kiválasztott kulcsot jelenleg ez a személyazonosság használja. Válasszon egy másik kulcsot, vagy szüntesse meg a kiválasztást, és próbálja újra.

# Strings used in errorHandling.jsm
key-error-key-spec-not-found = A(z) „{ $keySpec }” e-mail-cím nem felel meg a kulcstartó egyetlen kulcsának sem.
key-error-key-id-not-found = A beállított „{ $keySpec }” kulcsazonosító nem található a kulcstartóban.
key-error-not-accepted-as-personal = Nem erősítette meg, hogy a(z) „{ $keySpec }” azonosítójú kulcs a személyes kulcsa.

# Strings used in enigmailKeyManager.js & windows.jsm
need-online = A kiválasztott funkció offline módban nem érhető el. Kapcsolódjon és próbálja újra.

# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Nem található olyan kulcs, amely megfelelne a keresési feltételeknek.

# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Hiba – a kulcskinyerési parancs sikertelen

# Strings used in keyRing.jsm
fail-cancel = Hiba – a felhasználó megszakította a kulcs fogadását
not-first-block = Hiba – az első OpenPGP blokk nem nyilvános kulcs blokk
import-key-confirm = Importálja az üzenetbe ágyazott nyilvános kulcsokat?
fail-key-import = Hiba – a kulcs importálása sikertelen
file-write-failed = A(z) { $output } fájlba írás sikertelen
no-pgp-block = Hiba – nem található érvényes páncélozott OpenPGP-adatblokk
confirm-permissive-import = Az importálás sikertelen. Lehet, hogy az importálandó kulcs sérült vagy ismeretlen attribútumokat használ. Megpróbálja a helyes részek importálását? Ez hiányos és használhatatlan kulcsokat eredményezhet.

# Strings used in trust.jsm
key-valid-unknown = ismeretlen
key-valid-invalid = érvénytelen
key-valid-disabled = tiltott
key-valid-revoked = visszavont
key-valid-expired = lejárt
key-trust-untrusted = nem megbízható
key-trust-marginal = marginális
key-trust-full = megbízható
key-trust-ultimate = teljesen megbízható
key-trust-group = (csoport)

# Strings used in commonWorkflows.js
import-key-file = OpenPGP-kulcsfájl importálása
import-rev-file = OpenPGP visszavonási fájl importálása
gnupg-file = GnuPG-fájlok
import-keys-failed = A kulcsok importálása sikertelen
passphrase-prompt = Írja be a jelmondatot, amely feloldja a következő kulcsot: { $key }
file-to-big-to-import = A fájl túl nagy. Nem importáljon nagy kulcskészleteket egyszerre.

# Strings used in enigmailKeygen.js
save-revoke-cert-as = Visszavonási tanúsítvány létrehozása és mentése
revoke-cert-ok = A visszavonási tanúsítvány sikeresen létrejött. Használhatja a nyilvános kulcs érvénytelenítéséhez, például abban az esetben, ha elveszíti a titkos kulcsát.
revoke-cert-failed = A visszavonási tanúsítványt nem sikerült létrehozni.
gen-going = A kulcselőállítás már folyamatban van.
keygen-missing-user-name = A kiválasztott fiókhoz/személyazonossághoz nincs megadva név. Adjon meg egy értéket a fiókbeállítások  „Az Ön neve” mezőjében.
expiry-too-short = A kulcsának legalább egy napig érvényesnek kell lennie.
expiry-too-long = Nem hozhat létre olyan kulcsot, amely több mint 100 év múlva jár le.
key-confirm = Előállítja a nyilvános és titkos kulcsot „{ $id }” számára?
key-man-button-generate-key = Kulcs &előállítása
key-abort = Megszakítja a kulcselőállítást?
key-man-button-generate-key-abort = Kulcselőállítás &megszakítása
key-man-button-generate-key-continue = Kulcselőállítás &folytatása

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = Hiba – a visszafejtés sikertelen
fix-broken-exchange-msg-failed = Az üzenet javítása nem sikerült.

attachment-no-match-from-signature = Nem sikerült egyeztetni a(z) „{ $attachment }” aláírási fájlt egy melléklettel
attachment-no-match-to-signature = Nem sikerült egyeztetni a(z) „{ $attachment }” mellékletet egy aláírási fájllal
signature-verified-ok = A(z) { $attachment } melléklet aláírása sikeresen ellenőrizve lett
signature-verify-failed = A(z) { $attachment } melléklet aláírását nem lehetett ellenőrizni
decrypt-ok-no-sig =
    Figyelem
    A visszafejtés sikeres volt, de az aláírást nem lehetett helyesen ellenőrizni
msg-ovl-button-cont-anyway = &Folytatás mindenképp
enig-content-note = *Az üzenet mellékletei nem lettek aláírva, sem titkosítva*

# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = Üzenet &küldése
msg-compose-details-button-label = Részletek…
msg-compose-details-button-access-key = R
send-aborted = A küldési művelet megszakítva.
key-not-trusted = A(z) „{ $key }” nem elég megbízható
key-not-found = A(z) „{ $key }” kulcs nem található
key-revoked = A(z) „{ $key }” kulcs visszavonva
key-expired = A(z) „{ $key }” kulcs lejárt
msg-compose-internal-error = Belső hiba történt.
keys-to-export = Válassza ki az importálandó OpenPGP-kulcsokat
msg-compose-partially-encrypted-inlinePGP =
    Az üzenet, amelyre válaszol, titkosítatlan és titkosított részeket is tartalmaz. Ha a küldő eredetileg nem tudott visszafejteni néhány üzenetrészt, akkor bizalmas információkat szivárogtathat ki, amelyeket a feladó eredetileg nem volt képes visszafejteni.
    Fontolja meg az összes idézett szöveg eltávolítását a feladónak küldött válaszból.
msg-compose-cannot-save-draft = Hiba a piszkozat mentésekor
msg-compose-partially-encrypted-short = Figyeljen a bizalmas információk kiszivárogtatására – részlegesen titkosított e-mail.
quoted-printable-warn =
    Engedélyezte az „idézett-nyomtatható” kódolást az üzenetek küldéséhez. Ez hibás visszafejtést vagy üzenet ellenőrzést eredményezhet.
    Kikapcsolja az „idézett-nyomtatható” üzeneteket?
minimal-line-wrapping =
    { $width } karakteresre állította a sortördelést. A helyes titkosításhoz és aláíráshoz ennek az értéknek legalább 68-nak kell lennie.
    68 karakteresre állítja a sortördelést?
sending-news =
    A titkosított küldési művelet megszakítva.
    Ezt az üzenetet nem lehet titkosítani, mert vannak hírcsoport-címzettek. Küldje el újra az üzenetet titkosítás nélkül.
send-to-news-warning =
    Figyelmeztetés: arra készül, hogy titkosított üzenetet küljdön egy hírcsoportnak.
    Ez nem javasolt, mert csak akkor van értelme, ha a csoport összes tagja vissza tudja fejteni az üzenetet, azaz az üzenetet az összes résztvevő kulcsával titkosítani kell. Csak akkor küldje el ezt a levelet, ha pontosan tudja mit csinál.
    Folytatja?
save-attachment-header = Visszafejtett melléklet mentése
no-temp-dir =
    Nem található ideiglenes könyvtár, amelybe írni lehetne
    Állítsa be a TEMP környezeti változót
possibly-pgp-mime = Lehet, hogy PGP/MIME segítségével titkosított vagy aláírt üzenet; az ellenőrzéshez használja a „Visszafejtés/Ellenőrzés” funkciót
cannot-send-sig-because-no-own-key = Nem lehet digitálisan aláírni ezt az üzenetet, mert még nem állította be a végpontok közti titkosítást a(z) <{ $key }> számára
cannot-send-enc-because-no-own-key = Nem küldheti el titkosítva ezt az üzenetet, mert még nem állította be a végpontok közti titkosítást a(z) <{ $key }> számára

compose-menu-attach-key =
    .label = Saját nyilvános kulcs mellékelése
    .accesskey = m
compose-menu-encrypt-subject =
    .label = Tárgy titkosítása
    .accesskey = T

# Strings used in decryption.jsm
do-import-multiple =
    Importálja a következő kulcsokat?
    { $key }
do-import-one = { $name } ({ $id }) importálása?
cant-import = Hiba a nyilvános kulcs importálásakor
unverified-reply = A behúzott üzenetrész (válasz) valószínűleg módosítva lett
key-in-message-body = Kulcs található az üzenettörzsben. Az importálásához kattintson a „Kulcs importálására”
sig-mismatch = Hiba – az aláírás nem egyezik meg
invalid-email = Hiba – érvénytelen e-mail-címek
attachment-pgp-key =
    A(z) „{ $name }” melléklet amit megnyit egy OpenPGP-kulcsfájlnak tűnik.
    Kattintson az „Importálásra” a tartalmazott kulcs importálásához, vagy a „Nézetre”, hogy megtekintse a fájl tartalmát egy böngészőablakban
dlg-button-view = &Nézet

# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Visszafejtett üzenet (visszaállított hibás PGP e-mail-formátum, valószínűleg egy régi Exchange kiszolgáló miatt, így az eredmény lehet, hogy nem tökéletesen olvasható)

# Strings used in encryption.jsm
not-required = Hiba – titkosítás nem szükséges

# Strings used in windows.jsm
no-photo-available = Nincs elérhető fénykép
error-photo-path-not-readable = A(z) „{ $photo }” fényképútvonal nem olvasható
debug-log-title = OpenPGP hibakeresési napló

# Strings used in dialog.jsm
repeat-prefix = Ez a figyelmeztetés { $count }
repeat-suffix-singular = alkalommal meg lesz ismételve.
repeat-suffix-plural = alkalommal meg lesz ismételve.
no-repeat = Ez a figyelmeztetés nem jelenik meg újra.
dlg-keep-setting = Jegyezze meg a válaszomat, és ne kérdezze meg újra
dlg-button-ok = &Rendben
dlg-button-close = &Bezárás
dlg-button-cancel = &Mégse
dlg-no-prompt = Ne jelenjen meg többet ez a párbeszédablak
enig-prompt = OpenPGP kérdés
enig-confirm = OpenPGP megerősítés
enig-alert = OpenPGP figyelmeztetés
enig-info = OpenPGP információ

# Strings used in persistentCrypto.jsm
dlg-button-retry = Új&ra
dlg-button-skip = &Kihagyás

# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = OpenPGP figyelmeztetés
