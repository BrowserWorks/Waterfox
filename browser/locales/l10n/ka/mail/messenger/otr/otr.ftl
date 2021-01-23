# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = თქვენ სცადეთ გაგეგზავნათ დაუშიფრავი წერილი პირისთვის { $name }. დებულების მიხედვით, დაუშიფრავი წერილები არაა ნებადართული.

msgevent-encryption_required_part2 = მცდელობა პირადი საუბრის წამოსაწყებად. თქვენი შეტყობინება ხელახლა გაიგზავნება, როცა პირადი საუბარი დაიწყება.
msgevent-encryption_error = შეცდომა თქვენი შეტყობინების დაშიფვრისას. წერილი არ გაიგზავნა.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = { $name } უკვე ასრულებს დაშიფრულ კავშირს თქვენთან. შემთხვევით რომ არ გაგზავნოთ შეტყობინება დაუშიფრავად, თქვენი წერილი არ გაიგზავნება. გთხოვთ, თქვენც დაასრულოთ დაშიფრული საუბარი ან ხელახლა წამოიწყოთ.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = შეცდომა, პირადი საუბრის გამართვისას პირთან { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = თქვენ იღებთ საკუთარ OTR-წერილებს. თქვენ ან საკუთარ თავთან ცდილობთ საუბრის წამოწყებას, ან ვიღაც უკან აბრუნებს თქვენს შეტყობინებებს.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = ბოლო შეტყობინება, ხელახლა გაეგზავნება პირს { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = დაშიფრული შეტყობინება, რომელსაც გზავნის { $name } არ იკითხება, ვინაიდან ამჟამად არ იყენებთ პირად კავშირს.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = თქვენ მიიღეთ ამოუკითხავი დაშიფრული შეტყობინება, რომელსაც გიგზავნით { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = თქვენ მიიღეთ გაუმართავი მონაცემებით შეტყობინება, რომელსაც გიგზავნით { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = თქვენ მიიღეთ Heartbeat, რომელსაც გიგზავნით { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = Heartbeat გაიგზავნა პირისთვის { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = მოულოდნელი შეცდომა, საუბრის OTR-ით დაცვისას.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = { $name } გიგზავნით მოცემულ შეტყობინებას, რომელიც დაუშიფრავია: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = თქვენ მიიღეთ ამოუცნობი OTR-შეტყობინება, რომელსაც გიგზავნით { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = { $name } გიგზავნით შეტყობინებას სხვა სეანსიდან. თუ შესული ხართ რამდენჯერმე, სხვა სეანსზე შეიძლება იყოს მიღებული ეს წერილი.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = პირადი საუბარი პირთან { $name }, წამოწყებულია.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = დაშიფრული, მაგრამ დაუმოწმებელი საუბარი პირთან { $name }, წამოწყებულია.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = დაშიფრული საუბარი წარმატებით განახლდა პირთან { $name }.

error-enc = წარმოიქმნა შეცდომა, შეტყობინების დაშიფვრისას.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = { $name } მიიღებს თქვენ მიერ გაგზავნილ დაშიფრულ მონაცემებს, რომელთაც არ ელის.

error-unreadable = თქვენ გადაგზავნეთ ამოუკითხავი დაშიფრული შეტყობინება.
error-malformed = თქვენ გადაგზავნეთ შეტყობინება გაუმართავი მონაცემებით.

resent = [კვლავ გაგზავნილი]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } პირმა დაასრულა დაშიფრული საუბარი თქვენთან; თქვენც იგივე უნდა გააკეთოთ.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } ითხოვს არასაჯარო, Off-the-Record (OTR) დაშიფრულ საუბარს. თუმცა, თქვენ არ გაქვთ საჭირო მოდული. ვრცლად, იხილეთ https://en.wikipedia.org/wiki/Off-the-Record_Messaging
