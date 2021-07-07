# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = ตั้งนโยบายที่ WebExtensions สามารถเข้าถึงผ่าน chrome.storage.managed

policy-AppAutoUpdate = เปิดใช้งานหรือปิดใช้งานการอัปเดตแอปพลิเคชันอัตโนมัติ

policy-AppUpdateURL = ตั้ง URL อัปเดตแอปที่กำหนดเอง

policy-Authentication = กำหนดค่าการรับรองความถูกต้องแบบรวมสำหรับเว็บไซต์ที่สนับสนุน

policy-BlockAboutAddons = ปิดกั้นการเข้าถึงตัวจัดการส่วนเสริม (about:addons)

policy-BlockAboutConfig = ปิดกั้นการเข้าถึงหน้า about:config

policy-BlockAboutProfiles = ปิดกั้นการเข้าถึงหน้า about:profiles

policy-BlockAboutSupport = ปิดกั้นการเข้าถึงหน้า about:support

policy-CaptivePortal = เปิดหรือปิดใช้งานการสนับสนุนพอร์ทัลแบบ Captive

policy-CertificatesDescription = เพิ่มใบรับรองหรือใช้ใบรับรองในตัว

policy-Cookies = อนุญาตหรือปฏิเสธเว็บไซต์เพื่อตั้งคุกกี้

policy-DisabledCiphers = ปิดการใช้งานรหัสลับ

policy-DefaultDownloadDirectory = ตั้งไดเรกทอรีการดาวน์โหลดเริ่มต้น

policy-DisableAppUpdate = ป้องกันไม่ให้ { -brand-short-name } อัปเดต

policy-DisableDefaultClientAgent = ป้องกันไม่ให้ตัวแทนไคลเอนต์เริ่มต้นทำงานใด ๆ ใช้ได้กับ Windows เท่านั้น เนื่องจากแพลตฟอร์มอื่น ๆ ไม่มีตัวแทน

policy-DisableDeveloperTools = ปิดกั้นการเข้าถึงเครื่องมือนักพัฒนา

policy-DisableFeedbackCommands = ปิดใช้งานคำสั่งสำหรับส่งความคิดเห็นจากเมนู วิธีใช้ (ส่งความคิดเห็นและรายงานไซต์หลอกลวง)

policy-DisableForgetButton = ป้องกันไม่ให้เข้าถึงปุ่ม ลืม

policy-DisableFormHistory = ไม่จดจำประวัติการค้นหาและแบบฟอร์ม

policy-DisableMasterPasswordCreation = หากเป็น true จะไม่สามารถสร้างรหัสผ่านหลักได้

policy-DisablePasswordReveal = ไม่อนุญาตให้เปิดเผยรหัสผ่านในข้อมูลการเข้าสู่ระบบที่บันทึกไว้

policy-DisableProfileImport = ปิดใช้งานคำสั่งเมนูเพื่อนำเข้าข้อมูลจากแอปพลิเคชันอื่น

policy-DisableSafeMode = ปิดใช้งานคุณลักษณะสำหรับเริ่มการทำงานใหม่ในโหมดปลอดภัย หมายเหตุ: สามารถปิดใช้งานแป้น Shift สำหรับเข้าสู่โหมดปลอดภัยได้บน Windows เท่านั้นโดยใช้นโยบายกลุ่ม

policy-DisableSecurityBypass = ป้องกันไม่ให้ผู้ใช้ข้ามคำเตือนความปลอดภัย

policy-DisableSystemAddonUpdate = ป้องกันไม่ให้ { -brand-short-name } ติดตั้งและอัปเดตส่วนเสริมของระบบ

policy-DisableTelemetry = ปิดการวัดและส่งข้อมูลทางไกล

policy-DisplayMenuBar = แสดงแถบเมนูโดยค่าเริ่มต้น

policy-DNSOverHTTPS = กำหนดค่า DNS ผ่าน HTTPS

policy-DontCheckDefaultClient = ปิดใช้งานการตรวจสอบไคลเอ็นต์เริ่มต้นเมื่อเปิดโปรแกรม

policy-DownloadDirectory = ตั้งและล็อคไดเรกทอรีการดาวน์โหลด

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = เปิดหรือปิดใช้งานการปิดกั้นเนื้อหาแล้วเลือกล็อกคุณลักษณะนี้ได้

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = เปิดหรือปิดใช้งาน Encrypted Media Extensions โดยเลือกล็อกคุณลักษณะนี้ได้

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = ติดตั้ง ถอนการติดตั้ง หรือล็อกส่วนขยาย ตัวเลือกการติดตั้งนี้จะใช้ URL หรือเส้นทางเป็นพารามิเตอร์ ส่วนตัวเลือกถอนการติดตั้งและล็อกจะใช้ไอดีส่วนขยาย

