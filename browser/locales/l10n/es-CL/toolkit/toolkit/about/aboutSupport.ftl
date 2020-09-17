# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Información para resolver problemas
page-subtitle =
    Esta página contiene información técnica que puede serle útil cuando
    intente resolver un problema. Si está buscando respuestas a preguntas comunes
    acerca de { -brand-short-name }, mire en nuestro <a data-l10n-name="support-link">sitio web de soporte</a>.
crashes-title = Informes de fallos
crashes-id = ID del informe
crashes-send-date = Enviado
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
support-addons-enabled = Activado
support-addons-version = Versión
support-addons-id = ID
security-software-title = Software de seguridad
security-software-type = Tipo
security-software-name = Nombre
security-software-antivirus = Antivirus
security-software-antispyware = Antispyware
security-software-firewall = Firewall
features-title = Funciones de { -brand-short-name }
features-name = Nombre
features-version = Versión
features-id = ID
processes-title = Procesos remotos
processes-type = Tipo
processes-count = Cantidad
app-basics-title = Detalles básicos de la aplicación
app-basics-name = Nombre
app-basics-version = Versión
app-basics-build-id = ID de compilación
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
        [linux] Directorio del perfil
       *[other] Carpeta de perfil
    }
app-basics-enabled-plugins = Complementos habilitados
app-basics-build-config = Configuración de Build
app-basics-user-agent = Agente de usuario
app-basics-os = S.O.
app-basics-memory-use = Uso de memoria
app-basics-performance = Rendimiento
app-basics-service-workers = Service Workers registrados
app-basics-profiles = Perfiles
app-basics-launcher-process-status = Proceso lanzador
app-basics-multi-process-support = Ventanas multiproceso
app-basics-remote-processes-count = Procesos remotos
app-basics-enterprise-policies = Políticas empresariales
app-basics-location-service-key-google = Clave del servicio de localización de Google
app-basics-safebrowsing-key-google = Clave del servicio de navegación segura de Google
app-basics-key-mozilla = Clave del servicio de localización de Mozilla
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
experimental-features-title = Funcionalidades experimentales
experimental-features-name = Nombre
experimental-features-value = Valor
modified-key-prefs-title = Preferencias importantes modificadas
modified-prefs-name = Nombre
modified-prefs-value = Valor
user-js-title = Preferencias de user.js
user-js-description = Su perfil contiene un <a data-l10n-name="user-js-link">archivo user.js</a>, que contiene preferencias que no fueron creadas por { -brand-short-name }.
locked-key-prefs-title = Preferencias bloqueadas importantes
locked-prefs-name = Nombre
locked-prefs-value = Valor
graphics-title = Gráficos
graphics-features-title = Funciones
graphics-diagnostics-title = Diagnósticos
graphics-failure-log-title = Registro de fallos
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Registro de decisiones
graphics-crash-guards-title = Funciones desactivadas de protección contra fallos
graphics-workarounds-title = Soluciones
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Protocolo de ventana
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Entorno de escritorio
place-database-title = Base de datos de lugares
place-database-integrity = Integridad
place-database-verify-integrity = Verificar integridad
a11y-title = Accesibilidad
a11y-activated = Activado
a11y-force-disabled = Prevenir accesibilidad
a11y-handler-used = Gestionador accesible usado
a11y-instantiator = Instanciador de accesibilidad
library-version-title = Versiones de libs
copy-text-to-clipboard-label = Copiar texto al portapapeles
copy-raw-data-to-clipboard-label = Copiar datos en bruto al portapapeles
sandbox-title = Aislamiento
sandbox-sys-call-log-title = Llamadas del sistema rechazadas
sandbox-sys-call-index = #
sandbox-sys-call-age = Hace unos segundos
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Tipo de proceso
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Argumentos
safe-mode-title = Probar el modo seguro
restart-in-safe-mode-label = Reiniciar sin complementos…
clear-startup-cache-title = Intenta limpiar la caché de inicio
clear-startup-cache-label = Limpiar caché de inicio…
startup-cache-dialog-title = Limpiar caché de inicio
startup-cache-dialog-body = Reinicia { -brand-short-name } para limpiar la caché de inicio. Esto no cambiará tu configuración ni elimina las extensiones que has agregado a { -brand-short-name }.
restart-button-label = Reiniciar

## Media titles

audio-backend = Backend de audio
max-audio-channels = Canales máximos
sample-rate = Frecuencia de muestreo preferida
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
intl-app-title = Ajustes de aplicación
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

remote-debugging-title = Depuración remota (protocolo de Chromium)
remote-debugging-accepting-connections = Aceptando conexiones
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Informes de fallos para el último { $days } día
       *[other] Informes de fallos para los últimos { $days } días
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
        [one] Todos los informes de fallos (incluyendo { $reports } fallo pendiente dentro del rango de tiempo dado)
       *[other] Todos los informes de fallos (incluyendo { $reports } fallos pendientes dentro del rango de tiempo dado)
    }
