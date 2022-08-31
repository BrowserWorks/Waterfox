# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $organizer (String) - The participant that created the original invitation.
calendar-invitation-panel-intro = { $organizer } があなたを招待しています: 
# Variables:
# $summary (String) - A short summary or title of the event.
calendar-invitation-panel-title = { $summary }
calendar-invitation-panel-action-button = 保存
calendar-invitation-panel-accept-button = 承諾
calendar-invitation-panel-decline-button = 辞退
calendar-invitation-panel-tentative-button = 仮承諾
calendar-invitation-panel-reply-status = * 未確定またはまだ返答していません
calendar-invitation-panel-prop-title-when = 日時:
calendar-invitation-panel-prop-title-location = 場所:
# Variables:
# $dayOfWeek (String) - The day of the week for a given date.
# $date (String) - The date example: Tuesday, February 24, 2022.
calendar-invitation-datetime-date = { $date } { $dayOfWeek }
# Variables:
# $time (String) - The time part of a datetime using the "short" timeStyle.
# $timezone (String) - The timezone info for the datetime.
calendar-invitation-datetime-time = { $time } ({ $timezone })
calendar-invitation-panel-prop-title-attendees = 参加者:
calendar-invitation-panel-prop-title-description = 詳細:
# Variables:
# $count (Number) - The number of attendees with the "ACCEPTED" participation status.
calendar-invitation-panel-partstat-accepted = 承諾 { $count } 名
# Variables:
# $count (Number) - The number of attendees with the "DECLINED" participation status.
calendar-invitation-panel-partstat-declined = 辞退 { $count } 名
# Variables:
# $count (Number) - The number of attendees with the "TENTATIVE" participation status.
calendar-invitation-panel-partstat-tentative = 仮承諾 { $count } 名
# Variables:
# $count (Number) - The number of attendees with the "NEEDS-ACTION" participation status.
calendar-invitation-panel-partstat-needs-action = 留保 { $count } 名
# Variables:
# $count (Number) - The total number of attendees.
calendar-invitation-panel-partstat-total = 参加合計 { $count } 名
