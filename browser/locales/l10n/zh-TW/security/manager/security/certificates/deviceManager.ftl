# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = 裝置管理員
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = 安全模組與裝置

devmgr-header-details =
    .label = 詳細資訊

devmgr-header-value =
    .label = 值

devmgr-button-login =
    .label = 登入
    .accesskey = n

devmgr-button-logout =
    .label = 登出
    .accesskey = o

devmgr-button-changepw =
    .label = 變更密碼
    .accesskey = P

devmgr-button-load =
    .label = 載入
    .accesskey = L

devmgr-button-unload =
    .label = 卸載
    .accesskey = U

devmgr-button-enable-fips =
    .label = 啟用 FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = 停用 FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = 載入 PKCS#11 裝置驅動程式

load-device-info = 輸入要新增的模組資訊。

load-device-modname =
    .value = 模組名稱
    .accesskey = M

load-device-modname-default =
    .value = 新 PKCS#11 模組

load-device-filename =
    .value = 模組檔案名稱
    .accesskey = f

load-device-browse =
    .label = 瀏覽…
    .accesskey = B

## Token Manager

devinfo-status =
    .label = 狀態

devinfo-status-disabled =
    .label = 不使用

devinfo-status-not-present =
    .label = 不存在

devinfo-status-uninitialized =
    .label = 未初始化

devinfo-status-not-logged-in =
    .label = 未登入

devinfo-status-logged-in =
    .label = 已登入

devinfo-status-ready =
    .label = 使用

devinfo-desc =
    .label = 描述

devinfo-man-id =
    .label = 製造者

devinfo-hwversion =
    .label = 硬體版本
devinfo-fwversion =
    .label = 韌體版本

devinfo-modname =
    .label = 模組

devinfo-modpath =
    .label = 路徑

login-failed = 無法登入

devinfo-label =
    .label = 標籤

devinfo-serialnum =
    .label = 序號

fips-nonempty-password-required = FIPS 模式需要設定主控密碼。請先設定主控密碼。

fips-nonempty-primary-password-required = FIPS 模式需要為每個安全性裝置都設定密碼。請先設定密碼再嘗試開啟 FIPS 模式。
unable-to-toggle-fips = 無法修改安全裝置的 FIPS 模式。建議您重新啟動此應用程式。
load-pk11-module-file-picker-title = 選擇要載入的 PKCS#11 裝置驅動程式

# Load Module Dialog
load-module-help-empty-module-name =
    .value = 模組名稱不能空白。

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = 「Root Certs」已被保留，無法用作模組名稱。

add-module-failure = 無法新增模組
del-module-warning = 您確定要刪除此模組？
del-module-error = 無法刪除模組