raw-data-copied = Datos en bruto copiados al portapapeles
text-copied = Texto copiado al portapapeles

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Bloqueado para la versión de su driver de video.
blocked-gfx-card = Se bloqueó el driver de video por problemas no resueltos en el driver.
blocked-os-version = Bloqueado para su versión de sistema operativo.
blocked-mismatched-version = Bloqueado para su controlador de gráficos debido a disparidad de versión entre el registro y el DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Bloqueado para la versión de su driver de video. Intente actualizar el driver a la versión { $driverVersion } o superior.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Parámetros de ClearType
compositing = Composición
hardware-h264 = Decodificación H264 por hardware
main-thread-no-omtc = hilo principal, no OMTC
yes = Sí
no = No
unknown = Desconocido
virtual-monitor-disp = Pantalla virtual

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Encontrado
missing = Faltante
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Descripción
gpu-vendor-id = ID de fabricante
gpu-device-id = ID de dispositivo
gpu-subsys-id = ID del subsistema
gpu-drivers = Controladores
gpu-ram = RAM
gpu-driver-vendor = Productor del driver
gpu-driver-version = Versión del driver
gpu-driver-date = Fecha del driver
gpu-active = Activo
webgl1-wsiinfo = Info WSI del controlador WebGL 1
webgl1-renderer = Renderizador del controlador WebGL 1
webgl1-version = Versión del controlador WebGL 1
webgl1-driver-extensions = Extensiones del controlador WebGL 1
webgl1-extensions = Extensiones WebGL 1
webgl2-wsiinfo = Info WSI del controlador WebGL 2
webgl2-renderer = Procesador WebGL2
webgl2-version = Versión del controlador WebGL 2
webgl2-driver-extensions = Extensiones WebGL 2
webgl2-extensions = Extensiones WebGL 2
blocklisted-bug = En lista negra debido a problemas conocidos
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = bug { $bugNumber }
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = En lista de bloqueo debido a problemas conocidos: <a data-l10n-name="bug-link">{ $bugNumber }</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = En lista negra; código de fallo { $failureCode }
d3d11layers-crash-guard = Compositor D3D11
d3d11video-crash-guard = Decodificador de video D3D11
d3d9video-crash-guard = Decodificador de video D3D9
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = Decodificador de video WMF VPX
reset-on-next-restart = Restablecer en el próximo reinicio
gpu-process-kill-button = Terminar proceso GPU
gpu-device-reset = Reinicio de dispositivo
gpu-device-reset-button = Reiniciar dispositivo gatillante
uses-tiling = Usa mosaicos
content-uses-tiling = Usa mosaicos (contenido)
off-main-thread-paint-enabled = Pintura fuera del hilo principal activada
off-main-thread-paint-worker-count = Número de workers de pintura fuera del hilo principal
target-frame-rate = Tasa de cuadros objetivo
min-lib-versions = Versión mínima esperada
loaded-lib-versions = Versión en uso
has-seccomp-bpf = Seccomp-BPF (Filtrado de llamadas del sistema)
has-seccomp-tsync = Sincronización de hilos Seccomp
has-user-namespaces = Espacios de nombre de usuario
has-privileged-user-namespaces = Espacios de nombre de usuario para procesos privilegiados
can-sandbox-content = Aislamiento de procesos de contenido
can-sandbox-media = Aislamiento de complementos de medios
content-sandbox-level = Nivel de aislamiento de procesos de contenido
effective-content-sandbox-level = Nivel efectivo del contenedor de proceso de contenido
sandbox-proc-type-content = contenido
sandbox-proc-type-file = contenido del archivo
sandbox-proc-type-media-plugin = complemento de medios
sandbox-proc-type-data-decoder = decodificador de datos
startup-cache-title = Caché de inicio
startup-cache-disk-cache-path = Ubicación de la caché en disco
startup-cache-ignore-disk-cache = Ignorar caché en disco
startup-cache-found-disk-cache-on-init = Se encontró caché en disco en Init
startup-cache-wrote-to-disk-cache = Se escribió a la caché en disco
launcher-process-status-0 = Activado
launcher-process-status-1 = Desactivado por fallo
launcher-process-status-2 = Desactivado forzosamente
launcher-process-status-unknown = Estado desconocido
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Activado por el usuario
multi-process-status-1 = Activado por defecto
multi-process-status-2 = Desactivado
multi-process-status-4 = Desactivado por herramientas de accesibilidad
multi-process-status-6 = Desactivado por entrada de texto incompatible
multi-process-status-7 = Desactivado por complementos
multi-process-status-8 = Desactivado forzosamente
multi-process-status-unknown = Estado desconocido
async-pan-zoom = Aumento asíncrono
apz-none = ninguno
wheel-enabled = entrada de rueda activada
touch-enabled = entrada táctil activada
drag-enabled = arrastre de barra de desplazamiento activado
keyboard-enabled = teclado activado
autoscroll-enabled = desplazamiento automático activado
zooming-enabled = aumento con pellizco suave habilitado

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = entrada de rueda asíncrona desactivada debido a preferencia no soportada: { $preferenceKey }
touch-warning = entrada táctil asíncrona desactivada debido a preferencia no soportada: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Inactivo
policies-active = Activo
policies-error = Error
