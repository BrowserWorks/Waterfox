# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Ajustes del perfilador
perftools-intro-description =
    Las grabaciones abren profiler.firefox.com en una nueva pestaña. Todos los datos están almacenados
    localmente, pero puede elegir subirlos para compartirlos.

## All of the headings for the various sections.

perftools-heading-settings = Configuración completa
perftools-heading-buffer = Ajustes de buffer
perftools-heading-features = Funcionalidades
perftools-heading-features-default = Funciones (se recomienda activarlas de forma predeterminada)
perftools-heading-features-disabled = Funcionalidades desactivadas
perftools-heading-features-experimental = Experimental
perftools-heading-threads = Hilos
perftools-heading-threads-jvm = Subprocesos JVM
perftools-heading-local-build = Compilación local

##

perftools-description-intro =
    Las grabaciones abren <a>profiler.firefox.com</a> en una nueva pestaña. Todos los datos están almacenados
    localmente, pero puede elegir subirlos para compartirlos.
perftools-description-local-build =
    Si está perfilando una compilación hecha por usted mismo en esta
    máquina, añada el objdir de la misma a la lista de abajo para que
    pueda utilizarse para buscar información de símbolos.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Intervalo de muestreo:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Tamaño del buffer:
perftools-custom-threads-label = Añadir hilos personalizados por nombre:
perftools-devtools-interval-label = Intervalo:
perftools-devtools-threads-label = Hilos:
perftools-devtools-settings-label = Ajustes

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-recording-stopped-by-another-tool = Otra herramienta detuvo la grabación.
perftools-status-restart-required = Se debe reiniciar el navegador para activar esta función.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Deteniendo grabación
perftools-request-to-get-profile-and-stop-profiler = Capturando perfil

##

perftools-button-start-recording = Iniciar grabación
perftools-button-capture-recording = Capturar la grabación
perftools-button-cancel-recording = Guardar grabación
perftools-button-save-settings = Guardar ajustes y volver
perftools-button-restart = Reiniciar
perftools-button-add-directory = Añadir un directorio
perftools-button-remove-directory = Eliminar lo seleccionado
perftools-button-edit-settings = Editar ajustes…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = Los procesos principales tanto para el proceso principal como para los procesos de contenido
perftools-thread-compositor =
    .title = Combina diferentes elementos pintados en la página.
perftools-thread-dom-worker =
    .title = Esto se ocupa tanto de los web workers como de los service workers
perftools-thread-renderer =
    .title = Cuando WebRender está activado, el hilo que ejecuta las llamadas OpenGL
perftools-thread-render-backend =
    .title = El hilo WebRender RenderBackend
perftools-thread-paint-worker =
    .title = Cuando se activa el pintado fuera del hilo principal, el hilo en el que se realiza el pintado
perftools-thread-timer =
    .title = Los temporizadores de manejo de subprocesos (setTimeout, setInterval, nsITimer)
perftools-thread-style-thread =
    .title = El cálculo de estilo se divide en múltiples hilos
pref-thread-stream-trans =
    .title = Transporte de flujo de red
perftools-thread-socket-thread =
    .title = El hilo donde el código de red ejecuta cualquier llamada bloqueante de socket
perftools-thread-img-decoder =
    .title = Hilos de decodificación de imágenes
perftools-thread-dns-resolver =
    .title = La resolución de DNS ocurre en este hilo
perftools-thread-task-controller =
    .title = Hilos del grupo de subprocesos de TaskController
perftools-thread-jvm-gecko =
    .title = El subproceso principal de Gecko JVM
perftools-thread-jvm-nimbus =
    .title = Los subprocesos principales para el SDK de experimentos de Nimbus
perftools-thread-jvm-default-dispatcher =
    .title = El dispatcher predeterminado para la biblioteca de rutinas de Kotlin
perftools-thread-jvm-glean =
    .title = Los subprocesos principales del SDK de telemetría de Glean
perftools-thread-jvm-arch-disk-io =
    .title = El dispatcher IO para la librería de rutinas de Kotlin
perftools-thread-jvm-pool =
    .title = Subprocesos creados en un grupo de subprocesos sin nombre

##

perftools-record-all-registered-threads = Omitir las selecciones de arriba y grabar todos los hilos registrados
perftools-tools-threads-input-label =
    .title = Estos nombres de hilos son una lista separada por comas que se utiliza para activar la creación de perfiles de los hilos en el perfilador. El nombre debe ser solo una coincidencia parcial del nombre del hilo para que se incluya. Es sensible a los espacios en blanco.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## devtools.performance.new-panel-onboarding preference is true.

perftools-onboarding-message = <b>Nuevo</b>: { -profiler-brand-name } ahora está integrado en las herramientas para desarrolladores. <a>Saber más</a> sobre esta poderosa herramienta.
perftools-onboarding-close-button =
    .aria-label = Cerrar el mensaje introductorio

## Profiler presets


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# The same labels and descriptions are also defined in appmenu.ftl.

perftools-presets-web-developer-label = Desarrollador web
perftools-presets-web-developer-description = Configuración recomendada para la depuración de la mayoría de aplicaciones web, con poca sobrecarga.
perftools-presets-firefox-label = { -brand-shorter-name }
perftools-presets-firefox-description = Valor predeterminado recomendado para la creación de perfiles { -brand-shorter-name }.
perftools-presets-graphics-label = Gráficos
perftools-presets-graphics-description = Preestablecido para investigar errores gráficos en { -brand-shorter-name }.
perftools-presets-media-label = Multimedia
perftools-presets-media-description2 = Preestablecido para investigar errores de audio y vídeo en { -brand-shorter-name }.
perftools-presets-networking-label = Red
perftools-presets-networking-description = Preestablecido para investigar problemas de red en { -brand-shorter-name }.
perftools-presets-custom-label = Personalizado

##

