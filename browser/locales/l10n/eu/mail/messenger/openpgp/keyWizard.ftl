# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Gehitu OpenPGP gako pertsonala { $identity }(e)ntzat
key-wizard-button =
    .buttonlabelaccept = Jarraitu
    .buttonlabelhelp = atzera
key-wizard-warning = Posta elektroniko honetarako <b>jada badaukazu gako pertsonala</b>, inportatu beharko zenuke. Bestela ezingo zara sartu zure artxibatutako zifratutako mezuetara, ezta jada badaukazun gakoa erabiltzen ari diren jendearen mezu berriak irakurtzeko ere.
key-wizard-learn-more = Argibide gehiago
radio-create-key =
    .label = Sortu OpenPGP gako berria
    .accesskey = S
radio-import-key =
    .label = Inportatu badagoen OpenPGP gakoa
    .accesskey = I
radio-gnupg-key =
    .label = Erabili zure kanpoko gakoa GnuPG zehar (Adibidez txartel digitala)
    .accesskey = E

## Generate key section

openpgp-generate-key-title = Sortarazi OpenPGP gakoa
openpgp-generate-key-info = <b>Gakoa sortzeak hainbat minutu har ditzake burutu artean.</b> Ez irten aplikaziotik gakoa sortzen ari denean.  Gakoa sortzen ari denean, nabigatze aktiboak edo disko erabilera intentsiboa dakarten eragiketek 'ausazkotasunaren multzoa' berriz beteko dute eta prozesua azkartu. Gakoa sortzea amaitzean jakinaraziko zaizu.
openpgp-keygen-expiry-title = Gakoaren iraungitzea
openpgp-keygen-expiry-description = Definitu sortu berri duzun gakoaren iraungitze denbora. Ondoren data kontrola dezakezu luzatzea beharrezkoa balitz.
radio-keygen-expiry =
    .label = Gakoa iraungitzen da
    .accesskey = G
radio-keygen-no-expiry =
    .label = Gakoa ez da iraungitzen
    .accesskey = e
openpgp-keygen-days-label =
    .label = egun
openpgp-keygen-months-label =
    .label = hilabete
openpgp-keygen-years-label =
    .label = urte
openpgp-keygen-advanced-title = Ezarpen aurreratuak
openpgp-keygen-advanced-description = Kontrolatu zure OpenPGP gakoaren ezarpen aurreratuak.
openpgp-keygen-keytype =
    .value = Gako mota:
    .accesskey = m
openpgp-keygen-keysize =
    .value = Gako tamaina:
    .accesskey = t
openpgp-keygen-type-rsa =
    .label = RSA
openpgp-keygen-type-ecc =
    .label = ECC (kurba eliptikoa)
openpgp-keygen-button = Sortu gakoa
openpgp-keygen-progress-title = OpenPGP gako berria sortzen…
openpgp-keygen-import-progress-title = Zure OpenPGP gakoak inportzatzen…
openpgp-import-success = OpenPGP gakoak ondo inportatu dira!
openpgp-import-success-title = Burutu inportazio prozesua
openpgp-import-success-description = zure inportatutako OpenPGP gakoak posta zifratuetan erabiltzen hasteko, itxi elkarrizketa hau eta joan zure kontuaren ezarpenetara aukeratzeko.
openpgp-keygen-confirm =
    .label = Berretsi
openpgp-keygen-dismiss =
    .label = Utzi
openpgp-keygen-cancel =
    .label = utzi prozesua…
openpgp-keygen-import-complete =
    .label = Itxi
    .accesskey = I
openpgp-keygen-missing-username = Ez dago izenik zehaztuta uneko konturako. Mesedez sartu balioa  "zure Izena" eremuan kontuko ezarpenetan.
openpgp-keygen-long-expiry = Ezin duzu sortu, 100 urte baino beranduago iraungiko den gakoa.
openpgp-keygen-short-expiry = Zure gakoa askoz jota egun baten balioztatu beharko da.
openpgp-keygen-ongoing = Gakoaren sorrera abian da!
openpgp-keygen-error-core = Ezin da abiarazi OpenPGP zerbitzu nagusia
openpgp-keygen-error-failed = OpenPGP gako sorrera ustekabean huts egin du
#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = OpenPGP gakoa ondo sortu da, baina huts egin du errebokazio gakoaren sorrerak { $key } gakoarentzat
openpgp-keygen-abort-title = Bertan behera utzi sorrera?
openpgp-keygen-abort = OpenPGP gakoa sortzen ari da, ziur zaude utzi nahi duzula?
#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Sortu gako publiko eta sekretua { $identity } identitaterako?

## Import Key section

openpgp-import-key-title = Inportatu badagoen OpenPGP gako pertsonala
openpgp-import-key-legend = Aukeratu aurreko babeskopia fitxategia.
openpgp-import-key-description = Zuk beste OpenPGP software batekin sortutako gako pertsonalak inportatu ditzakezu.
openpgp-import-key-info = Beste software batzuk gako pertsonala beste termino batzuekin izendatu dezakete norberaren gakoa, gako pribatua edo gako parea bezalakoak.
#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird inportatu daitekeen gako bat aurkitu du.
       *[other] Thunderbird inportatu daitezkeen { $count } gako aurkitu ditu.
    }
openpgp-import-key-list-description = Berretsi zein gako tratatu behar diren gako pertsonal bezala. Zuk zeuk sortutako gakoak eta zure identitatea erakusten duten gakoak erabili beharko zenituzke gako pertsonal bezala. Gerora aukera hau aldatu dezakezu gakoen propietate elkarrizketa-leihoan.
openpgp-import-key-list-caption = Gako pertsonal bezala markatutako gakoak muturretik-muturrera zifratutako sekzioan zerrendatuko dira. Besteak eskuragarri egongo dira gako kudeatzailearen barnean.
openpgp-passphrase-prompt-title = Pasa-esaldia behar da
#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Mesedez sartu pasa-esaldia ondorengo gakoa desblokeatzeko: { $key }
openpgp-import-key-button =
    .label = Aukeratu fitxategia inportatzeko…
    .accesskey = A
import-key-file = Inportatu OpenPGP gako fitxategia
import-key-personal-checkbox =
    .label = Tratatu gako hau pertsonal gako bezala
gnupg-file = GnuPG fitxategiak
import-error-file-size = <b>Errorea!</b> 5MB baino fitxategi handiagoek ez dute euskarririk.
#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Errorea!</b> Fitxategia inportatzeak huts egin du. { $error }
#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Errorea!</b> Gakoa inportatzeak huts egin du. { $error }
openpgp-import-identity-label = Identitatea
openpgp-import-fingerprint-label = Hatz-marka
openpgp-import-created-label = Sortuta
openpgp-import-bits-label = bit
openpgp-import-key-props =
    .label = Gako propietateak
    .accesskey = G

## External Key section

openpgp-external-key-title = Kanpoko GnuPG gakoa
openpgp-external-key-description = Konfiguratu kanpoko GnuPG gako bat gakoaren ID sartuz
openpgp-external-key-info = Honez gain, Gako kudeatzailea erabili beharko zenuke dagokion gako publikoa inportatu eta onartzeko.
openpgp-external-key-warning = <b>Kanpo GnuPG gako bat bakarrik konfiguratu dezakezu.</b> Zure aurreko sarrera ordezkatuko da.
openpgp-save-external-button = Gorde gako ID
openpgp-external-key-label = Gako sekretu ID:
openpgp-external-key-input =
    .placeholder = 123456789341298340
