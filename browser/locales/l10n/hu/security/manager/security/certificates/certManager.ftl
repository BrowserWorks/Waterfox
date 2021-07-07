# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Tanúsítványkezelő

certmgr-tab-mine =
    .label = Saját tanúsítványok

certmgr-tab-remembered =
    .label = Hitelesítési döntések

certmgr-tab-people =
    .label = Emberek

certmgr-tab-servers =
    .label = Kiszolgálók

certmgr-tab-ca =
    .label = Hitelesítésszolgáltatók

certmgr-mine = A következő szervezetektől vannak Önt azonosító tanúsítványok
certmgr-remembered = Ezekkel a tanúsítványokkal azonosítja magát a webhelyek felé
certmgr-people = A következő embereket lehet azonosítani a meglevő tanúsítványokkal
certmgr-server = Ezek a bejegyzések kiszolgálói tanúsítványhiba kivételeket azonosítanak
certmgr-ca = A következő hitelesítésszolgáltatókat lehet azonosítani a meglevő tanúsítványokkal

certmgr-edit-ca-cert =
    .title = Hitelesítésszolgáltató tanúsítványa megbízhatóságának beállítása
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Megbízhatósági beállítások megadása:

certmgr-edit-cert-trust-ssl =
    .label = Ez a tanúsítvány használható webhelyek azonosítására.

certmgr-edit-cert-trust-email =
    .label = Ez a tanúsítvány használható elektronikus levelek feladóinak azonosítására.

certmgr-delete-cert =
    .title = Tanúsítvány törlése
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Gép

certmgr-cert-name =
    .label = Tanúsítvány neve

certmgr-cert-server =
    .label = Kiszolgáló

certmgr-override-lifetime =
    .label = Élettartam

certmgr-token-name =
    .label = Adatvédelmi eszköz

certmgr-begins-label =
    .label = Érvényesség kezdete

certmgr-expires-label =
    .label = Lejárat dátuma

certmgr-email =
    .label = E-mail cím

certmgr-serial =
    .label = Sorozatszám

certmgr-view =
    .label = Megtekintés…
    .accesskey = M

certmgr-edit =
    .label = Bizalom szerkesztése…
    .accesskey = B

certmgr-export =
    .label = Exportálás…
    .accesskey = x

certmgr-delete =
    .label = Törlés…
    .accesskey = T

certmgr-delete-builtin =
    .label = Törlés vagy bizalom visszavonása…
    .accesskey = v

certmgr-backup =
    .label = Mentés…
    .accesskey = e

certmgr-backup-all =
    .label = Biztonsági mentés mindenről…
    .accesskey = s

certmgr-restore =
    .label = Importálás…
    .accesskey = I

certmgr-add-exception =
    .label = Kivétel hozzáadása…
    .accesskey = h

exception-mgr =
    .title = Biztonsági kivétel hozzáadása

exception-mgr-extra-button =
    .label = Biztonsági kivétel megerősítése
    .accesskey = B

exception-mgr-supplemental-warning = Törvényesen működő bankok, üzletek és nyilvános webhelyek nem kérnek ilyesmit.

exception-mgr-cert-location-url =
    .value = Hely:

exception-mgr-cert-location-download =
    .label = Tanúsítvány letöltése
    .accesskey = T

exception-mgr-cert-status-view-cert =
    .label = Megtekintés…
    .accesskey = M

exception-mgr-permanent =
    .label = Kivétel megőrzése
    .accesskey = K

pk11-bad-password = Hibás a megadott jelszó.
pkcs12-decode-err = A fájl dekódolása nem sikerült.  Vagy nem PKCS #12 formátumban van, vagy megsérült, vagy a megadott jelszó hibás.
pkcs12-unknown-err-restore = A PKCS #12 fájl visszaállítása ismeretlen okokból nem sikerült.
pkcs12-unknown-err-backup = A PKCS #12 biztonsági mentés fájl létrehozása ismeretlen okokból nem sikerült.
pkcs12-unknown-err = A PKCS #12 művelet ismeretlen okokból nem sikerült.
pkcs12-info-no-smartcard-backup = Nem lehet biztonsági mentést készíteni a tanúsítványokról olyan biztonsági hardver eszközökről, mint az intelligens chipkártya.
pkcs12-dup-data = A tanúsítvány és a személyes kulcs már létezik az adatvédelmi eszközön.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Elmentendő fájl neve
file-browse-pkcs12-spec = PKCS12-fájlok
choose-p12-restore-file-dialog = Importálandó tanúsítványfájl

