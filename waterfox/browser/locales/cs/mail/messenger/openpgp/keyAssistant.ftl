# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Encryption status

openpgp-key-assistant-recipients-issue-header = Nelze šifrovat
openpgp-key-assistant-info-alias = { -brand-short-name } obvykle vyžaduje, aby veřejný klíč příjemce obsahovat ID uživatele, které odpovídá jeho e-mailové adrese. To můžete obejít pomocí pravidel OpenPGP pro aliasy příjemců. <a data-l10n-name="openpgp-link">Zjistit více…</a>

## Resolve section

openpgp-key-assistant-valid-description = Vyberte klíč, který chcete přijmout
openpgp-key-assistant-no-key-available = Žádný klíč není k dispozici.
openpgp-key-assistant-multiple-keys = K dispozici je více klíčů.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = Platnost přijatého klíče vypršela { $date }.
openpgp-key-assistant-keys-accepted-expired = Platnost několika přijatých klíčů vypršela.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = Tento klíč byl dříve přijat, ale jeho platnost vypršela { $date }.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one = Platnost klíče vypršela { $date }.
openpgp-key-assistant-key-unaccepted-expired-many = Platnost několika klíčů vypršela.
openpgp-key-assistant-key-fingerprint = Otisk
openpgp-key-assistant-key-source =
    { $count ->
        [one] Zdroj
        [few] Zdroje
       *[other] Zdroje
    }
openpgp-key-assistant-key-collected-attachment = příloha
openpgp-key-assistant-key-collected-keyserver = server klíčů
# Web Key Directory (WKD) is a concept.
openpgp-key-assistant-key-collected-wkd = Webový adresář klíčů
openpgp-key-assistant-key-rejected = Tento klíč byl dříve odmítnut.
openpgp-key-assistant-key-accepted-other = Tento klíč byl dříve přijat pro jinou e-mailovou adresu.
# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info = Vyhledejte další nebo aktualizované klíče pro { $recipient } online nebo je importujte ze souboru.

## Discovery section

openpgp-key-assistant-discover-title = Probíhá online vyhledávání.
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = Vyhledávání klíčů pro { $recipient }…

## Dialog buttons

openpgp-key-assistant-discover-online-button = Vyhledat veřejné klíče online…
openpgp-key-assistant-import-keys-button = Importovat veřejné klíče ze souboru…
openpgp-key-assistant-issue-resolve-button = Vyřešit…
openpgp-key-assistant-view-key-button = Zobrazit klíč…
openpgp-key-assistant-recipients-show-button = Zobrazit
openpgp-key-assistant-recipients-hide-button = Skrýt
openpgp-key-assistant-cancel-button = Zrušit
openpgp-key-assistant-back-button = Zpět
openpgp-key-assistant-accept-button = Přijmout
openpgp-key-assistant-close-button = Zavřít
openpgp-key-assistant-disable-button = Nešifrovat
openpgp-key-assistant-confirm-button = Odeslat šifrované
# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = vytvořeno { $date }
