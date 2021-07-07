# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = 关于 Service Worker
about-service-workers-main-title = 已注册的 Service Worker
about-service-workers-warning-not-enabled = Service Worker 未启用。
about-service-workers-warning-no-service-workers = 尚无已注册的 Service Worker。

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = 来源：{ $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>范围：</strong> { $name }
script-spec = <strong>脚本规格：</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>目前的 Worker URL：</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>活跃的缓存名称：</strong> { $name }
waiting-cache-name = <strong>等待中的缓存名称：</strong> { $name }
push-end-point-waiting = <strong>推送端点：</strong> { waiting }
push-end-point-result = <strong>推送端点：</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = 更新

unregister-button = 取消注册

unregister-error = 取消注册此 Service Worker 失败。

waiting = 请稍候…
