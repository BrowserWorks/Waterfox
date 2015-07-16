Tutoriál k Emacsu.  Podmínky viz na konci.
Do češtiny přeložil Milan Zamazal <pdm@zamazal.org>.

Máte před sebou tutoriál k Emacsu.

Příkazy Emacsu obecně využívají klávesu CONTROL (občas označovanou CTRL nebo
CTL) nebo klávesu META (občas označovanou EDIT nebo ALT).  Abychom tyto názvy
nemuseli stále psát v plném znění, budeme používat následující zkratky:

 C-<chr>  znamená přidržet klávesu CONTROL a stisknout znak <chr>.
          Tedy C-f znamená: přidržte klávesu CONTROL a stiskněte f.
 M-<chr>  znamená přidržet klávesu META, EDIT nebo ALT a stisknout <chr>.
          Pokud žádnou z kláves META, EDIT ani ALT nemáte, tak místo toho
          stiskněte a pusťte klávesu ESC a poté <chr>.  Klávesu ESC budeme
          značit <ESC>.

Důležitá poznámka: práci s Emacsem ukončíte stiskem C-x C-c (dva znaky).
Znaky ">>" na levém okraji značí místa, kde si máte vyzkoušet příkaz.
Například:
<<Blank lines inserted here by startup of help-with-tutorial>>
[Prostřední část obrazovky je prázdná záměrně. Text pokračuje níže.]
>>  Nyní stiskněte C-v (view next screen) pro posun na další obrazovku.
        (Směle do toho, proveďte to přidržením klávesy CONTROL a stiskem v.)
	Od této chvíle byste toto měli provádět kdykoliv dočtete zobrazenou
        obrazovku.

Všimněte si, že při posuvu obrazovek vždy zůstávají zobrazeny dva řádky
z předchozí obrazovky; to poskytuje určitou návaznost při postupném
čtení textu.

První věc, kterou potřebujete vědět, je jak se v textu pohybovat
z jednoho místa na druhé.  Už víte, jak se posunout o jednu obrazovku
vpřed, pomocí C-v.  K přechodu o obrazovku zpět použijte M-v
(přidržte klávesu META a stiskněte v nebo stiskněte <ESC>v, jestliže
nemáte žádnou z kláves META, EDIT nebo ALT).

>>  Zkuste stisknout M-v a pak C-v, několikrát to zopakujte.


* SHRNUTÍ
---------

K prohlížení obrazovkových stránek jsou užitečné následující příkazy:

	C-v	Posun o obrazovku vpřed
	M-v	Posun o obrazovku zpět
	C-l	Smazání obrazovky a znovuzobrazení celého textu,
		 přitom se text pod kurzorem přesune ke středu obrazovky.
		 (Jedná se o CONTROL-L a ne CONTROL-1.)

>> Najděte kurzor a zapamatujte si, jaký text je kolem něj.
   Pak stiskněte C-l.
   Najděte kurzor znovu a všimněte si, že je kolem něj tentýž text.


* ZÁKLADNÍ OVLÁDÁNÍ KURZORU
---------------------------

Pohyb mezi obrazovkami je užitečný, ale jak se přemístíte na konkrétní
místo v textu na obrazovce?

Je toho možno dosáhnout několika způsoby.  Nejzákladnějším způsobem je
použití příkazů C-p, C-b, C-f a C-n.  Každý z těchto příkazů přesune
kurzor na obrazovce o jeden řádek nebo sloupec v daném směru.
Zde je tabulka znázorňující směr posuvu kurzoru vyvolaný těmito čtyřmi
příkazy:

			  Předchozí řádek, C-p
				  :
				  :
      Dozadu, C-b .... Momentální pozice kurzoru .... Dopředu, C-f
				  :
				  :
			 Následující řádek, C-n

>> Přesuňte kurzor na prostřední řádek tohoto diagramu pomocí
   C-n nebo C-p.  Potom stiskněte C-l, abyste na obrazovce viděli celý
   diagram vycentrován.

Pravděpodobně se vám budou tyto příkazy snadno pamatovat podle
počátečních písmen anglických názvů: P jako previous (předchozí),
N jako next (následující), B jako backward (zpět), F jako forward (vpřed).
Jsou to základní příkazy pro pohyb kurzoru a budete je používat
neustále, takže by bylo velmi vhodné, kdybyste se je teď naučili.

>> Proveďte několikrát C-n, abyste kurzor přesunuli na tento řádek.

>> Posuňte kurzor dovnitř řádku pomocí několika C-f a pak nahoru stiskem C-p.
   Pozorujte, co C-p dělá, když je kurzor uprostřed řádku.

Každý řádek textu končí znakem nového řádku, který jej odděluje od řádku
následujícího.  Znakem nového řádku by měl být ukončen i poslední řádek
souboru (přestože to Emacs nevyžaduje).

>> Vyzkoušejte C-b na začátku řádku.  Kurzor by se měl přesunout na konec
   předchozího řádku, neboť jej tím přesunete přes znak nového řádku.

C-f funguje analogicky jako C-b, tj. na konci řádku dojde k přesunu na
další řádek.

>> Proveďte několik C-b, takže uvidíte, kde se nachází kurzor.
   Pak provádějte C-f, abyste se vrátili na konec řádku.
   Pak proveďte ještě jednou C-f, abyste se přesunuli na následující
   řádek.

Když kurzorem přejdete přes horní nebo dolní okraj obrazovky, posune se
text za příslušným okrajem na obrazovku.  Tato vlastnost se nazývá
"scrollování".  Umožňuje přemístit kurzor na libovolné místo v textu,
aniž by kurzor opustil obrazovku.

>> Zkuste posunout kurzor pod dolní okraj obrazovky pomocí C-n a pozorujte,
   co se stane.

Jestliže je posun po znacích příliš pomalý, můžete se pohybovat po
slovech.  M-f (META-f) provádí posun o slovo vpřed a M-b provádí posun
o slovo zpět.

>> Stiskněte několikrát M-f a M-b.

Pokud se kurzor nachází uprostřed slova, M-f provede přesun na konec
tohoto slova.  Nachází-li se kurzor v mezeře mezi slovy, M-f provede
přesun na konec následujícího slova.  M-b pracuje analogicky v opačném
směru.

>> Stiskněte několikrát M-f a M-b proloženě s C-f a C-b, abyste viděli
   výsledky příkazů M-f a M-b prováděných z různých míst uvnitř slov a
   mezi nimi.

Všimněte si analogie mezi C-f a C-b na jedné straně a M-f a M-b na
straně druhé.  Znaky s klávesou META jsou velmi často využívány pro operace
vztahující se k entitám definovaným jazykem (slova, věty, odstavce),
zatímco znaky s klávesou CONTROL pracují na základních prvcích
nezávislých na tom, co zrovna editujete (znaky, řádky, apod.).

Tato analogie platí také pro řádky a věty: C-a a C-e provádí přesun
na začátek a konec řádku, M-a a M-e provádí přesun na začátek a konec
věty.

>> Zkuste několikrát C-a a poté několikrát C-e.
   Zkuste několikrát M-a a poté několikrát M-e.

Všimněte si, že opakované C-a nedělá nic, zatímco opakované M-a vždy
provádí posun o další větu. Principu analogie to sice příliš
neodpovídá, ale přesto je toto chování možno považovat za přirozené.

Pozice kurzoru v textu se také nazývá "bod" ("point").  Abychom to
parafrázovali, kurzor je vidět na obrazovce v místě, kde je bod umístěn
v textu.

Zde je přehled jednoduchých operací pro pohyb kurzoru včetně příkazů pro
pohyb mezi slovy a větami:

	C-f	Přesun o znak vpřed
	C-b	Přesun o znak zpět

	M-f	Přesun o slovo vpřed
	M-b	Přesun o slovo zpět

	C-n	Přesun na následující řádek
	C-p	Přesun na předchozí řádek

	C-a	Přesun na začátek řádku
	C-e	Přesun na konec řádku

	M-a	Přesun zpět na začátek věty
	M-e	Přesun vpřed na konec věty

>> Vyzkoušejte si teď několikrát všechny tyto příkazy pro procvičení.
   Jsou to nejpoužívanější příkazy.

Další dva důležité příkazy pro pohyb kurzoru jsou M-< (META menší-než),
který provede přesun na začátek celého textu, a M-> (META větší-než),
který provede přesun na konec celého textu.

Na většině terminálů je "<" nad čárkou, takže pro vyvolání tohoto znaku
musíte použít klávesu Shift.  Na těchto terminálech je tedy nutno použít
klávesu Shift i v případě příkazu M-<; bez klávesy Shift byste provedli
M-čárka.

>> Zkuste teď M-< pro přesun na začátek tutoriálu.
   Použijte pak opakovaně C-v, abyste se opět vrátili sem.

>> Zkuste teď M-> pro přesun na konec tutoriálu.
   Použijte pak opakovaně M-v, abyste se opět vrátili sem.

Kurzor můžete přesouvat také pomocí kurzorových kláves (klávesy
se šipkami), pokud je váš terminál má.  My však doporučujeme naučit se
C-b, C-f, C-n a C-p, a to ze tří důvodů.  Za prvé, tyto klávesy fungují
na všech typech terminálů.  Za druhé, jakmile jednou získáte cvik
v používání Emacsu, zjistíte, že používání těchto CTRL znaků je
rychlejší než používání kurzorových kláves (protože nemusíte přesouvat
ruku z psací pozice).  Za třetí, zvyknete-li si používat tyto CTRL-znak
příkazy, snadno se naučíte používat jiné pokročilé příkazy pro pohyb
kurzoru.

Většina příkazů Emacsu akceptuje numerický argument; ten pro většinu
příkazů slouží jako opakovač.  Počet opakování příkazu zadáte
prostřednictvím stisku C-u následovaného stiskem příslušných číslic před
vyvoláním příkazu.  Máte-li META (nebo EDIT či ALT) klávesu, existuje
alternativní možnost zadání numerického argumentu: přidržte klávesu META
a stiskněte příslušné číslice.  Doporučujeme naučit se C-u metodu,
protože ta funguje na jakémkoliv terminálu.

Například C-u 8 C-f provede přesun o osm znaků vpřed.

Většina příkazů používá numerický argument jako opakovač.  Jisté
výjimečné příkazy jej používají jiným způsobem.  Mezi tyto výjimky patří
C-v a M-v.  Dostanou-li numerický argument, posunou obrazovku nahoru
nebo dolů o odpovídající počet řádků místo obrazovek.  Například
C-u 4 C-v posune obrazovku o 4 řádky.

>> Zkuste teď stisknout C-u 8 C-v.

To by mělo posunout obrazovku o 8 řádků nahoru.  Pokud byste ji chtěli
posunout zpět dolů, můžete dát argument příkazu M-v.

Používáte-li X Window, měli byste mít na levé straně emacsového okna
vysokou obdélníkovou oblast, nazývanou scrollbar.  Můžete pak text
posouvat klikáním myší na scrollbar.

>> Zkuste stisknout prostřední tlačítko na vrcholu zvýrazněné oblasti
   uvnitř scrollbaru.  To by mělo text posunout na pozici danou tím, jak
   vysoko nebo nízko jste kliknuli.

>> Zkuste při stisknutém prostředním tlačítku posouvat myší nahoru a
   dolů.  Uvidíte, jak se text posouvá nahoru a dolů podle toho, jak
   posouváte myší.


* KDYŽ EMACS NEREAGUJE
----------------------

Jestliže Emacs přestane reagovat na vaše příkazy, můžete probíhající
činnost bezpečně zastavit pomocí C-g.  Pomocí C-g můžete zastavit
příkaz, jehož provádění trvá příliš dlouho.

C-g můžete použít také pro odstranění numerického argumentu příkazu,
který nechcete dokončit.

>> Stiskněte C-u 100 pro vytvoření numerického argumentu 100 a pak
   stiskněte C-g.  Nyní stiskněte C-f.  Měl by být proveden posun
   o právě jeden znak, protože jste argument zrušili prostřednictvím
   C-g.

Pokud jste omylem stiskli <ESC>, můžete se jej zbavit pomocí C-g.


* DEAKTIVOVANÉ PŘÍKAZY
----------------------

Některé příkazy Emacsu jsou "deaktivované" ("disabled"), aby je
začínající uživatelé nemohli vyvolat náhodně.

Pokud vyvoláte některý z deaktivovaných příkazů, Emacs zobrazí hlášení
oznamující, který příkaz to byl, s dotazem, zda chcete tento příkaz
provést.

Pokud opravdu chcete příkaz vyzkoušet, stiskněte mezerník jako odpověď
na tuto otázku.  Obyčejně, jestliže nechcete deaktivovaný příkaz
provést, odpovězte na tuto otázku pomocí "n".

>> Stiskněte C-x C-l (což je deaktivovaný příkaz),
   pak na otázku odpovězte n.


* OKNA
------

Emacs může mít několik oken (windows), z nichž každé zobrazuje svůj
vlastní text.  Jak více oken používat, objasníme později.  Nyní chceme
objasnit, jak se zbavit nadbytečných oken a vrátit se do základní
jednookenní editace.  Je to jednoduché:

	C-x 1	Jedno okno (tj. zrušení všech ostatních oken)

