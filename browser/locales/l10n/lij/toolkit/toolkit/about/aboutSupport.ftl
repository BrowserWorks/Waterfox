# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Informaçioin in sciâ soluçion di problemi
page-subtitle = Sta pagina a contegne informaçioin tecniche che peuan ese utili quande ti preuvi a risòlve un problema. Se ti çerchi rispòste a domande comuni in sce { -brand-short-name }, contròlla o nòstro <a data-l10n-name="support-link">scito de agiutto</a>.

crashes-title = Segnalaçioin de cianto anòmalo
crashes-id = ID segnalaçion
crashes-send-date = Mandâ
crashes-all-reports = Tutte e segnalaçioin
crashes-no-config = St'aplicaçion a no l'é configurâ pe mostrâ e segnalaçioin de cianto anòmalo.
extensions-title = Estenscioin
extensions-name = Nomme
extensions-enabled = Abilitou
extensions-version = Verscion
extensions-id = ID
support-addons-name = Nomme
support-addons-version = Verscion
support-addons-id = ID
security-software-title = Software de Seguessa
security-software-type = Tipo
security-software-name = Nomme
security-software-antivirus = Antiviros
security-software-antispyware = Antispyware
security-software-firewall = Firewall
features-title = Carateristiche de{ -brand-short-name }
features-name = Nomme
features-version = Verscion
features-id = ID
app-basics-title = Aplicaçion de Base
app-basics-name = Nomme
app-basics-version = Verscion
app-basics-build-id = ID da build
app-basics-update-channel = Canâ d'agiornamento
app-basics-update-history = Stöia di agiornamenti
app-basics-show-update-history = Fanni vedde a stöia di agiornamenti
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Profî de cartelle
       *[other] Cartella do profî
    }
app-basics-enabled-plugins = Plugin abilitæ
app-basics-build-config = Crea preferensa
app-basics-user-agent = Agente do utente
app-basics-os = OS
app-basics-memory-use = Uzo da memöia
app-basics-performance = Prestaçioin
app-basics-service-workers = Service worker registræ
app-basics-profiles = Profî
app-basics-launcher-process-status = Processo lanciatou
app-basics-multi-process-support = Barcoin moltiprocesso
app-basics-enterprise-policies = Critei aziendali
app-basics-location-service-key-google = Ciave do serviçio de localizaçion de Google
app-basics-key-mozilla = Ciave do Serviçio de Localizaçion de Mozilla
app-basics-safe-mode = Mòddo seguo
show-dir-label =
    { PLATFORM() ->
        [macos] Fanni vedde into Finder
        [windows] Arvi cartella
       *[other] Arvi cartella
    }
modified-key-prefs-title = Preferense inportanti cangiæ
modified-prefs-name = Nomme
modified-prefs-value = Valô
user-js-title = Preferense into user.js
user-js-description = Inta cartella do profî gh'é un <a data-l10n-name="user-js-link">file user.js</a> con preferense che no en inpostæ da { -brand-short-name }.
locked-key-prefs-title = Preferense inportanti blocæ
locked-prefs-name = Nomme
locked-prefs-value = Valô
graphics-title = Grafica
graphics-features-title = Carateristiche
graphics-diagnostics-title = Diagnòsticâ
graphics-failure-log-title = Diaio di Cianti
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Diaio de Decixoin
graphics-crash-guards-title = Carateristiche pe-a proteçion di cianti dizabilitæ
graphics-workarounds-title = Mastrussi
place-database-title = Database di leughi
place-database-integrity = Integritæ
place-database-verify-integrity = Verifica Integritæ
a11y-title = Acesibilitæ
a11y-activated = Ativou
a11y-force-disabled = Inpedisci acesibilitæ
a11y-handler-used = Strumento man de acesibilitæ
a11y-instantiator = Instansiatô de acesibilitæ
library-version-title = Vescioin da libraia
copy-text-to-clipboard-label = Còpia testo in scî aponti
copy-raw-data-to-clipboard-label = Còpia dæti sgreuzzi in scî aponti
sandbox-title = Sandbox
sandbox-sys-call-log-title = Scistema de ciamæ refuæ
sandbox-sys-call-index = #
sandbox-sys-call-age = Segondi fa
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Tipo de processo
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Argomenti
safe-mode-title = Preuva o mòddo seguo
restart-in-safe-mode-label = Arvi torna co-i conponenti azonti dizativæ…

## Media titles

audio-backend = Backend de aodio
max-audio-channels = Mascimo numero de canâ
sample-rate = Frequensa de canpionamento preferia
media-title = Media
media-output-devices-title = Dispoxitivi de output
media-input-devices-title = Dispoxitivi de input
media-device-name = Nomme
media-device-group = Gruppo
media-device-vendor = Venditô
media-device-state = Stato
media-device-preferred = Preferio
media-device-format = Formou
media-device-channels = Canâ
media-device-rate = Indice
media-device-latency = Ritardo

##

intl-title = Internaçionalizaçion e Localizaçion
intl-app-title = Inpostaçioin da aplicaçion
intl-locales-requested = Localizaçioin domandæ
intl-locales-available = Localizaçion che ghe son
intl-locales-supported = Localizaçion de l'App
intl-locales-default = Localizaçion predefinia
intl-os-title = Scistema Operativo
intl-os-prefs-system-locales = Localizaçioin de Scistema
intl-regional-prefs = Preferense Regionâ

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/


