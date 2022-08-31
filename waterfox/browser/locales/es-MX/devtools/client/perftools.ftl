# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Ajustes del perfilador
perftools-intro-description =
    Las grabaciones abren profiler.firefox.com en una nueva pestaña. Todos los datos se almacenan 
    localmente, pero puedes elegir por subirlos para compartir.

## All of the headings for the various sections.

perftools-heading-settings = Configuración completa
perftools-heading-buffer = Ajustes de buffer
perftools-heading-features = Funcionalidades
perftools-heading-features-default = Funcionalidades (recomendadas activadas de forma predeterminada)
perftools-heading-features-disabled = Funcionalidades deshabilitadas
perftools-heading-features-experimental = Experimental
perftools-heading-threads = Hilos
perftools-heading-threads-jvm = Subprocesos JVM
perftools-heading-local-build = Compilación local

##

perftools-description-intro =
    Las grabaciones abren <a>profiler.firefox.com</a> en una nueva pestaña. Todos los datos son almacenados
    localmente, pero puedes elegir si quieres subirlos para compartirlos.
perftools-description-local-build =
    Si estás perfilando una compilación que hiciste tu, en este
    equipo, por favor añade el objdir de tu compilación a la lista a continuación para que
    pueda utilizarse para buscar información simbólica.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Intervalo de muestra:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Tamaño del buffer:
perftools-custom-threads-label = Agregar hilos personalizados por nombre:
perftools-devtools-interval-label = Intervalo:
perftools-devtools-threads-label = Hilos:
perftools-devtools-settings-label = Ajustes

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-recording-stopped-by-another-tool = Otra herramienta detuvo la grabación.
perftools-status-restart-required = Se debe reiniciar el navegador para habilitar esta función.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Detener la grabación
perftools-request-to-get-profile-and-stop-profiler = Capturando perfil

##

perftools-button-start-recording = Iniciar grabación
perftools-button-capture-recording = Capturar la grabación
perftools-button-cancel-recording = Cancelar grabación
perftools-button-save-settings = Guardar ajustes y volver
perftools-button-restart = Reiniciar
perftools-button-add-directory = Agregar un directorio
perftools-button-remove-directory = Eliminar lo seleccionado
perftools-button-edit-settings = Editar ajustes…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = Los procesos principales tanto para el proceso padre como para los procesos de contenido
perftools-thread-compositor =
    .title = Combina diferentes elementos pintados en la página.
perftools-thread-dom-worker =
    .title = Esto se ocupa tanto de los web workers como de los service workers
perftools-thread-renderer =
    .title = Cuando WebRender está habilitado, el hilo que ejecuta las llamadas OpenGL
perftools-thread-render-backend =
    .title = El hilo WebRender RenderBackend
perftools-thread-paint-worker =
    .title = Cuando se habilita el pintado fuera del hilo principal, el hilo en el que se realiza el pintado
perftools-thread-timer =
    .title = Los temporizadores de manejo de subprocesos (setTimeout, setInterval, nsITimer)
perftools-thread-style-thread =
    .title = El cálculo de estilo se divide en múltiples hilos
pref-thread-stream-trans =
    .title = Transporte de flujo de red
perftools-thread-socket-thread =
    .title = El hilo donde el código de red ejecuta cualquier llamada de socket de bloqueo
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
    .title = El despachador predeterminado para la biblioteca de rutinas de Kotlin
perftools-thread-jvm-glean =
    .title = Los subprocesos principales del SDK de telemetría de Glean
perftools-thread-jvm-arch-disk-io =
    .title = Despachador IO para la librería de rutinas de Kotlin
perftools-thread-jvm-pool =
    .title = Subprocesos creador en un conjunto de subprocesos sin nombre

##

perftools-record-all-registered-threads = Omitir las selecciones de arriba y grabar todos los hilos registrados
perftools-tools-threads-input-label =
    .title = Estos nombres de hilos son una lista separada por comas que se utiliza para habilitar la creación de perfiles de los hilos en el perfilador. El nombre debe ser solo una coincidencia parcial del nombre del hilo para que se incluya. Es sensible a los espacios en blanco.

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
perftools-presets-firefox-description = Configuración preestablecida recomendada para crear perfiles de { -brand-shorter-name }.
perftools-presets-graphics-label = Gráficos
perftools-presets-graphics-description = Preestablecido para investigar errores gráficos en { -brand-shorter-name }.
perftools-presets-media-label = Multimedia
perftools-presets-media-description2 = Preestablecido para investigar errores de audio y video en { -brand-shorter-name }.
perftools-presets-networking-label = Redes
perftools-presets-networking-description = Preestablecido para investigar errores de red en { -brand-shorter-name }.
# "Power" is used in the sense of energy (electricity used by the computer).
perftools-presets-power-label = Energía
perftools-presets-power-description = Preestablecido para investigar errores de uso de energía en { -brand-shorter-name }, con poca sobrecarga.
perftools-presets-custom-label = Personalizado

##

