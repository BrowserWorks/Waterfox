# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Aneqqis i { $addon-name }

abuse-report-title-extension = Mmel asiɣzef-a i { -vendor-short-name }
abuse-report-title-theme = Mmel asentel-a i { -vendor-short-name }
abuse-report-subtitle = D acu i d ugur?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = sɣur <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Ur tessineḍ ara ugur ara tferneḍ?
    <a data-l10n-name="learnmore-link">Issin ugar ɣef tummla n yisiɣzaf akked isental</a>

abuse-report-submit-description = Seglem ugur( d afrayan)
abuse-report-textarea =
    .placeholder = D ayen fessusen i nekni akken ad tazneḍ ugur ma nẓra talqayt. Ma ulac aɣilig, seglem-d ayen i twalaḍ. Tanemmirt imi i aɣ-d-muddeḍ yallelt ad neḥrez web s tezmert yelhan.
abuse-report-submit-note =
    Tamawt: Ur d-sedday ara talɣut tudmawant (am yisem, tansa, uṭṭun n tiliɣri, tansa n uxxam).
    { -vendor-short-name } ad yeḥrez akals imezgi n yineqqisen-a.

## Panel buttons.

abuse-report-cancel-button = Sefsex
abuse-report-next-button = Ɣer zdat
abuse-report-goback-button = Uɣal
abuse-report-submit-button = Azen

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Tummla n <span data-l10n-name="addon-name">{ $addon-name }</span> tefsex.
abuse-report-messagebar-submitting = Tuzna n uneqqis ɣef <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Tanmirt ɣef uneqqis id-tuzneḍ. Tebɣiḑ ad tekkseḍ <span data-l10n-name="addon-name">{ $addon-name }</span> ?
abuse-report-messagebar-submitted-noremove = Tanmirt ɣef uneqqis id-tuzneḍ.
abuse-report-messagebar-removed-extension = Tanmirt ɣef uneqqis id-tuzneḍ. Tekkseḍ asiɣzef <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Tanmirt ɣef uneqqis id-tuzneḍ. Tekkseḍ asentel <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Tella tucḍa deg uzzna n uneqqis i <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Aneqqis n <span data-l10n-name="addon-name">{ $addon-name }</span> ur yettwazen ara acku aneqqis nniḍen yettwazen melmi kan.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Ih, kkes-it
abuse-report-messagebar-action-keep-extension = Uhu, eǧǧ-it
abuse-report-messagebar-action-remove-theme = Ih, kkes-it
abuse-report-messagebar-action-keep-theme = Uhu eǧǧ-it
abuse-report-messagebar-action-retry = Ɛreḍ i tikelt-nniḍen
abuse-report-messagebar-action-cancel = Sefsex

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Isefka-iw neɣ aselkim-iw xeṣren
abuse-report-damage-example = Amedya: iger-d yir aseɣzan neɣ yuker isefka

abuse-report-spam-reason-v2 = Yegber aspam neɣ iger-d yir adellel
abuse-report-spam-example = Amedya: Sekcem adellel deg yisebtar web

abuse-report-settings-reason-v2 = Ibeddel amsedday-iw n unadi, asebter-iw agejdan neɣ iccer amaynut mebla ma yenna-yi-d neɣ isuter-iyi-d
abuse-report-settings-suggestions = Send ad temmleḍ asiɣzef, tzemreḍ ad tɛerḍeḍ ad tbeddleḍ iɣawwaṛen-ik:
abuse-report-settings-suggestions-search = Snifel iɣewwaṛen n  unadi amezwer
abuse-report-settings-suggestions-homepage = Snifel asebter agejdan akked yiccer amaynut

abuse-report-deceptive-reason-v2 = Ad d-yeqqar ayen ur yelli
abuse-report-deceptive-example = Amedya: aglam neɣ tugniwin n ukellex

abuse-report-broken-reason-extension-v2 = Ur iteddu ara, ittruzu ismal web, neɣ isaẓẓay { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Ur iteddu ara neɣ iseḥbes askan n yiminig
abuse-report-broken-example = Amedya: Timahilin ẓẓayit, yewɛer i useqdec, neɣ ur uleḥḥu ara; iḥricen n usmel web ur d-ttalin ara neɣ ur d-tt-banen ara am zik
abuse-report-broken-suggestions-extension =
    Ittban d akken yufiḍ-d abug. Ɣer tama n tuzna n uneqqis dagi, abrid ufrin
    akken ad tefruḍ ugur n tmahilt, d anermes n uneflay n usiɣzef.
    <a data-l10n-name="support-link">Rzu ɣer usmel n usiɣzef</a> akken ad tawiḍ talɣut ɣef uneflay.
abuse-report-broken-suggestions-theme =
    Ittban d akken yufiḍ-d abug. Ɣer tama n tuzna n uneqqis dagi, abrid ufrin
    akken ad tefruḍ ugur n tmahilt, d anermes n uneflay n usentel.
    <a data-l10n-name="support-link">Rzu ɣer usmel n usentel</a> akken ad tawiḍ talɣut ɣef uneflay.

abuse-report-policy-reason-v2 = Igber agdbur n kaṛuh, n tekriḍt neɣ arusḍif
abuse-report-policy-suggestions =
    Tamawt: Uguren n yizerfan n umeskar akked ticraḍ ilaq ad d-ttwammlen deg ukal yemgaraden.
    <a data-l10n-name="report-infringement-link">Seqdec iwellihen-a</a> akken
    ad d-temmleḍ ugur.

abuse-report-unwanted-reason-v2 = Ur ǧǧin bɣiɣ daɣen ur ẓriɣ ara amek ara tekkseɣ
abuse-report-unwanted-example = Amedya: asnas isbedd-it mebla tasiregt

abuse-report-other-reason = Ayen nniḍen

