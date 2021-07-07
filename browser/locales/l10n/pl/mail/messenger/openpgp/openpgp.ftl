# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = Do wysyłania zaszyfrowanych lub cyfrowo podpisanych wiadomości wymagana jest konfiguracja technologii szyfrowania OpenPGP lub S/MIME.
e2e-intro-description-more = Wybierz swój klucz osobisty, aby umożliwić korzystanie z OpenPGP, lub certyfikat osobisty, aby umożliwić korzystanie z S/MIME. Dla klucza lub certyfikatu osobistego posiadasz odpowiedni tajny klucz.
openpgp-key-user-id-label = Identyfikator konta/użytkownika
openpgp-keygen-title-label =
    .title = Wygeneruj klucz OpenPGP
openpgp-cancel-key =
    .label = Anuluj
    .tooltiptext = Anuluj generowanie klucza
openpgp-key-gen-expiry-title =
    .label = Ważność klucza
openpgp-key-gen-expire-label = Klucz wygasa za
openpgp-key-gen-days-label =
    .label = dni
openpgp-key-gen-months-label =
    .label = mies.
openpgp-key-gen-years-label =
    .label = lat(a)
openpgp-key-gen-no-expiry-label =
    .label = Klucz nie wygasa
openpgp-key-gen-key-size-label = Rozmiar klucza
openpgp-key-gen-console-label = Generowanie kluczy
openpgp-key-gen-key-type-label = Typ klucza
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (krzywa eliptyczna)
openpgp-generate-key =
    .label = Wygeneruj klucz
    .tooltiptext = Generuje nowy klucz zgodny z OpenPGP do szyfrowania i podpisywania
openpgp-advanced-prefs-button-label =
    .label = Zaawansowane…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">UWAGA: generowanie klucza może zająć nawet kilka minut.</a> Nie wyłączaj aplikacji w trakcie generowania. Aktywne przeglądanie Internetu i wykonywanie działań intensywnie korzystających z dysku podczas generowania klucza uzupełni „pulę losowości” i przyspieszy ten proces. Po ukończeniu generowania zostanie wyświetlony komunikat.
openpgp-key-expiry-label =
    .label = Wygasanie
openpgp-key-id-label =
    .label = Identyfikator klucza
openpgp-cannot-change-expiry = To klucz o złożonej strukturze, zmiana jego daty wygaśnięcia nie jest obsługiwana.
openpgp-key-man-title =
    .title = Menedżer kluczy OpenPGP
openpgp-key-man-generate =
    .label = Nowa para kluczy
    .accesskey = N
openpgp-key-man-gen-revoke =
    .label = Certyfikat unieważnienia
    .accesskey = C
openpgp-key-man-ctx-gen-revoke-label =
    .label = Wygeneruj i zapisz certyfikat unieważnienia
openpgp-key-man-file-menu =
    .label = Plik
    .accesskey = P
openpgp-key-man-edit-menu =
    .label = Edycja
    .accesskey = E
openpgp-key-man-view-menu =
    .label = Widok
    .accesskey = W
openpgp-key-man-generate-menu =
    .label = Generuj
    .accesskey = G
openpgp-key-man-keyserver-menu =
    .label = Serwer kluczy
    .accesskey = S
openpgp-key-man-import-public-from-file =
    .label = Importuj klucze publiczne z pliku
    .accesskey = m
openpgp-key-man-import-secret-from-file =
    .label = Importuj tajne klucze z pliku
openpgp-key-man-import-sig-from-file =
    .label = Importuj unieważnienia z pliku
openpgp-key-man-import-from-clipbrd =
    .label = Importuj klucze ze schowka
    .accesskey = h
openpgp-key-man-import-from-url =
    .label = Importuj klucze z adresu URL
    .accesskey = U
openpgp-key-man-export-to-file =
    .label = Eksportuj klucze publiczne do pliku
    .accesskey = E
openpgp-key-man-send-keys =
    .label = Wyślij klucze publiczne pocztą e-mail
    .accesskey = W
openpgp-key-man-backup-secret-keys =
    .label = Wykonaj kopię zapasową tajnych kluczy do pliku
    .accesskey = k
openpgp-key-man-discover-cmd =
    .label = Wykryj klucze w Internecie
    .accesskey = I
openpgp-key-man-discover-prompt = Aby wykrywać klucze OpenPGP w Internecie, na serwerach kluczy lub za pomocą protokołu WKD, wprowadź adres e-mail lub identyfikator klucza.
openpgp-key-man-discover-progress = Wyszukiwanie…
openpgp-key-copy-key =
    .label = Kopiuj klucz publiczny
    .accesskey = K
openpgp-key-export-key =
    .label = Eksportuj klucz publiczny do pliku
    .accesskey = E
