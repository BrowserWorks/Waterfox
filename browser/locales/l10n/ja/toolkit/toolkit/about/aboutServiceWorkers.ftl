# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Service Workers について
about-service-workers-main-title = 登録された Service Workers
about-service-workers-warning-not-enabled = Service Workers が有効ではありません。
about-service-workers-warning-no-service-workers = Service Workers が登録されていません。
# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = オリジン: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>スコープ:</strong> { $name }
script-spec = <strong>スクリプト仕様:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>現在の Worker URL:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>実行中のキャッシュ名:</strong> { $name }
waiting-cache-name = <strong>待機中のキャッシュ名:</strong> { $name }
push-end-point-waiting = <strong>エンドポイントをプッシュ:</strong> { waiting }
push-end-point-result = <strong>エンドポイントをプッシュ:</strong> { $name }
# This term is used as a button label (verb, not noun).
update-button = 更新
unregister-button = 登録解除
unregister-error = この Service Worker の登録解除に失敗しました。
waiting = 待機中...
