# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = Komprimera mappar
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = Komprimera nu
    .buttonaccesskeyaccept = n
    .buttonlabelcancel = Påminn mig senare
    .buttonaccesskeycancel = P
    .buttonlabelextra1 = Läs mer
    .buttonaccesskeyextra1 = L

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } måste utföra regelbundet filunderhåll för att förbättra prestandan för dina e-postmappar. Detta återställer { $data } diskutrymme utan att ändra dina meddelanden. För att låta { -brand-short-name } göra detta automatiskt i framtiden utan att fråga, kryssa i rutan nedan innan du väljer "{ compact-dialog.buttonlabelaccept }".

compact-dialog-never-ask-checkbox =
    .label = Komprimera mappar automatiskt i framtiden
    .accesskey = a

