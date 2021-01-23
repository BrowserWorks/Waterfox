# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = ਡਾਊਨਲੋਡ
downloads-panel =
    .aria-label = ਡਾਊਨਲੋਡ

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = ਵਿਰਾਮ
    .accesskey = P
downloads-cmd-resume =
    .label = ਮੁੜ-ਪ੍ਰਾਪਤ
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = ਰੱਦ ਕਰੋ
downloads-cmd-cancel-panel =
    .aria-label = ਰੱਦ ਕਰੋ

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = ਰੱਖਣ ਵਾਲੇ ਫੋਲਡਰ ਨੂੰ ਖੋਲ੍ਹੋ
    .accesskey = F

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Finder ਵਿੱਚ ਵੇਖੋ
    .accesskey = F

downloads-cmd-use-system-default =
    .label = ਸਿਸਟਮ ਦਰਸ਼ਕ ਵਿੱਚ ਖੋਲ੍ਹੋ
    .accesskey = V

downloads-cmd-always-use-system-default =
    .label = ਹਮੇਸ਼ਾ ਸਿਸਟਮ ਦਰਸ਼ਕ ਵਿੱਚ ਖੋਲ੍ਹੋ
    .accesskey = w

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Finder ਵਿੱਚ ਵੇਖੋ
           *[other] ਰੱਖਣ ਵਾਲੇ ਫੋਲਡਰ ਨੂੰ ਖੋਲ੍ਹੋ
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Finder ਵਿੱਚ ਵੇਖੋ
           *[other] ਰੱਖਣ ਵਾਲੇ ਫੋਲਡਰ ਨੂੰ ਖੋਲ੍ਹੋ
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Finder ਵਿੱਚ ਵੇਖੋ
           *[other] ਰੱਖਣ ਵਾਲੇ ਫੋਲਡਰ ਨੂੰ ਖੋਲ੍ਹੋ
        }

downloads-cmd-show-downloads =
    .label = ਡਾਊਨਲੋਡ ਫੋਲਡਰ ਵੇਖਾਓ
downloads-cmd-retry =
    .tooltiptext = ਮੁੜ-ਕੋਸ਼ਿਸ਼
downloads-cmd-retry-panel =
    .aria-label = ਮੁੜ-ਕੋਸ਼ਿਸ਼
downloads-cmd-go-to-download-page =
    .label = ਡਾਊਨਲੋਡ ਸਫ਼ੇ 'ਤੇ ਜਾਓ
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = ਡਾਊਨਲੋਡ ਲਿੰਕ ਨੂੰ ਕਾਪੀ ਕਰੋ
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = ਅਤੀਤ ਵਿੱਚੋਂ ਹਟਾਓ
    .accesskey = e
downloads-cmd-clear-list =
    .label = ਝਲਕ ਪੈਨਲ ਨੂੰ ਸਾਫ਼ ਕਰੋ
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = ਡਾਊਨਲੋਡ ਨੂੰ ਸਾਫ਼ ਕਰੋ
    .accesskey = D

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = ਡਾਊਨਲੋਡ ਦੀ ਇਜਾਜ਼ਤ ਦਿਓ
    .accesskey = o

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = ਫਾਈਲ ਨੂੰ ਹਟਾਓ

downloads-cmd-remove-file-panel =
    .aria-label = ਫਾਈਲ ਨੂੰ ਹਟਾਓ

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = ਫਾਈਲ ਨੂੰ ਹਟਾਓ ਜਾਂ ਡਾਊਨਲੋਡ ਨੂੰ ਇਜਾਜ਼ਤ ਦਿਓ

downloads-cmd-choose-unblock-panel =
    .aria-label = ਫਾਈਲ ਨੂੰ ਹਟਾਓ ਜਾਂ ਡਾਊਨਲੋਡ ਨੂੰ ਇਜਾਜ਼ਤ ਦਿਓ

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = ਫਾਈਲ ਨੂੰ ਖੋਲ੍ਹੋ ਜਾਂ ਹਟਾਓ

downloads-cmd-choose-open-panel =
    .aria-label = ਫਾਈਲ ਨੂੰ ਖੋਲ੍ਹੋ ਜਾਂ ਹਟਾਓ

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = ਹੋਰ ਜਾਣਕਾਰੀ ਵੇਖਾਓ

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = ਫਾਈਲ ਨੂੰ ਖੋਲ੍ਹੋ

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = ਡਾਊਨਲੋਡ ਕਰਨ ਦੀ ਮੁੜ-ਕੋਸ਼ਿਸ਼ ਕਰੋ

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = ਡਾਊਨਲੋਡ ਨੂੰ ਰੱਦ ਕਰੋ

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = ਸਭ ਡਾਊਨਲੋਡ ਨੂੰ ਵੇਖੋ
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = ਡਾਊਨਲੋਡ ਦੇ ਵੇਰਵੇ

downloads-clear-downloads-button =
    .label = ਡਾਊਨਲੋਡ ਨੂੰ ਸਾਫ਼ ਕਰੋ
    .tooltiptext = ਪੂਰੇ ਹੋਏ, ਰੱਦ ਕੀਤੇ ਅਤੇ ਫੇਲ੍ਹ ਹੋਏ ਡਾਊਨਲੋਡ ਸਾਫ਼ ਕਰੋ

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = ਕੋਈ ਡਾਊਨਲੋਡ ਨਹੀਂ ਹੈ।

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = ਇਸ ਸ਼ੈਸ਼ਨ ਲਈ ਕੋਈ ਡਾਊਨਲੋਡ ਨਹੀ ਹੈ।
