# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = 附加组件管理器
addons-page-title = 附加组件管理器
search-header =
    .placeholder = 在 addons.mozilla.org 搜索
    .searchbuttonlabel = 搜索
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = 到 <a data-l10n-name="get-extensions">{ $domain }</a> 获取扩展和主题。
list-empty-installed =
    .value = 您没有安装任何此类型的附加组件
list-empty-available-updates =
    .value = 没有找到可用的更新
list-empty-recent-updates =
    .value = 您最近没有更新任何附加组件
list-empty-find-updates =
    .label = 检查更新
list-empty-button =
    .label = 进一步了解附加组件
help-button = 附加组件帮助
sidebar-help-button-title =
    .title = 附加组件帮助
preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } 选项
       *[other] { -brand-short-name } 首选项
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } 选项
           *[other] { -brand-short-name } 首选项
        }
addons-settings-button = { -brand-short-name } 设置
sidebar-settings-button-title =
    .title = { -brand-short-name } 设置
show-unsigned-extensions-button =
    .label = 一些扩展未通过验证
show-all-extensions-button =
    .label = 显示所有扩展
cmd-show-details =
    .label = 显示详细信息
    .accesskey = S
cmd-find-updates =
    .label = 查找更新
    .accesskey = F
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] 选项
           *[other] 首选项
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
cmd-enable-theme =
    .label = 使用主题
    .accesskey = W
cmd-disable-theme =
    .label = 停用主题
    .accesskey = W
cmd-install-addon =
    .label = 安装
    .accesskey = I
cmd-contribute =
    .label = 捐助
    .accesskey = C
    .tooltiptext = 捐助此附加组件的开发
detail-version =
    .label = 版本
detail-last-updated =
    .label = 上次更新
detail-contributions-description = 此附加组件的开发者希望通过您的小额捐款，帮助支持其持续开发。
detail-contributions-button = 捐助
    .title = 捐助此附加组件的开发
    .accesskey = C
detail-update-type =
    .value = 自动更新
detail-update-default =
    .label = 默认
    .tooltiptext = 仅对有默认设置者自动安装更新
detail-update-automatic =
    .label = 开
    .tooltiptext = 自动安装更新
detail-update-manual =
    .label = 关
    .tooltiptext = 不要自动安装更新
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = 在隐私窗口中运行
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = 不支持隐私窗口
detail-private-disallowed-description2 = 隐私浏览时不会运行此扩展。<a data-l10n-name="learn-more">详细了解</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = 会自动于隐私浏览窗口中运作
detail-private-required-description2 = 此扩展可以获知您在隐私浏览窗口中的上网情况。<a data-l10n-name="learn-more">详细了解</a>
detail-private-browsing-on =
    .label = 允许
    .tooltiptext = 在隐私浏览模式中启用
detail-private-browsing-off =
    .label = 不允许
    .tooltiptext = 在隐私浏览模式中禁用
detail-home =
    .label = 主页
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = 附加组件配置文件
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = 检查更新
    .accesskey = f
    .tooltiptext = 检查此附加组件的更新
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] 选项
           *[other] 首选项
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] 更改此附加组件的选项
           *[other] 更改此附加组件的首选项
        }
detail-rating =
    .value = 评分
addon-restart-now =
    .label = 立即重启浏览器
disabled-unsigned-heading =
    .value = 一些附加组件已被禁用
disabled-unsigned-description = 下列附加组件未通过针对是否适用于 { -brand-short-name } 的验证。您可以<label data-l10n-name="find-addons">找找有无替代品</label>或者请开发者申请验证。
disabled-unsigned-learn-more = 了解我们为保障您的网上安全做了哪些努力。
disabled-unsigned-devinfo = 想要自己的附加组件获得验证的开发者可继续阅读我们的<label data-l10n-name="learn-more">相关手册</label>。
plugin-deprecation-description = 少了些东西？{ -brand-short-name } 不再支持某些插件了。 <label data-l10n-name="learn-more">详细了解。</label>
legacy-warning-show-legacy = 显示旧式扩展
legacy-extensions =
    .value = 旧式扩展