Tedy vložení CONTROL-x následované číslicí 1.  C-x 1 rozšíří okno
obsahující kurzor přes celou obrazovku.  Zruší to všechna ostatní okna.

>> Stiskněte C-h k C-f.
   Pozorujte, jak se aktuální okno zmenší a objeví se nové okno za
   účelem zobrazení dokumentace k příkazu C-f.

>> Stiskněte C-x 1 a pozorujte, jak okno s dokumentací zmizí.


* VKLÁDÁNÍ A MAZÁNÍ
-------------------

Chcete-li vložit text, prostě jej napište.  Znaky, které vidíte,
jako A, 7, *, atd., jsou Emacsem chápány jako text a vkládány okamžitě.
Pro vložení znaku nového řádku stiskněte <Return> (klávesu Enter).

Poslední znak, který jste napsali, můžete smazat stiskem <Delete>.
<Delete> je klávesa, která může být na klávesnici označena "Del".
V některých případech jako <Delete> slouží klávesa "Backspace", avšak ne
vždy!

Obecněji, <Delete> maže znak bezprostředně před momentální pozicí
kurzoru.

>> Proveďte to teď -- napište několik znaků a pak je smažte několika
   stisky <Delete>.  Nebojte se změn v tomto souboru; originální
   tutoriál se nezmění.  Toto je vaše osobní kopie.

Když se řádek textu zvětší natolik, že přesáhne jeden řádek obrazovky,
je zobrazen na více řádcích obrazovky.  Řádek textu, který pokračuje na
dalším řádku obrazovky, je indikován zpětným lomítkem („\“) na pravém
okraji obrazovky.

>> Vkládejte text, až dosáhnete pravého okraje, a pokračujte ve vkládání.
   Objeví se vám pokračovací řádek.

>> Použijte <Delete> pro smazání textu, až se řádek textu opět vejde na
   jeden řádek obrazovky.  Pokračovací řádek zmizí.

Znak nového řádku můžete smazat jako kterýkoliv jiný znak.  Smazání
znaku nového řádku mezi dvěma řádky způsobí jejich spojení do jediného
řádku.  Je-li výsledný řádek příliš dlouhý na to, aby se vešel na šířku
obrazovky, bude zobrazen pokračovacím řádkem.

>> Přesuňte kurzor na začátek řádku a stiskněte <Delete>.  To tento
   řádek spojí s řádkem předchozím.

>> Stiskněte <Return> pro znovuvložení smazaného znaku nového řádku.

Vzpomeňte si, že většina příkazů Emacsu může dostat počet opakování;
včetně textových znaků.  Opakování textových znaků je vloží několikrát.

>>  Vyzkoušejte si to teď -- stiskněte C-u 8 * pro vložení ********.

Teď už znáte nejzákladnější způsoby, jak něco v Emacsu napsat a jak
opravovat chyby.  Můžete ovšem také mazat po slovech nebo po řádcích.
Zde je shrnutí operací pro mazání textu:

	<Delete>     Smazání znaku bezprostředně před kurzorem
	C-d   	     Smazání znaku následujícího za kurzorem

	M-<Delete>   Zrušení slova bezprostředně před kurzorem
	M-d	     Zrušení slova následujícího za kurzorem

	C-k	     Zrušení textu od pozice kurzoru do konce řádku
	M-k	     Zrušení textu do konce aktuální věty

Všimněte si, že <Delete> a C-d, resp. M-<Delete> a M-d, rozšiřují
paralelu započatou C-f a M-f (pravda, <Delete> opravdu není CONTROL
znak, ale netrapme se tím).  C-k a M-k jsou jako C-e a M-e ve smyslu
vztahu řádků k větám.

Libovolnou část bufferu můžete též zrušit následující metodou.
Přesuňte se na jeden konec této části a stiskněte C-@ nebo C-SPC
(libovolnou z těchto kombinací). (SPC označuje mezerník.)  Přesuňte
se na druhý konec této části a stiskněte C-w.  Text mezi těmito
pozicemi bude zrušen.

>> Přesuňte kurzor na písmeno L na začátku předchozího odstavce.
>> Stiskněte C-SPC.  Emacs by měl ve spodním řádku obrazovky
   zobrazit zprávu "Mark set".
>> Přesuňte kurzor na písmeno c ve slově "konec" na druhém řádku
   odstavce.
>> Stiskněte C-w.  Text začínající písmenem L a končící před písmenem
   c bude zrušen.

Uvědomte si, že rozdíl mezi "rušením" ("killing") a "mazáním"
("deleting") je ten, že "zrušené" věci mohou být zpět vhozeny, zatímco
"smazané" nikoliv.  Obecně příkazy, které mohou smazat větší množství
textu, ukládají text, zatímco příkazy, které mažou jediný znak nebo
pouze prázdné řádky a mezery, mazaný text neukládají.

>> Přesuňte kurzor na začátek neprázdného řádku.
   Pak stiskněte C-k pro zrušení textu na tomto řádku.
>> Stiskněte C-k podruhé.  Uvidíte, že to zruší znak nového řádku, který
   je za tímto řádkem.

Všimněte si, že jedno C-k zruší obsah řádku a druhé C-k zruší řádek
samotný a posune všechny další řádky nahoru.  C-k zpracovává numerický
argument speciálně: zruší odpovídající počet řádků VČETNĚ jejich
obsahu.  To už není opakování.  C-u 2 C-k zruší dva řádky a jejich
obsah; dvojitý stisk C-k by toto obvykle neudělal.

Vracení textu zpět se nazývá "vhazování" ("yanking").  (Představte
si opětovné vhazování, vracení dříve odstraněného textu zpátky.)
Zrušený text můžete vhodit buď na stejné místo, kde byl zrušen,
nebo na jiné místo v bufferu, nebo dokonce i do jiného souboru.
Text můžete vhodit i vícekrát, vytváříte tak jeho další kopie.

Příkazem pro vhazování je C-y.  Tento příkaz vloží poslední smazaný
text na pozici, na které se nachází kurzor.

>> Zkuste to; stiskněte C-y pro vhození textu zpět.

Stisknete-li několikrát C-k po sobě, všechen smazaný text je uložen
společně tak, aby bylo možné vhodit zpět všechny řádky najednou.

>> Stiskněte několikrát C-k.

Nyní obnovte posledně zrušený text:

>> Stiskněte C-y.  Pak posuňte kurzor o několik řádků níže a stiskněte
   C-y znova.  Nyní vidíte, jak lze text kopírovat.

