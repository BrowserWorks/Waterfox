# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

unknowncontenttype-handleinternally =
    .label = 用 { -brand-short-name } 打开
    .accesskey = e

unknowncontenttype-settingschange =
    .value =
        { PLATFORM() ->
            [windows] 请在 { -brand-short-name } 的选项中更改设置。
           *[other] 请在 { -brand-short-name } 的首选项中更改设置。
        }

unknowncontenttype-intro = 您选择了打开：
unknowncontenttype-which-is = 文件类型：
unknowncontenttype-from = 来源：
unknowncontenttype-prompt = 您想要保存此文件吗？
unknowncontenttype-action-question = 您想要 { -brand-short-name } 如何处理此文件？
unknowncontenttype-open-with =
    .label = 打开，通过
    .accesskey = O
unknowncontenttype-other =
    .label = 其他…
unknowncontenttype-choose-handler =
    .label =
        { PLATFORM() ->
            [macos] 选择…
           *[other] 浏览…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] B
        }
unknowncontenttype-save-file =
    .label = 保存文件
    .accesskey = S
unknowncontenttype-remember-choice =
    .label = 以后自动采用相同的动作处理此类文件。
    .accesskey = a
