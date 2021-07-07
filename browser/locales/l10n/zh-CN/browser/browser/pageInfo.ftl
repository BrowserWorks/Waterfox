# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;
copy =
    .key = C
menu-copy =
    .label = 复制
    .accesskey = C
select-all =
    .key = A
menu-select-all =
    .label = 全选
    .accesskey = A
close-dialog =
    .key = w
general-tab =
    .label = 常规
    .accesskey = G
general-title =
    .value = 标题：
general-url =
    .value = 网址：
general-type =
    .value = 类型：
general-mode =
    .value = 渲染模式：
general-size =
    .value = 大小：
general-referrer =
    .value = 来源网址：
general-modified =
    .value = 修改时间：
general-encoding =
    .value = 文字编码：
general-meta-name =
    .label = 名称
general-meta-content =
    .label = 内容
media-tab =
    .label = 媒体
    .accesskey = M
media-location =
    .value = 位置：
media-text =
    .value = 候补文本：
media-alt-header =
    .label = 备用文字
media-address =
    .label = 网址
media-type =
    .label = 类型
media-size =
    .label = 大小
media-count =
    .label = 数量
media-dimension =
    .value = 尺寸：
media-long-desc =
    .value = 详细描述：
media-save-as =
    .label = 另存为…
    .accesskey = A
media-save-image-as =
    .label = 另存为…
    .accesskey = e
perm-tab =
    .label = 权限
    .accesskey = P
permissions-for =
    .value = 权限，对于:
security-tab =
    .label = 安全
    .accesskey = S
security-view =
    .label = 查看证书
    .accesskey = V
security-view-unknown = 未知
    .value = 未知
security-view-identity =
    .value = 网站身份
security-view-identity-owner =
    .value = 所有者：
security-view-identity-domain =
    .value = 网站：
security-view-identity-verifier =
    .value = 验证者：
security-view-identity-validity =
    .value = 过期时间：
security-view-privacy =
    .value = 隐私和历史记录
security-view-privacy-history-value = 我之前访问过该网站吗？
security-view-privacy-sitedata-value = 此网站在我的计算机上存储了信息吗？
security-view-privacy-clearsitedata =
    .label = 清除 Cookie 和网站数据
    .accesskey = C
security-view-privacy-passwords-value = 我保存过该网站的任何密码吗？
security-view-privacy-viewpasswords =
    .label = 查看已保存的密码
    .accesskey = w
security-view-technical =
    .value = 技术细节
help-button =
    .label = 帮助

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = 有，Cookie 和 { $value } { $unit } 网站数据
security-site-data-only = 有，{ $value } { $unit } 网站数据
security-site-data-cookies-only = 有，Cookie
security-site-data-no = 无
image-size-unknown = 未知
page-info-not-specified =
    .value = 未指明
not-set-alternative-text = 未指明
not-set-date = 未指明
media-img = 图像
media-bg-img = 背景
media-border-img = 边框
media-list-img = 项目
media-cursor = 光标
media-object = 对象
media-embed = 嵌入
media-link = 图标
media-input = 输入
media-video = 视频
media-audio = 音频
saved-passwords-yes = 是
saved-passwords-no = 否
no-page-title =
    .value = 无标题页
general-quirks-mode =
    .value = 怪异模式
general-strict-mode =
    .value = 标准规范模式
page-info-security-no-owner =
    .value = 此网站未提供所有者信息。
media-select-folder = 请选择保存图像的文件夹
media-unknown-not-cached =
    .value = 未知（未缓存）
permissions-use-default =
    .label = 使用默认设置
security-no-visits = 否
# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] 元信息（1 个标签）
           *[other] 元信息（{ $tags } 个标签）
        }
# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] 否
        [one] 是，1 次
       *[other] 是，{ $visits } 次
    }
# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } 字节)
           *[other] { $kb } KB ({ $bytes } 字节)
        }
# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } 图像（动画，{ $frames } 帧）
           *[other] { $type } 图像（动画，{ $frames } 帧）
        }
# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } 图像
# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (缩放至 { $scaledx }px × { $scaledy }px)
# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx }px × { $dimy }px
# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } KB
# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = 拦截来自 { $website } 的图像
    .accesskey = B
# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) — The url of the website pageInfo is getting info for
page-info-page =
    .title = 页面信息 — { $website }
page-info-frame =
    .title = 框架信息 — { $website }
