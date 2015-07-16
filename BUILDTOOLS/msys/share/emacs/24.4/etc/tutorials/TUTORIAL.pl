Krótki samouczek Emacsa.  Warunki kopiowania znajdują sie na końcu pliku.

Polecenia Emacsa wymagają na ogół wciśnięcia klawisza CONTROL (oznaczanego
czasami Ctrl lub CTL) lub klawisza META (oznaczanego czasami EDIT
albo ALT). Dalej będziemy stosować następujące skróty:

C-<znak> oznacza przytrzymanie klawisza CONTROL przy naciskaniu
	klawisza <znak>. Na przykład C-f będzie odpowiadało
	naciśnięciu f przy wciśniętym klawiszu CONTROL.
M-<znak> oznacza przytrzymanie klawisza META lub ALT przy naciskaniu
	klawisza <znak>. Zamiast tego można nacisnąć i puścić klawisz
	ESC, a potem nacisnąć klawisz <znak>.

Uwaga: aby zakończyć sesję Emacsa, naciśnij C-x C-c (kolejno dwa znaki).
Znaki ">>" na lewym marginesie oznaczają w dalszej części tego samouczka
ćwiczenia dla Ciebie. Na przykład:
<<Blank lines inserted around following line by help-with-tutorial>>
[Dodatkowe odstępy zostały zrobione w celach dydaktycznych.]
>> Teraz naciśnij C-v (następny ekran), aby przejść na następny ekran
   samouczka (zrób to naciskając jednocześnie klawisze CONTROL i v).
   Od tego momentu powinieneś robić to zawsze, gdy dojdziesz
   do końca ekranu.

Zwróć uwagę na to, że kilka linii się powtarza, gdy przechodzisz z
ekranu na następny; ma to zapewnić wrażenie ciągłości podczas przesuwania
się w obrębie pliku.

Pierwszą umiejętnością, która powinieneś opanować, jest sposób
przesuwania się z miejsca na miejsce. Wiesz już, jak przesuwać się
o jeden ekran do przodu. Aby przesunąć się o jeden ekran do tyłu,
wciśnij kombinację klawiszy M-v (to znaczy wciśnij i przytrzymaj
klawisz META lub Alt i jednocześnie naciśnij v albo naciśnij kolejno
klawisze <ESC> v, jeśli nie masz klawisza META lub Alt).

>> Spróbuj nacisnąć M-v, a potem C-v, by przesunąć się w przód i w tył
   kilka razy.


PODSUMOWANIE
------------

Następujące polecenia służą do przeglądania tekstu po jednym ekranie:

	C-v Przesuń się o jeden ekran do przodu
	M-v Przesuń się o jeden ekran do tyłu
	C-l Wyczyść ekran i wyświetl go na nowo, umieszczając
	tekst z okolic kursora w środku ekranu.
	(Ta kombinacja to CONTROL-L, a nie CONTROL-1.)

>> Znajdź kursor i zapamiętaj, jaki tekst jest w jego pobliżu.
   Naciśnij następnie C-l.
   Znajdź kursor jeszcze raz i zwróć uwagę, że znajduje się on
   w pobliżu tego samego tekstu.

Możesz także użyć klawiszy PageUp i PageDn, jeśli są dostępne na
Twojej klawiaturze, do przemieszczania się między stronami, ale użycie
C-v i M-v jest bardziej efektywne.

PODSTAWY KIEROWANIA KURSOREM
----------------------------

Przesuwanie się z ekranu na ekran jest użyteczne, ale jak przejść do
określonego miejsca w obrębie jednego ekranu?

Można to zrobić na kilka sposobów. Najprostszym jest użycie poleceń
C-p, C-b, C-f oraz C-n. Każde z nich przesuwa kursor o jeden wiersz
albo kolumnę w określonym kierunku. Oto schemat, który to obrazuje:

                 Poprzednia linia, C-p
                 (ang. previous line)
                         :
                         :
    Do tyłu, C-b .... Kursor .... Do przodu, C-f
             (ang. back) : (ang. forward)
                         :
                         :
                  Następna linia, C-n
                   (ang. next line)

>> Przesuń kursor na środek tego schematu za pomocą C-n lub C-p.
   Potem naciśnij C-l, by zobaczyć cały diagram na środku ekranu.

To są podstawowe polecenia kierujące położeniem kursora, których
będziesz używał bardzo często, warto więc je zapamiętać.

>> Naciśnij kilka razy C-n, by przesunąć kursor do tej linii.

>> Przesuń się w głąb linii za pomocą C-f, a potem do góry za pomocą
   C-p. Zwróć uwagę na zachowanie się C-p, gdy kursor jest w środku
   linii.

Każda linia tekstu kończy się znakiem nowej linii, który oddziela ją
od następnej. Każdy Twój plik powinien się kończyć znakiem nowej
linii (ale Emacs tego nie wymaga).

>> Spróbuj nacisnąć C-b na początku linii. Powinno Cię to przenieść
   na koniec poprzedniej linii. Dzieje się tak dlatego, że kursor
   przechodzi wówczas nad znakiem nowej linii.

C-f przechodzi nad znakiem nowej linii tak samo jak C-b.

>> Naciśnij kilka razy C-b i obserwuj położenie kursora.
   Naciskaj potem C-f, by wrócić na koniec linii. W końcu naciśnij
   jeszcze raz C-f, by przejść do następnej linii.

Gdy przesuwasz kursor poza dolną krawędź ekranu, tekst położony
za krawędzią przesuwa się na ekran (ang. scrolling). Dzięki temu
Emacs może przesunąć kursor do określonego miejsca bez umieszczania
go poza ekranem.

>> Spróbuj przesunąć kursor poza dolną granicę ekranu za pomocą C-n
   i zobacz, co się stanie.

Jeśli przesuwanie się o jeden znak na raz jest dla Ciebie zbyt wolne,
to spróbuj przesuwać się o słowa. M-f (Meta-f) przesuwa kursor o słowo
do przodu, a M-b przesuwa go o słowo do tyłu.

>> Naciśnij kilka razy M-f i M-b.

Gdy jesteś w środku słowa, to M-f przesuwa kursor na jego koniec.
Jeśli natomiast jesteś w przerwie miedzy słowami, to M-f przesuwa
kursor na koniec następnego słowa. M-b zachowuje się podobnie
dla ruchu do tyłu.

>> Naciśnij M-f i M-b kilka razy na przemian z C-f i C-b, tak byś
   mógł zauważyć działanie M-f i M-b naciśniętych w różnych miejscach
   wewnątrz i między słowami.

Zauważ podobieństwo między C-f i C-b oraz M-f i M-b. Bardzo często
kombinacje zawierające Meta (Alt) oznaczają operacje związane
z jednostkami językowymi (słowa, zdania, akapity), podczas gdy
kombinacje z klawiszem Control działają na jednostkach podstawowych,
niezależnych od tego, co edytujesz (znaki, linie, itd.).

Oto zależność, która stosuje się do linii i zdań: C-a i C-e przesuwają
kursor na początek i koniec linii, a M-a i M-e przesuwają go na początek
i koniec zdania.

>> Naciśnij kilka razy C-a, a potem kilka razy C-e.
   Powtórz to z M-a, a potem z M-e.

Czy zauważyłeś, że powtarzanie C-a nic nie zmienia, natomiast powtórne
M-a przesuwa Cię o jedno zdanie? Chociaż nie ma tu pełnej analogii,
wydaje się to jednak naturalne.

Położenie kursora w tekście jest określane mianem "punktu".

Oto podsumowanie prostych poleceń służących do przesuwania kursora,
włącznie z operacjami dotyczącymi słów i zdań:

	C-f Do przodu o jeden znak
	C-b Do tyłu o jeden znak

	M-f Do przodu o słowo
	M-b Do tyłu o słowo

	C-n Następna linia
	C-p Poprzednia linia

	C-a Początek linii
	C-e Koniec linii

	M-a Do tyłu na początek zdania
	M-e Do przodu na koniec zdania

>> Przećwicz kilka razy dla wprawy wszystkie powyższe polecenia.
   Należą one do najczęściej używanych.

Dwa inne ważne polecenia przesuwające kursor to M-< (Meta lub Alt
i znak mniejszości), które przesuwa kursor na początek całego tekstu
i M-> (Meta lub Alt i znak większości), które przesuwa kursor na koniec
całego tekstu.

