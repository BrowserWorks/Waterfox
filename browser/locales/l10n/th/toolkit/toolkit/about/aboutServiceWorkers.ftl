# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = เกี่ยวกับตัวทำงานบริการ
about-service-workers-main-title = ตัวทำงานบริการที่ลงทะเบียน
about-service-workers-warning-not-enabled = ไม่ได้เปิดใช้งานตัวทำงานบริการ
about-service-workers-warning-no-service-workers = ไม่มีตัวทำงานบริการที่ได้ลงทะเบียนไว้

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = แหล่งที่มา: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>ขอบเขต:</strong> { $name }
script-spec = <strong>ข้อมูลจำเพาะของสคริปต์:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL ของตัวทำงานปัจจุบัน:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>ชื่อแคชที่ใช้งานอยู่:</strong> { $name }
waiting-cache-name = <strong>ชื่อแคชที่กำลังรออยู่:</strong> { $name }
push-end-point-waiting = <strong>จุดปลายทางการสื่อสารสำหรับรับแจ้งแบบทันที:</strong> { waiting }
push-end-point-result = <strong>จุดปลายทางการสื่อสารสำหรับรับแจ้งแบบทันที:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = อัปเดต

unregister-button = เลิกลงทะเบียน

unregister-error = ไม่สามารถเลิกลงทะเบียนตัวทำงานบริการนี้

waiting = กำลังรอ…
