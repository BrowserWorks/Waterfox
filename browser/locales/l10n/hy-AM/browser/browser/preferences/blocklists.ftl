# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Արգելացուցակներ
    .style = width: 55em

blocklist-description = Ընտրեք { -brand-short-name } ցուցակը, որը օգտագործվում է առցանց վտանգներից խուսափելու համար: Ցուցակները տրված են <a data-l10n-name="disconnect-link" title="Disconnect"> Անջատել </a>:
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Ցուցակ

blocklist-button-cancel =
    .label = Չեղարկել
    .accesskey = Չ

blocklist-button-ok =
    .label = Պահել փոփոխությունները
    .accesskey = Պ

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = 1-ին մակարդակի արգելափակման ցուցակ (Խորհուրդ է տրվում)։
blocklist-item-moz-std-description = Թույլ է տալիս որոշ հետևումներ, որպեսզի ավելի քիչ կայքեր կոտրվեն:
blocklist-item-moz-full-listName = 2-րդ մակարդակի արգելափակման ցուցակ:
blocklist-item-moz-full-description = Արգելափակում է բոլոր հայտնաբերված վտանգները: Որոշ վեբ կայքեր կամ բովանդակություն կարող են չբեռնվել պատշաճ կերպով:
