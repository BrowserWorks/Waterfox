# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Nahlásenie doplnku { $addon-name }

abuse-report-title-extension = Nahlásiť toto rozšírenie spoločnosti { -vendor-short-name }
abuse-report-title-theme = Nahlásiť túto tému vzhľadu spoločnosti { -vendor-short-name }
abuse-report-subtitle = V čom je problém?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = autor: <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Neviete, ktorý problém vybrať?
    <a data-l10n-name="learnmore-link">Pozrite sa na ďalšie informácie o nahlasovaní rozšírení a tém vzhľadu</a>

abuse-report-submit-description = Popis problému (voliteľný)
abuse-report-textarea =
    .placeholder = Ak váš problém podrobne popíšete, môžeme ho jednoduchšie vyriešiť. Ďakujeme vám za hlásenie.
abuse-report-submit-note = Poznámka: nezadávajte, prosím, žiadne osobné údaje (meno, e-mailovú adresu, telefónne číslo ani adresu). { -vendor-short-name } si tieto hlásenia trvalo ukladá.

## Panel buttons.

abuse-report-cancel-button = Zrušiť
abuse-report-next-button = Ďalej
abuse-report-goback-button = Naspäť
abuse-report-submit-button = Odoslať

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Nahlásenie doplnku <span data-l10n-name="addon-name">{ $addon-name }</span> bolo zrušené.
abuse-report-messagebar-submitting = Odosielanie hlásenia o doplnku <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Ďakujeme vám za hlásenie. Chcete doplnok <span data-l10n-name="addon-name">{ $addon-name }</span> odstrániť?
abuse-report-messagebar-submitted-noremove = Ďakujeme vám za hlásenie.
abuse-report-messagebar-removed-extension = Ďakujeme vám za hlásenie. Rozšírenie <span data-l10n-name="addon-name">{ $addon-name }</span> bolo odstránené.
abuse-report-messagebar-removed-theme = Ďakujeme vám za hlásenie. Téma vzhľadu <span data-l10n-name="addon-name">{ $addon-name }</span> bolo odstránené.
abuse-report-messagebar-error = Pri odosielaní hlásenia o doplnku <span data-l10n-name="addon-name">{ $addon-name }</span> nastala chyba.
abuse-report-messagebar-error-recent-submit = Hlásenie o doplnku <span data-l10n-name="addon-name">{ $addon-name }</span> nebolo odoslané, pretože ste ho už nedávno nahlásili.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Áno, odstrániť
abuse-report-messagebar-action-keep-extension = Nie, ponechať
abuse-report-messagebar-action-remove-theme = Áno, odstrániť
abuse-report-messagebar-action-keep-theme = Nie, ponechať
abuse-report-messagebar-action-retry = Skúsiť znova
abuse-report-messagebar-action-cancel = Zrušiť

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Poškodzuje môj počítač a údaje
abuse-report-damage-example = Príklad: malvér alebo krádež údajov

abuse-report-spam-reason-v2 = Spam alebo reklamy
abuse-report-spam-example = Príklad: vkladanie reklám do webových stránok

abuse-report-settings-reason-v2 = Zmena vyhľadávacieho modulu, domovskej stránky alebo stránky novej karty bez predchádzajúceho upozornenia
abuse-report-settings-suggestions = Pred nahlásením tohto rozšírenia skúste upraviť svoje nastavenia:
abuse-report-settings-suggestions-search = Zmena vyhľadávacieho modulu
abuse-report-settings-suggestions-homepage = Zmena domovskej stránky a stránky novej karty

abuse-report-deceptive-reason-v2 = Vydáva sa za niečo iné
abuse-report-deceptive-example = Príklad: zavádzajúci popis alebo náhľady

abuse-report-broken-reason-extension-v2 = Nefunguje, rozbíja webové stránky alebo spomaľuje { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Nefunguje alebo rozbíja rozhranie prehliadača
abuse-report-broken-example = Príklad: funkcie sú pomalé, ťažko sa používa, nefunguje, obmedzuje fungovanie alebo zobrazovanie webových stránok
abuse-report-broken-suggestions-extension = Zdá sa, že ste objavili chybu. Okrem odoslania hlásenia nám v riešení problému pomôže, ak kontaktujete aj autora rozšírenia. <a data-l10n-name="support-link">Navštívte stránky rozšírenia</a>, kde na autora nájdete kontakt.
abuse-report-broken-suggestions-theme = Zdá sa, že ste objavili chybu. Okrem odoslania hlásenia nám v riešení problému pomôže, ak kontaktujete aj autora témy vzhľadu. <a data-l10n-name="support-link">Navštívte stránky témy vzhľadu</a>, kde na autora nájdete kontakt.

abuse-report-policy-reason-v2 = Obsahuje nenávistný, násilný alebo nelegálny obsah
abuse-report-policy-suggestions = Poznámka: problémy s autorskými právami, prosím, hláste podľa <a data-l10n-name="report-infringement-link">tohto návodu</a>.

abuse-report-unwanted-reason-v2 = Nevyžiadané rozšírenie, ktoré neviem odstrániť
abuse-report-unwanted-example = Príklad: nainštalované cudzou aplikáciou bez môjho vedomia

abuse-report-other-reason = V niečom inom

