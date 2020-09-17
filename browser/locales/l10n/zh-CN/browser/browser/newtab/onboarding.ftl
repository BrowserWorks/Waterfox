# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = 详细了解
onboarding-button-label-get-started = 开始使用

## Welcome modal dialog strings

onboarding-welcome-header = 欢迎使用 { -brand-short-name }
onboarding-welcome-body = 浏览器安装完成。<br/>但 { -brand-product-name } 不只是浏览器。
onboarding-welcome-learn-more = 还有更多好物。
onboarding-welcome-modal-get-body = 浏览器安装完成。<br/>看看 { -brand-product-name } 的其他功能。
onboarding-welcome-modal-supercharge-body = 强化隐私保护措施。
onboarding-welcome-modal-privacy-body = 浏览器安装完成。来强化一下隐私保护措施把。
onboarding-welcome-modal-family-learn-more = 了解 { -brand-product-name } 系列产品。
onboarding-welcome-form-header = 从这里开始
onboarding-join-form-body = 在此输入您的电子邮件地址，即可开始使用。
onboarding-join-form-email =
    .placeholder = 输入电子邮件地址
onboarding-join-form-email-error = 需要有效的电子邮件地址
onboarding-join-form-legal = 若继续，即表示您同意我们的<a data-l10n-name="terms">服务条款</a>和<a data-l10n-name="privacy">隐私声明</a>。
onboarding-join-form-continue = 继续
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = 已有账户？
# Text for link to submit the sign in form
onboarding-join-form-signin = 登录
onboarding-start-browsing-button-label = 开始上网冲浪
onboarding-cards-dismiss =
    .title = 隐藏
    .aria-label = 隐藏

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = 欢迎使用 <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = 快速、安全、私密的浏览器，由非营利组织全力支持。
onboarding-multistage-welcome-primary-button-label = 开始设置
onboarding-multistage-welcome-secondary-button-label = 登录
onboarding-multistage-welcome-secondary-button-text = 已有账户？
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = 导入您的密码、书签和<span data-l10n-name="zap">更多数据</span>
onboarding-multistage-import-subtitle = 从其他浏览器来？将一切转移到 { -brand-short-name } 很简单。
onboarding-multistage-import-primary-button-label = 开始导入
onboarding-multistage-import-secondary-button-label = 暂时不要
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = 在此设备找到上面列出的网站。除非您选择导入，否则 { -brand-short-name } 不会保存或同步另一浏览器的数据。
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = 开始使用：第 { $current }屏，共 { $total } 屏
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = 选择<span data-l10n-name="zap">外观</span>
onboarding-multistage-theme-subtitle = 使用主题，让 { -brand-short-name } 有你的个性
onboarding-multistage-theme-primary-button-label = 保存主题
onboarding-multistage-theme-secondary-button-label = 暂时不要
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = 自动
# System refers to the operating system
onboarding-multistage-theme-description-automatic = 使用系统主题
onboarding-multistage-theme-label-light = 明亮
onboarding-multistage-theme-label-dark = 深邃
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox 染山霞

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title = 遵循操作系统的按钮、菜单、窗口外观。
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title = 使用亮色按钮、菜单、窗口外观。
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title = 使用暗色按钮、菜单、窗口外观。
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title = 使用多彩按钮、菜单、窗口外观。
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title = 遵循操作系统的按钮、菜单、窗口外观。
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description = 遵循操作系统的按钮、菜单、窗口外观。
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title = 使用亮色按钮、菜单、窗口外观。
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description = 使用亮色按钮、菜单、窗口外观。
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title = 使用暗色按钮、菜单、窗口外观。
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description = 使用暗色按钮、菜单、窗口外观。
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title = 使用多彩按钮、菜单、窗口外观。
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description = 使用多彩按钮、菜单、窗口外观。

## Welcome full page string

onboarding-fullpage-welcome-subheader = 来探索有哪些能力。
onboarding-fullpage-form-email =
    .placeholder = 您的电子邮件地址…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = { -brand-product-name } 随身带着走
