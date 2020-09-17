# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Bu gwall wrth anfon yr adroddiad. Rhowch gynnig arall arni'n hwyrach.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Gwefan wedi'i thrwsio? Anfon adroddiad

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Llym
    .label = Llym
protections-popup-footer-protection-label-custom = Cyfaddas
    .label = Cyfaddas
protections-popup-footer-protection-label-standard = Safonol
    .label = Safonol

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Rhagor o wybodaeth am Ddiogelwch Rhag Tracio Uwch

protections-panel-etp-on-header = Mae Diogelwch Uwch Rhag Tracio YMLAEN ar y wefan hon
protections-panel-etp-off-header = Mae Diogelwch Uwch Rhag Tracio I FFWRDD ar y wefan hon

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Gwefan ddim yn gweithio?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Gwefan Ddim yn Gweithio?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Pam?
protections-panel-not-blocking-why-etp-on-tooltip = Gallai rhwystro'r rhain dorri elfennau o rai gwefannau. Heb dracwyr, efallai na fydd rhai botymau, ffurflenni a meysydd mewngofnodi'n gweithio.
protections-panel-not-blocking-why-etp-off-tooltip = Mae'r holl dracwyr ar y wefan hon wedi'u llwytho gan fod diogelu wedi'i ddiffodd.

##

protections-panel-no-trackers-found = Dim tracwyr hysbys i { -brand-short-name } wedi eu canfod ar y dudalen hon.

protections-panel-content-blocking-tracking-protection = Cynnwys Tracio

protections-panel-content-blocking-socialblock = Tracwyr Cyfryngau Cymdeithasol
protections-panel-content-blocking-cryptominers-label = Cryptogloddwyr
protections-panel-content-blocking-fingerprinters-label = Bysbrintwyr

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Rhwystrwyd
protections-panel-not-blocking-label = Caniatawyd
protections-panel-not-found-label = Heb Ganfod Dim

##

protections-panel-settings-label = Gosodiadau Diogelu

# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Bwrdd Gwaith Diogelwch

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Diffoddwch ddiogelu os rydych yn cael problemau gyda:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Meysydd mewngofnodi
protections-panel-site-not-working-view-issue-list-forms = Ffurflenni
protections-panel-site-not-working-view-issue-list-payments = Taliadau
protections-panel-site-not-working-view-issue-list-comments = Sylwadau
protections-panel-site-not-working-view-issue-list-videos = Fideos

protections-panel-site-not-working-view-send-report = Anfon adroddiad

##

protections-panel-cross-site-tracking-cookies = Mae'r cwcis hyn yn eich dilyn o wefan i wefan i gasglu data am yr hyn rydych chi'n ei wneud ar-lein. Maen nhw'n cael eu gosod gan drydydd partïon fel hysbysebwyr a chwmnïau dadansoddol.
protections-panel-cryptominers = Mae cryptogloddwyr yn defnyddio pŵer cyfrifiadurol eich system i gloddio arian digidol. Mae sgriptiau cryptogloddio yn gwagio eich batri, arafu eich cyfrifiadur, a gall gynyddu eich bil trydan.
protections-panel-fingerprinters = Mae bysbrintwyr yn casglu gosodiadau o'ch porwr a'ch cyfrifiadur i greu proffil ohonoch. Gan ddefnyddio'r olion bys digidol hwn, mae nhw'n gallu'ch tracio ar draws gwahanol wefannau.
protections-panel-tracking-content = Gall gwefannau lwytho hysbysebion allanol, fideos a chynnwys eraill sy'n cynnwys cod tracio. Gall rhwystro cynnwys tracio helpu gwefannau i lwytho'n gynt, ond efallai na fydd rhai botymau, ffurflenni a meysydd mewngofnodi'n gweithio.
protections-panel-social-media-trackers = Mae rhwydweithiau cymdeithasol yn gosod tracwyr ar wefannau eraill i ddilyn yr hyn rydych chi'n ei wneud, ei weld, a'i wylio ar-lein. Mae hyn yn caniatáu i gwmnïau cyfryngau cymdeithasol ddysgu mwy amdanoch chi y tu hwnt i'r hyn rydych chi'n ei rannu ar eich proffiliau cyfryngau cymdeithasol.

protections-panel-content-blocking-manage-settings =
    .label = Rheoli Gosodiadau Diogelu
    .accesskey = M

protections-panel-content-blocking-breakage-report-view =
    .title = Adrodd ar Wefan wedi Torri
protections-panel-content-blocking-breakage-report-view-description = Gall rhwystro cynnwys achosi problemau gyda rai gwefannau. Pan fyddwch yn cyflwyno adroddiad ar broblemau, byddwch yn helpu gwneud { -brand-short-name } yn well i bawb. (Bydd hyn yn anfon yr URL yn ogystal â gwybodaeth am osodiadau eich porwr i Mozilla. <label data-l10n-name="learn-more">Dysgu rhagor</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Dewisol: Disgrifiwch y broblem
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Dewisol: Disgrifiwch y broblem
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Diddymu
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Anfon Adroddiad
