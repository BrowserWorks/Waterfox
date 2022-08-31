# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = Compact folders
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = Compact now
    .buttonaccesskeyaccept = C
    .buttonlabelcancel = Remind me later
    .buttonaccesskeycancel = R
    .buttonlabelextra1 = Learn more…
    .buttonaccesskeyextra1 = L

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } needs to do regular file maintenance to improve the performance of your mail folders. This will recover { $data } of disk space without changing your messages. To let { -brand-short-name } do this automatically in the future without asking, check the box below before choosing ‘{ compact-dialog.buttonlabelaccept }’.

compact-dialog-never-ask-checkbox =
    .label = Compact folders automatically in the future
    .accesskey = a