Na większości klawiatur "<" jest nad przecinkiem, musisz więc użyć
klawisza Shift, by nacisnąć "<", i podobnie musisz użyć klawisza Shift,
by nacisnąć M-<. Bez Shift uzyskałbyś M-przecinek.

>> Naciśnij M-<, by przejść na początek samouczka, a potem kilka razy
   użyj C-v, by powrócić do tego miejsca.

>> Teraz naciśnij M->, by przejść na koniec samouczka, i wróć do tego
   miejsca za pomocą kilkakrotnego M-v.

Jeśli Twoja klawiatura ma klawisze strzałek, to możesz ich użyć do
przesuwania kursora. Radzimy Ci nauczyć się się kombinacji C-b, C-f,
C-n i C-p z trzech powodów. Po pierwsze, działają one na wszystkich
typach terminali. Po drugie, gdy już zdobędziesz pewną praktykę w
posługiwaniu się Emacsem, to będzie Ci szybciej nacisnąć te kombinacje
niż klawisze strzałek (ponieważ nie wymaga to przenoszenia dłoni z
miejsca, które zajmują podczas szybkiego pisania za pomocą 10 palców).
Po trzecie wreszcie, gdy już wyrobisz sobie zwyczaj posługiwania się
tymi poleceniami z klawiszem Control, to łatwo przyjdzie Ci nauczyć się
bardziej zaawansowanych poleceń przesuwających kursor.

Większość poleceń Emacsa akceptuje argument liczbowy; dla większości
poleceń oznacza on liczbę powtórzeń. Aby określić liczbę powtórzeń
polecenia, powinieneś je poprzedzić naciśnięciem C-u a potem cyfr.
Jeśli masz na klawiaturze klawisz META (lub EDIT albo ALT), to
alternatywnym sposobem wprowadzenia argumentu liczbowego jest użycie
tego klawisza i wciskanie cyfr argumentu. Radzimy jednak przyswoić
sobie metodę z klawiszem C-u, ponieważ działa ona na wszystkich
terminalach.

Na przykład C-u 8 C-f przesuwa kursor do przodu o osiem znaków.

>> Spróbuj użyć C-n i C-p z argumentem liczbowym, by przesunąć kursor
   do jednej z linii w pobliżu tego zdania za pomocą tylko jednego
   polecenia.

Większość poleceń używa argumentu liczbowego jako liczby powtórzeń.
Jest kilka poleceń, które używają go w inny sposób. Do takich wyjątków
należą C-v i M-v. Jeśli poda się im argument, to przesuwają zawartość
ekranu w górę lub w dół o podaną liczbę linii zamiast o tyleż ekranów.
Na przykład C-u 4 C-v przewija ekran o 4 linie.

>> Spróbuj nacisnąć C-u 8 C-v.

To powinno było przewinąć ekran do góry o 8 linii. Jeśli chciałbyś
przewinąć ekran w dół, to powinieneś podać argument przed poleceniem M-v.

Jeśli pracujesz w systemie z okienkowym trybem graficznym, jak X11
lub MS-Windows, to prawdopodobnie po lewej stronie okna Emacsa znajduje
się prostokątny obszar nazywany po angielsku "scrollbar", a po polsku
suwakiem. Za jego pomocą możesz przewijać tekst, używając do tego myszy.

>> Spróbuj nacisnąć środkowy klawisz myszy u góry podświetlonego
   obszaru na suwaku. To powinno przewinąć tekst do miejsca
   określonego przez wysokość, na której nacisnąłeś klawisz myszy.

>> Przesuń mysz do miejsca oddalonego od górnego końca suwaka o mniej
   więcej trzy linie i naciśnij lewy klawisz myszy kilka razy.


* GDY EMACS JEST ZABLOKOWANY
----------------------------

Jeśli Emacs przestaje odpowiadać na Twoje polecenia, to możesz go
bezpiecznie zatrzymać, przyciskając C-g. Klawisza C-g możesz też użyć do
przerwania polecenia, które zabiera zbyt wiele czasu.

Możesz także użyć C-g do anulowania argumentu liczbowego albo początku
polecenia, którego nie zamierzasz dokończyć.

>> Napisz C-u 100 jako argument liczbowy, po czym naciśnij C-g.
   Teraz naciśnij C-f. Powinno to przesunąć kursor zaledwie o
   jeden znak, ponieważ argument liczbowy anulowałeś za pomocą C-g.

Za pomocą klawisza C-g możesz też anulować skutki omyłkowego
wciśnięcia klawisza <ESC>.


* ZABLOKOWANE POLECENIA
-----------------------

Pewne polecenia Emacsa są „zablokowane” -- po to, by początkujący
użytkownicy nie mogli ich wywołać przez przypadek.

Jeśli wywołasz jedno z zablokowanych poleceń, to Emacs wypisze komunikat
informujący o tym, co to za polecenie, i zapyta Cię, czy istotnie chcesz
je wywołać.

Jeśli naprawdę chcesz wywołać to polecenie, to odpowiedz na pytanie,
naciskając spację. Jeśli nie chcesz wywołać zablokowanego polecenia,
to na pytanie odpowiedz, naciskając n.

>> Napisz „C-x C-l” (co jest zablokowanym poleceniem) i odpowiedz n
   na zadane pytanie.


* OKNA
------

Emacs może mieć otwartych kilka okien, z których każde wyświetla
własny tekst. Pojęcie „okna”, jeśli chodzi o Emacsa, nie odnosi
się do osobnego okienka systemu okienkowego, lecz do pojedynczego
panelu wewnątrz okienka systemowego. (Emacs może też pracować
na kilku oknach systemowych (X-oknach); w terminologii Emacsa
nazywają się one ramkami. Opisane jest to poniżej.)

Na tym etapie lepiej jest się nie zagłębiać w techniki wykorzystujące
kilka okien. Powinieneś jedynie wiedzieć, w jaki sposób pozbyć się
nadmiaru okien, które mogą się pojawić w wyniku wywołania Emacsowego
systemu pomocy albo niektórych poleceń. Robi się to w prosty sposób:

	C-x 1 Jedno okno (tzn. zlikwiduj wszystkie pozostałe okna).

Kombinacja ta to klawisz Control-x, po którym występuje cyfra 1.
Powiększa ona okno, w którym jest kursor tak, by wypełniło ono ekran,
kasując zarazem pozostałe okna Emacsa.

>> Przesuń kursor do tej linii i naciśnij C-u 0 C-l.

(C-l, jak pamiętasz odświeża zawartość ekranu. Jeśli temu poleceniu
poda się argument liczbowy, to będzie to oznaczało „odśwież zawartość
ekranu i umieść bieżąca linię o tyle linii od góry ekranu”. Tak więc,
C-u 0 C-1 oznacza „odśwież ekran, umieszczając bieżąca linię na samej
górze”.)

>> Naciśnij Control-x 2
   Zauważ, że okno się kurczy, a jednocześnie pojawia się nowe,
   wyświetlające ten sam tekst.

>> Naciśnij C-x 1, a nowe okno zniknie.


* WSTAWIANIE I USUWANIE
-----------------------

Jeśli chcesz wstawić nowy tekst, to po prostu go napisz. Znaki, które da
się wyświetlić, takie jak A, 7, *, itd., Emacs traktuje jako tekst i
natychmiast wstawia do dotychczasowego tekstu. Aby wstawić znak nowej
linii, trzeba nacisnąć klawisz <Return> (na maszynach do pisania tak
oznaczało się znak powrotu karetki).

Ostatnio napisany znak możesz skasować, naciskając klawisz <Delback>.
Chodzi tu o klawisz, którego normalnie używasz do skasowania ostatnio
napisanego znaku. Na większości klawiatur wyróżnia się on wielkością,
leży nad klawiszem <Return> i jest oznaczony napisem "Delete", "Del"
albo "Backspace".

Jeśli masz na klawiaturze klawisz oznaczony "Backspace", to właśnie on
jest wspomnianym <Delback>. Oprócz niego może jeszcze występować
klawisz oznaczony słowem "Delete", ale to nie on pełni rolę <Delback>.

Mówiąc bardziej ogólnie, <Delback> usuwa znak bezpośrednio
poprzedzający bieżącą pozycję kursora.

>> Sprawdź to teraz: wstaw kilka znaków, po czym usuń je, kilka razy
   naciskając <Delback>. Nie martw się, że zmieniasz w ten sposób
   niniejszy plik, w istocie nie zmieniasz głównego pliku samouczka.
   Pracujesz teraz na jego kopii.

