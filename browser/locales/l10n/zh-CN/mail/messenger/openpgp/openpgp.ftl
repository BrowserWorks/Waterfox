# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = 若要发送经加密或数字签名的消息，需配置 OpenPGP 或 S/MIME 加密技术。
e2e-intro-description-more = 请选择您要用于 OpenPGP 的个人密钥，或用于 S/MIME 的个人证书。无论是个人密钥或是证书，您都会有对应的私钥。
openpgp-key-user-id-label = 账户 / 用户 ID
openpgp-keygen-title-label =
    .title = 生成 OpenPGP 密钥
openpgp-cancel-key =
    .label = 取消
    .tooltiptext = 取消生成密钥
openpgp-key-gen-expiry-title =
    .label = 密钥到期日
openpgp-key-gen-expire-label = 密钥过期时间
openpgp-key-gen-days-label =
    .label = 天
openpgp-key-gen-months-label =
    .label = 月
openpgp-key-gen-years-label =
    .label = 年
openpgp-key-gen-no-expiry-label =
    .label = 密钥永不过期
openpgp-key-gen-key-size-label = 密钥大小
openpgp-key-gen-console-label = 密钥生成方式
openpgp-key-gen-key-type-label = 密钥类型
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC（椭圆曲线）
openpgp-generate-key =
    .label = 生成密钥
    .tooltiptext = 生成新的 OpenPGP 兼容密钥，进行加密与/或签名
openpgp-advanced-prefs-button-label =
    .label = 高级…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">注意：密钥生成可能需要几分才能完成。</a></b>密钥生成过程中，请不要关闭应用程序。主动浏览上网，或进行频繁读写磁盘操作，可补充“随机数池”以加速密钥生成。完成后将提示您密钥已生成。
openpgp-key-expiry-label =
    .label = 到期日
openpgp-key-id-label =
    .label = 密钥 ID
openpgp-cannot-change-expiry = 该密钥结构复杂，不支持更改到期日。
openpgp-key-man-title =
    .title = OpenPGP 密钥管理器
openpgp-key-man-generate =
    .label = 生成新密钥对
    .accesskey = K
openpgp-key-man-gen-revoke =
    .label = 吊销证书
    .accesskey = R
openpgp-key-man-ctx-gen-revoke-label =
    .label = 生成并保存吊销证书
openpgp-key-man-file-menu =
    .label = 文件
    .accesskey = F
openpgp-key-man-edit-menu =
    .label = 编辑
    .accesskey = E
openpgp-key-man-view-menu =
    .label = 查看
    .accesskey = V
openpgp-key-man-generate-menu =
    .label = 生成
    .accesskey = G
openpgp-key-man-keyserver-menu =
    .label = 密钥服务器
    .accesskey = K
openpgp-key-man-import-public-from-file =
    .label = 从文件导入公钥
    .accesskey = I
openpgp-key-man-import-secret-from-file =
    .label = 从文件导入私钥
openpgp-key-man-import-sig-from-file =
    .label = 从文件导入证书吊销信息
openpgp-key-man-import-from-clipbrd =
    .label = 从剪贴板导入密钥
    .accesskey = I
openpgp-key-man-import-from-url =
    .label = 从 URL 导入密钥
    .accesskey = U
openpgp-key-man-export-to-file =
    .label = 将公钥导出为文件
    .accesskey = E
openpgp-key-man-send-keys =
    .label = 通过电子邮件发送公钥
    .accesskey = S
openpgp-key-man-backup-secret-keys =
    .label = 备份私钥为文件
    .accesskey = B
openpgp-key-man-discover-cmd =
    .label = 在网上寻找密钥
    .accesskey = D
openpgp-key-man-discover-prompt = 若要在网上寻找 OpenPGP 密钥、密钥服务器或使用 WKD 通信协议，请输入电子邮件地址或密钥 ID。
openpgp-key-man-discover-progress = 正在搜索…
openpgp-key-copy-key =
    .label = 复制公钥
    .accesskey = C
openpgp-key-export-key =
    .label = 将公钥导出为文件
    .accesskey = E
openpgp-key-backup-key =
    .label = 备份私钥为文件
    .accesskey = B
