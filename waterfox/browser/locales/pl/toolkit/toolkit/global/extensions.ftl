# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Headers used in the webextension permissions dialog,
## See https://bug1308309.bmoattachments.org/attachment.cgi?id=8814612
## for an example of the full dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension.

webext-perms-header = Czy dodać „{ $extension }”?
webext-perms-header-with-perms = Czy dodać „{ $extension }”? To rozszerzenie wymaga następujących uprawnień:
webext-perms-header-unsigned = Czy dodać „{ $extension }”? To rozszerzenie nie przeszło weryfikacji. Złośliwe rozszerzenia mogą wykradać dane prywatne lub infekować komputery. Dodaj rozszerzanie jedynie, jeśli ufasz jego pochodzeniu.
webext-perms-header-unsigned-with-perms = Czy dodać „{ $extension }”? To rozszerzenie nie przeszło weryfikacji. Złośliwe rozszerzenia mogą wykradać dane prywatne lub infekować komputery. Dodaj rozszerzanie jedynie, jeśli ufasz jego pochodzeniu. To rozszerzenie wymaga następujących uprawnień:
webext-perms-sideload-header = Dodano „{ $extension }”
webext-perms-optional-perms-header = Dodatek „{ $extension }” prosi o nowe uprawnienia.

##

webext-perms-add =
    .label = Dodaj
    .accesskey = D
webext-perms-cancel =
    .label = Anuluj
    .accesskey = A

webext-perms-sideload-text = Inny program na tym komputerze zainstalował dodatek mogący wpływać na przeglądarkę. Przejrzyj jakich wymaga uprawnień i zdecyduj, czy chcesz go włączyć.
webext-perms-sideload-text-no-perms = Inny program na tym komputerze zainstalował dodatek mogący wpływać na przeglądarkę. Zdecyduj, czy chcesz go włączyć.
webext-perms-sideload-enable =
    .label = Włącz
    .accesskey = W
webext-perms-sideload-cancel =
    .label = Anuluj
    .accesskey = A

# Variables:
#   $extension (String): replaced with the localized name of the extension.
webext-perms-update-text = Rozszerzenie „{ $extension }” zostało uaktualnione. Nowe uprawnienia muszą zostać zaakceptowane zanim uaktualniona wersja zostanie zainstalowana. Wybranie „Anuluj” spowoduje pozostawienie aktualnie zainstalowanej wersji rozszerzenia. To rozszerzenie wymaga następujących uprawnień:
webext-perms-update-accept =
    .label = Uaktualnij
    .accesskey = U

webext-perms-optional-perms-list-intro = Ten dodatek prosi o nadanie następujących uprawnień:
webext-perms-optional-perms-allow =
    .label = Zezwól
    .accesskey = Z
webext-perms-optional-perms-deny =
    .label = Zabroń
    .accesskey = a

webext-perms-host-description-all-urls = Dostęp do danych użytkownika na wszystkich stronach

# Variables:
#   $domain (String): will be replaced by the DNS domain for which a webextension is requesting access (e.g., mozilla.org)
webext-perms-host-description-wildcard = Dostęp do danych na stronach w domenie { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-wildcards =
    { $domainCount ->
        [one] Dostęp do danych na stronach w jednej innej domenie
        [few] Dostęp do danych na stronach w { $domainCount } innych domenach
       *[many] Dostęp do danych na stronach w { $domainCount } innych domenach
    }
# Variables:
#   $domain (String): will be replaced by the DNS host name for which a webextension is requesting access (e.g., www.mozilla.org)
webext-perms-host-description-one-site = Dostęp do danych użytkownika dla witryny { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-sites =
    { $domainCount ->
        [one] Dostęp do danych użytkownika dla jednej innej witryny
        [few] Dostęp do danych użytkownika dla { $domainCount } innych witryn
       *[many] Dostęp do danych użytkownika dla { $domainCount } innych witryn
    }

## Headers used in the webextension permissions dialog for synthetic add-ons.
## The part of the string describing what privileges the extension gives should be consistent
## with the value of webext-site-perms-description-gated-perms-{sitePermission}.
## Note, this string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $hostname (String): the hostname of the site the add-on is being installed from.

webext-site-perms-header-with-gated-perms-midi = Ten dodatek daje witrynie { $hostname } dostęp do urządzeń MIDI użytkownika.
webext-site-perms-header-with-gated-perms-midi-sysex = Ten dodatek daje witrynie { $hostname } dostęp do urządzeń MIDI użytkownika (z obsługą SysEx).

##

# This string is used as description in the webextension permissions dialog for synthetic add-ons.
# Note, the empty line is used to create a line break between the two sections.
# Note, this string will be used as raw markup. Avoid characters like <, >, &
webext-site-perms-description-gated-perms-midi =
    Są to zwykle urządzenia podłączane do komputera, takie jak syntezatory dźwięku, ale mogą być również wbudowane w komputer.
    
    Witryny zazwyczaj nie mają dostępu do urządzeń MIDI. Niewłaściwe użycie może spowodować uszkodzenia lub zagrozić bezpieczeństwu.

## Headers used in the webextension permissions dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension being installed.
##   $hostname (String): will be replaced by the DNS host name for which a webextension enables permissions.

webext-site-perms-header-with-perms = Czy dodać „{ $extension }”? To rozszerzenie daje witrynie { $hostname } te możliwości:
webext-site-perms-header-unsigned-with-perms = Czy dodać „{ $extension }”? To rozszerzenie nie przeszło weryfikacji. Złośliwe rozszerzenia mogą wykradać dane prywatne lub infekować komputery. Dodaj rozszerzanie jedynie, jeśli ufasz jego pochodzeniu. To rozszerzenie daje witrynie { $hostname } te możliwości:

## These should remain in sync with permissions.NAME.label in sitePermissions.properties

webext-site-perms-midi = Dostęp do urządzeń MIDI
webext-site-perms-midi-sysex = Dostęp do urządzeń MIDI z obsługą SysEx