Gdy linia tekstu staje się zbyt długa, by zmieścić się w jednym
wierszu ekranu, to jest ona „kontynuowana” w wierszu następnym.
Znak „backslash” („\”) (albo - jeśli pracujesz w okienkowym
trybie graficznym - zagięta strzałka) umieszczony na prawym marginesie
wskazuje, że dana linia jest kontynuowana w następnym wierszu ekranu.

>> Wpisuj jakiś tekst tak długo, aż dojdziesz do prawego marginesu, i
   potem nie przestawaj. Zauważysz, że pojawi się linia kontynuacji.

>> Użyj klawisza <Delback>, by usunąć znaki tekstu, tak by linia znowu
   mieściła się na ekranie; linia kontynuacji zniknie.

Znak nowej linii można skasować tak jak każdy inny znak. Usunięcie znaku
nowej linii między dwiema liniami spowoduje ich połączenie. Jeśli powstała
w wyniku tego linia tekstu jest zbyt długa, by zmieścić się na szerokość
ekranu, to zostanie wyświetlona z linią kontynuacji.

>> Przesuń kursor na początek linii i naciśnij <Delback>. Bieżąca
   linia zostanie połączona z poprzednią.

>> Naciśnij <Return>, by z powrotem wstawić znak nowej linii, który
   skasowałeś.

Jak już wiesz, większość poleceń Emacsa można wywołać z parametrem
liczby powtórzeń; dotyczy to także znaków tekstu. Argument liczbowy
powoduje wstawienie znaku odpowiadającą mu liczbę razy.

>> Wypróbuj to teraz -- naciśnij C-u 8 *, a uzyskasz ********.

Nauczyłeś się już większej części podstawowych sposobów pisania oraz
poprawiania błędów. W Emacsie możesz usuwać również całe słowa lub
linie. Oto podsumowanie operacji usuwania znaków:

	<Delback> usuń znak bezpośrednio przed kursorem
	C-d usuń znak bezpośrednio za kursorem

	M-<Delback> wytnij słowo bezpośrednio przed kursorem
	M-d wytnij słowo bezpośrednio za kursorem

	C-k wytnij zawartość linii od kursora do jej końca
	M-k wytnij wszystkie znaki od kursora do końca zdania

Warto zauważyć, że stosunek <Delete> i C-d do M-<Delete> i M-d
rozszerza analogię występującą w zestawieniu C-f i M-f (<Delete> tak
naprawdę nie jest znakiem sterującym, ale nie jest to tutaj
istotne). C-k i M-k są podobne do C-e i M-e w tym sensie, że linie są
odpowiednikami zdań.


Oto metoda wycinania części tekstu. Umieść kursor na początku fragmentu,
który chcesz wyciąć, i naciśnij C-@ lub C-SPC (SPC-spacja). Teraz przejdź
na drugi koniec wybranego fragmentu i naciśnij C-w. To wytnie cały tekst
zawarty między punktami początkowym i końcowym.

>> Przesuń kursor na literę O na początku poprzedniego paragrafu.

>> Naciśnij C-SPC. Emacs wyświetli "Mark set" (znacznik ustawiony)
   na dole ekranu.

>> Przesuń kursor do litery o w słowie „kursor” w drugim zdaniu.

>> Naciśnij C-w. Ta komenda wytnie cały fragment zaczynający się od O,
   a kończący tuż przed o.

Gdy usuwasz więcej niż jeden znak naraz, Emacs zachowuje usunięty
tekst po to, by mógł go z powrotem gdzieś wstawić. Wstawianie
usuniętego tekstu nazywa się „wklejaniem”. Usunięty tekst
możesz wkleić zarówno w to samo miejsce, z którego został usunięty,
bądź też w inne miejsca. Ten sam tekst możesz wkleić wielokrotnie,
w celu uzyskania wielu kopii. Poleceniem wklejenia tekstu jest C-y.

Zauważ różnicę między „wycinaniem” i „usuwaniem”, polegającą na tym,
że rzeczy wycięte można na nowo wklejać, usuniętych natomiast wklejać nie
można. Na ogół polecenia Emacsa, które kasują dużo tekstu, zachowują go,
podczas gdy polecenia, które po prostu kasują jeden znak albo puste
linie lub odstępy, skasowanego tekstu nie zachowują.

>> Przesuń kursor na początek linii, która nie jest pusta. Naciśnij
   C-k, by wyciąć tekst z tej linii.

>> Naciśnij C-k jeszcze raz. Zauważ, że wycina to znak nowej linii,
   który znajduje się za ta linią.

Zwróć uwagę, że pojedyncze C-k wycina zawartość linii, a powtórne C-k
wycina samą linię, tak że pozostałe linie przesuwają się do góry. C-k
traktuje argument liczbowy w sposób specjalny: wycina ono tyle linii,
ile wynosi wartość argumentu, ORAZ ich zawartość. To nie jest jedynie
powtórzenie kilka razy C-k. C-u 2 C-k wycina dwie linie wraz z ich
znakami nowej linii; dwukrotne naciśniecie C-k nie zrobiłoby tego.

By odzyskać ostatnio wycięty tekst i wstawić go w miejsce kursora,
naciśnij C-y.

>> Twoja kolej. Naciśnij C-y, by z powrotem wstawić tekst.

Zwróć uwagę, że jeśli naciśniesz C-k kilka razy z rzędu, to cały wycięty
tekst zostanie zachowywany w jednym kawałku, tak że pojedyncze C-y wklei
wszystkie linie.

>> Naciśnij C-k kilka razy.

A by odzyskać ten wycięty tekst...

>> ...naciśnij C-y. Przesuń potem kursor o kilka linii w dół i
   naciśnij C-y jeszcze raz. Widzisz, że wstawia to ten sam tekst.

Co zrobić, jeśli chcesz wstawić tekst, który wcześniej wyciąłeś,
a potem wycinasz coś innego? C-y wstawia tekst ostatnio wycięty.
Poprzedni fragment nie jest jednak stracony. Możesz do niego wrócić,
używając polecenia M-y. Naciskając C-y, wstawiasz tekst ostatnio
wycięty, a naciskając M-y, zastępujesz ten tekst wyciętym uprzednio.
Dalsze naciskanie M-y przywołuje coraz wcześniejsze fragmenty tekstu.
Gdy dojdziesz do tekstu, którego szukałeś, po prostu kontynuuj edycję
tekstu, pozostawiając wklejony tekst tam, gdzie się znajduje.

Naciskając M-y wystarczająco wiele razy, dojdziesz do punktu,
z którego wystartowałeś (czyli tekstu wyciętego ostatnio).

>> Wytnij jakąś linię, zmień pozycję kursora i wytnij inną. Naciśnij
   potem C-y, by wstawić drugą z wyciętych linii. Potem naciśnij M-y
   i linia ta zostanie zastąpiona przez tą pierwszą. Naciśnij M-y
   jeszcze kilka razy, by zobaczyć, co się dzieje. Powtarzaj to aż
   do ponownego pojawienia się drugiej z linii. Możesz też wypróbować,
   co się stanie, gdy polecenie M-y poprzedzisz argumentem dodatnim
   albo ujemnym.


* COFNIJ
--------

Jeśli wprowadzisz zmiany do tekstu, a potem dojdziesz do wniosku, że
to była pomyłka, to możesz cofnąć zmiany, wydając polecenie „cofnij”
(ang. undo), C-x u.

C-x u cofa zmiany wprowadzone przez jedno polecenie; jeśli powtórzysz
C-x u kilka razy z rzędu, to każde powtórzenie cofa kolejne polecenie.

Od tej reguły są dwa wyjątki: polecenia, które nie zmieniają tekstu nie
liczą się jako polecenia, które można wycofać (dotyczy to zarówno
przesunięć kursora, jak i przewijania tekstu), oraz znaki wstawiane do
tekstu (np. litery) łączone są w grupy do 20. (Redukuje to liczbę
naciśnięć C-x u, które musiałbyś wykonać, by wycofać się z niechcianych
zmian.)

>> Wytnij tę linię za pomocą C-k, a potem naciśnij C-x u; linia
   powinna się pojawić ponownie.