onboarding-sync-welcome-content = 在所有设备上都能同步书签、历史记录、密码以及其他设置，数据随处可取。
onboarding-sync-welcome-learn-more-link = 详细了解 Firefox 账户
onboarding-sync-form-input =
    .placeholder = 电子邮件
onboarding-sync-form-continue-button = 继续
onboarding-sync-form-skip-login-button = 跳过此步骤

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = 请输入您的电子邮箱
onboarding-sync-form-sub-header = 以启用 { -sync-brand-name }服务。

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = 全套尊重隐私权的工具在任何设备上都能助你事半功倍。
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = 我们所做的一切，均符合我们对个人数据隐私的承诺：索取更少、确保安全、绝不隐瞒。
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = 时刻使用 { -brand-product-name } 同步书签、密码、历史记录等数据。
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = 在您的个人信息出现在数据外泄事件时收到通知。
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = 小巧便携又固若金汤，轻松管理网站密码。

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = 保护您不受跟踪
onboarding-tracking-protection-text2 = { -brand-short-name } 可帮助阻止网站的在线跟踪，让内容跟踪器更难盯上您。
onboarding-tracking-protection-button2 = 工作原理
onboarding-data-sync-title = 把设置随身带着走
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = 在任何使用 { -brand-product-name } 的地方同步书签、密码等数据。
onboarding-data-sync-button2 = 登录{ -sync-brand-short-name }服务
onboarding-firefox-monitor-title = 数据外泄有提醒
onboarding-firefox-monitor-text2 = { -monitor-brand-name } 会监控您的电子邮件地址是否出现在已知数据外泄事件中，并在有新外泄事件时通知您。
onboarding-firefox-monitor-button = 订阅警报
onboarding-browse-privately-title = 私密浏览
onboarding-browse-privately-text = 隐私浏览会自动清除您的搜索与上网记录，让使用此计算机的其他人无法得知您在网上的活动。
onboarding-browse-privately-button = 打开隐私窗口
onboarding-firefox-send-title = 以私密的方式分享文件
onboarding-firefox-send-text2 = 上传您的文件到 { -send-brand-name }，即可通过端到端加密与链接到期即焚来进行分享。
onboarding-firefox-send-button = 试试 { -send-brand-name }
onboarding-mobile-phone-title = 获取手机版 { -brand-product-name }
onboarding-mobile-phone-text = 下载适用于 iOS 或 Android 的 { -brand-product-name }，即可跨设备同步数据。
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = 下载移动浏览器
onboarding-send-tabs-title = 即时发送标签页给自己
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = 轻松跨设备分享网页，无须复制链接或离开浏览器。
onboarding-send-tabs-button = 开始使用 Send Tabs
onboarding-pocket-anywhere-title = 随处阅听
onboarding-pocket-anywhere-text2 = 可使用 { -pocket-brand-name } 应用离线保存您喜爱的故事，以便您闲暇时阅读、聆听和观看。
onboarding-pocket-anywhere-button = 试试 { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = 创建并存储高强度的密码
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } 可直接在网页表单中创建高强度密码，并将所有密码存放于同一位置。
onboarding-lockwise-strong-passwords-button = 管理您的登录信息
onboarding-facebook-container-title = 为 Facebook 设置边界
onboarding-facebook-container-text2 = { -facebook-container-brand-name } 可将您的 Facebook 身份与其他网站隔离，使 Facebook 更难以通过广告定位您。
onboarding-facebook-container-button = 添加扩展
onboarding-import-browser-settings-title = 导入您的书签、密码等数据
onboarding-import-browser-settings-text = 马上就好——请导入您的 Chrome 网站和设置。
onboarding-import-browser-settings-button = 导入 Chrome 数据
onboarding-personal-data-promise-title = 围绕隐私设计
onboarding-personal-data-promise-text = { -brand-product-name } 尊重您的数据，索取更少、严格保护、用途明确。
onboarding-personal-data-promise-button = 阅读我们的承诺

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = 恭喜，您已经安装好 { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = 现在来安装 <icon></icon><b>{ $addon-name } 吧。</b>
return-to-amo-extension-button = 添加扩展
return-to-amo-get-started-button = { -brand-short-name } 使用入门