openpgp-key-backup-key =
    .label = Wykonaj kopię zapasową tajnego klucza do pliku
    .accesskey = z
openpgp-key-send-key =
    .label = Wyślij klucz publiczny pocztą e-mail
    .accesskey = W
openpgp-key-man-copy-to-clipbrd =
    .label = Kopiuj klucze publiczne do schowka
    .accesskey = K
openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
            [one] Kopiuj identyfikator klucza do schowka
            [few] Kopiuj identyfikatory kluczy do schowka
           *[many] Kopiuj identyfikatory kluczy do schowka
        }
    .accesskey = d
openpgp-key-man-copy-fprs =
    .label =
        { $count ->
            [one] Kopiuj odcisk klucza do schowka
            [few] Kopiuj odciski kluczy do schowka
           *[many] Kopiuj odciski kluczy do schowka
        }
    .accesskey = c
openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
            [one] Kopiuj klucz publiczny do schowka
            [few] Kopiuj klucze publiczne do schowka
           *[many] Kopiuj klucze publiczne do schowka
        }
    .accesskey = u
openpgp-key-man-ctx-expor-to-file-label =
    .label = Eksportuj klucze do pliku
openpgp-key-man-ctx-copy-to-clipbrd-label =
    .label = Kopiuj klucze publiczne do schowka
openpgp-key-man-ctx-copy =
    .label = Kopiuj
    .accesskey = K
openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
            [one] Odcisk klucza
            [few] Odciski kluczy
           *[many] Odciski kluczy
        }
    .accesskey = O
openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
            [one] Identyfikator klucza
            [few] Identyfikatory kluczy
           *[many] Identyfikatory kluczy
        }
    .accesskey = I
openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
            [one] Klucz publiczny
            [few] Klucze publiczne
           *[many] Klucze publiczne
        }
    .accesskey = b
openpgp-key-man-close =
    .label = Zamknij
openpgp-key-man-reload =
    .label = Odśwież pamięć podręczną kluczy
    .accesskey = O
openpgp-key-man-change-expiry =
    .label = Zmień datę wygaśnięcia
    .accesskey = Z
openpgp-key-man-del-key =
    .label = Usuń klucze
    .accesskey = U
openpgp-delete-key =
    .label = Usuń klucz
    .accesskey = U
openpgp-key-man-revoke-key =
    .label = Unieważnij klucz
    .accesskey = n
openpgp-key-man-key-props =
    .label = Właściwości klucza
    .accesskey = W
openpgp-key-man-key-more =
    .label = Więcej
    .accesskey = c
openpgp-key-man-view-photo =
    .label = Identyfikator zdjęcia
    .accesskey = d
openpgp-key-man-ctx-view-photo-label =
    .label = Wyświetl identyfikator zdjęcia
openpgp-key-man-show-invalid-keys =
    .label = Wyświetl nieprawidłowe klucze
    .accesskey = n
openpgp-key-man-show-others-keys =
    .label = Wyświetl klucze innych osób
    .accesskey = o
openpgp-key-man-user-id-label =
    .label = Nazwa
openpgp-key-man-fingerprint-label =
    .label = Odcisk klucza
openpgp-key-man-select-all =
    .label = Wybierz wszystkie klucze
    .accesskey = b
openpgp-key-man-empty-tree-tooltip =
    .label = Wpisz wyszukiwane słowa w polu powyżej
openpgp-key-man-nothing-found-tooltip =
    .label = Żadne klucze nie pasują do wyszukiwanych słów
openpgp-key-man-please-wait-tooltip =
    .label = Proszę czekać, trwa wczytywanie kluczy…
openpgp-key-man-filter-label =
    .placeholder = Wyszukaj klucze
openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I
openpgp-key-details-title =
    .title = Właściwości klucza
openpgp-key-details-signatures-tab =
    .label = Certyfikacje
openpgp-key-details-structure-tab =
    .label = Struktura
openpgp-key-details-uid-certified-col =
    .label = Identyfikator użytkownika/certyfikowane przez
openpgp-key-details-user-id2-label = Domniemany właściciel klucza
openpgp-key-details-id-label =
    .label = Identyfikator
openpgp-key-details-key-type-label = Typ
openpgp-key-details-key-part-label =
    .label = Część klucza
openpgp-key-details-algorithm-label =
    .label = Algorytm
openpgp-key-details-size-label =
    .label = Rozmiar
openpgp-key-details-created-label =
    .label = Utworzono
openpgp-key-details-created-header = Utworzono
openpgp-key-details-expiry-label =
    .label = Wygasanie
openpgp-key-details-expiry-header = Wygasanie
openpgp-key-details-usage-label =
    .label = Zastosowania
