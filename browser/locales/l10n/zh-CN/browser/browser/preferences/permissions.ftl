# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

permissions-window =
    .title = 例外
    .style = width: 45em
permissions-close-key =
    .key = w
permissions-address = 网站地址
    .accesskey = d
permissions-block =
    .label = 阻止
    .accesskey = B
permissions-session =
    .label = 在这次浏览期间允许
    .accesskey = S
permissions-allow =
    .label = 允许
    .accesskey = A
permissions-button-off =
    .label = 关闭
    .accesskey = O
permissions-button-off-temporarily =
    .label = 暂时关闭
    .accesskey = T
permissions-site-name =
    .label = 网站
permissions-status =
    .label = 状态
permissions-remove =
    .label = 移除网站
    .accesskey = R
permissions-remove-all =
    .label = 移除全部网站
    .accesskey = e
permissions-button-cancel =
    .label = 取消
    .accesskey = C
permissions-button-ok =
    .label = 保存更改
    .accesskey = S
permission-dialog =
    .buttonlabelaccept = 保存更改
    .buttonaccesskeyaccept = S
permissions-autoplay-menu = 所有网站的默认值：
permissions-searchbox =
    .placeholder = 搜索网站
permissions-capabilities-autoplay-allow =
    .label = 允许音频和视频
permissions-capabilities-autoplay-block =
    .label = 阻止音频
permissions-capabilities-autoplay-blockall =
    .label = 阻止音频和视频
permissions-capabilities-allow =
    .label = 允许
permissions-capabilities-block =
    .label = 阻止
permissions-capabilities-prompt =
    .label = 每次都问我
permissions-capabilities-listitem-allow =
    .value = 允许
permissions-capabilities-listitem-block =
    .value = 阻止
permissions-capabilities-listitem-allow-session =
    .value = 在这次浏览期间允许
permissions-capabilities-listitem-off =
    .value = 关闭
permissions-capabilities-listitem-off-temporarily =
    .value = 暂时关闭

## Invalid Hostname Dialog

permissions-invalid-uri-title = 输入了非法的主机名
permissions-invalid-uri-label = 请输入合法的主机名

## Exceptions - Tracking Protection

permissions-exceptions-etp-window =
    .title = 例外 - 增强型跟踪保护
    .style = { permissions-window.style }
permissions-exceptions-etp-desc = 你已关闭对下列网站的保护。

## Exceptions - Cookies

permissions-exceptions-cookie-window =
    .title = 例外 - Cookie 和网站数据
    .style = { permissions-window.style }
permissions-exceptions-cookie-desc = 您可以指定一律允许或不允许哪些网站使用 Cookie 和网站数据。请输入所要指定的完整网址，然后点击“阻止”、“在这次浏览期间允许”或“允许”。

## Exceptions - HTTPS-Only Mode

permissions-exceptions-https-only-window =
    .title = 例外 - HTTPS-Only 模式
    .style = { permissions-window.style }
permissions-exceptions-https-only-desc = 您可以关闭特定网站的 HTTPS-Only 模式。{ -brand-short-name } 将不再尝试将这些网站的连接升级为安全的 HTTPS。“例外”不会应用至隐私窗口。

## Exceptions - Pop-ups

permissions-exceptions-popup-window =
    .title = 有特殊权限的网站 - 弹出式窗口
    .style = { permissions-window.style }
permissions-exceptions-popup-desc = 您可以指定哪些网站可以打开弹出式窗口。请输入所要指定的完整网址，然后点击“允许”。

## Exceptions - Saved Logins

permissions-exceptions-saved-logins-window =
    .title = 例外 - 已保存的登录信息
    .style = { permissions-window.style }
permissions-exceptions-saved-logins-desc = 下列网站的登录信息将不被保存

## Exceptions - Add-ons

permissions-exceptions-addons-window =
    .title = 有特殊权限的网站 - 附加组件安装
    .style = { permissions-window.style }
permissions-exceptions-addons-desc = 您可以指定哪些网站可以安装附加组件。请输入所要指定的完整网址，然后点击“允许”。

## Site Permissions - Autoplay

permissions-site-autoplay-window =
    .title = 设置 - 自动播放
    .style = { permissions-window.style }
permissions-site-autoplay-desc = 您可以在此处管理不遵从默认自动播放设置的网站。

## Site Permissions - Notifications

permissions-site-notification-window =
    .title = 设置 - 通知权限
    .style = { permissions-window.style }
permissions-site-notification-desc = 下列网站曾请求向您发送通知。您可选择允许哪些网站发送通知，还可禁止新的发送通知请求。
permissions-site-notification-disable-label =
    .label = 禁止新的发送通知请求
permissions-site-notification-disable-desc = 所有列表外的网站将无法请求获得发送通知的权限。禁止此权限可能会影响某些网站的功能。

## Site Permissions - Location

permissions-site-location-window =
    .title = 设置 - 位置权限
    .style = { permissions-window.style }
permissions-site-location-desc = 下列网站曾请求获知您的位置。您可选择允许哪些网站获知您的位置，还可禁止新的获取位置请求。
permissions-site-location-disable-label =
    .label = 禁止新的获取位置请求
permissions-site-location-disable-desc = 所有列表外的网站将无法请求获知您的位置。禁止此权限可能会影响某些网站的功能。

## Site Permissions - Virtual Reality

permissions-site-xr-window =
    .title = 设置 - 虚拟现实权限
    .style = { permissions-window.style }
permissions-site-xr-desc = 下列网站曾请求使用您的虚拟现实设备。您可选择允许哪些网站使用您的虚拟现实设备，也可禁止提出对虚拟现实设备的权限请求。
permissions-site-xr-disable-label =
    .label = 禁止网站提出虚拟现实设备使用请求
permissions-site-xr-disable-desc = 将阻止上述之外的网站请求使用您的虚拟现实设备。不授予虚拟现实设备权限可能会影响某些网站的功能。

## Site Permissions - Camera

permissions-site-camera-window =
    .title = 设置 - 摄像头权限
    .style = { permissions-window.style }
permissions-site-camera-desc = 下列网站曾请求操控您的摄像头。您可选择允许哪些网站操控您的摄像头，还可禁止新的操控摄像头请求。
permissions-site-camera-disable-label =
    .label = 禁止新的操控摄像头请求
permissions-site-camera-disable-desc = 所有列表外的网站将无法请求操控您的摄像头。禁止此权限可能会影响某些网站的功能。

## Site Permissions - Microphone

permissions-site-microphone-window =
    .title = 设置 - 麦克风权限
    .style = { permissions-window.style }
permissions-site-microphone-desc = 下列网站曾请求操控您的麦克风。您可选择允许哪些网站操控您的麦克风，还可禁止新的操控麦克风请求。
permissions-site-microphone-disable-label =
    .label = 禁止新的操控麦克风请求
permissions-site-microphone-disable-desc = 所有列表外的网站将无法请求操控您的麦克风。禁止此权限可能会影响某些网站的功能。
