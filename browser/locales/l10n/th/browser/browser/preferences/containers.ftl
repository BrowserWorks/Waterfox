# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = เพิ่มการแยกข้อมูลใหม่
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = ค่ากำหนดการแยกข้อมูล { $name }
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = การตั้งค่าการแยกข้อมูล { $name }
    .style = width: 45em
containers-window-close =
    .key = w
# This is a term to store style to be applied
# on the three labels in the containers add/edit dialog:
#   - name
#   - icon
#   - color
#
# Using this term and referencing it in the `.style` attribute
# of the three messages ensures that all three labels
# will be aligned correctly.
-containers-labels-style = min-width: 4rem
containers-name-label = ชื่อ
    .accesskey = ช
    .style = { -containers-labels-style }
containers-name-text =
    .placeholder = ป้อนชื่อการแยกข้อมูล
containers-icon-label = ไอคอน
    .accesskey = อ
    .style = { -containers-labels-style }
containers-color-label = สี
    .accesskey = ส
    .style = { -containers-labels-style }
containers-button-done =
    .label = เสร็จสิ้น
    .accesskey = ร
containers-dialog =
    .buttonlabelaccept = เสร็จสิ้น
    .buttonaccesskeyaccept = ร
containers-color-blue =
    .label = น้ำเงิน
containers-color-turquoise =
    .label = ฟ้าเทอร์คอยส์
containers-color-green =
    .label = เขียว
containers-color-yellow =
    .label = เหลือง
containers-color-orange =
    .label = ส้ม
containers-color-red =
    .label = แดง
containers-color-pink =
    .label = ชมพู
containers-color-purple =
    .label = ม่วง
containers-color-toolbar =
    .label = จับคู่แถบเครื่องมือ
containers-icon-fence =
    .label = รั้ว
containers-icon-fingerprint =
    .label = ลายนิ้วมือ
containers-icon-briefcase =
    .label = กระเป๋าเอกสาร
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = เครื่องหมายดอลลาร์
containers-icon-cart =
    .label = รถเข็นซื้อของ
containers-icon-circle =
    .label = จุด
containers-icon-vacation =
    .label = วันหยุดพักผ่อน
containers-icon-gift =
    .label = ของขวัญ
containers-icon-food =
    .label = อาหาร
containers-icon-fruit =
    .label = ผลไม้
containers-icon-pet =
    .label = สัตว์เลี้ยง
containers-icon-tree =
    .label = ต้นไม้
containers-icon-chill =
    .label = ผ่อนคลาย
