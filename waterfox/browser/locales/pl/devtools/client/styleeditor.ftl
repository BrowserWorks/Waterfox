# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = Utwórz nowy arkusz stylów i dołącz go do dokumentu
    .accesskey = N
styleeditor-import-button =
    .tooltiptext = Importuj istniejący arkusz stylów i dołącz go do dokumentu
    .accesskey = I
styleeditor-filter-input =
    .placeholder = Filtruj arkusze stylów
styleeditor-visibility-toggle =
    .tooltiptext = Przełącz widoczność arkusza stylów
    .accesskey = Z
styleeditor-visibility-toggle-system =
    .tooltiptext = Systemowych arkuszy stylów nie można wyłączyć
styleeditor-save-button = Zapisz
    .tooltiptext = Zapisz ten arkusz stylów do pliku
    .accesskey = Z
styleeditor-options-button =
    .tooltiptext = Ustawienia edytora stylów
styleeditor-at-rules = Reguły @
styleeditor-editor-textbox =
    .data-placeholder = Wprowadź tutaj CSS.
styleeditor-no-stylesheet = Ta strona nie ma arkusza stylów.
styleeditor-no-stylesheet-tip = Być może chcesz <a data-l10n-name="append-new-stylesheet">dołączyć nowy arkusz stylów</a>?
styleeditor-open-link-new-tab =
    .label = Otwórz odnośnik w nowej karcie
styleeditor-copy-url =
    .label = Kopiuj adres URL
styleeditor-find =
    .label = Znajdź
    .accesskey = Z
styleeditor-find-again =
    .label = Znajdź następne
    .accesskey = n
styleeditor-go-to-line =
    .label = Przejdź do wiersza…
    .accesskey = P
# Label displayed when searching a term that is not found in any stylesheet path
styleeditor-stylesheet-all-filtered = Nie odnaleziono pasującego arkusza stylów.

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [one] { $ruleCount } reguła.
        [few] { $ruleCount } reguły.
       *[many] { $ruleCount } reguł.
    }
