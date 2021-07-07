# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = { -brand-short-name } 排障模式
    .style = width: 37em;
troubleshoot-mode-description = 使用 { -brand-short-name } 的排障模式来诊断问题。您的附加组件和自定义设置将被暂时禁用。
troubleshoot-mode-description2 = 您可以将这些更改部分或全部保存:
troubleshoot-mode-disable-addons =
    .label = 禁用全部附加组件
    .accesskey = D
troubleshoot-mode-reset-toolbars =
    .label = 重置工具栏以及控件
    .accesskey = R
troubleshoot-mode-change-and-restart =
    .label = 保存更改并重启客户端
    .accesskey = M
troubleshoot-mode-continue =
    .label = 以排障模式继续
    .accesskey = C
troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] 退出
           *[other] 退出
        }
    .accesskey =
        { PLATFORM() ->
            [windows] x
           *[other] Q
        }
