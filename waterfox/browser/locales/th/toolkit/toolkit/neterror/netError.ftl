# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = มีปัญหาในการโหลดหน้า
certerror-page-title = คำเตือน: ความเสี่ยงด้านความปลอดภัยที่อาจเกิดขึ้นข้างหน้า
certerror-sts-page-title = ไม่ได้เชื่อมต่อ: ปัญหาความปลอดภัยที่อาจเกิดขึ้น
neterror-blocked-by-policy-page-title = หน้าที่ถูกปิดกั้น
neterror-captive-portal-page-title = เข้าสู่ระบบเครือข่าย
neterror-dns-not-found-title = ไม่พบเซิร์ฟเวอร์
neterror-malformed-uri-page-title = URL ไม่ถูกต้อง

## Error page actions

neterror-advanced-button = ขั้นสูง…
neterror-copy-to-clipboard-button = คัดลอกข้อความไปยังคลิปบอร์ด
neterror-learn-more-link = เรียนรู้เพิ่มเติม…
neterror-open-portal-login-page-button = เปิดหน้าเข้าสู่ระบบของเครือข่าย
neterror-override-exception-button = ยอมรับความเสี่ยงและดำเนินการต่อ
neterror-pref-reset-button = เรียกคืนการตั้งค่าเริ่มต้น
neterror-return-to-previous-page-button = ย้อนกลับ
neterror-return-to-previous-page-recommended-button = ย้อนกลับ (แนะนำ)
neterror-try-again-button = ลองอีกครั้ง
neterror-add-exception-button = ดำเนินการต่อสำหรับไซต์นี้เสมอ
neterror-settings-button = เปลี่ยนการตั้งค่า DNS
neterror-view-certificate-link = ดูใบรับรอง
neterror-trr-continue-this-time = ไปต่อในครั้งนี้
neterror-disable-native-feedback-warning = ดำเนินการต่อเสมอ

##

neterror-pref-reset = ดูเหมือนว่าการตั้งค่าความปลอดภัยเครือข่ายของคุณอาจเป็นสาเหตุของสิ่งนี้ คุณต้องการเรียกคืนการตั้งค่าเริ่มต้นหรือไม่?
neterror-error-reporting-automatic = รายงานข้อผิดพลาดเช่นนี้เพื่อช่วย { -vendor-short-name } ระบุและปิดกั้นไซต์ที่ประสงค์ร้าย

## Specific error messages

neterror-generic-error = { -brand-short-name } ไม่สามารถโหลดหน้านี้ได้ด้วยเหตุผลบางอย่าง
neterror-load-error-try-again = ไซต์อาจไม่พร้อมใช้งานชั่วคราวหรือกำลังทำงานหนักเกินไป ลองอีกครั้งในอีกสักครู่
neterror-load-error-connection = หากคุณไม่สามารถโหลดหน้าใด ๆ ได้ ตรวจสอบการเชื่อมต่อเครือข่ายของคอมพิวเตอร์ของคุณ
neterror-load-error-firewall = หากคอมพิวเตอร์หรือเครือข่ายของคุณถูกปกป้องด้วยไฟร์วอลล์หรือพร็อกซี ตรวจสอบให้แน่ใจว่า { -brand-short-name } ได้รับอนุญาตให้เข้าถึงเว็บ
neterror-captive-portal = คุณต้องเข้าสู่ระบบเครือข่ายนี้ก่อนที่คุณจะสามารถเข้าถึงอินเทอร์เน็ต
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = คุณต้องการไปที่ <a data-l10n-name="website">{ $hostAndPath }</a> ใช่หรือไม่?
neterror-dns-not-found-hint-header = <strong>หากคุณป้อนที่อยู่ถูกต้องแล้ว คุณสามารถ:</strong>
neterror-dns-not-found-hint-try-again = ลองอีกครั้งในภายหลัง
neterror-dns-not-found-hint-check-network = ตรวจสอบการเชื่อมต่อเครือข่ายของคุณ
neterror-dns-not-found-hint-firewall = ตรวจสอบว่า { -brand-short-name } ได้รับอนุญาตให้เข้าถึงเว็บ (คุณอาจเชื่อมต่ออยู่แต่ไม่ผ่านไฟร์วอลล์)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } ไม่สามารถปกป้องคำขอของคุณสำหรับที่อยู่ของไซต์นี้ผ่านตัวแก้ไข DNS ที่เชื่อถือได้ของเราได้ นี่คือเหตุผล:
neterror-dns-not-found-trr-third-party-warning2 = คุณสามารถไปต่อด้วย DNS resolver เริ่มต้นของคุณได้ อย่างไรก็ตาม บุคคลที่สามอาจเห็นได้ว่าคุณเยี่ยมชมเว็บไซต์อะไรบ้าง
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } ไม่สามารถเชื่อมต่อไปยัง { $trrDomain } ได้
neterror-dns-not-found-trr-only-timeout = การเชื่อมต่อไปยัง { $trrDomain } ใช้เวลานานกว่าที่คาดไว้
neterror-dns-not-found-trr-offline = คุณไม่ได้เชื่อมต่อกับอินเทอร์เน็ต
neterror-dns-not-found-trr-unknown-host2 = { $trrDomain } ไม่พบเว็บไซต์นี้
neterror-dns-not-found-trr-server-problem = เกิดปัญหากับ { $trrDomain }
neterror-dns-not-found-bad-trr-url = URL ไม่ถูกต้อง
neterror-dns-not-found-trr-unknown-problem = เกิดปัญหาที่ไม่คาดคิด

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } ไม่สามารถปกป้องคำขอของคุณสำหรับที่อยู่ของไซต์นี้ผ่านตัวแก้ไข DNS ที่เชื่อถือได้ของเราได้ นี่คือเหตุผล:
neterror-dns-not-found-native-fallback-heuristic = DNS over HTTPS ถูกปิดใช้งานบนเครือข่ายของคุณ
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } ไม่สามารถเชื่อมต่อไปยัง { $trrDomain } ได้