openpgp-key-details-fingerprint-label = Odcisk klucza
openpgp-key-details-sel-action =
    .label = Wybierz działanie…
    .accesskey = d
openpgp-key-details-also-known-label = Domniemane alternatywne tożsamości właściciela klucza:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Zamknij
openpgp-acceptance-label =
    .label = Twoja akceptacja
openpgp-acceptance-rejected-label =
    .label = Nie, odrzuć ten klucz.
openpgp-acceptance-undecided-label =
    .label = Jeszcze nie, może później.
openpgp-acceptance-unverified-label =
    .label = Tak, ale nie zweryfikowano, czy jest to właściwy klucz.
openpgp-acceptance-verified-label =
    .label = Tak, zweryfikowano osobiście, że to właściwy odcisk klucza.
key-accept-personal =
    W przypadku tego klucza posiadasz część publiczną i część tajną. Możesz używać go jako klucza osobistego.
    Jeśli ktoś inny przekazał Ci ten klucz, nie używaj go jako klucza osobistego.
key-personal-warning = Czy utworzono ten klucz samodzielnie, a wyświetlony właściciel klucza odnosi się do Ciebie?
openpgp-personal-no-label =
    .label = Nie, nie używaj go jako mojego klucza osobistego.
openpgp-personal-yes-label =
    .label = Tak, traktuj ten klucz jako klucz osobisty.
openpgp-copy-cmd-label =
    .label = Kopiuj

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbird nie ma klucza osobistego OpenPGP dla tożsamości <b>{ $identity }</b>
        [one] Thunderbird odnalazł { $count } klucz osobisty OpenPGP powiązany z tożsamością <b>{ $identity }</b>
        [few] Thunderbird odnalazł { $count } klucze osobiste OpenPGP powiązane z tożsamością <b>{ $identity }</b>
       *[many] Thunderbird odnalazł { $count } kluczy osobistych OpenPGP powiązanych z tożsamością <b>{ $identity }</b>
    }
#   $count (Number) - the number of configured keys associated with the current identity
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status =
    { $count ->
        [0] Wybierz prawidłowy klucz, aby włączyć protokół OpenPGP.
        [one] Bieżąca konfiguracja wykorzystuje klucz o identyfikatorze <b>{ $key }</b>
        [few] Bieżąca konfiguracja wykorzystuje klucz o identyfikatorze <b>{ $key }</b>
       *[many] Bieżąca konfiguracja wykorzystuje klucz o identyfikatorze <b>{ $key }</b>
    }
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-have-key = Bieżąca konfiguracja wykorzystuje klucz o identyfikatorze <b>{ $key }</b>
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Bieżąca konfiguracja wykorzystuje klucz <b>{ $key }</b>, który wygasł.
openpgp-add-key-button =
    .label = Dodaj klucz…
    .accesskey = D
e2e-learn-more = Więcej informacji
openpgp-keygen-success = Pomyślnie utworzono klucz OpenPGP.
openpgp-keygen-import-success = Pomyślnie zaimportowano klucze OpenPGP.
openpgp-keygen-external-success = Zapisano zewnętrzny identyfikator klucza GnuPG.

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Żaden
openpgp-radio-none-desc = Nie używaj OpenPGP dla tej tożsamości.
openpgp-radio-key-not-usable = Ten klucz nie może być używany jako klucz osobisty, ponieważ brakuje tajnego klucza.
openpgp-radio-key-not-accepted = Aby używać tego klucza, musisz zatwierdzić go jako klucz osobisty.
openpgp-radio-key-not-found = Nie można odnaleźć tego klucza. Jeśli chcesz go użyć, musisz zaimportować go do programu { -brand-short-name }.
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Wygasa: { $date }
openpgp-key-expires-image =
    .tooltiptext = Klucz wygasa za mniej niż 6 miesięcy
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Wygasł: { $date }
openpgp-key-expired-image =
    .tooltiptext = Klucz wygasł
openpgp-key-expires-within-6-months-icon =
    .title = Klucz wygasa za mniej niż 6 miesięcy
openpgp-key-has-expired-icon =
    .title = Klucz wygasł
openpgp-key-expand-section =
    .tooltiptext = Więcej informacji
openpgp-key-revoke-title = Unieważnij klucz
openpgp-key-edit-title = Zmień klucz OpenPGP
openpgp-key-edit-date-title = Przedłuż datę wygaśnięcia
openpgp-manager-description = Użyj menedżera kluczy OpenPGP, aby przeglądać i zarządzać kluczami publicznymi swoich rozmówców oraz wszystkimi pozostałymi kluczami niewymienionymi tutaj.
openpgp-manager-button =
    .label = Menedżer kluczy OpenPGP
    .accesskey = M
openpgp-key-remove-external =
    .label = Usuń zewnętrzny identyfikator klucza
    .accesskey = U
