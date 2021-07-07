# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = 对 { $addon-name } 的举报

abuse-report-title-extension = 向 { -vendor-short-name } 举报此扩展
abuse-report-title-theme = 向 { -vendor-short-name } 举报此主题
abuse-report-subtitle = 有什么问题？

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = 作者：<a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore = 不确定要选择哪项？<a data-l10n-name="learnmore-link">详细了解举报扩展与主题</a>

abuse-report-submit-description = 描述问题（选填）
abuse-report-textarea =
    .placeholder = 如果有更多细节，我们就能更容易找到问题根源。请描述您遇到了哪些问题，也非常感谢您帮助我们保持网络健康。
abuse-report-submit-note = 注：请勿包含个人信息（如姓名、电子邮件地址、电话号码、家庭住址等）。{ -vendor-short-name } 会保留这些举报的永久性记录。

## Panel buttons.

abuse-report-cancel-button = 取消
abuse-report-next-button = 下一步
abuse-report-goback-button = 返回上一步
abuse-report-submit-button = 提交

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = 已取消举报 <span data-l10n-name="addon-name">{ $addon-name }</span>。
abuse-report-messagebar-submitting = 正在发送 <span data-l10n-name="addon-name">{ $addon-name }</span> 的举报。
abuse-report-messagebar-submitted = 感谢您提交举报。您想要移除 <span data-l10n-name="addon-name">{ $addon-name }</span> 吗？
abuse-report-messagebar-submitted-noremove = 感谢您提交举报！
abuse-report-messagebar-removed-extension = 感谢您提交举报。已移除 <span data-l10n-name="addon-name">{ $addon-name }</span> 扩展。
abuse-report-messagebar-removed-theme = 感谢您提交举报。已移除 <span data-l10n-name="addon-name">{ $addon-name }</span> 主题。
abuse-report-messagebar-error = 发送 <span data-l10n-name="addon-name">{ $addon-name }</span> 的举报时，发生错误。
abuse-report-messagebar-error-recent-submit = 由于最近发送过另一份举报，并未发送 <span data-l10n-name="addon-name">{ $addon-name }</span> 的举报。

## Message bars actions.

abuse-report-messagebar-action-remove-extension = 是的，移除它
abuse-report-messagebar-action-keep-extension = 不了，我想继续使用
abuse-report-messagebar-action-remove-theme = 是的，移除它
abuse-report-messagebar-action-keep-theme = 不了，我想继续使用
abuse-report-messagebar-action-retry = 重试
abuse-report-messagebar-action-cancel = 取消

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = 它损坏了我的计算机或泄露我的数据
abuse-report-damage-example = 例如：注入恶意软件或窃取数据

abuse-report-spam-reason-v2 = 它包含垃圾邮件或插入不受欢迎的广告
abuse-report-spam-example = 例如：在网页中插入广告

abuse-report-settings-reason-v2 = 它未预先询问或通知我，就更改了我的搜索引擎、主页、新标签页
abuse-report-settings-suggestions = 举报扩展前，您可以尝试修改浏览器设置：
abuse-report-settings-suggestions-search = 更改您的默认搜索设置
abuse-report-settings-suggestions-homepage = 更改您的主页和新标签页

abuse-report-deceptive-reason-v2 = 它伪装成与其无关的东西
abuse-report-deceptive-example = 例如：误导性描述或图像

abuse-report-broken-reason-extension-v2 = 它不起作用、造成网站无法正常使用、拖慢 { -brand-product-name }
abuse-report-broken-reason-theme-v2 = 它不起作用或破坏浏览器显示内容
abuse-report-broken-example = 例如：功能运行缓慢、难以使用或不起作用；导致部分网站加载不完整，或看起来不正常
abuse-report-broken-suggestions-extension = 听起来您遇到缺陷（Bug）了。除了在此举报之外，解决功能问题的最佳方式是直接联系扩展开发者。请<a data-l10n-name="support-link">访问扩展网站</a>获取开发者联系方式。
abuse-report-broken-suggestions-theme = 听起来您遇到缺陷（Bug）了。除了在此举报之外，解决功能问题的最佳方式是直接联系扩展开发者。请<a data-l10n-name="support-link">访问主题网站</a>获取开发者联系方式。

abuse-report-policy-reason-v2 = 它散播仇恨、暴力、非法内容
abuse-report-policy-suggestions = 注: 若有版权与商标问题，请依照另一流程处理。<a data-l10n-name="report-infringement-link">请依照该说明</a>举报问题。

abuse-report-unwanted-reason-v2 = 我从未安装此附加组件，也不知如何移除
abuse-report-unwanted-example = 例如：计算机中的某应用程序未经我同意便安装了此附加组件

abuse-report-other-reason = 其他原因

