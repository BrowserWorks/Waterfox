# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $organizer (String) - The participant that created the original invitation.
calendar-invitation-panel-intro = Organizátor { $organizer } vás pozval:
# Variables:
# $summary (String) - A short summary or title of the event.
calendar-invitation-panel-title = { $summary }
calendar-invitation-panel-action-button = Uložit
calendar-invitation-panel-accept-button = Ano
calendar-invitation-panel-decline-button = Ne
calendar-invitation-panel-tentative-button = Možná
calendar-invitation-panel-reply-status = * Zatím jste se nerozhodli nebo neodpověděli
calendar-invitation-panel-prop-title-when = Kdy:
calendar-invitation-panel-prop-title-location = Místo:
# Variables:
# $dayOfWeek (String) - The day of the week for a given date.
# $date (String) - The date example: Tuesday, February 24, 2022.
calendar-invitation-datetime-date = { $dayOfWeek } { $date }
# Variables:
# $time (String) - The time part of a datetime using the "short" timeStyle.
# $timezone (String) - The timezone info for the datetime.
calendar-invitation-datetime-time = { $time } ({ $timezone })
calendar-invitation-panel-prop-title-attendees = Účastníci:
calendar-invitation-panel-prop-title-description = Popis:
# Variables:
# $count (Number) - The number of attendees with the "ACCEPTED" participation status.
calendar-invitation-panel-partstat-accepted = { $count } se zúčastní
# Variables:
# $count (Number) - The number of attendees with the "DECLINED" participation status.
calendar-invitation-panel-partstat-declined = { $count } se nezúčastní
# Variables:
# $count (Number) - The number of attendees with the "TENTATIVE" participation status.
calendar-invitation-panel-partstat-tentative = { $count } možná
# Variables:
# $count (Number) - The number of attendees with the "NEEDS-ACTION" participation status.
calendar-invitation-panel-partstat-needs-action = { $count } se ještě nerozhodli
# Variables:
# $count (Number) - The total number of attendees.
calendar-invitation-panel-partstat-total = { $count } účastníků