key-external-label = Zewnętrzny klucz GnuPG
# Strings in keyDetailsDlg.xhtml
key-type-public = klucz publiczny
key-type-primary = główny klucz
key-type-subkey = klucz podrzędny
key-type-pair = para kluczy (tajny klucz i klucz publiczny)
key-expiry-never = nigdy
key-usage-encrypt = Szyfrowanie
key-usage-sign = Podpisywanie
key-usage-certify = Certyfikowanie
key-usage-authentication = Uwierzytelnianie
key-does-not-expire = Klucz nie wygasa
key-expired-date = Klucz wygasł w dniu { $keyExpiry }
key-expired-simple = Klucz wygasł
key-revoked-simple = Klucz został unieważniony
key-do-you-accept = Czy akceptujesz ten klucz do weryfikowania podpisów cyfrowych i szyfrowania wiadomości?
key-accept-warning = Unikaj zaakceptowania fałszywego klucza. Skorzystaj z innego kanału komunikacji niż e-mail, aby zweryfikować odcisk klucza rozmówcy.
# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Nie można wysłać wiadomości, ponieważ wystąpił problem z kluczem osobistym. { $problem }
cannot-encrypt-because-missing = Nie można wysłać tej wiadomości za pomocą szyfrowania typu „end-to-end”, ponieważ wystąpiły problemy z kluczami tych odbiorców: { $problem }
window-locked = Okno tworzenia wiadomości jest zablokowane; anulowano wysyłanie
# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Zaszyfrowana część wiadomości
mime-decrypt-encrypted-part-concealed-data = To jest zaszyfrowana część wiadomości. Musisz otworzyć ją w oddzielnym oknie, klikając załącznik.
# Strings in keyserver.jsm
keyserver-error-aborted = Przerwano
keyserver-error-unknown = Wystąpił nieznany błąd
keyserver-error-server-error = Serwer kluczy zgłosił błąd.
keyserver-error-import-error = Zaimportowanie pobranego klucza się nie powiodło.
keyserver-error-unavailable = Serwer kluczy jest niedostępny.
keyserver-error-security-error = Serwer kluczy nie obsługuje szyfrowanego dostępu.
keyserver-error-certificate-error = Certyfikat serwera kluczy jest nieprawidłowy.
keyserver-error-unsupported = Serwer kluczy nie jest obsługiwany.
# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Dostawca poczty przetworzył żądanie wysłania klucza publicznego do katalogu kluczy OpenPGP.
    Proszę potwierdzić, aby dokończyć publikację klucza publicznego.
wkd-message-body-process =
    To wiadomość związana z automatycznym przetwarzaniem w celu wysłania klucza publicznego do katalogu kluczy OpenPGP.
    Na tym etapie nie musisz podejmować żadnych dodatkowych działań.
# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Nie można odszyfrować wiadomości o temacie
    „{ $subject }”.
    Czy chcesz spróbować ponownie za pomocą innego hasła, czy chcesz pominąć wiadomość?
# Strings in gpg.jsm
unknown-signing-alg = Nieznany algorytm podpisywania (identyfikator: { $id })
unknown-hash-alg = Nieznana funkcja kryptograficzna (identyfikator: { $id })
# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Twój klucz { $desc } wygaśnie za mniej niż { $days } dni.
    Zalecamy utworzenie nowej pary kluczy i skonfigurowanie odpowiednich kont, aby z niej korzystać.
expiry-keys-expire-soon =
    Te klucze wygasną za mniej niż { $days } dni: { $desc }.
    Zalecamy utworzenie nowych kluczy i skonfigurowanie odpowiednich kont, aby z nich korzystać.
expiry-key-missing-owner-trust =
    Tajny klucz { $desc } nie ma ustawionego zaufania.
    Zalecamy ustawienie „Ufasz certyfikatom” na „bezwzględne” we właściwościach klucza.
expiry-keys-missing-owner-trust =
    Te tajne klucze nie mają ustawionego zaufania:
    { $desc }.
    Zalecamy ustawienie „Ufasz certyfikatom” na „bezwzględne” we właściwościach klucza.
expiry-open-key-manager = Otwórz menedżera kluczy OpenPGP
expiry-open-key-properties = Otwórz właściwości klucza
# Strings filters.jsm
filter-folder-required = Musisz wybrać folder docelowy.
filter-decrypt-move-warn-experimental =
    Ostrzeżenie: działanie filtru „Odszyfruj na stałe” może spowodować uszkodzenie wiadomości.
    Zdecydowanie zalecamy najpierw wypróbować filtr „Utwórz odszyfrowaną kopię”, dokładnie sprawdzić wynik i zacząć korzystać z tego filtru dopiero wtedy, gdy wynik jest zadowalający.
