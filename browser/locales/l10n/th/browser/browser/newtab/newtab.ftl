# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Waterfox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = แท็บใหม่
newtab-settings-button =
    .title = ปรับแต่งหน้าแท็บใหม่ของคุณ
newtab-personalize-icon-label =
    .title = ปรับแท็บใหม่ให้เป็นส่วนตัว
    .aria-label = ปรับแท็บใหม่ให้เป็นส่วนตัว
newtab-personalize-dialog-label =
    .aria-label = ปรับให้เป็นแบบส่วนตัว

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = ค้นหา
    .aria-label = ค้นหา
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = ค้นหาด้วย { $engine } หรือป้อนที่อยู่
newtab-search-box-handoff-text-no-engine = ค้นหาหรือป้อนที่อยู่
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = ค้นหาด้วย { $engine } หรือป้อนที่อยู่
    .title = ค้นหาด้วย { $engine } หรือป้อนที่อยู่
    .aria-label = ค้นหาด้วย { $engine } หรือป้อนที่อยู่
newtab-search-box-handoff-input-no-engine =
    .placeholder = ค้นหาหรือป้อนที่อยู่
    .title = ค้นหาหรือป้อนที่อยู่
    .aria-label = ค้นหาหรือป้อนที่อยู่
newtab-search-box-search-the-web-input =
    .placeholder = ค้นหาเว็บ
    .title = ค้นหาเว็บ
    .aria-label = ค้นหาเว็บ
newtab-search-box-text = ค้นหาเว็บ
newtab-search-box-input =
    .placeholder = ค้นหาเว็บ
    .aria-label = ค้นหาเว็บ

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = เพิ่มเครื่องมือค้นหา
newtab-topsites-add-topsites-header = ไซต์เด่นใหม่
newtab-topsites-add-shortcut-header = ทางลัดใหม่
newtab-topsites-edit-topsites-header = แก้ไขไซต์เด่น
newtab-topsites-edit-shortcut-header = แก้ไขทางลัด
newtab-topsites-title-label = ชื่อเรื่อง
newtab-topsites-title-input =
    .placeholder = ป้อนชื่อเรื่อง
newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = พิมพ์หรือวาง URL
newtab-topsites-url-validation = ต้องการ URL ที่ถูกต้อง
newtab-topsites-image-url-label = URL ภาพที่กำหนดเอง
newtab-topsites-use-image-link = ใช้ภาพที่กำหนดเอง…
newtab-topsites-image-validation = ไม่สามารถโหลดภาพ ลอง URL อื่น

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = ยกเลิก
newtab-topsites-delete-history-button = ลบออกจากประวัติ
newtab-topsites-save-button = บันทึก
newtab-topsites-preview-button = แสดงตัวอย่าง
newtab-topsites-add-button = เพิ่ม

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = คุณแน่ใจหรือไม่ว่าต้องการลบทุกอินสแตนซ์ของหน้านี้ออกจากประวัติของคุณ?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = การกระทำนี้ไม่สามารถเลิกทำได้

## Top Sites - Sponsored label

newtab-topsite-sponsored = ได้รับการสนับสนุน

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = เปิดเมนู
    .aria-label = เปิดเมนู
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = เอาออก
    .aria-label = เอาออก
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = เปิดเมนู
    .aria-label = เปิดเมนูบริบทสำหรับ { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = แก้ไขไซต์นี้
    .aria-label = แก้ไขไซต์นี้

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = แก้ไข
newtab-menu-open-new-window = เปิดในหน้าต่างใหม่
newtab-menu-open-new-private-window = เปิดในหน้าต่างส่วนตัวใหม่
newtab-menu-dismiss = ยกเลิก
newtab-menu-pin = ปักหมุด
newtab-menu-unpin = ถอนหมุด
newtab-menu-delete-history = ลบออกจากประวัติ
newtab-menu-save-to-pocket = บันทึกไปยัง { -pocket-brand-name }
newtab-menu-delete-pocket = ลบจาก { -pocket-brand-name }
newtab-menu-archive-pocket = เก็บถาวรใน { -pocket-brand-name }
newtab-menu-show-privacy-info = สปอนเซอร์ของเราและความเป็นส่วนตัวของคุณ

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = เสร็จสิ้น
newtab-privacy-modal-button-manage = จัดการการตั้งค่าเนื้อหาที่ได้รับการสนับสนุน
newtab-privacy-modal-header = ความเป็นส่วนตัวของคุณสำคัญ
newtab-privacy-modal-paragraph-2 =
    นอกเหนือจากการนำเสนอเรื่องราวที่น่าสนใจ เรายังแสดงให้คุณเห็นเนื้อหาที่เกี่ยวข้อง
    ซึ่งได้รับการตรวจสอบอย่างละเอียดจากผู้สนับสนุนที่ได้รับการคัดเลือก ทำให้คุณมั่นใจ
    ได้ว่า<strong>ข้อมูลการเรียกดูของคุณจะไม่ทิ้งสำเนาส่วนตัวของ { -brand-product-name } ของคุณ</strong>ซึ่งเราและ
    สปอนเซอร์ของเราจะไม่เห็น
newtab-privacy-modal-link = เรียนรู้วิธีการปกป้องความเป็นส่วนตัวในแท็บใหม่

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = เอาที่คั่นหน้าออก
# Bookmark is a verb here.
newtab-menu-bookmark = เพิ่มที่คั่นหน้า

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = คัดลอกลิงก์ดาวน์โหลด
newtab-menu-go-to-download-page = ไปยังหน้าดาวน์โหลด
newtab-menu-remove-download = เอาออกจากประวัติ

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] แสดงใน Finder
       *[other] เปิดโฟลเดอร์ที่บรรจุ
    }
