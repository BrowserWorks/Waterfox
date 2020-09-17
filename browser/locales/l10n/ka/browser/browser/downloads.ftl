# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = ჩამოტვირთვები
downloads-panel =
    .aria-label = ჩამოტვირთვები

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = შეჩერება
    .accesskey = შ
downloads-cmd-resume =
    .label = განაგრძეთ
    .accesskey = რ
downloads-cmd-cancel =
    .tooltiptext = გაუქმება
downloads-cmd-cancel-panel =
    .aria-label = გაუქმება

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = შემცველი საქაღალდის გახსნა
    .accesskey = ს

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Finder-ში ჩვენება
    .accesskey = ჩ

downloads-cmd-use-system-default =
    .label = გახსნა სისტემური მნახველით
    .accesskey = ვ

downloads-cmd-always-use-system-default =
    .label = ყოველთვის გაიხსნას სისტემური მნახველით
    .accesskey = ლ

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Finder-ში ჩვენება
           *[other] შემცველი საქაღალდის გახსნა
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Finder-ში ჩვენება
           *[other] შემცველი საქაღალდის გახსნა
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Finder-ში ჩვენება
           *[other] შემცველი საქაღალდის გახსნა
        }

downloads-cmd-show-downloads =
    .label = ჩამოტვირთვების საქაღალდის ნახვა
downloads-cmd-retry =
    .tooltiptext = ახლიდან
downloads-cmd-retry-panel =
    .aria-label = ახლიდან
downloads-cmd-go-to-download-page =
    .label = ჩამოტვირთვის გვერდზე გადასვლა
    .accesskey = ჩ
downloads-cmd-copy-download-link =
    .label = ჩამოტვირთვის ბმულის ასლი
    .accesskey = ბ
downloads-cmd-remove-from-history =
    .label = ისტორიიდან წაშლა
    .accesskey = წ
downloads-cmd-clear-list =
    .label = დასრულებული ჩამოტვირთვების მოცილება
    .accesskey = დ
downloads-cmd-clear-downloads =
    .label = ჩამოტვირთვების გასუფთავება
    .accesskey = ჩ

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = ჩამოტვირთვის დაშვება
    .accesskey = დ

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = ფაილის მოცილება

downloads-cmd-remove-file-panel =
    .aria-label = ფაილის მოცილება

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = ფაილის მოცილება ან ჩამოტვირთვის დაშვება

downloads-cmd-choose-unblock-panel =
    .aria-label = ფაილის მოცილება ან ჩამოტვირთვის დაშვება

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = ფაილის გახსნა ან მოცილება

downloads-cmd-choose-open-panel =
    .aria-label = ფაილის გახსნა ან მოცილება

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = დამატებითი ინფორმაციის ჩვენება

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = ფაილის გახსნა

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = ხელახლა ჩამოტვირთვა

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = ჩამოტვირთვის გაუქმება

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = ყველა ჩამოტვირთვის ჩვენება
    .accesskey = ყ

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = ჩამოტვირთვის აღწერილობა

downloads-clear-downloads-button =
    .label = ჩამოტვირთვების გასუფთავება
    .tooltiptext = ასუფთავებს დასრულებულ, გაუქმებულ და ჩაშლილ ჩამოტვირთვებს

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = ჩამოტვირთვები არაა.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = ჩამოტვირთვები არ ყოფილა.
