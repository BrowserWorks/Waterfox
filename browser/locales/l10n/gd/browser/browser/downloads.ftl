# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Luchdaidhean a-nuas
downloads-panel =
    .aria-label = Luchdaidhean a-nuas

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of 
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Cuir 'na stad
    .accesskey = s
downloads-cmd-resume =
    .label = Lean air
    .accesskey = r
downloads-cmd-cancel =
    .tooltiptext = Sguir dheth
downloads-cmd-cancel-panel =
    .aria-label = Sguir dheth

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Fosgail am pasgan far a bheil e
    .accesskey = F
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Seall san lorgair
    .accesskey = S

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Seall san lorgair
           *[other] Fosgail am pasgan far a bheil e
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Seall san lorgair
           *[other] Fosgail am pasgan far a bheil e
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Seall san lorgair
           *[other] Fosgail am pasgan far a bheil e
        }

downloads-cmd-show-downloads =
    .label = Seall pasgan nan luchdadh a-nuas
downloads-cmd-retry =
    .tooltiptext = Feuch ris a-rithist
downloads-cmd-retry-panel =
    .aria-label = Feuch ris a-rithist
downloads-cmd-go-to-download-page =
    .label = Rach gu duilleag nan luchdaidhean
    .accesskey = g
downloads-cmd-copy-download-link =
    .label = Dèan lethbhreac dhen cheangal luchdaidh
    .accesskey = l
downloads-cmd-remove-from-history =
    .label = Thoir air falbh on eachdraidh
    .accesskey = e
downloads-cmd-clear-list =
    .label = Falamhaich panail an ro-sheallaidh
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Falamhaich na chaidh a luchdadh a-nuas
    .accesskey = d

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Ceadaich an luchdadh a-nuas
    .accesskey = u

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Thoir air falbh am faidhle

downloads-cmd-remove-file-panel =
    .aria-label = Thoir air falbh am faidhle

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Thoir air falbh faidhle no ceadaich luchdadh a-nuas

downloads-cmd-choose-unblock-panel =
    .aria-label = Thoir air falbh faidhle no ceadaich luchdadh a-nuas

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Fosgail no thoir air falbh faidhle

downloads-cmd-choose-open-panel =
    .aria-label = Fosgail no thoir air falbh faidhle

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Seall barrachd fiosrachaidh

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Fosgail am faidhle

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Feuch ris an luchdadh a-nuas às ùr

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Sguir dhen luchdadh a-nuas

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Seall gach rud a chaidh a luchdadh a-nuas
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Fiosrachadh mun luchdadh a-nuas

downloads-clear-downloads-button =
    .label = Falamhaich na chaidh a luchdadh a-nuas
    .tooltiptext = Falamhaichidh seo na chaidh a luchdadh a-nuas, a' gabhail a-steach feadhainn a sguireadh dhiubh no a dh'fhàillig

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Cha deach dad a luchdadh a-nuas.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Cha deach dad a luchdadh a-nuas san t-seisean seo.
