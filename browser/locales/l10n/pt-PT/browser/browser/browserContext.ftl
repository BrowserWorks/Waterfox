# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Desloque para baixo para mostrar o histórico
           *[other] Clique com o botão direito ou desloque para baixo para mostrar o histórico
        }

## Back

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = Retroceder uma página ({ $shortcut })
    .aria-label = Anterior
    .accesskey = A

# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = Anterior
    .accesskey = A

navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }

toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = Avançar uma página ({ $shortcut })
    .aria-label = Seguinte
    .accesskey = S

# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = Seguinte
    .accesskey = S

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

## Waterfox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name }
    .tooltiptext = { -fxaccount-brand-name }

## Save Page

main-context-menu-page-save =
    .label = Guardar página como…
    .accesskey = P

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Adicionar esta página aos marcadores
    .accesskey = m
    .tooltiptext = Adicionar esta página aos marcadores

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = Adicionar página aos marcadores
    .accesskey = m

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = Editar marcador
    .accesskey = m

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Adicionar esta página aos marcadores
    .accesskey = m
    .tooltiptext = Adicionar esta página aos marcadores ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Editar este marcador
    .accesskey = m
    .tooltiptext = Editar este marcador

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Editar este marcador
    .accesskey = m
    .tooltiptext = Editar este marcador ({ $shortcut })

main-context-menu-open-link =
    .label = Abrir ligação
    .accesskey = A

main-context-menu-open-link-new-tab =
    .label = Abrir ligação num novo separador
    .accesskey = s

main-context-menu-open-link-container-tab =
    .label = Abrir ligação num novo separador contentor
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = Abrir ligação numa nova janela
    .accesskey = j

main-context-menu-open-link-new-private-window =
    .label = Abrir ligação numa nova janela privada
    .accesskey = p

main-context-menu-bookmark-link =
    .label = Adicionar ligação aos marcadores
    .accesskey = o

main-context-menu-save-link =
    .label = Guardar ligação como…
    .accesskey = G

main-context-menu-save-link-to-pocket =
    .label = Guardar ligação no { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.


## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Copiar endereço de email
    .accesskey = e

main-context-menu-copy-link-simple =
    .label = Copiar ligação
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
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Silenciar
    .accesskey = S

main-context-menu-media-unmute =
    .label = Repor som
    .accesskey = m

main-context-menu-media-play-speed-2 =
    .label = Velocidade
    .accesskey = V

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
    .label = Mostrar controlos
    .accesskey = c

main-context-menu-media-hide-controls =
    .label = Ocultar controlos
    .accesskey = c

##

main-context-menu-media-video-fullscreen =
    .label = Ecrã completo
    .accesskey = E

main-context-menu-media-video-leave-fullscreen =
    .label = Sair de ecrã completo
    .accesskey = a

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-watch-pip =
    .label = Ver o vídeo numa janela flutuante
    .accesskey = u

main-context-menu-image-reload =
    .label = Recarregar imagem
    .accesskey = R

main-context-menu-image-view-new-tab =
    .label = Abrir imagem num novo separador
    .accesskey = i

main-context-menu-video-view-new-tab =
    .label = Abrir vídeo num novo separador
    .accesskey = i

main-context-menu-image-copy =
    .label = Copiar imagem
    .accesskey = o

main-context-menu-image-copy-link =
    .label = Copiar ligação da imagem
    .accesskey = o

main-context-menu-video-copy-link =
    .label = Copiar ligação do vídeo
    .accesskey = o

main-context-menu-audio-copy-link =
    .label = Copiar ligação do áudio
    .accesskey = o

main-context-menu-image-save-as =
    .label = Guardar imagem como…
    .accesskey = e

main-context-menu-image-email =
    .label = Enviar imagem por e-mail…
    .accesskey = g

main-context-menu-image-set-image-as-background =
    .label = Definir como fundo do ambiente de trabalho…
    .accesskey = h

main-context-menu-image-info =
    .label = Ver informação da imagem
    .accesskey = f

main-context-menu-image-desc =
    .label = Ver descrição
    .accesskey = d

main-context-menu-video-save-as =
    .label = Guardar vídeo como…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = Guardar áudio como…
    .accesskey = u

main-context-menu-video-take-snapshot =
    .label = Tirar uma captura…
    .accesskey = p

main-context-menu-video-email =
    .label = Enviar vídeo por e-mail…
    .accesskey = a

main-context-menu-audio-email =
    .label = Enviar áudio por e-mail…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Ativar este plugin
    .accesskey = t

main-context-menu-plugin-hide =
    .label = Ocultar este plugin
    .accesskey = u

main-context-menu-save-to-pocket =
    .label = Guardar página no { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Enviar página para dispositivo
    .accesskey = d

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = Utilizar credencial guardada
    .accesskey = g

main-context-menu-use-saved-password =
    .label = Utilizar palavra-passe guardada
    .accesskey = u

##

main-context-menu-suggest-strong-password =
    .label = Sugerir palavra-passe forte…
    .accesskey = S

main-context-menu-manage-logins2 =
    .label = Gerir credenciais
    .accesskey = G

main-context-menu-keyword =
    .label = Adicionar uma palavra-chave para esta pesquisa…
    .accesskey = A

main-context-menu-link-send-to-device =
    .label = Enviar ligação para dispositivo
    .accesskey = d

main-context-menu-frame =
    .label = Este frame
    .accesskey = t

main-context-menu-frame-show-this =
    .label = Mostrar apenas este frame
    .accesskey = a

main-context-menu-frame-open-tab =
    .label = Abrir frame num novo separador
    .accesskey = s

main-context-menu-frame-open-window =
    .label = Abrir frame numa nova janela
    .accesskey = j

main-context-menu-frame-reload =
    .label = Recarregar frame
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = Adicionar este frame aos marcadores
    .accesskey = m

main-context-menu-frame-save-as =
    .label = Guardar frame como…
    .accesskey = f

main-context-menu-frame-print =
    .label = Imprimir frame…
    .accesskey = p

main-context-menu-frame-view-source =
    .label = Ver código fonte do frame
    .accesskey = V

main-context-menu-frame-view-info =
    .label = Ver informação do frame
    .accesskey = i

main-context-menu-print-selection =
    .label = Imprimir seleção
    .accesskey = r

main-context-menu-view-selection-source =
    .label = Ver fonte da seleção
    .accesskey = e

main-context-menu-take-screenshot =
    .label = Tirar uma captura de ecrã
    .accesskey = T

main-context-menu-take-frame-screenshot =
    .label = Tirar uma captura de ecrã
    .accesskey = t

main-context-menu-view-page-source =
    .label = Ver fonte da página
    .accesskey = V

main-context-menu-bidi-switch-text =
    .label = Mudar direção do texto
    .accesskey = x

main-context-menu-bidi-switch-page =
    .label = Mudar direção da página
    .accesskey = g

main-context-menu-inspect =
    .label = Inspecionar
    .accesskey = n

main-context-menu-inspect-a11y-properties =
    .label = Inspecionar propriedades de acessibilidade

main-context-menu-eme-learn-more =
    .label = Saber mais acerca de DRM…
    .accesskey = D

# Variables
#   $containerName (String): The name of the current container
main-context-menu-open-link-in-container-tab =
    .label = Abrir ligação num novo separador { $containerName }
    .accesskey = s