openpgp-key-send-key =
    .label = 通过电子邮件发送公钥
    .accesskey = S
openpgp-key-man-copy-to-clipbrd =
    .label = 复制公钥到剪切板
    .accesskey = C
openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
           *[other] 复制密钥 ID 至剪贴板
        }
    .accesskey = K
openpgp-key-man-copy-fprs =
    .label =
        { $count ->
           *[other] 复制指纹至剪贴板
        }
    .accesskey = F
openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
           *[other] 复制公钥至剪贴板
        }
    .accesskey = P
openpgp-key-man-ctx-expor-to-file-label =
    .label = 将密钥导出为文件
openpgp-key-man-ctx-copy-to-clipbrd-label =
    .label = 复制公钥到剪切板
openpgp-key-man-ctx-copy =
    .label = 复制
    .accesskey = C
openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
           *[other] 指纹
        }
    .accesskey = F
openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
           *[other] 密钥 ID
        }
    .accesskey = K
openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
           *[other] 公钥
        }
    .accesskey = P
openpgp-key-man-close =
    .label = 关闭
openpgp-key-man-reload =
    .label = 重载密钥缓存
    .accesskey = R
openpgp-key-man-change-expiry =
    .label = 更改到期日
    .accesskey = E
openpgp-key-man-del-key =
    .label = 删除密钥
    .accesskey = D
openpgp-delete-key =
    .label = 删除密钥
    .accesskey = D
openpgp-key-man-revoke-key =
    .label = 吊销密钥
    .accesskey = R
openpgp-key-man-key-props =
    .label = 密钥属性
    .accesskey = K
openpgp-key-man-key-more =
    .label = 更多
    .accesskey = M
openpgp-key-man-view-photo =
    .label = 免冠照
    .accesskey = P
openpgp-key-man-ctx-view-photo-label =
    .label = 查看免冠照
openpgp-key-man-show-invalid-keys =
    .label = 显示无效的密钥
    .accesskey = D
openpgp-key-man-show-others-keys =
    .label = 显示来自其他人的密钥
    .accesskey = O
openpgp-key-man-user-id-label =
    .label = 名称
openpgp-key-man-fingerprint-label =
    .label = 指纹
openpgp-key-man-select-all =
    .label = 选择所有密钥
    .accesskey = A
openpgp-key-man-empty-tree-tooltip =
    .label = 在上方框内输入所搜索条目
openpgp-key-man-nothing-found-tooltip =
    .label = 没有与搜索条件匹配的密钥
openpgp-key-man-please-wait-tooltip =
    .label = 正在加载密钥，请稍候…
openpgp-key-man-filter-label =
    .placeholder = 搜索密钥
openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I
openpgp-key-details-title =
    .title = 密钥属性
openpgp-key-details-signatures-tab =
    .label = 证书
openpgp-key-details-structure-tab =
    .label = 结构
openpgp-key-details-uid-certified-col =
    .label = 用户 ID / 颁发者
openpgp-key-details-user-id2-label = 密钥声称所有者
openpgp-key-details-id-label =
    .label = ID
openpgp-key-details-key-type-label = 类型
openpgp-key-details-key-part-label =
    .label = 密钥部分
openpgp-key-details-algorithm-label =
    .label = 算法
openpgp-key-details-size-label =
    .label = 大小
openpgp-key-details-created-label =
    .label = 创建于
openpgp-key-details-created-header = 创建于
openpgp-key-details-expiry-label =
    .label = 到期日
openpgp-key-details-expiry-header = 到期日
openpgp-key-details-usage-label =
    .label = 用途
openpgp-key-details-fingerprint-label = 指纹
openpgp-key-details-sel-action =
    .label = 选择操作…
    .accesskey = S
openpgp-key-details-also-known-label = 密钥拥有者声称的其他身份：
openpgp-card-details-close-window-label =
    .buttonlabelaccept = 关闭
openpgp-acceptance-label =
    .label = 您是否要接受
openpgp-acceptance-rejected-label =
    .label = 不接受，拒绝此密钥。
openpgp-acceptance-undecided-label =
    .label = 还没决定，之后再说。
openpgp-acceptance-unverified-label =
    .label = 接受，但我还未验证过是否为正确密钥。
