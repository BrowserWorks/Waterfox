# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Headers used in the webextension permissions dialog,
## See https://bug1308309.bmoattachments.org/attachment.cgi?id=8814612
## for an example of the full dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension.

webext-perms-header = 要安裝 { $extension } 嗎？
webext-perms-header-with-perms = 要安裝 { $extension } 嗎？此擴充套件將有下列權限:
webext-perms-header-unsigned = 要安裝 { $extension } 嗎？此擴充套件尚未經過驗證。惡意的擴充套件可偷走您的個人資訊，或讓您的電腦成為有害軟體散佈的溫床。請只在信任此套件的來源時才安裝。
webext-perms-header-unsigned-with-perms = 要安裝 { $extension } 嗎？此擴充套件尚未經過驗證。惡意的擴充套件可偷走您的個人資訊，或讓您的電腦成為有害軟體散佈的溫床。請只在信任此元件的來源時才安裝。此擴充套件將有下列權限:
webext-perms-sideload-header = 已安裝 { $extension }
webext-perms-optional-perms-header = { $extension } 要求更多權限。

##

webext-perms-add =
    .label = 安裝
    .accesskey = A
webext-perms-cancel =
    .label = 取消
    .accesskey = C

webext-perms-sideload-text = 您電腦上的其他軟體，安裝了可能會影響瀏覽器的附加元件。請確認此附加元件要求的權限，然後選擇啟用或保持停用。
webext-perms-sideload-text-no-perms = 您電腦上的其他軟體，安裝了可能會影響瀏覽器的附加元件。請選擇要啟用或保持停用。
webext-perms-sideload-enable =
    .label = 啟用
    .accesskey = E
webext-perms-sideload-cancel =
    .label = 取消
    .accesskey = C

# Variables:
#   $extension (String): replaced with the localized name of the extension.
webext-perms-update-text = { $extension } 已有更新。您必須允許新版套件所要求的權限，才會安裝。點擊「取消」可繼續使用目前版本的擴充套件。此擴充套件將有下列權限:
webext-perms-update-accept =
    .label = 更新
    .accesskey = U

webext-perms-optional-perms-list-intro = 它想要:
webext-perms-optional-perms-allow =
    .label = 允許
    .accesskey = A
webext-perms-optional-perms-deny =
    .label = 拒絕
    .accesskey = D

webext-perms-host-description-all-urls = 存取您所有網站中的資料

# Variables:
#   $domain (String): will be replaced by the DNS domain for which a webextension is requesting access (e.g., mozilla.org)
webext-perms-host-description-wildcard = 存取您在 { $domain } 網域中的資料

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-wildcards = 存取您在其他 { $domainCount } 個網域中的資料
# Variables:
#   $domain (String): will be replaced by the DNS host name for which a webextension is requesting access (e.g., www.mozilla.org)
webext-perms-host-description-one-site = 存取您在 { $domain } 的資料

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-sites = 存取您在其他 { $domainCount } 個網站中的資料

## Headers used in the webextension permissions dialog for synthetic add-ons.
## The part of the string describing what privileges the extension gives should be consistent
## with the value of webext-site-perms-description-gated-perms-{sitePermission}.
## Note, this string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $hostname (String): the hostname of the site the add-on is being installed from.

webext-site-perms-header-with-gated-perms-midi = 此附加元件會讓 { $hostname } 能夠存取 MIDI 裝置。
webext-site-perms-header-with-gated-perms-midi-sysex = 此附加元件會讓 { $hostname } 能夠存取 MIDI 裝置（並支援 SysEx）。

##

# This string is used as description in the webextension permissions dialog for synthetic add-ons.
# Note, the empty line is used to create a line break between the two sections.
# Note, this string will be used as raw markup. Avoid characters like <, >, &
webext-site-perms-description-gated-perms-midi =
    通常是連結音效合成器等外接裝置，但也可能是電腦中內建的裝置。
    
    一般來說不該允許網站存取 MIDI 裝置，使用不當的話可能會造成裝置損壞，或有安全性風險。

## Headers used in the webextension permissions dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension being installed.
##   $hostname (String): will be replaced by the DNS host name for which a webextension enables permissions.

webext-site-perms-header-with-perms = 要安裝 { $extension } 嗎？此擴充套件將把下列功能授予 { $hostname }:
webext-site-perms-header-unsigned-with-perms = 要安裝 { $extension } 嗎？此擴充套件尚未經過驗證。惡意的擴充套件可偷走您的個人資訊，或讓您的電腦成為有害軟體散佈的溫床。請只在信任此元件的來源時才安裝。此擴充套件將授予 { $hostname } 下列功能:

## These should remain in sync with permissions.NAME.label in sitePermissions.properties

webext-site-perms-midi = 存取 MIDI 裝置
webext-site-perms-midi-sysex = 存取 MIDI 裝置並支援 SysEx
