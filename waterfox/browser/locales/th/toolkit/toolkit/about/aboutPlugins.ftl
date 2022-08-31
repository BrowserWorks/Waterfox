# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = เกี่ยวกับปลั๊กอิน

installed-plugins-label = ปลั๊กอินที่ติดตั้ง
no-plugins-are-installed-label = ไม่พบปลั๊กอินที่ติดตั้ง

deprecation-description = มีบางอย่างขาดหายไป? ปลั๊กอินบางตัวไม่ได้รับการสนับสนุนอีกต่อไป <a data-l10n-name="deprecation-link">เรียนรู้เพิ่มเติม</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">ไฟล์:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">เส้นทาง:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">รุ่น:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">สถานะ:</span> ถูกเปิดใช้งาน
state-dd-enabled-block-list-state = <span data-l10n-name="state">สถานะ:</span> ถูกเปิดใช้งาน ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">สถานะ:</span> ถูกปิดใช้งาน
state-dd-Disabled-block-list-state = <span data-l10n-name="state">สถานะ:</span> ถูกปิดใช้งาน ({ $blockListState })

mime-type-label = ชนิดของ MIME
description-label = คำอธิบาย
suffixes-label = ส่วนต่อท้าย

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = ข้อมูลสัญญาอนุญาต
plugins-gmp-privacy-info = ข้อมูลความเป็นส่วนตัว

plugins-openh264-name = ตัวแปลงสัญญาณวิดีโอ OpenH264 ให้บริการโดย Cisco Systems, Inc.
plugins-openh264-description = ปลั๊กอินนี้ติดตั้งโดยอัตโนมัติโดย Waterfox เพื่อให้สอดคล้องกับข้อกำหนด WebRTC และเปิดใช้งานการเรียก WebRTC ด้วยอุปกรณ์ที่ต้องใช้ตัวแปลงสัญญาณวิดีโอ H.264 เยี่ยมชม https://www.openh264.org/ เพื่อดูรหัสต้นฉบับของตัวแปลงสัญญาณและเรียนรู้เพิ่มเติมเกี่ยวกับการใช้งาน

plugins-widevine-name = โมดูลถอดรหัสเนื้อหา Widevine ให้บริการโดย Google Inc.
plugins-widevine-description = ปลั๊กอินนี้ช่วยให้สามารถเล่นสื่อที่เข้ารหัสตามข้อกำหนดของ Encrypted Media Extensions ได้ โดยทั่วไปแล้วสื่อที่เข้ารหัสจะถูกใช้โดยไซต์เพื่อป้องกันการคัดลอกเนื้อหาสื่อพรีเมียม เยี่ยมชม https://www.w3.org/TR/encrypted-media/ สำหรับข้อมูลเพิ่มเติมเกี่ยวกับ Encrypted Media Extensions
