# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = 密码强度

## Change Password dialog

change-device-password-window =
    .title = 更改密码

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = 安全设备: { $tokenName }
change-password-old = 当前密码:
change-password-new = 新密码:
change-password-reenter = 新密码(重复):

## Reset Password dialog

pippki-failed-pw-change = 无法更改密码。
pippki-incorrect-pw = 您未输入正确的主密码，请重试。
pippki-pw-change-ok = 密码更改成功。

pippki-pw-empty-warning = 您存储的密码和私钥将不再受保护。
pippki-pw-erased-ok = 警告！您已经删除了您的主密码。 { pippki-pw-empty-warning }
pippki-pw-not-wanted = 警告！您决定了不使用主密码。{ pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = 您正处于 FIPS 模式。该模式需要一个非空的主密码。

## Reset Primary Password dialog

reset-primary-password-window =
    .title = 重置主密码
    .style = width: 40em
reset-password-button-label =
    .label = 重置

reset-primary-password-text = 如果您重置您的主密码，您存储的所有网站和电子邮箱密码、表单数据、个人证书以及私钥，都将被丢弃。您确实要重置主密码吗？

pippki-reset-password-confirmation-title = 重置主密码
pippki-reset-password-confirmation-message = 您的主密码已重置。

## Downloading cert dialog

download-cert-window =
    .title = 下载证书
    .style = width: 46em
download-cert-message = 您被要求信任一个新的数字证书认证机构（CA）。
download-cert-trust-ssl =
    .label = 信任由此证书颁发机构来标识网站。
download-cert-trust-email =
    .label = 信任由此证书颁发机构来标识电子邮件用户。
download-cert-message-desc = 在信任此证书颁发机构之前，您应该检查它的证书、策略和它的手续（如果有的话）。
download-cert-view-cert =
    .label = 查看
download-cert-view-text = 检查CA证书

## Client Authorization Ask dialog

client-auth-window =
    .title = 使用确认请求
client-auth-site-description = 此站点请求您用证书来标识您自己：
client-auth-choose-cert = 选择一个证书作为标识：
client-auth-cert-details = 所选证书细节：

## Set password (p12) dialog

set-password-window =
    .title = 输入证书备份密码
set-password-message = 证书备份密码是用来保护您即将创建的证书备份文件。您必须设置此密码才能备份。
set-password-backup-pw =
    .value = 证书备份密码：
set-password-repeat-backup-pw =
    .value = 证书备份密码（重复）：
set-password-reminder = 重要：如果您忘记了您的证书备份密码，您此后将无法恢复此备份。请将它记在一个安全的地方。

## Protected Auth dialog

protected-auth-window =
    .title = 受保护的令牌身份验证
protected-auth-msg = 请验证该令牌。认证方式取决于您的令牌的类型。
protected-auth-token = 令牌：
