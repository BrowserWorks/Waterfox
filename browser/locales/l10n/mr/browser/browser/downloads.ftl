# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = डाउनलोडस्
downloads-panel =
    .aria-label = डाउनलोडस्

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of 
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = थांबवा
    .accesskey = P
downloads-cmd-resume =
    .label = पुन्हा सुरू करा
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = रद्द करा
downloads-cmd-cancel-panel =
    .aria-label = रद्द करा

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = समाविष्टीत फोल्डर उघडा
    .accesskey = F
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = फाइंडरमध्ये दाखवा
    .accesskey = F

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] फाइंडरमध्ये दाखवा
           *[other] समाविष्टीत फोल्डर उघडा
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] फाइंडरमध्ये दाखवा
           *[other] समाविष्टीत फोल्डर उघडा
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] फाइंडरमध्ये दाखवा
           *[other] समाविष्टीत फोल्डर उघडा
        }

downloads-cmd-show-downloads =
    .label = डाउनलोड फोल्डर दर्शवा
downloads-cmd-retry =
    .tooltiptext = पुनःप्रयत्न करा
downloads-cmd-retry-panel =
    .aria-label = पुनःप्रयत्न करा
downloads-cmd-go-to-download-page =
    .label = डाउनलोड पृष्ठावर जा
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = डाउनलोड दुव्याचे प्रत बनवा
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = इतिहासातून काढून टाका
    .accesskey = e
downloads-cmd-clear-list =
    .label = पूर्वावलोकन फलक साफ करा
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = डाउनलोड्स नष्ट करा
    .accesskey = D

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = डाउनलोडची परवानगी द्या
    .accesskey = o

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = फाइल हटवा

downloads-cmd-remove-file-panel =
    .aria-label = फाइल हटवा

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = फाइल हटवा किंवा डाउनलोडची परवानगी द्या

downloads-cmd-choose-unblock-panel =
    .aria-label = फाइल हटवा किंवा डाउनलोडची परवानगी द्या

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = फाइल उघडा किंवा हटवा

downloads-cmd-choose-open-panel =
    .aria-label = फाइल उघडा किंवा हटवा

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = आणखी माहिती दाखवा

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = फाइल उघडा

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = पुन्हा डाउनलोड चा प्रयत्न करा

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = डाऊनलोड रद्द करा

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = सर्व डाउनलोड्स दाखवा
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = डाउनलोड तपशील

downloads-clear-downloads-button =
    .label = डाउनलोड्स नष्ट करा
    .tooltiptext = पूर्ण झालेले, रद्द केलेले व अपयशी डाउनलोड्स नष्ट करतो

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = डाउनलोड्स आढळले नाही.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = ह्या सत्राकरिता डाउनलोड नाही.
