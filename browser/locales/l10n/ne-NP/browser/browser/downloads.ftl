# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = डाउनलोडहरू
downloads-panel =
    .aria-label = डाउनलोडहरू

##

downloads-cmd-pause =
    .label = रोक्नुहोस्
    .accesskey = P
downloads-cmd-resume =
    .label = पुनः निरन्तरता दिनुहोस्
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = रद्द गर्नुहोस्
downloads-cmd-cancel-panel =
    .aria-label = रद्द गर्नुहोस्

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = समाविष्ट भएको फोल्डर खोल्नुहोस्
    .accesskey = F
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = फाइन्डरमा देखाउनुहोस्
    .accesskey = F

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] फाइन्डरमा देखाउनुहोस्
           *[other] समाविष्ट भएको फोल्डर खोल्नुहोस्
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] फाइन्डरमा देखाउनुहोस्
           *[other] समाविष्ट भएको फोल्डर खोल्नुहोस्
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] फाइन्डरमा देखाउनुहोस्
           *[other] समाविष्ट भएको फोल्डर खोल्नुहोस्
        }

downloads-cmd-show-downloads =
    .label = डाउनलोड फोल्डर देखाउनुहोस्
downloads-cmd-retry =
    .tooltiptext = पुनः प्रयास गर्नुहोस्
downloads-cmd-retry-panel =
    .aria-label = पुनः प्रयास गर्नुहोस्
downloads-cmd-go-to-download-page =
    .label = डाउनलोड पेजमा जानुहोस्
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = डाउनलोड लिङ्क प्रतिलिपि गर्नुहोस्
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = इतिहासबाट हटाउनुहोस्
    .accesskey = e
downloads-cmd-clear-list =
    .label = पूर्वावलोकन प्यानल खाली गर्नुहोस्
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = डाउनलोडहरू खाली गर्नुहोस्
    .accesskey = D

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = डाउनलोड गर्न दिनुहोस्
    .accesskey = o

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = फाइल हटाउनुहोस्

downloads-cmd-remove-file-panel =
    .aria-label = फाइल हटाउनुहोस्

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = फाइल हटाउनुहोस् वा डाउनलोड गर्न दिनुहोस्

downloads-cmd-choose-unblock-panel =
    .aria-label = फाइल हटाउनुहोस् वा डाउनलोड गर्न दिनुहोस्

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = फाइल खोल्नुहोस् अथवा हटाउनुहोस्

downloads-cmd-choose-open-panel =
    .aria-label = फाइल खोल्नुहोस् अथवा हटाउनुहोस्

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = थप जानकारी देखाउनुहोस्

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = फाइल खोल्नुहोस्

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = डाउनलोड गर्न पुनःप्रयास गर्नुहोस्

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = डाउनलोड रद्द गर्नुहोस्

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = सबै डाउनलोड देखाउनुहोस्
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = डाउनलेाडको विवरणहरू

downloads-clear-downloads-button =
    .label = डाउनलेाडहरू खाली गर्नुहोस्
    .tooltiptext = सबै सकिएका, रद्ध गरिएका र विफल भएका डाउनलोडहरू मेटाउनुहोस्

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = कुनै डाउनलोडहरू छैन।

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = यस सत्रमा केहि पनि डाउनलोड भएन।
