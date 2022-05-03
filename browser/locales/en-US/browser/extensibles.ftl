# In browser/locales/jar.mn
# Localised versions MUST be located in browser/locales/l10n/{locale}/browser/browser/extensibles.ftl

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