filter-term-pgpencrypted-label = Zaszyfrowane za pomocą OpenPGP
filter-key-required = Musisz wybrać klucz odbiorcy.
filter-key-not-found = Nie można odnaleźć klucza szyfrowania dla „{ $desc }”.
filter-warn-key-not-secret =
    Ostrzeżenie: działanie filtru „Zaszyfruj do klucza” zastępuje odbiorców.
    Jeśli nie masz tajnego klucza dla „{ $desc }”, nie będzie można już odczytać tych wiadomości.
# Strings filtersWrapper.jsm
filter-decrypt-move-label = Odszyfruj na stałe (OpenPGP)
filter-decrypt-copy-label = Utwórz odszyfrowaną kopię (OpenPGP)
filter-encrypt-label = Zaszyfruj do klucza (OpenPGP)
# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Pomyślnie zaimportowano klucze
import-info-bits = Bity
import-info-created = Utworzono
import-info-fpr = Odcisk klucza
import-info-details = Wyświetl informacje i zarządzaj akceptacją kluczy
import-info-no-keys = Nie zaimportowano żadnych kluczy.
# Strings in enigmailKeyManager.js
import-from-clip = Czy zaimportować klucze ze schowka?
import-from-url = Pobierz klucz publiczny z tego adresu URL:
copy-to-clipbrd-failed = Nie można skopiować wybranych kluczy do schowka.
copy-to-clipbrd-ok = Skopiowano klucze do schowka
delete-secret-key =
    OSTRZEŻENIE: za chwilę zostanie usunięty tajny klucz!
    
    Po usunięciu swojego tajnego klucza nie będzie już można odszyfrować żadnych wiadomości zaszyfrowanych dla tego klucza, ani nie będzie można go unieważnić.
    
    Czy na pewno usunąć OBYDWA klucze, tajny klucz i klucz publiczny
    „{ $userId }”?
delete-mix =
    OSTRZEŻENIE: za chwilę zostaną usunięte tajne klucze!
    Po usunięciu swojego tajnego klucza nie będzie już można odszyfrować żadnych wiadomości zaszyfrowanych dla tego klucza.
    Czy na pewno usunąć OBYDWA klucze, wybrane tajne klucze i klucze publiczne?
delete-pub-key =
    Czy usunąć klucz publiczny
    „{ $userId }”?
delete-selected-pub-key = Czy usunąć klucze publiczne?
refresh-all-question = Nie wybrano żadnego klucza. Czy odświeżyć WSZYSTKIE klucze?
key-man-button-export-sec-key = &Eksportuj tajne klucze
key-man-button-export-pub-key = E&ksportuj tylko klucze publiczne
key-man-button-refresh-all = &Odśwież wszystkie klucze
key-man-loading-keys = Wczytywanie kluczy, proszę czekać…
ascii-armor-file = Pliki zakodowanego ASCII (*.asc)
no-key-selected = Aby wykonać wybrane działanie, należy wybrać co najmniej jeden klucz
export-to-file = Eksportuj klucz publiczny do pliku
export-keypair-to-file = Eksportuj tajny i publiczny klucz do pliku
export-secret-key = Czy dołączyć tajny klucz do zapisywanego pliku klucza OpenPGP?
save-keys-ok = Pomyślnie zapisano klucze
save-keys-failed = Zapisanie kluczy się nie powiodło
default-pub-key-filename = Wyeksportowane-klucze-publiczne
default-pub-sec-key-filename = Kopia-zapasowa-tajnych-kluczy
refresh-key-warn = Ostrzeżenie: w zależności od liczby kluczy i szybkości połączenia, odświeżenie wszystkich kluczy może być dość długim procesem.
preview-failed = Nie można odczytać pliku klucza publicznego.
general-error = Błąd: { $reason }
dlg-button-delete = &Usuń

## Account settings export output

