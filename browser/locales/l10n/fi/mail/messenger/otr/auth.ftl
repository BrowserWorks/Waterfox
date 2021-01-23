# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Varmista yhteyshenkilön henkilöllisyys
    .buttonlabelaccept = Varmista

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Varmista yhteyshenkilön { $name } henkilöllisyys

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Sormenjälkesi, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Sormenjälki yhteyshenkilöllle { $their_name }:

auth-help = Yhteyshenkilön henkilöllisyyden varmistaminen takaa, että keskustelu on todella yksityistä, jolloin kolmannen osapuolen on vaikeaa salakuunnella tai manipuloida keskustelua.
auth-helpTitle = Varmistusohjeet

auth-questionReceived = Tämä on yhteyshenkilösi esittämä kysymys:

auth-yes =
    .label = Kyllä

auth-no =
    .label = Ei

auth-verified = Olen varmistanut, että tämä on todella oikea sormenjälki.

auth-manualVerification = Manuaalinen sormenjäljen varmennus
auth-questionAndAnswer = Kysymys ja vastaus
auth-sharedSecret = Jaettu salaisuus

auth-manualVerification-label =
    .label = { auth-manualVerification }

auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }

auth-sharedSecret-label =
    .label = { auth-sharedSecret }

auth-manualInstruction = Ota yhteyttä aiottuun keskustelukumppaniisi jollain muulla todennetulla kanavalla, kuten OpenPGP-allekirjoitetulla sähköpostilla tai puhelimitse. Teidän tulisi kertoa toisillenne sormenjälkenne. (Sormenjälki on tarkistussumma, joka varmistaa salausavaimen.) Jos sormenjälki täsmää, Ilmoita alla olevassa valintaikkunassa, että olet varmistanut sormenjäljen.

auth-how = Kuinka haluaisit varmistaa yhteyshenkilösi henkilöllisyyden?

auth-qaInstruction = Mieti kysymystä, jonka vastauksen tiedätte vain sinä ja yhteyshenkilösi. Kirjoita kysymys ja vastaus, ja odota sitten yhteystietosi antamaa vastausta. Jos vastaukset eivät täsmää, käyttämääsi viestintäkanavaa saatetaan valvoa.

auth-secretInstruction = Ajattele salaisuutta, jonka tiedätte vain sinä ja yhteyshenkilösi. Älä käytä samaa Internet-yhteyttä salaisuuden kertomiseen. Syötä salaisuus ja odota sitten yhteyshenkilösi syöttävän sen. Jos salaisuudet eivät täsmää, käyttämääsi viestintäkanavaa saatetaan valvoa.

auth-question = Kirjoita kysymys:

auth-answer = Kirjoita vastaus (kirjainkoosta riippuvainen):

auth-secret = Kirjoita salaisuus:
