# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Configurações do profiler
perftools-intro-description = As gravações abrem o profiler.firefox.com em uma nova aba. Todos os dados são armazenados localmente, mas você pode escolher enviar para compartilhar.

## All of the headings for the various sections.

perftools-heading-settings = Todas as configurações
perftools-heading-buffer = Configurações de buffer
perftools-heading-features = Funcionalidades
perftools-heading-features-default = Funcionalidades (recomendado ativar por padrão)
perftools-heading-features-disabled = Funcionalidades desativadas
perftools-heading-features-experimental = Experimental
perftools-heading-threads = Threads
perftools-heading-threads-jvm = Threads da JVM
perftools-heading-local-build = Build local

##

perftools-description-intro = As gravações abrem o <a>profiler.firefox.com</a> em uma nova aba. Todos os dados são armazenados localmente, mas você pode escolher enviar para compartilhar.
perftools-description-local-build = Se você está gravando um profile de uma build que você mesmo compilou nesta máquina, adicione o objdir da sua build à lista abaixo para que ele possa ser usado para procurar informações de símbolos.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Intervalo de amostragem:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Tamanho do buffer:
perftools-custom-threads-label = Adicionar threads personalizados por nome:
perftools-devtools-interval-label = Intervalo:
perftools-devtools-threads-label = Threads:
perftools-devtools-settings-label = Configurações

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-recording-stopped-by-another-tool = A gravação foi interrompida por outra ferramenta.
perftools-status-restart-required = O navegador deve ser reiniciado para ativar esta funcionalidade.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Parando a gravação
perftools-request-to-get-profile-and-stop-profiler = Capturando profile

##

perftools-button-start-recording = Iniciar gravação
perftools-button-capture-recording = Capturar gravação
perftools-button-cancel-recording = Cancelar gravação
perftools-button-save-settings = Salvar configurações e voltar
perftools-button-restart = Reiniciar
perftools-button-add-directory = Adicionar um diretório
perftools-button-remove-directory = Remover selecionados
perftools-button-edit-settings = Editar configurações…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = Os processos principais, tanto do processo pai como dos processos de conteúdo
perftools-thread-compositor =
    .title = Compõe juntos diferentes elementos pintados na página
perftools-thread-dom-worker =
    .title = Isto lida tanto com web workers como service workers
perftools-thread-renderer =
    .title = Quando o WebRender está ativado, o thread que executa chamadas OpenGL
perftools-thread-render-backend =
    .title = O thread RenderBackend do WebRender
perftools-thread-paint-worker =
    .title = Quando a pintura fora do thread principal está ativada, o thread em que a pintura acontece
perftools-thread-timer =
    .title = Os timers de manipulação de threads (setTimeout, setInterval, nsITimer)
perftools-thread-style-thread =
    .title = A computação de estilo é dividida em vários threads
pref-thread-stream-trans =
    .title = Transporte de fluxo de rede
perftools-thread-socket-thread =
    .title = O thread em que o código de rede executa quaisquer chamadas de soquete de bloqueio
perftools-thread-img-decoder =
    .title = Threads de decodificação de imagens
perftools-thread-dns-resolver =
    .title = A resolução de DNS acontece neste thread
perftools-thread-task-controller =
    .title = Threads do conjunto de threads do TaskController
perftools-thread-jvm-gecko =
    .title = O thread principal da JVM do Gecko
perftools-thread-jvm-nimbus =
    .title = Os threads principais do SDK de experimentos Nimbus
perftools-thread-jvm-default-dispatcher =
    .title = O expedidor padrão da biblioteca de corrotinas Kotlin
perftools-thread-jvm-glean =
    .title = Os threads principais do SDK de telemetria Glean
perftools-thread-jvm-arch-disk-io =
    .title = O expedidor de IO da biblioteca de corrotinas Kotlin
perftools-thread-jvm-pool =
    .title = Threads criados em um pool de threads sem nome

##

perftools-record-all-registered-threads = Ignorar as seleções acima e gravar todos os threads registrados
perftools-tools-threads-input-label =
    .title = Esses nomes de thread ficam numa lista separada por vírgulas, usada para ativar a gravação de profiles dos threads no profiler. O nome precisa ser apenas uma correspondência parcial do nome do thread a ser incluído. É sensível a espaços em branco.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## devtools.performance.new-panel-onboarding preference is true.

perftools-onboarding-message = <b>Novo</b>: Agora o { -profiler-brand-name } é integrado nas ferramentas de desenvolvimento. <a>Saiba mais</a> sobre esta nova ferramenta poderosa.
perftools-onboarding-close-button =
    .aria-label = Fechar a mensagem de integração

## Profiler presets


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# The same labels and descriptions are also defined in appmenu.ftl.

perftools-presets-web-developer-label = Desenvolvimento web
perftools-presets-web-developer-description = Ajuste prévio recomendado para depuração da maioria dos aplicativos web, com pouca sobrecarga.
perftools-presets-firefox-label = { -brand-shorter-name }
perftools-presets-firefox-description = Predefinição recomendada para gravação de profile no { -brand-shorter-name }.
perftools-presets-graphics-label = Gráficos
perftools-presets-graphics-description = Predefinição para investigar bugs gráficos no { -brand-shorter-name }.
perftools-presets-media-label = Mídia
perftools-presets-media-description2 = Predefinição para investigar bugs de áudio e vídeo no { -brand-shorter-name }.
perftools-presets-networking-label = Rede
perftools-presets-networking-description = Predefinição para investigar bugs de rede no { -brand-shorter-name }.
# "Power" is used in the sense of energy (electricity used by the computer).
perftools-presets-power-label = Energia
perftools-presets-power-description = Predefinição para investigar bugs de uso de energia no { -brand-shorter-name }, com baixa sobrecarga.
perftools-presets-custom-label = Personalizado

##

