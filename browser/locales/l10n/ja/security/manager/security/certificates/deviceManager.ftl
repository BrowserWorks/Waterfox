# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = デバイスマネージャー
    .style = width: 67em; height: 32em;
devmgr-devlist =
    .label = セキュリティモジュールとデバイス
devmgr-header-details =
    .label = 詳細
devmgr-header-value =
    .label = 値
devmgr-button-login =
    .label = ログイン
    .accesskey = n
devmgr-button-logout =
    .label = ログアウト
    .accesskey = O
devmgr-button-changepw =
    .label = パスワードを変更...
    .accesskey = P
devmgr-button-load =
    .label = 追加...
    .accesskey = L
devmgr-button-unload =
    .label = 削除
    .accesskey = U
devmgr-button-enable-fips =
    .label = FIPS を有効にする
    .accesskey = F
devmgr-button-disable-fips =
    .label = FIPS を無効にする
    .accesskey = F

## Strings used for load device

load-device =
    .title = PKCS #11 デバイスドライバーの読み込み
load-device-info = 追加するモジュール情報を入力してください。
load-device-modname =
    .value = モジュール名
    .accesskey = M
load-device-modname-default =
    .value = New PKCS #11 Module
load-device-filename =
    .value = ファイルパス
    .accesskey = f
load-device-browse =
    .label = 参照...
    .accesskey = B

## Token Manager

devinfo-status =
    .label = 状態
devinfo-status-disabled =
    .label = 無効
devinfo-status-not-present =
    .label = 存在しない
devinfo-status-uninitialized =
    .label = 未初期化
devinfo-status-not-logged-in =
    .label = 未ログイン
devinfo-status-logged-in =
    .label = ログイン済み
devinfo-status-ready =
    .label = 使用可能
devinfo-desc =
    .label = 詳細説明
devinfo-man-id =
    .label = 製造元
devinfo-hwversion =
    .label = ハードウェアバージョン
devinfo-fwversion =
    .label = ファームウェアバージョン
devinfo-modname =
    .label = モジュール
devinfo-modpath =
    .label = パス
login-failed = ログインに失敗しました
devinfo-label =
    .label = ラベル
devinfo-serialnum =
    .label = シリアル番号
fips-nonempty-password-required = FIPS モードではすべてのセキュリティデバイスにマスターパスワードが設定されている必要があります。FIPS モードを有効にする前に、パスワードを設定してください。

# (^m^) en-US: "Primary Password"
fips-nonempty-primary-password-required = FIPS モードではすべてのセキュリティデバイスにマスターパスワードが設定されている必要があります。FIPS モードを有効にする前にパスワードを設定してください。
unable-to-toggle-fips = セキュリティデバイスの FIPS モードを変更できません。このアプリケーションを終了し、再起動してください。
load-pk11-module-file-picker-title = 読み込む PKCS#11 デバイスドライバーを選択してください
# Load Module Dialog
load-module-help-empty-module-name =
    .value = モジュール名が無いため読み込めません。
# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs’ は予約されているためモジュール名として使用できません。
add-module-failure = モジュールを追加できません
del-module-warning = このセキュリティモジュールを削除してもよろしいですか？
del-module-error = モジュールを削除できません
