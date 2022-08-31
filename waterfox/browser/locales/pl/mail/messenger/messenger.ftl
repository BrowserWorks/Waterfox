# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Window controls

messenger-window-minimize-button =
    .tooltiptext = Minimalizuj
messenger-window-maximize-button =
    .tooltiptext = Maksymalizuj
messenger-window-restore-down-button =
    .tooltiptext = Przywróć w dół
messenger-window-close-button =
    .tooltiptext = Zamknij
# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] 1 nieprzeczytana wiadomość
        [few] { $count } nieprzeczytane wiadomości
       *[many] { $count } nieprzeczytanych wiadomości
    }
about-rights-notification-text = { -brand-short-name } to wolne oprogramowanie o otwartym kodzie źródłowym (open source), tworzone przez społeczność tysięcy ludzi z całego świata.

## Content tabs

content-tab-page-loading-icon =
    .alt = Strona jest wczytywana
content-tab-security-high-icon =
    .alt = Połączenie jest zabezpieczone
content-tab-security-broken-icon =
    .alt = Połączenie nie jest zabezpieczone

## Toolbar

addons-and-themes-toolbarbutton =
    .label = Dodatki i motywy
    .tooltiptext = Zarządzaj dodatkami
quick-filter-toolbarbutton =
    .label = Szybkie filtrowanie
    .tooltiptext = Filtruj wiadomości
redirect-msg-button =
    .label = Przekieruj
    .tooltiptext = Przekieruj zaznaczoną wiadomość

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Pasek panelu folderów
    .accesskey = f
folder-pane-toolbar-options-button =
    .tooltiptext = Opcje panelu folderów
folder-pane-header-label = Foldery

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Ukryj pasek narzędzi
    .accesskey = U
show-all-folders-label =
    .label = Wszystkie
    .accesskey = W
show-unread-folders-label =
    .label = Nieprzeczytane
    .accesskey = N
show-favorite-folders-label =
    .label = Ulubione
    .accesskey = b
show-smart-folders-label =
    .label = Pogrupowane
    .accesskey = P
show-recent-folders-label =
    .label = Ostatnie
    .accesskey = O
folder-toolbar-toggle-folder-compact-view =
    .label = Widok kompaktowy
    .accesskey = k

## Menu

redirect-msg-menuitem =
    .label = Przekieruj
    .accesskey = k
menu-file-save-as-file =
    .label = Plik…
    .accesskey = P

## AppMenu

appmenu-save-as-file =
    .label = Plik…
appmenu-settings =
    .label = Ustawienia
appmenu-addons-and-themes =
    .label = Dodatki i motywy
appmenu-help-enter-troubleshoot-mode =
    .label = Tryb rozwiązywania problemów…
appmenu-help-exit-troubleshoot-mode =
    .label = Wyłącz tryb rozwiązywania problemów
appmenu-help-more-troubleshooting-info =
    .label = Więcej informacji do rozwiązywania problemów
appmenu-redirect-msg =
    .label = Przekieruj

## Context menu

context-menu-redirect-msg =
    .label = Przekieruj
mail-context-delete-messages =
    .label =
        { $count ->
            [one] Usuń wiadomość
           *[other] Usuń zaznaczone wiadomości
        }
context-menu-decrypt-to-folder =
    .label = Kopiuj jako odszyfrowane do
    .accesskey = o

## Message header pane

other-action-redirect-msg =
    .label = Przekieruj
message-header-msg-flagged =
    .title = Z gwiazdką
    .aria-label = Z gwiazdką
message-header-msg-not-flagged =
    .title = Bez gwiazdki
    .aria-label = Bez gwiazdki
# Variables:
# $address (String) - The email address of the recipient this picture belongs to.
message-header-recipient-avatar =
    .alt = Zdjęcie profilowe { $address }.

## Message header cutomize panel

message-header-customize-panel-title = Ustawienia nagłówka wiadomości
message-header-customize-button-style =
    .value = Styl przycisków
    .accesskey = S
message-header-button-style-default =
    .label = Ikony i tekst
message-header-button-style-text =
    .label = Tekst
message-header-button-style-icons =
    .label = Ikony
message-header-show-sender-full-address =
    .label = Zawsze pokazuj pełny adres nadawcy
    .accesskey = a
message-header-show-sender-full-address-description = Adres e-mail będzie widoczny pod wyświetlaną nazwą.
message-header-show-recipient-avatar =
    .label = Pokazuj zdjęcie profilowe nadawcy
    .accesskey = P
message-header-hide-label-column =
    .label = Ukrywaj kolumnę etykiet
    .accesskey = U
message-header-large-subject =
    .label = Duży temat
    .accesskey = D

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Zarządzaj rozszerzeniem
    .accesskey = Z
