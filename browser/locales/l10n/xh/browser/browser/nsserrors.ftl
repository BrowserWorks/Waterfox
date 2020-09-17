# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# DO NOT ADD THINGS OTHER THAN ERROR MESSAGES HERE.
# This file gets parsed into a JS dictionary of all known error message ids in
# gen_aboutneterror_codes.py . If we end up needing fluent attributes or
# refactoring them in some way, the script will need updating.

psmerr-ssl-disabled = Ayikwazi kuqhagamshela ngokukhuselekileyo ngenxa yokuba iSSL protokoli iyekisiwe.
psmerr-ssl2-disabled = Ayikwazi kuqhagamshela ngokukhuselekileyo ngenxa yokuba isayithi isebenzisa uhlelo oludala olungakhuselekanga lweprotokoli iSSL.

# This is a multi-line message.
psmerr-hostreusedissuerandserial =
    Ufumene isatifikethi esingasebenziyo.  Nceda zidibanise nomlawuli weseva okanye obhalelanana naye ngemeyile uze umnike ulwazi olulandelayo:
    
    Isatifikethi sakho siqulethe inombolo yolandelelwano efana ncam neyesinye isatifikethi esikhutshwe ngugunyaziwe wezatifikethi.  Nceda fumana isatifikethi esiqulethe inombolo yolandelelwano efana yodwa.

