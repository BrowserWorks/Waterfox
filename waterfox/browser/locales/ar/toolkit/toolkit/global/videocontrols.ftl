# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = المكان
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

# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = شاهِده بوضع الڤديو المعترِض

# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = شاهِد الڤديو أمام المتصفّح بينما تؤدي مهامك الأخرى في { -brand-short-name }

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
