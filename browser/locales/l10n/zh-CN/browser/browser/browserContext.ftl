# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] 下拉显示历史
           *[other] 右击或下拉显示历史
        }

## Back

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = 转到上一页 ({ $shortcut })
    .aria-label = 后退
    .accesskey = B

# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = 后退
    .accesskey = B

navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }

toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = 转到下一页 ({ $shortcut })
    .aria-label = 前进
    .accesskey = F

# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = 前进
    .accesskey = F

navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }

toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = 重新载入
    .accesskey = R

# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = 重新载入
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = 停止
    .accesskey = S

# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = 停止
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Waterfox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name }
    .tooltiptext = { -fxaccount-brand-name }

## Save Page

main-context-menu-page-save =
    .label = 另存页面为…
    .accesskey = P

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = 为此网页添加书签
    .accesskey = m
    .tooltiptext = 为此页添加书签

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = 添加书签
    .accesskey = m

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = 编辑书签
    .accesskey = m

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = 为此网页添加书签
    .accesskey = m
    .tooltiptext = 为此页添加书签 ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = 编辑此书签
    .accesskey = m
    .tooltiptext = 编辑此书签

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = 编辑此书签
    .accesskey = m
    .tooltiptext = 编辑此书签 ({ $shortcut })

main-context-menu-open-link =
    .label = 打开链接
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = 新建标签页打开链接
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = 新建身份标签页打开链接
    .accesskey = C

main-context-menu-open-link-new-window =
    .label = 新建窗口打开链接
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = 新建隐私窗口打开链接
    .accesskey = P

main-context-menu-bookmark-link =
    .label = 为此链接添加书签
    .accesskey = B

main-context-menu-save-link =
    .label = 从链接另存文件为…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = 保存链接到 { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.


## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = 复制邮件地址
    .accesskey = E

main-context-menu-copy-link-simple =
    .label = 复制链接
    .accesskey = L

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = 播放
    .accesskey = P

main-context-menu-media-pause =
    .label = 暂停
    .accesskey = P

##

main-context-menu-media-mute =
    .label = 静音
    .accesskey = M

main-context-menu-media-unmute =
    .label = 恢复声音
    .accesskey = m

main-context-menu-media-play-speed-2 =
    .label = 速度
    .accesskey = d

main-context-menu-media-play-speed-slow-2 =
    .label = 0.5×

main-context-menu-media-play-speed-normal-2 =
    .label = 1.0×

main-context-menu-media-play-speed-fast-2 =
    .label = 1.25×

main-context-menu-media-play-speed-faster-2 =
    .label = 1.5×

main-context-menu-media-play-speed-fastest-2 =
    .label = 2×

main-context-menu-media-loop =
    .label = 循环
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = 显示控制界面
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = 隐藏控制界面
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = 全屏
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = 退出全屏
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-watch-pip =
    .label = 画中画观看
    .accesskey = u

main-context-menu-image-reload =
    .label = 重新载入图像
    .accesskey = R

main-context-menu-image-view-new-tab =
    .label = 新建标签页打开图像
    .accesskey = I

main-context-menu-video-view-new-tab =
    .label = 新建标签页打开视频
    .accesskey = i

main-context-menu-image-copy =
    .label = 复制图像
    .accesskey = y

main-context-menu-image-copy-link =
    .label = 复制图像链接
    .accesskey = o

main-context-menu-video-copy-link =
    .label = 复制视频链接
    .accesskey = o

main-context-menu-audio-copy-link =
    .label = 复制音频链接
    .accesskey = o

main-context-menu-image-save-as =
    .label = 另存图像为…
    .accesskey = v

main-context-menu-image-email =
    .label = 用邮件发送图片…
    .accesskey = g

main-context-menu-image-set-image-as-background =
    .label = 将图像设为桌面背景…
    .accesskey = S

main-context-menu-image-info =
    .label = 查看图像信息
    .accesskey = f

main-context-menu-image-desc =
    .label = 查看描述
    .accesskey = D

main-context-menu-video-save-as =
    .label = 另存视频为…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = 另存音频为…
    .accesskey = v

main-context-menu-video-take-snapshot =
    .label = 视频截图...
    .accesskey = S

main-context-menu-video-email =
    .label = 用邮件发送视频…
    .accesskey = a

main-context-menu-audio-email =
    .label = 用邮件发送音频…
    .accesskey = a

main-context-menu-plugin-play =
    .label = 激活此插件
    .accesskey = c

main-context-menu-plugin-hide =
    .label = 隐藏此插件
    .accesskey = H

main-context-menu-save-to-pocket =
    .label = 保存页面到 { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = 发送页面到设备
    .accesskey = D

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = 使用存放的登录信息
    .accesskey = o

main-context-menu-use-saved-password =
    .label = 使用存放的密码
    .accesskey = o

##

main-context-menu-suggest-strong-password =
    .label = 建议高强度密码…
    .accesskey = S

main-context-menu-manage-logins2 =
    .label = 管理登录信息
    .accesskey = M

main-context-menu-keyword =
    .label = 为此搜索引擎添加关键词…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = 发送链接到设备
    .accesskey = D

main-context-menu-frame =
    .label = 此框架
    .accesskey = h

main-context-menu-frame-show-this =
    .label = 仅显示此框架
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = 新建标签页打开框架
    .accesskey = T

main-context-menu-frame-open-window =
    .label = 新建窗口打开框架
    .accesskey = W

main-context-menu-frame-reload =
    .label = 重新载入框架
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = 为此框架添加书签
    .accesskey = m

main-context-menu-frame-save-as =
    .label = 另存框架为…
    .accesskey = F

main-context-menu-frame-print =
    .label = 打印框架…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = 查看框架源代码
    .accesskey = V

main-context-menu-frame-view-info =
    .label = 查看框架信息
    .accesskey = I

main-context-menu-print-selection =
    .label = 打印选中内容
    .accesskey = r

main-context-menu-view-selection-source =
    .label = 查看选中部分源代码
    .accesskey = e

main-context-menu-take-screenshot =
    .label = 截图
    .accesskey = T

main-context-menu-take-frame-screenshot =
    .label = 截图
    .accesskey = o

main-context-menu-view-page-source =
    .label = 查看页面源代码
    .accesskey = V

main-context-menu-bidi-switch-text =
    .label = 切换文字方向
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = 切换页面方向
    .accesskey = D

main-context-menu-inspect =
    .label = 检查
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = 检查无障碍环境属性

main-context-menu-eme-learn-more =
    .label = 详细了解数字版权管理（DRM）…
    .accesskey = D

# Variables
#   $containerName (String): The name of the current container
main-context-menu-open-link-in-container-tab =
    .label = 新建 { $containerName } 标签页打开链接
    .accesskey = T
