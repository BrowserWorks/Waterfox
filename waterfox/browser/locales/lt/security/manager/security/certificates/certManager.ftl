# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Liudijimų tvarkytuvė

certmgr-tab-mine =
    .label = Jūsų liudijimai

certmgr-tab-remembered =
    .label = Tapatumo tikrinimo sprendimai

certmgr-tab-people =
    .label = Asmenų

certmgr-tab-servers =
    .label = Serverių

certmgr-tab-ca =
    .label = Liudijimų įstaigų

certmgr-mine = Turite liudijimus, išduotus šių jus identifikuojančių įstaigų
certmgr-remembered = Šie liudijimai naudojami jūsų tapatumo patvirtinimui svetainėse
certmgr-people = Turite liudijimus, identifikuojančius šiuos asmenis
certmgr-server = Šie įrašai nurodo serverių liudijimų klaidų išimtis
certmgr-ca = Turite liudijimus, identifikuojančius šias liudijimų įstaigas

certmgr-edit-ca-cert =
    .title = Pasitikėjimo LĮ liudijimu nuostatos
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Pasitikėjimo nuostatos:

certmgr-edit-cert-trust-ssl =
    .label = Šis liudijimas gali patvirtinti svetainių tapatybę

certmgr-edit-cert-trust-email =
    .label = Šis liudijimas gali patvirtinti el. pašto naudotojų tapatybę

certmgr-delete-cert =
    .title = Liudijimo šalinimas
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Serveris

certmgr-cert-name =
    .label = Liudijimo vardas

certmgr-cert-server =
    .label = Serveris

certmgr-override-lifetime =
    .label = Galiojimo laikas

certmgr-token-name =
    .label = Saugumo priemonė

certmgr-begins-label =
    .label = Prasideda

certmgr-expires-label =
    .label = Baigiasi

certmgr-email =
    .label = El. pašto adresas

certmgr-serial =
    .label = Numeris

certmgr-view =
    .label = Peržiūrėti…
    .accesskey = P

certmgr-edit =
    .label = Taisyti pasitikėjimą…
    .accesskey = T

certmgr-export =
    .label = Eksportuoti…
    .accesskey = E

certmgr-delete =
    .label = Pašalinti…
    .accesskey = š

certmgr-delete-builtin =
    .label = Pašalinti arba nepasitikėti…
    .accesskey = š

certmgr-backup =
    .label = Archyvuoti…
    .accesskey = A

certmgr-backup-all =
    .label = Archyvuoti viską…
    .accesskey = v

certmgr-restore =
    .label = Importuoti…
    .accesskey = I

certmgr-add-exception =
    .label = Pritaikyti išimtį…
    .accesskey = m

exception-mgr =
    .title = Saugumo išimties pritaikymas

exception-mgr-extra-button =
    .label = Patvirtinti saugumo išimtį
    .accesskey = P

exception-mgr-supplemental-warning = Patikimi bankai, parduotuvės ir kitos viešos svetainės neprašytų šito daryti.

exception-mgr-cert-location-url =
    .value = Adresas:

exception-mgr-cert-location-download =
    .label = Atsiųsti liudijimą
    .accesskey = A

exception-mgr-cert-status-view-cert =
    .label = Parodyti…
    .accesskey = r

exception-mgr-permanent =
    .label = Įrašyti šią išimtį visam laikui
    .accesskey = v

pk11-bad-password = Neteisingas slaptažodis.
pkcs12-decode-err = Klaida iškoduojant failą.  Priežastys gali būti šios: ne PKCS Nr. 12 formatas, pažeistas failas arba įvestas neteisingas slaptažodis.
pkcs12-unknown-err-restore = Nepavyko atstatyti PKCS Nr. 12 failo (priežastis neaiški).
pkcs12-unknown-err-backup = Nepavyko sukurti PKCS Nr. 12 atsarginio failo (priežastis neaiški).
pkcs12-unknown-err = Nepavyko PKCS Nr. 12 operacija (priežastis neaiški).
pkcs12-info-no-smartcard-backup = Aparatinėje įrangoje (pvz., lustinėje kortelėje) esančio liudijimo atsarginės kopijos nedaromos.
pkcs12-dup-data = Saugumo priemonėje šis liudijimas ir privatusis raktas jau yra.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Archyvuojamo failo vardas
file-browse-pkcs12-spec = PKCS12 failai
choose-p12-restore-file-dialog = Importuotino failo vardas

## Import certificate(s) file dialog