policy-ExtensionSettings = จัดการการติดตั้งส่วนขยายในทุกส่วน

policy-ExtensionUpdate = เปิดใช้งานหรือปิดใช้งานการอัปเดตส่วนขยายอัตโนมัติ

policy-HardwareAcceleration = หากเป็น false ให้ปิดการเร่งด้วยฮาร์ดแวร์

policy-InstallAddonsPermission = อนุญาตให้เว็บไซต์บางส่วนติดตั้งส่วนเสริม

policy-LegacyProfiles = ปิดใช้งานคุณลักษณะการบังคับใช้โปรไฟล์แยกต่างหากสำหรับการติดตั้งในแต่ละครั้ง

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = เปิดใช้งานการตั้งค่าลักษณะการทำงานของคุกกี้ SameSite แบบดั้งเดิมซึ่งเป็นค่าเริ่มต้น

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = แปลงกลับเป็นลักษณะการทำงานของ SameSite แบบดั้งเดิมสำหรับคุกกี้บนไซต์ที่ระบุ

##

policy-LocalFileLinks = อนุญาตให้เว็บไซต์ที่ระบุเชื่อมโยงไปยังไฟล์ภายในเครื่อง

policy-NetworkPrediction = เปิดหรือปิดใช้งานการคาดเดาเครือข่าย (การดึงข้อมูล DNS ล่วงหน้า)

policy-OfferToSaveLogins = บังคับให้การตั้งค่าอนุญาต { -brand-short-name } ให้เสนอให้จดจำการเข้าสู่ระบบและรหัสผ่านที่บันทึกไว้ โดยสามารถกำหนดค่าเป็นทั้งจริงและเท็จได้

policy-OfferToSaveLoginsDefault = กำหนดค่าเริ่มต้นเพื่ออนุญาต { -brand-short-name } ให้เสนอให้จดจำข้อมูลการเข้าสู่ระบบและรหัสผ่านที่บันทึกไว้ โดยสามารถกำหนดค่าเป็นทั้งจริงและเท็จได้

policy-OverrideFirstRunPage = แทนที่หน้าการเรียกใช้ครั้งแรก ตั้งค่านโยบายนี้เป็นว่างเปล่าถ้าคุณต้องการปิดใช้งานหน้าการเรียกใช้ครั้งแรก

policy-OverridePostUpdatePage = แทนที่หน้า “มีอะไรใหม่” หลังการอัปเดต ตั้งค่านโยบายนี้เป็นว่างเปล่าถ้าคุณต้องการปิดใช้งานหน้าหลังการอัปเดต

policy-PasswordManagerEnabled = เปิดใช้งานการบันทึกรหัสผ่านไปยังตัวจัดการรหัสผ่าน

# PDF.js and PDF should not be translated
policy-PDFjs = ปิดใช้งานหรือกำหนดค่า PDF.js ตัวดู PDF ในตัวใน { -brand-short-name }

policy-Permissions2 = กำหนดค่าสิทธิอนุญาตสำหรับกล้อง, ไมโครโฟน, ตำแหน่งที่ตั้ง, การแจ้งเตือน, และการเล่นอัตโนมัติ

policy-Preferences = ตั้งและล็อกค่าสำหรับเซตย่อยของค่ากำหนด

policy-PromptForDownloadLocation = ถามตำแหน่งที่จะบันทึกไฟล์เมื่อดาวน์โหลด

policy-Proxy = กำหนดค่าการตั้งค่าพร็อกซี

policy-RequestedLocales = ตั้งค่ารายการภาษาสำหรับแอปพลิเคชันตามลำดับที่ต้องการ

policy-SanitizeOnShutdown2 = ล้างข้อมูลการนำทางเมื่อปิดเครื่อง

policy-SearchEngines = กำหนดค่าการตั้งค่าเครื่องมือค้นหา นโยบายนี้ใช้ได้บนรุ่น Extended Support Release (ESR) เท่านั้น

policy-SearchSuggestEnabled = เปิดใช้งานหรือปิดใช้งานข้อเสนอแนะการค้นหา

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = ติดตั้งโมดูล PKCS #11

policy-SSLVersionMax = ตั้งรุ่น SSL สูงสุด

policy-SSLVersionMin = ตั้งรุ่น SSL ต่ำสุด

policy-SupportMenu = เพิ่มรายการเมนูฝ่ายสนับสนุนที่กำหนดเองไปยังเมนูช่วยเหลือ

policy-UserMessaging = ไม่ต้องแสดงข้อความบางส่วนถึงผู้ใช้

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = ปิดกั้นไม่ให้เยี่ยมชมเว็บไซต์ ดูคู่มือสำหรับรายละเอียดเพิ่มเติมเกี่ยวกับรูปแบบ
