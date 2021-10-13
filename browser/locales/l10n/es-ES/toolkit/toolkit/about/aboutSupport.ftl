# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Información para solucionar problemas
page-subtitle = Esta página contiene información técnica que puede ser útil cuando intente solucionar un problema. Si está buscando respuestas a preguntas frecuentes sobre { -brand-short-name }, visite nuestro <a data-l10n-name="support-link">sitio de asistencia</a>.

crashes-title = Informes de fallos
crashes-id = ID del informe
crashes-send-date = Enviado
crashes-all-reports = Todos los informes de fallo
crashes-no-config = Esta aplicación no ha sido configurada para mostrar informes de fallos.
support-addons-title = Complementos
support-addons-name = Nombre
support-addons-type = Tipo
support-addons-enabled = Activado
support-addons-version = Versión
support-addons-id = ID
security-software-title = Software de seguridad
security-software-type = Tipo
security-software-name = Nombre
security-software-antivirus = Antivirus
security-software-antispyware = Antispyware
security-software-firewall = Cortafuegos
features-title = Características de { -brand-short-name }
features-name = Nombre
features-version = Versión
features-id = ID
processes-title = Procesos remotos
processes-type = Tipo
processes-count = Número
app-basics-title = Configuración básica de la aplicación
app-basics-name = Nombre
app-basics-version = Versión
app-basics-build-id = ID de compilación
app-basics-distribution-id = ID de distribución
app-basics-update-channel = Canal de actualización
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Actualizar directorio
       *[other] Actualizar carpeta
    }
app-basics-update-history = Historial de actualizaciones
app-basics-show-update-history = Mostrar el historial de actualizaciones
# Represents the path to the binary used to start the application.
app-basics-binary = Binario de la aplicación
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Directorio de perfil
       *[other] Carpeta del perfil
    }
app-basics-enabled-plugins = Plugins activados
app-basics-build-config = Configuración de compilación
app-basics-user-agent = Agente de usuario
app-basics-os = OS
app-basics-os-theme = Tema del sistema operativo
# Rosetta is Apple's translation process to run apps containing x86_64
# instructions on Apple Silicon. This should remain in English.
app-basics-rosetta = Traducido por Rosetta
app-basics-memory-use = Uso de memoria
app-basics-performance = Rendimiento
app-basics-service-workers = Service Workers registrados
app-basics-third-party = Módulos de terceros
app-basics-profiles = Perfiles
app-basics-launcher-process-status = Proceso lanzador
app-basics-multi-process-support = Ventanas multiproceso
app-basics-fission-support = Ventanas de Fission
app-basics-remote-processes-count = Procesos remotos
app-basics-enterprise-policies = Políticas empresariales
app-basics-location-service-key-google = Clave del servicio de localización de Google
app-basics-safebrowsing-key-google = Clave del servicio Google Safebrowsing
app-basics-key-mozilla = Clave del servicio de ubicación de Waterfox
app-basics-safe-mode = Modo seguro
show-dir-label =
    { PLATFORM() ->
        [macos] Mostrar en Finder
        [windows] Abrir carpeta
       *[other] Abrir directorio
    }
environment-variables-title = Variables de entorno
environment-variables-name = Nombre
environment-variables-value = Valor
experimental-features-title = Características experimentales
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
graphics-title = Gráficos
graphics-features-title = Características
graphics-diagnostics-title = Diagnósticos
graphics-failure-log-title = Registro de fallos
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Registro de decisiones
graphics-crash-guards-title = Características desactivadas de Crash Guard
graphics-workarounds-title = Alternativas
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Protocolo de ventana
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Entorno de escritorio
place-database-title = Base de datos de sitios
place-database-integrity = Integridad
place-database-verify-integrity = Verificar integridad
a11y-title = Accesibilidad
a11y-activated = Activado
a11y-force-disabled = Impedir accesibilidad
a11y-handler-used = Se usó un controlador accesible
a11y-instantiator = Instanciador de accesibilidad
library-version-title = Versiones de bibliotecas
copy-text-to-clipboard-label = Copiar el texto al portapapeles
copy-raw-data-to-clipboard-label = Copiar datos sin procesar al portapapeles
sandbox-title = Entorno de pruebas
sandbox-sys-call-log-title = Llamadas de sistema rechazadas
sandbox-sys-call-index = #
sandbox-sys-call-age = Hace segundos
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Tipo de proceso
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Argumentos
troubleshoot-mode-title = Diagnosticar problemas
restart-in-troubleshoot-mode-label = Modo de resolución de problemas…
clear-startup-cache-title = Intentar limpiar la caché de inicio
clear-startup-cache-label = Limpiar caché de inicio…
startup-cache-dialog-title2 = ¿Reiniciar { -brand-short-name } para limpiar la caché de inicio?
startup-cache-dialog-body2 = Esto no cambiará su configuración ni eliminará extensiones.
restart-button-label = Reiniciar

## Media titles

audio-backend = Sistema de audio
max-audio-channels = Canales máximos
sample-rate = Tasa de muestreo preferida
roundtrip-latency = Latencia de ida y vuelta (desviación estándar)
media-title = Medios
media-output-devices-title = Dispositivos de salida
media-input-devices-title = Dispositivos de entrada
media-device-name = Nombre
media-device-group = Grupo
media-device-vendor = Fabricante
media-device-state = Estado
media-device-preferred = Preferido
media-device-format = Formato
media-device-channels = Canales
media-device-rate = Tasa
media-device-latency = Latencia
media-capabilities-title = Capacidades del contenido multimedia
# List all the entries of the database.
media-capabilities-enumerate = Enumerar base de datos

##

intl-title = Internacionalización y localización
intl-app-title = Configuración de la aplicación
intl-locales-requested = Idiomas solicitados
intl-locales-available = Idiomas disponibles
intl-locales-supported = Idiomas de la aplicación
intl-locales-default = Idioma preterminado
intl-os-title = Sistema operativo
intl-os-prefs-system-locales = Idiomas del sistema
intl-regional-prefs = Preferencias regionales

## Remote Debugging
##
## The Waterfox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Depuración remota (protocolo de Chromium )
remote-debugging-accepting-connections = Aceptando conexiones
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Informes de fallos del último día
       *[other] Informes de fallos de los últimos { $days } días
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

raw-data-copied = Datos sin procesar copiados al portapapeles
text-copied = Texto copiado al portapapeles

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Bloqueado para la versión de su controlador gráfico.
blocked-gfx-card = Bloqueado para su tarjeta gráfica debido a problemas no resueltos del controlador.
blocked-os-version = Bloqueado para la versión de su sistema operativo.
blocked-mismatched-version = Bloqueado por la diferencia e versión de su controlador gráfico entre el registro y la DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Bloqueado para la versión de su controlador gráfico. Pruebe a actualizar su controlador gráfico a la versión { $driverVersion } o más moderna.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Parámetros de ClearType

compositing = Composición
hardware-h264 = Decodificación H264 por hardware
main-thread-no-omtc = hilo principal, sin OMTC
yes = Sí
no = No
unknown = Desconocido
virtual-monitor-disp = Pantalla de monitor virtual

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Encontrado
missing = Ausente

gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Descripción
gpu-vendor-id = ID del fabricante
gpu-device-id = ID del dispositivo
gpu-subsys-id = ID del subsistema
gpu-drivers = Controladores
gpu-ram = RAM
gpu-driver-vendor = Fabricante del driver
gpu-driver-version = Versión del controlador
gpu-driver-date = Fecha del controlador
gpu-active = Activa
webgl1-wsiinfo = Información WSI del controlador WebGL 1
webgl1-renderer = Renderizador del controlador WebGL 1
webgl1-version = Versión del controlador WebGL 1
webgl1-driver-extensions = Extensiones del controlador WebGL 1
webgl1-extensions = Extensiones WebGL 1
webgl2-wsiinfo = Información WSI del controlador WebGL 2
webgl2-renderer = Renderizador del controlador WebGL 2
webgl2-version = Versión del controlador WebGL 2
webgl2-driver-extensions = Extensiones del controlador WebGL 2
webgl2-extensions = Extensiones WebGL 2

# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Lista bloqueada debido a problemas conocidos: <a data-l10n-name="bug-link">bug { $bugNumber }</a>

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Incluido en lista de bloqueo; código de error { $failureCode }

d3d11layers-crash-guard = Compositor D3D11
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = Decodificador de vídeo WMF VPX

reset-on-next-restart = Restablecer en el próximo reinicio
gpu-process-kill-button = Terminar proceso GPU
gpu-device-reset = Reiniciar dispositivo
gpu-device-reset-button = Provocar reinicio del dispositivo
uses-tiling = Usa mosaicos
content-uses-tiling = Usa mosaicos (contenido)
off-main-thread-paint-enabled = Dibujado fuera del hilo principal de ejecución activado
off-main-thread-paint-worker-count = Contador de workers de dibujado ajenos al hilo principal de ejecución
target-frame-rate = Frecuencia de imágenes objetivo

min-lib-versions = Versión mínima esperada
loaded-lib-versions = Versión en uso

has-seccomp-bpf = Seccomp-BPF (filtrado de llamadas de sistema)
has-seccomp-tsync = Sincronización de hilos seccomp
has-user-namespaces = Espacios de nombres de usuario
has-privileged-user-namespaces = Espacios de nombres de usuarios para procesos privilegiados
can-sandbox-content = Aislamiento del proceso de contenido
can-sandbox-media = Aislamiento de plugins de medios
content-sandbox-level = Nivel de aislamiento del proceso de contenido
effective-content-sandbox-level = Nivel efectivo de aislamiento (sandboxing) para los procesos de contenido
content-win32k-lockdown-state = Estado de bloqueo Win32k del proceso para los contenidos
sandbox-proc-type-content = contenido
sandbox-proc-type-file = contenido del archivo
sandbox-proc-type-media-plugin = plugin de medios
sandbox-proc-type-data-decoder = decodificador de datos

startup-cache-title = Caché de inicio
startup-cache-disk-cache-path = Ruta de caché de disco
startup-cache-ignore-disk-cache = Ignorar caché de disco
startup-cache-found-disk-cache-on-init = Caché de disco encontrada durante la inicialización
startup-cache-wrote-to-disk-cache = Se escribió a la caché de disco

launcher-process-status-0 = Activado
launcher-process-status-1 = Desactivado por fallo
launcher-process-status-2 = Desactivado forzosamente
launcher-process-status-unknown = Estado desconocido

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/{ $totalWindows }
fission-status-experiment-control = Desactivado por el experimento
fission-status-experiment-treatment = Activado por el experimento
fission-status-disabled-by-e10s-env = Desactivado por el entorno
fission-status-enabled-by-env = Activado por el entorno
fission-status-disabled-by-safe-mode = Desactivado por el modo seguro
fission-status-enabled-by-default = Activado de forma predeterminada
fission-status-disabled-by-default = Desactivado de forma predeterminada
fission-status-enabled-by-user-pref = Activado por el usuario
fission-status-disabled-by-user-pref = Desactivado por el usuario
fission-status-disabled-by-e10s-other = E10s desactivado
fission-status-enabled-by-rollout = Habilitado por el lanzamiento por fases

async-pan-zoom = Encuadre/zoom asíncrono
apz-none = ninguno
wheel-enabled = entrada de rueda de ratón activada
touch-enabled = entrada táctil activada
drag-enabled = arrastre de la barra de desplazamiento activado
keyboard-enabled = teclado habilitado
autoscroll-enabled = desplazamiento automático activado
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

support-printing-title = Imprimiendo
support-printing-troubleshoot = Solución de problemas
support-printing-clear-settings-button = Eliminar los ajustes de impresión guardados
support-printing-modified-settings = Ajustes de impresión modificados
support-printing-prefs-name = Nombre
support-printing-prefs-value = Valor

## Normandy sections

support-remote-experiments-title = Experimentos remotos
support-remote-experiments-name = Nombre
support-remote-experiments-branch = Rama de experimentos
support-remote-experiments-see-about-studies = Ver <a data-l10n-name="support-about-studies-link">about:studies</a> para más información, incluyendo como desactivar experimentos individuales o desactivar que { -brand-short-name } ejecute este tipo de experimentos en el futuro.

support-remote-features-title = Funciones remotas
support-remote-features-name = Nombre
support-remote-features-status = Estado