toolbar-context-menu-remove-extension =
    .label = Usuń rozszerzenie
    .accesskey = U

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Czy usunąć „{ $name }”?
addon-removal-confirmation-button = Usuń
addon-removal-confirmation-message = Czy usunąć „{ $name }” z programu { -brand-short-name } wraz z jego konfiguracją i danymi?
caret-browsing-prompt-title = Przeglądanie z użyciem kursora
caret-browsing-prompt-text = Naciśnięcie klawisza F7 włącza lub wyłącza tryb przeglądania z użyciem kursora. Opcja ta wyświetla ruchomy kursor w pewnych treściach, pozwalając na zaznaczanie tekstu przy pomocy klawiatury. Czy włączyć opcję przeglądania z użyciem kursora?
caret-browsing-prompt-check-text = Nie pytaj ponownie.
repair-text-encoding-button =
    .label = Napraw kodowanie tekstu
    .tooltiptext = Spróbuj wykryć właściwe kodowanie tekstu na podstawie treści wiadomości

## no-reply handling

no-reply-title = Odpowiedź nie jest obsługiwana
no-reply-message = Adres odpowiedzi ({ $email }) nie wydaje się być adresem monitorowanym. Wiadomości na ten adres prawdopodobnie nie zostaną przez nikogo przeczytane.
no-reply-reply-anyway-button = Odpowiedz mimo to

## error messages

decrypt-and-copy-failures = Nie udało się odszyfrować { $failures } z { $total } wiadomości i nie zostały one skopiowane.

## Spaces toolbar

spaces-toolbar-element =
    .toolbarname = Pasek miejsc
    .aria-label = Pasek miejsc
    .aria-description = Pionowy pasek narzędzi do przełączania między różnymi miejscami. Używaj klawiszy strzałek, aby poruszać się po dostępnych przyciskach.
spaces-toolbar-button-mail2 =
    .title = Poczta
spaces-toolbar-button-address-book2 =
    .title = Książka adresowa
spaces-toolbar-button-calendar2 =
    .title = Kalendarz
spaces-toolbar-button-tasks2 =
    .title = Zadania
spaces-toolbar-button-chat2 =
    .title = Komunikator
spaces-toolbar-button-overflow =
    .title = Więcej miejsc…
spaces-toolbar-button-settings2 =
    .title = Ustawienia
spaces-toolbar-button-hide =
    .title = Ukryj pasek miejsc
spaces-toolbar-button-show =
    .title = Pokaż pasek miejsc
spaces-context-new-tab-item =
    .label = Otwórz w nowej karcie
spaces-context-new-window-item =
    .label = Otwórz w nowym oknie
# Variables:
# $tabName (String) - The name of the tab this item will switch to.
spaces-context-switch-tab-item =
    .label = Przełącz na kartę „{ $tabName }”
settings-context-open-settings-item2 =
    .label = Ustawienia
settings-context-open-account-settings-item2 =
    .label = Ustawienia konta
settings-context-open-addons-item2 =
    .label = Dodatki i motywy

## Spaces toolbar pinned tab menupopup

spaces-toolbar-pinned-tab-button =
    .tooltiptext = Menu miejsc
spaces-pinned-button-menuitem-mail =
    .label = { spaces-toolbar-button-mail2.title }
spaces-pinned-button-menuitem-address-book =
    .label = { spaces-toolbar-button-address-book2.title }
spaces-pinned-button-menuitem-calendar =
    .label = { spaces-toolbar-button-calendar2.title }
spaces-pinned-button-menuitem-tasks =
    .label = { spaces-toolbar-button-tasks2.title }
spaces-pinned-button-menuitem-chat =
    .label = { spaces-toolbar-button-chat2.title }
spaces-pinned-button-menuitem-settings =
    .label = { spaces-toolbar-button-settings2.title }
spaces-pinned-button-menuitem-mail2 =
    .label = { spaces-toolbar-button-mail2.title }
spaces-pinned-button-menuitem-address-book2 =
    .label = { spaces-toolbar-button-address-book2.title }
spaces-pinned-button-menuitem-calendar2 =
    .label = { spaces-toolbar-button-calendar2.title }
spaces-pinned-button-menuitem-tasks2 =
    .label = { spaces-toolbar-button-tasks2.title }
spaces-pinned-button-menuitem-chat2 =
    .label = { spaces-toolbar-button-chat2.title }
spaces-pinned-button-menuitem-settings2 =
    .label = { spaces-toolbar-button-settings2.title }
spaces-pinned-button-menuitem-show =
    .label = { spaces-toolbar-button-show.title }
# Variables:
# $count (Number) - Number of unread messages.
chat-button-unread-messages = { $count }
    .title =
        { $count ->
            [one] Jedna nieprzeczytana wiadomość
            [few] { $count } nieprzeczytane wiadomości
           *[many] { $count } nieprzeczytanych wiadomości
        }

## Spaces toolbar customize panel

menuitem-customize-label =
    .label = Dostosuj…
spaces-customize-panel-title = Ustawienia paska miejsc
spaces-customize-background-color = Kolor tła
spaces-customize-icon-color = Kolor przycisku
# The background color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-background-color = Kolor tła zaznaczonego przycisku
# The icon color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-text-color = Kolor zaznaczonego przycisku
spaces-customize-button-restore = Przywróć domyślne
    .accesskey = P
customize-panel-button-save = Gotowe
    .accesskey = G
