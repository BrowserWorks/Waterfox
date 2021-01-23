# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Rozpšawa za { $addon-name }

abuse-report-title-extension = { -vendor-short-name } toś to rozšyrjenje k wěsći daś
abuse-report-title-theme = { -vendor-short-name } toś tu drastwu k wěsći daś
abuse-report-subtitle = Kótary jo problem?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = wót <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Sćo se njewěsty, kótary problem maśo wubraś?
    <a data-l10n-name="learnmore-link">Zgóńśo wěcej wó zdźělenju rozšyrjenjow a drastwow</a>

abuse-report-submit-description = Wopišćo problem (na žycenje)
abuse-report-textarea =
    .placeholder = Jo lóžčej za nas, se problemoju wěnowaś, gaž drobnostki mamy. Pšosym wopišćo, na což sćo starcył. Źěkujomy se wam, až nam pomagaśo, web strowy źaržaś.
abuse-report-submit-note =
    Glědajśo: Njezapśimujśo pšosym wósobińske informacije (na psikład mě, e-mailowu adresu, telefonowy numer, bydleńsku adresu).
    { -vendor-short-name } trajnu kopiju toś tych rozpšawow wobchowujo.

## Panel buttons.

abuse-report-cancel-button = Pśetergnuś
abuse-report-next-button = Dalej
abuse-report-goback-button = Slědk
abuse-report-submit-button = Wótpósłaś

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Rozpšawa za <span data-l10n-name="addon-name">{ $addon-name }</span> jo se pśetergnuła.
abuse-report-messagebar-submitting = Rozpšawa za <span data-l10n-name="addon-name">{ $addon-name }</span> se sćelo.
abuse-report-messagebar-submitted = Źěkujomy se, až sćo pósłał rozpšawu. Cośo <span data-l10n-name="addon-name">{ $addon-name }</span> wótwónoźeś?
abuse-report-messagebar-submitted-noremove = Źěkujomy se, až sćo pósłał rozpšawu.
abuse-report-messagebar-removed-extension = Źěkujomy se, až sćo pósłał rozpšawu. Sćo wótwónoźeł rozšyěrjenje <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Źěkujomy se, až sćo pósłał rozpšawu. Sćo wótwónoźeł drastwu <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Zmólka pśi słanju rozpšawy za <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Rozpšawa za <span data-l10n-name="addon-name">{ $addon-name }</span> njejo se pósłała, dokulaž jo se druga rozpšawa njedawno wótpósłała.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Jo, wótwónoźeś
abuse-report-messagebar-action-keep-extension = Ně, wobchowaś
abuse-report-messagebar-action-remove-theme = Jo, wótwónoźeś
abuse-report-messagebar-action-keep-theme = Ně, wobchowaś
abuse-report-messagebar-action-retry = Hyšći raz wopytaś
abuse-report-messagebar-action-cancel = Pśetergnuś

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Jo wobškóźił mójo licadło abo wobgrozył móje daty
abuse-report-damage-example = Pśikład: Zašćěpjona škódna softwara abo wukšadnjone daty

abuse-report-spam-reason-v2 = Wopśimujo spam abo zasajźujo njewitane wabjenje
abuse-report-spam-example = Pśikład: wabjenje na webbokach zasajźiś

abuse-report-settings-reason-v2 = Jo móju pytnicu, startowy bok abo nowy rejtarik změniło, bźeztogo aby mě informěrowało abo se mě pšašało
abuse-report-settings-suggestions = Nježli až rozšyrjenje k wěsći dajosó, móžośo wopytaś, swóje nastajenja změniś:
abuse-report-settings-suggestions-search = Změńśo swóje standardne pytańske nastajenja
abuse-report-settings-suggestions-homepage = Změńśo swój startowy bok a nowy rejtarik

abuse-report-deceptive-reason-v2 = Twjerźi, až to njejo
abuse-report-deceptive-example = Pśikład: Torjece wopisanje abo wobraznosć

abuse-report-broken-reason-extension-v2 = Njefunkcioněrujo, wobškóźujo websedła abo spómałšujo { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Njefunkcioněrujo abo wobškóźujo zwobraznjenje wobglědowaka
abuse-report-broken-example = Pśikład: Funkcije su pomałe, śěžko wužywajobne abo njefunkcioněruju; źěle websedła se njezacytaju abo wuglědaju njewšedne
abuse-report-broken-suggestions-extension = Zda se, zo sćo identificěrował zmólku. Mimo až móžośo rozpšawu wótpósłaś, stajśo se nejlěpjej z wuwijarjom rozšyrjenja do zwiska, aby problem z funkcionalnosću rozwězał. <a data-l10n-name="support-link">Woglědajśo se k websedłoju rozšyrjenja</a>, aby se informacije wó wuwijarju wobstarał.
abuse-report-broken-suggestions-theme = Zda se, zo sćo identificěrował zmólku. Mimo až móžośo rozpšawu wótpósłaś, stajśo se nejlěpjej z wuwijarjom drastwy do zwiska, aby problem z funkcionalnosću rozwězał. <a data-l10n-name="support-link">Woglědajśo se k websedłoju drastwy</a>, aby se informacije wó wuwijarju wobstarał.

abuse-report-policy-reason-v2 = Wopśimujo gramoty połne, namócne abo ilegalne wopśimjeśe
abuse-report-policy-suggestions = Glědajśo: Problemy z awtorstwom a wikowym znamjenim muse se na drugi nałog k wěsći daś. <a data-l10n-name="report-infringement-link">Mějśo se pó toś tych instrukcijach</a>, aby problem k wěsći dał.

abuse-report-unwanted-reason-v2 = Njejsom to nigda kśěł a njewěm, kak mógu to wótbyś
abuse-report-unwanted-example = Pśikład: Nałoženje jo jo zainstalěrowało bźez dowólnosći

abuse-report-other-reason = Něco druge

