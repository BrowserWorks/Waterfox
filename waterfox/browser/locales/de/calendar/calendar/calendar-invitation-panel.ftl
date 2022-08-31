# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $organizer (String) - The participant that created the original invitation.
calendar-invitation-panel-intro = { $organizer } hat Sie eingeladen zu: 

# Variables:
# $summary (String) - A short summary or title of the event.
calendar-invitation-panel-title = { $summary }

calendar-invitation-panel-action-button = Speichern

calendar-invitation-panel-accept-button = Ja

calendar-invitation-panel-decline-button = Nein

calendar-invitation-panel-tentative-button = Vorläufig

calendar-invitation-panel-reply-status = * Sie haben sich nicht entschieden bzw. geantwortet.

calendar-invitation-panel-prop-title-when = Zeit:

calendar-invitation-panel-prop-title-location = Ort:

# Variables:
# $dayOfWeek (String) - The day of the week for a given date.
# $date (String) - The date example: Tuesday, February 24, 2022.
calendar-invitation-datetime-date = { $dayOfWeek }, { $date }

# Variables:
# $time (String) - The time part of a datetime using the "short" timeStyle.
# $timezone (String) - The timezone info for the datetime.
calendar-invitation-datetime-time = { $time } ({ $timezone })

calendar-invitation-panel-prop-title-attendees = Teilnehmer:

calendar-invitation-panel-prop-title-description = Beschreibung:

# Variables:
# $count (Number) - The number of attendees with the "ACCEPTED" participation status.
calendar-invitation-panel-partstat-accepted = { $count } ja

# Variables:
# $count (Number) - The number of attendees with the "DECLINED" participation status.
calendar-invitation-panel-partstat-declined = { $count } nein

# Variables:
# $count (Number) - The number of attendees with the "TENTATIVE" participation status.
calendar-invitation-panel-partstat-tentative = { $count } vorläufig

# Variables:
# $count (Number) - The number of attendees with the "NEEDS-ACTION" participation status.
calendar-invitation-panel-partstat-needs-action = { $count } ausstehend

# Variables:
# $count (Number) - The total number of attendees.
calendar-invitation-panel-partstat-total = { $count } Teilnehmer
