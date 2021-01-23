# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = I wakken ad tazneḍ iznan i yettwawgelhen neɣ yettwazemlen s wudem umḍin, tesriḍ ad tsewleḍ tatiknulujit n uwgelhen, OpenPGP neɣ S/MIME.
e2e-intro-description-more = Fren tasarut-ik·im tudmawant i usermed n useqdec n OpenPGP, neɣ aselken udmawan i usermed n useqdec n S/MIME. I tsarut tudmawant neɣ i uselken udmawan, ɣur-k tasarut tuffirt yemṣadan.
openpgp-key-user-id-label = Amiḍan / Asulay n useqdac
openpgp-keygen-title-label =
    .title = Sirew tasarut OpenPGP
openpgp-cancel-key =
    .label = Sefsex
    .tooltiptext = Sefsex asirew n tsarut
openpgp-key-gen-expiry-title =
    .label = Keffu n tsarut
openpgp-key-gen-expire-label = Tasarut ad temmet deg
openpgp-key-gen-days-label =
    .label = ussan
openpgp-key-gen-months-label =
    .label = ayyuren
openpgp-key-gen-years-label =
    .label = iseggasen
openpgp-key-gen-no-expiry-label =
    .label = Tasarut ut tettmettat ara
openpgp-key-gen-key-size-label = Teɣzi n tsarut
openpgp-key-gen-console-label = Asirew n tsarut
openpgp-key-gen-key-type-label = Anaw n tsarut
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (Elliptic Curve)
openpgp-generate-key =
    .label = Sirew tasarut
    .tooltiptext = Sirew tasarut i yemṣadan d OpenPGP i uwgelhen d/neɣ uzmul
openpgp-advanced-prefs-button-label =
    .label = Talqayt…
openpgp-key-expiry-label =
    .label = Azemz n taggara
openpgp-key-id-label =
    .label = Asulay n tsarut
openpgp-cannot-change-expiry = Ta d tasarut s tɣessa tuddist, Abeddel n uzemz-is n taggara ur yettwasefrak ara.
openpgp-key-man-title =
    .title = Asefrak n tsarut OpenPGP
openpgp-key-man-generate =
    .label = Tayuga n tsura timaynutin
    .accesskey = K
openpgp-key-man-file-menu =
    .label = Afaylu
    .accesskey = F
openpgp-key-man-edit-menu =
    .label = Ẓreg
    .accesskey = E
openpgp-key-man-view-menu =
    .label = Sken
    .accesskey = V
openpgp-key-man-generate-menu =
    .label = Sirew
    .accesskey = G
openpgp-key-man-keyserver-menu =
    .label = Aqeddac n tsarut
    .accesskey = K
openpgp-key-man-import-public-from-file =
    .label = Kter tasarut(tisura) tazayezt(tizuyaz) seg ufaylu
    .accesskey = l
openpgp-key-man-import-secret-from-file =
    .label = Kter tasarut(tisura) tuffirt(tuffirin) seg ufaylu
openpgp-key-man-discover-progress = Anadi…
openpgp-key-man-ctx-expor-to-file-label =
    .label = Kter tisura ɣer ufaylu
openpgp-key-man-ctx-copy-to-clipbrd-label =
    .label = Nɣel tisura tizuyaz ɣer afus
openpgp-key-man-close =
    .label = Mdel
openpgp-key-man-ctx-view-photo-label =
    .label = Sker asulay n tewlaft
openpgp-key-man-user-id-label =
    .label = Isem
openpgp-key-man-fingerprint-label =
    .label = Adsil umḍin
openpgp-key-man-filter-label =
    .placeholder = Anadi ɣef tsura
openpgp-key-man-select-all-key =
    .key = A
openpgp-key-details-title =
    .title = Iraten n tsarut
openpgp-key-details-signatures-tab =
    .label = Isleknen
openpgp-key-details-structure-tab =
    .label = Taɣessa
openpgp-key-details-id-label =
    .label = Asulay
openpgp-key-details-key-type-label = Anaw
openpgp-key-details-key-part-label =
    .label = Aferdis agejdan
openpgp-key-details-algorithm-label =
    .label = Alguritm
openpgp-key-details-size-label =
    .label = Teɣzi
openpgp-key-details-created-label =
    .label = Yettwarna
openpgp-key-details-created-header = Yettwarna
openpgp-key-details-expiry-label =
    .label = Azemz n taggara
openpgp-key-details-expiry-header = Azemz n taggara
openpgp-key-details-usage-label =
    .label = Aseqdec
openpgp-key-details-fingerprint-label = Adsil umḍin
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Mdel
openpgp-acceptance-label =
    .label = Aqbal-ik•im
openpgp-acceptance-rejected-label =
    .label = Uhu, agi tasarut-a.
openpgp-acceptance-undecided-label =
    .label = Mazal, ahat ticki.
openpgp-personal-no-label =
    .label = Uhu, ur tt-seqdaceɣ ara am tsarut-iw tudmawant.
openpgp-personal-yes-label =
    .label = Ih, ḥseb tasarut-a am tsarut tudmawant.
openpgp-copy-cmd-label =
    .label = Nɣel

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbird ur yesɛi ara tasarut OpenPGP tudmawant i <b> { $identity } </b>
        [one] Thunderbird yufa-d { $count } tasarut OpenPGP tudmawant i icudden ɣer </b> { $identity } </b>
       *[other] Thunderbird yufa-d { $count } tisura OpenPGP tudmawanin i icudden ɣer <b> { $identity } </b>
    }
openpgp-add-key-button =
    .label = Rnu tasarut…
    .accesskey = A
e2e-learn-more = Issin ugar

## OpenPGP Key selection area

key-does-not-expire = Tasarut ur tettmettat ara
key-expired-date = Tasarut temmut deg { $keyExpiry }
key-expired-simple = Tasarut temmut
key-revoked-simple = Tasarut ettwasefsex

## Account settings export output

