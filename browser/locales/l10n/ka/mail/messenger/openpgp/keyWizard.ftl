# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = პირადი OpenPGP-გასაღების დამატება { $identity }-ისთვის
key-wizard-button =
    .buttonlabelaccept = განაგრძეთ
    .buttonlabelhelp = უკან დაბრუნება
key-wizard-warning = <b>თუ გაქვთ არსებული პირადი გასაღები</b> ამ ელფოსტისთვის, გადმოიტანეთ. სხვა შემთხვევაში წვდომას ვერ გექნებათ, თქვენს დაარქივებულ დაშიფრულ წერილებზე და ვერც მიღებულ დაშიფრულ წერილებს წაიკითხავთ იმ ხალხისგან, რომლებიც ჯერ კიდევ არსებულ გასაღებს იყენებენ.
key-wizard-learn-more = ვრცლად
radio-create-key =
    .label = შექმენით ახალი OpenPGP-გასაღები
    .accesskey = შ
radio-import-key =
    .label = გადმოიტანეთ არსებული OpenPGP-გასაღები
    .accesskey = ტ
radio-gnupg-key =
    .label = გამოიყენეთ გარეშე გასაღები GnuPG-ით (მაგ. სმარტბარათიდან)
    .accesskey = ყ

## Generate key section

openpgp-generate-key-title = OpenPGP-გასაღების შედგენა
openpgp-generate-key-info = <b>გასაღების შედგენა რამდენიმე წუთს გასტანს.</b> არ გამოხვიდეთ პროგრამიდან, შედგენის მიმდინარეობისას. გვერდების ხშირი მონახულება და დისკზე დამტვირთავი მოქმედებები გასაღების შედგენისას, ზრდის შემთხვევით კომბინაციებს და ასწრაფებს ამ საქმის შესრულებას. გეცნობებათ, როცა გასაღების შედგენა დასრულდება.
openpgp-keygen-expiry-title = გასაღების ვადა
openpgp-keygen-expiry-description = განსაზღვრეთ ახლად შედგენილი გასაღების ვადა. მომავალშიც შეძლებთ ვადის გახანგრძლივებას, თუ დაგჭირდათ.
radio-keygen-expiry =
    .label = გასაღებს ვადა გაუვა
    .accesskey = ვ
radio-keygen-no-expiry =
    .label = გასაღები უვადოა
    .accesskey = უ
openpgp-keygen-days-label =
    .label = დღეში
openpgp-keygen-months-label =
    .label = თვეში
openpgp-keygen-years-label =
    .label = წელიწადში
openpgp-keygen-advanced-title = გაფართოებული პარამეტრები
openpgp-keygen-advanced-description = გამართეთ გაფართოებული პარამეტრები OpenPGP-გასაღების.
openpgp-keygen-keytype =
    .value = გასაღების სახეობა:
    .accesskey = ხ
openpgp-keygen-keysize =
    .value = გასაღების ზომა
    .accesskey = ზ
openpgp-keygen-type-rsa =
    .label = RSA
openpgp-keygen-type-ecc =
    .label = ECC (ელიფსური მრუდი)
openpgp-keygen-button = გასაღების შედგენა
openpgp-keygen-progress-title = იქმნება თქვენი ახალი OpenPGP-გასაღები…
openpgp-keygen-import-progress-title = გადმოდის თქვენი OpenPGP-გასაღებები…
openpgp-import-success = OpenPGP გადმოტანილია წარმატებით!
openpgp-import-success-title = გადმოტანის დასრულება
openpgp-import-success-description = გადმოტანილი OpenPGP-გასაღების გამოსაყენებლად ელფოსტის დაშიფვრისთვის, დახურეთ ეს ფანჯარა და გადადით ანგარიშის პარამეტრებში.
openpgp-keygen-confirm =
    .label = დადასტურება
openpgp-keygen-dismiss =
    .label = გაუქმება
openpgp-keygen-cancel =
    .label = გაუქმების მიმდინარეობა…
openpgp-keygen-import-complete =
    .label = დახურვა
    .accesskey = დ
