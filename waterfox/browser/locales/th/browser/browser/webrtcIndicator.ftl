# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } - ตัวบ่งชี้การแบ่งปัน
webrtc-indicator-window =
    .title = { -brand-short-name } - ตัวบ่งชี้การแบ่งปัน

## Used as list items in sharing menu

webrtc-item-camera = กล้อง
webrtc-item-microphone = ไมโครโฟน
webrtc-item-audio-capture = เสียงในแท็บ
webrtc-item-application = แอปพลิเคชัน
webrtc-item-screen = หน้าจอ
webrtc-item-window = หน้าต่าง
webrtc-item-browser = แท็บ

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = ไม่ทราบที่มา

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = อุปกรณ์ที่แบ่งปันแท็บ
    .accesskey = อ

webrtc-sharing-window = คุณกำลังแบ่งปันหน้าต่างแอปพลิเคชันอื่น
webrtc-sharing-browser-window = คุณกำลังแบ่งปัน { -brand-short-name }
webrtc-sharing-screen = คุณกำลังแบ่งปันทั้งหน้าจอของคุณ
webrtc-stop-sharing-button = หยุดการแบ่งปัน
webrtc-microphone-unmuted =
    .title = ปิดไมโครโฟน
webrtc-microphone-muted =
    .title = เปิดไมโครโฟน
webrtc-camera-unmuted =
    .title = ปิดกล้อง
webrtc-camera-muted =
    .title = เปิดกล้อง
webrtc-minimize =
    .title = ย่อตัวบ่งชี้ให้เล็กสุด

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = คุณกำลังแบ่งปันกล้องของคุณ คลิกเพื่อควบคุมการแบ่งปัน
webrtc-microphone-system-menu =
    .label = คุณกำลังแบ่งปันไมโครโฟนของคุณ คลิกเพื่อควบคุมการแบ่งปัน
webrtc-screen-system-menu =
    .label = คุณกำลังแบ่งปันหน้าต่างหรือหน้าจอ คลิกเพื่อควบคุมการแบ่งปัน

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = กล้องและไมโครโฟนของคุณกำลังถูกแบ่งปัน คลิกเพื่อควบคุมการแบ่งปัน
webrtc-indicator-sharing-camera =
    .tooltiptext = กล้องของคุณกำลังถูกแบ่งปัน คลิกเพื่อควบคุมการแบ่งปัน
webrtc-indicator-sharing-microphone =
    .tooltiptext = ไมโครโฟนของคุณกำลังถูกแบ่งปัน คลิกเพื่อควบคุมการแบ่งปัน
webrtc-indicator-sharing-application =
    .tooltiptext = แอปพลิเคชันกำลังถูกแบ่งปัน คลิกเพื่อควบคุมการแบ่งปัน
webrtc-indicator-sharing-screen =
    .tooltiptext = หน้าจอของคุณกำลังถูกแบ่งปัน คลิกเพื่อควบคุมการแบ่งปัน
webrtc-indicator-sharing-window =
    .tooltiptext = หน้าต่างกำลังถูกแบ่งปัน คลิกเพื่อควบคุมการแบ่งปัน
webrtc-indicator-sharing-browser =
    .tooltiptext = แท็บกำลังถูกแบ่งปัน คลิกเพื่อควบคุมการแบ่งปัน

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = ควบคุมการแบ่งปัน
webrtc-indicator-menuitem-control-sharing-on =
    .label = ควบคุมการแบ่งปันบน “{ $streamTitle }”

webrtc-indicator-menuitem-sharing-camera-with =
    .label = กำลังแบ่งปันกล้องกับ “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label = กำลังแบ่งปันกล้องกับ { $tabCount } แท็บ

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = กำลังแบ่งปันไมโครโฟนกับ “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label = กำลังแบ่งปันไมโครโฟนกับ { $tabCount } แท็บ

webrtc-indicator-menuitem-sharing-application-with =
    .label = กำลังแบ่งปันแอปพลิเคชันกับ “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label = กำลังแบ่งปันแอปพลิเคชันกับ { $tabCount } แท็บ

webrtc-indicator-menuitem-sharing-screen-with =
    .label = กำลังแบ่งปันหน้าจอกับ “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label = กำลังแบ่งปันหน้าจอกับ { $tabCount } แท็บ

webrtc-indicator-menuitem-sharing-window-with =
    .label = กำลังแบ่งปันหน้าต่างกับ “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label = กำลังแบ่งปันหน้าต่างกับ { $tabCount } แท็บ

