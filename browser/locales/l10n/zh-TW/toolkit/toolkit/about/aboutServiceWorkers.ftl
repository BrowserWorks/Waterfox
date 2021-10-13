# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = 關於 Service Workers
about-service-workers-main-title = 註冊的 Service Worker
about-service-workers-warning-not-enabled = 未啟用 Service Workers。
about-service-workers-warning-no-service-workers = 未註冊 Service Workers。

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = 來源: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Scope:</strong> { $name }
script-spec = <strong>Script Spec:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>目前的 Worker 網址:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>使用中的快取名稱:</strong> { $name }
waiting-cache-name = <strong>等待中的快取名稱:</strong> { $name }
push-end-point-waiting = <strong>推送端點</strong> { waiting }
push-end-point-result = <strong>推送端點</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = 更新

unregister-button = 取消註冊

unregister-error = 此 Service Worker 取消註冊失敗。

waiting = 等待中…
