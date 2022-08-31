# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Позиция
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Загрузка:
videocontrols-volume-control =
    .aria-label = Громкость
videocontrols-closed-caption-button =
    .aria-label = Субтитры
videocontrols-play-button =
    .aria-label = Воспроизвести
videocontrols-pause-button =
    .aria-label = Приостановить
videocontrols-mute-button =
    .aria-label = Отключить звук
videocontrols-unmute-button =
    .aria-label = Включить звук
videocontrols-enterfullscreen-button =
    .aria-label = Полный экран
videocontrols-exitfullscreen-button =
    .aria-label = Выйти из полноэкранного режима
videocontrols-casting-button-label =
    .aria-label = Транслировать на экран
videocontrols-closed-caption-off =
    .offlabel = Выкл.
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Картинка в картинке
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Смотреть в режиме «Картинка в картинке»
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Воспроизводите видео на переднем плане, пока вы занимаетесь другими делами в { -brand-short-name }
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Открепить видео
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = Больше экранов — веселее. Воспроизводите это видео в режиме «Картинка в картинке» во время веб-сёрфинга.
videocontrols-error-aborted = Загрузка видео остановлена.
videocontrols-error-network = Воспроизведение видео прервано из-за ошибки сети.
videocontrols-error-decode = Видео не может быть воспроизведено, так как файл повреждён.
videocontrols-error-src-not-supported = Формат видео или MIME-тип не поддерживается.
videocontrols-error-no-source = Видео в поддерживаемом формате и MIME-типе не найдено.
videocontrols-error-generic = Воспроизведение видео прервано из-за неизвестной ошибки.
videocontrols-status-picture-in-picture = Это видео воспроизводится в режиме «Картинка в картинке».
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
