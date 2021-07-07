# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Información para solucionar problemas
page-subtitle = Esta página presenta información técnica que puede ser de ayuda si necesitas resolver un problema. Para obtener respuestas a preguntas comunes sobre { -brand-short-name } visita nuestro <a data-l10n-name="support-link">sitio web de soporte</a>.
crashes-title = Reporte de fallos
crashes-id = ID del reporte
crashes-send-date = Enviado
crashes-all-reports = Todos los informes de fallos
crashes-no-config = Esta aplicación no ha sido configurada para mostrar reportes de fallos.
extensions-title = Extensiones
extensions-name = Nombre
extensions-enabled = Activada
extensions-version = Versión
extensions-id = ID
support-addons-title = Complementos
support-addons-name = Nombre
support-addons-type = Tipo
support-addons-enabled = Habilitado
support-addons-version = Versión
support-addons-id = ID
security-software-title = Software de seguridad
security-software-type = Tipo
security-software-name = Nombre
security-software-antivirus = Antivirus
security-software-antispyware = Antispyware
security-software-firewall = Firewall
features-title = Características de { -brand-short-name }
features-name = Nombre
features-version = Versión
features-id = ID
processes-title = Procesos remotos
processes-type = Tipo
processes-count = Recuento
app-basics-title = Configuración básica de la aplicación
app-basics-name = Nombre
app-basics-version = Versión
app-basics-build-id = Id. de compilación
app-basics-distribution-id = ID de distribución
app-basics-update-channel = Canal de actualizaciones
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Directorio de actualizaciones
       *[other] Carpeta de actualizaciones
    }
app-basics-update-history = Historial de actualizaciones
app-basics-show-update-history = Mostrar historial de actualizaciones
# Represents the path to the binary used to start the application.
app-basics-binary = Binario de la aplicación
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Directorio del perfil
       *[other] Carpeta del perfil
    }
app-basics-enabled-plugins = Plugins activados
app-basics-build-config = Configuración de compilación
app-basics-user-agent = Agente de usuario
app-basics-os = OS
# Rosetta is Apple's translation process to run apps containing x86_64
# instructions on Apple Silicon. This should remain in English.
app-basics-rosetta = Traducido por Rosetta
app-basics-memory-use = Uso de memoria
app-basics-performance = Rendimiento
app-basics-service-workers = Service Workers registrados
app-basics-third-party = Módulos de terceros
app-basics-profiles = Perfiles
app-basics-launcher-process-status = Proceso de lanzamiento
app-basics-multi-process-support = Ventanas multiproceso
app-basics-fission-support = Ventanas de Fission
app-basics-remote-processes-count = Procesos remotos
app-basics-enterprise-policies = Políticas empresariales
app-basics-location-service-key-google = Clave de servicio de ubicación de Google
app-basics-safebrowsing-key-google = Clave de navegación segura de Google
app-basics-key-mozilla = Clave del servicio de localización de Mozilla
app-basics-safe-mode = Modo Seguro
show-dir-label =
    { PLATFORM() ->
        [macos] Mostrar en Finder
        [windows] Abrir carpeta
       *[other] Abrir directorio
    }