openpgp-acceptance-verified-label =
    .label = 接受，我已验证这的确是正确的指纹。
key-accept-personal = 您有此密钥的公钥与私钥部分，可以将其用作个人密钥。若此密钥是由别人提供给您的，则请勿将其用作个人密钥。
key-personal-warning = 您是否自行创建了此密钥，且显示的拥有者信息也是您本人？
openpgp-personal-no-label =
    .label = 不，请勿将其用作我的个人密钥。
openpgp-personal-yes-label =
    .label = 是，将此密钥视为个人密钥。
openpgp-copy-cmd-label =
    .label = 复制

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbird 没有用于 <b>{ $identity }</b> 的 OpenPGP 个人密钥
       *[other] Thunderbird 找到 { $count } 个 <b>{ $identity }</b> 的 OpenPGP 个人密钥
    }
#   $count (Number) - the number of configured keys associated with the current identity
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status =
    { $count ->
        [0] 请选择有效的密钥以启用 OpenPGP 协议。
       *[other] 您当前配置使用 ID 为 <b>{ $key }</b> 的密钥
    }
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-have-key = 您当前配置使用 ID 为 <b>{ $key }</b> 的密钥
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = 您当前配置使用密钥 <b>{ $key }</b>，已经过期。
openpgp-add-key-button =
    .label = 添加密钥...
    .accesskey = A
e2e-learn-more = 详细了解
openpgp-keygen-success = 已成功创建 OpenPGP 密钥！
openpgp-keygen-import-success = 已成功导入 OpenPGP 密钥！
openpgp-keygen-external-success = 已保存外部 GnuPG 密钥 ID！

## OpenPGP Key selection area

openpgp-radio-none =
    .label = 无
openpgp-radio-none-desc = 不要为此身份使用 OpenPGP。
openpgp-radio-key-not-usable = 由于缺少私钥，无法将此密钥用作个人密钥！
openpgp-radio-key-not-accepted = 若要使用此密钥，您须先将其设为个人密钥！
openpgp-radio-key-not-found = 找不到此密钥！若您想要使用此密钥，请先导入至 { -brand-short-name }。
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = 到期于：{ $date }
openpgp-key-expires-image =
    .tooltiptext = 密钥将在 6 个月内到期
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = 过期于：{ $date }
openpgp-key-expired-image =
    .tooltiptext = 密钥已过期
openpgp-key-expires-within-6-months-icon =
    .title = 密钥将在 6 个月内到期
openpgp-key-has-expired-icon =
    .title = 密钥已过期
openpgp-key-expand-section =
    .tooltiptext = 更多信息
openpgp-key-revoke-title = 吊销密钥
openpgp-key-edit-title = 更改 OpenPGP 密钥
openpgp-key-edit-date-title = 延长有效期
openpgp-manager-description = 使用 OpenPGP 密钥管理器可以查看往来通信者的公钥，以及所有上方未列出的密钥。
openpgp-manager-button =
    .label = OpenPGP 密钥管理器
    .accesskey = K
openpgp-key-remove-external =
    .label = 移除外部密钥 ID
    .accesskey = E