openpgp-export-public-success = <b>Pomyślnie wyeksportowano klucz publiczny.</b>
openpgp-export-public-fail = <b>Nie można wyeksportować wybranego klucza publicznego.</b>
openpgp-export-secret-success = <b>Pomyślnie wyeksportowano tajny klucz.</b>
openpgp-export-secret-fail = <b>Nie można wyeksportować wybranego tajnego klucza.</b>
# Strings in keyObj.jsm
key-ring-pub-key-revoked = Klucz { $userId } (identyfikator klucza: { $keyId }) jest unieważniony.
key-ring-pub-key-expired = Klucz { $userId } (identyfikator klucza: { $keyId }) wygasł.
key-ring-no-secret-key = Wygląda na to, że w Twojej bazie kluczy nie ma tajnego klucza dla { $userId } (identyfikator klucza: { $keyId }); nie można używać tego klucza do podpisywania.
key-ring-pub-key-not-for-signing = Klucz { $userId } (identyfikator klucza: { $keyId }) nie może być używany do podpisywania.
key-ring-pub-key-not-for-encryption = Klucz { $userId } (identyfikator klucza: { $keyId }) nie może być używany do szyfrowania.
key-ring-sign-sub-keys-revoked = Wszystkie klucze podrzędne do podpisywania klucza { $userId } (identyfikator klucza: { $keyId }) są unieważnione.
key-ring-sign-sub-keys-expired = Wszystkie klucze podrzędne do podpisywania klucza { $userId } (identyfikator klucza: { $keyId }) wygasły.
key-ring-enc-sub-keys-revoked = Wszystkie klucze podrzędne do szyfrowania klucza { $userId } (identyfikator klucza: { $keyId }) są unieważnione.
key-ring-enc-sub-keys-expired = Wszystkie klucze podrzędne do szyfrowania klucza { $userId } (identyfikator klucza: { $keyId }) wygasły.
# Strings in gnupg-keylist.jsm
keyring-photo = Zdjęcie
user-att-photo = Atrybut użytkownika (obraz JPEG)
# Strings in key.jsm
already-revoked = Ten klucz został już unieważniony.
#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Za chwilę zostanie unieważniony klucz „{ $identity }”.
    Nie będzie już można podpisywać za pomocą tego klucza, a po rozprowadzeniu tej zmiany inni nie będą już mogli zaszyfrowywać za pomocą tego klucza. Nadal można używać klucza do odszyfrowywania starych wiadomości.
    Czy kontynuować?
#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    Nie masz klucza (0x{ $keyId }) pasującego do tego certyfikatu unieważnienia.
    Jeśli utracono klucz, musisz go zaimportować (np. z serwera kluczy) przed zaimportowaniem certyfikatu unieważnienia.
#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = Klucz 0x{ $keyId } został już unieważniony.
key-man-button-revoke-key = &Unieważnij klucz
openpgp-key-revoke-success = Pomyślnie unieważniono klucz.
after-revoke-info =
    Klucz został unieważniony.
    Udostępnij ten klucz publiczny ponownie, wysyłając go pocztą e-mail lub przesyłając go do serwerów kluczy, aby inni dowiedzieli się, że został unieważniony.
    Gdy tylko oprogramowanie używane przez innych dowie się o unieważnieniu, przestanie używać starego klucza.
    Jeśli używasz nowego klucza dla tego samego adresu e-mail i załączasz nowy klucz publiczny do wysyłanych wiadomości, to informacje o unieważnionym starym kluczu będą automatycznie dołączane.
# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = I&mportuj
delete-key-title = Usuń klucz OpenPGP
delete-external-key-title = Usuń zewnętrzny klucz GnuPG
delete-external-key-description = Czy usunąć ten zewnętrzny identyfikator klucza GnuPG?
key-in-use-title = Obecnie używany klucz OpenPGP
delete-key-in-use-description = Nie można kontynuować. Klucz wybrany do usunięcia jest obecnie używany przez tę tożsamość. Wybierz inny klucz lub wybierz żaden i spróbuj ponownie.
revoke-key-in-use-description = Nie można kontynuować. Klucz wybrany do unieważnienia jest obecnie używany przez tę tożsamość. Wybierz inny klucz lub wybierz żaden i spróbuj ponownie.
# Strings used in errorHandling.jsm
key-error-key-spec-not-found = Adres e-mail „{ $keySpec }” nie może zostać dopasowany do żadnego klucza w Twojej bazie kluczy.
key-error-key-id-not-found = W Twojej bazie kluczy nie można odnaleźć identyfikatora klucza „{ $keySpec }”.
key-error-not-accepted-as-personal = Nie potwierdzono, że klucz o identyfikatorze „{ $keySpec }” to Twój klucz osobisty.
# Strings used in enigmailKeyManager.js & windows.jsm
need-online = Wybrana funkcja jest niedostępna w trybie offline. Przejdź do trybu online i spróbuj ponownie.
# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Nie można odnaleźć żadnego klucza spełniającego podane kryteria wyszukiwania.
# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Błąd: polecenie odczytu klucza się nie powiodło
# Strings used in keyRing.jsm
fail-cancel = Błąd: użytkownik anulował odebranie klucza
not-first-block = Błąd: pierwszy blok OpenPGP nie jest blokiem klucza publicznego
import-key-confirm = Zaimportować klucze publiczne osadzone w wiadomości?
fail-key-import = Błąd: zaimportowanie klucza się nie powiodło
file-write-failed = Zapisanie do pliku { $output } się nie powiodło
no-pgp-block = Błąd: nie odnaleziono prawidłowego zakodowanego bloku danych OpenPGP
confirm-permissive-import = Zaimportowanie się nie powiodło. Importowany klucz może być uszkodzony lub używać nieznanych atrybutów. Czy spróbować zaimportować części, które są poprawne? Może to skończyć się zaimportowaniem niepełnych lub nienadających się do użytku kluczy.
# Strings used in trust.jsm
key-valid-unknown = nieznany
key-valid-invalid = nieprawidłowy
key-valid-disabled = wyłączony
key-valid-revoked = unieważniony
key-valid-expired = wygasły
key-trust-untrusted = niezaufany
key-trust-marginal = ograniczony
key-trust-full = zaufany
key-trust-ultimate = bezwzględny
key-trust-group = (grupa)
# Strings used in commonWorkflows.js
import-key-file = Importuj plik klucza OpenPGP
import-rev-file = Importuj plik unieważnienia OpenPGP
gnupg-file = Pliki GnuPG
import-keys-failed = Zaimportowanie kluczy się nie powiodło
passphrase-prompt = Wprowadź hasło odblokowujące ten klucz: { $key }
file-to-big-to-import = Ten plik jest za duży. Nie importuj jednocześnie dużego zestawu kluczy.
# Strings used in enigmailKeygen.js
save-revoke-cert-as = Utwórz i zapisz certyfikat unieważnienia
revoke-cert-ok = Pomyślnie utworzono certyfikat unieważnienia. Możesz go użyć do unieważnienia swojego klucza publicznego, na przykład w przypadku utraty tajnego klucza.
revoke-cert-failed = Nie można utworzyć certyfikatu unieważnienia.
gen-going = Generowanie klucza już trwa.
keygen-missing-user-name = Dla wybranego konta/tożsamości nie określono nazwy. Podaj wartość w polu „Imię i nazwisko” w ustawieniach konta.
expiry-too-short = Klucz musi być ważny przez przynajmniej jeden dzień.
expiry-too-long = Nie można utworzyć klucza, który wygasa za więcej niż 100 lat.
key-confirm = Wygenerować publiczny klucz i tajny klucz dla „{ $id }”?
key-man-button-generate-key = &Wygeneruj klucz
key-abort = Przerwać generowanie klucza?
key-man-button-generate-key-abort = &Przerwij generowanie klucza
key-man-button-generate-key-continue = &Kontynuuj generowanie klucza

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = Błąd: odszyfrowanie się nie powiodło
fix-broken-exchange-msg-failed = Nie można naprawić tej wiadomości.
attachment-no-match-from-signature = Nie można dopasować pliku podpisu „{ $attachment }” do załącznika
attachment-no-match-to-signature = Nie można dopasować załącznika „{ $attachment }” do pliku podpisu
signature-verified-ok = Pomyślnie zweryfikowano podpis dla załącznika { $attachment }
signature-verify-failed = Nie można zweryfikować podpisu dla załącznika { $attachment }
decrypt-ok-no-sig =
    Ostrzeżenie
    Odszyfrowanie się powiodło, ale nie można poprawnie zweryfikować podpisu
msg-ovl-button-cont-anyway = &Kontynuuj mimo to
enig-content-note = *Załączniki do tej wiadomości nie zostały podpisane ani zaszyfrowane*
# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = &Wyślij wiadomość
msg-compose-details-button-label = Informacje…
msg-compose-details-button-access-key = I
send-aborted = Przerwano działanie wysyłania.
key-not-trusted = Niewystarczające zaufanie dla klucza „{ $key }”
key-not-found = Nie odnaleziono klucza „{ $key }”
key-revoked = Klucz „{ $key }” jest unieważniony
key-expired = Klucz „{ $key }” wygasł
msg-compose-internal-error = Wystąpił błąd wewnętrzny.
keys-to-export = Wybierz klucze OpenPGP do wstawienia
msg-compose-partially-encrypted-inlinePGP =
    Wiadomość, na którą odpowiadasz, zawierała niezaszyfrowane i zaszyfrowane części. Jeśli nadawca nie był w stanie odszyfrować pewnych części wiadomości, to być może powodujesz wyciek poufnych informacji, których nadawca nie był w stanie odszyfrować.
    Proszę zastanowić się nad usunięciem całego cytowanego tekstu ze swojej odpowiedzi do tego nadawcy.
msg-compose-cannot-save-draft = Błąd podczas zapisywania szkicu
msg-compose-partially-encrypted-short = Uważaj na wycieki poufnych informacji — częściowo zaszyfrowana wiadomość.
quoted-printable-warn =
    Włączono kodowanie „Quoted-Printable” dla wysyłanych wiadomości. Może to spowodować niepoprawne odszyfrowanie lub weryfikację wiadomości.
    Czy wyłączyć teraz wysyłanie wiadomości „Quoted-Printable”?
