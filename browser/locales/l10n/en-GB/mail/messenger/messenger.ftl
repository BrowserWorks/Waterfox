# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] 1 unread message
       *[other] { $count } unread messages
    }
about-rights-notification-text = { -brand-short-name } is free and open source software, built by a community of thousands from all over the world.

## Content tabs

content-tab-page-loading-icon =
    .alt = The page is loading
content-tab-security-high-icon =
    .alt = The connection is secure
content-tab-security-broken-icon =
    .alt = The connection is not secure

## Toolbar

addons-and-themes-button =
    .label = Add-ons and Themes
    .tooltip = Manage your add-ons
addons-and-themes-toolbarbutton =
    .label = Add-ons and Themes
    .tooltiptext = Manage your add-ons
quick-filter-toolbarbutton =
    .label = Quick Filter
    .tooltiptext = Filter messages
redirect-msg-button =
    .label = Redirect
    .tooltiptext = Redirect selected message

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Folder Pane Toolbar
    .accesskey = F
folder-pane-toolbar-options-button =
    .tooltiptext = Folder Pane Options
folder-pane-header-label = Folders

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Hide Toolbar
    .accesskey = H
show-all-folders-label =
    .label = All Folders
    .accesskey = A
show-unread-folders-label =
    .label = Unread Folders
    .accesskey = n
show-favorite-folders-label =
    .label = Favourite Folders
    .accesskey = F
show-smart-folders-label =
    .label = Unified Folders
    .accesskey = U
show-recent-folders-label =
    .label = Recent Folders
    .accesskey = R
folder-toolbar-toggle-folder-compact-view =
    .label = Compact View
    .accesskey = C

## Menu

redirect-msg-menuitem =
    .label = Redirect
    .accesskey = d

## AppMenu

# Since v89 we dropped the platforms distinction between Options or Preferences
# and consolidated everything with Preferences.
appmenu-preferences =
    .label = Preferences
appmenu-addons-and-themes =
    .label = Add-ons and Themes
appmenu-help-enter-troubleshoot-mode =
    .label = Troubleshoot Mode…
appmenu-help-exit-troubleshoot-mode =
    .label = Turn Troubleshoot Mode Off
appmenu-help-more-troubleshooting-info =
    .label = More Troubleshooting Information
appmenu-redirect-msg =
    .label = Redirect

## Context menu

context-menu-redirect-msg =
    .label = Redirect

## Message header pane

other-action-redirect-msg =
    .label = Redirect

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Manage Extension
    .accesskey = E
toolbar-context-menu-remove-extension =
    .label = Remove Extension
    .accesskey = v

## Message headers

message-header-address-in-address-book-icon =
    .alt = Address is in the Address Book
message-header-address-not-in-address-book-icon =
    .alt = Address is not in the Address Book

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Remove { $name }?
addon-removal-confirmation-button = Remove
addon-removal-confirmation-message = Remove { $name } as well as its configuration and data from { -brand-short-name }?
caret-browsing-prompt-title = Caret Browsing
caret-browsing-prompt-text = Pressing F7 turns Caret Browsing on or off. This feature places a moveable cursor within some content, allowing you to select text with the keyboard. Do you want to turn Caret Browsing on?
caret-browsing-prompt-check-text = Do not ask again.
repair-text-encoding-button =
    .label = Repair Text Encoding
    .tooltiptext = Guess correct text encoding from message content
