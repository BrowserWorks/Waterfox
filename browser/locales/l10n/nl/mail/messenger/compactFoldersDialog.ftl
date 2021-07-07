# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = Mappen comprimeren
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = Nu comprimeren
    .buttonaccesskeyaccept = c
    .buttonlabelcancel = Mij hier later aan herinneren
    .buttonaccesskeycancel = l
    .buttonlabelextra1 = Meer info…
    .buttonaccesskeyextra1 = M

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } moet regelmatig bestandsonderhoud uitvoeren om de prestaties van uw e-mailmappen te verbeteren. Dit zal { $data } schijfruimte vrijmaken zonder uw berichten te wijzigen. Vink om { -brand-short-name } dit in de toekomst automatisch te laten doen zonder te vragen het onderstaande vakje aan voordat u ‘{ compact-dialog.buttonlabelaccept }’ kiest.

compact-dialog-never-ask-checkbox =
    .label = Mappen in de toekomst automatisch comprimeren
    .accesskey = a

