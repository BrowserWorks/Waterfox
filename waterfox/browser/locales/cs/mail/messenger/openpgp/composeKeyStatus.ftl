# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-compose-key-status-intro-need-keys = Pro odeslání šifrované zprávy musíte nejdříve získat a přijmout veřejný klíč každého z příjemců.
openpgp-compose-key-status-keys-heading = Dostupnost klíčů OpenPGP:
openpgp-compose-key-status-title =
    .title = Zabezpečení zpráv pomocí OpenPGP
openpgp-compose-key-status-recipient =
    .label = Příjemce
openpgp-compose-key-status-status =
    .label = Stav
openpgp-compose-key-status-open-details = Spravovat klíče pro vybraného příjemce…
openpgp-recip-good = v pořádku
openpgp-recip-missing = žádný klíč není k dispozici
openpgp-recip-none-accepted = žádný přijatý klíč
openpgp-compose-general-info-alias = { -brand-short-name } obvykle vyžaduje, aby veřejný klíč příjemce obsahovat ID uživatele, které odpovídá jeho e-mailové adrese. To můžete obejít pomocí pravidel OpenPGP pro aliasy příjemců.
openpgp-compose-general-info-alias-learn-more = Zjistit více
openpgp-compose-alias-status-direct =
    { $count ->
        [one] namapováno na alias klíče
        [few] namapováno na { $count } aliasy klíčů
       *[other] namapováno na { $count } aliasů klíčů
    }
openpgp-compose-alias-status-error = nepoužitelný nebo nedostupný alias klíče
