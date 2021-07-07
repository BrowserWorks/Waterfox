# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Pranešimas apie „{ $addon-name }“

abuse-report-title-extension = Pranešti apie šį priedą į „{ -vendor-short-name }“
abuse-report-title-theme = Pranešti apie šį priedą į „{ -vendor-short-name }“
abuse-report-subtitle = Kokia problema?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = sukūrė <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Nežinote, kurią problemą pasirinkti?
    <a data-l10n-name="learnmore-link">Sužinokite daugiau, kaip geriau pranešti apie priedus ir grafinius apvalkalus</a>

abuse-report-submit-description = Apibūdinkite problemą (neprivaloma)
abuse-report-textarea =
    .placeholder = Mums lengviau reaguoti į problemas, kai turime daugiau detalių. Aprašykite, kokia esame situacija. Ačiū, kad padedate palaikyti saityno kokybę.
abuse-report-submit-note =
    Atminkite: nepalikite asmeninės informacijos (pvz., vardo, el. pašto adreso, telefono numerio, fizinio adreso).
    „{ -vendor-short-name }“ šiuos pranešimus įrašo visam laikui.

## Panel buttons.

abuse-report-cancel-button = Atsisakyti
abuse-report-next-button = Toliau
abuse-report-goback-button = Eiti atgal
abuse-report-submit-button = Pateikti

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Pranešimas apie <span data-l10n-name="addon-name">„{ $addon-name }“</span> atšauktas.
abuse-report-messagebar-submitting = Siunčiamas pranešimas apie <span data-l10n-name="addon-name">„{ $addon-name }“</span>.
abuse-report-messagebar-submitted = Ačiū už pateiktą pranešimą. Ar norėtumėte pašalinti <span data-l10n-name="addon-name">„{ $addon-name }“</span>?
abuse-report-messagebar-submitted-noremove = Ačiū už pateiktą pranešimą.
abuse-report-messagebar-removed-extension = Ačiū už patetiką pranešimą. Pašalinote <span data-l10n-name="addon-name">„{ $addon-name }“</span> priedą.
abuse-report-messagebar-removed-theme = Ačiū už pranešimą. Pašalinote <span data-l10n-name="addon-name">„{ $addon-name }“</span> grafinį apvalkalą.
abuse-report-messagebar-error = Siunčiant pranešimą apie <span data-l10n-name="addon-name">„{ $addon-name }“</span> įvyko klaida.
abuse-report-messagebar-error-recent-submit = Pranešimas apie <span data-l10n-name="addon-name">„{ $addon-name }“</span> nebuvo išsiųstas, nes neseniai buvo pateiktas kitas pranešimas.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Taip, pašalinti
abuse-report-messagebar-action-keep-extension = Ne, tegul lieka
abuse-report-messagebar-action-remove-theme = Taip, pašalinti
abuse-report-messagebar-action-keep-theme = Ne, tegul lieka
abuse-report-messagebar-action-retry = Kartoti
abuse-report-messagebar-action-cancel = Atsisakyti

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Pažeidė mano kompiuterį arba mano duomenis
abuse-report-damage-example = Pavyzdys: įdiegė virusą arba pavogė duomenis

abuse-report-spam-reason-v2 = Yra nepageidaujamo turinio arba nepageidaujamų reklamų
abuse-report-spam-example = Pavyzdys: svetainėse įterpia reklamas

abuse-report-settings-reason-v2 = Pakeitė mano ieškyklę, pradžios tinklalapį, arba naują kortelę, apie tai nepranešant ir nepaklausiant
abuse-report-settings-suggestions = Prieš pranešdami apie priedą, galite pabandyti pakeisti nuostatas:
abuse-report-settings-suggestions-search = Keisti numatytosios ieškyklės nuostatas
abuse-report-settings-suggestions-homepage = Keisti pradžios tinklalapį ir naujos kortelės tinklalapį

abuse-report-deceptive-reason-v2 = Apsimeta kažkuo kitu
abuse-report-deceptive-example = Pavyzdys: klaidinantis aprašymas arba vaizdai

abuse-report-broken-reason-extension-v2 = Neveikia, trikdo svetainių veikimą, arba lėtina „{ -brand-product-name }“ veikimą{ -brand-product-name }
abuse-report-broken-reason-theme-v2 = Neveikia arba trikdo naršyklės vaizdą
abuse-report-broken-example = Pavyzdys: lėtas funkcionalumas, sudėtinga naudotis, arba visai neveikia; kai kurios svetainių dalys neįkeliamos arba atrodo neįprastai
abuse-report-broken-suggestions-extension =
    Panašu, kad aptikote triktį. Pateikus pranešimą čia, kitas geras būdas problemos spręsti
    yra susisiekti su priedo kūrėju. <a data-l10n-name="support-link">Aplankę priedo svetainę</a>, rasite kūrėjo kontaktus.
abuse-report-broken-suggestions-theme =
    Panašu, kad aptikote triktį. Pateikus pranešimą čia, kitas geras būdas problemos spręsti
    yra susisiekti su grafinio apvalkalo kūrėju. <a data-l10n-name="support-link">Aplankę grafinio apvalkalo svetainę</a>, rasite kūrėjo kontaktus.

abuse-report-policy-reason-v2 = Yra neapykantą, smurtą kurstančio arba nelegalaus turinio
abuse-report-policy-suggestions =
    Atminkite: problemos dėl autorių teisių ir prekių ženklų privalo būti pateiktos atskirai.
    Norėdami pranešti apie tokią problemą, <a data-l10n-name="report-infringement-link">sekite šias instrukcijas</a>.

abuse-report-unwanted-reason-v2 = Niekada nenorėjau ir nežinau kaip tuo atsikratyti
abuse-report-unwanted-example = Pavyzdys: programa įdiegė priedą be mano sutikimo

abuse-report-other-reason = Kažkas kito

