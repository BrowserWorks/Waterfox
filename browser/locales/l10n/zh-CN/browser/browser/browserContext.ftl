# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] 下拉显示历史
           *[other] 右击或下拉显示历史
        }

## Back

main-context-menu-back =
    .tooltiptext = 转到上一页
    .aria-label = 后退
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = 转到下一页
    .aria-label = 前进
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = 重新载入
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = 停止
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = 另存页面为…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = 为此网页添加书签
    .accesskey = m
    .tooltiptext = 为此页添加书签

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

main-context-menu-bookmark-this-link =
    .label = 为此链接添加书签
    .accesskey = L

main-context-menu-save-link =
    .label = 从链接另存文件为…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = 保存链接到 { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = 复制邮件地址
    .accesskey = E

main-context-menu-copy-link =
    .label = 复制链接地址
    .accesskey = a

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

main-context-menu-media-play-speed =
    .label = 播放速度
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = 慢 (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = 正常
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = 快 (1.25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = 很快 (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = 倍速 (2×)
    .accesskey = L

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
main-context-menu-media-pip =
    .label = 画中画
    .accesskey = u

main-context-menu-image-reload =
    .label = 重新载入图像
    .accesskey = R

main-context-menu-image-view =
    .label = 查看图像
    .accesskey = I

main-context-menu-video-view =
    .label = 查看视频
    .accesskey = i

main-context-menu-image-copy =
    .label = 复制图像
    .accesskey = y

main-context-menu-image-copy-location =
    .label = 复制图像地址
    .accesskey = o

main-context-menu-video-copy-location =
    .label = 复制视频地址
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = 复制音频地址
    .accesskey = o

main-context-menu-image-save-as =
    .label = 另存图像为…
    .accesskey = v

main-context-menu-image-email =
    .label = 用邮件发送图片…
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = 设为桌面背景…
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

main-context-menu-video-image-save-as =
    .label = 另存截图为…
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

main-context-menu-view-background-image =
    .label = 查看背景图像
    .accesskey = w

main-context-menu-generate-new-password =
    .label = 使用生成的密码…
    .accesskey = G

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

main-context-menu-view-selection-source =
    .label = 查看选中部分源代码
    .accesskey = e

main-context-menu-view-page-source =
    .label = 查看页面源代码
    .accesskey = V

main-context-menu-view-page-info =
    .label = 查看页面信息
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = 切换文字方向
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = 切换页面方向
    .accesskey = D

main-context-menu-inspect-element =
    .label = 检查元素
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = 检查无障碍环境属性

main-context-menu-eme-learn-more =
    .label = 详细了解数字版权管理（DRM）…
    .accesskey = D

