# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-manage-keys-openpgp-cmd =
    .label = OpenPGP-nyckelhanterare
    .accesskey = O

openpgp-ctx-decrypt-open =
    .label = Dekryptera och öppna
    .accesskey = D
openpgp-ctx-decrypt-save =
    .label = Dekryptera och spara som…
    .accesskey = k
openpgp-ctx-import-key =
    .label = Importera OpenPGP-nyckel
    .accesskey = m
openpgp-ctx-verify-att =
    .label = Verifiera signatur
    .accesskey = V

openpgp-has-sender-key = Det här meddelandet påstår sig innehålla avsändarens publika OpenPGP-nyckel.
openpgp-be-careful-new-key = Varning: Den nya publika OpenPGP-nyckeln i det här meddelandet skiljer sig från de publika nycklarna som du tidigare accepterade för { $email }.

openpgp-import-sender-key =
    .label = Importera…

openpgp-search-keys-openpgp =
    .label = Hitta OpenPGP-nyckel

openpgp-missing-signature-key = Det här meddelandet var signerat med en nyckel som du inte har ännu.

openpgp-search-signature-key =
    .label = Hitta…

# Don't translate the terms "OpenPGP" and "MS-Exchange"
openpgp-broken-exchange-opened = Detta är ett OpenPGP-meddelande som uppenbarligen skadades av MS-Exchange och det kan inte repareras eftersom det öppnades från en lokal fil. Kopiera meddelandet till en e-postmapp för att prova en automatisk reparation.
openpgp-broken-exchange-info = Detta är ett OpenPGP-meddelande som tydligen skadades av MS-Exchange. Om meddelandets innehåll inte visas som förväntat kan du prova en automatisk reparation.
openpgp-broken-exchange-repair =
    .label = Reparera meddelande
openpgp-broken-exchange-wait = Var god vänta…

openpgp-cannot-decrypt-because-mdc =
    Detta är ett krypterat meddelande som använder en gammal och sårbar mekanism.
    Det kunde ha ändrats under transporten, med avsikt att stjäla innehållet.
    För att förhindra denna risk visas inte innehållet.

openpgp-cannot-decrypt-because-missing-key = Den hemliga nyckeln som krävs för att dekryptera detta meddelande är inte tillgänglig.

openpgp-partially-signed =
    Endast en delmängd av detta meddelande signerades digitalt med OpenPGP.
    Om du klickar på verifieringsknappen döljs de oskyddade delarna och statusen för den digitala signaturen visas.

openpgp-partially-encrypted =
    Endast en delmängd av det här meddelandet krypterades med OpenPGP.
    De läsbara delarna av meddelandet som redan visas krypterades inte.
    Om du klickar på dekryptera-knappen visas innehållet i de krypterade delarna.

openpgp-reminder-partial-display = Påminnelse: Meddelandet som visas nedan är bara en delmängd av det ursprungliga meddelandet.

openpgp-partial-verify-button = Verifiera
openpgp-partial-decrypt-button = Dekryptera

