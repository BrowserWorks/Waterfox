# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Raporto por { $addon-name }

abuse-report-title-extension = Denunci tiun ĉi etendaĵon al { -vendor-short-name }
abuse-report-title-theme = Denunci tiun ĉi etoson al { -vendor-short-name }
abuse-report-subtitle = Kiu estas la problemo?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = de <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore = Ĉu vi ne scias kiun problemon elekti? <a data-l10n-name="learnmore-link">Pli da informo pri denunco de etendaĵoj kaj etosoj</a>

abuse-report-submit-description = Priskribi la problemon (nedevige)
abuse-report-textarea =
    .placeholder = Estas pli facile por ni solvi problemon se ni havas specifajn informojn. Bonvolu priskribi tion, kion vi spertas. Dankon, vi helpas nin teni la reton sana.
abuse-report-submit-note = Rimarko: ne aldonu personajn informojn (ekzemple nomon, retpoŝtan adreson, telefonnumeron, poŝtan adreson). { -vendor-short-name } senlime gardas tiun denuncojn.

## Panel buttons.

abuse-report-cancel-button = Nuligi
abuse-report-next-button = Antaŭen
abuse-report-goback-button = Malantaŭen
abuse-report-submit-button = Sendi

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Denunco por <span data-l10n-name="addon-name">{ $addon-name }</span> nuligita.
abuse-report-messagebar-submitting = Sendo de denunco por <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Dankon pro via denunco. Ĉu vi volas forigi <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Dankon pro via denunco.
abuse-report-messagebar-removed-extension = Dankon pro via denunco. Vi forigis la etendaĵon <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Dankon pro via denunco. Vi forigis la etoson <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Okazis eraro dum la sendo de la denunco por <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = La denunco por <span data-l10n-name="addon-name">{ $addon-name }</span> ne estis sendita ĉar alia denunco estis ĵuse sendita.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Jes, forigi ĝin
abuse-report-messagebar-action-keep-extension = Ne, mi ĝin gardos
abuse-report-messagebar-action-remove-theme = Jes, forigi ĝin
abuse-report-messagebar-action-keep-theme = Ne, mi ĝin gardos
abuse-report-messagebar-action-retry = Klopodi denove
abuse-report-messagebar-action-cancel = Nuligi

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Ĝi difektis mian komputilon aŭ elmetis miajn datumojn
abuse-report-damage-example = Ekzemplo: ĝi injektis malican programon aŭ ŝtelis datumojn

abuse-report-spam-reason-v2 = Ĝi enhavas trudmesaĝojn aŭ reklamojn
abuse-report-spam-example = Ekzemplo: ĝi aldonas reklamojn al retejoj

abuse-report-settings-reason-v2 = Ĝi ŝanĝis mian serĉilon, ekan paĝon aŭ novajn langetojn sen sciigi aŭ pridemandi
abuse-report-settings-suggestions = Antaŭ ol denunci la etendaĵojn, vi povas provi ŝanĝi viajn agordojn:
abuse-report-settings-suggestions-search = Ŝanĝi viajn normajn serĉajn agordojn
abuse-report-settings-suggestions-homepage = Ŝanĝi vian ekan paĝon kaj novan langeton

abuse-report-deceptive-reason-v2 = Ĝi pretendas esti io alia
abuse-report-deceptive-example = Ekzemplo: priskribo aŭ bildoj trompaj

abuse-report-broken-reason-extension-v2 = Ĝi ne funkcias, misfunkciigas retejojn aŭ malrapidigas { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Ĝi ne funkcias kaj misfunkciigas la montradon de paĝoj
abuse-report-broken-example = Ekzemplo: trajtoj estas malrapidaj, malfacile uzeblaj aŭ ne funkcias; partoj de la retejoj ne ŝargiĝos aŭ aspektos strange
abuse-report-broken-suggestions-extension = Ŝajne vi ĵus trovis eraron. Krom tiu ĉi denunco, la plej bona maniero solvi problemon estas kontakti la programiston. <a data-l10n-name="support-link">Vizitu la retejon de la etendaĵo</a> por havi informon pri la programisto.
abuse-report-broken-suggestions-theme = Ŝajne vi ĵus trovis eraron. Krom tiu ĉi denunco, la plej bona maniero solvi problemon estas kontakti la programiston. <a data-l10n-name="support-link">Vizitu la retejon de la etoso</a> por havi informon pri la programisto.

abuse-report-policy-reason-v2 = Ĝi enhavas abomenan, perfortan aŭ kontraŭleĝan enhavon
abuse-report-policy-suggestions = Rimarko: kopirajtajn kaj varmarkajn aferojn oni devas denunci aparte. <a data-l10n-name="report-infringement-link">Uzu tiun ĉi instrukciojn</a> por denunci la problemon.

abuse-report-unwanted-reason-v2 = Mi neniam volis ĝin kaj mi ne scias kiel forigi ĝin
abuse-report-unwanted-example = Ekzemplo: programo instalis ĝin sen mia permeso

abuse-report-other-reason = Io alia

