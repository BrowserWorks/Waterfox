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