key-external-label = 外部 GnuPG 密钥
# Strings in keyDetailsDlg.xhtml
key-type-public = 公钥
key-type-primary = 主密钥
key-type-subkey = 子密钥
key-type-pair = 密钥对（私钥与公钥）
key-expiry-never = 永不
key-usage-encrypt = 加密
key-usage-sign = 签名
key-usage-certify = 认证
key-usage-authentication = 验证
key-does-not-expire = 密钥永不过期
key-expired-date = 密钥已于 { $keyExpiry } 过期
key-expired-simple = 密钥已过期
key-revoked-simple = 密钥已被吊销
key-do-you-accept = 您要接受将此密钥用于验证数字签名与加密消息吗？
key-accept-warning = 请先使用电子邮件之外的通信渠道验证对方的密钥指纹，避免接受恶意密钥。
# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = 您的个人密钥有问题，无法发送消息。{ $problem }
cannot-encrypt-because-missing = 由于下列收件人的密钥有问题，无法用端到端加密的方式发送此消息：{ $problem }
window-locked = 邮件撰写窗口已锁定；取消发送
# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = 加密消息部分
mime-decrypt-encrypted-part-concealed-data = 这是加密过的消息部分。请点击附件用单独视窗打开。
# Strings in keyserver.jsm
keyserver-error-aborted = 已中止
keyserver-error-unknown = 发生未知错误
keyserver-error-server-error = 密钥服务器报告错误。
keyserver-error-import-error = 无法导入下载的密钥。
keyserver-error-unavailable = 密钥服务器不可用。
keyserver-error-security-error = 密钥服务器不支持加密访问。
keyserver-error-certificate-error = 密钥服务器的证书无效。
keyserver-error-unsupported = 不支持此密钥服务器。
# Strings in mimeWkdHandler.jsm
wkd-message-body-req = 您的邮件服务商处理了您要将公钥上传到网上 OpenPGP 密钥库的请求。请确认公钥是否已经完成发布。
wkd-message-body-process = 这是一封关于自动将公钥上传到网上 OpenPGP 密钥库的邮件。您暂时不必进行任何操作。
# Strings in persistentCrypto.jsm
converter-decrypt-body-failed = 无法解密主题为 { $subject } 的消息。您想要使用不同密语再试一次，或是跳过此消息？
# Strings in gpg.jsm
unknown-signing-alg = 未知的签名算法（ID：{ $id }）
unknown-hash-alg = 未知的加密哈希值（ID：{ $id }）
# Strings in keyUsability.jsm
expiry-key-expires-soon = 您的密钥 { $desc } 将于 { $days } 天内到期。建议您重新生成密钥，并配置妥当对应账户来使用。
expiry-keys-expire-soon = 您的下列密钥将于 { $days } 天内到期：{ $desc }。建议您重新生成密钥，并配置妥当对应账户来使用。
expiry-key-missing-owner-trust = 您对密钥 { $desc } 缺少信任设置。建议您到密钥属性中，将“密钥信任度”设为“完全信任”。
expiry-keys-missing-owner-trust = 下列密钥少信任设置：{ $desc }。建议您到密钥属性中，将“密钥信任度”设为“完全信任”。
expiry-open-key-manager = 打开 OpenPGP 密钥管理器
expiry-open-key-properties = 打开密钥属性
# Strings filters.jsm
filter-folder-required = 必须选择一个目标文件夹。
filter-decrypt-move-warn-experimental = 警告：过滤器操作“永久解密”可能会损坏消息。我们强烈建议您先行使用“创建解密副本”过滤器，仔细测试结果，确认无误后再使用此过滤器。
filter-term-pgpencrypted-label = OpenPGP 加密
filter-key-required = 必须选择一个接收人密钥。
filter-key-not-found = 找不到“{ $desc }”的加密密钥。
filter-warn-key-not-secret = 警告：过滤器操作“使用密钥加密”会替换收件人。若您没有“{ $desc }”的私钥，将无法阅读邮件。
# Strings filtersWrapper.jsm
filter-decrypt-move-label = 永久解密（OpenPGP）
filter-decrypt-copy-label = 创建解密的副本（OpenPGP）
filter-encrypt-label = 使用密钥加密（OpenPGP）
# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = 成功！已导入密钥
import-info-bits = 位
import-info-created = 创建于
import-info-fpr = 指纹
import-info-details = 查看详细信息并管理密钥接受度
import-info-no-keys = 未导入密钥。
# Strings in enigmailKeyManager.js
import-from-clip = 您想要从剪贴板导入一些密钥吗？
import-from-url = 请从下列 URL 下载公钥：
copy-to-clipbrd-failed = 无法将选中的密钥复制到剪贴板。
copy-to-clipbrd-ok = 已将密钥复制到剪贴板
delete-secret-key = 警告：即将删除私钥！删除私钥后，将无法再解密使用该密钥加密的消息，也无法吊销该密钥。您确定要删除“{ $userId }”的公钥与私钥吗？
delete-mix = 警告：即将删除私钥！删除私钥后，将无法再解密使用该密钥加密的消息。您确定要删除“{ $userId }”的公钥与私钥吗？
delete-pub-key = 您确定要删除公钥“{ $userId }”吗？
delete-selected-pub-key = 您确定要删除公钥吗？
refresh-all-question = 您没有选择任何密钥。要刷新所有密钥吗？
key-man-button-export-sec-key = 导出私钥(&S)
key-man-button-export-pub-key = 只导出公钥(&P)
key-man-button-refresh-all = 刷新所有密钥(&R)
key-man-loading-keys = 正在加载密钥，请稍候...
ascii-armor-file = ASCII 格式文件（*.asc）
no-key-selected = 您需至少选择一个密钥，才能执行所选操作
export-to-file = 将公钥导出为文件
export-keypair-to-file = 将私钥和公钥导出为文件
export-secret-key = 您要将私钥也包含在保存的 OpenPGP 密钥文件中吗？
save-keys-ok = 成功保存密钥
save-keys-failed = 密钥保存失败
default-pub-key-filename = 导出的公钥
default-pub-sec-key-filename = 私钥备份
refresh-key-warn = 警告：视密钥数量与网络速度而定，刷新所有密钥耗时可能非常漫长！
preview-failed = 无法读取公钥文件。
general-error = 错误：{ $reason }
dlg-button-delete = 删除(&D)