Co když máte nějaký text, který byste rádi vhodili zpět a pak zrušíte
něco jiného?  C-y by vložilo poslední zrušený text.  Avšak předchozí
text není ztracen.  Můžete jej získat zpět použitím příkazu M-y.  Poté,
co provedete C-y pro získání posledního zrušeného textu, stisk M-y
vymění tento vhozený text za předchozí zrušený text.  Dalšími a
dalšími stisky M-y dostáváte předcházející a předcházející zrušené
texty.  Když dosáhnete textu, který hledáte, nemusíte s ním pro jeho
uchování nic dalšího provádět.  Jednoduše vhozený text ponechejte, kde
je, a pokračujte v editaci.

Pokud opakujete M-y dostatečně dlouho, dostanete se zpátky k výchozímu
bodu (posledně zrušenému textu).

>> Zrušte řádek, přesuňte kurzor někam jinam a zrušte jiný řádek.
   Pak proveďte C-y pro vrácení druhého zrušeného řádku.
   Pak proveďte M-y a vhozený řádek bude nahrazen prvním zrušeným řádkem.
   Opakujte M-y a pozorujte, co dostáváte.  Pokračujte v tom, dokud se
   znovu neobjeví druhý zrušený řádek a pak několik dalších.
   Chcete-li, můžete zkusit předat M-y kladné a záporné argumenty.


* UNDO
------

Jestliže provedete v textu změnu a pak zjistíte, že to byl omyl, můžete
změnu vrátit příkazem undo, C-x u.

C-x u obvykle vrátí změny provedené jedním příkazem; pokud C-x u
zopakujete několikrát za sebou, každé opakování vrátí jeden další
příkaz.

Jsou ale dvě výjimky: příkazy, které nemění text, se nepočítají (to
zahrnuje příkazy pro pohyb kurzoru a scrollování) a znaky vkládající
samy sebe jsou obvykle zpracovávány ve skupinách až po 20.  (To je kvůli
tomu, aby se zredukoval počet C-x u nutných pro vrácení vkládaného
textu.)

>> Zrušte tento řádek pomocí C-k, stiskněte pak C-x u a řádek by se měl
   znovu objevit.

Alternativní undo příkaz je C-_; pracuje stejně jako C-x u, je však
méně pracné jej aplikovat několikrát za sebou.  Nevýhodou C-_ je, že
na některých klávesnicích není zřejmé, jak jej vyvolat.  To je důvod,
proč nabízíme i C-x u.  Na některých terminálech můžete C-_ vyvolat
stiskem / při stisknutém CTRL.

Numerický argument pro C-_ a C-x u funguje jako počet opakování.

Pomocí příkazu undo můžete vrátit zrušený stejně jako smazaný text.
Rozdíl mezi mazáním a rušením textu ovlivňuje možnost vhození tohoto
textu pomocí C-y, neovlivňuje možnosti příkazu undo.


* SOUBORY
---------

Aby text, který editujete, zůstal trvale uchován, musíte jej uložit do
souboru.  Jinak by byl po ukončení Emacsu ztracen.  Svoji editaci
spojíte se souborem "vyhledáním" ("finding") souboru.  (Také se to
nazývá "navštívení" ("visiting") souboru.)

Vyhledání souboru znamená, že vidíte jeho obsah v Emacsu.  V mnoha
ohledech je to, jako byste editovali přímo ten soubor.  Nicméně změny,
které prostřednictvím Emacsu činíte, se nestanou trvalými, dokud tyto
změny do souboru "neuložíte" ("save").  Tím se zamezí nechtěnému ponechání
částečně změněného souboru v systému.  Dokonce i když soubor uložíte,
Emacs uchová původní soubor pod změněným názvem pro případ, že byste
zjistili, že vaše úpravy byly chybné.

Když se podíváte do dolní části obrazovky, uvidíte řádek, který začíná a
končí pomlčkami a na začátku má "2J:-- TUTORIAL.cs" nebo něco podobného.
Tato část obrazovky obvykle obsahuje jméno souboru, který je právě
navštíven.  Zrovna teď máte navštíven soubor nazvaný "TUTORIAL.cs",
který je vaší osobní čmárací kopií tutoriálu Emacsu.  Když v Emacsu
vyhledáte soubor, jeho jméno se objeví přesně na tom místě.

Příkazy pro vyhledávání a ukládání souborů se na rozdíl od ostatních
příkazů, které jste se zatím naučili, skládají ze dvou znaků.  Oba
začínají znakem CONTROL-x.  Existuje celá řada příkazů začínajících na
CONTROL-x; mnoho z nich pracuje se soubory, buffery a podobnými věcmi.
Tyto příkazy jsou dlouhé dva, tři nebo čtyři znaky.

Další věcí ohledně příkazu pro vyhledání souboru je to, že musíte říct,
které jméno souboru chcete.  Říkáme, že příkaz "čte argument
z terminálu" (v tomto případě je argumentem jméno souboru).  Poté co
vyvoláte příkaz

	C-x C-f   Vyhledání souboru

Emacs se vás zeptá na jméno souboru.  Jméno souboru, které píšete, se
objevuje ve spodním řádku obrazovky, který se v této situaci nazývá
minibuffer.  Pro editaci jména souboru můžete používat obvyklé editační
příkazy Emacsu.

Zadávání jména souboru (obecně kterýkoliv vstup z minibufferu) můžete
zrušit příkazem C-g.

>> Stiskněte C-x C-f a pak C-g.  To minibuffer zruší a taktéž to zruší
   příkaz C-x C-f, který minibuffer použil.  Takže nevyhledáte žádný
   soubor.

Po napsání jména souboru stiskněte <Return>.
Příkaz C-x C-f pak začne pracovat a vyhledá soubor, který jste zvolili.
Po skončení příkazu C-x C-f minibuffer zmizí.

Po malé chvilce se obsah souboru objeví na obrazovce a můžete jej
editovat.  Když chcete změny trvale uložit, použijte příkaz

	C-x C-s   Uložení souboru

To zkopíruje text z Emacsu do souboru.  Když to provedete poprvé, Emacs
přejmenuje původní soubor na soubor s novým jménem, aby nebyl ztracen.
Nové jméno je vytvořeno přidáním "~" na konec původního jména souboru.

Když je ukládání dokončeno, Emacs zobrazí jméno zapsaného souboru.
Měli byste ukládat rozumně často, abyste neztratili příliš mnoho práce
v případě pádu systému.

>> Stiskněte C-x C-s pro uložení vaší kopie tutoriálu.
   Mělo by to zobrazit "Wrote ...TUTORIAL.cs" ve spodním řádku obrazovky.

Existující soubor můžete vyhledat, abyste jej mohli prohlížet nebo
editovat.  Můžete také vyhledat soubor, který ještě neexistuje.  To je
způsob, jakým lze vytvořit soubor v Emacsu: vyhledejte soubor, který
bude na začátku prázdný a pak začněte vkládat text určený pro tento
soubor.  Když požádáte o uložení, Emacs skutečně vytvoří soubor
s textem, který jste vložili.  Od té chvíle se pak můžete cítit, jako
kdybyste editovali již existující soubor.


