# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = გაასაჩივრეთ { $addon-name }

abuse-report-title-extension = საჩივარს ამ გაფართოების შესახებ გაეცნობა { -vendor-short-name }
abuse-report-title-theme = საჩივარს, ამ თემის შესახებ გაეცნობა { -vendor-short-name }
abuse-report-subtitle = რას ეხება საქმე?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = შემქმნელი <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    ზუსტად არ იცით რა უნდა მიუთითოთ?
    <a data-l10n-name="learnmore-link">იხილეთ ვრცლად, გაფართოებებისა და თემების შესახებ საჩივრის გაგზავნაზე</a>

abuse-report-submit-description = აღწერეთ საკითხი (არასავალდებულო)
abuse-report-textarea =
    .placeholder = დაწვრილებითი ინფორმაცია გვეხმარება ხარვეზის გამორკვევაში. გთხოვთ, აღწეროთ რა დაბრკოლებას გადააწყდით. გმადლობთ, რომ გვეხმარებით ვებსივრცის სიჯანსაღის შენარჩუნებაში.
abuse-report-submit-note =
    შენიშვნა: ნუ მიუთითებთ პირად მონაცემებს (სახელს, ელფოსტას, სატელეფონო ნომერს, სახლის მისამართს).
    { -vendor-short-name } სამუდამოდ ინახავს ამ საჩივრების შესახებ ჩანაწერებს.

## Panel buttons.

abuse-report-cancel-button = გაუქმება
abuse-report-next-button = შემდეგ
abuse-report-goback-button = უკან
abuse-report-submit-button = გაგზავნა

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = საჩივარი გაფართოებაზე <span data-l10n-name="addon-name">{ $addon-name }</span> გაუქმებულია.
abuse-report-messagebar-submitting = იგზავნება საჩივარი გაფართოებაზე <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = გმადლობთ საჩივრის გამოგზავნისთვის. გსურთ, წაიშალოს <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = გმადლობთ, საჩივრის გამოგზავნისთვის.
abuse-report-messagebar-removed-extension = გმადლობთ საჩივრის გამოგზავნისთვის. გაფართოება <span data-l10n-name="addon-name">{ $addon-name }</span> წაიშალა.
abuse-report-messagebar-removed-theme = გმადლობთ საჩივრის გამოგზავნისთვის. თემა <span data-l10n-name="addon-name">{ $addon-name }</span> წაიშალა.
abuse-report-messagebar-error = შეცდომა საჩივრის გაგზავნისას გაფართოებაზე <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = საჩივარი გაფართოებაზე <span data-l10n-name="addon-name">{ $addon-name }</span> არ გაიგზავნა, ვინაიდან უკვე წარდგენილია სხვა საჩივარი.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = დიახ, მოცილდეს
abuse-report-messagebar-action-keep-extension = არა, დარჩეს
abuse-report-messagebar-action-remove-theme = დიახ, მოცილდეს
abuse-report-messagebar-action-keep-theme = არა, დარჩეს
abuse-report-messagebar-action-retry = გამეორება
abuse-report-messagebar-action-cancel = გაუქმება

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = დააზიანა ჩემი კომპიუტერი და მოიპარა ჩემი მონაცემები
abuse-report-damage-example = მაგალითად: დააყენა მავნე პროგრამა ან მოიპარა მონაცემები

abuse-report-spam-reason-v2 = შეიცავს ჯართს ან ამატებს არასასურველ რეკლამებს
abuse-report-spam-example = მაგალითად: ათავსებს რეკლამებს ვებგვერდებზე

abuse-report-settings-reason-v2 = შეცვალა ჩემი საძიებო სისტემა, საწყისი გვერდი ან ახალი ჩანართი უნებართვოდ
abuse-report-settings-suggestions = მოხსენების გამოგზავნამდე, შეგიძლიათ სცადოთ პარამეტრების შეცვლა:
abuse-report-settings-suggestions-search = ცვლის თქვენს ნაგულისხმევ საძიებო სისტემას
abuse-report-settings-suggestions-homepage = ცვლის თქვენს საწყის გვერდს და ახალ ჩანართს

abuse-report-deceptive-reason-v2 = თავს სხვა რამედ ასაღებს
abuse-report-deceptive-example = მაგალითად: შემაცდენელი აღწერა ან სურათები

abuse-report-broken-reason-extension-v2 = არ იმუშავა, დააზიანა ვებსაიტები ან შეანელა { -brand-product-name }
abuse-report-broken-reason-theme-v2 = არ მუშაობს ან აზიანებს ბრაუზერის გამოსახულებას
abuse-report-broken-example = მაგალითად: შესაძლებლობები ნელია, რთული გამოსაყენებელია ან არ მუშაობს; საიტების ნაწილი არ იტვირთება ან უჩვეულოდ გამოიყურება
abuse-report-broken-suggestions-extension =
    როგორც ჩანს, თქვენ აღმოაჩინეთ ხარვეზი. აქ გამოგზავნილი მოხსენების გარდა, კარგი იქნება, თუ მუშაობასთან დაკავშირებული საკითხების მოსაგვარებლად, თავად გაფართოების შემმუშავებელს დაუკავშირდებით.
    <a data-l10n-name="support-link">ეწვიეთ გაფართოების ვებსაიტს</a> შემმუშავებელთან დასაკავშირებლად.
abuse-report-broken-suggestions-theme =
    როგორც ჩანს, თქვენ აღმოაჩინეთ ხარვეზი. აქ გამოგზავნილი მოხსენების გარდა, კარგი იქნება, თუ მუშაობასთან
    დაკავშირებული საკითხების მოსაგვარებლად, თავად თემის შემმუშავებელს დაუკავშირდებით.
    <a data-l10n-name="support-link">ეწვიეთ თემის ვებსაიტს</a> შემმუშავებელთან დასაკავშირებლად.

abuse-report-policy-reason-v2 = სიძულვილის, ძალადობის ან უკანონობის შემცველია
abuse-report-policy-suggestions =
    შენიშვნა: საავტორო უფლებებისა და სავაჭრო ნიშნების დარღვევების შესახებ, მოხსენებები ცალკე უნდა გამოიგზავნოს.
    <a data-l10n-name="report-infringement-link">ისარგებლეთ ამ მითითებებით</a>
    ხარვეზის მოხსენებისთვის.

abuse-report-unwanted-reason-v2 = არასოდეს მდომებია და არ ვიცი როგორ მოვიცილო
abuse-report-unwanted-example = მაგალითად: პროგრამა თავისით ჩაიდგა უნებართვოდ

abuse-report-other-reason = სხვა

