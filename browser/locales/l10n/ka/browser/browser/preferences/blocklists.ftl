# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = შეზღუდულთა სია
    .style = width: 50em

blocklist-description = აირჩიეთ სია, რომელსაც { -brand-short-name } გამოიყენებს ინტერნეტ-მეთვალყურეების შესაზღუდად. სიების მომწოდებელია <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = სია

blocklist-button-cancel =
    .label = გაუქმება
    .accesskey = გ

blocklist-button-ok =
    .label = ცვლილებების შენახვა
    .accesskey = შ

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = 1-ლი დონის შეზღუდვის სია (სასურველია).
blocklist-item-moz-std-description = ზოგიერთი მეთვალყურე დაშვებულია, საიტების გამართულად მუშაობისთვის.
blocklist-item-moz-full-listName = მე-2 დონის შეზღუდვის სია.
blocklist-item-moz-full-description = ყველა აღმოჩენილი მეთვალყურე შეიზღუდება. ვებსაიტების ან შიგთავსის ნაწილი, შესაძლოა სათანადოდ არ ჩაიტვირთოს.