* BUFFERY
---------

Jestliže vyhledáte pomocí C-x C-f druhý soubor, první soubor v Emacsu
zůstává.  Můžete se do něj zpět přepnout jeho opětovným vyhledáním
pomocí C-x C-f.  Tímto způsobem můžete do Emacsu dostat poměrně hodně
souborů.

>> Vytvořte soubor pojmenovaný "foo" stiskem C-x C-f foo <Return>.
   Potom vložte nějaký text, zeditujte jej a uložte "foo" stiskem C-x C-s.
   Nakonec stiskněte C-x C-f TUTORIAL.cs <Return>, čímž se vrátíte zpět do
   tutoriálu.

Emacs ukládá text každého souboru do objektu nazývaného "buffer".
Vyhledání souboru vytvoří v Emacsu nový buffer.  Chcete-li vidět seznam
bufferů, které momentálně existují ve vašem procesu Emacs, stiskněte:

	C-x C-b   Seznam bufferů

>> Zkuste teď C-x C-b.

Podívejte se, že každý buffer má v seznamu jméno a může tam mít také jméno
souboru, jehož text obsahuje.  Některé buffery neodpovídají souborům.
Například buffer pojmenovaný "*Buffer List*" nemá žádný soubor.  Je to
buffer, který obsahuje seznam bufferů vytvořený pomocí C-x C-b.
JAKÝKOLIV text, který vidíte v emacsovém okně, je vždy součástí
nějakého bufferu.

>> Stiskněte C-x 1, abyste se zbavili seznamu bufferů.

Pokud provedete změny textu jednoho souboru a pak vyhledáte jiný soubor,
nezpůsobí to uložení prvního souboru.  Jeho změny zůstávají v Emacsu
uchovány v jemu odpovídajícím bufferu.  Vytvoření a editace druhého
souboru nemá žádný vliv na buffer prvního souboru.  To je velmi
užitečné, ale také to znamená, že potřebujete vhodný způsob, jak uložit
buffer prvního souboru.  Nutnost přepnout se zpátky pomocí C-x C-f, aby
jej bylo možno uložit prostřednictvím C-x C-s, by byla nemístně
obtěžující.  Takže máme

	C-x s     Uložení některých bufferů

C-x s se vás zeptá na každý buffer, který obsahuje změny, které jste
neuložili.  Pro každý takový buffer se vás zeptá, zda jej má uložit.

>> Vložte řádek textu a pak stiskněte C-x s.
   Měli byste být dotázáni, zda má být uložen buffer nazvaný TUTORIAL.cs.
   Odpovězte na tuto otázku ano (yes) stiskem "y".


* ROZŠIŘOVÁNÍ SADY PŘÍKAZŮ
--------------------------

Existuje mnohem, mnohem více příkazů Emacsu, než které by vůbec mohly
být rozmístěny na všechny CONTROL a META znaky.  Emacs tento problém
obchází prostřednictvím X (eXtend) příkazu.  Ten vzniká dvěma způsoby:

	C-x	Znakový eXtend.  Následován jedním znakem.
	M-x	Pojmenovaný příkaz eXtend.  Následován dlouhým názvem.

To jsou příkazy, které jsou obecně užitečné, avšak méně často používané
než ty, které jste se již naučili.  Už jste viděli dva z nich: souborové
příkazy C-x C-f pro vyhledání a C-x C-s pro uložení.  Jiný příklad je
příkaz pro ukončení Emacsu -- tj. příkaz C-x C-c.  (Nemějte obavy
o ztrátu změn, které jste provedli; C-x C-c nabídne uložení každého
změněného souboru, než Emacs ukončí.)

C-z je příkaz na *dočasné* opuštění Emacsu -- můžete se po něm do
spuštěného Emacsu vrátit.

Na systémech, které to umožňují, C-z Emacs "pozastaví"; tzn. vrátí vás
do shellu, avšak Emacs neukončí.  V nejběžnějších shellech se můžete do
Emacsu vrátit příkazem "fg" nebo pomocí "%emacs".

Na systémech, které pozastavování procesů nemají implementováno, C-z
vytvoří subshell běžící pod Emacsem, aby vám dal šanci spustit jiné
programy a pak se do Emacsu vrátit; neprovede tedy pravé opuštění
Emacsu.  V tom případě je obvyklou cestou návratu ze subshellu do Emacsu
shellovský příkaz "exit".

Chvíle pro použití C-x C-c nastane, když se chystáte odhlásit ze
systému.  Správné je to také při ukončování Emacsu vyvolaného poštovním
programem a různými jinými utilitami, protože ty nemusí vědět, jak si
poradit s pozastavením Emacsu.  Nicméně za normálních okolností, pokud
se nechystáte odlogovat, je lépe Emacs pozastavit pomocí C-z než jej
ukončit.

Existuje mnoho C-x příkazů.  Zde je seznam těch, které jste se již naučili:

	C-x C-f		Vyhledání souboru
	C-x C-s		Uložení soubor
	C-x C-b		Seznam bufferů
	C-x C-c		Ukončení Emacsu
	C-x u		Undo

Pojmenované eXtended příkazy jsou příkazy, které jsou používány ještě
méně, nebo příkazy, které jsou používány jenom v jistých módech.
Příkladem je příkaz replace-string, který globálně nahradí jeden řetězec
jiným.  Když stisknete M-x, vypíše se na spodním řádku obrazovky prompt
M-x a vy byste měli zadat jméno příkazu; v tomto případě
"replace-string".  Jednoduše napište "repl s<TAB>" a Emacs název doplní.
Dokončete zadávání jména příkazu pomocí <Return>.

Příkaz replace-string vyžaduje dva argumenty -- řetězec, který má být
nahrazen, a řetězec, který jej má nahradit.  Každý argument musíte
ukončit pomocí <Return>.

>> Přesuňte kurzor na prázdný řádek dva řádky pod tímto.
   Pak napište M-x repl s<Return>změnil<Return>modifikoval<Return>.

   Všimněte si, jak se tento řádek změnil: nahradili jste slovo
   z-m-ě-n-i-l slovem "modifikoval", kdekoliv se za aktuální pozicí
   kurzoru vyskytlo.


* AUTOMATICKÉ UKLÁDÁNÍ
----------------------

Jestliže jste provedli změny v souboru, ale nemáte je ještě uloženy,
mohou být v případě pádu systému ztraceny.  Aby vás Emacs od toho
uchránil, periodicky zapisuje "auto save" soubor pro každý soubor, který
editujete.  Jméno auto save souboru má na začátku a na konci #;
například jestliže se váš soubor jmenuje "hello.c", jeho auto save
soubor se jmenuje "#hello.c#".  Když soubor uložíte normálním způsobem,
Emacs auto save soubor smaže.