## Import certificate(s) file dialog

file-browse-certificate-spec = Tanúsítványok
import-ca-certs-prompt = Válassza ki a fájlt, amelyben az importálandó CA-tanúsítvány van
import-email-cert-prompt = Válassza ki a fájlt, amelyben az importálandó e-mail tanúsítvány van

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = A(z) „{ $certName }” tanúsítvány egy hitelesítésszolgáltatót reprezentál.

## For Deleting Certificates

delete-user-cert-title =
    .title = Tanúsítványok törlése
delete-user-cert-confirm = Biztosan törölni akarja ezeket a tanúsítványokat?
delete-user-cert-impact = Ha valamely saját tanúsítványodat törli, akkor többé nem használhatja saját maga azonosítására.


delete-ssl-override-title =
    .title = Kiszolgálói tanúsítvány kivételek törlése
delete-ssl-override-confirm = Biztos, hogy törli ezeket a kiszolgáló-kivételeket?
delete-ssl-override-impact = A kiszolgáló-kivétel törlésével a kiszolgálóra visszaállnak az eredeti biztonsági ellenőrzések, és kötelező lesz az érvényes tanúsítvány használata.

delete-ca-cert-title =
    .title = CA-tanúsítványok törlése vagy bizalom visszavonása
delete-ca-cert-confirm = A következő CA-tanúsítványok törlését kezdeményezte. A beépített tanúsítványok esetén a bizalom lesz visszavonva, ami ugyanazt eredményezi. Biztosan töröl vagy visszavonja a bizalmat?
delete-ca-cert-impact = Ha egy hitelesítésszolgáltató (CA) tanúsítványát törli vagy a bizalmát attól visszavonja, az alkalmazás nem fog megbízni az általa kiadott tanúsítványokban.


delete-email-cert-title =
    .title = E-mail tanúsítványok törlése
delete-email-cert-confirm = Biztosan törölni akarja ezen emberek e-mail tanúsítványát?
delete-email-cert-impact = Ha törli valakinek az e-mail tanúsítványát, többé nem tud kódolt levelet küldeni az illetőnek.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Tanúsítvány ezen sorozatszámmal: { $serialNumber }

## Cert Viewer

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Ne küldjön ügyféltanúsítványt

# Used when no cert is stored for an override
no-cert-stored-for-override = (nincs tárolva)

# When a certificate is unavailable (for example, it has been deleted or the token it exists on has been removed).
certificate-not-available = (Nem érhető el)

## Used to show whether an override is temporary or permanent

permanent-override = Állandó
temporary-override = Ideiglenes

## Add Security Exception dialog

add-exception-branded-warning = Arra készül, hogy felülbírálja a webhely { -brand-short-name } általi besorolását.
add-exception-invalid-header = Ez a webhely érvénytelen adatokkal próbálja azonosítani magát.
add-exception-domain-mismatch-short = Rossz webhely
add-exception-domain-mismatch-long = A tanúsítvány egy másik webhelyhez tartozik, azaz valaki megpróbálhatja ennek a webhelynek kiadni magát.
add-exception-expired-short = Elavult információ
add-exception-expired-long = A tanúsítvány már nem érvényes. Lehet, hogy ellopták vagy elveszett, és valaki megpróbálhatja ennek a webhelynek kiadni magát.
add-exception-unverified-or-bad-signature-short = Ismeretlen identitás
add-exception-unverified-or-bad-signature-long = A tanúsítvány nem megbízható, mert nem ellenőrizte kibocsátottként egy biztonságos aláírást használó elismert hatóság.
add-exception-valid-short = Érvényes tanúsítvány
add-exception-valid-long = A webhely érvényesen, ellenőrzötten azonosította magát. Nem kell kivételt hozzáadni.
add-exception-checking-short = Adatok ellenőrzése
add-exception-checking-long = Kísérlet a webhely azonosítására…
add-exception-no-cert-short = Nem áll rendelkezésre információ
add-exception-no-cert-long = Nem lehet a webhely azonosítási állapotát lekérdezni.

## Certificate export "Save as" and error dialogs

save-cert-as = Tanúsítvány mentése fájlba
cert-format-base64 = X.509 tanúsítvány (PEM)
cert-format-base64-chain = X.509 tanúsítvány lánccal (PEM)
cert-format-der = X.509 tanúsítvány (DER)
cert-format-pkcs7 = X.509 tanúsítvány (PKCS#7)
cert-format-pkcs7-chain = X.509 tanúsítvány lánccal (PKCS#7)
write-file-failure = Fájlhiba
