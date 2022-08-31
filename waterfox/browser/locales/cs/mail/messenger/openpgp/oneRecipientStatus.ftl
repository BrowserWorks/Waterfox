# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-one-recipient-status-title =
    .title = Zabezpečení zpráv pomocí OpenPGP
openpgp-one-recipient-status-status =
    .label = Stav
openpgp-one-recipient-status-key-id =
    .label = ID klíče
openpgp-one-recipient-status-created-date =
    .label = Vytvořen
openpgp-one-recipient-status-expires-date =
    .label = Platnost do
openpgp-one-recipient-status-open-details =
    .label = Zobrazit podrobnosti a upravit přijetí…
openpgp-one-recipient-status-discover =
    .label = Najít nový nebo aktualizovaný klíč
openpgp-one-recipient-status-instruction1 = Abyste mohli příjemci odeslat zprávu šifrovaně, musíte získat jeho veřejný klíč OpenPGP a označit ho jako přijatý.
openpgp-one-recipient-status-instruction2 = Veřejný klíč příjemce získáte tak, že ho buď naimportujete z e-mailové zprávy, ve které vám ho poslal, nebo ho zkusíte najít v adresáři.
openpgp-key-own = Přijatý (osobní klíč)
openpgp-key-secret-not-personal = Nelze použít
openpgp-key-verified = Přijatý (ověřen)
openpgp-key-unverified = Přijatý (neověřen)
openpgp-key-undecided = Nepřijatý (není rozhodnuto)
openpgp-key-rejected = Nepřijatý (odmítnut)
openpgp-key-expired = Platnost vypršela
openpgp-intro = Dostupné veřejné klíče pro { $key }
openpgp-pubkey-import-id = ID: { $kid }
openpgp-pubkey-import-fpr = Otisk: { $fpr }
openpgp-pubkey-import-intro =
    { $num ->
        [one] Soubor obsahuje veřejný klíč zobrazený níže:
        [few] Soubor obsahuje { $num } veřejné klíče zobrazené níže:
       *[other] Soubor obsahuje { $num } veřejných klíčů zobrazených níže:
    }
openpgp-pubkey-import-accept =
    { $num ->
        [one] Přijímáte tento klíč k účelům ověřování digitálních podpisů a šifrování zpráv pro všechny zobrazené e-mailové adresy?
        [few] Přijímáte tyto klíče k účelům ověřování digitálních podpisů a šifrování zpráv pro všechny zobrazené e-mailové adresy?
       *[other] Přijímáte tyto klíče k účelům ověřování digitálních podpisů a šifrování zpráv pro všechny zobrazené e-mailové adresy?
    }
pubkey-import-button =
    .buttonlabelaccept = Importovat
    .buttonaccesskeyaccept = I
