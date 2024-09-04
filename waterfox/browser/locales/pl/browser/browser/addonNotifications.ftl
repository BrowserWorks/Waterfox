# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } nie pozwolił tej witrynie zapytać o zgodę na instalację oprogramowania.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = Czy zezwolić witrynie { $host } na zainstalowanie dodatku?
xpinstall-prompt-message = Za chwilę zostanie zainstalowany dodatek z witryny { $host }. Przed kontynuacją upewnij się, że jej ufasz.

##

xpinstall-prompt-header-unknown = Czy zezwolić nieznanej witrynie na zainstalowanie dodatku?
xpinstall-prompt-message-unknown = Za chwilę zostanie zainstalowany dodatek z nieznanej witryny. Przed kontynuacją upewnij się, że jej ufasz.
xpinstall-prompt-dont-allow =
    .label = Nie zezwalaj
    .accesskey = N
xpinstall-prompt-never-allow =
    .label = Nigdy nie zezwalaj
    .accesskey = d
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Zgłoś podejrzaną witrynę
    .accesskey = Z
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Kontynuuj instalację
    .accesskey = K

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Ta witryna prosi o dostęp do urządzeń MIDI użytkownika. Można włączyć dostęp, instalując dodatek.
site-permission-install-first-prompt-midi-message = Bezpieczeństwo tego dostępu nie jest gwarantowane. Kontynuuj wyłącznie wtedy, gdy ufasz tej witrynie.

##

xpinstall-disabled-locked = Instalacja oprogramowania została wyłączona przez administratora komputera.
xpinstall-disabled = Instalacja oprogramowania jest obecnie wyłączona. Kliknij Włącz i spróbuj ponownie.
xpinstall-disabled-button =
    .label = Włącz
    .accesskey = c
# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = Dodatek { $addonName } ({ $addonId }) został zablokowany przez administratora komputera.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = Administrator komputera nie pozwolił tej witrynie zapytać o zgodę na instalację oprogramowania.
addon-install-full-screen-blocked = Instalacja dodatków jest niedozwolona w trybie pełnoekranowym lub przed jego włączeniem.
# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = Dodatek „{ $addonName }” został dodany do { -brand-short-name(case: "gen") }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } wymaga nowych uprawnień
# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = Dokończ instalację rozszerzeń zaimportowanych do { -brand-short-name(case: "gen") }

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = Czy usunąć „{ $name }”?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = Czy usunąć rozszerzenie „{ $name }” z { -brand-shorter-name(case: "gen") }?
addon-removal-button = Usuń
addon-removal-abuse-report-checkbox = Zgłoś to rozszerzenie do { -vendor-short-name(case: "gen") }
# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying =
    { $addonCount ->
        [one] Pobieranie i weryfikowanie dodatku…
        [few] Pobieranie i weryfikowanie { $addonCount } dodatków…
       *[many] Pobieranie i weryfikowanie { $addonCount } dodatków…
    }
addon-download-verifying = weryfikowanie…
addon-install-cancel-button =
    .label = Anuluj
    .accesskey = A
addon-install-accept-button =
    .label = Dodaj
    .accesskey = D

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one] Strona prosi o zgodę na instalację dodatku w { -brand-short-name(case: "loc") }:
        [few] Strona prosi o zgodę na instalację { $addonCount } dodatków w { -brand-short-name(case: "loc") }:
       *[many] Strona prosi o zgodę na instalację { $addonCount } dodatków w { -brand-short-name(case: "loc") }:
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one] Ostrożnie! Strona prosi o zgodę na instalację niezweryfikowanego dodatku w { -brand-short-name(case: "loc") }. Kontynuuj na własną odpowiedzialność.
        [few] Ostrożnie! Strona prosi o zgodę na instalację { $addonCount } niezweryfikowanych dodatków w { -brand-short-name(case: "loc") }. Kontynuuj na własną odpowiedzialność.
       *[many] Ostrożnie! Strona prosi o zgodę na instalację { $addonCount } niezweryfikowanych dodatków w { -brand-short-name(case: "loc") }. Kontynuuj na własną odpowiedzialność.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message =
    { $addonCount ->
        [one] Ostrożnie! Strona prosi o zgodę na instalację dodatku w { -brand-short-name(case: "loc") }, który jest niezweryfikowany. Kontynuuj na własną odpowiedzialność.
        [few] Ostrożnie! Strona prosi o zgodę na instalację { $addonCount } dodatków w { -brand-short-name(case: "loc") } – niektóre z nich są niezweryfikowane. Kontynuuj na własną odpowiedzialność.
       *[many] Ostrożnie! Strona prosi o zgodę na instalację { $addonCount } dodatków w { -brand-short-name(case: "loc") } – niektóre z nich są niezweryfikowane. Kontynuuj na własną odpowiedzialność.
    }

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = Nie udało się zainstalować dodatku z powodu błędu połączenia.
addon-install-error-incorrect-hash = Nie udało się zainstalować dodatku, ponieważ nie pasuje on do dodatku oczekiwanego przez { -brand-short-name(case: "acc") }.
addon-install-error-corrupt-file = Dodatek pobrany z tej strony nie może zostać zainstalowany, ponieważ wygląda on na uszkodzony.
addon-install-error-file-access = Dodatek „{ $addonName }” nie może zostać zainstalowany, ponieważ { -brand-short-name } nie może zmodyfikować potrzebnego pliku.
addon-install-error-not-signed = { -brand-short-name } uniemożliwił tej stronie instalację niezweryfikowanego dodatku.
addon-install-error-invalid-domain = Dodatek „{ $addonName }” nie może być instalowany z tego miejsca.
addon-local-install-error-network-failure = Nie udało się zainstalować dodatku z powodu błędu systemu plików.
addon-local-install-error-incorrect-hash = Nie udało się zainstalować dodatku, ponieważ nie pasuje on do dodatku oczekiwanego przez { -brand-short-name(case: "acc") }.
addon-local-install-error-corrupt-file = Dodatek nie może zostać zainstalowany, ponieważ wygląda on na uszkodzony.
addon-local-install-error-file-access = Dodatek „{ $addonName }” nie może zostać zainstalowany, ponieważ { -brand-short-name } nie może zmodyfikować potrzebnego pliku.
addon-local-install-error-not-signed = Ten dodatek nie może zostać zainstalowany, ponieważ nie został zweryfikowany.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = Dodatek „{ $addonName }” nie może zostać zainstalowany, ponieważ nie jest on zgodny z { -brand-short-name(case: "ins") } { $appVersion }.
addon-install-error-blocklisted = Dodatek „{ $addonName }” nie może zostać zainstalowany, ponieważ obarczony jest on wysokim ryzykiem utraty stabilności lub problemów z bezpieczeństwem.
