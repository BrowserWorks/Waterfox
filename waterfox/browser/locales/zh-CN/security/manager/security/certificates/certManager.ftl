# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = 证书管理器

certmgr-tab-mine =
    .label = 您的证书

certmgr-tab-remembered =
    .label = 认证决策

certmgr-tab-people =
    .label = 个人

certmgr-tab-servers =
    .label = 服务器

certmgr-tab-ca =
    .label = 证书颁发机构

certmgr-mine = 您有下列组织的证书可以识别您自己
certmgr-remembered = 下列证书可用于向网站识别您的身份
certmgr-people = 您有用来识别这些人的证书文件
certmgr-server = 下列是服务器证书例外项目
certmgr-ca = 您有用来识别这些证书颁发机构的证书文件

certmgr-edit-ca-cert =
    .title = 编辑证书颁发机构信任关系设置
    .style = width: 48em;

certmgr-edit-cert-edit-trust = 编辑信任设置：

certmgr-edit-cert-trust-ssl =
    .label = 此证书可以标识网站。

certmgr-edit-cert-trust-email =
    .label = 此证书可以标识电子邮件用户。

certmgr-delete-cert =
    .title = 删除证书
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = 主机

certmgr-cert-name =
    .label = 证书名称

certmgr-cert-server =
    .label = 服务器

certmgr-override-lifetime =
    .label = 生命周期

certmgr-token-name =
    .label = 安全设备

certmgr-begins-label =
    .label = 起始时间

certmgr-expires-label =
    .label = 过期时间

certmgr-email =
    .label = 电子邮件地址

certmgr-serial =
    .label = 序列号

certmgr-view =
    .label = 查看…
    .accesskey = V

certmgr-edit =
    .label = 编辑信任…
    .accesskey = E

certmgr-export =
    .label = 导出…
    .accesskey = x

certmgr-delete =
    .label = 删除…
    .accesskey = D

certmgr-delete-builtin =
    .label = 删除或不信任…
    .accesskey = D

certmgr-backup =
    .label = 备份…
    .accesskey = B

certmgr-backup-all =
    .label = 全部备份…
    .accesskey = k

certmgr-restore =
    .label = 导入…
    .accesskey = m

certmgr-add-exception =
    .label = 添加例外…
    .accesskey = x

exception-mgr =
    .title = 添加安全例外

exception-mgr-extra-button =
    .label = 确认安全例外
    .accesskey = C

exception-mgr-supplemental-warning = 合法的银行、电商以及其他公共网站不会要求您这么做。

exception-mgr-cert-location-url =
    .value = 地址:

exception-mgr-cert-location-download =
    .label = 获取证书
    .accesskey = G

exception-mgr-cert-status-view-cert =
    .label = 查看…
    .accesskey = V

exception-mgr-permanent =
    .label = 永久保存此例外
    .accesskey = P

pk11-bad-password = 输入的密码不正确。
pkcs12-decode-err = 解码该文件失败。它可能不是 PKCS #12 格式，或已经损坏，或您输入的密码不正确。
pkcs12-unknown-err-restore = 恢复 PKCS #12 文件失败，原因未知。
pkcs12-unknown-err-backup = 创建 PKCS #12 备份文件失败，原因未知。
pkcs12-unknown-err = PKCS #12 操作失败，原因未知。
pkcs12-info-no-smartcard-backup = 不可能备份硬件安全设备（如智能卡）中的证书。
pkcs12-dup-data = 证书和私钥已经存在于此安全设备中了。

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = 要备份的文件名
file-browse-pkcs12-spec = PKCS12 文件
choose-p12-restore-file-dialog = 要导入的证书文件

## Import certificate(s) file dialog

file-browse-certificate-spec = 证书文件
import-ca-certs-prompt = 请选择要导入的包含 CA 证书的文件
import-email-cert-prompt = 请选择包含要导入的包含某人邮件证书的文件

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = 此证书“{ $certName }”代表了一个数字证书颁发机构（CA）。

## For Deleting Certificates

delete-user-cert-title =
    .title = 删除您的证书
delete-user-cert-confirm = 确定要删除这些证书吗？
delete-user-cert-impact = 如果您删除了某个您自己的证书，您将无法使用它来标识你自己。


delete-ssl-override-title =
    .title = 删除服务器证书例外
delete-ssl-override-confirm = 您确定要删除此服务器例外吗？
delete-ssl-override-impact = 如果您删除一个服务器例外，下次您再访问该服务器时会恢复要求该网站使用有效的证书，您可能又会收到服务器证书无效的提示。

delete-ca-cert-title =
    .title = 删除或不信任 CA 证书
delete-ca-cert-confirm = 您已请求删除这些 CA 证书。内置的证书将被取消所有信任使操作达到同样的效果。您确认要删除或取消信任吗？
delete-ca-cert-impact = 如果您删除或不信任证书一个颁发机构（CA）证书，本应用程序将不再信任由该 CA 颁发的任何证书.


delete-email-cert-title =
    .title = 删除电子邮件证书
delete-email-cert-confirm = 您确定要删除这些人的电子邮件证书吗？
delete-email-cert-impact = 如果您删除了某人的电子邮件证书，您将不能再向此人发送加密电子邮件。

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = 证书序列号：{ $serialNumber }

## Cert Viewer

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = 不发送客户端证书

# Used when no cert is stored for an override
no-cert-stored-for-override = （未存储）

# When a certificate is unavailable (for example, it has been deleted or the token it exists on has been removed).
certificate-not-available = (不可用)

## Used to show whether an override is temporary or permanent

permanent-override = 永久
temporary-override = 临时

## Add Security Exception dialog

add-exception-branded-warning = 您将指定 { -brand-short-name } 如何来标识此站点。
add-exception-invalid-header = 此站点尝试使用无效的信息来标识自身。
add-exception-domain-mismatch-short = 错误的站点
add-exception-domain-mismatch-long = 证书属于其他网站，有可能是某人想要冒充此网站。
add-exception-expired-short = 过时的信息
add-exception-expired-long = 该证书目前无效。它可能已被失窃或遗失，并可能被某人用于冒充此网站。
add-exception-unverified-or-bad-signature-short = 未知标识
add-exception-unverified-or-bad-signature-long = 无法核实此证书是否由受信任的颁发机构以安全方式签署，因此不能信任此证书。
add-exception-valid-short = 有效的证书
add-exception-valid-long = 此站点提供了有效、已验证的标识。因此无添加例外的必要。
add-exception-checking-short = 正在检查信息
add-exception-checking-long = 正在尝试识别此站点…
add-exception-no-cert-short = 无可用信息
add-exception-no-cert-long = 无法取得指定站点的标识及状态信息。

## Certificate export "Save as" and error dialogs

save-cert-as = 保存证书至文件
cert-format-base64 = X.509 证书 (PEM)
cert-format-base64-chain = X.509 含链证书 (PEM)
cert-format-der = X.509 证书 (DER)
cert-format-pkcs7 = X.509 证书 (PKCS#7)
cert-format-pkcs7-chain = X.509 含链证书 (PKCS#7)
write-file-failure = 文件错误
