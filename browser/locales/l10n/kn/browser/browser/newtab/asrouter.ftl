# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These messages are used as headings in the recommendation doorhanger

##

cfr-doorhanger-extension-cancel-button = ಈಗ ಬೇಡ
    .accesskey = N

cfr-doorhanger-extension-ok-button = ಈಗ ಸೇರಿಸಿ
    .accesskey = A

cfr-doorhanger-extension-manage-settings-button = ಶಿಫಾರಸು ಮಾಡಲಾದ ಸಿದ್ದತೆಗಳನ್ನು ನಿರ್ವಹಿಸಿ
    .accesskey = M

cfr-doorhanger-extension-never-show-recommendation = ನನಗೆ ಈ ಶಿಫಾರಸ್ಸನ್ನು ತೋರಿಸಬೇಡ
    .accesskey = S

cfr-doorhanger-extension-learn-more-link = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = { $name } ಇಂದ

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = ಶಿಫಾರಸು

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } ನಕ್ಷತ್ರ
           *[other] { $total } ನಕ್ಷತ್ರಗಳು
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } ಬಳಕೆದಾರ
       *[other] { $total } ಬಳಕೆದಾರರು
    }

## These messages are steps on how to use the feature and are shown together.


## Firefox Accounts Message

## Protections panel

## What's New toolbar button and panel

## Search Bar

## Picture-in-Picture

## Permission Prompt

## Fingerprinter Counter

## Bookmark Sync

## Login Sync

## Send Tab

## Firefox Send

## Social Tracking Protection

## Enhanced Tracking Protection Milestones

## What’s New Panel Content for Firefox 76

## Lockwise message

## Vulnerable Passwords message

## Picture-in-Picture fullscreen message

## Protections Dashboard message

## Better PDF message

## DOH Message

## What's new: Cookies message

