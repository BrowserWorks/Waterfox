# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = 创建配置文件向导
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] 介绍
       *[other] 欢迎使用 { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } 把您的偏好设置等各种数据保存在您的个人配置文件中。

profile-creation-explanation-2 = 如果您与他人共用一个 { -brand-short-name } 程序，您可以为不同用户创建相互独立的配置文件，让浏览数据各自分离。

profile-creation-explanation-3 = 如果只有您一人使用这份 { -brand-short-name } 副本，您需要至少一份配置文件。如果您想将不同用途或环境下的数据分离（如工作与私人事务），也可以创建多份配置文件。

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] 要开始创建配置文件，请单击“继续”。
       *[other] 要开始创建配置文件，请单击“下一步”。
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] 总结
       *[other] 正在完成 { create-profile-window.title }
    }

profile-creation-intro = 您需要为各个配置文件取不同的名称。您可以用这里提供的名称，也可以自行指定。

profile-prompt = 请输入新的配置文件名称:
    .accesskey = E

profile-default-name =
    .value = 默认用户

profile-directory-explanation = 您的用户设置、首选项以及其他相关的用户数据将被保存至：

create-profile-choose-folder =
    .label = 选择文件夹…
    .accesskey = C

create-profile-use-default =
    .label = 使用默认文件夹
    .accesskey = U