## Account settings export output

openpgp-export-public-success = <b>成功导出公钥！</b>
openpgp-export-public-fail = <b>无法导出选中的公钥！</b>
openpgp-export-secret-success = <b>成功导出私钥！</b>
openpgp-export-secret-fail = <b>无法导出选中的私钥！</b>
# Strings in keyObj.jsm
key-ring-pub-key-revoked = 密钥 { $userId }（密钥 ID { $keyId }）已吊销。
key-ring-pub-key-expired = 密钥 { $userId }（密钥 ID { $keyId }）已过期。
key-ring-no-secret-key = 您的密钥环中似乎没有 { $userId }（密钥 ID { $keyId }）的私钥。无法使用该密钥进行签名。
key-ring-pub-key-not-for-signing = 密钥 { $userId }（密钥 ID { $keyId }）无法用于签名。
key-ring-pub-key-not-for-encryption = 密钥 { $userId }（密钥 ID { $keyId }）无法用于加密。
key-ring-sign-sub-keys-revoked = 密钥 { $userId }（密钥 ID { $keyId }）的所有签名用子密钥已被吊销。
key-ring-sign-sub-keys-expired = 密钥 { $userId }（密钥 ID { $keyId }）的所有签名用子密钥已过期。
key-ring-enc-sub-keys-revoked = 密钥 { $userId }（密钥 ID { $keyId }）的所有加密用子密钥已被吊销。
key-ring-enc-sub-keys-expired = 密钥 { $userId }（密钥 ID { $keyId }）的所有加密用子密钥已过期。
# Strings in gnupg-keylist.jsm
keyring-photo = 照片
user-att-photo = 用户属性（JPEG 图像）
# Strings in key.jsm
already-revoked = 该密钥已被吊销。
#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question = 即将吊销密钥“{ $identity }”。吊销后，将无法再使用此密钥进行签名。且在公布后，其他人也将无法再使用该密钥进行加密。您还是可以此密钥来解密旧消息。确定要继续吗？
#   $keyId (String) - the id of the key being revoked
revoke-key-not-present = 您没有与此吊销证书匹配的密钥（0x{ $keyId }）！若您弄丢密钥，则须重新导入密钥（例如从密钥服务器）才能导入吊销证书！
#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = 密钥  0x{ $keyId } 已被吊销。
key-man-button-revoke-key = 吊销密钥(&R)
openpgp-key-revoke-success = 已成功吊销密钥。
after-revoke-info = 此密钥已被吊销。请使用电子邮件再次分享公钥，或是上传到密钥服务器，让其他人知道您已吊销此密钥。当其他人使用的软件知道密钥已吊销后，就不会再使用您的旧密钥。若您在相同邮箱使用新的密钥，并将新的公钥附在您发送的邮件中，那么旧密钥已被吊销的信息也会自动包含在内。
# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = 导入(&I)
delete-key-title = 删除 OpenPGP 密钥
delete-external-key-title = 移除外部 GnuPG 密钥
delete-external-key-description = 您要移除该 GnuPG 密钥 ID 吗？
key-in-use-title = OpenPGP 密钥正在使用中
delete-key-in-use-description = 无法继续！您选择要删除的密钥目前正由此身份使用中。请选择其他密钥或取消选择并重试。
revoke-key-in-use-description = 无法继续！您选择要吊销的密钥目前正由此身份使用中。请选择其他密钥或取消选择并重试。
# Strings used in errorHandling.jsm
key-error-key-spec-not-found = 电子邮件地址“{ $keySpec }”无法与您密钥环上的密钥匹配。
key-error-key-id-not-found = 未在您的密钥环找到配置的密钥 ID “{ $keySpec }”。
key-error-not-accepted-as-personal = 您并未确认 ID 为“{ $keySpec }”的密钥是您的个人密钥。
# Strings used in enigmailKeyManager.js & windows.jsm
need-online = 您选择的功能无法离线使用。请联网后再试。
# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = 找不到任何匹配搜索条件的密钥。
# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = 错误 - 密钥提取命令运行失败
# Strings used in keyRing.jsm
fail-cancel = 错误 - 用户取消接收密钥
not-first-block = 错误 - 第一个 OpenPGP 块不是公钥块
import-key-confirm = 要导入消息中嵌入的公钥吗？
fail-key-import = 错误 - 密钥导入失败
file-write-failed = 写入到文件 { $output } 失败
no-pgp-block = 错误 - 找不到有效的 armored 格式 OpenPGP 数据块
confirm-permissive-import = 导入失败。您试图导入的密钥可能已损坏或使用了未知的属性。您想要尝试导入其中正确的部分吗？可能会导入不完整且无法使用的密钥。
# Strings used in trust.jsm
key-valid-unknown = 未知
key-valid-invalid = 无效
key-valid-disabled = 已禁用
key-valid-revoked = 已吊销
key-valid-expired = 已过期
key-trust-untrusted = 不受信任
key-trust-marginal = 间接信任
key-trust-full = 可信
key-trust-ultimate = 完全信任
key-trust-group = （群组）
# Strings used in commonWorkflows.js
import-key-file = 导入 OpenPGP 密钥文件
import-rev-file = 导入 OpenPGP 吊销文件
gnupg-file = GnuPG 文件
import-keys-failed = 导入密钥失败
passphrase-prompt = 请输入可解密下列密钥的密语：{ $key }
file-to-big-to-import = 文件太大。请不要一次导入大量密钥。
# Strings used in enigmailKeygen.js
save-revoke-cert-as = 创建并保存吊销证书
revoke-cert-ok = 已成功创建吊销证书。您可以用它来吊销公钥（以防弄丢私钥）。
revoke-cert-failed = 无法创建吊销证书。
gen-going = 已在生成密钥中！
keygen-missing-user-name = 尚未指定选择的账户/身份名称。请在账户设置中的“你的名字”栏输入姓名。
expiry-too-short = 您的密钥有效期不能少于 1 天。
expiry-too-long = 您不能创建有效期超过 100 年的密钥。
key-confirm = 确定要生成“{ $id }”的公钥与私钥吗？
key-man-button-generate-key = 生成密钥(&G)
key-abort = 要中止生成密钥吗？
key-man-button-generate-key-abort = 中止生成密钥(&A)
key-man-button-generate-key-continue = 继续生成密钥(&C)

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = 错误 - 解密失败
fix-broken-exchange-msg-failed = 消息修复失败。
attachment-no-match-from-signature = 无法将签名文件“{ $attachment }”与附件匹配
attachment-no-match-to-signature = 无法将附件“{ $attachment }”与签名文件匹配
signature-verified-ok = 附件 { $attachment } 的签名验证成功
signature-verify-failed = 附件 { $attachment } 的签名验证失败
decrypt-ok-no-sig = 警告：解密成功，但无法正确验证签名
msg-ovl-button-cont-anyway = 仍然继续(&C)
enig-content-note = *此消息的附件尚未签名或加密*
# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = 发送邮件(&S)
msg-compose-details-button-label = 详细信息…
msg-compose-details-button-access-key = D
send-aborted = 发送操作已中止。
key-not-trusted = 对密钥“{ $key }”的信任度不足
key-not-found = 找不到密钥“{ $key }”
key-revoked = 密钥“{ $key }”已吊销
key-expired = 密钥“{ $key }”已过期
msg-compose-internal-error = 发生内部错误。
keys-to-export = 选择要插入的 OpenPGP 密钥
msg-compose-partially-encrypted-inlinePGP = 您回复的消息当中包含了未加密与有加密的部分。若发件人原本就无法解密消息中的某些部分，可能会造成该部分当中的机密信息被泄露出去。请考虑将回复给发件人的消息中，所有的引用文本删除。
msg-compose-cannot-save-draft = 保存草稿时出错
msg-compose-partially-encrypted-short = 当心泄露敏感信息 - 这封邮件仅有部分加密。
quoted-printable-warn = 您选择使用“quoted-printable”编码方式来发送邮件，可能会造成消息的解密或验证不正确。您要关闭使用“quoted-printable”编码方式吗？
minimal-line-wrapping = 您将换行长度设为 { $width } 个字符。若需正确进行加密或签名，此长度须至少为 68。您现在要将换行长度改为 68 个字符吗？
sending-hidden-rcpt = 发送加密邮件时不能使用密送收件人。若要发送此加密邮件，请删除密送收件人，或将其移到“抄送”栏。
sending-news = 加密发送操作中断。因为有新闻组收件人，无法加密此消息。请解除加密再重新发送。
send-to-news-warning = 警告：您即将发送加密的邮件到新闻组中。不鼓励这样做，因为只有在群组中的所有成员都能够解密消息时才能阅读（也就是说，必须使用群组中的所有成员的密钥加密消息）。请只在您确切知道自己在做什么时才发送。确定要继续吗？
save-attachment-header = 保存解密附件
no-temp-dir = 找不到可以写入的临时文件夹，请设置 TEMP 环境变量
possibly-pgp-mime = 可能是 PGP/MIME 加密或签名过的消息，请使用“解密 / 验证”功能来验证
cannot-send-sig-because-no-own-key = 由于您还没有配置<{ $key }>的端到端加密，无法数字签名此消息
cannot-send-enc-because-no-own-key = 由于您还没有配置<{ $key }>的端到端加密，无法发送此消息
# Strings used in decryption.jsm
do-import-multiple = 要导入下列密钥吗？{ $key }
do-import-one = 要导入 { $name }（{ $id }）吗？
cant-import = 导入公钥时出错
unverified-reply = 缩进的消息部分（回复引用内容）可能已被修改
key-in-message-body = 在消息内容中发现密钥，请点击“导入密钥”以导入该密钥
sig-mismatch = 错误 - 签名不匹配
invalid-email = 错误 - 电子邮件地址无效
attachment-pgp-key = 您正要打开的附件“{ $name }”似乎是 OpenPGP 密钥文件。请点击“导入”以导入密钥，或点击“查看”以在浏览器窗口中查看文件内容。
dlg-button-view = 查看(&V)
# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = 解密消息（从可能是由旧版 Exchange 服务器损坏的 PGP 邮件格式恢复，结果可能不易阅读）
# Strings used in encryption.jsm
not-required = 错误 - 未要求加密
# Strings used in windows.jsm
no-photo-available = 没有可用的照片
error-photo-path-not-readable = 照片路径“{ $photo }”无法读取
debug-log-title = OpenPGP 调试日志
# Strings used in dialog.jsm
repeat-prefix = 此警报将重复 { $count }
repeat-suffix-singular = 次。
repeat-suffix-plural = 次。
no-repeat = 将不再显示该警报。
dlg-keep-setting = 记住我的答案，不要再问我
dlg-button-ok = 确定(&O)
dlg-button-close = 关闭(&C)
dlg-button-cancel = 取消(&C)
dlg-no-prompt = 不再显示此对话框。
enig-prompt = OpenPGP 提示
enig-confirm = OpenPGP 确认
enig-alert = OpenPGP 警报
enig-info = OpenPGP 信息
# Strings used in persistentCrypto.jsm
dlg-button-retry = 重试(&R)
dlg-button-skip = 跳过(&S)
# Strings used in enigmailCommon.js
enig-error = OpenPGP 错误
# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = OpenPGP 警报
