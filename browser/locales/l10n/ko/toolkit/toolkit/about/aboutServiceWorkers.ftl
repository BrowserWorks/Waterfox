# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Service Worker 정보
about-service-workers-main-title = 등록된 Service Worker
about-service-workers-warning-not-enabled = Service Worker가 활성화되지 않았습니다.
about-service-workers-warning-no-service-workers = 등록된 Service Worker가 없습니다.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = 출처: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>범위:</strong> { $name }
script-spec = <strong>스크립트 스펙:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>현재 Worker URL:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>활성화 캐시 이름:</strong> { $name }
waiting-cache-name = <strong>대기 캐시 이름:</strong> { $name }
push-end-point-waiting = <strong>푸시 엔드포인트:</strong> { waiting }
push-end-point-result = <strong>푸시 엔드포인트:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = 업데이트

unregister-button = 등록해제

unregister-error = 이 Service Worker를 등록 해제하지 못했습니다.

waiting = 대기 중…
