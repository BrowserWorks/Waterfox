# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

dock-options-window-dialog =
    .title =
        { PLATFORM() ->
            [macos] Programmasymboolopties
           *[other] Taakbalkitemopties
        }
    .style = width: 35em;
dock-options-show-badge =
    .label = Taakbalkitemmarkering tonen
    .accesskey = T
bounce-system-dock-icon =
    .label = Het programmasymbool laten bewegen als een nieuw bericht binnenkomt
    .accesskey = b
dock-icon-legend =
    { PLATFORM() ->
        [macos] Programmasymboolmarkering
       *[other] Taakbalkitemmarkering
    }
dock-icon-show-label =
    .value =
        { PLATFORM() ->
            [macos] Programmasymbool markeren met:
           *[other] Taakbalkitem markeren met:
        }
count-unread-messages-radio =
    .label = Aantal ongelezen berichten
    .accesskey = o
count-new-messages-radio =
    .label = Aantal nieuwe berichten
    .accesskey = n
notification-settings-info = U kunt de badge uitschakelen via het paneel Berichtgeving in Systeemvoorkeuren.