##

neterror-file-not-found-filename = ตรวจสอบชื่อไฟล์สำหรับตัวพิมพ์ใหญ่เล็กหรือข้อผิดพลาดการพิมพ์อื่น ๆ
neterror-file-not-found-moved = ตรวจสอบเพื่อดูหากไฟล์ถูกย้าย เปลี่ยนชื่อ หรือลบ
neterror-access-denied = ไฟล์อาจถูกเอาออก ย้าย หรือสิทธิอนุญาตของไฟล์อาจป้องกันการเข้าถึง
neterror-unknown-protocol = คุณอาจจำเป็นต้องติดตั้งซอฟต์แวร์อื่นเพื่อเปิดที่อยู่นี้
neterror-redirect-loop = ปัญหานี้บางครั้งอาจมีสาเหตุมาจากการปิดใช้งานหรือปฏิเสธการยอมรับคุกกี้
neterror-unknown-socket-type-psm-installed = ตรวจสอบให้แน่ใจว่าระบบของคุณมีตัวจัดการความปลอดภัยส่วนบุคคลติดตั้งอยู่
neterror-unknown-socket-type-server-config = สิ่งนี้อาจเกิดจากการกำหนดค่าที่ไม่มาตรฐานบนเซิร์ฟเวอร์
neterror-not-cached-intro = เอกสารที่ขอไม่มีในแคชของ { -brand-short-name }
neterror-not-cached-sensitive = ตามมาตรการรักษาความปลอดภัย { -brand-short-name } จะไม่ขอเอกสารที่ละเอียดอ่อนให้ใหม่โดยอัตโนมัติ
neterror-not-cached-try-again = คลิก ลองอีกครั้ง เพื่อขอเอกสารจากเว็บไซต์ใหม่
neterror-net-offline = กด “ลองอีกครั้ง” เพื่อสลับเป็นโหมดออนไลน์และโหลดหน้าใหม่
neterror-proxy-resolve-failure-settings = ตรวจสอบให้แน่ใจว่าการตั้งค่าพร็อกซีถูกต้อง
neterror-proxy-resolve-failure-connection = ตรวจสอบให้แน่ใจว่าคอมพิวเตอร์ของคุณมีการเชื่อมต่อเครือข่ายที่ทำงานได้
neterror-proxy-resolve-failure-firewall = หากคอมพิวเตอร์หรือเครือข่ายของคุณถูกปกป้องด้วยไฟร์วอลล์หรือพร็อกซี ตรวจสอบให้แน่ใจว่า { -brand-short-name } ได้รับอนุญาตให้เข้าถึงเว็บ
neterror-proxy-connect-failure-settings = ตรวจสอบให้แน่ใจว่าการตั้งค่าพร็อกซีถูกต้อง
neterror-proxy-connect-failure-contact-admin = ติดต่อผู้ดูแลเครือข่ายของคุณเพื่อให้แน่ใจว่าเซิร์ฟเวอร์พร็อกซีกำลังทำงานอยู่
neterror-content-encoding-error = โปรดติดต่อเจ้าของเว็บไซต์เพื่อแจ้งพวกเขาให้ทราบถึงปัญหานี้
neterror-unsafe-content-type = โปรดติดต่อเจ้าของเว็บไซต์เพื่อแจ้งพวกเขาให้ทราบถึงปัญหานี้
neterror-nss-failure-not-verified = ไม่สามารถแสดงหน้าที่คุณกำลังพยายามจะดูเนื่องจากไม่สามารถยืนยันความถูกต้องของข้อมูลที่ได้รับ
neterror-nss-failure-contact-website = โปรดติดต่อเจ้าของเว็บไซต์เพื่อแจ้งพวกเขาให้ทราบถึงปัญหานี้
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } ตรวจพบภัยคุกคามด้านความปลอดภัยที่อาจเกิดขึ้นและไม่ได้ดำเนินการต่อไปยัง <b>{ $hostname }</b> ถ้าคุณเยี่ยมชมไซต์นี้ ผู้โจมตีอาจพยายามล้วงข้อมูล เช่น รหัสผ่าน อีเมล หรือรายละเอียดบัตรเครดิตของคุณ
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } ตรวจพบภัยคุกคามด้านความปลอดภัยที่อาจเกิดขึ้นและไม่ได้ดำเนินการต่อไปยัง <b>{ $hostname }</b> เนื่องจากเว็บไซต์นี้ต้องการการเชื่อมต่อที่ปลอดภัย
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } ตรวจพบปัญหาและไม่ได้ดำเนินการต่อไปยัง <b>{ $hostname }</b> เว็บไซต์อาจถูกกำหนดค่าอย่างไม่ถูกต้องหรือนาฬิกาคอมพิวเตอร์ของคุณถูกตั้งค่าเป็นเวลาที่ผิด
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> ดูเหมือนจะเป็นไซต์ที่ปลอดภัย แต่ไม่สามารถทำการเชื่อมต่ออย่างปลอดภัยได้ ปัญหานี้เกิดจาก <b>{ $mitm }</b> ซึ่งอาจเป็นเนื่องจากซอฟต์แวร์ที่ติดตั้งบนคอมพิวเตอร์ของคุณหรือเครือข่ายของคุณ
neterror-corrupted-content-intro = ไม่สามารถแสดงหน้าที่คุณกำลังพยายามจะดูเนื่องจากตรวจพบข้อผิดพลาดในการส่งผ่านข้อมูล
neterror-corrupted-content-contact-website = โปรดติดต่อเจ้าของเว็บไซต์เพื่อแจ้งพวกเขาให้ทราบถึงปัญหานี้
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = ข้อมูลขั้นสูง: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> ใช้เทคโนโลยีความปลอดภัยที่ล้าสมัยและเสี่ยงต่อการถูกโจมตี ผู้โจมตีสามารถเปิดเผยข้อมูลที่คุณคิดว่าปลอดภัยได้อย่างง่ายดาย ผู้ดูแลเว็บไซต์จำเป็นต้องแก้ไขเซิร์ฟเวอร์ก่อนที่คุณจะสามารถเยี่ยมชมไซต์ได้
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = รหัสข้อผิดพลาด: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = คอมพิวเตอร์ของคุณคิดว่าเวลาปัจจุบันคือ { DATETIME($now, dateStyle: "medium") } ซึ่งทำให้ { -brand-short-name } ไม่สามารถทำการเชื่อมต่ออย่างปลอดภัยได้ เมื่อต้องการเยี่ยมชม <b>{ $hostname }</b> ให้อัปเดตนาฬิกาคอมพิวเตอร์ของคุณในการตั้งค่าระบบของคุณให้เป็นวันที่ เวลา และเขตเวลาปัจจุบัน แล้วรีเฟรช <b>{ $hostname }</b>
neterror-network-protocol-error-intro = ไม่สามารถแสดงหน้าที่คุณกำลังพยายามจะดูเนื่องจากตรวจพบข้อผิดพลาดในโปรโตคอลเครือข่าย
neterror-network-protocol-error-contact-website = โปรดติดต่อเจ้าของเว็บไซต์เพื่อแจ้งพวกเขาให้ทราบถึงปัญหานี้
certerror-expired-cert-second-para = ดูเหมือนว่าใบรับรองของเว็บไซต์จะหมดอายุแล้ว ซึ่งทำให้ { -brand-short-name } ไม่สามารถเชื่อมต่ออย่างปลอดภัยได้ ถ้าคุณเยี่ยมชมไซต์นี้ ผู้โจมตีอาจพยายามล้วงข้อมูล เช่น รหัสผ่าน อีเมล หรือรายละเอียดบัตรเครดิตของคุณ
certerror-expired-cert-sts-second-para = ดูเหมือนว่าใบรับรองของเว็บไซต์จะหมดอายุแล้ว ซึ่งทำให้ { -brand-short-name } ไม่สามารถเชื่อมต่ออย่างปลอดภัยได้
certerror-what-can-you-do-about-it-title = คุณสามารถทำอะไรเกี่ยวกับเรื่องนี้ได้บ้าง?
certerror-unknown-issuer-what-can-you-do-about-it-website = ปัญหานี้มักเกิดขึ้นกับเว็บไซต์ และไม่มีวิธีใดที่คุณสามารถแก้ปัญหานี้ได้
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = ถ้าคุณกำลังใช้เครือข่ายบริษัทหรือกำลังใช้ซอฟต์แวร์ป้องกันไวรัส คุณสามารถติดต่อขอความช่วยเหลือจากทีมสนับสนุนได้ คุณยังสามารถแจ้งให้ผู้ดูแลของเว็บไซต์ทราบเกี่ยวกับปัญหานี้ได้
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = นาฬิกาคอมพิวเตอร์ของคุณถูกตั้งค่าเป็น { DATETIME($now, dateStyle: "medium") } ตรวจให้แน่ใจว่าคอมพิวเตอร์ของคุณถูกตั้งค่าเป็นวันที่ เวลา และเขตเวลาที่ถูกต้องในการตั้งค่าระบบของคุณ แล้วลองรีเฟรช <b>{ $hostname }</b>
certerror-expired-cert-what-can-you-do-about-it-contact-website = ถ้านาฬิกาของคุณถูกตั้งค่าเป็นเวลาที่ถูกต้องอยู่แล้ว แสดงว่าเว็บไซต์อาจจะถูกกำหนดค่าอย่างไม่ถูกต้อง และไม่มีวิธีใดที่คุณสามารถแก้ปัญหานี้ได้ คุณสามารถแจ้งให้ผู้ดูแลของเว็บไซต์นี้ทราบเกี่ยวกับปัญหานี้ได้
certerror-bad-cert-domain-what-can-you-do-about-it = ปัญหานี้มักเกิดขึ้นกับเว็บไซต์ และไม่มีวิธีใดที่คุณสามารถแก้ปัญหานี้ได้ คุณสามารถแจ้งให้ผู้ดูแลของเว็บไซต์ทราบเกี่ยวกับปัญหานี้ได้
certerror-mitm-what-can-you-do-about-it-antivirus = ถ้าซอฟต์แวร์ป้องกันไวรัสของคุณมีคุณลักษณะที่ใช้สแกนการเชื่อมต่อที่ถูกเข้ารหัส (มักถูกเรียกว่า “การสแกนเว็บ” หรือ “การสแกน HTTPS”) คุณสามารถปิดใช้งานคุณลักษณะนั้นได้ ถ้าวิธีนี้ใช้ไม่ได้ผล คุณสามารถลบและติดตั้งซอฟต์แวร์ป้องกันไวรัสใหม่ได้
certerror-mitm-what-can-you-do-about-it-corporate = ถ้าคุณกำลังใช้เครือข่ายบริษัท คุณสามารถติดต่อแผนกไอทีของคุณได้
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = ถ้าคุณไม่คุ้นเคยกับ <b>{ $mitm }</b> แสดงว่าอาจเป็นการโจมตีและคุณไม่ควรดำเนินการต่อไปยังไซต์นี้
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = ถ้าคุณไม่คุ้นเคยกับ <b>{ $mitm }</b> แสดงว่าอาจเป็นการโจมตี และไม่มีวิธีใดที่คุณสามารถเข้าถึงไซต์นี้ได้
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> มีนโยบายการรักษาความปลอดภัยที่เรียกว่า HTTP Strict Transport Security (HSTS) ซึ่งหมายความว่า { -brand-short-name } สามารถทำการเชื่อมต่อได้อย่างปลอดภัยเท่านั้น คุณไม่สามารถเพิ่มข้อยกเว้นเพื่อเยี่ยมชมไซต์นี้ได้