Jestliže dojde k pádu systému, můžete svoji editaci obnovit z auto-save
souboru, a to normálním vyhledáním souboru (toho, který jste editovali,
ne auto save souboru) a následnou aplikací M-x recover file<return>.
Na žádost o potvrzení odpovězte zadáním yes<return> pro pokračování a
obnovení auto-save dat.


* ECHO OBLAST
-------------

Když Emacs vidí, že píšete příkazy pomalu, ukazuje vám je ve spodní
části obrazovky v oblasti nazývané "echo oblast".  Echo oblast obsahuje
dolní řádek obrazovky.


* STAVOVÝ ŘÁDEK
---------------

Řádek bezprostředně nad echo oblastí se nazývá "stavový řádek" ("mode line").
Stavový řádek říká něco jako:

2J:** TUTORIAL.cs       (Fundamental)--L670--58%----------------

Tento řádek podává užitečnou informaci o stavu Emacsu a textu, který
editujete.

Už víte, co znamená jméno souboru -- je to soubor, který jste vyhledali.
-NN%-- označuje vaši aktuální pozici v textu; říká, že NN procent textu
je nad horním okrajem obrazovky.  Je-li začátek souboru na obrazovce, je
zde --Top-- a ne --00%--.  Je-li konec textu na obrazovce, je zde
--Bot--.  Jestliže se díváte na tak malý text, že se celý vejde na
obrazovku, stavový řádek říká --All--.

Hvězdičky poblíž začátku znamenají, že jste text změnili.  Těsně po
vyhledání nebo uložení souboru v této části stavového řádku nejsou žádné
hvězdičky, pouze pomlčky.

Část stavového řádku v závorkách říká, v jakých editačních módech se
nacházíte.  Implicitní mód je Fundamental, což je ten, který momentálně
používáte.  Je příkladem hlavního módu ("major mode").

Emacs má celou řadu hlavních módů.  Některé z nich jsou určeny pro
editaci různých programovacích jazyků a/nebo textů jako třeba Lisp mód,
Text mód, atd.  V libovolném okamžiku je aktivní právě jeden hlavní mód a
jeho jméno lze nalézt ve stavovém řádku na místě, kde je teď
"Fundamental".

Každý hlavní mód mění chování některých příkazů.  Například existují
příkazy pro vytváření komentářů v programu, a protože každý programovací
programovací jazyk má jinou představu o tom, jak má komentář vypadat,
musí každý hlavní mód vkládat komentáře jinak.  Každý hlavní mód je
vlastně jméno extended příkazu, kterým se do tohoto módu můžete
přepnout.  Například M-x fundamental-mode je příkaz pro přepnutí se do
Fundamental módu.

Chystáte-li se editovat český text, jako třeba tento soubor,
pravděpodobně byste měli použít Text mód.
>> Napište M-x text-mode<Return>.

Nebojte se, žádný z příkazů, které jste se naučili, chování Emacsu nijak
významně nezmění.  Můžete si ale všimnout, že M-f a M-b nyní pracují
s apostrofy jako se součástmi slov.  Předtím, ve Fundamental módu, M-f a
M-b pracovaly s apostrofy coby oddělovači slov.

Hlavní módy obvykle dělají menší změny, jako byla tato: příkazy většinou
dělají "totéž", ale v každém hlavním módu pracují trošku jinak.

Dokumentaci k aktuálnímu hlavnímu módu si můžete zobrazit stiskem C-h m.

>> Jednou nebo několikrát použijte C-u C-v, abyste tento řádek dostali
   k vrcholu obrazovky.
>> Stiskněte C-h m, abyste viděli, jak se Text mód liší od Fundamental
   módu.
>> Stiskněte C-x 1 pro odstranění dokumentace z obrazovky.

Hlavní módy se nazývají hlavní proto, že také existují vedlejší módy
(minor modes).  Vedlejší módy nejsou alternativou k hlavním módům, nýbrž
jejich malé modifikace.  Každý vedlejší mód může být zapnut nebo vypnut
sám o sobě nezávisle na všech ostatních vedlejších módech a nezávisle na
hlavním módu.  Takže nemusíte používat žádný vedlejší mód nebo můžete
používat jeden vedlejší mód nebo libovolnou kombinaci několika
vedlejších módů.

Jedním z velmi užitečných vedlejších módů, zejména pro editaci českých
textů, je Auto Fill mód.  Když je tento mód zapnut, Emacs zalomí řádek
mezi dvěma slovy, kdykoliv vkládáte text a řádek se stane příliš
dlouhým.

Auto Fill mód můžete zapnout provedením M-x auto-fill-mode<Return>.
Je-li tento mód zapnut, můžete jej vypnout provedením M-x
auto-fill-mode<Return>.  Je-li mód vypnut, tento příkaz jej zapíná,
a je-li mód zapnut, tak jej tento příkaz vypíná.  Říkáme, že tento
příkaz přepíná ("toggles") tento mód.

>> Napište teď M-x auto-fill-mode<Return>.  Pak vkládejte "asdf " stále
   dokola tak dlouho, až uvidíte, jak se vkládaný řádek rozdělí na dva
   řádky.  Do textu musíte vkládat mezery proto, že Auto Fill mód
   zalamuje řádky pouze v mezerách.

Okraj je obvykle nastaven na 70 znaků, ale můžete to změnit příkazem
C-x f.  Hodnotu okraje, kterou si přejete, byste měli předat jako
numerický argument.

>> Napište C-x f s argumentem 20.  (C-u 2 0 C-x f).
   Pak pište nějaký text a pozorujte, jak Emacs vyplňuje řádky po
   20 znacích.  Pak nastavte okraj zpátky na 70 opětovným použitím
   C-x f.

Jestliže provedete změny uprostřed odstavce, Auto Fill mód jej
nepřeformátuje.
Pro přeformátování odstavce stiskněte M-q (META-q) s kurzorem uvnitř
odstavce.

>> Přesuňte kurzor do předchozího odstavce a stiskněte M-q.


* VYHLEDÁVÁNÍ
-------------

Emacs umí v textu vyhledávat řetězce (tj. skupiny spojených znaků nebo
slov) směrem vpřed nebo vzad.  Hledání řetězce je příkaz přesunující
kurzor; přesune kurzor na nejbližší místo, kde se tento řetězec nachází.

Vyhledávací příkaz Emacsu se liší od vyhledávacích příkazů většiny
editorů v tom smyslu, že je "inkrementální".  To znamená, že vyhledávání
se provádí už v okamžiku, kdy zadáváte vyhledávací řetězec.