C-_ jest innym sposobem wywołania polecenia "cofnij"; działa to
dokładnie tak samo jak C-x u, jest jednak łatwiejsze do naciśnięcia
kilka razy z rzędu. Wadą kombinacji C-_ jest to, że nie jest oczywiste
w jaki sposób ją uzyskać na niektórych klawiaturach. To właśnie dlatego
dostępna jest też kombinacja C-x u. Na niektórych terminalach możesz
nacisnąć C-_ poprzez przytrzymanie Ctrl i naciśnięcie /.

Argument liczbowy podany przed C-_ lub C-x u określa liczbę powtórzeń
tego polecenia.


* PLIKI
-------

Aby edytowany przez Ciebie tekst został na trwałe zachowany, musisz
umieścić go w pliku. Jeśli tego nie zrobisz, to tekst zniknie, gdy
zamknięty zostanie Emacs, za pomocą którego go edytowałeś. Aby zachować
tekst w pliku, najpierw musisz ten plik „znaleźć”, i to zanim
zaczniesz wprowadzać tekst. Czynność znajdowania pliku (ang. "file
finding") bywa też nazywana „odwiedzaniem pliku” (ang. "file
visiting").

Odwiedzanie pliku w Emacsie powoduje wyświetlenie jego zawartości.
Bardzo często jest to początek edycji pliku. Jednakże zmiany, które
wprowadzasz do pliku, nie są w nim utrwalone, zanim go nie „zachowasz”
(ang. save). Ma to zapobiec pozostawieniu w systemie pliku, który został
zmieniony tylko w połowie, a tego chcesz uniknąć. Gdy zachowujesz
zmieniony plik, Emacs zostawia oryginał (pod inna nazwą) na wypadek,
gdybyś doszedł do wniosku, że wprowadzone zmiany były błędne.

Jeśli popatrzysz na dół ekranu, to zauważysz linię, która zaczyna się
i kończy myślnikami, a zawiera tekst „TUTORIAL”. W tej
części ekranu zawsze możesz znaleźć nazwę pliku, który właśnie
odwiedzasz. W tej chwili odwiedzasz plik o nazwie TUTORIAL, który
jest Twoją własną kopią samouczka Emacsa. Obojętnie, który plik
odwiedzisz, właśnie w tym miejscu pojawi się jego nazwa.

Polecenia służące do odwiedzania i zachowywania plików różnią się
od innych poleceń, które już poznałeś, tym, że składają się z dwóch
znaków. Obydwa zaczynają się od znaku Control-x. Jest mnóstwo
poleceń, które zaczynają się od tego właśnie znaku; wiele z nich
dotyczy plików, buforów oraz rzeczy z nimi związanych. Polecenia
te mają długość dwóch, trzech lub czterech znaków.

Kolejną nowością odnośnie polecenia odwiedzania pliku jest to, że
musisz mu podać nazwę pliku, który chcesz znaleźć. Mówimy o tym, że
polecenie „czyta argument z terminala” (w tym wypadku argument jest
nazwą pliku). Po wpisaniu polecenia

	C-x C-f znajdź plik (ang. find a file)

Emacs poprosi Cię o wpisanie nazwy pliku. Pojawia się ona w dolnej linii
ekranu. Gdy ta linia jest używana do wprowadzania tego typu danych,
nazywa się ją „minibuforem” (ang. "minibuffer"). Do edycji nazwy pliku
w minibuforze możesz używać zwykłych poleceń Emacsa.

Wprowadzanie nazwy pliku (lub jakichkolwiek innych danych w
minibuforze) można anulować klawiszem C-g.

>> Naciśnij C-x C-f, po czym naciśnij C-g. Na skutek tego zniknie
   minibufor oraz przerwane zostanie wykonanie polecenia C-x C-f, które
   tego minibufora używało. W rezultacie nie odwiedzisz żadnego pliku.

Gdy skończysz wpisywać nazwę pliku, naciśnij <Return>. Wówczas
polecenie C-x C-f zabierze się do roboty i znajdzie plik, który
wybrałeś. Z chwilą zakończenia wykonywania polecenia C-x C-f
zniknie też minibufor.

Zawartość znalezionego pliku po chwili pojawia się na ekranie
i możesz ją edytować. Gdy chcesz zachować zmiany, by je utrwalić,
wydaj polecenie

	C-x C-s zachowaj plik (ang. save).

Kopiuje to tekst z Emacsa do pliku. Za pierwszym razem, gdy to
robisz, Emacs zmienia nazwę oryginalnego pliku, dodając na
końcu jego nazwy znak ~. W ten sposób powstaje zapasowa kopia
oryginalnego pliku.

Gdy zachowywanie pliku się kończy, Emacs wypisuje jego nazwę u dołu
ekranu. Pliki powinieneś zachowywać stosunkowo często, aby nie stracić
za dużo w wypadku załamania systemu.

>> Naciśnij C-x C-s, by zachować dla siebie kopię samouczka. Emacs
   powinien wypisać "Wrote ...TUTORIAL" na dole ekranu.

Odwiedzić w celu edycji lub odczytu możesz plik istniejący już w
systemie. Możesz też odwiedzić plik, którego jeszcze nie ma w systemie i
właśnie w taki sposób tworzy się w Emacsie nowe pliki. Gdy poleceniem
C-x C-f odwiedzisz plik o nazwie nieistniejącej w systemie, wówczas
Emacs wyświetli puste miejsce, do którego będziesz mógł zacząć wpisywać
tekst. Gdy zażądasz zachowania wpisanego tekstu, Emacs utworzy w
systemie plik z tym tekstem. Od tego momentu możesz uważać, że edytujesz
plik już istniejący.


* BUFORY
--------

Jeśli za pomocą C-x C-f odwiedzisz inny plik, to plik odwiedzony
poprzednio pozostanie w Emacsie. Możesz się na niego przełączyć,
odwiedzając go jeszcze raz za pomocą C-x C-f. W ten sposób możesz
mieć w Emacsie odwiedzonych jednocześnie wiele plików.

>> Utwórz plik o nazwie "foo" za pomocą C-x C-f foo <Return>.
   Wpisz w niego jakiś tekst i zachowaj "foo" za pomocą C-x C-s.
   W końcu napisz C-x C-f TUTORIAL <Return>, by wrócić do samouczka.

Emacs przechowuje tekst każdego pliku w obiekcie, zwanym „buforem”.
Odwiedzenie pliku powoduje utworzenie nowego bufora wewnątrz Emacsa. By
zobaczyć listę buforów, które istnieją w Twoim Emacsie, naciśnij

	C-x C-b lista buforów (ang. list buffers).

>> Naciśnij C-x C-b.

Zwróć uwagę, że każdy bufor ma własną nazwę, może też mieć skojarzoną z
nim nazwę pliku, który odwiedza. KAŻDY tekst, który oglądasz w Emacsie,
jest zawsze częścią jednego z buforów.

>> Naciśnij C-x 1 by pozbyć się listy buforów.

Jeśli masz kilka buforów to tylko jeden z nich jest aktualny, ten
który właśnie edytujesz. Jeśli chcesz edytować inny bufer musisz się
do niego "przełączyć" (ang. switch). Jeśli chcesz przełączyć się do
bufora, który odwiedza jakiś plik, możesz to zrobić poprzez ponowne
odwiedzenie pliku za pomocą C-x C-f. Ale istnieje także łatwiejszy
sposób: użyj C-x b. Używając tej komendy musisz podać nazwę bufora, do
którego zamierzasz się przełączyć.

>> Naciśnij C-x b foo <Return> by wrócić do bufora "foo", który
   przechowuje tekst pliku "foo". Następnie naciśnij C-x b TUTORIAL
   <Return> by wrócić do samouczka.

Zwykle nazwa bufora odpowiada nazwie pliku (bez ścieżki), choć czasami
zdarza się inaczej. Lista buforów, którą tworzysz za pomocą C-x C-b
pokazuje nazwy wszystkich buforów.

KAŻDY tekst, który pojawia się w oknie Emacsa jest częścią jakiegoś
bufora.  Niektóre bufory nie odpowiadają żadnemu odwiedzanemu
plikowi. Na przykład bufor "*Buffer List*" nie odwiedza żadnego pliku;
zawiera on listę buforów, utworzoną w reakcji na naciśnięcie przez
Ciebie C-x C-b. Bufor "*Messages*" także nie odwiedza żadnego pliku;
zawiera komunikaty, które pojawiały się podczas Twojej sesji z
Emacsem.

>> Naciśnij C-x b *Messages* <Return> by obejrzeć bufor zawierający
   komunikaty. Następnie naciśnij C-x b TUTORIAL <Return> by wrócić do
   samouczka.

Jeśli zmieniasz tekst w jakimś pliku, a potem odwiedzisz inny plik, to
zawartość tego pierwszego NIE jest automatycznie zachowywana. Zmiany,
które wprowadziłeś, pozostają w Emacsie, w buforze tegoż pliku.
Tworzenie czy edytowanie innego bufora nie ma żadnego wpływu na
pozostałe. Jest to bardzo przydatne, ale też oznacza, że potrzebny jest
Ci wygodny sposób zachowywania zawartości buforów. Niewygodne na
przykład byłoby, aby zawsze w celu zachowania bufora trzeba było do
niego przechodzić za pomocą C-x C-f i dopiero potem wywoływać C-x C-s.
Dlatego istnieje polecenie:

	C-x s Zachowaj bufory (ang. save some buffers)

W reakcji na polecenie C-x s Emacs dla każdego z buforów, w którym
występują nie zachowane do tej pory zmiany, zadaje pytanie, czy go
w tej chwili zachować.

>> Wstaw jakąś linię tekstu, a potem naciśnij C-x s.
   Powinieneś zostać zapytany o to, czy chcesz zachować bufor
   TUTORIAL. Odpowiedz na to pytanie twierdząco, naciskając y.


* ROZSZERZANIE ZESTAWU POLECEŃ
------------------------------

Poleceń Emacsa jest znacznie, znacznie więcej, niż można by skojarzyć
z klawiszami klawiatury, uwzględniając nawet kombinacje z META lub Ctrl.
Emacs radzi sobie z tym problemem, udostępniając polecenia X (ang.
eXtend). Istnieją dwa rodzaje tych poleceń:

	C-x Rozszerzenie o znak. Następuje po nim jeden znak.
	M-x Rozszerzenie o nazwane polecenie. Następuje po nim
	    pełna, niekiedy długa nazwa polecenia.

Polecenia te są użyteczne, ale używa się ich nie tak często, jak tych,
których już się nauczyłeś. Miałeś już okazję poznać dwa z nich: C-x C-f,
służące do odwiedzania plików, oraz C-x C-s do ich zachowywania. Innym
przykładem może być polecenie C-x C-c, które kończy sesję Emacsa. (Nie
martw się, że w ten sposób stracisz zmiany, które wprowadziłeś do
tekstów; przed zamknięciem sesji Emacs proponuje Ci zachowania
każdego ze zmodyfikowanych plików.)

C-z jest poleceniem, które wychodzi z Emacsa *na chwilę*, tak byś mógł
wrócić do niej wrócić po jakimś czasie.

W systemach, w których jest to możliwe, C-z zawiesza proces Emacsa;
powoduje to powrót do powłoki (ang. shell), ale nie niszczy Emacsa.
W najpopularniejszych powłokach możesz wrócić do Emacsa za pomocą
polecenia „fg” lub „%emacs”.

W systemach, w których nie ma zawieszania procesów, C-z tworzy proces
podpowłoki (ang. "subshell"), który działa pod Emacsem i daje Ci szansę
uruchamiania innych programów oraz powrotu do Emacsa po ich skończeniu; w
systemach tych C-z w istocie nie powoduje wyjścia z Emacsa i wówczas
normalnym poleceniem powrotu do Emacsa jest wyjście z podpowłoki za
pomocą polecenia "exit".

Polecenia C-x C-c powinieneś używać, gdy masz zamiar się wylogować.
Zalecane jest także wychodzenie z Emacsa wystartowanego na przykład przez
programy obsługujące pocztę elektroniczną lub innego rodzaju narzędzia,
ponieważ mogą one nie wiedzieć, jak sobie poradzić z zawieszeniem
Emacsa. Jednakże w zwykłych okolicznościach, jeśli nie musisz
wylogowywać się z systemu, korzystniej jest zawiesić Emacsa za pomocą
C-z, niż z niego wyjść.

Istnieje wiele poleceń zaczynających się od C-x. Oto lista tych,
których już się nauczyłeś:

	C-x C-f odwiedź plik
	C-x C-s zachowaj plik
	C-x C-b wyświetl listę buforów
	C-x C-c wyjdź z Emacsa
	C-x u cofnij

Poleceń podawanych za pomocą nazwy używa się jeszcze rzadziej lub używa
się tylko w niektórych trybach. Przykładem może być polecenie
replace-string, które zastępuje jeden łańcuch innym w całym tekście. Gdy
naciskasz M-x, Emacs czeka na dalszy ciąg polecenia, wyświetlając na
dole ekranu (w minibuforze) napis "M-x". Powinieneś tam wpisać nazwę
polecenia, w tym wypadku replace-string. Wystarczy przy tym, że napisz
jedynie repl s<Tab>; Emacs dokończy nazwę automatycznie. Wprowadzanie
nazwy zakończ naciśnięciem klawisza <Return>.

Polecenie replace-string wymaga dwóch argumentów: łańcucha, który ma
zostać zastąpiony, i łańcucha, który ma zostać wstawiony w miejsce tegoż.
Wpisywanie każdego z tych łańcuchów trzeba zakończyć przyciśnięciem
klawisza <Return>.

>> Przesuń kursor do czystej linii, dwie linie poniżej tej.
   Naciśnij M-x repl s<Return>zmieni<Return>zmodyfikuje<Return>.

   Zwróć uwagę, jak ta linia się zmieniła: zastąpiłeś słowem
   „zmodyfikuje” każde wystąpienie słowa z-m-i-e-n-i poniżej początkowej
   pozycji kursora.


* AUTOMATYCZNE ZACHOWYWANIE
---------------------------

Jeśli zmian wprowadzonych do pliku nie zachowasz, to możesz je stracić w
wypadku, gdy Twój komputer przestanie działać. By Cię przed tym
uchronić, Emacs okresowo zachowuje wprowadzone zmiany w specjalnym
pliku, który ma znak # na początku i na końcu swojej nazwy. Przyjmijmy
na przykład, że Twój plik nazywa się "hello.c". Odpowiadający mu plik
zachowywany automatycznie będzie nosił nazwę "#hello.c#". Gdy
zachowasz plik w zwykły sposób, Emacs skasuje plik
zachowany automatycznie.

Jeśli Twój komputer przestanie działać, możesz odzyskać Twoje dane z
pliku automatycznie zachowanego przez zwykłe odwiedzenie tego pliku,
który edytowałeś (a nie pliku automatycznie zachowanego!) i napisanie
M-x recover file<Return>. Gdy Emacs zapyta o potwierdzenie, to
dane zachowane automatycznie odzyskasz, jeśli odpowiesz yes<Return>.


* OBSZAR ECHA
-------------

Jeśli polecenia dla Emacsa wpisujesz dostatecznie wolno, będą one
pokazywane w specjalnym obszarze na dole ekranu, zwanym obszarem echa
(ang. echo area). Obszar echa zawiera ostatnią dolną linię ekranu.


* LINIA STANU
-------------

Linia, która znajduje się bezpośrednio nad obszarem echa, zwana jest
linią trybu (ang. modeline). Pokazuje ona tekst podobny do
następującego:

--:** TUTORIAL (Fundamental)--L670--58%----------------

Linia ta podaje użyteczne informacje o stanie Emacsa i tekstu, który
edytujesz.

Wiesz już, jakie jest znaczenie nazwy: oznacza ona plik,
który odwiedziłeś. --NN%-- informuje o bieżącej pozycji wewnątrz
tekstu; oznacza to, że NN procent tekstu znajduje się ponad górnym
brzegiem ekranu. Jeśli początek pliku znajduje się na początku
ekranu, to zamiast liczby --00%-- zobaczysz w tym miejscu --Top--.
Podobnie dla końca tekstu pojawi się tam napis --Bot-- (ang. bottom).
Jeśli wyświetlasz tekst na tyle krótki, że mieści się w
całości na ekranie, to linia trybu będzie zawierała napis --All--.

Litera L, po której występują cyfry, także opisuje Twoją bieżącą
pozycję: cyfry oznaczają numer linii, na której obecnie ustawiony jest
kursor.

Gwiazdki blisko początku linii trybu oznaczają, że wprowadziłeś do
tekstu jakieś zmiany. Tuż po odwiedzeniu, a także po zachowaniu pliku
nie będzie w tym miejscu gwiazdek, lecz myślniki.

Wewnątrz nawiasów znajdziesz informacje na temat trybu edycji, w
którym właśnie jest Emacs. Domyślnym trybem edycji nazywa się
podstawowym (ang. fundamental); jest to tryb używanym właśnie w
tej chwili. Jest to przykład „trybu głównego” (ang. major mode).

Emacs może działać w wielu trybach głównych. Zostały one zaprojektowane,
aby ułatwić edycję napisów w rozmaitych językach programowania, takich
jak tryb Lisp czy C, oraz rodzajach tekstów, jak tryb tekstowy. W danej
chwili może być aktywny tylko jeden główny tryb pracy i to jego nazwa
jest wyświetlana w linii trybu w miejscu, w którym teraz jest
"Fundamental".

Każdy z głównych trybów edycyjnych może zmienić zachowanie niektórych
poleceń. Na przykład w Emacsie istnieją polecenia służące do tworzenia
komentarzy w programach. Skoro każdy język programowania sam określa,
jak powinien wyglądać komentarz, to każdy z głównych trybów edycyjnych
musi wstawiać komentarze w odpowiedni sposób. Trybowi edycyjnemu
odpowiada nazwa polecenia, które możesz wykonać, by przełączyć się w ten
tryb lub go wyłączyć. Przykładem może być M-x fundamental-mode, które
jest poleceniem przełączającym tryb podstawowy.

Jeśli zamierzasz edytować tekst w języku angielskim, taki jak na
przykład oryginalna wersja tego samouczka, to prawdopodobnie
powinieneś użyć trybu tekstowego (ang. text mode).

>> Napisz M-x text-mode<Return>.

Nie musisz się martwić, bo żadne z poleceń, które do tej pory poznałeś,
nie zmienia Emacsa w poważny sposób. Możesz jednak zauważyć, że teraz
M-f i M-b traktują apostrofy jako części słów. Poprzednio, w trybie
podstawowym, polecenia te traktowały apostrofy jako separatory słów.

Główne tryby edycji wprowadzają zwykle subtelne zmiany, takie jak
opisana powyżej; większość poleceń nadal robi „to samo”, chociaż
być może w troszeczkę inny sposób.

By zobaczyć dokumentację na temat bieżącego głównego trybu edycji,
naciśnij C-h m.

>> Naciśnij C-u C-v raz lub więcej razy, tak by ta linia znalazła się
   blisko góry ekranu.

>> Naciśnij C-h m, by odczytać dokumentację na temat tego, czym tryb
   tekstowy różni się od trybu podstawowego.

>> Naciśnij q, by usunąć dokumentację trybu z ekranu.

Główne tryby edycji nazywają się właśnie „głównymi”, gdyż występują
także „podrzędne” tryby edycji (ang. minor modes). Podrzędne tryby
edycji nie są alternatywą dla trybów głównych, lecz jedynie ich
niewielką modyfikacją. Każdy podrzędny tryb edycji można włączyć lub
wyłączyć niezależnie od pozostałych trybów podrzędnych, a także
niezależnie od trybu głównego. Możesz wiec używać jednego,
kombinacji dowolnych, albo nie używać żadnego trybu podrzędnego.

Jednym z podrzędnych trybów edycji, który jest bardzo użyteczny,
szczególnie do edycji tekstu angielskiego lub polskiego, jest tryb
automatycznego wypełniania (ang. auto fill mode). Jeśli jest on
włączony, to Emacs łamie linie pomiędzy słowami automatycznie, gdy
podczas wstawiania tekstu linia robi się za szeroka.

Tryb automatycznego wstawiania włącza się na przykład poleceniem M-x
auto-fill-mode<Return>. Powtórzenie tego polecenie powoduje wyłączenie
trybu, ponowne powtórzenie --- jego włączenie, i tak dalej. Mówimy, że
polecenie „przełącza tryb”.

>> Napisz M-x auto-fill-mode<Return>. Wstaw potem wiele napisów
   „asdf ” tak długo, aż zobaczysz, że linia podzieli na dwie.
   Między literami musisz wstawiać spacje, ponieważ tryb
   automatycznego wypełniania łamie linie tylko tam, gdzie są spacje.

Margines jest zazwyczaj ustawiony na 70 znaków, ale możesz to zmienić
poleceniem C-x f. Powinieneś poleceniu podać argument liczbowy
mówiący, w której kolumnie ma zostać ustawiony margines.

>> Wywołaj C-x f z argumentem równym 20. (C-u 2 0 C-x f).
   Napisz potem jakiś tekst i zauważ, że Emacs wypełnia linie do
   długości co najwyżej 20 znaków. Ustaw margines z powrotem na
   70 znaków, wywołując jeszcze raz C-x f z odpowiednim argumentem.

Jeśli zmieniasz tekst wewnątrz akapitu, to tryb automatycznego
wypełniania sam z siebie nie wyrówna marginesu. Możesz go wyrównać
samodzielnie, wydając polecenie M-q (Meta-q) (kursor powinien się
wówczas znajdować wewnątrz akapitu).

>> Przesuń kursor do poprzedniego akapitu i naciśnij M-q.


* SZUKANIE
----------

Emacs potrafi szukać łańcuchów (zwartych ciągów znaków lub słów)
zarówno wstecz jak i do przodu. Szukanie łańcucha jest poleceniem,
które przesuwa kursor --- do następnego miejsca, w którym dany
łańcuch występuje.

Polecenie Emacsa "search" różni się od podobnych poleceń w innych
edytorach tym, że jest przyrostowe. Znaczy to, że szukanie odbywa
się w trakcie, gdy wpisujesz kolejne znaki łańcucha, który ma zostać
znaleziony.

Poleceniami rozpoczynającymi szukanie są: C-s dla szukania w przód
oraz C-r dla szukania wstecz. POCZEKAJ PROSZĘ! Nie próbuj ich w tej
chwili.

Gdy naciśniesz C-s, zauważysz, że w obszarze echa pojawi się
tekst "I-search". Jest to informacja, że Emacs znajduje się w trybie
"incremental search" i czeka, byś napisał tekst, który ma znaleźć.
Naciśnięcie <Return> kończy proces szukania.

>> Rozpocznij teraz szukanie, naciskając C-s. POWOLI, litera po
   literze, napisz słowo kursor, zatrzymując się po każdym znaku
   i obserwując, gdzie zatrzymuje się kursor. Gdy naciśniesz drugie
   r, będzie można powiedzieć, że szukałeś słowa kursor
   jednokrotnie. Naciśnij jeszcze raz C-s, by znaleźć następne
   wystąpienie słowa kursor. Naciśnij teraz cztery razy <Delback>
   i zobacz, co się dzieje z kursorem. Naciśnij <Return>, by skończyć
   szukanie.

Widziałeś, co się działo? Podczas szukania przyrostowego Emacs próbuje
przejść do miejsca wystąpienia łańcucha, który wpisałeś do tej pory,
i podświetla go dla Twojej wygody. By znaleźć następne wystąpienie
słowa kursor, po prostu jeszcze raz naciśnij C-s. Jeśli takiego
wystąpienia nie ma, to Emacs zapiszczy i napisze, że szukanie
„skończyło się porażką”.

Kombinacja C-g przerywa proces szukania, podobnie jak to czyni
z innymi poleceniami.

UWAGA: W niektórych systemach naciśniecie C-s zamraża ekran i w
rezultacie Emacs nie może pokazywać tekstu. Oznacza to, że składowa
systemu operacyjnego, zwana kontrolą przepływu (ang. "flow control"),
przechwyciła znak C-s i nie pozwoliła mu dotrzeć do Emacsa. By odzyskać
kontrolę nad ekranem, naciśnij C-q. Dodatkowej pomocy poszukaj w
rozdziale "Spontaneous Entry to Incremental Search" w podręczniku
Emacsa.

Jeśli podczas szukania przyrostowego naciśniesz <Delback>, to zauważysz,
że w minibuforze znika ostatni znak wpisanego przez ciebie łańcucha, a
kursor wraca do poprzedniego miejsca. Przypuśćmy na przykład, że
nacisnąłeś k i znalazłeś pierwsze wystąpienie tej litery. Jeśli teraz
naciśniesz u, to kursor przesunie się tuż za najbliższe litery
ku. Naciśnij teraz <Delback>. Spowoduje to skasowanie z wyszukiwanego
łańcucha litery u, a kursor wróci do pierwszego wystąpienia litery k.

Jeśli podczas szukania naciśniesz jakiś klawisz w kombinacji z META lub
Ctrl (z nielicznymi wyjątkami --- znakami, które mają specjalne
znaczenie podczas szukania, takimi jak C-s i C-r), to szukanie zostanie
przerwane.

C-s rozpoczyna proces szukania do przodu, czyli ZA bieżącą pozycją
kursora. Jeśli chcesz szukać czegoś położonego w tekście wcześniej,
to naciśnij C-r. Wszystko, co powiedzieliśmy o poleceniu C-s, stosuje
się też do C-r, oczywiście w odniesieniu do szukania wstecz.


* WIELE OKIEN
-------------

Jedną z użytecznych cech Emacsa jest możliwość wyświetlania więcej niż
jednego okna na raz.

>> Przesuń kursor do tej linii i naciśnij C-u 0 C-l.

>> Naciśnij teraz C-x 2, co podzieli ekran na dwa okna. Obydwa okna
   wyświetlają ten samouczek. Kursor pozostaje w górnym oknie.

>> Naciśnij C-M-v by przewinąć dolne okno. (Jeśli nie masz
   klawisza Meta lub Alt, to naciśnij ESC C-v.)

>> Naciśnij C-x o ("o" jak angielskie "other") by przesunąć kursor do
   dolnego okna. Użyj C-v i M-v w dolnym oknie, by przewinąć jego
   zawartość. Polecenia, które masz wykonać, odczytuj z górnego okna.

>> Naciśnij C-x o jeszcze raz tak, by kursor wrócił do górnego okna.
   Kursor w górnym oknie nie zmienił położenia.

Każde okno pamięta położenie swojego kursora, lecz w danej chwili
tylko jedno z okien wyświetla kursor. Wszystkie polecenia edycyjne
stosują się do okna, w którym jest kursor. To okno nazywane jest
„oknem wybranym”.

Polecenie C-M-v przyda Ci się, gdy będziesz chciał edytować tekst w
jednym oknie, a drugiego używał jako punktu odniesienia. Dzięki niemu
kursor może zawsze znajdować się w oknie, którego zawartość edytujesz, a
Ty możesz przesuwać drugie okno.

C-M-v to przykład kombinacji, który uzyskuje się, wciskając jednocześnie
klawisze Ctrl i Meta (Alt). Jeśli masz prawdziwy klawisz META (Alt), to
C-M-v możesz uzyskać przytrzymując jednocześnie Ctrl oraz META (Alt) i
naciskając v. Nie jest ważne, co zostało naciśnięte wcześniej, Ctrl czy
META, ponieważ obydwa te klawisze działają jako modyfikatory znaczenia
znaków.

Jeśli nie masz klawisza META (Alt) i w jego zastępstwie używasz ESC, to
kolejność naciskania klawiszy ma znaczenie: musisz najpierw nacisnąć i
puścić ESC, po czym nacisnąć Ctrl-v; kombinacja Ctrl-ESC v nie zadziała.
Wynika to z tego, że ESC jest znakiem, a nie modyfikatorem.

>> Naciśnij C-x 1 (w górnym oknie), by pozbyć się okna dolnego.

(Jeśli nacisnąłbyś C-x 1 w dolnym oknie, to górne by znikło. Możesz
sobie to polecenie tłumaczyć jako „pozostaw tylko jedno okno --- to w
którym właśnie jestem”.)

Nie musi być tak, że obydwa okna pokazują ten sam bufor. Jeśli użyjesz
C-x C-f, by odwiedzić jakiś plik w jednym z nich, to zawartość drugiego
się nie zmieni. Z zasady w różnych oknach możesz niezależnie wyświetlać
różne pliki.

Oto inny sposób używania dwóch okien do wyświetlania dwóch różnych
rzeczy:

>> Naciśnij C-x 4 C-f i nazwę jednego z Twoich plików. Zakończ
   wprowadzanie klawiszem <Return>. Podany plik pojawi się w dolnym
   oknie razem z kursorem, który tam przeskakuje.

>> Naciśnij C-x o, by wrócić do górnego okna, oraz C-x 1 by usunąć
   dolne okno.


* REKURSYWNE POZIOMY EDYCJI
---------------------------

Czasami możesz znaleźć się w czymś, co nazywa się "rekursywnym
poziomem edycji". Możesz to rozpoznać po nawiasach kwadratowych w
linii trybu, obejmujących nawiasy okrągłe zawierające nazwę głównego
trybu edycji. Mógłbyś na przykład zobaczyć [(Fundamental)] zamiast
(Fundamental).

By wyjść z rekursywnego poziomu edycji, naciśnij ESC ESC ESC. Jest to
ogólnego przeznaczenia polecenie „wychodzimy”. Możesz go użyć także,
by pozbyć się nadmiaru okien albo wyjść z minibufora.

>> Naciśnij M-x by wejść do minibufora, potem naciśnij ESC ESC ESC, by
   z niego wyjść.

Aby wyjść z rekursywnego poziomu edycji, nie wystarczy użyć C-g. Dzieje
się tak dlatego, że klawisz C-g jest używany do anulowania poleceń i
argumentów WEWNĄTRZ pojedynczego rekursywnego poziomu edycji.


SZUKANIE POMOCY
---------------

W tym samouczku dostarczyliśmy tylko tyle informacji, ile jest
niezbędne, byś mógł zacząć używać Emacsa. Emacs jest istną kopalnią
najróżniejszych rzeczy, których nie sposób tutaj opisać. Będziesz
zapewne chciał dowiedzieć się o Emacsie więcej, ponieważ posiada on
wiele pożytecznych cech, o których na razie nic nie wiesz. Między innymi
jest w nim zaszyte mnóstwo wewnętrznej dokumentacji. Dotrzeć do tej
dokumentacji możesz po naciśnięciu kombinacji C-h.

By uzyskać pomoc, naciśnij C-h, a potem znak, który określa jakiego
rodzaju pomocy oczekujesz. Jeśli poczujesz się NAPRAWDĘ zagubiony, to
napisz C-h?, a Emacs podpowie, jakiego rodzaju pomocy może Ci
dostarczyć. Jeśli naciśniesz C-h, a potem zadecydujesz, że pomoc nie
jest Ci jednak potrzebna, to aby anulować zapoczątkowane polecenie C-h,
po prostu wciśnij C-g.

Najprostszą pomoc możesz uzyskać naciskając C-h c. Naciśnij C-h a potem
c, po czym kombinację klawiszy, której znaczenie chcesz poznać; Emacs
wyświetli krótki opis polecenia odpowiadającego tej kombinacji.

>> Naciśnij C-h c C-p.

Powinno to przywołać komunikat, o treści podobnej do

	C-p runs the command previous-line

W ten sposób możesz uzyskać „nazwę funkcji” przypisanej kombinacji
klawiszy. Przydaje się to podczas pisania kodu w Lispie, w którym
zapisane są rozszerzenia Emacsa; wystarcza to także do przypomnienia
Ci, co dane polecenie robi, jeśli widziałeś je już wcześniej, lecz
go nie zapamiętałeś.

Jako dopełnienie polecenia C-h c Emacs dopuszcza też wieloznakowe
kombinacje klawiszy, na przykład C-x C-s albo (jeśli nie masz klawisza
META lub Alt) <ESC>v.

By uzyskać więcej informacji na temat polecenia, naciśnij C-h k
zamiast C-h c.

>> Naciśnij C-h k C-p.

To polecenie wyświetla dokumentację na temat danej funkcji oraz jej
nazwę w oknie Emacsa. Gdy skończysz śledzić wynik tego polecenia
naciśnij C-x 1, by pozbyć się tekstu pomocy. Nie musisz tego robić od
razu. Możesz wykonać pewne operacje w oparciu o tekst pomocy zanim
naciśniesz C-x 1.

Oto kilka innych użytecznych wariantów C-h:

	C-h f Opisz funkcje o podanej nazwie.

>> Napisz C-h f previous-line<Return>. Wypisze to na ekranie całą
   informacje, jaką Emacs ma na temat funkcji, która implementuje
   polecenie C-p.

Podobnie komenda C-h v pokazuje na ekranie dokumentację zmiennych,
których wartości możesz zmienić, aby dostosować Emacsa do swoich
preferencji. Wpisz nazwę zmiennej, gdy Emacs o nią poprosi.


	C-h a 	Apropos. Wpisz słowo, a Emacs wypisze listę
	      	wszystkich poleceń, których nazwa zawiera to słowo.
		Polecenia te można wywoływać za pomocą Meta-x.
		Dla niektórych poleceń Apropos wypisze jedno- lub
		dwuznakowe sekwencje, które wywołują te polecenia.

>> Napisz C-h a file<Return>.

Zobaczysz listę wszystkich poleceń,
dostępnych za pomocą M-x, które maja słowo "file" w swojej nazwie.
Zauważysz tam także polecenia takie, jak C-x C-f oraz C-x C-w,
umieszczone obok nazw poleceń "find-file" i "write-file".

>> Napisz C-M-v, aby przewinąć okno pomocy. Zrób to kilka razy.
>> Napisz C-x 1, aby usunąć okno pomocy.

	C-h i 	Czytanie elektronicznych podręczników (w formacie Info). To
		polecenie przełączy Cię do specjalnego bufora o nazwie
		*info*, gdzie będziesz mógł przeczytać podręczniki
		dotyczące pakietów zainstalowanych w Twoim
		systemie. Napisz m emacs <Return>, aby zapoznać się z
		podręcznikiem Emacsa. Jeżeli nigdy wcześniej nie używałeś
		trybu Info, to napisz ?, a Emacs przedstawi Ci możliwości
		tego trybu. Po tym, jak zapoznasz się z niniejszym krótkim
		samouczkiem, w dalszej pracy dostęp do dokumentacji
		będziesz uzyskiwał właśnie za pomocą Emacs Info.


DODATKOWE FUNKCJE
-----------------

Więcej o Emacsie możesz się nauczyć czytając jego podręcznik, w formie
książkowej lub on-line w postaci Info (użyj menu Help lub naciśnij F10
h r). Dwie dodatkowe właściwości, które szczególnie mogą się przydać
to dopełnianie wprowadzanych danych i dired ułatwiające zarządzanie
plikami.

Dopełnianie pozwala uniknąć niepotrzebnego wpisywania. Na przykład
jeśli chcesz się przełączyć do bufora *Messages*, możesz nacisnąć C-x
b *M<Tab> a Emacs dopełni dalszą część nazwy za Ciebie na tyle, na ile
będzie w stanie ustalić na podstawie tego, co do tej pory wpisałeś. Dopełnianie
jest opisane w Info w podręczniku Emacsa w części zatytułowanej
"Dopłnianie" (ang. Completion).

Dired umożliwia Ci zrobienie wykazu plików w danym katalogu (dodatkowo
w podkatalogach), przemieszczanie się wewnątrz tej listy, odwiedzanie
plików, zmienianie nazw, usuwanie i inne operacje na plikach. Dired
jest opisane w Info w podręczniku Emacsa w części zatytułowanej
"Dired".

Podręcznik dodatkowo opisuje wiele innych właściwości Emacsa.


* KIEROWANIE KURSOREM Z X TERMINALA (akapit dodany przez autorów wersji polskiej)
-----------------------------------

Jeśli pracujesz na terminalu graficznym, to do kierowania kursorem
prawdopodobnie łatwiej Ci będzie używać klawiszy strzałek po prawej
stronie klawiatury. Klawisze strzałek: w lewo, w prawo, w górę i w dół
działają zgodnie z oczekiwaniem; odpowiadają one dokładnie C-b, C-f, C-p
i C-n, ale są łatwiejsze do zapamiętania. Możesz także używać C-lewo i
C-prawo, by przesuwać się o słowa, oraz C-góra i C-dół, by przesuwać się
o bloki (np. akapity, jeśli edytujesz tekst). Jeśli masz klawisze
oznaczone Home (lub Begin) oraz End, to przeniosą Cię one na początek i,
odpowiednio, na koniec linii, a C-Home i C-End na początek i koniec
pliku. Jeśli na Twojej klawiaturze są klawisze PgUp i PgDn, to możesz
ich użyć do przesuwania się o jeden ekran, tak jak M-v i C-v.

Wszystkie te polecenia akceptują argument liczbowy, tak jak to
opisano powyżej. Wpisanie argumentu możesz sobie uprościć:
naciśnij i trzymaj CONTROL lub META i wpisz liczbę. Na
przykład, aby przesunąć kursor o 12 słów w prawo, naciśnij C-1 C-2
C-prawo. Zwróć uwagę, że jest to łatwe do wpisania, ponieważ nie
musisz puszczać klawisza CONTROL podczas wpisywania cyfr.


* UŻYWANIE MENU (akapit dodany przez autorów wersji polskiej)
---------------

Jeśli pracujesz na X-terminalu, to u góry okna Emacsa powinieneś zauważyć
pasek z menu. Tego menu możesz używać, by wywoływać najczęściej
potrzebne polecenia Emacsa, takie jak "find file". Na początku będziesz
sądził, że jest to łatwiejsze niż używanie klawiatury, ponieważ nie
musisz się na pamięć uczyć kombinacji klawiszy, które uruchamiają
poszczególne polecenia. Gdy już jednak poznasz Emacsa, to zaczniesz
sobie te kombinacje przyswajać --- dla wygody przy pozycjach menu
pokazywane są odpowiadające im kombinacje klawiszy.

Zwróć uwagę, że niektóre pozycje występujące w menu nie mają
odpowiedników klawiszowych. Na przykład pozycja "Buffers" powoduje
wyświetlenie listy wszystkich dostępnych buforów. Do każdego z nich
możesz się przełączyć, wybierając jego nazwę, wyświetloną pod pozycją
Buffers.


PODSUMOWANIE
------------

Pamiętaj, że by wyjść z Emacsa na stałe, trzeba wydać polecenie C-x C-c.
By wyjść do powłoki na chwilę tak, by jeszcze Do Emacsa wrócić, trzeba
użyć C-z. (To nie działa pod X-Windows, ponieważ tam nie ma prawdziwego
konceptu przejścia na chwilę do powłoki. Zamiast tego C-z „ikonizuje”
okno Emacsa.)

Ten samouczek był pisany tak, by wszyscy nowi użytkownicy mogli go
zrozumieć. Jeśli coś pozostawił niejasnym, nie siedź cicho i nie
obwiniaj siebie, tylko daj nam znać!


KOPIOWANIE
----------

Niniejszy samouczek jest potomkiem w długiej linii samouczków
Emacsa, która rozpoczyna się od tego, który został napisany przez
Stuarta Cracrafta dla oryginalnego Emacsa. Został on zmodyfikowany we
wrześniu 1994 przez Bena Winga, który zaktualizował go w celu uwzględnienia
pracy pod X-Windows.

Autorem pierwszego tłumaczenia na język polski był Remek Trzaska
<remek@npac.syr.edu>, a pomagał mu Ryszard Kubiak
<rysiek@ipipan.gda.pl>. Tamto tłumaczenie zostało uaktualnione dla
wersji GNU Emacs 21 przez Beatę Wierzchołowską <beataw@orient.uw.edu.pl>
z pomocą Ryszarda Kubiaka i Janusza S. Bienia <jsbien@mail.uw.edu.pl>.

Ta wersja samouczka, podobnie jak GNU Emacs, jest chroniona prawem
autorskim, ale wolno ją kopiować pod następującymi warunkami:

Copyright (C) 1985, 1994, 2001-2014 Free Software Foundation, Inc.

Zezwala się na wykonywanie lub rozpowszechnianie
wiernych kopii tego dokumentu w otrzymanej formie, na dowolnym
nośniku, pod warunkiem zachowania informacji o
prawach autorskich i niniejszym zezwoleniu oraz pod
warunkiem, że dystrybutor udzieli odbiorcy pozwolenia na
dalsze rozpowszechnianie zgodnie z niniejszym zezwoleniem.


Zezwala się również na rozpowszechnianie na warunkach podanych
powyżej zmodyfikowanych wersji tego dokumentu lub jego części,
pod warunkiem, że zostaną wyraźnie uwidocznione
informacje o tym, kto dokonał modyfikacji jako ostatni.


Warunki kopiowania samego Emacsa są bardziej skomplikowane, ale zgodne
z tą ideą. Proszę, przeczytaj plik COPYING, po czym rozdaj swoim
znajomym kopie Emacsa. Pomóż tępić obstrukcjonizm w informatyce,
używając, tworząc i dzieląc się oprogramowaniem swobodnym.

;;; Local Variables:
;;; mode: fundamental
;;; coding: utf-8
;;; sentence-end-double-space: nil
;;; End:
