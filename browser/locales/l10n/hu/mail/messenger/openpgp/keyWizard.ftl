# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Személyes OpenPGP-kulcs hozzáadása { $identity } számára

key-wizard-button =
    .buttonlabelaccept = Tovább
    .buttonlabelhelp = Vissza

key-wizard-warning = <b>Ha van létező személyes kulcsa</b> ehhez az e-mail-címhez, akkor importálnia kell. Ellenkező esetben nem férhet hozzá titkosított e-mailek archívumához, és nem fogja tudni elolvasni az olyan emberektől bejövő titkosított e-maileket, akik továbbra is használják a meglévő kulcsát.

key-wizard-learn-more = További tudnivalók

radio-create-key =
    .label = Új OpenPGP kulcs létrehozása
    .accesskey = l

radio-import-key =
    .label = Meglévő OpenPGP kulcs importálása
    .accesskey = i

radio-gnupg-key =
    .label = Külső kulcs használata GnuPG segítségével (például intelligens kártyáról)
    .accesskey = K

## Generate key section

openpgp-generate-key-title = OpenPGP kulcs előállítása

openpgp-generate-key-info = <b>A kulcs előállítása akár néhány percet is igénybe vehet.</b> Ne zárja be az alkalmazást, amíg a kulcs előállítása folyamatban van. A kulcselőállítás során az aktív böngészés vagy a lemezintenzív műveletek feltöltik a „véletlenszerűségi készletet”, és ez felgyorsítja a folyamatot. Értesítést kap, amikor a kulcselőállítás befejeződött.

openpgp-keygen-expiry-title = Kulcs lejárata

openpgp-keygen-expiry-description = Adja meg az újonnan előállított kulcs lejárati idejét. Később is meghosszabbíthatja, ha szükséges.

radio-keygen-expiry =
    .label = A kulcs lejár:
    .accesskey = e

radio-keygen-no-expiry =
    .label = A kulcs nem jár le
    .accesskey = n

openpgp-keygen-days-label =
    .label = nap múlva
openpgp-keygen-months-label =
    .label = hónap múlva
openpgp-keygen-years-label =
    .label = év múlva

openpgp-keygen-advanced-title = Speciális beállítások

openpgp-keygen-advanced-description = Az OpenPGP-kulcs speciális beállításainak vezérlése

openpgp-keygen-keytype =
    .value = Kulcs típusa:
    .accesskey = t

openpgp-keygen-keysize =
    .value = Kulcsméret:
    .accesskey = s

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (elliptikus görbe)

openpgp-keygen-button = Kulcs előállítása

openpgp-keygen-progress-title = Új OpenPGP-kulcs előállítása…

openpgp-keygen-import-progress-title = OpenPGP-kulcsok importálása…

openpgp-import-success = Az OpenPGP kulcsok importálása sikerült!

openpgp-import-success-title = Importálási folyamat befejezése

openpgp-import-success-description = Az importált OpenPGP-kulcs e-mail titkosításhoz történő használatához zárja be ezt a párbeszédablakot, és válassza ki a Fiókbeállításokban.

openpgp-keygen-confirm =
    .label = Megerősítés

openpgp-keygen-dismiss =
    .label = Mégse

openpgp-keygen-cancel =
    .label = Folyamat megszakítása…

openpgp-keygen-import-complete =
    .label = Bezárás
    .accesskey = B

openpgp-keygen-missing-username = A jelenlegi fiókhoz nincs megadva név. Adjon meg egy értéket a fiókbeállítások  "Az Ön neve" mezőjében.
openpgp-keygen-long-expiry = Nem hozhat létre olyan kulcsot, amely több mint 100 év múlva jár le.
openpgp-keygen-short-expiry = A kulcsának legalább egy napig érvényesnek kell lennie.

openpgp-keygen-ongoing = A kulcselőállítás már folyamatban van.

openpgp-keygen-error-core = Az OpenPGP központi szolgáltatás előkészítése sikertelen

openpgp-keygen-error-failed = Az OpenPGP-kulcs előállítása váratlanul sikertelen

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = A(z) OpenPGP-kulcs létrehozása sikeres, de nem sikerült megszerezni a(z) { $key } kulcs visszavonását.

openpgp-keygen-abort-title = Megszakítja a kulcselőállítást?
openpgp-keygen-abort = Az OpenPGP-kulcs előállítása jelenleg folyamatban van, biztos megszakítja?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Előállítja a nyilvános és titkos kulcsot { $identity } számára?

## Import Key section

openpgp-import-key-title = Meglévő személyes OpenPGP-kulcs importálása

openpgp-import-key-legend = Válasszon egy korábbi biztonsági mentési fájlt.

openpgp-import-key-description = Importálhat személyes kulcsokat más OpenPGP-t használó szoftverekből.

openpgp-import-key-info = Más szoftverek másként nevezhetik a személyes kulcsot, például: saját kulcs, titkos kulcs, privát kulcs vagy kulcspár.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] A Thunderbird egy kulcsot talált, amely importálható.
       *[other] A Thunderbird { $count } kulcsot talált, amely importálható.
    }

openpgp-import-key-list-description = Erősítse meg, hogy mely kulcsok kezelhetők személyes kulcsaiként. Csak azokat a kulcsokat használja személyes kulcsként, amelyeket saját maga készített, és az Ön személyazonosságát mutatják. Ezt a beállítást később is megváltoztathatja a Kulcstulajdonságok párbeszédablakon.

openpgp-import-key-list-caption = A személyes kulcsként kezeltként megjelölt kulcsok a végpontok közötti titkosítás szakaszban vannak felsorolva. A többi a Kulcskezelőben érhető el.

openpgp-passphrase-prompt-title = Jelmondat szükséges

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Írja be a jelmondatot a következő kulcs feloldásához: { $key }

openpgp-import-key-button =
    .label = Válassza ki az importálandó fájlt…
    .accesskey = V

import-key-file = OpenPGP-kulcsfájl importálása

import-key-personal-checkbox =
    .label = E kulcs személyes kulcsként kezelése

gnupg-file = GnuPG-fájlok

import-error-file-size = <b>Hiba!</b> Az 5 MB-nál nagyobb fájlok nem támogatottak.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Hiba!</b> A fájl importálása sikertelen. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Hiba!</b> A kulcsok importálása sikertelen. { $error }

openpgp-import-identity-label = Személyazonosság

openpgp-import-fingerprint-label = Ujjlenyomat

openpgp-import-created-label = Létrehozva

openpgp-import-bits-label = Bitek

openpgp-import-key-props =
    .label = Kulcs tulajdonságai
    .accesskey = K

## External Key section

openpgp-external-key-title = Külső GnuPG-kulcs

openpgp-external-key-description = Kulső GnuPG-kulcs beállítása a kulcsazonosító megadásával

openpgp-external-key-info = Továbbá a Kulcskezelő használatával kell importálnia és elfogadnia a megfelelő nyilvános kulcsot.

openpgp-external-key-warning = <b>Csak egy külső GnuPG-kulcsot konfigurálhat.</b> Az előző bejegyzés felül lesz írva.

openpgp-save-external-button = Kulcsazonosító mentése

openpgp-external-key-label = Titkos kulcsazonosító:

openpgp-external-key-input =
    .placeholder = 123456789341298340
