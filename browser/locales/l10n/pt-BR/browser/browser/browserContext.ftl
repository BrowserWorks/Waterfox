# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Arrastar para baixo para mostrar o histórico
           *[other] Clique com o botão direito ou clique e arraste para baixo para mostrar o histórico
        }

## Back

main-context-menu-back =
    .tooltiptext = Voltar uma página
    .aria-label = Voltar
    .accesskey = V
navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }
toolbar-button-back =
    .label = { main-context-menu-back.aria-label }
# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = Voltar uma página ({ $shortcut })
    .aria-label = Voltar
    .accesskey = V
# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = Voltar
    .accesskey = V
navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }
toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Avançar uma página
    .aria-label = Avançar
    .accesskey = A
navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }
toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }
# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = Avançar uma página ({ $shortcut })
    .aria-label = Avançar
    .accesskey = A
# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = Avançar
    .accesskey = A
navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }
toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Recarregar
    .accesskey = R
# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = Recarregar
    .accesskey = R
toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Parar
    .accesskey = P
# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = Parar
    .accesskey = P
toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Firefox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name }
    .tooltiptext = { -fxaccount-brand-name }

## Save Page

main-context-menu-page-save =
    .label = Salvar página como…
    .accesskey = P
toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Adicionar esta página aos favoritos
    .accesskey = m
    .tooltiptext = Adicionar aos favoritos
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = Adicionar página aos favoritos
    .accesskey = f
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = Editar favorito
    .accesskey = f
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Adicionar esta página aos favoritos
    .accesskey = m
    .tooltiptext = Adicionar aos favoritos ({ $shortcut })
main-context-menu-bookmark-change =
    .aria-label = Editar este favorito
    .accesskey = m
    .tooltiptext = Editar este favorito
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Editar este favorito
    .accesskey = m
    .tooltiptext = Editar este favorito ({ $shortcut })
main-context-menu-open-link =
    .label = Abrir link
    .accesskey = A
main-context-menu-open-link-new-tab =
    .label = Abrir link em nova aba
    .accesskey = b
main-context-menu-open-link-container-tab =
    .label = Abrir link em nova aba contêiner
    .accesskey = c
main-context-menu-open-link-new-window =
    .label = Abrir link em nova janela
    .accesskey = A
main-context-menu-open-link-new-private-window =
    .label = Abrir link em nova janela privativa
    .accesskey = r
main-context-menu-bookmark-this-link =
    .label = Adicionar este link aos favoritos
    .accesskey = d
main-context-menu-bookmark-link =
    .label = Adicionar link aos favoritos
    .accesskey = f
main-context-menu-save-link =
    .label = Salvar link como…
    .accesskey = S
