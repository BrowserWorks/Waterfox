# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Posición
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Cargando:
videocontrols-volume-control =
    .aria-label = Volumen
videocontrols-closed-caption-button =
    .aria-label = Subtítulos
videocontrols-play-button =
    .aria-label = Reproducir
videocontrols-pause-button =
    .aria-label = Pausar
videocontrols-mute-button =
    .aria-label = Silenciar
videocontrols-unmute-button =
    .aria-label = Escuchar
videocontrols-enterfullscreen-button =
    .aria-label = Pantalla completa
videocontrols-exitfullscreen-button =
    .aria-label = Salir de pantalla completa
videocontrols-casting-button-label =
    .aria-label = Enviar a pantalla
videocontrols-closed-caption-off =
    .offlabel = Desactivar
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Picture-in-Picture
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Ver en Picture-in-Picture
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Reproduce videos en primer plano mientras haces otras cosas en { -brand-short-name }
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Saca este video
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = Más pantallas son más divertidas. Reproduce este video en Picture-in-Picture mientras navega.
videocontrols-error-aborted = Se detuvo la carga del video.
videocontrols-error-network = Reproducción de video interrumpida por un error de red.
videocontrols-error-decode = No puede reproducirse el video porque el archivo está corrupto.
videocontrols-error-src-not-supported = El formato o tipo MIME del video no se admite.
videocontrols-error-no-source = No se encontró ningún video que tenga un formato y tipo MIME compatibles.
videocontrols-error-generic = La reproducción del video se detuvo por un error desconocido.
videocontrols-status-picture-in-picture = Este video se está reproduciendo en modo Picture-in-Picture.
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
