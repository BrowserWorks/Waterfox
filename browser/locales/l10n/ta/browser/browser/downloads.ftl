# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = பதிவிறக்கங்கள்
downloads-panel =
    .aria-label = பதிவிறக்கங்கள்

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of 
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = இடைநிறுத்து
    .accesskey = இ
downloads-cmd-resume =
    .label = தொடரவும்
    .accesskey = த
downloads-cmd-cancel =
    .tooltiptext = ரத்து
downloads-cmd-cancel-panel =
    .aria-label = ரத்து

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = கோப்பகத்திலிருந்து திற
    .accesskey = F
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = கண்டுபிடிப்பானில் காண்பி
    .accesskey = க

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] கண்டுபிடிப்பானில் காண்பி
           *[other] கோப்பகத்திலிருந்து திற
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] கண்டுபிடிப்பானில் காண்பி
           *[other] கோப்பகத்திலிருந்து திற
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] கண்டுபிடிப்பானில் காண்பி
           *[other] கோப்பகத்திலிருந்து திற
        }

downloads-cmd-show-downloads =
    .label = பதிவிறக்க கோப்புறையைக் காண்பி
downloads-cmd-retry =
    .tooltiptext = மறுமுயற்சி
downloads-cmd-retry-panel =
    .aria-label = மறுமுயற்சி
downloads-cmd-go-to-download-page =
    .label = பதிவிறக்க பக்கத்திற்கு செல்
    .accesskey = ப
downloads-cmd-copy-download-link =
    .label = பதிவிறக்க இணைப்பை நகலெடு
    .accesskey = ப
downloads-cmd-remove-from-history =
    .label = வரலாற்றிலிருந்து நீக்கு
    .accesskey = e
downloads-cmd-clear-list =
    .label = முன்பார்வை பலகத்தை துடை
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = பதிவிறக்கங்களை துடை
    .accesskey = D

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = பதிவிறக்கத்தை அனுமதி
    .accesskey = o

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = கோப்பை நீக்கு

downloads-cmd-remove-file-panel =
    .aria-label = கோப்பை நீக்கு

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = கோப்பை நீக்கு அல்லது பதிவிறக்கத்தை அனுமதி

downloads-cmd-choose-unblock-panel =
    .aria-label = கோப்பை நீக்கு அல்லது பதிவிறக்கத்தை அனுமதி

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = கோப்பை நீக்கு அல்லது திற

downloads-cmd-choose-open-panel =
    .aria-label = கோப்பை நீக்கு அல்லது திற

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = கூடுதல் தகவலைக் காட்டு

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = கோப்பைத் திற

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = பதிவிறக்கத்தை மீட்டெடு

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = பதிவிறக்கத்தை ரத்து செய்

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = அனைத்து பதிவிறக்கங்களையும் காண்பி
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = விவரங்களைப் பதிவிறக்கு

downloads-clear-downloads-button =
    .label = பதிவிறக்கங்களை அழி
    .tooltiptext = முடிந்துவிட்ட, ரத்து செய்த மற்றும் தோல்வியடைந்த பதிவிறக்கங்களை அழிக்கும்

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = பதிவிறக்கங்கள் எதுவும் இல்லை.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = இந்த அமர்விற்கான பதிவிறக்கங்கள் ஏதும் இல்லை.
