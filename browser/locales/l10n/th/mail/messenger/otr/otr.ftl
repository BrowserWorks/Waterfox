# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = คุณได้รับข้อความที่ถูกเข้ารหัสซึ่งไม่สามารถอ่านได้จาก { $name }

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = คุณได้รับข้อความข้อมูลที่ผิดรูปแบบจาก { $name }

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = ได้รับฮาร์ตบีตจาก { $name }

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = ส่งฮาร์ตบีตไปที่ { $name } แล้ว

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = เกิดข้อผิดพลาดที่ไม่คาดคิดขณะพยายามปกป้องการสนทนาของคุณโดยใช้ OTR

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = ข้อความที่ได้รับจาก { $name } ต่อไปนี้ไม่ได้ถูกเข้ารหัส: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = คุณได้รับข้อความ OTR ที่ไม่รู้จักจาก { $name }

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = เริ่มการสนทนาแบบส่วนตัวกับ { $name } แล้ว

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = เข้ารหัสแล้ว แต่เริ่มการสนทนาที่ยังไม่ยืนยันกับ { $name } แล้ว

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = การเรียกการสนทนาแบบเข้ารหัสกับ { $name } ใหม่สำเร็จแล้ว

error-enc = เกิดข้อผิดพลาดขณะเข้ารหัสข้อความ

error-unreadable = คุณส่งข้อความที่เข้ารหัสซึ่งไม่สามารถอ่านได้
error-malformed = คุณส่งข้อความข้อมูลที่ผิดรูปแบบ

resent = [ส่งใหม่]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } ได้สิ้นสุดการสนทนาแบบเข้ารหัสของพวกเขากับคุณแล้ว คุณควรสิ้นสุดการสนทนาเช่นกัน

