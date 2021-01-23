# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Informaçion in sci profî
profiles-subtitle = Sta pagina a permette de gestî i profî. Ògni profî o l'é 'na realtê separâ, con stöia, segnalibbri, inpostaçion e conponenti azonti conpletamente indipendenti.
profiles-create = Crea 'n neuvo profî
profiles-restart-title = Arvi torna
profiles-restart-in-safe-mode = Arvi torna co-i conponenti azonti dizabilitæ…
profiles-restart-normal = Arvi torna in mòddo normale…

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profî: { $name }
profiles-is-default = Profî predefinito
profiles-rootdir = Cartella reixe

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Cartella locale
profiles-current-profile = No se peu scancelâ o profî che ti deuvi òua.
profiles-in-use-profile = Sto profî o l'é deuviou da 'n atra aplicaçion e o no peu ese scancelou.

profiles-rename = Cangia nomme
profiles-remove = Scancella
profiles-set-as-default = Metti comme profî predefinio
profiles-launch-profile = Xeua profî inte 'n neuvo navegatô

profiles-yes = Sci
profiles-no = No

profiles-rename-profile-title = Cangia nomme profî
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Cangia nomme a-o profî “{ $name }”

profiles-invalid-profile-name-title = Nomme profî no bon
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = O nomme “{ $name }” dæto a-o profî o no l'é bon.

profiles-delete-profile-title = Scancella profî
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Quande se scencella un profî sto chi o saiâ levòu da l'elenco di profî disponibili e o no saiâ poscibile anulâ l’operaçion.
    Ti peu çerne de scancelâ anche i file asociæ a-o profî, incluzi inpostaçion, certificati e atri dæti de l’utente. Se ti çerni sta opçion a cartella “{ $dir }” a saiâ scanelâ e no saiâ poscibile repigiala.
    Scancelâ i file asociæ a-o profî?
profiles-delete-files = Scancella i schedai
profiles-dont-delete-files = No scancelâ i schedai

profiles-delete-profile-failed-title = Erô
profiles-delete-profile-failed-message = Gh'é stæto 'n erô into scancelâ sto profî.


profiles-opendir =
    { PLATFORM() ->
        [macos] Fanni vedde into Finder
        [windows] Arvi cartella
       *[other] Arvi percorso
    }