Příkaz pro zahájení hledání vpřed je C-s a pro hledání vzad C-r.
ALE POZOR!  Nezkoušejte to ještě.

Když stisknete C-s, uvidíte v echo oblasti prompt "I-search".  To vám
říká, že Emacs se nachází ve stavu, který se nazývá inkrementální hledání,
a čeká, až mu zadáte, co chcete hledat.  <RET> hledání ukončí.

>> Nyní zahajte hledání stiskem C-s.  POMALU, písmeno po písmenu, pište
   slovo "kurzor".  Po každém písmenu si všimněte, co se děje s kurzorem.
   Teď jste vyhledali "kurzor" poprvé.
>> Stiskněte C-s znovu, abyste nalezli další výskyt "kurzor".
>> Nyní čtyřikrát stiskněte <Delete> a pozorujte, jak se kurzor
   přesunuje.
>> Stiskněte <RET> pro ukončení hledání.

Viděli jste, co se stalo?  Emacs se v inkrementálním hledání pokouší
přejít na další výskyt řetězce, který jste dosud napsali.  Chcete-li
přejít na další výskyt "kurzor", jednoduše stiskněte C-s znovu.
Jestliže už žádný takový výskyt není, Emacs pípne a řekne vám, že
hledání momentálně "selhává", C-g hledání ukončí.

POZNÁMKA: Na některých systémech stisk C-s způsobí ztuhnutí
obrazovky a nevidíte žádný další výstup z Emacsu.  To znamená, že
"vlastnost" operačního systému zvaná "flow control" zachycuje C-s a
nepropustí jej k Emacsu.  Pro odtuhnutí obrazovky stiskněte C-q.  Pak
v sekci "Spontaneous Entry to Incremental Search" v manuálu Emacsu
vyhledejte radu, jak se vypořádat s touto "vlastností".

Jestliže uprostřed inkrementálního hledání stisknete <Delete>, uvidíte,
že poslední znak v hledaném řetězci zmizí a hledání se vrací na poslední
místo hledání.  Předpokládejme například, že jste napsali "c", abyste
našli první výskyt "k".  Jestliže nyní stisknete "u", kurzor se přesune na
první výskyt "ku".  Teď stiskněte <Delete>.  To vymaže "u" z hledaného
řetězce a kurzor se přesune zpět na první výskyt "k".

Jestliže uprostřed hledání stisknete CONTROL nebo META znak (s několika
výjimkami -- znaky, které jsou speciální v hledání, jako C-s a C-r),
hledání se ukončí.

C-s zahajuje hledání, které hledá jakýkoliv výskyt hledaného řetězce ZA
aktuální pozicí kurzoru.  Chcete-li něco hledat v předcházejícím textu,
stiskněte C-r místo C-s.  Vše, co jsme řekli o C-s, platí také o C-r
kromě toho, že směr hledání je opačný.


* VÍCE OKEN
-----------

Jednou z pěkných vlastností Emacsu je to, že může na obrazovce zobrazit
více oken současně.

>> Přesuňte kurzor na tento řádek a stiskněte C-u 0 C-l.

>> Teď stiskněte C-x 2, což rozdělí obrazovku na dvě okna.
   Obě okna zobrazují tento tutoriál.  Kurzor zůstává navrchu okna.

>> Tiskněte C-M-v pro scrollování spodního okna.
   (Nemáte-li skutečnou klávesu META, stiskněte ESC C-v.)

>> Stiskněte C-x o ("o" jako "other") pro přesun kurzoru do dolního okna.

>> Použijte C-v a M-v ve spodním okně pro jeho scrollování.
   Pokračujte ve čtení těchto instrukcí v horním okně.

>> Znovu stiskněte C-x o pro přesun kurzoru zpět do horního okna.
   Kurzor v horním okně je přesně na místě, kde byl původně.

Můžete dále používat C-x o pro přepínání mezi okny.  Každé okno má svoji
vlastní pozici kurzoru, ale jenom jedno okno kurzor skutečně zobrazuje.
Všechny obvyklé editační příkazy platí pro okno, ve kterém se nachází
kurzor.  Toto okno nazýváme "aktivní okno" ("selected window").

Příkaz C-M-v je velmi užitečný, jestliže v jednom okně editujete text a
druhé okno používáte pouze pro přehled.  Můžete kurzor nechávat stále
v okně, kde editujete, a postupovat po druhém okně pomocí C-M-v.

C-M-v je příkladem CONTROL-META znaku.  Máte-li skutečnou META klávesu,
můžete vyvolat C-M-v přidržením obou kláves CTRL a META při stisku v.
Nezáleží na tom, zda je prvně stisknuta CTRL nebo META, protože obě tyto
klávesy fungují jako modifikátory kláves, které tisknete.

Pokud nemáte skutečnou META klávesu, můžete místo ní použít ESC, na
pořadí záleží: musíte stisknout ESC a následně CTRL-v; CTRL-ESC v by
nefungovalo.  To proto, že ESC je samostatný znak, nikoliv modifikátor.

>> Stiskněte C-x 1 (v horním okně), abyste se zbavili dolního okna.

