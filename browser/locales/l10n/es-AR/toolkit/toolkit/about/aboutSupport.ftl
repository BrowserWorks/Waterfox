# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Información para solución de problemas
page-subtitle =
    Esta página contiene información técnica que podría ser útil si está
    tratando de resolver un problema. Si está buscando respuestas a preguntas comunes
    acerca de { -brand-short-name }, busque en el <a data-l10n-name="support-link">sitio web de soporte</a>.
crashes-title = Informes de fallos
crashes-id = ID de informe
crashes-send-date = Enviados
crashes-all-reports = Todos los informes de fallos
crashes-no-config = Esta aplicación no ha sido configurada para mostrar informes de fallos.
extensions-title = Extensiones
extensions-name = Nombre
extensions-enabled = Habilitada
extensions-version = Versión
extensions-id = ID
support-addons-title = Complementos
support-addons-name = Nombre
support-addons-type = Tipo
support-addons-enabled = Habilitado
support-addons-version = Versión
support-addons-id = ID
security-software-title = Programa de seguridad
security-software-type = Tipo
security-software-name = Nombre
security-software-antivirus = Antivirus
security-software-antispyware = Programas anti espías
security-software-firewall = Cortafuego
features-title = Características de { -brand-short-name }
features-name = Nombre
features-version = Versión
features-id = ID
processes-title = Procesos remotos
processes-type = Tipo
processes-count = Cantidad
app-basics-title = Esenciales de la aplicación
app-basics-name = Nombre
app-basics-version = Versión
app-basics-build-id = ID de Build
app-basics-distribution-id = ID de distribución
app-basics-update-channel = Canal de actualización
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Directorio de actualización
       *[other] Carpeta de actualización
    }
app-basics-update-history = Historial de actualizaciones
app-basics-show-update-history = Mostrar historial de actualizaciones
# Represents the path to the binary used to start the application.
app-basics-binary = Binario de aplicación
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Directorio de perfil
       *[other] Carpeta de perfil
    }
app-basics-enabled-plugins = Plugins habilitados
app-basics-build-config = Configuración de compilación
app-basics-user-agent = Agente de usuario
app-basics-os = SO
app-basics-memory-use = Uso de memoria
app-basics-performance = Rendimiento
app-basics-service-workers = ServiceWorkers registrados
app-basics-profiles = Perfiles
app-basics-launcher-process-status = Proceso lanzador
app-basics-multi-process-support = Ventanas multiproceso
app-basics-remote-processes-count = Procesos remotos
app-basics-enterprise-policies = Políticas empresariales
app-basics-location-service-key-google = Clave del servicio de localización de Google
app-basics-safebrowsing-key-google = Google Safebrowsing Key
app-basics-key-mozilla = Clave del servicio de ubicación de Mozilla
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
experimental-features-title = Funciones experimentales
experimental-features-name = Nombre
experimental-features-value = Valor
modified-key-prefs-title = Preferencias importantes modificadas
modified-prefs-name = Nombre
modified-prefs-value = Valor
user-js-title = Preferencias en user.js
user-js-description = Su carpeta de perfil contiene un <a data-l10n-name="user-js-link">archivo user.js</a>, que incluye preferencias que no fueron creadas por { -brand-short-name }.
locked-key-prefs-title = Preferencias importantes bloqueadas
locked-prefs-name = Nombre
locked-prefs-value = Valor
graphics-title = Gráficos
graphics-features-title = Características
graphics-diagnostics-title = Diagnósticos
graphics-failure-log-title = Registro de fallas
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Registro de decisión
graphics-crash-guards-title = Características de protección contra fallos deshabilitadas
graphics-workarounds-title = Soluciones
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Protocolo de ventana
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Entorno de escritorio
place-database-title = Base de datos de lugares
place-database-integrity = Integridad
place-database-verify-integrity = Verificar integridad
a11y-title = Accesibilidad
a11y-activated = Activada
a11y-force-disabled = Impedir accesibilidad
a11y-handler-used = Se usó un Controlador accesible
a11y-instantiator = Instanciador de accesibilidad
library-version-title = Versiones de libs
copy-text-to-clipboard-label = Copiar texto al portapapeles
copy-raw-data-to-clipboard-label = Copiar datos en bruto al portapapeles
sandbox-title = Sandbox
sandbox-sys-call-log-title = Llamadas del sistema rechazadas
sandbox-sys-call-index = #
sandbox-sys-call-age = Hace segundos
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Tipo de proceso
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Argumentos
safe-mode-title = Intentar modo seguro
restart-in-safe-mode-label = Reiniciar con complementos deshabilitados…
clear-startup-cache-title = Intentar borrar la caché de inicio
clear-startup-cache-label = Eliminar caché de inicio…
startup-cache-dialog-title = Eliminar caché de inicio
startup-cache-dialog-body = Reiniciar { -brand-short-name } para eliminar la caché de inicio. Esto no va a cambiar su configuración ni va a eliminar las extensiones que haya agregó a { -brand-short-name }.
restart-button-label = Reiniciar

## Media titles

audio-backend = Backend de audio
max-audio-channels = Canales máximos
sample-rate = Frecuencia de muestreo principal
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
media-device-rate = Frecuencia
media-device-latency = Latencia
media-capabilities-title = Capacidades de medios
# List all the entries of the database.
media-capabilities-enumerate = Enumerar base de datos