webrtc-indicator-menuitem-sharing-browser-with =
    .label = กำลังแบ่งปันแท็บกับ “{ $streamTitle }”
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label = กำลังแบ่งปันแท็บกับ { $tabCount } แท็บ

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = อนุญาตให้ { $origin } ฟังเสียงของแท็บนี้หรือไม่?
webrtc-allow-share-camera = อนุญาตให้ { $origin } ใช้กล้องของคุณหรือไม่?
webrtc-allow-share-microphone = อนุญาตให้ { $origin } ใช้ไมโครโฟนของคุณหรือไม่?
webrtc-allow-share-screen = อนุญาตให้ { $origin } เห็นหน้าจอของคุณหรือไม่?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = อนุญาตให้ { $origin } ใช้ลำโพงอื่น ๆ หรือไม่?
webrtc-allow-share-camera-and-microphone = อนุญาตให้ { $origin } ใช้กล้องและไมโครโฟนของคุณหรือไม่?
webrtc-allow-share-camera-and-audio-capture = อนุญาตให้ { $origin } ใช้กล้องของคุณและฟังเสียงของแท็บนี้หรือไม่?
webrtc-allow-share-screen-and-microphone = อนุญาตให้ { $origin } ใช้ไมโครโฟนของคุณและเห็นหน้าจอของคุณหรือไม่?
webrtc-allow-share-screen-and-audio-capture = อนุญาตให้ { $origin } ฟังเสียงของแท็บนี้และเห็นหน้าจอของคุณหรือไม่?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = อนุญาตให้ { $origin } มอบสิทธิอนุญาตให้กับ { $thirdParty } ในการฟังเสียงของแท็บนี้หรือไม่?
webrtc-allow-share-camera-unsafe-delegation = อนุญาตให้ { $origin } มอบสิทธิให้กับ { $thirdParty } ในการเข้าถึงกล้องของคุณหรือไม่?
webrtc-allow-share-microphone-unsafe-delegation = อนุญาตให้ { $origin } มอบสิทธิให้กับ { $thirdParty } ในการเข้าถึงไมโครโฟนของคุณหรือไม่?
webrtc-allow-share-screen-unsafe-delegation = อนุญาตให้ { $origin } มอบสิทธิอนุญาตให้กับ { $thirdParty } ในการดูหน้าจอของคุณหรือไม่?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = อนุญาตให้ { $origin } มอบสิทธิให้กับ { $thirdParty } ในการเข้าถึงลำโพงอื่น ๆ หรือไม่?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = อนุญาตให้ { $origin } มอบสิทธิให้กับ { $thirdParty } ในการเข้าถึงกล้องและไมโครโฟนของคุณหรือไม่?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = อนุญาตให้ { $origin } มอบสิทธิให้กับ { $thirdParty } ในการเข้าถึงกล้องและฟังเสียงของแท็บนี้หรือไม่?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = อนุญาตให้ { $origin } มอบสิทธิให้กับ { $thirdParty } ในการเข้าถึงไมโครโฟนของคุณและดูหน้าจอของคุณหรือไม่?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = อนุญาตให้ { $origin } มอบสิทธิอนุญาตให้กับ { $thirdParty } ในการฟังเสียงของแท็บนี้และดูหน้าจอของคุณหรือไม่?

##

webrtc-share-screen-warning = โปรดแบ่งปันหน้าจอเฉพาะกับไซต์ที่คุณเชื่อถือเท่านั้น การแบ่งปันอาจอนุญาตให้ไซต์หลอกลวงเรียกดูในชื่อคุณและขโมยข้อมูลส่วนตัวของคุณ
webrtc-share-browser-warning = โปรดแบ่งปัน { -brand-short-name } เฉพาะกับไซต์ที่คุณเชื่อถือเท่านั้น การแบ่งปันอาจอนุญาตให้ไซต์หลอกลวงเรียกดูในชื่อคุณและขโมยข้อมูลส่วนตัวของคุณ

webrtc-share-screen-learn-more = เรียนรู้เพิ่มเติม
webrtc-pick-window-or-screen = เลือกหน้าต่างหรือหน้าจอ
webrtc-share-entire-screen = ทั้งหน้าจอ
webrtc-share-pipe-wire-portal = ใช้การตั้งค่าระบบปฏิบัติการ
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = หน้าจอ { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application = { $appName } ({ $windowCount } หน้าต่าง)

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = อนุญาต
    .accesskey = อ
webrtc-action-block =
    .label = ปิดกั้น
    .accesskey = ป
webrtc-action-always-block =
    .label = ปิดกั้นเสมอ
    .accesskey = ส
webrtc-action-not-now =
    .label = ไม่ใช่ตอนนี้
    .accesskey = ม

##

webrtc-remember-allow-checkbox = จดจำการตัดสินใจนี้
webrtc-mute-notifications-checkbox = ปิดเสียงการแจ้งเตือนเว็บไซต์ขณะแบ่งปัน

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name } ไม่สามารถอนุญาตการเข้าถึงแบบถาวรให้กับหน้าจอของคุณได้
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name } ไม่อนุญาตให้เข้าถึงแท็บของคุณแบบถาวรโดยไม่ถามว่าจะแบ่งปันแท็บไหน
webrtc-reason-for-no-permanent-allow-insecure = การเชื่อมต่อของคุณไปยังไซต์นี้ไม่ปลอดภัย เพื่อปกป้องคุณ { -brand-short-name } จะอนุญาตให้เข้าถึงเฉพาะในวาระนี้เท่านั้น