openpgp-keygen-missing-username = სახელი არაა მითითებული ამ ანგარიშისთვის. გთხოვთ, შეიყვანოთ მნიშვნელობა ველში  „თქვენი სახელი“ ანგარიშის პარამეტრებიდან.
openpgp-keygen-long-expiry = შეუძლებელია გასაღების შექმნა, 100 წელზე მეტი ვადით.
openpgp-keygen-short-expiry = თქვენი გასაღების ვადა, ერთ დღეზე არანაკლები უნდა იყოს.
openpgp-keygen-ongoing = გასაღების შედგენა უკვე მიმდინარეობს!
openpgp-keygen-error-core = ვერ ეშვება OpenPGP-ის ძირითადი მომსახურება
openpgp-keygen-error-failed = OpenPGP-გასაღების შედგენა მოულოდნელად შეწყდა
#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = OpenPGP-გასაღები შეიქმნა წარმატებით, მაგრამ ვერ გაუქმდა გასაღები { $key }
openpgp-keygen-abort-title = შეწყდეს გასაღების შედგენა?
openpgp-keygen-abort = OpenPGP-გასაღების შედგენა მიმდინარეობს, ნამდვილად გსურთ გაუქმება?
#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = გსურთ შედგენა საჯარო და საიდუმლო გასაღების ანგარიშისთვის { $identity }?

## Import Key section

openpgp-import-key-title = გადმოიტანეთ არსებული პირადი OpenPGP-გასაღები
openpgp-import-key-legend = აირჩიეთ ადრე დამარქაფებული ფაილი.
openpgp-import-key-description = შეგიძლიათ გადმოიტანოთ პირადი გასაღებები, რომლებიც სხვა OpenPGP-პროგრამითაა შექმნილი.
openpgp-import-key-info = სხვა პროგრამაში, პირად გასაღებს განსხვავებულად შეიძლება ერქვას, კუთვნილი გასაღები, საიდუმლო გასაღები, კერძო გასაღები ან გასაღების წყვილი.
#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird-მა იპოვა გასაღები, რომლის გადმოტანაც შეიძლება.
       *[other] Thunderbird-მა იპოვა { $count } გასაღები, რომელთა გადმოტანაც შეიძლება.
    }
openpgp-import-key-list-description = დაამოწმეთ, რომელი გასაღებები შეიძლება ჩაითვალოს თქვენს პირად გასაღებებად. მხოლოდ თქვენ მიერ შექმნილი და რომლებიც, თქვენს ვინაობას აჩვენებს, გამოდგება პირად გასაღებებად. მომავალშიც შეგეძლებათ შეცვლა, გასაღების პარამეტრების ფანჯრიდან.
openpgp-import-key-list-caption = გასაღებები, მონიშნული პირად გასაღებებად, აღიწერება გამჭოლი დაშიფვრის განყოფილებაში. დანარჩენები ხელმისაწვდომი იქნება გასაღებების მმართველში.
openpgp-passphrase-prompt-title = საჭიროა საიდუმლო ფრაზა
#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = შეიყვანეთ საიდუმლო ფრაზა, რომ გაიხსნას გასაღები: { $key }
openpgp-import-key-button =
    .label = ფაილის არჩევა გადმოსატანად…
    .accesskey = ტ
import-key-file = OpenPGP-გასაღების ფაილის შეტანა
import-key-personal-checkbox =
    .label = გასაღების პირად გასაღებად განსაზღვრა
gnupg-file = GnuPG-ფაილები
import-error-file-size = <b>შეცდომა!</b> 5MB-ზე დიდი ფაილები არაა მხარდაჭერილი.
#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>შეცდომა!</b> ვერ მოხერხდა ფაილის შემოტანა. { $error }
#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>შეცდომა!</b> ვერ მოხერხდა გასაღებების შემოტანა. { $error }
openpgp-import-identity-label = მოწმობა
openpgp-import-fingerprint-label = ანაბეჭდი
openpgp-import-created-label = შექმნილი
openpgp-import-bits-label = ბიტი
openpgp-import-key-props =
    .label = გასაღების თვისებები
    .accesskey = ღ

## External Key section

openpgp-external-key-title = გარე GnuPG-გასაღები
openpgp-external-key-description = გარე GnuPG-გასაღების გამართვა, გასაღების ID-ის მითითებით
openpgp-external-key-info = გარდა ამისა, უნდა გამოიყენოთ გასაღების მმართველი, შესაბამისი საჯარო გასაღების შემოტანისა და დაშვებისთვის.
openpgp-external-key-warning = <b>შეგიძლიათ გამართოთ მხოლოდ ერთი GnuPG-გასაღები.</b> თქვენი წინა შენატანი ჩანაცვლდება.
openpgp-save-external-button = გასაღების ID-ს შენახვა
openpgp-external-key-label = საიდუმლო გასაღების ID:
openpgp-external-key-input =
    .placeholder = 123456789341298340
