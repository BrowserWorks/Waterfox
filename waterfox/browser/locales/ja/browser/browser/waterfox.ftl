# In browser/locales/jar.mn
# Localised versions MUST be located in browser/locales/l10n/{locale}/browser/browser/waterfox.ftl

## Restart Prompt
restart-prompt-title = Restart { -brand-short-name }
restart-prompt-question = Are you sure that you want to restart { -brand-short-name }?

## App Menu
appmenuitem-restart-browser =
    .label = Restart

## Tab Context Menu
copy-url =
    .label = Copy Tab Link
copy-all-urls =
    .label = Copy All Tab Links
unload-tab =
    .label = Unload Tab

## Private Tab
open-all-private =
    .label = Open All in Private Tabs
open-all-links-private =
    .label = Open All Links in Private Tabs
open-private-tab =
    .label = Open in a New Private Tab
new-private-tab =
    .label = New Private Tab
    .tooltiptext = Open a new private tab
open-link-private =
    .label = Open Link in New Private Tab
private-tab =
    .label =
        { $isPrivate ->
            [true] Exit Private Tab
            *[false] Make Private Tab
        }

## Status Bar
status-bar =
    .label = Status Bar

## about:preferences
### Main
tab-position-header = Tab Bar Position
tab-bar-top-above =
    .label = Top above address bar
tab-bar-top-below =
    .label = Top below address bar
tab-bar-bottom-above =
    .label = Bottom above status bar
tab-bar-bottom-below =
    .label = Bottom below status bar
tab-additional-header = Additional Tab Preferences
pinned-icon-only =
    .label = Shrink pinned tabs to display only the site icon
insert-after-current =
    .label = Insert new tab after current tab
insert-related-after-current =
    .label = Insert related new tab after current tab
dynamic-theme-header = Dynamic Themes
dynamic-theme-dark =
    .label = Force Dark Mode
dynamic-theme-light =
    .label = Force Light Mode
dynamic-theme-auto =
    .label = Dynamically Set Light/Dark Mode
restart-header = Restart Menu Item
restart-show-button =
    .label = Show restart button in PanelUI
restart-purge-cache =
    .label = Clear fast restart cache on browser restart
restart-require-confirmation =
    .label = Require restart confirmation
tab-feature-header = Tab Context Menu
show-duplicate-tab =
    .label = Show duplicate tab menu item
show-copy-url =
    .label = Show copy tab url menu item
enable-copy-active-tab =
    .label = Copy URL only from active tab
show-copy-all-urls =
    .label = Show copy all tab urls menu item
show-unload-tab =
    .label = Show unload tab menu item
statusbar-header = Status Bar
statusbar-enabled =
    .label = Show Status Bar
statusbar-show-links =
    .label = Show links
statusbar-contrast-text =
    .label = Contrast status bar text colour
bookmarks-bar-position-header = Bookmarks Toolbar Position
bookmarks-position-top =
    .label = Top
bookmarks-position-bottom =
    .label = Bottom
geolocation-api-header = Geolocation API
geolocation-description = Some websites require your location to function. If a website isn't functioning as a result of not being able to find your location, please enable this preference and try again.
geolocation-api-enabled =
    .label = Enable
geolocation-api-disabled =
    .label = Disable
### Privacy
send-referrer-header-0 =
    .label = Never send the referrer header
send-referrer-header-1 =
    .label = Send the referrer header only when clicking on links and similar elements
send-referrer-header-2 =
    .label = Send the referrer header on all requests (Default)
enable-webrtc-p2p =
    .label = Enable WebRTC peer connection
load-images =
    .label = Load images automatically
enable-javascript =
    .label = Enable JavaScript
webrtc-header = WebRTC peer connection
ref-header = HTTP Referrer Header
### Look & Feel
pane-theme-title = Look & Feel
category-theme =
    .tooltiptext = { pane-theme-title }
preset-title = Presets
waterfox-defaults =
    .label = Waterfox Defaults
rounded-corners =
    .label = Rounded Corners
    .label =
        { $isRounded ->
            [true] Toggle Square Corners
            *[false] Toggle Smooth Corners
        }
