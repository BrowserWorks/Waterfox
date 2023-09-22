# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

permissions-window2 =
    .title = 例外サイト
    .style = min-width: 40em
permissions-close-key =
    .key = w
permissions-address = ウェブサイトのアドレス
    .accesskey = d
permissions-block =
    .label = 不許可
    .accesskey = B
permissions-disable-etp =
    .label = 例外を追加
    .accesskey = E
permissions-session =
    .label = 現在のセッションのみ
    .accesskey = S
permissions-allow =
    .label = 許可
    .accesskey = A
permissions-button-off =
    .label = オフにする
    .accesskey = O
permissions-button-off-temporarily =
    .label = 一時的にオフにする
    .accesskey = T
permissions-site-name =
    .label = ウェブサイト
permissions-status =
    .label = 現在の設定
permissions-remove =
    .label = ウェブサイトを削除
    .accesskey = R
permissions-remove-all =
    .label = すべてのウェブサイトを削除
    .accesskey = e
permission-dialog =
    .buttonlabelaccept = 変更を保存
    .buttonaccesskeyaccept = S
permissions-autoplay-menu = すべてのウェブサイトの既定値:
permissions-searchbox =
    .placeholder = ウェブサイトを検索
permissions-capabilities-autoplay-allow =
    .label = 音声と動画を許可
permissions-capabilities-autoplay-block =
    .label = 音声ありをブロック
permissions-capabilities-autoplay-blockall =
    .label = 音声と動画をブロック
permissions-capabilities-allow =
    .label = 許可
permissions-capabilities-block =
    .label = ブロック
permissions-capabilities-prompt =
    .label = 常に確認
permissions-capabilities-listitem-allow =
    .value = 許可
permissions-capabilities-listitem-block =
    .value = 不許可
permissions-capabilities-listitem-allow-session =
    .value = 現在のセッションのみ
permissions-capabilities-listitem-off =
    .value = オフ
permissions-capabilities-listitem-off-temporarily =
    .value = 一時的にオフ

## Invalid Hostname Dialog

permissions-invalid-uri-title = 無効なホスト名が入力されました
permissions-invalid-uri-label = 有効なホスト名を入力してください

## Exceptions - Tracking Protection

permissions-exceptions-etp-window2 =
    .title = 強化型トラッキング防止機能の例外
    .style = { permissions-window2.style }
permissions-exceptions-manage-etp-desc = 強化型トラッキング防止をオフにするウェブサイトを指定してください。管理したいサイトの正確なアドレスを入力して [例外を追加] をクリックしてください。

## Exceptions - Cookies

permissions-exceptions-cookie-window2 =
    .title = 例外 - Cookie とサイトデータ
    .style = { permissions-window2.style }
permissions-exceptions-cookie-desc = Cookie とサイトデータの使用を許可するかどうかウェブサイトごとに指定できます。個別に設定するサイトの正確なアドレスを入力して [不許可]、[現在のセッションのみ]、[許可] のいずれかをクリックしてください。

## Exceptions - HTTPS-Only Mode

permissions-exceptions-https-only-window2 =
    .title = 例外 - HTTPS-Only モード
    .style = { permissions-window2.style }
permissions-exceptions-https-only-desc = HTTPS-Only モードをオフにするウェブサイトを指定できます。{ -brand-short-name } はこれらのサイトでは安全な接続にアップグレードしません。プライベートウィンドウではこの例外は適用されません。
permissions-exceptions-https-only-desc2 = HTTPS-Only モードをオフにするウェブサイトを指定できます。{ -brand-short-name } はこれらのサイトでは安全な接続にアップグレードしません。

## Exceptions - Pop-ups

permissions-exceptions-popup-window2 =
    .title = 許可サイト - ポップアップ
    .style = { permissions-window2.style }
permissions-exceptions-popup-desc = ポップアップウィンドウを開くことを許可するウェブサイトを指定できます。許可するサイトの正確なアドレスを入力して [許可] をクリックしてください。

## Exceptions - Saved Logins

permissions-exceptions-saved-logins-window2 =
    .title = 例外 - ログイン情報の保存
    .style = { permissions-window2.style }
permissions-exceptions-saved-logins-desc = 次のウェブサイトのログイン情報は保存されません。

## Exceptions - Add-ons

permissions-exceptions-addons-window2 =
    .title = 許可サイト - アドオンのインストール
    .style = { permissions-window2.style }
permissions-exceptions-addons-desc = アドオンのインストールを許可するウェブサイトを指定できます。許可するサイトの正確なアドレスを入力して [許可] をクリックしてください。

## Site Permissions - Autoplay

