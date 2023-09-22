# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = يُحمّل:
videocontrols-volume-control =
    .aria-label = مستوى الصوت

videocontrols-play-button =
    .aria-label = شغّل
videocontrols-pause-button =
    .aria-label = ألبِث
videocontrols-mute-button =
    .aria-label = اكتم الصوت
videocontrols-unmute-button =
    .aria-label = أطلِق الصوت
videocontrols-enterfullscreen-button =
    .aria-label = ملء الشاشة
videocontrols-exitfullscreen-button =
    .aria-label = غادر ملء الشاشة
videocontrols-casting-button-label =
    .aria-label = اعرض على الشاشة
videocontrols-closed-caption-off =
    .offlabel = بدون

# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = ڤديو معترِض

videocontrols-error-aborted = توقف تحميل الفديو.
videocontrols-error-network = توقف تشغيل الفديو بسبب عُطل شبكي.
videocontrols-error-decode = تعذّر تشغيل الفديو لعطب في الملف.
videocontrols-error-src-not-supported = نسق أو نوع MIME الفديو غير مدعوم.
videocontrols-error-no-source = لم يُعثر على فديو بنسق أو نوع MIME مدعوم.
videocontrols-error-generic = توقف تشغيل الفديو بسبب عُطل غير معروف.
videocontrols-status-picture-in-picture = يعمل هذا الڤديو في وضع الڤديوهات المعترِضة.

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
videocontrols-position-and-duration-labels = { $position }‏<span data-l10n-name="position-duration-format"> \‏ { $duration }</span>

# This is a plain text version of the videocontrols-position-and-duration-labels
# string, used by screenreaders.
#
# Variables:
#   $position (String): The current media position
#   $duration (String): The total video duration
videocontrols-scrubber-position-and-duration =
    .aria-label = المكان
    .aria-valuetext = { $position }‏ \‏ { $duration }