file-browse-certificate-spec = Liudijimų failai
import-ca-certs-prompt = Parinkite failą, kuriame yra importuojamas LĮ liudijimas
import-email-cert-prompt = Parinkite failą, kuriame yra importuojamas el. pašto liudijimas

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Liudijimas „{ $certName }“ atstovauja liudijimų įstaigą.

## For Deleting Certificates

delete-user-cert-title =
    .title = Jūsų liudijimų šalinimas
delete-user-cert-confirm = Ar tikrai pašalinti šiuos liudijimus?
delete-user-cert-impact = Jei pašalinsite asmeninį liudijimą, nebegalėsite juo patvirtinti savo tapatybės.


delete-ssl-override-title =
    .title = Pašalinti serverio liudijimo išimtį
delete-ssl-override-confirm = Ar tikrai pašalinti šiam serveriui taikomą išimtį?
delete-ssl-override-impact = Nustojus serveriui taikyti išimtį, šiai sričiai bus taikomos įprastos saugumo patikros procedūros ir bus reikalaujama galiojančio liudijimo.

delete-ca-cert-title =
    .title = Pasitikėjimo LĮ liudijimais nutraukimas ir jų šalinimas
delete-ca-cert-confirm = Jūs nurodėte pašalinti šiuos LĮ liudijimus. Įtaisytųjų liudijimų atveju, užuot juos pašalinus, bus visiškai nutrauktas pasitikėjimas jais (šio veiksmo efektas toks pat). Ar norite, kad liudijimai būtų pašalinti arba nutrauktas pasitikėjimas jais?
delete-ca-cert-impact = Pašalinus liudijimų įstaigos (LĮ) liudijimą arba nutraukus pasitikėjimą juo, programa nebepasitikės jokiais šios LĮ išduodamais liudijimais.


delete-email-cert-title =
    .title = El. pašto liudijimų šalinimas
delete-email-cert-confirm = Ar tikrai pašalinti šių asmenų el. pašto liudijimus?
delete-email-cert-impact = Jei pašalinsite adresato el. pašto liudijimą, nebegalėsite jam siųsti šifruotų laiškų.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Liudijimas su numeriu: { $serialNumber }

## Cert Viewer

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Nesiųsti kliento liudijimo

# Used when no cert is stored for an override
no-cert-stored-for-override = (Neįrašytas)

# When a certificate is unavailable (for example, it has been deleted or the token it exists on has been removed).
certificate-not-available = (Nepasiekiamas)

## Used to show whether an override is temporary or permanent

permanent-override = Visam laikui
temporary-override = Laikinai

## Add Security Exception dialog

add-exception-branded-warning = Ketinate šiai svetainei netaikyti „{ -brand-short-name }“ tapatybės duomenų patikros procedūros.
add-exception-invalid-header = Ši svetainė bando patvirtinti savo tapatybę, naudodama netinkamus duomenis.
add-exception-domain-mismatch-short = Ne ta svetainė
add-exception-domain-mismatch-long = Šis liudijimas priklauso kitai svetainei, tad gali būti, kad kažkas bando apsimesti ta svetaine.
add-exception-expired-short = Pasenę duomenys
add-exception-expired-long = Šis liudijimas nėra galiojantis. Jis galėjo būti pavogtas arba pamestas, tad gali būti kažkieno naudojamas siekiant apsimesti šia svetaine.
add-exception-unverified-or-bad-signature-short = Nežinoma tapatybė
add-exception-unverified-or-bad-signature-long = Liudijimas nėra patikimas, nes jis nebuvo patvirtintas saugiu parašu patikimoje įstaigoje.
add-exception-valid-short = Liudijimas galioja
add-exception-valid-long = Ši svetainės tapatybė tiksli ir patvirtinta. Nėra poreikio pridėti išimčiai.
add-exception-checking-short = Tikrinami duomenys
add-exception-checking-long = Bandoma patikrinti svetainės tapatybę…
add-exception-no-cert-short = Nėra duomenų
add-exception-no-cert-long = Nepavyko sužinoti šios svetainės tapatybės duomenų.

## Certificate export "Save as" and error dialogs

save-cert-as = Įrašyti liudijimą į failą
cert-format-base64 = X.509 liudijimas (PEM)
cert-format-base64-chain = X.509 liudijimas su grandine (PEM)
cert-format-der = X.509 liudijimas (DER)
cert-format-pkcs7 = X.509 liudijimas (PKCS#7)
cert-format-pkcs7-chain = X.509 liudijimas su grandine (PKCS#7)
write-file-failure = Failo klaida