main-context-menu-save-link-to-pocket =
    .label = Salvar link no { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.


## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Copiar endereço de email
    .accesskey = o
main-context-menu-copy-link =
    .label = Copiar link
    .accesskey = o
main-context-menu-copy-link-simple =
    .label = Copiar link
    .accesskey = l

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Reproduzir
    .accesskey = p
main-context-menu-media-pause =
    .label = Pausar
    .accesskey = u

##

main-context-menu-media-mute =
    .label = Silenciar
    .accesskey = S
main-context-menu-media-unmute =
    .label = Ativar som
    .accesskey = s
main-context-menu-media-play-speed =
    .label = Velocidade de reprodução
    .accesskey = d
main-context-menu-media-play-speed-slow =
    .label = Lenta (0,5×)
    .accesskey = L
main-context-menu-media-play-speed-normal =
    .label = Normal
    .accesskey = N
main-context-menu-media-play-speed-fast =
    .label = Rápida (1,25×)
    .accesskey = R
main-context-menu-media-play-speed-faster =
    .label = Mais rápida (1,5×)
    .accesskey = a
# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Muito rápida (2×)
    .accesskey = u
main-context-menu-media-play-speed-2 =
    .label = Velocidade
    .accesskey = d
main-context-menu-media-play-speed-slow-2 =
    .label = 0.5×
main-context-menu-media-play-speed-normal-2 =
    .label = 1.0×
main-context-menu-media-play-speed-fast-2 =
    .label = 1.25×
main-context-menu-media-play-speed-faster-2 =
    .label = 1.5×
main-context-menu-media-play-speed-fastest-2 =
    .label = 2×
main-context-menu-media-loop =
    .label = Repetir
    .accesskey = R

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Mostrar controles
    .accesskey = n
main-context-menu-media-hide-controls =
    .label = Ocultar controles
    .accesskey = n

##

main-context-menu-media-video-fullscreen =
    .label = Tela inteira
    .accesskey = T
main-context-menu-media-video-leave-fullscreen =
    .label = Sair da tela inteira
    .accesskey = t
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Picture-in-Picture
    .accesskey = u
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-watch-pip =
    .label = Assistir em picture-in-picture
    .accesskey = u
main-context-menu-image-reload =
    .label = Recarregar imagem
    .accesskey = R
main-context-menu-image-view =
    .label = Ver imagem
    .accesskey = i
main-context-menu-video-view =
    .label = Ver vídeo
    .accesskey = e
main-context-menu-image-view-new-tab =
    .label = Abrir imagem em nova aba
    .accesskey = i
main-context-menu-video-view-new-tab =
    .label = Abrir vídeo em nova aba
    .accesskey = i
main-context-menu-image-copy =
    .label = Copiar imagem
    .accesskey = i
main-context-menu-image-copy-location =
    .label = Copiar endereço da imagem
    .accesskey = o
main-context-menu-video-copy-location =
    .label = Copiar endereço do vídeo
    .accesskey = o
main-context-menu-audio-copy-location =
    .label = Copiar endereço do áudio
    .accesskey = o
main-context-menu-image-copy-link =
    .label = Copiar link da imagem
    .accesskey = o
main-context-menu-video-copy-link =
    .label = Copiar link do vídeo
    .accesskey = o
main-context-menu-audio-copy-link =
    .label = Copiar link do áudio
    .accesskey = o
main-context-menu-image-save-as =
    .label = Salvar imagem como…
    .accesskey = i
main-context-menu-image-email =
    .label = Enviar imagem por email…
    .accesskey = v
main-context-menu-image-set-as-background =
    .label = Definir como papel de parede…
    .accesskey = n
main-context-menu-image-set-image-as-background =
    .label = Definir imagem como fundo da área de trabalho…
    .accesskey = D
main-context-menu-image-info =
    .label = Ver informações da imagem
    .accesskey = f
main-context-menu-image-desc =
    .label = Ver descrição
    .accesskey = d
main-context-menu-video-save-as =
    .label = Salvar vídeo como…
    .accesskey = v
main-context-menu-audio-save-as =
    .label = Salvar áudio como…
    .accesskey = S
main-context-menu-video-image-save-as =
    .label = Salvar quadro atual como…
    .accesskey = S
main-context-menu-video-take-snapshot =
    .label = Capturar tela…
    .accesskey = C
main-context-menu-video-email =
    .label = Enviar vídeo por email…
    .accesskey = r
main-context-menu-audio-email =
    .label = Enviar áudio por email…
    .accesskey = r
main-context-menu-plugin-play =
    .label = Ativar este plugin
    .accesskey = t
main-context-menu-plugin-hide =
    .label = Ocultar este plugin
    .accesskey = c
main-context-menu-save-to-pocket =
    .label = Salvar página no { -pocket-brand-name }
    .accesskey = k
main-context-menu-send-to-device =
    .label = Enviar página para dispositivo
    .accesskey = d
main-context-menu-view-background-image =
    .label = Ver imagem de fundo
    .accesskey = m
main-context-menu-generate-new-password =
    .label = Usar senha gerada…
    .accesskey = g

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = Usar conta salva
    .accesskey = o
main-context-menu-use-saved-password =
    .label = Usar senha salva
    .accesskey = e

##

main-context-menu-suggest-strong-password =
    .label = Sugerir senha forte…
    .accesskey = S
main-context-menu-manage-logins2 =
    .label = Gerenciar contas
    .accesskey = G
main-context-menu-keyword =
    .label = Adicionar um atalho a esta pesquisa…
    .accesskey = r
main-context-menu-link-send-to-device =
    .label = Enviar link para dispositivo
    .accesskey = d
main-context-menu-frame =
    .label = Este frame
    .accesskey = t
main-context-menu-frame-show-this =
    .label = Mostrar só este frame
    .accesskey = x
main-context-menu-frame-open-tab =
    .label = Abrir frame em nova aba
    .accesskey = b
main-context-menu-frame-open-window =
    .label = Abrir frame em nova janela
    .accesskey = A
main-context-menu-frame-reload =
    .label = Recarregar frame
    .accesskey = R
main-context-menu-frame-bookmark =
    .label = Adicionar este frame aos favoritos
    .accesskey = d
main-context-menu-frame-save-as =
    .label = Salvar frame como…
    .accesskey = l
main-context-menu-frame-print =
    .label = Imprimir frame…
    .accesskey = I
main-context-menu-frame-view-source =
    .label = Ver código-fonte do frame
    .accesskey = V
main-context-menu-frame-view-info =
    .label = Ver informações do frame
    .accesskey = i
main-context-menu-print-selection =
    .label = Imprimir seleção
    .accesskey = r
main-context-menu-view-selection-source =
    .label = Ver código-fonte selecionado
    .accesskey = e
main-context-menu-take-screenshot =
    .label = Capturar tela
    .accesskey = C
main-context-menu-take-frame-screenshot =
    .label = Capturar tela
    .accesskey = C
main-context-menu-view-page-source =
    .label = Ver código-fonte da página
    .accesskey = V
main-context-menu-view-page-info =
    .label = Ver informações da página
    .accesskey = i
main-context-menu-bidi-switch-text =
    .label = Alterar direção do texto
    .accesskey = A
main-context-menu-bidi-switch-page =
    .label = Alterar direção da página
    .accesskey = e
main-context-menu-inspect-element =
    .label = Inspecionar elemento
    .accesskey = Q
main-context-menu-inspect =
    .label = Inspecionar
    .accesskey = Q
main-context-menu-inspect-a11y-properties =
    .label = Inspecionar propriedades de acessibilidade
main-context-menu-eme-learn-more =
    .label = Saiba mais sobre DRM…
    .accesskey = D
