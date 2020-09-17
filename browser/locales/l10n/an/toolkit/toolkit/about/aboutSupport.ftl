# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Información pa solucionar problemas
page-subtitle = Ista pachina contiene información tecnica que puede estar util quan prebe de resolver un problema. Si ye buscando respuestas a preguntas freqüents sobre { -brand-short-name }, mire o <a data-l10n-name="support-link">puesto d'asistencia</a>.
crashes-title = Informes de fallos
crashes-id = ID d'o informe
crashes-send-date = Ninviau
crashes-all-reports = Totz os informes de fallo
crashes-no-config = Ista aplicación no ye configurada ta amostrar informes de fallos.
extensions-title = Extensions
extensions-name = Nombre
extensions-enabled = Activada
extensions-version = Versión
extensions-id = ID
support-addons-title = Complementos
support-addons-name = Nombre
support-addons-type = Tipo
support-addons-enabled = Activau
support-addons-version = Versión
support-addons-id = ID
security-software-title = Software de seguranza
security-software-type = Tipo
security-software-name = Nombre
security-software-antivirus = Antivirus
security-software-antispyware = Antispyware
security-software-firewall = Firewall
features-title = Caracteristicas de { -brand-short-name }
features-name = Nombre
features-version = Versión
features-id = ID
processes-title = Procesos remotos
processes-type = Tipo
processes-count = Cuenta
app-basics-title = Configuración basica de l'aplicación
app-basics-name = Nombre
app-basics-version = Versión
app-basics-build-id = Construir ID
app-basics-distribution-id = ID de distribución
app-basics-update-channel = Esviellar a Canal
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Directorio d'actualizacions
       *[other] Carpeta d'actualizacions
    }
app-basics-update-history = Historial d'actualizacions
app-basics-show-update-history = Amostrar l'historial d'actualizacions
# Represents the path to the binary used to start the application.
app-basics-binary = Binario de l'aplicación
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Directorio de perfil
       *[other] Carpeta de perfil
    }
app-basics-enabled-plugins = Plugins activaus
app-basics-build-config = Configuración de compilación
app-basics-user-agent = Achent d'usuario
app-basics-os = SO
app-basics-memory-use = Uso de memoria
app-basics-performance = Rendimiento
app-basics-service-workers = Service Workers rechistraus
app-basics-profiles = Perfils
app-basics-launcher-process-status = Proceso de lanzamiento
app-basics-multi-process-support = Finestras multiproceso
app-basics-remote-processes-count = Procesos remotos
app-basics-enterprise-policies = Politicas d'interpresa
app-basics-location-service-key-google = Clau d'o servicio de plazamiento de Google
app-basics-safebrowsing-key-google = Clau d'o servicio de navegación segura de Google
app-basics-key-mozilla = Clau d'o servicio de plazamiento de Mozilla
app-basics-safe-mode = Modo seguro
show-dir-label =
    { PLATFORM() ->
        [macos] Amostrar en o Finder
        [windows] Ubrir la carpeta
       *[other] Ubrir o directorio
    }
environment-variables-title = Variables d'entorno
environment-variables-name = Nombre
environment-variables-value = Valor
experimental-features-title = Caracteristicas experimentals
experimental-features-name = Nombre
experimental-features-value = Valor
modified-key-prefs-title = Preferencias modificadas importants
modified-prefs-name = Nombre
modified-prefs-value = Valura
user-js-title = Preferencias de user.js
user-js-description = A suya carpeta de perfil contien un <a data-l10n-name="user-js-link">fichero user.js</a> que bi incluye as preferencias que no estioron creyadas por { -brand-short-name }.
locked-key-prefs-title = Preferencias importants blocadas
locked-prefs-name = Nombre
locked-prefs-value = Valura
graphics-title = Graficos
graphics-features-title = Caracteristicas
graphics-diagnostics-title = Diagnosticos
graphics-failure-log-title = Rechistro de fallos
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Rechistro de decisions
graphics-crash-guards-title = Caracteristicas Crash Guard desactivadas
graphics-workarounds-title = Solucions temporals
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Protocolo de finestra
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Entorno d'escritorio
place-database-title = Base de datos de puestos
place-database-integrity = Integridat
place-database-verify-integrity = Verificar Integridat
a11y-title = Accesibilidat
a11y-activated = Activau
a11y-force-disabled = Privar accesibilidat
a11y-handler-used = S'ha usau un maniador accesible
a11y-instantiator = Instanciador d'accesibilidat
library-version-title = Versions d'a biblioteca
copy-text-to-clipboard-label = Copiar o texto en o portafuellas
copy-raw-data-to-clipboard-label = Copiar os datos crudos en o portafuellas
sandbox-title = Borrador
sandbox-sys-call-log-title = Gritadas a lo sistema refusadas
sandbox-sys-call-index = #
sandbox-sys-call-age = Fa bells segundos
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Tipo de proceso
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Argumentos
safe-mode-title = Intentar en Modo Seguro
restart-in-safe-mode-label = Reiniciar con os complementos desactivaus…
clear-startup-cache-title = Mira de limpiar la caché d'inicio
clear-startup-cache-label = Limpiando la caché d'inicio...
startup-cache-dialog-title = Limpiando la caché d'inicio
startup-cache-dialog-body = Reinicia { -brand-short-name } pa limpiar la caché d'inicio. Esto no cambiará las tuyas preferencias ni eliminará las extensions que has anyadiu a { -brand-short-name }.
restart-button-label = Reiniciar

