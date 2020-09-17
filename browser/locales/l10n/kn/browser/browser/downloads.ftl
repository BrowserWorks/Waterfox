# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = ಇಳಿಕೆಗಳು
downloads-panel =
    .aria-label = ಇಳಿಕೆಗಳು

##

downloads-cmd-pause =
    .label = ವಿರಮಿಸು
    .accesskey = P
downloads-cmd-resume =
    .label = ಮರಳಿ ಆರಂಭಿಸು
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = ರದ್ದು ಮಾಡು
downloads-cmd-cancel-panel =
    .aria-label = ರದ್ದು ಮಾಡು

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = ಹೊಂದಿರುವ ಕಡತಕೋಶವನ್ನು ತೆರೆ
    .accesskey = F
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = ಹುಡುಕುಗಾರನಲ್ಲಿ ತೋರಿಸು
    .accesskey = F

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] ಹುಡುಕುಗಾರನಲ್ಲಿ ತೋರಿಸು
           *[other] ಹೊಂದಿರುವ ಕಡತಕೋಶವನ್ನು ತೆರೆ
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] ಹುಡುಕುಗಾರನಲ್ಲಿ ತೋರಿಸು
           *[other] ಹೊಂದಿರುವ ಕಡತಕೋಶವನ್ನು ತೆರೆ
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] ಹುಡುಕುಗಾರನಲ್ಲಿ ತೋರಿಸು
           *[other] ಹೊಂದಿರುವ ಕಡತಕೋಶವನ್ನು ತೆರೆ
        }

downloads-cmd-show-downloads =
    .label = ಡೌನ್‌ಲೋಡ್‌ ಕಡತಕೋಶವನ್ನು ತೋರಿಸು
downloads-cmd-retry =
    .tooltiptext = ಮರಳಿ ಪ್ರಯತ್ನಿಸು
downloads-cmd-retry-panel =
    .aria-label = ಮರಳಿ ಪ್ರಯತ್ನಿಸು
downloads-cmd-go-to-download-page =
    .label = ಇಳಿಕೆಯ ಪುಟಕ್ಕೆ ತೆರಳು
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = ಇಳಿಕೆಯ ಕೊಂಡಿಯನ್ನು ಪ್ರತಿ ಮಾಡು
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = ಇತಿಹಾಸದಿಂದ ತೆಗೆದುಹಾಕು
    .accesskey = e
downloads-cmd-clear-downloads =
    .label = ಇಳಿಕೆಗಳನ್ನು ಅಳಿಸು
    .accesskey = D

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = ಡೌನ್‌ಲೋಡ್ ಅನುಮತಿಸು
    .accesskey = o

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = ಕಡತ ತೆಗೆದುಹಾಕು

downloads-cmd-remove-file-panel =
    .aria-label = ಕಡತ ತೆಗೆದುಹಾಕು

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = ಕಡತ ತೆಗೆ ಅಥವಾ ಡೌನ್‌ಲೋಡ್ ಅನುಮತಿಸು

downloads-cmd-choose-unblock-panel =
    .aria-label = ಕಡತ ತೆಗೆ ಅಥವಾ ಡೌನ್‌ಲೋಡ್ ಅನುಮತಿಸು

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = ತೆರೆ ಅಥವಾ ಕಡತ ತೆಗೆ

downloads-cmd-choose-open-panel =
    .aria-label = ತೆರೆ ಅಥವಾ ಕಡತ ತೆಗೆ

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = ಹೆಚ್ಚಿನ ಮಾಹಿತಿಯನ್ನು ತೋರಿಸು

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = ಕಡತವನ್ನು ತೆರೆ

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = ಡೌನ್‌ಲೋಡ್ ಮರುಪ್ರಯತ್ನಿಸು

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = ಡೌನ್‌ಲೋಡ್‌ ರದ್ದುಗೊಳಿಸು

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = ಎಲ್ಲಾ ಇಳಿಕೆಗಳನ್ನು ತೋರಿಸು
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = ಡೌನ್‌ಲೋಡ್ ವಿವರಗಳು

downloads-clear-downloads-button =
    .label = ಇಳಿಕೆಗಳನ್ನು ಅಳಿಸು
    .tooltiptext = ಪೂರ್ಣಗೊಂಡ, ರದ್ದುಗೊಳಿಸಲಾದ ಹಾಗು ವಿಫಲಗೊಂಡ ಇಳಿಕೆಗಳನ್ನು ಅಳಿಸುತ್ತದೆ

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = ಯಾವುದೆ ಇಳಿಕೆಗಳಿಲ್ಲ.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = ಈ ಅಧಿವೇಶನಕ್ಕಾಗಿ ಯಾವುದೆ ಡೌನ್‌ಲೋಡ್‌ಗಳಿಲ್ಲ.
