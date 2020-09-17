# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Informació de resolució de problemes
page-subtitle = Aquesta pàgina conté informació tècnica que pot ser útil quan proveu de resoldre un problema. Si cerqueu respostes per a preguntes freqüents del { -brand-short-name }, visiteu el nostre <a data-l10n-name="support-link">lloc web d'assistència</a>.
crashes-title = Informes de fallada
crashes-id = Identificador de l'informe
crashes-send-date = Data d'enviament
crashes-all-reports = Tots els informes de fallada
crashes-no-config = Aquesta aplicació no està configurada per visualitzar els informes de fallada.
extensions-title = Extensions
extensions-name = Nom
extensions-enabled = Habilitada
extensions-version = Versió
extensions-id = ID
support-addons-title = Complements
support-addons-name = Nom
support-addons-type = Tipus
support-addons-enabled = Activat
support-addons-version = Versió
support-addons-id = ID
security-software-title = Programari de seguretat
security-software-type = Tipus
security-software-name = Nom
security-software-antivirus = Antivirus
security-software-antispyware = Antiespia
security-software-firewall = Tallafoc
features-title = Característiques del { -brand-short-name }
features-name = Nom
features-version = Versió
features-id = ID
processes-title = Processos remots
processes-type = Tipus
processes-count = Recompte
app-basics-title = Paràmetres bàsics de l'aplicació
app-basics-name = Nom
app-basics-version = Versió
app-basics-build-id = Identificador del muntatge
app-basics-distribution-id = ID de distribució
app-basics-update-channel = Canal d'actualitzacions
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Directori d'actualitzacions
       *[other] Carpeta d'actualitzacions
    }
app-basics-update-history = Historial d'actualitzacions
app-basics-show-update-history = Mostra l'historial d'actualitzacions
# Represents the path to the binary used to start the application.
app-basics-binary = Binari de l'aplicació
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Directori del perfil
       *[other] Carpeta del perfil
    }
app-basics-enabled-plugins = Connectors habilitats
app-basics-build-config = Configuració de la versió
app-basics-user-agent = Agent d'usuari
app-basics-os = Sistema operatiu
app-basics-memory-use = Utilització de la memòria
app-basics-performance = Rendiment
app-basics-service-workers = Processos de treball de servei registrats
app-basics-profiles = Perfils
app-basics-launcher-process-status = Procés d'inici
app-basics-multi-process-support = Finestres multiprocés
app-basics-remote-processes-count = Processos remots
app-basics-enterprise-policies = Polítiques d'empresa
app-basics-location-service-key-google = Clau del servei d'ubicació de Google
app-basics-safebrowsing-key-google = Clau del servei de navegació segura Google Safebrowsing
app-basics-key-mozilla = Clau del servei d'ubicació de Mozilla
app-basics-safe-mode = Mode segur
show-dir-label =
    { PLATFORM() ->
        [macos] Mostra-ho en el Finder
        [windows] Obre la carpeta
       *[other] Obre el directori
    }
environment-variables-title = Variables d'entorn
environment-variables-name = Nom
environment-variables-value = Valor
experimental-features-title = Funcions experimentals
experimental-features-name = Nom
experimental-features-value = Valor
modified-key-prefs-title = Preferències modificades importants
modified-prefs-name = Nom
modified-prefs-value = Valor
user-js-title = Preferències de user.js
user-js-description = La vostra carpeta de perfil conté un <a data-l10n-name="user-js-link">fitxer user.js</a>, que inclou preferències que no han estat creades pel { -brand-short-name }.
locked-key-prefs-title = Preferències importants blocades
locked-prefs-name = Nom
locked-prefs-value = Valor
graphics-title = Gràfics
graphics-features-title = Característiques
graphics-diagnostics-title = Diagnòstics
graphics-failure-log-title = Registre de fallades
graphics-gpu1-title = GPU núm. 1
graphics-gpu2-title = GPU núm. 2
graphics-decision-log-title = Registre de decisions
graphics-crash-guards-title = Característiques del protector de fallades desactivades
graphics-workarounds-title = Solucions temporals
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Protocol de finestres
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Entorn d'escriptori
place-database-title = Base de dades de llocs
place-database-integrity = Integritat
place-database-verify-integrity = Verifica la integritat
a11y-title = Accessibilitat
a11y-activated = Activat
a11y-force-disabled = Evita l'accessibilitat
a11y-handler-used = Gestor d'accessibilitat utilitzat
a11y-instantiator = Instanciador d'accessibilitat
library-version-title = Versions de la biblioteca
copy-text-to-clipboard-label = Copia el text al porta-retalls
copy-raw-data-to-clipboard-label = Copia les dades sense processar al porta-retalls
sandbox-title = Entorn de proves
sandbox-sys-call-log-title = Crides del sistema rebutjades
sandbox-sys-call-index = #
sandbox-sys-call-age = Fa uns segons
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Tipus de procés
sandbox-sys-call-number = Crida del sistema
sandbox-sys-call-args = Arguments
safe-mode-title = Proveu el mode segur
restart-in-safe-mode-label = Reinicia amb els complements inhabilitats…
clear-startup-cache-title = Proveu d'esborrar la memòria cau d'inici
clear-startup-cache-label = Esborra la memòria cau d'inici…
startup-cache-dialog-title = Esborra la memòria cau d’inici
startup-cache-dialog-body = Reinicieu el { -brand-short-name } per esborrar la memòria cau d'inici. Això no canviarà els vostres paràmetres ni eliminarà cap extensió que hàgiu afegit al { -brand-short-name }.
restart-button-label = Reinicia