legacy-extensions-description = 这些扩展不符合现今的 { -brand-short-name } 标准，因此已被停用。 <label data-l10n-name="legacy-learn-more">了解附加组件的变化</label>
private-browsing-description2 =
    扩展在 { -brand-short-name } 隐私浏览模式中的运行权限有所调整。默认情况下，任何新添加至 { -brand-short-name } 的扩展均不会在隐私窗口中运行。除非您在设置中明确允许，否则扩展将在隐私浏览模式中停止运行，也无法获知您的在线活动。这项调整旨在确保您的隐私浏览足够私密。
    <label data-l10n-name="private-browsing-learn-more">了解如何管理扩展设置。</label>
addon-category-discover = 推荐
addon-category-discover-title =
    .title = 推荐
addon-category-extension = 扩展
addon-category-extension-title =
    .title = 扩展
addon-category-theme = 主题
addon-category-theme-title =
    .title = 主题
addon-category-plugin = 插件
addon-category-plugin-title =
    .title = 插件
addon-category-dictionary = 字典
addon-category-dictionary-title =
    .title = 字典
addon-category-locale = 语言
addon-category-locale-title =
    .title = 语言
addon-category-available-updates = 可用更新
addon-category-available-updates-title =
    .title = 可用更新
addon-category-recent-updates = 最近更新
addon-category-recent-updates-title =
    .title = 最近更新

## These are global warnings

extensions-warning-safe-mode = 所有附加组件都已被安全模式暂时禁用。
extensions-warning-check-compatibility = 附加组件兼容性检查已禁用。您可能有不兼容的附加组件。
extensions-warning-check-compatibility-button = 启用
    .title = 启用附加组件兼容性检查
extensions-warning-update-security = 附加组件更新安全检查已被禁用。您可能会受到更新带来的安全威胁。
extensions-warning-update-security-button = 启用
    .title = 启用附加组件安全更新检查

## Strings connected to add-on updates

addon-updates-check-for-updates = 检查更新
    .accesskey = C
addon-updates-view-updates = 查看最近更新
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = 自动更新附加组件
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = 重设所有附加组件为自动更新
    .accesskey = R
addon-updates-reset-updates-to-manual = 重设所有附加组件为手动更新
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = 正在更新附加组件
addon-updates-installed = 您的附加组件更新完毕。
addon-updates-none-found = 没有找到可用的更新
addon-updates-manual-updates-found = 查看可用更新

## Add-on install/debug strings for page options menu

addon-install-from-file = 从文件安装附加组件…
    .accesskey = I
addon-install-from-file-dialog-title = 选择附加组件来安装
addon-install-from-file-filter-name = 附加组件
addon-open-about-debugging = 调试附加组件
    .accesskey = B

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = 管理扩展快捷键
    .accesskey = S
shortcuts-no-addons = 您没有启用任何扩展。
shortcuts-no-commands = 下列扩展没有快捷键：
shortcuts-input =
    .placeholder = 输入一个快捷键
shortcuts-browserAction2 = 激活工具栏按钮
shortcuts-pageAction = 激活页面动作
shortcuts-sidebarAction = 切换侧栏
shortcuts-modifier-mac = 包含 Ctrl、Alt 或 ⌘
shortcuts-modifier-other = 包含 Ctrl 或 Alt
shortcuts-invalid = 组合无效
shortcuts-letter = 输入一个字母
shortcuts-system = 不可覆盖 { -brand-short-name } 的快捷键
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = 快捷键重复
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = 有超过一个附加组件使用 { $shortcut } 作为快捷键，重复的快捷键可能会导致无法预料的行为。
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = 已被 { $addon } 占用
shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] 显示另外 { $numberToShow } 个
    }
