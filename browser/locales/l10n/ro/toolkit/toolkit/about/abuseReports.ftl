# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Raport pentru { $addon-name }

abuse-report-title-extension = Raportează această extensie la { -vendor-short-name }
abuse-report-title-theme = Raportează această temă la { -vendor-short-name }
abuse-report-subtitle = Care e problema?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = de către <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore = Nu ești sigur(ă) ce să selectezi? <a data-l10n-name="learnmore-link">Află mai multe despre raportarea extensiilor și a temelor</a>

abuse-report-submit-description = Descrie problema (opțional)
abuse-report-textarea =
    .placeholder = Ne este mai ușor să abordăm o problemă dacă avem informații specifice. Te rugăm să descrii ce probleme ai întâmpinat. Îți mulțumim că ne ajuți să menținem webul sănătos.
abuse-report-submit-note = Notă: Nu include informații personale (precum nume, adresă de e-mail, număr de telefon, adresă fizică). { -vendor-short-name } păstrează evidențe permanente cu aceste raportări.

## Panel buttons.

abuse-report-cancel-button = Anulează
abuse-report-next-button = Înainte
abuse-report-goback-button = Înapoi
abuse-report-submit-button = Transmite

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Raportare anulată pentru <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitting = Se transmite raportarea pentru <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Îți mulțumim că ai trimis raportarea. Vrei să elimini <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Îți mulțumim că ai transmis o raportare.
abuse-report-messagebar-removed-extension = Îți mulțumim că ai trimis o raportare. Ai eliminat extensia <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Îți mulțumim că ai trimis o raportare. Ai eliminat tema <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = A apărut o problemă la transmiterea raportării pentru <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Raportarea pentru <span data-l10n-name="addon-name">{ $addon-name }</span> nu a fost transmisă deoarece a mai fost depusă recent altă raportare.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Da, elimin-o
abuse-report-messagebar-action-keep-extension = Nu, păstreaz-o
abuse-report-messagebar-action-remove-theme = Da, elimin-o
abuse-report-messagebar-action-keep-theme = Nu, păstreaz-o
abuse-report-messagebar-action-retry = Reîncearcă
abuse-report-messagebar-action-cancel = Anulează

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Mi-a stricat calculatorul sau mi-a compromis datele
abuse-report-damage-example = Exemplu: Injectare de programe rău intenționate sau furt de date

abuse-report-spam-reason-v2 = Conține spam sau introduce reclame nedorite
abuse-report-spam-example = Exemplu: Inserare de reclame pe pagini web

abuse-report-settings-reason-v2 = Mi-a schimbat motorul de căutare, pagina de start sau fila nouă fără să mă informeze sau să îmi ceară permisiunea
abuse-report-settings-suggestions = Înainte de a raporta extensia, poți încerca să îți modifici setările:
abuse-report-settings-suggestions-search = Schimbă setările implicite de căutare
abuse-report-settings-suggestions-homepage = Schimbă pagina de start și de filă nouă

abuse-report-deceptive-reason-v2 = Pretinde că e ceva ce nu este
abuse-report-deceptive-example = Exemplu: Descriere sau grafică ce induce în eroare

abuse-report-broken-reason-extension-v2 = Nu funcționează, produce defecțiuni pe site-uri web sau înceteinește { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Nu funcționează sau face inutilizabil afișajul în browser
abuse-report-broken-example = Exemplu: Funcționalitățile sunt lente, greu de utilizat sau nu funcționează; nu se încarcă părți din site-uri sau arată straniu
abuse-report-broken-suggestions-extension = Pare că ai identificat o defecțiune. În plus față de transmiterea unei raportări aici, cea mai bună cale de rezolvare a unei probleme de funcționalitate este să contactezi dezvoltatorul extensiei. <a data-l10n-name="support-link">Intră pe site-ul extensiei</a> pentru a obține datele de contact ale dezvoltatorului.
abuse-report-broken-suggestions-theme = Pare că ai identificat o defecțiune. În plus față de transmiterea unei raportări aici, cea mai bună cale de rezolvare a unei probleme de funcționalitate este să contactezi dezvoltatorul temei. <a data-l10n-name="support-link">Intră pe site-ul temei</a> pentru a obține datele de contact ale dezvoltatorului.

abuse-report-policy-reason-v2 = Are conținut de ură, violent sau ilegal
abuse-report-policy-suggestions = Notă: Aspectele legate de drepturile de reproducere și mărcile comerciale trebuie raportate printr-o procedură separată. <a data-l10n-name="report-infringement-link">Folosește aceste instrucțiuni</a> ca să raportezi problema.

abuse-report-unwanted-reason-v2 = Nu l-am vrut niciodată și nu știu cum să scap de el
abuse-report-unwanted-example = Exemplu: A fost instalată de o aplicație fără permisiunea mea

abuse-report-other-reason = Altceva