## Media titles

audio-backend = Sistema de fons d'àudio
max-audio-channels = Nombre màxim de canals
sample-rate = Freqüència de mostratge preferida
roundtrip-latency = Latència d'anada i tornada (desviació estàndard)
media-title = Multimèdia
media-output-devices-title = Dispositius de sortida
media-input-devices-title = Dispositius d'entrada
media-device-name = Nom
media-device-group = Grup
media-device-vendor = Proveïdor
media-device-state = Estat
media-device-preferred = Preferit
media-device-format = Format
media-device-channels = Canals
media-device-rate = Freqüència
media-device-latency = Latència
media-capabilities-title = Capacitats multimèdia

##

intl-title = Internacionalització i localització
intl-app-title = Paràmetres de l'aplicació
intl-locales-requested = Llengües sol·licitades
intl-locales-available = Llengües disponibles
intl-locales-supported = Llengües de l'aplicació
intl-locales-default = Llengua per defecte
intl-os-title = Sistema operatiu
intl-os-prefs-system-locales = Llengües del sistema
intl-regional-prefs = Preferències regionals

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Informes de fallada de l'últim dia
       *[other] Informes de fallada dels últims { $days } dies
    }
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] Fa un minut
       *[other] Fa { $minutes } minuts
    }
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] Fa una hora
       *[other] Fa { $hours } hores
    }
# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] Fa un dia
       *[other] Fa { $days } dies
    }
# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Tots els informes de fallada (inclosa { $reports } fallada pendent dins el període de temps indicat)
       *[other] Tots els informes de fallada (incloses { $reports } fallades pendents dins el període de temps indicat)
    }
raw-data-copied = Les dades sense processar s'han copiat al porta-retalls
text-copied = S'ha copiat el text al porta-retalls

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Blocat per la versió del controlador gràfic.
blocked-gfx-card = Blocat per la targeta gràfica a causa de problemes no resolts del controlador.
blocked-os-version = Blocat per la versió del sistema operatiu.
blocked-mismatched-version = Blocat per què no coincideixen les versions del controlador gràfic del registre i de la DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Blocat pel controlador gràfic. Proveu d'actualitzar-lo a la versió { $driverVersion } o posterior.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Paràmetres ClearType
compositing = Composició
hardware-h264 = Descodificació H264 per maquinari
main-thread-no-omtc = fil principal, sense OMTC
yes = Sí
no = No
unknown = Desconegut
virtual-monitor-disp = Pantalla de monitor virtual

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = S'ha trobat
missing = Falta
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Descripció
gpu-vendor-id = ID del proveïdor
gpu-device-id = ID del dispositiu
gpu-subsys-id = ID del subsistema
gpu-drivers = Controladors
gpu-ram = RAM
gpu-driver-vendor = Versió del controlador
gpu-driver-version = Proveïdor del controlador
gpu-driver-date = Data del controlador
gpu-active = Activa
webgl1-extensions = Extensions WebGL 1
webgl2-extensions = Extensions WebGL 2
blocklisted-bug = És a la llista de bloquejos per problemes coneguts
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = error { $bugNumber }
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = És a la llista de bloquejos; codi d'error { $failureCode }
d3d11layers-crash-guard = Compositor D3D11
d3d11video-crash-guard = Descodificador de vídeo D3D11
d3d9video-crash-guard = Descodificador de vídeo D3D9
glcontext-crash-guard = OpenGL
reset-on-next-restart = Reinicialitza als valors per defecte en el proper reinici
gpu-process-kill-button = Finalitza el procés de GPU
min-lib-versions = Versió mínima esperada
loaded-lib-versions = Versió en ús
has-seccomp-bpf = Seccomp-BPF (filtratge de crides del sistema)
has-seccomp-tsync = Sincronització de fils Seccomp
has-user-namespaces = Espais de noms de l'usuari
has-privileged-user-namespaces = Espais de noms de l'usuari per a processos privilegiats
can-sandbox-content = Inclou en l'entorn de proves els processos de contingut
can-sandbox-media = Inclou en l'entorn de proves els connectors multimèdia
content-sandbox-level = Nivell de l'entorn de proves de processos de contingut
effective-content-sandbox-level = Nivell de l'entorn de proves de processos de contingut efectiu
sandbox-proc-type-content = contingut
sandbox-proc-type-media-plugin = connector multimèdia
launcher-process-status-0 = Activat
launcher-process-status-1 = Desactivat a causa d'un error
launcher-process-status-unknown = Estat desconegut
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Activat per l'usuari
multi-process-status-1 = Activat per defecte
multi-process-status-2 = Desactivat
multi-process-status-4 = Inhabilitat per les eines d'accessibilitat
multi-process-status-6 = Inhabilitat perquè l'entrada de text és incompatible
multi-process-status-7 = Inhabilitat per part dels complements
multi-process-status-8 = Inhabilitat de forma forçada
multi-process-status-unknown = Estat desconegut
async-pan-zoom = Pan/Zoom asíncrons
apz-none = cap
wheel-enabled = entrada amb roda activada
touch-enabled = entrada tàctil activada
drag-enabled = arrossegament de la barra de desplaçament activat

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = l'entrada amb roda asíncrona està desactivada perquè hi ha una preferència incompatible: { $preferenceKey }
touch-warning = l'entrada tàctil asíncrona està desactivada perquè hi ha una preferència incompatible: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Inactiu
policies-active = Actiu
policies-error = Error
