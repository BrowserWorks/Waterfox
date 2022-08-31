# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = 设备管理器
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = 安全模块和设备

devmgr-header-details =
    .label = 细节

devmgr-header-value =
    .label = 值

devmgr-button-login =
    .label = 登录
    .accesskey = n

devmgr-button-logout =
    .label = 退出
    .accesskey = O

devmgr-button-changepw =
    .label = 修改密码
    .accesskey = P

devmgr-button-load =
    .label = 载入
    .accesskey = L

devmgr-button-unload =
    .label = 卸载
    .accesskey = U

devmgr-button-enable-fips =
    .label = 启用FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = 禁用FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = 载入 PKCS#11 设备驱动程序

load-device-info = 输入您要添加的模块的信息。

load-device-modname =
    .value = 模块名称
    .accesskey = M

load-device-modname-default =
    .value = 新建PKCS#11模块

load-device-filename =
    .value = 模块文件名
    .accesskey = f

load-device-browse =
    .label = 浏览…
    .accesskey = B

## Token Manager

devinfo-status =
    .label = 状态

devinfo-status-disabled =
    .label = 已禁用

devinfo-status-not-present =
    .label = 暂无

devinfo-status-uninitialized =
    .label = 未初始化

devinfo-status-not-logged-in =
    .label = 未登录

devinfo-status-logged-in =
    .label = 已登录

devinfo-status-ready =
    .label = 可以使用

devinfo-desc =
    .label = 描述

devinfo-man-id =
    .label = 制造商

devinfo-hwversion =
    .label = HW版本
devinfo-fwversion =
    .label = FW版本

devinfo-modname =
    .label = 模块

devinfo-modpath =
    .label = 路径

login-failed = 登录失败

devinfo-label =
    .label = 标签

devinfo-serialnum =
    .label = 序列号

fips-nonempty-primary-password-required = FIPS 需要您为各个安全设备设置一个主密码。请在启用 FIPS 模式之前设置主密码。
unable-to-toggle-fips = 无法更换该安全设备的 FIPS 模式。建议您退出并重启本应用程序。
load-pk11-module-file-picker-title = 选择要载入的 PKCS#11 设备驱动程序

# Load Module Dialog
load-module-help-empty-module-name =
    .value = 模块名称不能为空。

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ”Root Certs“已被保留，不能用作模块名称。

add-module-failure = 无法添加模块
del-module-warning = 您确定要删除此安全模块吗？
del-module-error = 无法删除模块
