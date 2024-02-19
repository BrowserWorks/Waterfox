# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = เกี่ยวกับ { -brand-full-name }

releaseNotes-link = มีอะไรใหม่

update-checkForUpdatesButton =
    .label = ตรวจสอบการอัปเดต
    .accesskey = ต

update-updateButton =
    .label = เริ่มการทำงานใหม่เพื่ออัปเดต { -brand-shorter-name }
    .accesskey = ร

update-checkingForUpdates = กำลังตรวจสอบการอัปเดต…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>กำลังดาวน์โหลดการอัปเดต — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = กำลังดาวน์โหลดอัปเดต — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = กำลังติดตั้งการอัปเดต…

update-failed = การอัปเดตล้มเหลว <label data-l10n-name="failed-link">ดาวน์โหลดรุ่นล่าสุด</label>
update-failed-main = การอัปเดตล้มเหลว <a data-l10n-name="failed-link-main">ดาวน์โหลดรุ่นล่าสุด</a>

update-adminDisabled = การอัปเดตถูกปิดใช้งานโดยผู้ดูแลระบบของคุณ
update-noUpdatesFound = { -brand-short-name } เป็นรุ่นล่าสุดแล้ว
aboutdialog-update-checking-failed = ไม่สามารถตรวจหาการอัปเดตได้
update-otherInstanceHandlingUpdates = { -brand-short-name } กำลังถูกอัปเดตโดยอินสแตนซ์อื่น

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = มีการอัปเดตที่ <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = มีการอัปเดตที่ <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = คุณไม่สามารถดำเนินการอัปเดตเพิ่มเติมในระบบนี้ได้ <label data-l10n-name="unsupported-link">เรียนรู้เพิ่มเติม</label>

update-restarting = กำลังเริ่มการทำงานใหม่…

update-internal-error2 = ไม่สามารถตรวจสอบการอัพเดตได้เนื่องจากมีข้อผิดพลาดภายใน การอัพเดตมีอยู่ที่ <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = คุณกำลังอยู่บนช่องทางการอัปเดต <label data-l10n-name="current-channel">{ $channel }</label>

warningDesc-version = { -brand-short-name } เป็นรุ่นทดลองและอาจไม่เสถียร

aboutdialog-help-user = ความช่วยเหลือของ { -brand-product-name }
aboutdialog-submit-feedback = ส่งข้อคิดเห็น

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> คือ <label data-l10n-name="community-exp-creditsLink">ชุมชนระดับโลก</label> ที่ทำงานร่วมกันเพื่อทำให้เว็บเปิดกว้าง เป็นของสาธารณะ และเข้าถึงได้ทุกคน

community-2 = { -brand-short-name } ได้รับการออกแบบโดย <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label> ซึ่งเป็น <label data-l10n-name="community-creditsLink">ชุมชนระดับโลก</label> ที่ทำงานร่วมกันเพื่อทำให้เว็บเปิดกว้าง เป็นของสาธารณะ และเข้าถึงได้ทุกคน

helpus = ต้องการที่จะช่วย? <label data-l10n-name="helpus-donateLink">ทำการบริจาค</label> หรือ <label data-l10n-name="helpus-getInvolvedLink">มีส่วนร่วม!</label>

bottomLinks-license = ข้อมูลสัญญาอนุญาต
bottomLinks-rights = สิทธิผู้ใช้
bottomLinks-privacy = นโยบายความเป็นส่วนตัว

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits } บิต)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits } บิต)
