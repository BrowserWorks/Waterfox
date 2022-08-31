# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Kreator nowego profilu
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Wstęp
       *[other] { create-profile-window.title } — zapraszamy
    }

profile-creation-explanation-1 = { -brand-short-name } przechowuje informacje o ustawieniach i preferencjach użytkownika w prywatnym profilu.

profile-creation-explanation-2 = Jeżeli dzielisz tę kopię programu { -brand-short-name } z innymi użytkownikami, możesz używać profili, aby rozdzielić dane użytkowników. Aby tego dokonać, każdy użytkownik powinien mieć własny profil.

profile-creation-explanation-3 = Jeżeli jesteś jedyną osobą korzystającą z tej kopii programu { -brand-short-name }, musisz mieć przynajmniej jeden profil. Jeśli chcesz, możesz utworzyć kilka profili na własny użytek, z różnymi ustawieniami i preferencjami. Na przykład, możesz mieć osobne profile: służbowy i prywatny.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Aby rozpocząć tworzenie profilu, naciśnij przycisk Kontynuuj.
       *[other] Aby rozpocząć tworzenie profilu, naciśnij przycisk Dalej.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Zakończenie
       *[other] { create-profile-window.title } — finalizowanie
    }

profile-creation-intro = Tworzony profil musi mieć nazwę różną od już istniejących profili. Użyj nazwy podanej poniżej lub wprowadź własną.

profile-prompt = Wprowadź nazwę nowego profilu:
    .accesskey = N

profile-default-name =
    .value = Domyślny użytkownik

profile-directory-explanation = Ustawienia, preferencje oraz pozostałe dane osobiste użytkownika będą przechowywane w:

create-profile-choose-folder =
    .label = Wybierz folder…
    .accesskey = W

create-profile-use-default =
    .label = Użyj domyślnego folderu
    .accesskey = U
