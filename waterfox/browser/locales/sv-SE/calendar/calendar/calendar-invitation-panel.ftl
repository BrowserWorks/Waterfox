# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $organizer (String) - The participant that created the original invitation.
calendar-invitation-panel-intro = { $organizer } har bjudit in dig till:
# Variables:
# $summary (String) - A short summary or title of the event.
calendar-invitation-panel-title = { $summary }
calendar-invitation-panel-action-button = Spara
calendar-invitation-panel-accept-button = Ja
calendar-invitation-panel-decline-button = Nej
calendar-invitation-panel-tentative-button = Kanske
calendar-invitation-panel-reply-status = * Du har inte bestämt dig eller svarat ännu
calendar-invitation-panel-prop-title-when = När:
calendar-invitation-panel-prop-title-location = Plats:
# Variables:
# $dayOfWeek (String) - The day of the week for a given date.
# $date (String) - The date example: Tuesday, February 24, 2022.
calendar-invitation-datetime-date = { $dayOfWeek }, { $date }
# Variables:
# $time (String) - The time part of a datetime using the "short" timeStyle.
# $timezone (String) - The timezone info for the datetime.
calendar-invitation-datetime-time = { $time } ({ $timezone })
calendar-invitation-panel-prop-title-attendees = Deltagare:
calendar-invitation-panel-prop-title-description = Beskrivning:
# Variables:
# $count (Number) - The number of attendees with the "ACCEPTED" participation status.
calendar-invitation-panel-partstat-accepted = { $count } ja
# Variables:
# $count (Number) - The number of attendees with the "DECLINED" participation status.
calendar-invitation-panel-partstat-declined = { $count } nej
# Variables:
# $count (Number) - The number of attendees with the "TENTATIVE" participation status.
calendar-invitation-panel-partstat-tentative = { $count } kanske
# Variables:
# $count (Number) - The number of attendees with the "NEEDS-ACTION" participation status.
calendar-invitation-panel-partstat-needs-action = { $count } väntande
# Variables:
# $count (Number) - The total number of attendees.
calendar-invitation-panel-partstat-total = { $count } deltagare
