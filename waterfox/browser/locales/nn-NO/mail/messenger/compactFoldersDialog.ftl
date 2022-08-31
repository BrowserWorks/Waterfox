# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = Komprimer mappene
    .style = width: 50em;
compact-dialog =
    .buttonlabelaccept = Komprimer no
    .buttonaccesskeyaccept = N
    .buttonlabelcancel = Minn meg på det seinare
    .buttonaccesskeycancel = M
    .buttonlabelextra1 = Les meir …
    .buttonaccesskeyextra1 = L
# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } må vedlikehalde filene regelmessig for å forbetre ytinga til meldingsmappene dine. Dette vil tilbakerstille { $data } diskplass utan å endre på meldingane dine. For å la { -brand-short-name } gjere dette automatisk i framtida utan å spørje, kryss av i boksen under før du vel «{ compact-dialog.buttonlabelaccept }».
compact-dialog-never-ask-checkbox =
    .label = Komprimer mappene automatisk i framtida
    .accesskey = a
