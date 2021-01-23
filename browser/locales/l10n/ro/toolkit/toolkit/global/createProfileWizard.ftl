# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Asistent pentru crearea profilului
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introducere
       *[other] Bine ai venit la { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } stochează informații despre setări și preferințe în profilul tău personal.

profile-creation-explanation-2 = Dacă mai folosești această copie de { -brand-short-name } împreună cu alți utilizatori, poți folosi profiluri pentru a păstra separate informațiile fiecărui utilizator. Pentru aceasta, fiecare utilizator ar trebui să-și creeze propriul profil.

profile-creation-explanation-3 = Dacă ești singura persoană care folosește această copie de { -brand-short-name }, trebuie să ai cel puțin un profil. Dacă dorești, poți să îți creezi mai multe profiluri, pentru a stoca seturi diferite de setări și preferințe. De exemplu, poate vrei să ai profiluri separate pentru afaceri și pentru uzul personal.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Pentru a începe să-ți creezi profilul, apasă Continuă.
       *[other] Pentru a începe să-ți creezi profilul, dă clic pe Înainte.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Încheiere
       *[other] Încheiere { create-profile-window.title }
    }

profile-creation-intro = Dacă creezi mai multe profiluri, le poți deosebi după denumirile profilurilor. Poți folosi denumirea sugerată aici sau denumirea pe care o dorești tu.

profile-prompt = Introdu numele noului profil:
    .accesskey = e

profile-default-name =
    .value = Utilizator implicit

profile-directory-explanation = Setările utilizatorului, preferințele și alte date legate de utilizator vor fi stocate în:

create-profile-choose-folder =
    .label = Alege dosarul…
    .accesskey = d

create-profile-use-default =
    .label = Folosește dosarul implicit
    .accesskey = U
