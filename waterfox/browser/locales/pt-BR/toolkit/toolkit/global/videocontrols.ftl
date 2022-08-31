# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Posição
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Carregando:
videocontrols-volume-control =
    .aria-label = Volume
videocontrols-closed-caption-button =
    .aria-label = Legendas ocultas
videocontrols-play-button =
    .aria-label = Executar
videocontrols-pause-button =
    .aria-label = Pausa
videocontrols-mute-button =
    .aria-label = Silenciar
videocontrols-unmute-button =
    .aria-label = Ativar som
videocontrols-enterfullscreen-button =
    .aria-label = Tela inteira
videocontrols-exitfullscreen-button =
    .aria-label = Sair da tela inteira
videocontrols-casting-button-label =
    .aria-label = Transmitir para tela
videocontrols-closed-caption-off =
    .offlabel = Desligar
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Picture-in-Picture
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Assistir em Picture-in-Picture
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Reproduza vídeos em primeiro plano enquanto faz outras coisas no { -brand-short-name }
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Destacar este vídeo
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = Mais telas são mais divertidas. Reproduza este vídeo em picture-in-picture enquanto navega.
videocontrols-error-aborted = Carregamento do vídeo interrompido.
videocontrols-error-network = Execução do vídeo interrompida por um erro de rede.
videocontrols-error-decode = O vídeo não pode ser executado porque o arquivo está corrompido.
videocontrols-error-src-not-supported = Formato de vídeo ou tipo MIME não suportado.
videocontrols-error-no-source = Não há nenhum vídeo com formato ou tipo MIME suportados.
videocontrols-error-generic = Execução do vídeo interrompida por um erro desconhecido.
videocontrols-status-picture-in-picture = Este vídeo está sendo reproduzido em modo picture-in-picture.
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