## Media titles

audio-backend = Sistema de fondo d'audio
max-audio-channels = Maximo numero de canals
sample-rate = Freqüencia de mostreyo preferida
roundtrip-latency = Latencia roundtrip (desviacion standar)
media-title = Multimedia
media-output-devices-title = Dispositivos de salida
media-input-devices-title = Dispositivos de dentrada
media-device-name = Nombre
media-device-group = Grupo
media-device-vendor = Fabricant
media-device-state = Estau
media-device-preferred = Preferiu
media-device-format = Formato
media-device-channels = Canals
media-device-rate = Freqüencia
media-device-latency = Latencia
media-capabilities-title = Capacidatz multimedia
# List all the entries of the database.
media-capabilities-enumerate = Enumerar la base de datos

##

intl-title = Internacionalización & localización
intl-app-title = Achustes d'aplicación
intl-locales-requested = Locales demandadas
intl-locales-available = Locales disponibles
intl-locales-supported = Locales d'Aplicación
intl-locales-default = Locale per defecto
intl-os-title = Sistema operativo
intl-os-prefs-system-locales = Locales d'o sistema
intl-regional-prefs = Preferencias rechionals

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Debug a distancia (protocolo Chromium)
remote-debugging-accepting-connections = Se son acceptando las connexions
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Informes de fallos d'o zaguer día
       *[other] Informes de fallos d'os zaguers { $days } días
    }
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] En fa { $minutes } minuto
       *[other] En fa { $minutes } minutos
    }
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] En fa { $hours } hora
       *[other] En fa { $hours } horas
    }
# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] En fa { $days } día
       *[other] En fa { $days } días
    }
# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Totz os informes de fallos (incluindo { $reports } fallo pendient en o entrevalo de tiempo indicau)
       *[other] Totz os informes de fallos (incluindo { $reports } fallos pendients en o entrevalo de tiempo indicau)
    }
raw-data-copied = S'han copiau ss datos crudos en o portafuellas
text-copied = S'ha copiau o texto en o portafuellas

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Bloqueyau ta la versión d'o suyo controlador grafico.
blocked-gfx-card = Bloqueyau ta la suya tarcheta grafica a causa de problemas no resueltos d'o controlador.
blocked-os-version = Bloqueyau ta la versión d'o suyo sistema operativo.
blocked-mismatched-version = Bloqueyau ta la versión d'o suyo controlador grafico no coincide o rechistro y DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Bloqueyau ta la versión d'o suyo controlador grafico. Mire d'actualizar o suyo controlador grafico a la versión { $driverVersion } u mas moderna.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Parametros de ClearType
compositing = Redactando
hardware-h264 = Decodificación Hardware H264
main-thread-no-omtc = filo principal, no OMTC
yes = Sí
no = No
unknown = Desconoixiu
virtual-monitor-disp = Pantalla de monitor virtual

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Trobau
missing = Falta
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Descripción
gpu-vendor-id = ID d'o fabricante
gpu-device-id = ID d'o dispositivo
gpu-subsys-id = Subsys ID
gpu-drivers = Controladors
gpu-ram = RAM
gpu-driver-vendor = Casa d'o driver
gpu-driver-version = Versión d'o controlador
gpu-driver-date = Calendata d'o controlador
gpu-active = Activo
webgl1-wsiinfo = WebGL 1 Driver WSI Info
webgl1-renderer = WebGL 1 Driver Renderer
webgl1-version = WebGL 1 Driver Version
webgl1-driver-extensions = WebGL 1 Driver Extensions
webgl1-extensions = WebGL 1 Extensions
webgl2-wsiinfo = WebGL 2 Driver WSI Info
webgl2-renderer = WebGL 2 Driver Renderer
webgl2-version = WebGL 2 Driver Version
webgl2-driver-extensions = WebGL 2 Driver Extensions
webgl2-extensions = WebGL 2 Extensions
blocklisted-bug = S'ha ficau en a lista de bloqueyo por problemas conoixius
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = bug { $bugNumber }
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Blocada per problemas conoixius d'o <a data-l10n-name="bug-link">bug { $bugNumber }</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = En a lista de bloqueyo; codigo de fallo { $failureCode }
d3d11layers-crash-guard = Compositor D3D11
d3d11video-crash-guard = Decodificador de video D3D11
d3d9video-crash-guard = Decodificador de video D3D9
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = Decodificador de video WMF VPX
reset-on-next-restart = Meter propiedatz por defecto en o siguient reinicio.
gpu-process-kill-button = Rematar proceso GPU
gpu-device-reset = Reinicio d'o driver
gpu-device-reset-button = Reinicio d'o dispositivo activador
uses-tiling = Fa servir mosaicos
content-uses-tiling = Fa servir mosaicos (conteniu)
off-main-thread-paint-enabled = S'ha activau lo Painting difuera d'o filo d'execución principal
off-main-thread-paint-worker-count = Numero de workers de pintura defuera d'o filo principal
target-frame-rate = Freqüencia d'imachens deseyada
min-lib-versions = S'asperaba una versión minima
loaded-lib-versions = Versión en uso
has-seccomp-bpf = Seccomp-BPF (Filtrau de Clamadas a o Sistema)
has-seccomp-tsync = Sincronización de filos Seccomp
has-user-namespaces = Espacios de nombres de l'usuario
has-privileged-user-namespaces = Espacions de nombres de l'usuario pa procesos privilechiaus
can-sandbox-content = Content Process Sandboxing
can-sandbox-media = Seccomp-BPF (Filtrado de Clamadas a o Sistema)
content-sandbox-level = Nibel de l'entorno de prebas de proceso d'o conteniu
effective-content-sandbox-level = Nivel efectivo d'a zona de prebatinas d'os procesos de conteniu
sandbox-proc-type-content = conteniu
sandbox-proc-type-file = conteniu d'o fichero
sandbox-proc-type-media-plugin = plugin multimedia
sandbox-proc-type-data-decoder = descodificador de datos
startup-cache-title = Caché d'inicio
startup-cache-disk-cache-path = Ruta d'a caché de disco
startup-cache-ignore-disk-cache = Ignorar la caché de disco
startup-cache-found-disk-cache-on-init = Caché de disco trobada en l'inicialización
startup-cache-wrote-to-disk-cache = Escrito en a caché de deisco
launcher-process-status-0 = Activau
launcher-process-status-1 = Desactivau per causa d'un fallo
launcher-process-status-2 = Desactivau forzadament
launcher-process-status-unknown = Estau desconoixiu
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Activau por l'usuario
multi-process-status-1 = Activau por defecto
multi-process-status-2 = Desactivau
multi-process-status-4 = Desactivau por las ferramientas d'accesibilidat
multi-process-status-6 = Desactivau por no estar soportada la dentrada de texto
multi-process-status-7 = Desactivau por complementos
multi-process-status-8 = Desactivar forzadament
multi-process-status-unknown = Estau desconoixiu
async-pan-zoom = Pan/Zoom asincronos
apz-none = garra
wheel-enabled = dentrada con rueda activada
touch-enabled = dentrada tactil activada
drag-enabled = s'ha activau l'arrocegamiento d'a barra de desplazamiento
keyboard-enabled = teclau activau
autoscroll-enabled = desplazamiento automatico activau
zooming-enabled = Activau lo smooth pinch-zoom

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = a dentrada con rueda asincrona ye desactivada porque i ha una preferencia incompatible: { $preferenceKey }
touch-warning = a dentrada tactil asincrona ye desactivada porque i ha una preferencia incompatible: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Inactivo
policies-active = Activo
policies-error = Eror