minimal-line-wrapping =
    Ustawiono zawijanie wierszy na taką liczbę znaków: { $width }. Aby zapewnić poprawne szyfrowanie i podpisywanie, ta wartość musi wynosić co najmniej 68.
    Czy zmienić teraz zawijanie wierszy na 68 znaków?
sending-hidden-rcpt = Podczas wysyłania zaszyfrowanej wiadomości nie można używać odbiorców ukrytej kopii. Aby wysłać tę zaszyfrowaną wiadomość, usuń odbiorców ukrytej kopii lub przenieś ich do pola odbiorców kopii.
sending-news =
    Przerwano zaszyfrowane działanie wysyłania.
    Nie można zaszyfrować tej wiadomości, ponieważ ma ona odbiorców będących grupami dyskusyjnymi. Wyślij wiadomość ponownie bez szyfrowania.
send-to-news-warning =
    Ostrzeżenie: za chwilę zostanie wysłana zaszyfrowana wiadomość na grupę dyskusyjną.
    Jest to niezalecane, ponieważ ma to sens tylko wtedy, gdy wszyscy członkowie grupy mogą odszyfrować wiadomość, tzn. wiadomość musi zostać zaszyfrowana za pomocą kluczy wszystkich uczestników grupy. Wyślij tę wiadomość tylko wtedy, gdy dobrze wiesz, co robisz.
    Kontynuować?
save-attachment-header = Zapisz odszyfrowany załącznik
no-temp-dir =
    Nie można odnaleźć katalogu tymczasowego do zapisu
    Ustaw zmienną środowiskową TEMP
possibly-pgp-mime = Wiadomość prawdopodobnie zaszyfrowana lub podpisana za pomocą PGP/MIME; użyj funkcji „Odszyfruj/zweryfikuj” do weryfikacji
cannot-send-sig-because-no-own-key = Nie można podpisać cyfrowo tej wiadomości, ponieważ nie skonfigurowano jeszcze szyfrowania typu „end-to-end” dla <{ $key }>
cannot-send-enc-because-no-own-key = Nie można wysłać tej wiadomości w postaci zaszyfrowanej, ponieważ nie skonfigurowano jeszcze szyfrowania typu „end-to-end” dla <{ $key }>
# Strings used in decryption.jsm
do-import-multiple =
    Zaimportować te klucze?
    { $key }
do-import-one = Zaimportować „{ $name }” ({ $id })?
cant-import = Błąd podczas importowania klucza publicznego
unverified-reply = Wcięta część wiadomości (odpowiedź) została prawdopodobnie zmodyfikowana
key-in-message-body = W treści wiadomości znaleziono klucz. Kliknij „Importuj klucz”, aby go zaimportować
sig-mismatch = Błąd: niezgodność podpisu
invalid-email = Błąd: nieprawidłowe adresy e-mail
attachment-pgp-key =
    Otwierany załącznik „{ $name }” wydaje się być plikiem klucza OpenPGP.
    Kliknij „Importuj”, aby zaimportować zawarte w nim klucze lub „Wyświetl”, aby wyświetlić treść pliku w oknie przeglądarki
dlg-button-view = &Wyświetl
# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Odszyfrowana wiadomość (przywrócono uszkodzony format wiadomości e-mail PGP prawdopodobnie spowodowany przez stary serwer Exchange, więc wynik może nie być dokładnie taki, jak powinien)
# Strings used in encryption.jsm
not-required = Błąd: szyfrowanie nie jest wymagane
# Strings used in windows.jsm
no-photo-available = Brak dostępnych zdjęć
error-photo-path-not-readable = Ścieżka do zdjęcia „{ $photo }” jest nie do odczytania
debug-log-title = Dziennik debugowania OpenPGP
# Strings used in dialog.jsm
repeat-prefix = Ten komunikat będzie powtarzany { $count }
repeat-suffix-singular = jeszcze raz.
repeat-suffix-plural = razy więcej.
no-repeat = Ten komunikat nie będzie wyświetlany ponownie.
dlg-keep-setting = Zapamiętaj moją odpowiedź i nie pytaj więcej
dlg-button-ok = &OK
dlg-button-close = Za&mknij
dlg-button-cancel = &Anuluj
dlg-no-prompt = Nie wyświetlaj więcej tego okna dialogowego
enig-prompt = Monit OpenPGP
enig-confirm = Potwierdzenie OpenPGP
enig-alert = Komunikat OpenPGP
enig-info = Informacje OpenPGP
# Strings used in persistentCrypto.jsm
dlg-button-retry = &Ponów
dlg-button-skip = Po&miń
# Strings used in enigmailCommon.js
enig-error = Błąd OpenPGP
# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = Komunikat OpenPGP
