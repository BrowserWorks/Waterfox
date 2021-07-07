_for English, please see below_


# Nederlandse spellingcontrole

Dit is de Nederlandse spellingcontrole van
[Stichting OpenTaal](https://www.opentaal.org). Mits aan volledige
bronvermelding wordt gedaan en de licenties worden gerespecteerd, is deze
spellingcontrole vrij te gebruiken. De exacte voorwaarden zijn te vinden in he
 bestand [LICENSE.txt](LICENSE.txt). Lees deze goed door.

![logo Stichting OpenTaal](images/logo-shape-trans-640x360.png?raw=true)

Deze spellingcontrole is gebaseerd op de
[Nederlandse woordenlijst](https://github.com/OpenTaal/opentaal-wordlist) van
OpenTaal. Deze lijst heeft het
[Keurmerk Spelling](http://taalunieversum.org/inhoud/spelling-meer-hulpmiddelen/keurmerk)
van de [Taalunie](http://taalunie.org) gekregen. Dit betekent dat de woorden in
deze spellingcontrole voldoen aan de officiële spelling.

![logo Keurmerk Spelling](images/keurmerk.png?raw=true)

Naast het gebruiken van de woordenlijst is er veel handmatig werk verricht om de
spellingcontrole te optimaliseren.

## Inhoud

De spellingcontrole bestaat, naast de documentatie en licentie, uit de volgende
bestanden:
- `nl.aff`
- `nl.dic`
- `datetimeversion.txt`

Deze zijn samengesteld en gecontroleerd met een aantal hulpbestanden:
- `../opentaal-wordlist/wordparts.tsv`
- `../opentaal-wordlist/corrections.tsv`
- `elements/archaic.tsv`
- `elements/excluded.tsv`
- `elements/inflections.tsv`
- `elements/nosuggest.txt`
- `elements/objectionable.txt`
- `elements/obsolete.tsv`
- `elements/outdated.tsv`
- `elements/replacements.tsv`
- `elements/stress.tsv`

De spellingcontrole bestaat uit de twee
[UTF-8 Unicode](https://nl.wikipedia.org/wiki/UTF-8) bestanden
[nl.aff](nl.aff) en [nl.dic](nl.dic). Het
[formaat](https://linux.die.net/man/4/hunspell) ervan is redelijk complex en
is niet bedoeld om voor andere doeleinden te gebruiken. Dit formaat maakt het
mogelijk om van de meer dan 400.000 woorden uit de woordenlijst een woordenboek
te maken dat minder dan de helft zo groot is én informatie heeft over
vervoegingen, samenstellingen en suggesties.

De datum, de tijd en het versienummer van al deze bestanden is te vinden in
[datetimeversion.txt](datetimeversion.txt).

Beschrijving van de overige bestanden is:
<!--- [elements/archaic.tsv](elements/archaic.tsv) (archaïsch), dit zijn woorden die
nog wel gebruikt worden, alle zitten in de woordenlijst-->
- [elements/excluded.tsv](elements/excluded.tsv), deze woorden worden
uitgesloten van de spellingcontrole omdat ze een veel voorkomende fout van een
ander woord zijn
- [elements/inflections.tsv](elements/inflections.tsv), zijn flexies met hun
basiswoorden, soms zijn dat er meerdere
als suggestie gegeven worden
- [elements/nosuggest.txt](elements/nosuggest.txt), deze woorden mogen niet
als suggestie gegeven worden
- [elements/objectionable.txt](elements/objectionable.txt) (verwerpelijk), deze
woorden zijn verwerpelijk omdat ze (buiten de studie naar dit woord) als
discriminerend of racistisch worden ervaren
<!--- [elements/obsolete.tsv](elements/obsolete.tsv) (onbruik), deze woorden zijn in
onbruik geraakt, sommige zitten nog in de woordenlijst (weeuw), sommige niet
meer (arre) en sommige zijn fout omdat er een andere spelling van is (pannekoek)
of een ander woord voor in de plaats is gekomen (chocozoen)-->
<!--- [elements/outdated.tsv](elements/outdated) (ouderwets), deze woorden worden zeer
zelden nog gebruikt, sommige zitten nog in de woordenlijst, sommige niet meer-->

## Installatie

Spellingcontrole is in veel software zoals Chrome, Firefox, Thunderbird,
LibreOffice en Adobe-producten al geïntegreerd. Daardoor is het eenvoudig deze
Nederlandse ondersteuning te installeren.

Na installatie ondersteunt de spellingcontrole `Nederlands` of `Dutch`.
De spellingregels en de spellingcontrole zijn overigens identiek voor het
Nederlands in de landen waar deze wordt gebruikt, zoals Nederland, België en
Suriname.

Besturingssystemen bieden ook softwarepakketten die deze spellingcontrole
installeren en automatisch updaten. Voorbeelden hiervan zijn:
- [hunspell-nl](https://packages.ubuntu.com/search?keywords=hunspell-nl) voor Ubuntu
- [hunspell-nl](https://packages.debian.org/search?keywords=hunspell-nl) voor Debian

Voor andere besturingssystemen, zie
https://repology.org/project/hunspell-nl/versions

Ondersteuning voor Aspell en Ispell is te vinden in de respectievelijke
architectuuronafhankelijke Debianpakketten
[aspell-nl](https://packages.debian.org/stable/aspell-nl) en
[idutch](https://packages.debian.org/stable/idutch). Sinds 2011 wordt MySpell
niet meer ondersteund.

## Toetsenbord

Voor Android is er een toetsenbord dat gebruik maakt van de woordenlijst van
OpenTaal. Zie dit
[artikel](https://www.opentaal.org/het-laatste-nieuws/projectnieuws/51-publicaties/221-anysoftkeyboard)
op onze website voor meer informatie.

## Wordfeud

Of een woord wel of niet wordt geaccepteerd in Wordfeud of bepaalde andere
woordspellen is niet de verantwoordelijkheid van Stichting OpenTaal. Hiervoor
kan het beste contact opgenomen worden met [TaalTik](https://taaltik.nl).

## Draag bij

Help ons vrije en open Nederlandse schrijftools te ontwikkelen. Doneer
belastingvrij aan onze ANBI via https://www.opentaal.org/vrienden-van-opentaal
of contacteer ons als je woordenlijsten of databasevaardigheden te bieden hebt.


# Dutch spelling checker

This is the Dutch spell checker by [Stichting OpenTaal](https://www.opentaal.org).
As long as full attribution is provided and the licenses are respected, this
spell checker can be used freely. The exact conditions can be found in the file
[LICENSE.txt](LICENSE.txt). Please, read these carefully.

![logo Stichting OpenTaal](images/logo-shape-white-640x360.png?raw=true)

This spell checker is based on the
[Dutch word list](https://github.com/OpenTaal/opentaal-wordlist) from OpenTaal
This list has received the Quality Mark Spelling
([Keurmerk Spelling](http://taalunieversum.org/inhoud/spelling-meer-hulpmiddelen/keurmerk))
from the Dutch Language Union ([Taalunie](http://taalunie.org)). This means that
the words in this spell checker conform to the official spelling.

![logo Keurmerk Spelling](images/keurmerk.png?raw=true)

Besides using the word list, there has been done a lot of manual editing to
optimize this spelling checker.

## Contents

_Please, see the relevant section in Dutch_

## Installation

TODO

Operating systems offer software packages which install this spelling checker
and update it automatically. Examples of this are:
- [hunspell-nl](https://packages.ubuntu.com/search?keywords=hunspell-nl) for Ubuntu
- [hunspell-nl](https://packages.debian.org/search?keywords=hunspell-nl) for Debian

For other operating systems, see https://repology.org/project/hunspell-nl/versions

Support for Aspell and Ispell can be found in the respective
architecture-independent Debian packages
[aspell-nl](https://packages.debian.org/stable/aspell-nl) and
[idutch](https://packages.debian.org/stable/idutch). Since 2011, MySpell is no
longer supported.

## Keyboard

A keyboard for Android which uses this word list has been developed. Please, see
this
[article](https://www.opentaal.org/het-laatste-nieuws/projectnieuws/51-publicaties/221-anysoftkeyboard)
on our website for more information.

## Wordfeud

Whether or not a word is accepted in the Dutch version of Wordfeud or certain
other Dutch word games is not the responsibility of Stichting OpenTaal. For
this, please contact [TaalTik](https://taaltik.nl).

## Contribute

Please, help us create free and open Dutch writing tools. Donate tax free to our
foundation at https://www.opentaal.org/vrienden-van-opentaal or contact us is
you have word lists to database skills to offer.
