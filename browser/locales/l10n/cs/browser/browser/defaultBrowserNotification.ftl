# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The question portion of the following message should have the <strong> and </strong> tags surrounding it.
default-browser-notification-message =
    <strong>Nastavte si { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } jako výchozí prohlížeč</strong> a získáte rychlý, bezpečný a soukromý prohlížeč pro jakoukoliv webovou stránku.
default-browser-notification-button =
    .label = Nastavit jako výchozí
    .accesskey = v

## These strings are used for the default browser prompt. There are 2 variations
## depending on the operating system (Windows vs other). The checkbox label and
## secondary button are shared between the variants.

default-browser-prompt-title-pin =
    Chcete { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } nastavit jako svůj hlavní prohlížeč?
default-browser-prompt-message-pin =
    { -brand-short-name.gender ->
        [masculine] Mějte { -brand-short-name(case: "acc") } nastavený jako výchozí prohlížeč a připnutý na své liště.
        [feminine] Mějte { -brand-short-name(case: "acc") } nastavenou jako výchozí prohlížeč a připnutou na své liště.
        [neuter] Mějte { -brand-short-name(case: "acc") } nastavené jako výchozí prohlížeč a připnuté na své liště.
       *[other] Mějte aplikaci { -brand-short-name } nastavenou jako výchozí prohlížeč a připnutou na své liště.
    }
default-browser-prompt-message-pin-mac =
    { -brand-short-name.gender ->
        [masculine] Mějte { -brand-short-name(case: "acc") } nastavený jako výchozí prohlížeč a připnutý ve svém docku.
        [feminine] Mějte { -brand-short-name(case: "acc") } nastavenou jako výchozí prohlížeč a připnutou ve svém docku.
        [neuter] Mějte { -brand-short-name(case: "acc") } nastavené jako výchozí prohlížeč a připnuté ve svém docku.
       *[other] Mějte aplikaci { -brand-short-name } nastavenou jako výchozí prohlížeč a připnutou ve svém docku.
    }
default-browser-prompt-button-primary-pin = Nastavit jako hlavní prohlížeč
default-browser-prompt-title-alt =
    Chcete { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } nastavit jako svůj výchozí prohlížeč?
default-browser-prompt-message-alt = Získejte rychlost, bezpečnost a soukromí pro své prohlížení.
default-browser-prompt-button-primary-alt = Nastavit jako výchozí prohlížeč
default-browser-prompt-checkbox-not-again-label = Příště už nezobrazovat
default-browser-prompt-button-secondary = Teď ne
