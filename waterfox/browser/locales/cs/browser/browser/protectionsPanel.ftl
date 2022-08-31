# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Při odesílání hlášení nastala chyba. Zkuste to prosím později.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Stránka začala fungovat? Pošlete hlášení

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Přísná
    .label = Přísná
protections-popup-footer-protection-label-custom = Vlastní
    .label = Vlastní
protections-popup-footer-protection-label-standard = Standardní
    .label = Standardní

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Více informací o rozšířené ochraně proti sledování

protections-panel-etp-on-header = Rozšířená ochrana proti sledování je zapnuta
protections-panel-etp-off-header = Rozšířená ochrana proti sledování je vypnuta

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Stránka nefunguje?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Stránka nefunguje?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Proč?
protections-panel-not-blocking-why-etp-on-tooltip = Blokování těchto prvků může ovlivnit fungování webové stránky. Bez sledovacích prvků nemusí některá tlačítka nebo formuláře správně fungovat.
protections-panel-not-blocking-why-etp-off-tooltip = Všechny sledovací prvky na této stránce byly načteny, protože ochrana proti sledování je vypnutá.

##

protections-panel-no-trackers-found =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } na této stránce nenalezl
        [feminine] { -brand-short-name } na této stránce nenalezla
        [neuter] { -brand-short-name } na této stránce nenalezlo
       *[other] Aplikace { -brand-short-name } na této stránce nenalezla
    } žádné známé sledovací prvky.

protections-panel-content-blocking-tracking-protection = Sledující obsah

protections-panel-content-blocking-socialblock = Sledující prvky sociálních sítí
protections-panel-content-blocking-cryptominers-label = Těžba kryptoměn
protections-panel-content-blocking-fingerprinters-label = Otisk prohlížeče

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Zablokováno
protections-panel-not-blocking-label = Povoleno
protections-panel-not-found-label = Nenalezeno

##

protections-panel-settings-label = Nastavení ochrany
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Přehled ochrany soukromí

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Vypněte ochranu proti sledování pokud pozorujete problémy s:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = přihlášením
protections-panel-site-not-working-view-issue-list-forms = fungováním formulářů
protections-panel-site-not-working-view-issue-list-payments = platbami
protections-panel-site-not-working-view-issue-list-comments = psaním komentářů
protections-panel-site-not-working-view-issue-list-videos = přehráváním videí

protections-panel-site-not-working-view-send-report = Poslat hlášení

##

protections-panel-cross-site-tracking-cookies = Tyto cookies slouží k vašemu sledování napříč webovými stránkami a sběru dat o tom, co na internetu děláte. Používají je třetí strany jako jsou reklamní systémy nebo analytické společnosti.
protections-panel-cryptominers = Těžba kryptoměn využívá výpočetní výkon vašeho počítače k získávání digitálních měn. Běžící skripty vybíjí vaši baterii a zpomalují váš počítač.
protections-panel-fingerprinters = Sběrem informací o vašem prohlížeči a počítači lze vytvořit unikátní otisk a ten pak použít k vašemu sledování napříč různými a nijak nesouvisejícími servery a webovými stránkami.
protections-panel-tracking-content = Webové stránky mohou načítat externí reklamy, videa a další obsah, který obsahuje sledovací kód. Po zablokování sledujícího obsahu se stránky načítají rychleji, ale některá tlačítka nebo formuláře nemusí správně fungovat.
protections-panel-social-media-trackers = Sociální sítě umisťují na ostatní stránky sledovací prvky, pomocí kterých mohou sledovat, co na internetu děláte, vidíte a co si pouštíte. To umožňuje společnostem, které tato sociální média vlastní, dozvědět se o vás víc než jen to, co sdílíte na svých profilech.

protections-panel-description-shim-allowed = Některé níže označené sledovací prvky byly na této stránce částečně povoleny, protože jste s nimi interagovali.
protections-panel-description-shim-allowed-learn-more = Zjistit více
protections-panel-shim-allowed-indicator =
    .tooltiptext = Sledovací prvky částečně povoleny

protections-panel-content-blocking-manage-settings =
    .label = Nastavení ochrany
    .accesskey = N

protections-panel-content-blocking-breakage-report-view =
    .title = Nahlásit nefunkční stránku
protections-panel-content-blocking-breakage-report-view-description =
    Blokování sledovacích prvků může na některých stránkách způsobovat problémy. Jejich nahlášením významně pomůžete { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } dále vylepšovat. S vaším hlášením se Mozille odešle URL stránky a informace o vašem nastavení blokování obsahu. <label data-l10n-name="learn-more">Zjistit více</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Popis problému (nepovinné)
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Popis problému (nepovinné)
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Zrušit
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Odeslat hlášení
