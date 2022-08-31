# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = Porządkuj foldery
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = Uporządkuj
    .buttonaccesskeyaccept = U
    .buttonlabelcancel = Przypomnij później
    .buttonaccesskeycancel = P
    .buttonlabelextra1 = Więcej informacji…
    .buttonaccesskeyextra1 = W

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } musi regularnie konserwować pliki, aby zwiększyć wydajność folderów poczty. Spowoduje to odzyskanie { $data } miejsca na dysku bez żadnych zmian w wiadomościach. Aby { -brand-short-name } mógł w przyszłości robić to automatycznie i bez pytania, zaznacz poniższe pole przed kliknięciem „{ compact-dialog.buttonlabelaccept }”.

compact-dialog-never-ask-checkbox =
    .label = W przyszłości automatycznie porządkuj foldery
    .accesskey = a

