# This Source Code Form is subject to the terms of the BrowserWorks Public
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
pippki-failed-pw-change = 无法更改密码。
pippki-incorrect-pw = 您未输入正确的主密码，请重试。
pippki-pw-change-ok = 密码更改成功。
pippki-pw-empty-warning = 您存储的密码和私钥将不再受保护。
pippki-pw-erased-ok = 警告！您已经删除了您的主密码。 { pippki-pw-empty-warning }
pippki-pw-not-wanted = 警告！您决定了不使用主密码。{ pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = 您正处于 FIPS 模式。该模式需要一个非空的主密码。

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = 重置主密码
    .style = min-width: 40em
reset-password-button-label =
    .label = 重置
reset-primary-password-text = 如果您重置您的主密码，您存储的所有网站和电子邮箱密码、表单数据、个人证书以及私钥，都将被丢弃。您确实要重置主密码吗？
pippki-reset-password-confirmation-title = 重置主密码
pippki-reset-password-confirmation-message = 您的主密码已重置。

## Downloading cert dialog

download-cert-window2 =
    .title = 下载证书
    .style = min-width: 46em
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


## Client Authentication Ask dialog

client-auth-window =
    .title = 使用确认请求
client-auth-site-description = 此站点请求您用证书来标识您自己：
client-auth-choose-cert = 选择一个证书作为标识：
client-auth-send-no-certificate =
    .label = 不发送证书
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = “{ $hostname }”请求您用证书来标识您自己：
client-auth-cert-details = 所选证书细节：
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = 颁发给：{ $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = 序列号：{ $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = 有效期从 { $notBefore } 至 { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = 密钥用途：{ $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = 电子邮件地址：{ $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = 颁发者：{ $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = 存储于：{ $storedOn }
client-auth-cert-remember-box =
    .label = 记住此决定

## Set password (p12) dialog

set-password-window =
    .title = 输入证书备份密码
set-password-message = 证书备份密码是用来保护您即将创建的证书备份文件。您必须设置此密码才能备份。
set-password-backup-pw =
    .value = 证书备份密码：
set-password-repeat-backup-pw =
    .value = 证书备份密码（重复）：
set-password-reminder = 重要：如果您忘记了您的证书备份密码，您此后将无法恢复此备份。请将它记在一个安全的地方。

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = 请对令牌“{ $tokenName }”进行身份验证。如何操作取决于令牌（例如，按压指纹识别器或键入代码）。
