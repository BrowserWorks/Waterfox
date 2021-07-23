# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = 账户设置

## Header

account-setup-title = 设置现有的电子邮件地址
account-setup-description =
    若要使用您现有的电子邮件地址，请填写您的凭据。<br/>
    { -brand-product-name } 将会自动查询可用并推荐使用的服务器配置。

## Form fields

account-setup-name-label = 您的全名
    .accesskey = n
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = 李四
account-setup-name-info-icon =
    .title = 你的名字，显示给其他人
account-setup-name-warning-icon =
    .title = { account-setup-name-warning }
account-setup-email-label = 电子邮件地址
    .accesskey = E
account-setup-email-input =
    .placeholder = john.doe@example.com
account-setup-email-info-icon =
    .title = 您现有的电子邮件地址
account-setup-email-warning-icon =
    .title = { account-setup-email-warning }
account-setup-password-label = 密码
    .accesskey = P
    .title = 可选，仅用于验证用户名
account-provisioner-button = 注册新的电子邮件地址…
    .accesskey = G
account-setup-password-toggle =
    .title = 显示/隐藏密码
account-setup-remember-password = 记住密码
    .accesskey = m
account-setup-exchange-label = 您的登录信息
    .accesskey = l
#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = 您的域﹨您的用户名
#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = 域登录

## Action buttons

account-setup-button-cancel = 取消
    .accesskey = a
account-setup-button-manual-config = 手动配置
    .accesskey = m
account-setup-button-stop = 停止
    .accesskey = S
account-setup-button-retest = 重新测试
    .accesskey = t
account-setup-button-continue = 继续
    .accesskey = C
account-setup-button-done = 完成
    .accesskey = D

## Notifications

account-setup-looking-up-settings = 正在查询配置…
account-setup-looking-up-settings-guess = 正在查询配置：正在尝试常用的服务器名称…
account-setup-looking-up-settings-half-manual = 正在查询配置：正在探测服务器…
account-setup-looking-up-disk = 正在查询配置：{ -brand-short-name } 安装…
account-setup-looking-up-isp = 正在查询配置：电子邮件服务商...
# Note: Do not translate or replace Mozilla. It stands for the public project mozilla.org, not Mozilla Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = 正在查询配置：Mozilla ISP 数据库…
account-setup-looking-up-mx = 正在查询配置：收件域名…
account-setup-looking-up-exchange = 正在查询配置：Exchange 服务器…
account-setup-checking-password = 正在验证密码…
account-setup-installing-addon = 正在下载安装附加组件…
account-setup-success-half-manual = 探测指定服务器找到下列配置：
account-setup-success-guess = 尝试常用服务器名称找到配置。
account-setup-success-guess-offline = 您已离线。我们已推测一些设置，但您需要输入正确的设置。
account-setup-success-password = 密码正确
account-setup-success-addon = 已成功安装附加组件
# Note: Do not translate or replace Mozilla. It stands for the public project mozilla.org, not Mozilla Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = 从 Mozilla ISP 数据库中找到配置。
account-setup-success-settings-disk = 在 { -brand-short-name } 安装找到配置。
account-setup-success-settings-isp = 从电子邮件服务商找到配置。
# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = 找到 Microsoft Exchange 服务器的配置。

## Illustrations

account-setup-step1-image =
    .title = 初始设置
account-setup-step2-image =
    .title = 正在加载…
account-setup-step3-image =
    .title = 找到配置
account-setup-step4-image =
    .title = 连接错误
account-setup-privacy-footnote = 凭据将遵循我们的<a data-l10n-name="privacy-policy-link">隐私政策</a>进行使用，且仅会存储在本地。
account-setup-selection-help = 不确定要怎么选？
account-setup-selection-error = 需要帮助？
account-setup-documentation-help = 设置文档
account-setup-forum-help = 支持论坛

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
       *[other] 可用配置
    }
# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP
account-setup-result-imap-description = 与您的服务器同步各文件夹与邮件
# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3
account-setup-result-pop-description = 将您服务器上的各文件夹与邮件下载到本地
# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange
account-setup-result-exchange-description = Microsoft Exchange 服务器
account-setup-incoming-title = 收件
account-setup-outgoing-title = 发件
account-setup-username-title = 用户名
account-setup-exchange-title = 服务器
account-setup-result-smtp = SMTP
account-setup-result-no-encryption = 未加密
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS
account-setup-result-outgoing-existing = 使用已有的发件 SMTP 服务器
# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = 收件：{ $incoming }，发件：{ $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = 验证失败。可能是您输入的凭据不正确，或需要使用单独的用户名登录。此用户名通常是 Windows 的域登录用户名，可以包含也可以不包含域（如：janedoe 或 AD\\janedoe）。
account-setup-credentials-wrong = 验证失败。请检查用户名和密码
account-setup-find-settings-failed = { -brand-short-name } 未能找到你的邮件账户设置
account-setup-exchange-config-unverifiable = 无法验证配置。如果您的用户名和密码确认无误，则可能是服务器管理员已禁用了您为账户所选的配置。请尝试选择其他协议。

## Manual configuration area

account-setup-manual-config-title = 服务器设置
account-setup-incoming-server-legend = 收件服务器
account-setup-protocol-label = 协议：
protocol-imap-option = { account-setup-result-imap }
protocol-pop-option = { account-setup-result-pop }
protocol-exchange-option = { account-setup-result-exchange }
account-setup-hostname-label = 主机名：
account-setup-port-label = 端口：
    .title = 端口设为 0，则为自动检测
account-setup-auto-description = { -brand-short-name } 将尝试自动检测留白的字段。
account-setup-ssl-label = 连接安全性：
account-setup-outgoing-server-legend = 发件服务器

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = 自动检测
ssl-no-authentication-option = 无须验证
ssl-cleartext-password-option = 普通密码
ssl-encrypted-password-option = 加密过的密码

## Incoming/Outgoing SSL options

ssl-noencryption-option = 无
account-setup-auth-label = 验证方式：
account-setup-username-label = 用户名：
account-setup-advanced-setup-button = 高级配置
    .accesskey = A

## Warning insecure server dialog

account-setup-insecure-title = 警告！
account-setup-insecure-incoming-title = 收件设置：
account-setup-insecure-outgoing-title = 发件设置：
# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = <b>{ $server }</b> 未加密连接。
account-setup-warning-cleartext-details = 不安全的邮件服务器不使用加密连接以保护您的密码及个人信息。连接到这样的邮件服务器有可能会泄露您的密码和个人信息。
account-setup-insecure-server-checkbox = 我已了解相关风险。
    .accesskey = u
account-setup-insecure-description = { -brand-short-name } 可以让您通过使用提供的配置信息来收取邮件。但是，对于这些不正确的连接，您应该联系您的管理员或者电子邮件提供商，更详细的信息请参见 <a data-l10n-name="thunderbird-faq-link">Thunderbird 常见问题解答</a>。
insecure-dialog-cancel-button = 更改设置
    .accesskey = S
insecure-dialog-confirm-button = 确认
    .accesskey = C

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = { -brand-short-name } 在 { $domain } 上找到了您的账户设置信息，您要继续并提交凭据吗？
exchange-dialog-confirm-button = 登录
exchange-dialog-cancel-button = 取消

## Alert dialogs

account-setup-creation-error-title = 创建账户时发生错误
account-setup-error-server-exists = 收件服务器已存在。
account-setup-confirm-advanced-title = 确认高级配置
account-setup-confirm-advanced-description = 此对话框将关闭，即使配置不正确，也会使用当前设置来创建账户。您确定要继续吗？

## Addon installation section

account-setup-addon-install-title = 安装
account-setup-addon-install-intro = 安装第三方附加组件后，可让您访问此服务器上的邮件账户：
account-setup-addon-no-protocol = 此邮件服务器不支持开放式协议。{ account-setup-addon-install-intro }