shortcuts-card-collapse-button = 显示更少
header-back-button =
    .title = 返回

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = 扩展和主题就像手机上的应用，可帮助您保管密码、下载视频、查找优惠信息、拦截恼人广告、改变浏览器外观等等。这些小型程序大多由第三方开发。以下是一些 { -brand-product-name } <a data-l10n-name="learn-more-trigger">推荐</a>的附加组件，它们在安全性、性能和功能等方面表现优秀。
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = 以下的部分推荐是基于您的已安装附加组件、选项设置和使用统计得出的个性化结果。
discopane-notice-learn-more = 详细了解
privacy-policy = 隐私政策
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = 作者：<a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = 用户量：{ $dailyUsers }
install-extension-button = 添加至 { -brand-product-name }
install-theme-button = 安装主题
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = 管理
find-more-addons = 寻找更多附加组件
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = 更多选项

## Add-on actions

report-addon-button = 举报
remove-addon-button = 移除
# The link will always be shown after the other text.
remove-addon-disabled-button = 无法移除 <a data-l10n-name="link">为什么？</a>
disable-addon-button = 禁用
enable-addon-button = 启用
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = 启用
preferences-addon-button =
    { PLATFORM() ->
        [windows] 选项
       *[other] 首选项
    }
details-addon-button = 详细信息
release-notes-addon-button = 发行说明
permissions-addon-button = 权限
extension-enabled-heading = 已启用
extension-disabled-heading = 已禁用
theme-enabled-heading = 已启用
theme-disabled-heading = 已禁用
plugin-enabled-heading = 已启用
plugin-disabled-heading = 已禁用
dictionary-enabled-heading = 已启用
dictionary-disabled-heading = 已禁用
locale-enabled-heading = 已启用
locale-disabled-heading = 已禁用
ask-to-activate-button = 需要时询问
always-activate-button = 一律激活
never-activate-button = 永不激活
addon-detail-author-label = 作者
addon-detail-version-label = 版本
addon-detail-last-updated-label = 上次更新
addon-detail-homepage-label = 主页
addon-detail-rating-label = 评分
# Message for add-ons with a staged pending update.
install-postponed-message = 该扩展将在 { -brand-short-name } 重启后完成更新。
install-postponed-button = 立即更新
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = 评分：{ NUMBER($rating, maximumFractionDigits: 1) } / 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name }（已禁用）
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
       *[other] { $numberOfReviews } 条评价
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> 已被移除。
pending-uninstall-undo-button = 撤销
addon-detail-updates-label = 允许自动更新
addon-detail-updates-radio-default = 默认
addon-detail-updates-radio-on = 开
addon-detail-updates-radio-off = 关
addon-detail-update-check-label = 检查更新
install-update-button = 更新
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = 允许运行于隐私窗口
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = 若允许，扩展可在隐私浏览中获知您的在线活动。 <a data-l10n-name="learn-more">详细了解</a>
addon-detail-private-browsing-allow = 允许
addon-detail-private-browsing-disallow = 不允许

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = { -brand-product-name } 只推荐符合我们的安全和性能标准的扩展。
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Mozilla" in the string below because the extensions are built
# by Mozilla and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = 由 Mozilla 构建的官方扩展，符合安全和性能标准
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = 此扩展已通过审核，符合我们的安全和性能标准
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = 可用更新
recent-updates-heading = 最近更新
release-notes-loading = 正在载入…
release-notes-error = 抱歉，载入发行说明时出错。
addon-permissions-empty = 此扩展未要求任何权限
addon-permissions-required = 核心功能所需的权限：
addon-permissions-optional = 附加功能的可选权限：
addon-permissions-learnmore = 详细了解“权限”
recommended-extensions-heading = 推荐扩展
recommended-themes-heading = 推荐主题
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = 有好的创意？<a data-l10n-name="link">使用 Firefox Color 打造自己的主题。</a>

## Page headings

extension-heading = 管理您的扩展
theme-heading = 管理您的主题
plugin-heading = 管理您的插件
dictionary-heading = 管理您的字典
locale-heading = 管理您的语言包
updates-heading = 管理您的更新
discover-heading = 让 { -brand-short-name } 有您的个性
shortcuts-heading = 管理扩展快捷键
default-heading-search-label = 寻找更多附加组件
addons-heading-search-input =
    .placeholder = 在 addons.mozilla.org 搜索
addon-page-options-button =
    .title = 用于所有附加组件的工具