newtab-menu-open-file = เปิดไฟล์

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = เยี่ยมชมแล้ว
newtab-label-bookmarked = เพิ่มที่คั่นหน้าแล้ว
newtab-label-removed-bookmark = เอาที่คั่นหน้าออกแล้ว
newtab-label-recommended = กำลังนิยม
newtab-label-saved = บันทึกไปยัง { -pocket-brand-name } แล้ว
newtab-label-download = ดาวน์โหลดแล้ว
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · ผู้สนับสนุน
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = สนับสนุนโดย { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = เอาส่วนออก
newtab-section-menu-collapse-section = ยุบส่วน
newtab-section-menu-expand-section = ขยายส่วน
newtab-section-menu-manage-section = จัดการส่วน
newtab-section-menu-manage-webext = จัดการส่วนขยาย
newtab-section-menu-add-topsite = เพิ่มไซต์เด่น
newtab-section-menu-add-search-engine = เพิ่มเครื่องมือค้นหา
newtab-section-menu-move-up = ย้ายขึ้น
newtab-section-menu-move-down = ย้ายลง
newtab-section-menu-privacy-notice = ประกาศความเป็นส่วนตัว

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = ยุบส่วน
newtab-section-expand-section-label =
    .aria-label = ขยายส่วน

## Section Headers.

newtab-section-header-topsites = ไซต์เด่น
newtab-section-header-highlights = รายการเด่น
newtab-section-header-recent-activity = กิจกรรมล่าสุด
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = แนะนำโดย { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = เริ่มเรียกดูและเราจะแสดงบทความ วิดีโอ และหน้าอื่น ๆ บางส่วนที่ยอดเยี่ยมที่คุณได้เยี่ยมชมหรือเพิ่มที่คั่นหน้าไว้ล่าสุดที่นี่
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = คุณได้อ่านเรื่องราวครบทั้งหมดแล้ว คุณสามารถกลับมาตรวจดูเรื่องราวเด่นจาก { $provider } ได้ภายหลัง อดใจรอไม่ได้งั้นหรือ? เลือกหัวข้อยอดนิยมเพื่อค้นหาเรื่องราวที่ยอดเยี่ยมจากเว็บต่าง ๆ

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = คุณได้อ่านเรื่องราวครบทั้งหมดแล้ว!
newtab-discovery-empty-section-topstories-content = คุณสามารถกลับมาตรวจดูเรื่องราวเพิ่มเติมได้ภายหลัง
newtab-discovery-empty-section-topstories-try-again-button = ลองอีกครั้ง
newtab-discovery-empty-section-topstories-loading = กำลังโหลด…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = อุ๊ปส์! เราโหลดส่วนนี้เกือบเสร็จแล้ว แต่ยังไม่เสร็จดี

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = หัวข้อยอดนิยม:
newtab-pocket-more-recommendations = คำแนะนำเพิ่มเติม
newtab-pocket-learn-more = เรียนรู้เพิ่มเติม
newtab-pocket-cta-button = รับ { -pocket-brand-name }
newtab-pocket-cta-text = บันทึกเรื่องราวที่คุณรักลงใน { -pocket-brand-name } และเติมเต็มสมองของคุณด้วยบทความที่น่าหลงใหล

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = อุปส์ มีบางอย่างผิดพลาดในการโหลดเนื้อหานี้
newtab-error-fallback-refresh-link = เรียกหน้าใหม่เพื่อลองอีกครั้ง

## Customization Menu

newtab-custom-shortcuts-title = ทางลัด
newtab-custom-shortcuts-subtitle = ไซต์ที่คุณบันทึกหรือเยี่ยมชม
newtab-custom-row-selector =
    { $num ->
       *[other] { $num } แถว
    }
newtab-custom-sponsored-sites = ทางลัดที่ได้รับการสนับสนุน
newtab-custom-pocket-title = แนะนำโดย { -pocket-brand-name }
newtab-custom-pocket-subtitle = เนื้อหาสุดพิเศษที่คัดสรรโดย { -pocket-brand-name } ซึ่งเป็นส่วนหนึ่งของตระกูล { -brand-product-name }
newtab-custom-pocket-sponsored = เรื่องราวที่ได้รับการสนับสนุน
newtab-custom-recent-title = กิจกรรมล่าสุด
newtab-custom-recent-subtitle = ไซต์และเนื้อหาล่าสุดที่คัดสรรมา
newtab-custom-close-button = ปิด
newtab-custom-settings = จัดการการตั้งค่าเพิ่มเติม
