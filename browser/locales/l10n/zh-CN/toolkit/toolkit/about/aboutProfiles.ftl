# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = 关于配置文件
profiles-subtitle = 此页面有助于您管理您的配置文件。每个配置文件都是一个独立的空间，其中存放着各自的历史记录、书签、设置及附加组件。
profiles-create = 创建新配置文件
profiles-restart-title = 重启浏览器
profiles-restart-in-safe-mode = 重启并禁用附加组件…
profiles-restart-normal = 正常重启…
profiles-conflict = 有另一份 { -brand-product-name } 对配置文件作了更改。您必须重新启动 { -brand-short-name } 才能再作变更。
profiles-flush-fail-title = 更改未保存
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = 发生意外错误，无法保存更改。
profiles-flush-restart-button = 重启 { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = 配置文件：{ $name }
profiles-is-default = 默认配置文件
profiles-rootdir = 根目录

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = 本地目录
profiles-current-profile = 正在使用此配置文件，因而不能删除。
profiles-in-use-profile = 此配置文件正在被其他应用程序使用，因此无法删除。

profiles-rename = 重命名
profiles-remove = 移除
profiles-set-as-default = 设为默认配置文件
profiles-launch-profile = 在新的浏览器实例中启动配置文件

profiles-cannot-set-as-default-title = 无法设为默认
profiles-cannot-set-as-default-message = 无法更改 { -brand-short-name } 的默认配置文件。

profiles-yes = 是
profiles-no = 否

profiles-rename-profile-title = 重命名配置文件
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = 重命名配置文件“{ $name }”

profiles-invalid-profile-name-title = 无效的配置文件名
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = 不能使用配置文件名“{ $name }”。

profiles-delete-profile-title = 删除配置文件
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    删除配置文件时可以只从可用配置文件列表中将这个配置除去，此操作无法撤销。
    您也可选择将这个配置的数据文件一并彻底删除，包括您的设置、证书和其他个人文件等。这将删除“{ $dir }"文件夹，且无法撤销。
    您想彻底删除此配置文件吗？
profiles-delete-files = 删除文件
profiles-dont-delete-files = 只从列表中除去

profiles-delete-profile-failed-title = 错误
profiles-delete-profile-failed-message = 尝试删除此配置文件时发生错误。


profiles-opendir =
    { PLATFORM() ->
        [macos] 在访达中显示
        [windows] 打开文件夹
       *[other] 打开目录
    }