##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Segnalaçioin de cianto anòmalo inte l'urtimo giorno
       *[other] Segnalaçioin de cianto anòmalo inti urtimi { $days } giorni
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } menuto fa
       *[other] { $minutes } menuti fa
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } oa fa
       *[other] { $hours } oe fa
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } giorno fa
       *[other] { $days } giorni fa
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Tutte e segnalaçioin de cianto anòmalo (incluza { $reports } in ateiza inte l'intervallo de tenpo indicou)
       *[other] Tutte e segnalaçioin de cianto anòmalo (incluze { $reports } in ateiza inte l'intervallo de tenpo indicou)
    }

raw-data-copied = Dæti sgreuzzi copiæ in sci aponti
text-copied = Testo copiòu in sci aponti

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Blocòu a caoza da teu verscion do driver da scheda grafica.
blocked-gfx-card = Blocòu pe caxon da scheda grafica.
blocked-os-version = Blocòu pe caxon da verscion do teu scistema òperativo.
blocked-mismatched-version = Blocòu a caoza da no corispondensa da verscion di driver tra registro e DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Blocòu a caoza da a teu verscion do driver. Preuva a agiornâ o teu driver a-a verscion { $driverVersion } ò ciù neuva.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Parametri ClearType

compositing = Conpoziçion
hardware-h264 = Hardware Decoding H264
main-thread-no-omtc = thread prinçipâ, no OMTC
yes = Sci
no = No
unknown = Sconosciuo

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Atrovou
missing = Manca

gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Descriçion
gpu-vendor-id = ID Vendidô
gpu-device-id = ID dispoxitivo:
gpu-subsys-id = ID Subsys
gpu-drivers = Driver
gpu-ram = RAM
gpu-driver-version = Verscion Driver
gpu-driver-date = Dæta Driver
gpu-active = Ativo
webgl1-wsiinfo = Informaçioin in sciô Driver WSI de WebGL 1
webgl1-renderer = Render do driver WebGL 1
webgl1-version = Verscion do driver WebGL 1
webgl1-driver-extensions = Estençion do driver WebGL 1
webgl1-extensions = Estenscioin WebGL 1
webgl2-wsiinfo = Informaçioin in sciô Driver WSI de WebGL 2
webgl2-renderer = Renderer WebGL2
webgl2-version = Verscion do driver WebGL 2
webgl2-driver-extensions = Estençion do driver WebGL 2
webgl2-extensions = Estenscioin WebGL 2
blocklisted-bug = Blocòu pe motivi nòtti

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = bagon { $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Blocòu; Còdice d'erô { $failureCode }

d3d11layers-crash-guard = Conpositô D3D11
d3d11video-crash-guard = Decodificatô video D3D11
d3d9video-crash-guard = Decodificatô video D3D9
glcontext-crash-guard = OpenGL

reset-on-next-restart = Reinpòsta a-a proscima avertua
gpu-process-kill-button = Ferma processo GPU
gpu-device-reset-button = Arvi torna dispoxitivo
uses-tiling = Deuvia ciapelle
content-uses-tiling = Deuvia ciapelle (Contegnuo)
off-main-thread-paint-enabled = Painting Abilitou feua do thread prinçipâ
off-main-thread-paint-worker-count = Conta do worker Painting feua do thread prinçipâ

min-lib-versions = M'aspetavo 'na verscion minima
loaded-lib-versions = Verscion in uzo

has-seccomp-bpf = Seccomp-BPF (filtro ciamæ de scistema)
has-seccomp-tsync = Scincronizaçion thread seccomp
has-user-namespaces = Namespace de l’utente
has-privileged-user-namespaces = Namespace de l’utente pe processi privilegiæ
can-sandbox-content = Sandbox processa o contegnuo
can-sandbox-media = Sandbox plugin moltimediali
content-sandbox-level = Livello Sandox de processo de contegnuo
effective-content-sandbox-level = Contegnuo efetivo do Livello Sandox de processo
sandbox-proc-type-content = contegnuo
sandbox-proc-type-file = contegnuo do schedaio
sandbox-proc-type-media-plugin = plugin do media
sandbox-proc-type-data-decoder = data decoder

launcher-process-status-0 = Ativou
launcher-process-status-2 = Dizabilitou con fòrsa
launcher-process-status-unknown = Stato no conosciuo

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Abilitou da l'utente
multi-process-status-1 = Abilitou predefinio
multi-process-status-2 = Dizabilitou
multi-process-status-4 = Dizabilitou da-i strumenti de acesibilitæ
multi-process-status-6 = Dizabilitou pe testo d'ingresso no soportou
multi-process-status-7 = Dizabilitou da-i conponenti azonti
multi-process-status-8 = Dizabilitou con fòrsa
multi-process-status-unknown = Stato no conosciuo

async-pan-zoom = Panoramica/zoom ascincroni (APZ)
apz-none = nisciun
wheel-enabled = input reua ativo
touch-enabled = input tocco ativo
drag-enabled = Rebelamento bare de scorimento
keyboard-enabled = tastea abilitâ
autoscroll-enabled = aoto-rebelamento abilitou

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = input reua ascincrono dizativou pe caxon de 'na preferensa no soportâ: { $preferenceKey }
touch-warning = input tocco ascincrono dizativou a caoza de 'na preferensa no soportâ: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Dizativo
policies-active = Ativo
policies-error = Erô
