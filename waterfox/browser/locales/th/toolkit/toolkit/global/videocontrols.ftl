# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = ตําแหน่ง
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = กำลังโหลด:
videocontrols-volume-control =
    .aria-label = ระดับเสียง
videocontrols-closed-caption-button =
    .aria-label = คำบรรยายแบบปิด

videocontrols-play-button =
    .aria-label = เล่น
videocontrols-pause-button =
    .aria-label = หยุดชั่วคราว
videocontrols-mute-button =
    .aria-label = ปิดเสียง
videocontrols-unmute-button =
    .aria-label = เลิกปิดเสียง
videocontrols-enterfullscreen-button =
    .aria-label = เต็มหน้าจอ
videocontrols-exitfullscreen-button =
    .aria-label = ออกจากภาพเต็มหน้าจอ
videocontrols-casting-button-label =
    .aria-label = ฉายขึ้นหน้าจอ
videocontrols-closed-caption-off =
    .offlabel = ปิด

# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = ภาพที่เล่นควบคู่

# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = ดูในแบบภาพที่เล่นควบคู่

# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = เล่นวิดีโอในเบื้องหน้าขณะที่คุณทำอย่างอื่นใน { -brand-short-name }

videocontrols-error-aborted = วิดีโอหยุดโหลด
videocontrols-error-network = การเล่นวิดีโอถูกยกเลิกเนื่องจากข้อผิดพลาดทางเครือข่าย
videocontrols-error-decode = ไม่สามารถเล่นวิดีโอได้เนื่องจากไฟล์เสียหาย
videocontrols-error-src-not-supported = ไม่สามารถเล่นวิดีโอรูปแบบนี้ หรือ MIME ชนิดนี้ได้
videocontrols-error-no-source = ไม่พบวิดีโอที่อยู่ในรูปแบบหรือชนิดของ MIME ที่เล่นได้
videocontrols-error-generic = การเล่นวิดีโอถูกยกเลิกเนื่องจากข้อผิดพลาดที่ไม่ระบุไม่ได้
videocontrols-status-picture-in-picture = วิดีโอนี้กำลังเล่นในโหมดภาพที่เล่นควบคู่

# This message shows the current position and total video duration
#
# Variables:
#   $position (String): The current media position
#   $duration (String): The total video duration
#
# For example, when at the 5 minute mark in a 6 hour long video,
# $position would be "5:00" and $duration would be "6:00:00", result
# string would be "5:00 / 6:00:00". Note that $duration is not always
# available. For example, when at the 5 minute mark in an unknown
# duration video, $position would be "5:00" and the string which is
# surrounded by <span> would be deleted, result string would be "5:00".
videocontrols-position-and-duration-labels = { $position }<span data-l10n-name="position-duration-format"> / { $duration }</span>
