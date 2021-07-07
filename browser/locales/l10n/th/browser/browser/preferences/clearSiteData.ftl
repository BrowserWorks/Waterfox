# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = ล้างข้อมูล
    .style = width: 35em
clear-site-data-description = การล้างคุกกี้และข้อมูลไซต์ทั้งหมดที่จัดเก็บไว้โดย { -brand-short-name } อาจลงชื่อคุณออกจากเว็บไซต์และเอาเนื้อหาเว็บออฟไลน์ออก การล้างข้อมูลแคชจะไม่ส่งผลกระทบต่อการเข้าสู่ระบบของคุณ
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = คุกกี้และข้อมูลไซต์ ({ $amount } { $unit })
    .accesskey = ค
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = คุกกี้และข้อมูลไซต์
    .accesskey = ค
clear-site-data-cookies-info = คุณอาจได้รับการลงชื่อออกจากเว็บไซต์หากล้างข้อมูล
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = เนื้อหาเว็บที่ถูกแคชไว้ ({ $amount } { $unit })
    .accesskey = น
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = เนื้อหาเว็บที่ถูกแคชไว้
    .accesskey = น
clear-site-data-cache-info = จะต้องให้เว็บไซต์โหลดภาพและข้อมูลใหม่
clear-site-data-cancel =
    .label = ยกเลิก
    .accesskey = ย
clear-site-data-clear =
    .label = ล้าง
    .accesskey = ล
clear-site-data-dialog =
    .buttonlabelaccept = ล้าง
    .buttonaccesskeyaccept = ล
