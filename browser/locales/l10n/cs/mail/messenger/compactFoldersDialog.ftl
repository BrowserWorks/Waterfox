# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = Údržba složek
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = Provést údržbu
    .buttonaccesskeyaccept = P
    .buttonlabelcancel = Připomenout později
    .buttonaccesskeycancel = o
    .buttonlabelextra1 = Zjistit více…
    .buttonaccesskeyextra1 = Z

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message =
    { -brand-short-name } musí provést pravidelnou údržbu souborů, aby se zvýšila výkonnost poštovních složek. Tím získáte zpět { $data } místa na disku, aniž by došlo ke změnám ve vašich zprávách. Pokud chcete, aby to { -brand-short-name.gender ->
        [masculine] { -brand-short-name } v budoucnu dělal
        [feminine] { -brand-short-name } v budoucnu dělala
        [neuter] { -brand-short-name } v budoucnu dělalo
       *[other] aplikace { -brand-short-name } v budoucnu dělala
    } automaticky bez dotazování, před klepnutím na tlačítko ‘{ compact-dialog.buttonlabelaccept }’ zaškrtněte příslušné políčko níže.

compact-dialog-never-ask-checkbox =
    .label = V budoucnu provádět údržbu složek automaticky
    .accesskey = a

