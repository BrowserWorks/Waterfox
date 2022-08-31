# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = Compatta cartelle
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = Compatta ora
    .buttonaccesskeyaccept = C
    .buttonlabelcancel = Ricordamelo più tardi
    .buttonaccesskeycancel = R
    .buttonlabelextra1 = Ulteriori informazioni…
    .buttonaccesskeyextra1 = o

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } deve eseguire una manutenzione regolare dei file per migliorare le prestazioni delle cartelle di posta: questo permetterà di recuperare { $data } di spazio su disco senza modificare i messaggi. Per consentire a { -brand-short-name } di eseguire questa operazione in modo automatico, seleziona la casella sottostante scegliendo “{ compact-dialog.buttonlabelaccept }”.

compact-dialog-never-ask-checkbox =
    .label = Compatta cartelle automaticamente
    .accesskey = a

