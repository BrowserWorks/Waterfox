# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Raportti lisäosasta { $addon-name }

abuse-report-title-extension = Raportoi tämä laajennus { -vendor-short-name }lle
abuse-report-title-theme = Raportoi tämä teema { -vendor-short-name }lle
abuse-report-subtitle = Mikä on ongelmana?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = tekijä <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Oletko epävarma, mikä ongelmista tulee valita?
    <a data-l10n-name="learnmore-link">Lue lisää laajennusten ja teemojen raportoinnista</a>

abuse-report-submit-description = Kuvaa ongelma (valinnainen)
abuse-report-textarea =
    .placeholder = Jos kerrot tarkemmin kohtaamastasi ongelmasta, pystymme helpommin paikantamaan sen. Kerro vapaamuotoisesti, mitä olet huomannut. Kiitos, kun autat meitä pitämään verkon turvallisena.
abuse-report-submit-note =
    Huomio: Älä kirjoita henkilökohtaisia tietoja, kuten nimiä, sähköpostiosoitteita, puhelinnumeroita tai postiosoitteita.
    { -vendor-short-name } säilyttää raportit pysyvästi.

## Panel buttons.

abuse-report-cancel-button = Peruuta
abuse-report-next-button = Seuraava
abuse-report-goback-button = Takaisin
abuse-report-submit-button = Lähetä

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Raportti lisäosasta <span data-l10n-name="addon-name">{ $addon-name }</span> on peruttu.
abuse-report-messagebar-submitting = Lähetetään raportti lisäosasta <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Kiitos kun lähetit raportin. Haluatko poistaa lisäosan <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Kiitos kun lähetit raportin.
abuse-report-messagebar-removed-extension = Kiitos kun lähetit raportin. Poistit laajennuksen <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Kiitos kun lähetit raportin. Poistit teeman <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Raportin lähettäminen lisäosasta <span data-l10n-name="addon-name">{ $addon-name }</span> epäonnistui.
abuse-report-messagebar-error-recent-submit = Raporttia lisäosasta <span data-l10n-name="addon-name">{ $addon-name }</span> ei lähetetty, koska toinen raportti lähetettiin äskettäin.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Kyllä, poista se
abuse-report-messagebar-action-keep-extension = Ei, säilytä se
abuse-report-messagebar-action-remove-theme = Kyllä, poista se
abuse-report-messagebar-action-keep-theme = Ei, säilytä se
abuse-report-messagebar-action-retry = Yritä uudelleen
abuse-report-messagebar-action-cancel = Peruuta

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Se vahingoitti tietokonettani tai vaaransi tietoni
abuse-report-damage-example = Esimerkki: syötti haittaohjelmia tai varasti tietoja

abuse-report-spam-reason-v2 = Se sisältää roskapostia tai sisällyttää ei-haluttua mainontaa
abuse-report-spam-example = Esimerkki: lisää mainoksia verkkosivuille

abuse-report-settings-reason-v2 = Se muutti hakukoneeni, aloitussivuni tai uuden välilehden sisällön kertomatta minulle tai kysymättä minulta
abuse-report-settings-suggestions = Ennen kuin raportoit laajennuksesta, voit yrittää muuttaa asetuksia:
abuse-report-settings-suggestions-search = Muuta haun oletusasetuksia
abuse-report-settings-suggestions-homepage = Muuta aloitussivua tai uutta välilehteä

abuse-report-deceptive-reason-v2 = Se väittää olevansa jotain mitä se ei ole
abuse-report-deceptive-example = Esimerkki: Harhaanjohtava kuvaus tai kuvitus

abuse-report-broken-reason-extension-v2 = Se ei toimi, se rikkoo verkkosivustojen esitystavan tai se hidastaa { -brand-product-name }ia
abuse-report-broken-reason-theme-v2 = Se ei toimi tai se rikkoo selaimen esitystavan
abuse-report-broken-example = Esimerkki: ominaisuudet ovat hitaita, vaikeakäyttöisiä tai eivät toimi; osa sivuista ei lataudu tai ne näyttävät kummallisilta
abuse-report-broken-suggestions-extension =
    Vaikuttaa siltä, että löysit ohjelmistovirheen. Tämän raportin lähettämisen lisäksi paras
    tapa saada toiminnallisuusongelma selvitettyä on olla yhteydessä laajennuksen kehittäjään.
    <a data-l10n-name="support-link">Käy laajennuksen sivulla</a> nähdäksesi kehittäjän tiedot.
abuse-report-broken-suggestions-theme =
    Vaikuttaa siltä, että löysit ohjelmistovirheen. Tämän raportin lähettämisen lisäksi paras
    tapa saada toiminnallisuusongelma selvitettyä on olla yhteydessä teeman kehittäjään.
    <a data-l10n-name="support-link">Käy teeman sivulla</a> nähdäksesi kehittäjän tiedot.

abuse-report-policy-reason-v2 = Se sisältää vihantäyteistä, väkivaltaista tai laitonta sisältöä
abuse-report-policy-suggestions =
    Huomio: Tekijänoikeus- ja tavaramerkkiongelmat tulee raportoida eri tavalla.
    Raportoi ongelma <a data-l10n-name="report-infringement-link">näiden ohjeiden mukaisesti</a>.

abuse-report-unwanted-reason-v2 = En koskaan halunnut sitä, enkä tiedä miten pääsen siitä eroon
abuse-report-unwanted-example = Esimerkki: sovellus asensi sen ilman lupaani

abuse-report-other-reason = Jotain muuta