ssl-error-export-only-server = Ayikwazi kunxibelelana ngokukhuselekileyo. Umlingane akakuxhasi ukukhowuda okukumgangatho ophezulu.
ssl-error-us-only-server = Ayikwazi kunxibelelana ngokukhuselekileyo. Umlingane ufuna ukukhowuda okukumgangatho ophezulu okungaxhaswayo.
ssl-error-unsupported-certificate-type = Uhlobo lwesatifikethi olungaxhaswayo.
ssl-error-wrong-certificate = Uku-othentikheyitha komthengi kusilele: ikhi yabucala kuvimba wekhi akudibani nekhi kawonkewonke kuvimba wesatifikethi.
ssl-error-bad-mac-read = I-SSL ifumene irekhodi eneMessage Authentication Code engachananga.
ssl-error-bad-mac-alert = SSL peer reports incorrect Message Authentication Code.
ssl-error-rx-malformed-hello-request = I-SSL ifumene umyalezo ongayilwanga kakuhle weRequest woxhawulo lwezandla.
ssl-error-rx-malformed-client-hello = I-SSL ifumene umyalezo woxhawulo ngesandla ongenziwanga weClient Hello..
ssl-error-rx-malformed-server-hello = I-SSL ifumene iServer Hello engenziwanga kakuhle yomyalezo yoxhawulo ngesandla.
ssl-error-rx-malformed-certificate = I-SSL ifumene iSatifikethi esingenziwanga kakuhle semiyalezo yokubamba ngesandla.
ssl-error-rx-malformed-server-key-exch = I-SSL ifumene iKhi yeSeva Yotshintsho engenziwanga kakuhle yemiyalezo yokubamba ngesandla.
ssl-error-rx-malformed-cert-request = I-SSL ifumene umyalezo ongayilwanga kakuhle weCertificate Request woxhawulo zandla.
ssl-error-rx-malformed-hello-done = I-SSL ifumene umyalezo ongayilwanga kakuhle weServer Hello Done woxhawulo lwezandla.
ssl-error-rx-malformed-cert-verify = I-SSL yafumana umyalezo wokuHlolwa kweSatifikethi woxhawulo zandla.
ssl-error-rx-malformed-client-key-exch = I-SSL ifumene iSatifikethi esingenziwanga kakuhle somyalezo yoxhawulo zandla Lotshintsho Lwekhi Yomthengi.
ssl-error-rx-malformed-finished = I-SSL ifumene iFinished engayilwanga kakuhle yemiyalezo yokuxhawula ngesandla.
ssl-error-rx-malformed-change-cipher = I-SSL ifumene ingxelo yeChange Cipher Spec.
ssl-error-rx-malformed-alert = I-SSL ifumene ingxelo engayilwanga kakuhle yeSilumkiso.
ssl-error-rx-malformed-handshake = I-SSL ifumene ingxelo engayilwanga kakuhle yoXhawulo-zandla.
ssl-error-rx-unexpected-hello-request = I-SSL ifumene umyalezo ongayilwanga kakuhle weHello Request woxhawulo lwezandla.
ssl-error-rx-unexpected-client-hello = I-SSL ifumene umyalezo ongalindelekanga woxhawulo-zandla weClient Hello.
ssl-error-rx-unexpected-server-hello = I-SSL ifumene iServer Hello engalindelwanga enomyalezo woxhawulo-zandla.
ssl-error-rx-unexpected-certificate = I-SSL ifumene iSatifikethi esingalindelwanga esinomyalezo woxhawulo-zandla.
ssl-error-rx-unexpected-server-key-exch = I-SSL ifumene iSatifikethi esingalindelwanga esinomyalezo woxhawulo-zandla Wotshintsho Lwekhi Yeseva.
ssl-error-rx-unexpected-cert-request = I-SSL ifumene iSicelo seSatifikethi esingalindelwanga esinomyalezo woxhawulo-zandla.
ssl-error-rx-unexpected-hello-done = I-SSL ifumene iServer Hello Done engalindelwanga enomyalezo woxhawulo-zandla.
ssl-error-rx-unexpected-cert-verify = I-SSL ifumene iCertificate Verify engalindelwanga enomyalezo woxhawulo-zandla.
ssl-error-rx-unexpected-client-key-exch = I-SSL ifumene iClient Key Exchange esingalindelwanga enomyalezo woxhawulo-zandla.
ssl-error-rx-unexpected-finished = I-SSL ifumene umyalezo ongalindelekanga oGqityiweyo woxhawulo-zandla.
ssl-error-rx-unexpected-change-cipher = I-SSL ifumene irekhodi yeChange Cipher Specengalindelwanga.
ssl-error-rx-unexpected-alert = I-SSL ifumene irekhodi engalindelekanga Yokulumkisa.
ssl-error-rx-unexpected-handshake = I-SSL ifumene irekhodi yokuxhawula ngesandla engalindelekanga
ssl-error-generate-random-failure = I-SSL iye yafumana ukusilela ngenxa yejenereyitha yayo yenani elikhawulezileyo.
ssl-error-server-key-exchange-failure = Ukusilela okungachazwanga ngoxa iprosesa Utshintshwano Lwekhi yeSeva yeSSl yoxhawulo ngesandla.
ssl-error-client-key-exchange-failure = Ukusilela okungachazwanga ngoxa iprosesa Utshintshwano Lwekhi yoMthengi yeSSL yoxhawulo ngesandla.
ssl-error-no-trusted-ssl-client-ca = Akukho gunya lesatifikethi lithenjiweyo kugunyaziso lomthengi we-SSL.
ssl-error-decryption-failed-alert = Umlingane akakwazanga ukususa ikhowudi kwirekhodi ye-SSL eyifumeneyo.
ssl-error-decode-error-alert = Umlingane akakwazi ukususa ikhowudi kumyalezo we-SSL woxhawulo-zandla.
ssl-error-user-canceled-alert = Umsebenzisi ongumhlobo ucime uxhawulo-zandla.
ssl-error-certificate-unobtainable-alert = Umhlbo we-SSL akakwazanga kufumana isatifikethi sakho ngokusuka kwi-URL enikiweyo.
ssl-error-bad-cert-status-response-alert = Umlingane we-SSL akakwazanga ukufumana impendulo ye-OCSP yesatifikethi sayo.
ssl-error-rx-unexpected-new-session-ticket = I-SSL ifumene iTikiti Leseshoni Entsha enomyalezo woxhawulo-zandla.
ssl-error-rx-malformed-new-session-ticket = I-SSL ifumene iTikiti Leseshoni Entsha elingenziwanga kakuhle elinomyalezo woxhawulo-zandla.
ssl-error-decompression-failure = I-SSL ifumene ingxelo ekompresiweyo engakwaziyo ukuyekiswa ukukompreswa
ssl-error-unsafe-negotiation = Umhlobo uzame uhlobo lwakudala (enokuba sengozini) eyokuxhawula isandla.
ssl-error-rx-unexpected-uncompressed-record = I-SSL ifumene irekhodi yokuxhawula ngesandla engakhompreswanga.
ssl-error-feature-not-supported-for-servers = Ifitsha yeSSL ayixhaswa kwiiseva.
ssl-error-feature-not-supported-for-clients = Ifitsha yeSSL ayixhaswa kumthengi.
ssl-error-cipher-disallowed-for-version = Umhlobo we-SSL ukhethe icipher suite eyalelwe uhlobo lweprotokoli ekhethiweyo.
ssl-error-rx-malformed-hello-verify-request = I-SSL ifumene umyalezo ongayilwanga kakuhle weHello Verify Request yoxhawulo lwezandla.
ssl-error-rx-unexpected-hello-verify-request = I-SSL ifumene iHello Verify Request engalindelekanga enomyalezo woxhawulo-zandla.
ssl-error-rx-unexpected-cert-status = I-SSL ifumene iCertificate Status engalindelwanga esinomyalezo woxhawulo-zandla.
ssl-error-incorrect-signature-algorithm = I-algorithimu yosayino olungachananga ichazwe kwi-elementi esayinwe ngedijithali.
ssl-error-weak-server-cert-key = Isatifikethi seseva siqukiwe kwikhi kawonke wonke ebi-ethe ethe kakhulu.
sec-error-input-len = ilayibrari yokhuseleko iye yafumana impazamo yobude be-input.
sec-error-invalid-args = ilayibrari yokhuseleko; iingxoxo ezingezizo.
sec-error-invalid-algorithm = ilayibrari yokhuseleko; ialgorithimu engeyiyo.
sec-error-invalid-ava = ilayibrari yokhuseleko; i-AVA engeyiyo.
sec-error-bad-password = Iphaswedi yokhuseleko efakiweyo ayichananga.
sec-error-duplicate-cert-name = Igama lesatifikethi elidawnlowudiweyo liphindaphinda elo sele likuvimba wakho.
sec-error-expired-issuer-certificate = Isatifikethi somkhuphi wezatifikethi siphelile. Hlola umhla nexesha lesistim.
sec-error-crl-invalid = I-CRL entsha inolungiselelo olungasebenziyo.
sec-error-pkcs7-keyalg-mismatch = Ayikwazi kudikripta: i-algorithim yoku-enkript ikhi ayingqamani nesatifikethi sakho.
sec-error-unsupported-keyalg = I-algorithimu yekhi engaxhaswayo nengaziwayo.
sec-error-decryption-disallowed = Ayikwazi kudikripta: i-enkripta isebenzisa i-algorithim engavunyelwanga okanye isayizi yekhi.
xp-sec-fortezza-bad-pin = I-pin Engasebenziyo
sec-error-no-krl = Ayikho iKRL yesi satifikethi sesayithi efunyenweyo.
sec-error-krl-expired = IKRL yesi satifikethi sesayithi iphinde yavuselelwa.
sec-error-revoked-key = Ikhi yesi satifikethi sesayithi siphinde savuselelwa.
sec-error-krl-invalid = I-KRL entsha inefomathi engasebenziyo.
xp-java-cert-not-exists-error = Lo prinsipali akanaso isatifikethi
sec-error-bad-export-algorithm = Ialgorithimu efunekayo ayivunyelwanga.
sec-error-pkcs12-unsupported-version = Ayikwazi kuthumela ngaphakathi.Uhlobo lwefayile aluxhaswa.
sec-error-inadequate-cert-type = Uhlobo lwesatifikethi aluvunyelwanga usetyenziso.
sec-error-pkcs12-importing-cert-chain = Ayikwazi kuthumela ngaphakathi. Impazamo ekuzameni ukuthumela ngaphakathi umxokelelwane wesatifikethi.
sec-error-pkcs12-unable-to-locate-object-by-name = Ayikwazi ukuthumela ngaphandle. Ayikwazi kufumana isatifikethi okanye ikhi ngokwegama lesiteketiso.
sec-error-pkcs12-unable-to-export-key = Ayikwazi kuthumela ngaphandle. Ikhi Yabucala ayinakufunyanwa ize ithunyelwe ngaphandle
sec-error-pkcs12-unable-to-write = Ayikwazi kuthumela ngaphandle. Ayikwazi kubhala ifayile yokuthumela ngaphandle
sec-error-pkcs12-unable-to-read = Ayikwazi kuthumela ngaphandle. Ayikwazi kuunda ifayile yokuthumela ngaphandle
sec-error-invalid-password = Iphaswedi efakiweyo ayichananga. Sicela ukhethe eyahlukileyo.
sec-error-not-fortezza-issuer = Umxokelelwane womlingane iFORTEZZA ineSatifikethi esingesiso eseFORTEZZA.
sec-error-cannot-move-sensitive-key = Ikhi enochuku ayinakusiwa kwisloti efuneka kuso.
sec-error-js-invalid-module-name = Igama lemodyuli engasebenziyo.
sec-error-js-add-mod-failure = Ayikwazi kufakela imodyuli
sec-error-js-del-mod-failure = Ayikwazi kucimeka imodyuli
sec-error-old-krl = I-KRL entsha ayiyo eyasemva kwale intsha.
sec-error-ocsp-unknown-response-type = Intsabelo ye-OCSP ayinakudikhodwa ngokuzeleyo; yeyohlobo olungaziwayo.
sec-error-ocsp-unauthorized-response = Umsayini wentsabelo ye-OCSP ayigunyaziswanga ukunika imo yesi satifikethi.
sec-error-ocsp-invalid-signing-cert = Isatifikethi sosayino esingesiso se-OCSP kwintsabelo ye-OCSP.
sec-error-unknown-aia-location-type = Uhlobo olungaziwayo lwendawo kwicert AIA eyandisiweyo
sec-error-bad-http-response = Iseva ibuyisele impendulo engentle yeHTTP
sec-error-bad-ldap-response = Iseva ibuyisele impendulo engentle yeLDAP
sec-error-pkcs11-function-failed = Imodyuli yePKCS #11 ibuyise i-CKR_FUNCTION_FAILED, ibonisa ukuba umsebenzi oceliweyo awunakwenziwa. Ukuzama umsebenzi ofanayo kwakhona kusenokuphumelela.
sec-error-pkcs11-device-error = I-PKCS #11 modyuli ibuyisele i-CKR_DEVICE_ERROR, ibonisa ukuba ingxaki iye yavela ngetokheni okanye islothi.
