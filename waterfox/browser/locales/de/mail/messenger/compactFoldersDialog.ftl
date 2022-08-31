# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = Ordner komprimieren
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = Jetzt komprimieren
    .buttonaccesskeyaccept = J
    .buttonlabelcancel = Später erinnern
    .buttonaccesskeycancel = S
    .buttonlabelextra1 = Weitere Informationen…
    .buttonaccesskeyextra1 = W

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } muss regelmäßig in den Nachrichtendateien aufräumen, um den Umgang mit diesen schnell zu halten. Es werden { $data } Speicherplatz freigegeben, ohne dass Nachrichten geändert werden. Um { -brand-short-name } dies in Zukunft automatisch ohne Nachfrage ausführen zu lassen, aktiveren Sie das untenstehende Kontrollkästchen, bevor Sie "{ compact-dialog.buttonlabelaccept }" verwenden.

compact-dialog-never-ask-checkbox =
    .label = Ordner in Zukunft automatisch komprimieren
    .accesskey = a