(Kdybyste C-x 1 stiskli v dolním okně, odstranilo by to horní okno.
Chápejte tento příkaz jako "ponechej právě jedno okno -- to, ve kterém
zrovna jsem".)

Nemusíte v obou oknech zobrazovat tentýž buffer.  Jestliže použijete
C-x C-f pro vyhledání souboru v jednom z oken, druhé okno se nezmění.
Můžete vyhledávat soubory v obou oknech nezávisle.

Zde je další způsob, jak využít dvě okna ke zobrazení dvou různých věcí:

>> Stiskněte C-x 4 C-f následované jménem některého z vašich souborů.
   Dokončete to pomocí <Return>.  Vidíte zadaný soubor v dolním okně.
   Přesunul se tam i kurzor.

>> Stiskněte C-x o pro přesun zpět do horního okna a C-x 1 pro smazání
   dolního okna.


* REKURZIVNÍ EDITAČNÍ ÚROVNĚ
----------------------------

Občas se dostanete do něčeho, co se nazývá "rekurzivní editační úroveň"
("recursive editing level").  To je indikováno hranatými závorkami ve
stavovém řádku obklopujícími závorky okolo jména hlavního módu.
Například můžete vidět [(Fundamental)] místo (Fundamental).

Abyste se dostali z rekurzivní editační úrovně, stiskněte ESC ESC ESC.
To je obecný "vyskakovací" příkaz.  Můžete jej použít též pro odstranění
některých oken a vyskočení z minibufferu.

>> Stiskněte M-x, abyste se dostali do minibufferu; pak stiskněte
   ESC ESC ESC, abyste se z něj dostali ven.

Z rekurzivní editační úrovně nemůžete vyskočit pomocí C-g.  To proto, že
C-g je využíváno pro rušení příkazů a argumentů UVNITŘ rekurzivní
editační vrstvy.


* ZÍSKÁNÍ DALŠÍ NÁPOVĚDY
------------------------

V tomto tutoriálu jsme se pokusili poskytnout vám dostatek informací,
abyste mohli začít Emacs používat.  V Emacsu je toho tolik, že by bylo
nemožné to zde všechno objasnit.  Nicméně se o Emacsu můžete naučit
více, protože má mnoho užitečných vlastností.  Emacs nabízí příkazy pro
čtení dokumentace svých příkazů.  Všechny tyto "help" příkazy
začínají znakem CONTROL-h, který se nazývá "help znak".

Pro použití vlastností nápovědy stiskněte znak C-h a pak znak říkající,
jaký druh nápovědy žádáte.  Jste-li OPRAVDU ztraceni, stiskněte C-h ? a
Emacs vám sdělí, jaké druhy nápovědy vám může poskytnout.  Jestliže
jste stiskli C-h a pak jste se rozhodli, že žádnou nápovědu nechcete,
jednoduše to zrušte stiskem C-g.

(Na některých počítačích je význam znaku C-h změněn.  To by opravdu
nemělo být obecným nastavením pro všechny uživatele, takže máte právo
stěžovat si systémovému administrátorovi.  Do té doby, jestliže C-h
nezobrazuje hlášení o nápovědě v dolní části obrazovky, zkuste místo
toho používat klávesu F1 nebo M-x help RET.)

Nejzákladnější help příkaz je C-h c.  Stiskněte C-h, znak c a klávesový
příkaz; Emacs pak zobrazí velmi stručný popis příkazu.

>> Stiskněte C-h c C-p.
   Hlášení by mělo vypadat asi takto

	C-p runs the command previous-line

To vám sděluje "jméno funkce".  Jména funkcí jsou používána zejména pro
konfiguraci a rozšiřování Emacsu.  Ale protože jména funkcí jsou volena
tak, aby naznačovala, co odpovídající příkaz dělá, mohou sloužit také
jako velmi stručná dokumentace -- dostatečná k tomu, aby vám připomenula
příkazy, které jste se již naučili.

Víceznakové příkazy jako C-x C-s a (pokud nemáte META, EDIT ani ALT
klávesu) <ESC>v jsou po C-h c povoleny také.

K získání více informací o příkazu místo C-h c použijte C-h k.

>> Stiskněte C-h k C-p.

To zobrazí dokumentaci k funkci a její jméno v emacsovém okně.  Až
výstup přečtete, stiskněte C-x 1, abyste se textu nápovědy zbavili.
Nemusíte to dělat hned.  Můžete chvíli editovat a nahlížet do textu
nápovědy a teprve pak stisknout C-x 1.

Zde jsou další užitečné C-h volby:

   C-h f	Popis funkce.  Zadáváte jméno funkce.

>> Zkuste napsat C-h f previous-line<Return>.
   To vypíše veškeré informace, které Emacs má o funkci implementující
   příkaz C-p.

Podobný příkaz C-h v zobrazí dokumentaci proměnné, jejíž hodnotu
můžete nastavit a změnit tím chování Emacsu.  Jméno proměnné zadáte, až
se na ně Emacs zeptá.

   C-h a	Příkazové apropos.  Zadejte klíčové slovo a Emacs vypíše
		všechny příkazy, jejichž jména obsahují toto klíčové
		slovo.  Všechny tyto příkazy mohou být vyvolány pomocí
		META-x.  Pro některé příkazy příkazové apropos vypíše
		také jedno nebo dvouznakové sekvence, které provádějí
		tentýž příkaz.

>> Napište C-h a file<Return>.

To zobrazí v druhém okně seznam všech M-x příkazů obsahujících "file" ve
svém názvu.  Znakové příkazy jako C-x C-f uvidíte vypsané vedle
odpovídajících jmen příkazů jako find-file.

>> Stiskněte C-M-v pro posun okna s nápovědou.  Proveďte to několikrát.

>> Stiskněte C-x 1 pro smazání okna s nápovědou.

   C-h i	Čtení on-line manuálů (též Info).  Tento příkaz
		vás přepne do speciálního bufferu s názvem "*info*",
		ve kterém můžete číst on-line manuály pro balíky
		nainstalované na vašem systému.  Pokud stisknete
		m emacs <Return> můžete si například přečíst manuál
		k Emacsu.  Pokud jste dosud nikdy nepoužívali Info,
		stiskněte ? a Emacs vám představí hlavní možnosti
		módu pro Info.  Až si tyto možnosti prostudujete,
		měli byste používat Info manuál Emacsu jako svoji
		primární dokumentaci.


* ZÁVĚR
-------

Nezapomeňte, Emacs ukončíte provedením příkazu C-x C-c.  Pro dočasný
odskok do shellu, ze kterého se do Emacsu můžete opět vrátit,
použijte C-z.

Záměrem tohoto tutoriálu je být srozumitelný všem novým uživatelům, takže
narazíte-li na něco nejasného, tak neusedejte a neklaďte to za vinu sobě
-- stěžujte si!


KOPÍROVÁNÍ
----------

Tento tutoriál vychází z dlouhé řady emacsových tutoriálů zahájené
tutoriálem napsaným Stuartem Cracraftem pro původní Emacs.

Tato verze tutoriálu je, podobně jako GNU Emacs, chráněna copyrightem a
je šířena se svolením distribuovat kopie za jistých podmínek:

Copyright (C) 1985, 1996, 1998, 2001-2014 Free Software Foundation, Inc.

   Každému je zaručeno právo vytvářet a distribuovat přesné kopie tohoto
   dokumentu tak, jak jej obdržel, na jakémkoliv médiu, s tím, že bude
   zachována tato poznámka o autorství a poznámka o svolení a že
   distributor zaručuje příjemci právo na další redistribuci povolenou
   touto poznámkou.

   Je zaručeno právo distribuovat modifikované verze tohoto dokumentu
   nebo jeho částí pod výše uvedenými podmínkami za předpokladu, že
   obsahuje jasné poznámky uvádějící, kdo provedl poslední modifikace.

Podmínky pro kopírování Emacsu samotného jsou složitější, avšak ve
stejném duchu.  Přečtěte si prosím soubor COPYING a pak předávejte kopie
GNU Emacsu svým přátelům.  Pomáhejte potírat softwarovou obstrukci
("vlastnictví") používáním, psaním a sdílením free softwaru!

;;; Local Variables:
;;; coding: utf-8
;;; End:
