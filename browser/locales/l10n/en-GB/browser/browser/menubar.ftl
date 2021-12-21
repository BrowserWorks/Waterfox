# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# NOTE: For English locales, strings in this file should be in APA-style Title Case.
# See https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case
#
# NOTE: For Engineers, please don't re-use these strings outside of the menubar.


## Application Menu (macOS only)

menu-application-preferences =
    .label = Preferences
menu-application-services =
    .label = Services
menu-application-hide-this =
    .label = Hide { -brand-shorter-name }
menu-application-hide-other =
    .label = Hide Others
menu-application-show-all =
    .label = Show All
menu-application-touch-bar =
    .label = Customise Touch Bar…

##

# These menu-quit strings are only used on Windows and Linux.
menu-quit =
    .label =
        { PLATFORM() ->
            [windows] Exit
           *[other] Quit
        }
    .accesskey =
        { PLATFORM() ->
            [windows] x
           *[other] Q
        }
# This menu-quit-mac string is only used on macOS.
menu-quit-mac =
    .label = Quit { -brand-shorter-name }
# This menu-quit-button string is only used on Linux.
menu-quit-button =
    .label = { menu-quit.label }
# This menu-quit-button-win string is only used on Windows.
menu-quit-button-win =
    .label = { menu-quit.label }
    .tooltip = Exit { -brand-shorter-name }
menu-about =
    .label = About { -brand-shorter-name }
    .accesskey = A

## File Menu

menu-file =
    .label = File
    .accesskey = F
menu-file-new-tab =
    .label = New Tab
    .accesskey = T
menu-file-new-container-tab =
    .label = New Container Tab
    .accesskey = b
menu-file-new-window =
    .label = New Window
    .accesskey = N
menu-file-new-private-window =
    .label = New Private Window
    .accesskey = W
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Open Location…
menu-file-open-file =
    .label = Open File…
    .accesskey = O
menu-file-close =
    .label = Close
    .accesskey = C
menu-file-close-window =
    .label = Close Window
    .accesskey = d
menu-file-save-page =
    .label = Save Page As…
    .accesskey = A
menu-file-email-link =
    .label = Email Link…
    .accesskey = E
menu-file-print-setup =
    .label = Page Setup…
    .accesskey = u
menu-file-print-preview =
    .label = Print Preview
    .accesskey = v
menu-file-print =
    .label = Print…
    .accesskey = P
menu-file-import-from-another-browser =
    .label = Import From Another Browser…
    .accesskey = I
menu-file-go-offline =
    .label = Work Offline
    .accesskey = k

## Edit Menu

menu-edit =
    .label = Edit
    .accesskey = E
menu-edit-find-on =
    .label = Find in This Page…
    .accesskey = F
menu-edit-find-in-page =
    .label = Find in Page…
    .accesskey = F
menu-edit-find-again =
    .label = Find Again
    .accesskey = g
menu-edit-bidi-switch-text-direction =
    .label = Switch Text Direction
    .accesskey = w

## View Menu

menu-view =
    .label = View
    .accesskey = V
menu-view-toolbars-menu =
    .label = Toolbars
    .accesskey = T
menu-view-customize-toolbar =
    .label = Customise…
    .accesskey = C
menu-view-customize-toolbar2 =
    .label = Customise Toolbar…
    .accesskey = C
menu-view-sidebar =
    .label = Sidebar
    .accesskey = e
menu-view-bookmarks =
    .label = Bookmarks
menu-view-history-button =
    .label = History
menu-view-synced-tabs-sidebar =
    .label = Synced Tabs
menu-view-full-zoom =
    .label = Zoom
    .accesskey = Z
menu-view-full-zoom-enlarge =
    .label = Zoom In
    .accesskey = I
menu-view-full-zoom-reduce =
    .label = Zoom Out
    .accesskey = O
menu-view-full-zoom-actual-size =
    .label = Actual Size
    .accesskey = A
menu-view-full-zoom-toggle =
    .label = Zoom Text Only
    .accesskey = T
menu-view-page-style-menu =
    .label = Page Style
    .accesskey = y
menu-view-page-style-no-style =
    .label = No Style
    .accesskey = N
menu-view-page-basic-style =
    .label = Basic Page Style
    .accesskey = B
menu-view-charset =
    .label = Text Encoding
    .accesskey = c
menu-view-repair-text-encoding =
    .label = Repair Text Encoding
    .accesskey = c

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Enter Full Screen
    .accesskey = F
menu-view-exit-full-screen =
    .label = Exit Full Screen
    .accesskey = F
menu-view-full-screen =
    .label = Full Screen
    .accesskey = F

##

menu-view-show-all-tabs =
    .label = Show All Tabs
    .accesskey = A
menu-view-bidi-switch-page-direction =
    .label = Switch Page Direction
    .accesskey = D

## History Menu

menu-history =
    .label = History
    .accesskey = s
menu-history-show-all-history =
    .label = Show All History
menu-history-clear-recent-history =
    .label = Clear Recent History…
menu-history-synced-tabs =
    .label = Synced Tabs
menu-history-restore-last-session =
    .label = Restore Previous Session
menu-history-hidden-tabs =
    .label = Hidden Tabs
menu-history-undo-menu =
    .label = Recently Closed Tabs
menu-history-undo-window-menu =
    .label = Recently Closed Windows
menu-history-reopen-all-tabs = Reopen All Tabs
menu-history-reopen-all-windows = Reopen All Windows

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Bookmarks
    .accesskey = B
menu-bookmarks-show-all =
    .label = Show All Bookmarks
menu-bookmark-this-page =
    .label = Bookmark This Page
menu-bookmarks-manage =
    .label = Manage Bookmarks
menu-bookmark-current-tab =
    .label = Bookmark Current Tab
menu-bookmark-edit =
    .label = Edit This Bookmark
menu-bookmarks-all-tabs =
    .label = Bookmark All Tabs…
menu-bookmarks-toolbar =
    .label = Bookmarks Toolbar
menu-bookmarks-other =
    .label = Other Bookmarks
menu-bookmarks-mobile =
    .label = Mobile Bookmarks

## Tools Menu

menu-tools =
    .label = Tools
    .accesskey = T
menu-tools-downloads =
    .label = Downloads
    .accesskey = D
menu-tools-addons =
    .label = Add-ons
    .accesskey = A
menu-tools-fxa-sign-in =
    .label = Sign In To { -brand-product-name }…
    .accesskey = g
menu-tools-turn-on-sync =
    .label = Turn on { -sync-brand-short-name }…
    .accesskey = n
menu-tools-addons-and-themes =
    .label = Add-ons and Themes
    .accesskey = A
menu-tools-fxa-sign-in2 =
    .label = Sign In
    .accesskey = g
menu-tools-turn-on-sync2 =
    .label = Turn on Sync…
    .accesskey = n
menu-tools-sync-now =
    .label = Synchronise Now
    .accesskey = o
menu-tools-fxa-re-auth =
    .label = Reconnect to { -brand-product-name }…
    .accesskey = R
menu-tools-web-developer =
    .label = Web Developer
    .accesskey = W
menu-tools-browser-tools =
    .label = Browser Tools
    .accesskey = B
menu-tools-task-manager =
    .label = Task Manager
    .accesskey = M
menu-tools-page-source =
    .label = Page Source
    .accesskey = o
menu-tools-page-info =
    .label = Page Info
    .accesskey = I
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Options
           *[other] Preferences
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] n
        }
menu-settings =
    .label = Settings
    .accesskey =
        { PLATFORM() ->
            [windows] S
           *[other] n
        }
menu-tools-layout-debugger =
    .label = Layout Debugger
    .accesskey = L

## Window Menu

menu-window-menu =
    .label = Window
menu-window-bring-all-to-front =
    .label = Bring All to Front

## Help Menu


# NOTE: For Engineers, any additions or changes to Help menu strings should
# also be reflected in the related strings in appmenu.ftl. Those strings, by
# convention, will have the same ID as these, but prefixed with "app".
# Example: appmenu-get-help
#
# These strings are duplicated to allow for different casing depending on
# where the strings appear.

menu-help =
    .label = Help
    .accesskey = H
menu-help-product =
    .label = { -brand-shorter-name } Help
    .accesskey = H
menu-help-show-tour =
    .label = { -brand-shorter-name } Tour
    .accesskey = o
menu-help-import-from-another-browser =
    .label = Import from Another Browser…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Keyboard Shortcuts
    .accesskey = K
menu-help-troubleshooting-info =
    .label = Troubleshooting Information
    .accesskey = T
menu-get-help =
    .label = Get Help
    .accesskey = H
menu-help-more-troubleshooting-info =
    .label = More Troubleshooting Information
    .accesskey = T
menu-help-report-site-issue =
    .label = Report Site Issue…
menu-help-feedback-page =
    .label = Submit Feedback…
    .accesskey = S
menu-help-safe-mode-without-addons =
    .label = Restart with Add-ons Disabled…
    .accesskey = R
menu-help-safe-mode-with-addons =
    .label = Restart with Add-ons Enabled
    .accesskey = R
menu-help-enter-troubleshoot-mode2 =
    .label = Troubleshoot Mode…
    .accesskey = M
menu-help-exit-troubleshoot-mode =
    .label = Turn Troubleshoot Mode Off
    .accesskey = M
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Report Deceptive Site…
    .accesskey = d
menu-help-not-deceptive =
    .label = This Isn’t a Deceptive Site…
    .accesskey = D
