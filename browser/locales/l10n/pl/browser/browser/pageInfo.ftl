# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 700px; min-height: 650px;
copy =
    .key = C
menu-copy =
    .label = Kopiuj
    .accesskey = K
select-all =
    .key = A
menu-select-all =
    .label = Zaznacz wszystko
    .accesskey = a
close-dialog =
    .key = w
general-tab =
    .label = Ogólne
    .accesskey = O
general-title =
    .value = Tytuł:
general-url =
    .value = Adres:
general-type =
    .value = Typ:
general-mode =
    .value = Tryb wyświetlania:
general-size =
    .value = Rozmiar:
general-referrer =
    .value = Odsyłający URL:
general-modified =
    .value = Zmodyfikowany:
general-encoding =
    .value = Kodowanie tekstu:
general-meta-name =
    .label = Nazwa
general-meta-content =
    .label = Treści
media-tab =
    .label = Media
    .accesskey = M
media-location =
    .value = Położenie:
media-text =
    .value = Powiązany tekst:
media-alt-header =
    .label = Tekst alternatywny
media-address =
    .label = Adres
media-type =
    .label = Typ
media-size =
    .label = Rozmiar
media-count =
    .label = Ilość
media-dimension =
    .value = Wymiary:
media-long-desc =
    .value = Długi opis:
media-save-as =
    .label = Zapisz jako…
    .accesskey = Z
media-save-image-as =
    .label = Zapisz jako…
    .accesskey = s
perm-tab =
    .label = Uprawnienia
    .accesskey = U
permissions-for =
    .value = Uprawnienia dla:
security-tab =
    .label = Bezpieczeństwo
    .accesskey = B
security-view =
    .label = Wyświetl certyfikat
    .accesskey = c
security-view-unknown = Nieznany
    .value = Nieznany
security-view-identity =
    .value = Tożsamość witryny
security-view-identity-owner =
    .value = Właściciel:
security-view-identity-domain =
    .value = Witryna:
security-view-identity-verifier =
    .value = Zweryfikowana przez:
security-view-identity-validity =
    .value = Wygasa:
security-view-privacy =
    .value = Prywatność i historia
security-view-privacy-history-value = Czy ta witryna była wcześniej odwiedzana?
security-view-privacy-sitedata-value = Czy ta witryna przechowuje informacje na tym komputerze?
security-view-privacy-clearsitedata =
    .label = Wyczyść ciasteczka i dane witryny
    .accesskey = n
security-view-privacy-passwords-value = Czy hasła użyte na tej witrynie zostały zachowane?
security-view-privacy-viewpasswords =
    .label = Wyświetl zachowane hasła
    .accesskey = h
security-view-technical =
    .value = Szczegóły techniczne
help-button =
    .label = Pomoc

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Tak, ciasteczka i { $value } { $unit } danych witryny
security-site-data-only = Tak, { $value } { $unit } danych witryny
security-site-data-cookies-only = Tak, ciasteczka
security-site-data-no = Nie

##

image-size-unknown = Nieznany
page-info-not-specified =
    .value = Nieokreślony
not-set-alternative-text = Nieokreślony
not-set-date = Nieokreślony
media-img = Obraz
media-bg-img = Tło
media-border-img = Obramowanie
media-list-img = Wypunktowanie
media-cursor = Kursor
media-object = Obiekt
media-embed = Osadzony
media-link = Ikona
media-input = Przycisk
media-video = Wideo
media-audio = Dźwięk
saved-passwords-yes = Tak
saved-passwords-no = Nie
no-page-title =
    .value = Strona bez nazwy
general-quirks-mode =
    .value = Tryb zgodności wstecznej
general-strict-mode =
    .value = Tryb standardów
page-info-security-no-owner =
    .value = Ta witryna nie dostarcza informacji o swoich właścicielach.
media-select-folder = Wybierz folder do zapisu obrazów
media-unknown-not-cached =
    .value = Nieznany (brak w pamięci podręcznej)
permissions-use-default =
    .label = Używaj domyślnych
security-no-visits = Nie
# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 znacznik)
            [few] Meta ({ $tags } znaczniki)
           *[many] Meta ({ $tags } znaczników)
        }
# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Nie
        [one] Tak, raz
        [few] Tak, { $visits } razy
       *[many] Tak, { $visits } razy
    }
# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } bajt)
            [few] { $kb } KB ({ $bytes } bajty)
           *[many] { $kb } KB ({ $bytes } bajtów)
        }
# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] Obraz { $type } (animowany, { $frames } klatka)
            [few] Obraz { $type } (animowany, { $frames } klatki)
           *[many] Obraz { $type } (animowany, { $frames } klatek)
        }
# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Obraz { $type }
# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx } px × { $dimy } px (przeskalowany do { $scaledx } px × { $scaledy } px)
# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx } px × { $dimy } px
# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } KB
# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Blokuj obrazy z witryny { $website }
    .accesskey = B
# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) — The url of the website pageInfo is getting info for
page-info-page =
    .title = Informacje o stronie { $website }
page-info-frame =
    .title = Informacje o ramce { $website }
