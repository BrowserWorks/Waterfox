# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Về Service Worker
about-service-workers-main-title = Các Service Worker đã đăng ký
about-service-workers-warning-not-enabled = Service Worker không được bật.
about-service-workers-warning-no-service-workers = Không có Service Worker đã đăng ký.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Nguồn gốc: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Phạm vi:</strong> { $name }
script-spec = <strong>Tập lệnh Spec:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL Worker hiện tại:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Tên bộ đệm đang hoạt động:</strong> { $name }
waiting-cache-name = <strong>Tên bộ đệm đang chờ:</strong> { $name }
push-end-point-waiting = <strong>Điểm cuối:</strong> { waiting }
push-end-point-result = <strong>Điểm cuối:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = Cập nhật

unregister-button = Hủy đăng ký

unregister-error = Không thể hủy đăng ký Service Worker này.

waiting = Đang chờ…
