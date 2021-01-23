# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = { $addon-name } gehigarrirako txostena

abuse-report-title-extension = Salatu hedapen hau { -vendor-short-name }(r)i
abuse-report-title-theme = Salatu itxura hau { -vendor-short-name }(r)i
abuse-report-subtitle = Zein da arazoa?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = egilea: <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Ez zaude ziur zein arazo hautatu?
    <a data-l10n-name="learnmore-link">Hedapen eta itxurak salatzeko argibide gehiago</a>

abuse-report-submit-description = Azaldu arazoa (aukerakoa)
abuse-report-textarea =
    .placeholder = Guretzat errazagoa da arazoari irtenbidea ematea datu zehatzak baditugu. Azaldu mesedez zein den izan duzun arazoa. Eskerrik asko weba osasuntsu mantentzen laguntzeagatik.
abuse-report-submit-note = Oharra: ez sartu informazio pertsonalik (adib. izena, helbide elektronikoa, telefono zenbakia, helbide fisikoa). { -vendor-short-name }(e)k salaketa hauen erregistro iraunkorra mantentzen du.

## Panel buttons.

abuse-report-cancel-button = Utzi
abuse-report-next-button = Hurrengoa
abuse-report-goback-button = Joan atzera
abuse-report-submit-button = Bidali

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Bertan behera utzi da <span data-l10n-name="addon-name">{ $addon-name }</span> gehigarrirako salaketa.
abuse-report-messagebar-submitting = Salaketa bidaltzen <span data-l10n-name="addon-name">{ $addon-name }</span> gehigarrirako.
abuse-report-messagebar-submitted = Eskerrik asko salaketa bidaltzeagatik. <span data-l10n-name="addon-name">{ $addon-name }</span> gehigarria kendu egin nahi duzu?
abuse-report-messagebar-submitted-noremove = Eskerrik asko salaketa bidaltzeagatik.
abuse-report-messagebar-removed-extension = Eskerrik asko salaketa bidaltzeagatik. <span data-l10n-name="addon-name">{ $addon-name }</span> hedapena kendu egin duzu.
abuse-report-messagebar-removed-theme = Eskerrik asko salaketa bidaltzeagatik. <span data-l10n-name="addon-name">{ $addon-name }</span> itxura kendu egin duzu.
abuse-report-messagebar-error = Errorea gertatu da <span data-l10n-name="addon-name">{ $addon-name }</span> gehigarrirako salaketa bidaltzerakoan.
abuse-report-messagebar-error-recent-submit = <span data-l10n-name="addon-name">{ $addon-name }</span> gehigarrirako salaketa ez da bidali orain dela gutxi beste salaketa bat bidali delako.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Bai, kendu
abuse-report-messagebar-action-keep-extension = Ez, mantendu
abuse-report-messagebar-action-remove-theme = Bai, kendu
abuse-report-messagebar-action-keep-theme = Ez, mantendu
abuse-report-messagebar-action-retry = Saiatu berriro
abuse-report-messagebar-action-cancel = Utzi

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Nire ordenagailua kaltetu du edo nire datuak arriskuan jarri ditu
abuse-report-damage-example = Adibidea: malwarea txertatu du edo datuak lapurtu ditu

abuse-report-spam-reason-v2 = Spama du edo nahi ez ditudan iragarkiak ditu
abuse-report-spam-example = Adibidea: iragarkiak txertatzen ditu webguneetan

abuse-report-settings-reason-v2 = Nire bilaketa-motorra, hasiera-orria edo fitxa berria aldatu ditu galdetu gabe eta onespenik gabe
abuse-report-settings-suggestions = Hedapena salatu aurretik, zure ezarpenak aldatzen saia zaitezke:
abuse-report-settings-suggestions-search = Aldatu zure bilaketa-ezarpen lehenetsiak
abuse-report-settings-suggestions-homepage = Aldatu zure hasiera-orria eta fitxa berria

abuse-report-deceptive-reason-v2 = Benetan ez den zerbait izaten saiatu da
abuse-report-deceptive-example = Adibidea: gezurretako azalpen edo iruditeria

abuse-report-broken-reason-extension-v2 = Ez dabil, webguneak apurtzen ditu edo { -brand-product-name } moteltzen du
abuse-report-broken-reason-theme-v2 = Ez dabil edo nabigatzailearen bistaratzea apurtzen du
abuse-report-broken-example = Adibidea: eginbideak makalak edo erabiltzeko zailak dira, edo ez dabil; webguneetako zatiak ez dabiltza edo ezohikoak dirudite
abuse-report-broken-suggestions-extension = Badirudi programa-errore bat aurkitu duzula. Hemen bertan horren berri emateaz gain, arazoa konpontzeko biderik onena zuzenean hedapenaren garatzailearekin harremanetan jartzea da. Garatzaileari buruzko informazioa eskuratzeko, <a data-l10n-name="support-link">bisitatu hedapenaren webgunea</a>.
abuse-report-broken-suggestions-theme = Badirudi programa-errore bat aurkitu duzula. Hemen bertan horren berri emateaz gain, arazoa konpontzeko biderik onena zuzenean itxuraren garatzailearekin harremanetan jartzea da. Garatzaileari buruzko informazioa eskuratzeko, <a data-l10n-name="support-link">bisitatu itxuraren webgunea</a>.

abuse-report-policy-reason-v2 = Eduki gaitzesgarria, indarkeriazkoa edo ilegala du
abuse-report-policy-suggestions = Oharra: Copyright eta marka erregistratuei buruzko arazoak aparteko prozesu batean salatu behar dira. Arazoaren berri emateko, <a data-l10n-name="report-infringement-link">erabili jarraibide hauek</a>.

abuse-report-unwanted-reason-v2 = Inoiz ez dut nahi izan eta ez dakit nola gainetik kendu
abuse-report-unwanted-example = Adibidea: aplikazio batek nire baimenik gabe instalatu du

abuse-report-other-reason = Beste zerbait

