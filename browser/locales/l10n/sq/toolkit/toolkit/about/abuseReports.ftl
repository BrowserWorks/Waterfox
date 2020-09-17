# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Raport për { $addon-name }

abuse-report-title-extension = Raportojeni Këtë Zgjerim te { -vendor-short-name }
abuse-report-title-theme = Raportojeni Këtë Temë te { -vendor-short-name }
abuse-report-subtitle = Ç’problem ka?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = nga <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    S’jeni i sigurt ç’problem të zgjidhni?
    <a data-l10n-name="learnmore-link">Mësoni më tepër rreth raportimi zgjerimesh dhe temash</a>

abuse-report-submit-description = Përshkruani problemin (në daçi)
abuse-report-textarea =
    .placeholder = Për ne është më e lehtë të merremi me një problem, nëse kemi hollësi. Ju lutemi, përshkruani ç’po ju ndodh. Faleminderit që na ndihmoni ta mbajmë internetin të shëndetshëm.
abuse-report-submit-note =
    Shënim: Mos përfshini të dhëna personale, (fjala vjen, emër, adresë email, numër telefoni, adresë fizike).
     { -vendor-short-name } ruan një regjistër të përhershëm të këtyre raportimeve.

## Panel buttons.

abuse-report-cancel-button = Anuloje
abuse-report-next-button = Pasuesi
abuse-report-goback-button = Kthehu mbrapsht
abuse-report-submit-button = Parashtroje

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Raportimi për <span data-l10n-name="addon-name">{ $addon-name }</span> u anulua.
abuse-report-messagebar-submitting = Po dërgohet raportim për <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Faleminderit për parashtrimin e një raportimi. Doni të hiqet <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Faleminderit për parashtrimin e një raporti.
abuse-report-messagebar-removed-extension = Faleminderit për parashtrimin e një raporti. E hoqët zgjerimin <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Faleminderit për parashtrimin e një raporti. E hoqët temën <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Pati një gabim me dërgimin e raportit për <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Raporti për <span data-l10n-name="addon-name">{ $addon-name }</span> s’u dërgua, ngaqë tani afër qe parashtruar një tjetër raport.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Po, Hiqe
abuse-report-messagebar-action-keep-extension = Jo, Do Ta Mbaj
abuse-report-messagebar-action-remove-theme = Po, Hiqe
abuse-report-messagebar-action-keep-theme = Jo, Do Ta Mbaj
abuse-report-messagebar-action-retry = Riprovo
abuse-report-messagebar-action-cancel = Anuloje

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Dëmtoi kompjuterin tim ose komprometoi të dhënat e mia
abuse-report-damage-example = Shembull: Injektoi <em>malware</em> ose vodhi të dhëna

abuse-report-spam-reason-v2 = Përmban mesazhe të padëshiruar ose fut reklama të padëshiruara
abuse-report-spam-example = Shembull: Fut reklama në faqe web

abuse-report-settings-reason-v2 = Ndryshoi motorin tim të kërkimeve, faqen time hyrëse, ose skedën e re, pa më njoftuar ose pyetur
abuse-report-settings-suggestions = Përpara raportimit të zgjerimit, mund të provoni të ndryshoni rregullimet tuaja:
abuse-report-settings-suggestions-search = Ndryshoni rregullimet mbi parazgjedhje lidhur me kërkimet
abuse-report-settings-suggestions-homepage = Ndryshoni faqen tuaj hyrëse dhe skedë të re

abuse-report-deceptive-reason-v2 = Pretendon të jetë diçka që s’është
abuse-report-deceptive-example = Shembull: Përshkrim ose figurë e gabuar

abuse-report-broken-reason-extension-v2 = S’funksionon, dëmton shfaqjen e sajteve, ose ngadalëson { -brand-product-name }-in
abuse-report-broken-reason-theme-v2 = S’funksionon ose dëmton shfaqjen e shfletuesit
abuse-report-broken-example = Shembull: Veçoritë janë të ngadalta, të zorshme për t’u përdorur, ose s’funksionojnë fare; pjesë sajtesh nuk ngarkohen ose duken çuditshëm
abuse-report-broken-suggestions-extension =
    Duket sikur keni identifikuar një të metë. Veç parashtrimit të një raporti këtu, rruga më e mirë për zgjidhjen e një problemi funksionimi është të lidheni me zhvilluesin e zgjerimit.
    Që të merrni të dhëna rreth tij, <a data-l10n-name="support-link">vizitoni sajtin e zgjerimit</a>.
abuse-report-broken-suggestions-theme =
    Duket sikur keni identifikuar një të metë. Veç parashtrimit të një raporti këtu, rruga më e mirë për zgjidhjen e një problemi funksionimi është të lidheni me zhvilluesin e temës.
    Që të merrni të dhëna rreth tij, <a data-l10n-name="support-link">vizitoni sajtin e temës</a>.

abuse-report-policy-reason-v2 = Përmban lëndë që nxit urrejtje, të dhunshme ose të paligjshme
abuse-report-policy-suggestions =
    Shënim: Çështje të drejtash kopjimi dhe shenjash tregtare duhet të raportohen në një proces më vete.
    Për të raportuar një problem <a data-l10n-name="report-infringement-link">përdorni këto udhëzime</a>.

abuse-report-unwanted-reason-v2 = S’e kam dashur ndonjëherë dhe nuk di si ta heq qafe
abuse-report-unwanted-example = Shembull: E instaloi një aplikacion, pa lejen time

abuse-report-other-reason = Diçka tjetër