permissions-site-autoplay-window2 =
    .title = 設定 - 自動再生
    .style = { permissions-window2.style }
permissions-site-autoplay-desc = 自動再生の既定の設定によらないサイトをここで管理できます。

## Site Permissions - Notifications

permissions-site-notification-window2 =
    .title = 設定 - 通知の許可
    .style = { permissions-window2.style }
permissions-site-notification-desc = 次のウェブサイトがユーザーへの通知を要求しています。通知を許可するウェブサイトを指定してください。これ以後の要求をブロックすることもできます。
permissions-site-notification-disable-label =
    .label = 通知の許可の要求をブロックする
permissions-site-notification-disable-desc = 上記以外のウェブサイトは、通知の許可を要求させないようにします。通知をブロックすると、一部のウェブサイトが機能しなくなる可能性があります。

## Site Permissions - Location

permissions-site-location-window2 =
    .title = 設定 - 位置情報の使用許可
    .style = { permissions-window2.style }
permissions-site-location-desc = 次のウェブサイトがユーザーの位置情報へのアクセスを要求しています。位置情報へのアクセスを許可するウェブサイトを指定してください。これ以後の要求をブロックすることもできます。
permissions-site-location-disable-label =
    .label = 位置情報へのアクセスの要求をブロックする
permissions-site-location-disable-desc = 上記以外のウェブサイトは、位置情報へのアクセスを要求させないようにします。位置情報へのアクセスをブロックすると、一部のウェブサイトが機能しなくなる可能性があります。

## Site Permissions - Virtual Reality

permissions-site-xr-window2 =
    .title = 設定 - VR の使用許可
    .style = { permissions-window2.style }
permissions-site-xr-desc = 次のウェブサイトが VR デバイスへのアクセスを要求しています。VR デバイスへのアクセスを許可するウェブサイトを指定してください。これ以後の要求をブロックすることもできます。
permissions-site-xr-disable-label =
    .label = VR デバイスへのアクセスの要求をブロックする
permissions-site-xr-disable-desc = 上記以外のウェブサイトは、VR デバイスへのアクセスを要求させないようにします。VR デバイスへのアクセスをブロックすると、一部のウェブサイトが機能しなくなる可能性があります。

## Site Permissions - Camera

permissions-site-camera-window2 =
    .title = 設定 - カメラの使用許可
    .style = { permissions-window2.style }
permissions-site-camera-desc = 次のウェブサイトがカメラへのアクセスを要求しています。カメラへのアクセスを許可するウェブサイトを指定してください。これ以後の要求をブロックすることもできます。
permissions-site-camera-disable-label =
    .label = カメラへのアクセスの要求をブロックする
permissions-site-camera-disable-desc = 上記以外のウェブサイトは、カメラへのアクセスを要求させないようにします。カメラへのアクセスをブロックすると、一部のウェブサイトが機能しなくなる可能性があります。

## Site Permissions - Microphone

permissions-site-microphone-window2 =
    .title = 設定 - マイクの使用許可
    .style = { permissions-window2.style }
permissions-site-microphone-desc = 次のウェブサイトがマイクへのアクセスを要求しています。マイクへのアクセスを許可するウェブサイトを指定してください。これ以後の要求をブロックすることもできます。
permissions-site-microphone-disable-label =
    .label = マイクへのアクセスの要求をブロックする
permissions-site-microphone-disable-desc = 上記以外のウェブサイトは、マイクへのアクセスを要求させないようにします。マイクへのアクセスをブロックすると、一部のウェブサイトが機能しなくなる可能性があります。

## Site Permissions - Speaker
##
## "Speaker" refers to an audio output device.

permissions-site-speaker-window =
    .title = 設定 - スピーカーの使用許可
    .style = { permissions-window2.style }
permissions-site-speaker-desc = 次のウェブサイトが音声出力デバイスの選択を要求しています。音声出力デバイスの選択を許可するウェブサイトを指定してください。
permissions-exceptions-doh-window =
    .title = DNS over HTTPS を利用するウェブサイトの例外
    .style = { permissions-window2.style }
permissions-exceptions-manage-doh-desc = { -brand-short-name } はこれらのサイトおよびそのサブドメインで安全な DNS を利用しません。
permissions-doh-entry-field = ウェブサイトのドメイン名を入力してください
    .accesskey = d
permissions-doh-add-exception =
    .label = 追加
    .accesskey = A
permissions-doh-col =
    .label = ドメイン
permissions-doh-remove =
    .label = 削除
    .accesskey = R
permissions-doh-remove-all =
    .label = すべて削除
    .accesskey = e
