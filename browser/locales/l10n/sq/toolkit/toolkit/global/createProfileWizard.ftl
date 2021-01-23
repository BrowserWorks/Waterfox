# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Pjesa e Krijimit të Profileve
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Hyrje
       *[other] Mirë se vini te { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name }-i ruan të dhëna rreth rregullimeve dhe parapëlqimeve tuaj te profili juaj vetjak.

profile-creation-explanation-2 = Nëse e ndani këtë kopje të { -brand-short-name }-it me përdorues të tjerë, mund të përdorni profile për të mbajtur ndaras të dhëna të çdo përdoruesi. Për këtë, çdo përdorues do të duhej të krijonte profilin e tij ose të saj.

profile-creation-explanation-3 = Nëse jeni personi i vetëm që përdor këtë kopje të { -brand-short-name }-it, duhet të keni të paktën një profil. Nëse doni, mund të krijoni për veten profile të shumëfishtë, për të ruajtur grupe të ndryshëm rregullimesh dhe parapëlqimesh. Për shembull, mund të doni të keni profile të veçantë për në punë dhe përdorim vetjak.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Për të filluar krijimin e profilit tuaj, klikoni mbi Vazhdo.
       *[other] Për të filluar krijimin e profilit tuaj, klikoni mbi Pasuesin.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Përfundim
       *[other] Po përfundohet { create-profile-window.title }
    }

profile-creation-intro = Nëse krijoni disa profile, mund t'i dalloni nga emrat e profileve. Mund të përdorni emrin e dhënë këtu ose një të tuajin.

profile-prompt = Jepni emër profili të ri:
    .accesskey = J

profile-default-name =
    .value = Përdorues Parazgjedhje

profile-directory-explanation = Rregullimet tuaja si përdorues, parapëlqimet dhe të tjera të dhëna që kanë të bëjnë me ju si përdorues do të depozitohen në:

create-profile-choose-folder =
    .label = Zgjidhni Dosje…
    .accesskey = Z

create-profile-use-default =
    .label = Përdor Dosje Parazgjedhje
    .accesskey = P
