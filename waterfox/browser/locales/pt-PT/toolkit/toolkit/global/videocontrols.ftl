# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Posição
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Carregado:
videocontrols-volume-control =
    .aria-label = Volume
videocontrols-closed-caption-button =
    .aria-label = Legendas de áudio
videocontrols-play-button =
    .aria-label = Reproduzir
videocontrols-pause-button =
    .aria-label = Pausa
videocontrols-mute-button =
    .aria-label = Silenciar
videocontrols-unmute-button =
    .aria-label = Repor som
videocontrols-enterfullscreen-button =
    .aria-label = Ecrã completo
videocontrols-exitfullscreen-button =
    .aria-label = Sair de ecrã completo
videocontrols-casting-button-label =
    .aria-label = Lançar para o ecrã
videocontrols-closed-caption-off =
    .offlabel = Desligado
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Vídeo em janela flutuante
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Ver o vídeo numa janela flutuante
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Reproduzir vídeo em primeiro plano enquanto faz outras coisas no { -brand-short-name }
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Fazer este vídeo saltar
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = Mais ecrãs é mais divertido. Reproduza este vídeo no modo de Imagem Sobreposta enquanto navega.
videocontrols-error-aborted = O carregamento do vídeo parou.
videocontrols-error-network = Reprodução de vídeo abortada devido a um erro de rede.
videocontrols-error-decode = O vídeo não pode ser reproduzido porque o ficheiro está danificado.
videocontrols-error-src-not-supported = Formato de vídeo ou tipo MIME não suportado.
videocontrols-error-no-source = Não foi encontrado nenhum vídeo com um formato e tipo MIME suportado.
videocontrols-error-generic = Reprodução de vídeo abortada devido a um erro desconhecido.
videocontrols-status-picture-in-picture = Este vídeo está a ser reproduzido numa janela flutuante.
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