environment-variables-title = Variables de entorno
environment-variables-name = Nombre
environment-variables-value = Valor
experimental-features-title = Funciones experimentales
experimental-features-name = Nombre
experimental-features-value = Valor
modified-key-prefs-title = Preferencias importantes modificadas
modified-prefs-name = Nombre
modified-prefs-value = Valor
user-js-title = Preferencias en user.js
user-js-description = Su carpeta del perfil contiene un <a data-l10n-name="user-js-link">archivo user.js</a>, que incluye preferencias que no han sido creadas por { -brand-short-name }.
locked-key-prefs-title = Preferencias importantes bloqueadas
locked-prefs-name = Nombre
locked-prefs-value = Valor
graphics-title = Gráficas
graphics-features-title = Características
graphics-diagnostics-title = Diagnósticos
graphics-failure-log-title = Registro de fallos
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Registro de decisiones
graphics-crash-guards-title = Características de protección contra fallos deshabilitadas
graphics-workarounds-title = Soluciones
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Protocolo de ventanas
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Entorno de escritorio
place-database-title = Base de datos de lugares
place-database-integrity = Integridad
place-database-verify-integrity = Verificar integridad
a11y-title = Accesibilidad
a11y-activated = Activado
a11y-force-disabled = Prevenir accesibilidad
a11y-handler-used = Se usó un controlador accesible
a11y-instantiator = Instanciador de accesibilidad
library-version-title = Versiones de bibliotecas
copy-text-to-clipboard-label = Copiar el texto al portapapeles
copy-raw-data-to-clipboard-label = Copiar datos en crudo al portapapeles
sandbox-title = Arenero
sandbox-sys-call-log-title = Llamadas del sistema rechazadas
sandbox-sys-call-index = #
sandbox-sys-call-age = Hace segundos
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Tipo de proceso
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Argumentos
safe-mode-title = Probar modo seguro
restart-in-safe-mode-label = Reiniciar con Complementos Deshabilitados…
troubleshoot-mode-title = Diagnosticar problemas
restart-in-troubleshoot-mode-label = Modo de resolución de problemas…
clear-startup-cache-title = Intentar limpiar la caché de inicio
clear-startup-cache-label = Limpiar caché de inicio…
startup-cache-dialog-title2 = ¿Reiniciar { -brand-short-name } para limpiar la caché de inicio?
startup-cache-dialog-body2 = Esto no cambiará tu configuración ni eliminará extensiones
restart-button-label = Reiniciar

## Media titles

audio-backend = Backend de audio
max-audio-channels = Número máximo de canales
sample-rate = Frecuencia de muestreo preferida
roundtrip-latency = Latencia de ida y vuelta (desviación estándar)
media-title = Multimedia
media-output-devices-title = Dispositivos de salida
media-input-devices-title = Dispositivos de entrada
media-device-name = Nombre
media-device-group = Grupo
media-device-vendor = Fabricante
media-device-state = Estado
media-device-preferred = Preferido
media-device-format = Formato
media-device-channels = Canales
media-device-rate = Frecuencia
media-device-latency = Latencia
media-capabilities-title = Capacidades del contenido multimedia
# List all the entries of the database.
media-capabilities-enumerate = Enumerar base de datos

##

intl-title = Internacionalización y localización
intl-app-title = Ajustes de la aplicación
intl-locales-requested = Localizaciones solicitadas
intl-locales-available = Localizaciones disponibles
intl-locales-supported = Localizaciones de la app
intl-locales-default = Localización predeterminada
intl-os-title = Sistema operativo
intl-os-prefs-system-locales = Localizaciones del sistema
intl-regional-prefs = Preferencias regionales

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Depuración remota (protocolo de Chromium )
remote-debugging-accepting-connections = Aceptando conexiones
remote-debugging-url = URL

##

support-third-party-modules-title = Módulos de terceros
support-third-party-modules-module = Archivo de módulo
support-third-party-modules-version = Versión del archivo
support-third-party-modules-vendor = Información del fabricante
support-third-party-modules-occurrence = Ocurrencias
support-third-party-modules-process = Tipo de proceso e ID
support-third-party-modules-thread = Hilo
support-third-party-modules-base = Dirección de imagebase
support-third-party-modules-uptime = Tiempo de actividad del proceso (ms)
support-third-party-modules-duration = Duración de la carga (ms)
support-third-party-modules-status = Estado
support-third-party-modules-status-loaded = Cargado
support-third-party-modules-status-blocked = Bloqueado
support-third-party-modules-status-redirected = Redirigido
support-third-party-modules-empty = No se han cargado módulos de terceros.
support-third-party-modules-no-value = (Sin valor)
support-third-party-modules-button-open =
    .title = Abrir ubicación del archivo...
support-third-party-modules-expand =
    .title = Mostrar información detallada
support-third-party-modules-collapse =
    .title = Contraer información detallada
support-third-party-modules-unsigned-icon =
    .title = Este módulo no está firmado