##

intl-title = Internacionalización y localización
intl-app-title = Configuración de la aplicación
intl-locales-requested = Idiomas solicitados
intl-locales-available = Idiomas disponibles
intl-locales-supported = Idiomas de la aplicación
intl-locales-default = Idioma predeterminado
intl-os-title = Sistema operativo
intl-os-prefs-system-locales = Idiomas del sistema
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
remote-debugging-accepting-connections = Aceptar conexiones
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Informes de fallo del ultimo día
       *[other] Informes de fallos de los últimos { $days } días
    }
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] Hace { $minutes } minuto
       *[other] Hace { $minutes } minutos
    }
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] Hace { $hours } hora
       *[other] Hace { $hours } horas
    }
# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] Hace { $days } día
       *[other] Hace { $days } días
    }
# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Todos los informes de fallos (incluyendo { $reports } fallo pendiente en el rango de tiempo especificado)
       *[other] Todos los informes de fallos (incluyendo { $reports } fallos pendientes en el rango de tiempo especificado)
    }
raw-data-copied = Datos en bruto copiados al portapapeles
text-copied = Texto copiado al portapapeles

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Bloqueado para la versión de su driver de video.
blocked-gfx-card = Se bloqueó el driver de video por problemas no resueltos en el mismo.
blocked-os-version = Bloqueado para su versión de sistema operativo.
blocked-mismatched-version = Bloqueado porque no coincide la versión del controlador gráfico entre registro y DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Bloqueado para la versión de su driver de video. Intente actualizar el driver a la versión { $driverVersion } o superior.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Parámetros de ClearType
compositing = Composición
hardware-h264 = Decodificación H264 por hadrware
main-thread-no-omtc = hilo principal, no OMTC
yes = Si
no = No
unknown = Desconocido
virtual-monitor-disp = Pantalla del monitor virtual

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Encontrada
missing = Faltante
gpu-process-pid = GPUProcessPid
gpu-process = Proceso GPU
gpu-description = Descripción
gpu-vendor-id = ID de vendedor
gpu-device-id = ID de dispositivo
gpu-subsys-id = ID de Subsys
gpu-drivers = Drivers
gpu-ram = RAM
gpu-driver-vendor = Vendedor del driver
gpu-driver-version = Versión de driver
gpu-driver-date = Fecha del driver
gpu-active = Activa
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
wmfvpxvideo-crash-guard = Decodificador de video WMF VPX
reset-on-next-restart = Restablecer en próximo reinicio
gpu-process-kill-button = Terminar proceso de GPU
gpu-device-reset = Restablecer dispositivo
gpu-device-reset-button = Reinicio del dispositivo gatillo
uses-tiling = Utiliza mosaicos
content-uses-tiling = Utiliza baldosas (contenido)
off-main-thread-paint-enabled = Pintura habilitada fuera del hilo principal
off-main-thread-paint-worker-count = Cantidad de workers de pintura fuera del hilo principal
target-frame-rate = Tasa de marco de destino
min-lib-versions = Versión mínima esperada
loaded-lib-versions = Versión en uso
has-seccomp-bpf = Seccomp-BPF (Filtrado de llamadas del sistema)
has-seccomp-tsync = Sincronización de hilos seccomp
has-user-namespaces = User Namespaces
has-privileged-user-namespaces = User Namespaces for privileged processes
can-sandbox-content = Content Process Sandboxing
can-sandbox-media = Media Plugin Sandboxing
content-sandbox-level = Content Process Sandbox Level
effective-content-sandbox-level = Proceso de contenido efectivo del nivel de Sandbox
sandbox-proc-type-content = contenido
sandbox-proc-type-file = contenido de archivo
sandbox-proc-type-media-plugin = plugin de medios
sandbox-proc-type-data-decoder = decodificador de datos
startup-cache-title = Caché de inicio
startup-cache-disk-cache-path = Ruta de caché de disco
startup-cache-ignore-disk-cache = Ignorar caché de disco
startup-cache-found-disk-cache-on-init = Se encontró caché de disco en Init
startup-cache-wrote-to-disk-cache = Escribió en caché de disco
launcher-process-status-0 = Habilitado
launcher-process-status-1 = Deshabilitado por fallo
launcher-process-status-2 = Deshabilitado por la fuerza
launcher-process-status-unknown = Estado desconocido
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Habilitado por el usuario
multi-process-status-1 = Habilitado por defecto
multi-process-status-2 = Deshabilitado
multi-process-status-4 = Deshabilitado por herramientas de accesibilidad
multi-process-status-6 = Deshabiliatdo por ingreso de texto no soportado
multi-process-status-7 = Deshabilitado por complementos
multi-process-status-8 = Deshabilitado por la fuerza
multi-process-status-unknown = Estado desconocido
async-pan-zoom = Asynchronous Pan/Zoom
apz-none = ninguna
wheel-enabled = rueda habilitada
touch-enabled = táctil habilitado
drag-enabled = arrastre de barra de desplazamiento habilitado
keyboard-enabled = teclado habilitado
autoscroll-enabled = desplazamiento automático habilitado
zooming-enabled = zoom de pellizco suave habilitado

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = rueda no sincrónica deshabilitada por preferencia no soportada: { $preferenceKey }
touch-warning = táctil no sincrónico deshabilitado por preferencia no soportada: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Inactivo
policies-active = Activo
policies-error = Error