autohide-all =
    .label =
        { $isAutohide ->
            [true] Toggle Autohide Off
            *[false] Toggle Autohide On
        }
center-all =
    .label =
        { $isCentered ->
            [true] Toggle Centered Off
            *[false] Toggle Centered On
        }
reduce-padding =
    .label =
        { $isPadded ->
            [true] Toggle Compact Off
            *[false] Toggle Compact On
        }
enable-waterfox-theme-0 =
    .label = Enable Waterfox theme customisations on all themes
enable-waterfox-theme-1 =
    .label = Enable Waterfox theme customisations on Waterfox themes
enable-waterfox-theme-2 =
    .label = Disable Waterfox theme customisations
disable-panel-animate =
    .label = Disable app menu panel animation
disable-sidebar-animate =
    .label = Disable sidebar panel animation
auto-hide-tabs =
    .label = Auto Hide Tabs
auto-blur-tabs =
    .label = Auto Blur Tabs
auto-hide-tabbar =
    .label = Auto Hide Tab Bar
auto-hide-navbar =
    .label = Auto Hide Nav Bar
auto-hide-bookmarkbar =
    .label = Auto Hide Bookmarks Bar
auto-hide-sidebar =
    .label = Auto Hide Sidebar
auto-hide-back =
    .label = Auto Hide Back Button
auto-hide-forward =
    .label = Auto Hide Forward Button
auto-hide-pageaction =
    .label = Auto Hide Page Action
hide-all-icons =
    .label = Hide All Icons
hide-tab-icons =
    .label = Hide Tab Icons
hide-sidebar-header =
    .label = Hide Sidebar Header
hide-urlbar-iconbox =
    .label = Hide URL Bar Icon Box
hide-bookmarkbar-icon =
    .label = Hide Bookmarks Bar Icons
hide-bookmarkbar-label =
    .label = Hide Bookmarks Bar Labels
hide-disabled-menuitems =
    .label = Hide Disabled Menu Items
center-tab-content =
    .label = Center Tab Content
center-tab-label =
    .label = Center Tab Label Only
center-navbar-text =
    .label = Center Nav Bar Text
square-tab-edges =
    .label = Square Tab Corners
square-button-edges =
    .label = Square Button Corners
square-menu-panel =
    .label = Square App Menu Panel Corners
square-panel-item =
    .label = Square App Menu Item Corners
square-menu-popup =
    .label = Square Context Menu Panel Corners
square-menu-item =
    .label = Square Context Menu Item Corners
square-field =
    .label = Square Entry Field Corners
square-checkbox =
    .label = Square Checkbox
drag-space =
    .label = Enable Fixed Drag Space
compact-context-menu =
    .label = Reduce Context Menu Padding
compact-bookmark-menu =
    .label = Reduce Bookmarks Menu Padding
compact-panel-header =
    .label = Reduce Panel Header Padding
compact-navbar-popup =
    .label = Reduce Nav Bar Popup Padding
close-button-hover =
    .label = Display close tab button on hover of selected tab when many tabs are open
remove-panel-strip =
    .label = Remove Coloured App Menu Separator
full-panel-strip =
    .label = Full Width App Menu Separator
show-menu-icons =
    .label = Show Menu Icons
show-mac-menu-icons =
    .label = Show Mac Menu Icons
monospace-font =
    .label = Enable monospaced font for page
monospace-font-theme =
    .label = Enable monospaced font for theme
tab-context-line =
    .label = Tab Context Line

tab-bar-header = Tab Bar
nav-bar-header = Nav Bar
bookmark-header = Bookmarks Bar
font-header = Fonts
full-screen-header = Full screen
panels-header = Panels
sidebar-header = Sidebar
icons-header = Icons
media-player-header = Media Player

## about:telemetry
telemetry-page-subtitle = Waterfox does not collect telemetry about your installation - any telemetry modules are disabled when the browser is built. What you do in your browser is only known by you.
telemetry-privacy-policy = Privacy Policy

onboarding-grassroots-title = Supporting the grassroots
onboarding-grassroots-subtitle = Thank you for using Waterfox, an independent, grassroots browser. With your support, we’re building a sustainable alternative to the big players out there.