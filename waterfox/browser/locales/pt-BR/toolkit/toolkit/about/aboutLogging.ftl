# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This is the title of the page
about-logging-title = Log de tráfego de rede
about-logging-page-title = Gerenciador de log
about-logging-current-log-file = Arquivo de log atual:
about-logging-new-log-file = Novo arquivo de log:
about-logging-currently-enabled-log-modules = Módulos de log atualmente ativados:
about-logging-log-tutorial = Consulte <a data-l10n-name="logging">Log de HTTP </a> para ver instruções de como usar esta ferramenta.
# This message is used as a button label, "Open" indicates an action.
about-logging-open-log-file-dir = Abrir diretório
about-logging-set-log-file = Configurar arquivo de log
about-logging-set-log-modules = Configurar módulos de log
about-logging-start-logging = Iniciar registro em log
about-logging-stop-logging = Parar registro em log
about-logging-buttons-disabled = Registro de log configurado por meio de variáveis de ambiente, configuração dinâmica indisponível.
about-logging-some-elements-disabled = Registro de log configurado via URL, algumas opções de configuração estão indisponíveis
about-logging-info = Informações:
about-logging-log-modules-selection = Seleção de módulos de log
about-logging-new-log-modules = Novos módulos de log:
about-logging-logging-output-selection = Saída de log
about-logging-logging-to-file = Registrando log em um arquivo
about-logging-logging-to-profiler = Registrando log no { -profiler-brand-name }
about-logging-no-log-modules = Nenhum
about-logging-no-log-file = Nenhum
about-logging-logging-preset-selector-text = Ajuste prévio de registro de log:
about-logging-with-profiler-stacks-checkbox = Ativar stack trace em mensagens de log

## Logging presets

about-logging-preset-networking-label = Rede
about-logging-preset-networking-description = Módulos de log para diagnosticar problemas de rede
about-logging-preset-networking-cookie-label = Cookies
about-logging-preset-networking-cookie-description = Módulos de log para diagnosticar problemas de cookies
about-logging-preset-networking-websocket-label = WebSockets
about-logging-preset-networking-websocket-description = Módulos de log para diagnosticar problemas de WebSocket
about-logging-preset-networking-http3-label = HTTP/3
about-logging-preset-networking-http3-description = Módulos de log para diagnosticar problemas de HTTP/3 e QUIC
about-logging-preset-media-playback-label = Reprodução de mídia
about-logging-preset-media-playback-description = Módulos de log para diagnosticar problemas de reprodução de mídia (não problemas de videoconferência)
about-logging-preset-webrtc-label = WebRTC
about-logging-preset-webrtc-description = Módulos de log para diagnosticar chamadas WebRTC
about-logging-preset-webgpu-label = WebGPU
about-logging-preset-webgpu-description = Módulos de log para diagnosticar problemas de WebGPU
about-logging-preset-gfx-label = Gráficos
about-logging-preset-gfx-description = Módulos de log para diagnosticar problemas gráficos
about-logging-preset-custom-label = Personalizado
about-logging-preset-custom-description = Módulos de log selecionados manualmente
# Error handling
about-logging-error = Erro:

## Variables:
##   $k (String) - Variable name
##   $v (String) - Variable value

about-logging-invalid-output = Valor inválido “{ $v }“ na chave “{ $k }“
about-logging-unknown-logging-preset = Ajuste prévio de registro de log desconhecido “{ $v }“
about-logging-unknown-profiler-preset = Ajuste prévio de profiler desconhecido “{ $v }“
about-logging-unknown-option = Opção de about:logging desconhecida “{ $k }“
about-logging-configuration-url-ignored = URL de configuração ignorada
about-logging-file-and-profiler-override = Não é possível forçar saída em arquivo e substituir opções do profiler ao mesmo tempo
about-logging-configured-via-url = Opção configurada via URL
