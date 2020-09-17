# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = სისტემური ინტეგრაცია

system-integration-dialog =
    .buttonlabelaccept = მითითება ნაგულისხმებად
    .buttonlabelcancel = ინტეგრაციის გამოტოვება
    .buttonlabelcancel2 = გაუქმება

default-client-intro = { -brand-short-name } პროგრამის ნაგულისხმებ კლიენტად გამოყენება:

unset-default-tooltip = შეუძლებელია ნაგულისხმების სტატუსის გაუქმება { -brand-short-name } პროგრამიდანვე როცა თავად { -brand-short-name } პროგრამა გახსნილია. ნაგულისხმებად სხვა პროგრამის მისათითებლად თავად იმ პროგრამით უნდა სცადოთ.

checkbox-email-label =
    .label = ელფოსტა
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = სიახლეთა ჯგუფები
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = არხები
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows ძიება
       *[other] { "" }
    }

system-search-integration-label =
    .label = { system-search-engine-name } სისტემისთვის წერილებში ძიების ნებართვა
    .accesskey = S

check-on-startup-label =
    .label = ყოველთვის შემოწმება { -brand-short-name } პროგრამის გახსნისას
    .accesskey = A
