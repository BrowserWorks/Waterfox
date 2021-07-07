# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Zgłoszenie dodatku { $addon-name }

abuse-report-title-extension = Zgłoś to rozszerzenie do organizacji { -vendor-short-name }
abuse-report-title-theme = Zgłoś ten motyw do organizacji { -vendor-short-name }
abuse-report-subtitle = Na czym polega problem?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = Autor: <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Nie wiesz, co wybrać?
    <a data-l10n-name="learnmore-link">Więcej informacji o zgłaszaniu rozszerzeń i motywów</a>

abuse-report-submit-description = Opisz problem (opcjonalne)
abuse-report-textarea =
    .placeholder = Łatwiej nam naprawić problem, jeśli znamy konkrety. Prosimy opisać, co się wydarzyło. Dziękujemy za pomoc w utrzymaniu zdrowego Internetu.
abuse-report-submit-note =
    Uwaga: nie dołączaj danych osobowych (takich jak nazwisko, adres e-mail, numer telefonu czy fizyczny adres).
    { -vendor-short-name } przechowuje te zgłoszenia bezterminowo.

## Panel buttons.

abuse-report-cancel-button = Anuluj
abuse-report-next-button = Dalej
abuse-report-goback-button = Wstecz
abuse-report-submit-button = Wyślij

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

## Message bars descriptions.
##
## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Anulowano zgłoszenie dodatku <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitting = Zgłaszanie dodatku <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Dziękujemy za zgłoszenie. Czy usunąć dodatek <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Dziękujemy za zgłoszenie.
abuse-report-messagebar-removed-extension = Dziękujemy za zgłoszenie. Usunięto rozszerzenie <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Dziękujemy za zgłoszenie. Usunięto motyw <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Wystąpił błąd podczas zgłaszania dodatku <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Nie zgłoszono dodatku <span data-l10n-name="addon-name">{ $addon-name }</span>, ponieważ niedawno wysłano inne zgłoszenie.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Tak, usuń
abuse-report-messagebar-action-keep-extension = Nie usuwaj
abuse-report-messagebar-action-remove-theme = Tak, usuń
abuse-report-messagebar-action-keep-theme = Nie usuwaj
abuse-report-messagebar-action-retry = Spróbuj ponownie
abuse-report-messagebar-action-cancel = Anuluj

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Uszkadza mój komputer lub narusza bezpieczeństwo moich danych
abuse-report-damage-example = Przykład: złośliwe oprogramowanie lub kradzież danych

abuse-report-spam-reason-v2 = Zawiera spam lub wstawia niechciane reklamy
abuse-report-spam-example = Przykład: wstawianie reklam na stronach internetowych

abuse-report-settings-reason-v2 = Zmienia moją wyszukiwarkę, stronę startową lub stronę nowej karty bez informacji ani zgody
abuse-report-settings-suggestions = Przed zgłoszeniem rozszerzenia można spróbować zmienić ustawienia:
abuse-report-settings-suggestions-search = Zmień domyślne ustawienia wyszukiwania
abuse-report-settings-suggestions-homepage = Zmień stronę startową i stronę nowej karty

abuse-report-deceptive-reason-v2 = Udaje, że jest czymś, czym nie jest
abuse-report-deceptive-example = Przykład: mylący opis lub obrazy

abuse-report-broken-reason-extension-v2 = Nie działa, psuje strony internetowe lub spowalnia działanie przeglądarki { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Nie działa lub psuje interfejs przeglądarki
abuse-report-broken-example = Przykład: funkcje są wolne, trudne w użyciu lub nie działają, części stron internetowych się nie wczytują lub wyglądają niewłaściwie
abuse-report-broken-suggestions-extension =
    Wygląda na to, że znaleziono błąd. Oprócz zgłoszenia najlepszym sposobem na rozwiązanie
    problemu z funkcjonalnością jest skontaktowanie się z autorami rozszerzenia.
    <a data-l10n-name="support-link">Strona rozszerzenia</a> zawiera informacje o jego autorach.
abuse-report-broken-suggestions-theme =
    Wygląda na to, że znaleziono błąd. Oprócz zgłoszenia najlepszym sposobem na rozwiązanie
    problemu z funkcjonalnością jest skontaktowanie się z autorami motywu.
    <a data-l10n-name="support-link">Strona motywu</a> zawiera informacje o jego autorach.

abuse-report-policy-reason-v2 = Zawiera nienawistne, brutalne lub nielegalne treści
abuse-report-policy-suggestions =
    Uwaga: kwestie praw autorskich i znaków towarowych muszą być zgłaszane inną metodą.
    <a data-l10n-name="report-infringement-link">Skorzystaj z tych instrukcji</a>, aby zgłosić taki problem.

abuse-report-unwanted-reason-v2 = Samo się zainstalowało i nie wiem, jak je usunąć
abuse-report-unwanted-example = Przykład: aplikacja zainstalowała je bez mojej zgody

abuse-report-other-reason = Coś innego