support-third-party-modules-folder-icon =
    .title = Abrir ubicación del archivo…
support-third-party-modules-down-icon =
    .title = Mostrar información detallada
support-third-party-modules-up-icon =
    .title = Contraer información detallada
# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Informe de fallos del último { $days } día
       *[other] Informe de fallos de los últimos { $days } días
    }
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] hace { $minutes } minuto
       *[other] hace { $minutes } minutos
    }
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] hace { $hours } hora
       *[other] hace { $hours } horas
    }
# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] hace { $days } día
       *[other] hace { $days } días
    }
# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Todos los informes de fallos (incluyendo { $reports } fallo pendiente en el intervalo de tiempo indicado)
       *[other] Todos los informes de fallos (incluyendo { $reports } fallos pendientes en el intervalo de tiempo indicado)
    }
raw-data-copied = Datos en crudo copiados al portapapeles
text-copied = Texto copiado al portapapeles

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Bloqueado para la versión de tu controlador gráfico.
blocked-gfx-card = Bloqueado para tu tarjeta gráfica debido a problemas no resueltos del controlador.
blocked-os-version = Bloqueado para la versión de tu sistema operativo.
blocked-mismatched-version = Bloqueado por la diferencia de versión de tu controlador gráfico entre el registro y la DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Bloqueado para la versión de tu controlador gráfico. Prueba actualizando tu controlador gráfico a la versión { $driverVersion } o más moderna.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Parámetros de ClearType
compositing = Composición
hardware-h264 = Decodificación H264 por hardware
main-thread-no-omtc = hilo principal, no OMTC
yes = Sí
no = No
unknown = Desconocido
virtual-monitor-disp = Pantalla de monitor virtual

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Encontrada
missing = Ausente
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Descripción
gpu-vendor-id = ID de vendedor
gpu-device-id = ID de dispositivo
gpu-subsys-id = ID del subsistema
gpu-drivers = Controladores
gpu-ram = RAM
gpu-driver-vendor = Fabricante del controlador
gpu-driver-version = Versión del controlador
gpu-driver-date = Fecha del controlador
gpu-active = Activo
webgl1-wsiinfo = Información WSI del controlador WebGL 1
webgl1-renderer = Procesador WebGL 1
webgl1-version = Versión del controlador WebGL 1
webgl1-driver-extensions = Extensiones del controlador WebGL 1
webgl1-extensions = Extensiones WebGL 1
webgl2-wsiinfo = Información WSI del controlador WebGL 2
webgl2-renderer = Procesador WebGL2
webgl2-version = Versión del controlador WebGL 2
webgl2-driver-extensions = Extensiones del controlador WebGL 2
webgl2-extensions = Extensiones WebGL 2
blocklisted-bug = Bloqueado por problemas conocidos
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = bug { $bugNumber }
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = En lista de bloqueo debido a problemas conocidos: <a data-l10n-name="bug-link">{ $bugNumber }</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Bloqueado; código de falla { $failureCode }
d3d11layers-crash-guard = Compositor D3D11
d3d11video-crash-guard = Decodificador de video D3D11
d3d9video-crash-guard = Decodificador de video D3D9
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = Decodificador de vídeo WMF VPX
reset-on-next-restart = Restablecer en el próximo reinicio
gpu-process-kill-button = Terminar proceso GPU
gpu-device-reset = Restablecer dispositivo
gpu-device-reset-button = Reinicio del dispositivo de disparo
uses-tiling = Usa mosaicos
content-uses-tiling = Usa mosaicos (contenido)
off-main-thread-paint-enabled = Fuera del hilo principal de pintura Habilitado
off-main-thread-paint-worker-count = Recuento de dibujo fuera del tema principal
target-frame-rate = Frecuencia de imágenes objetivo
min-lib-versions = Versión mínima esperada
loaded-lib-versions = Versión en uso
has-seccomp-bpf = Seccomp-BPF (sistema de filtro de llamadas)
has-seccomp-tsync = Sincronización de hilos Seccomp
has-user-namespaces = Espacios de nombres de usuario
has-privileged-user-namespaces = Espacios de nombres de usuarios para procesos privilegiados
can-sandbox-content = Entorno de prueba para procesar contenidos
can-sandbox-media = Entorno de pruebas para extensiones de multimedia
content-sandbox-level = Entorno de prueba para procesar contenidos
effective-content-sandbox-level = Nivel efectivo del contenedor de proceso de contenido
content-win32k-lockdown-state = Estado de bloqueo de Win32k para el proceso de contenido
sandbox-proc-type-content = contenido
sandbox-proc-type-file = contenido del archivo
sandbox-proc-type-media-plugin = plugin de medios
sandbox-proc-type-data-decoder = decodificador de datos
startup-cache-title = Caché de inicio
startup-cache-disk-cache-path = Ruta de caché de disco
startup-cache-ignore-disk-cache = Ignorar caché de disco
startup-cache-found-disk-cache-on-init = Caché de disco encontrada durante la inicialización
startup-cache-wrote-to-disk-cache = Se escribió a la caché de disco
launcher-process-status-0 = Habilitado
launcher-process-status-1 = Deshabilitado debido a un fallo
launcher-process-status-2 = Deshabilitado forzosamente
launcher-process-status-unknown = Estado desconocido
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Habilitado por el usuario
multi-process-status-1 = Habilitado predeterminadamente
multi-process-status-2 = Deshabilitado
multi-process-status-4 = Deshabilitado por las herramientas de accesibilidad
multi-process-status-6 = Deshabilitado por ingresar texto no soportado
multi-process-status-7 = Deshabilitado por los complementos
multi-process-status-8 = Desactivado forzosamente
multi-process-status-unknown = Estado desconocido
# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/{ $totalWindows }
fission-status-experiment-control = Deshabilitado por el experimento
fission-status-experiment-treatment = Habilitado por el experimento
fission-status-disabled-by-e10s-env = Deshabilitado por el entorno
fission-status-enabled-by-env = Habilitado por el entorno
fission-status-disabled-by-safe-mode = Deshabilitado por el modo seguro
fission-status-enabled-by-default = Habilitado de forma predeterminada
fission-status-disabled-by-default = Deshabilitado de forma predeterminada
fission-status-enabled-by-user-pref = Habilitado por el usuario
fission-status-disabled-by-user-pref = Deshabilitado por el usuario
fission-status-disabled-by-e10s-other = E10s deshabilitado
fission-status-enabled-by-rollout = Habilitado por el lanzamiento por fases
async-pan-zoom = Encuadro/zoom asíncrono
apz-none = ninguno
wheel-enabled = entrada de rueda de ratón activada
touch-enabled = entrada táctil habilitada
drag-enabled = arrastra de barra de desplazamiento habilitado
keyboard-enabled = teclado habilitado
autoscroll-enabled = desplazamiento automático habilitado
zooming-enabled = zoom de pellizco suave activado

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = entrada de rueda de ratón desactivada debido a una preferencia no admitida: { $preferenceKey }
touch-warning = entrada táctil asíncrona desactivada debido a una preferencia no admitida: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Inactivo
policies-active = Activo
policies-error = Error

## Printing section

support-printing-title = Imprimir
support-printing-troubleshoot = Solución de problemas
support-printing-clear-settings-button = Eliminar los ajustes de impresión guardados
support-printing-modified-settings = Ajustes de impresión modificados
support-printing-prefs-name = Nombre
support-printing-prefs-value = Valor

## Normandy sections

support-remote-experiments-title = Experimentos remotos
support-remote-experiments-name = Nombre
support-remote-experiments-branch = Rama de experimentos
support-remote-experiments-see-about-studies = Ver <a data-l10n-name="support-about-studies-link">about:studies</a> para más información, incluyendo como desactivar experimentos individuales o desactivar que { -brand-short-name } ejecute este tipo de experimento en el futuro.
support-remote-features-title = Funciones remotas
support-remote-features-name = Nombre
support-remote-features-status = Estado
