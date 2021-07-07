# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Assistente de criação de perfil
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introdução
       *[other] Boas-vindas ao { create-profile-window.title }
    }
profile-creation-explanation-1 = O { -brand-short-name } armazena informações sobre suas configurações e preferências em seu perfil pessoal.
profile-creation-explanation-2 = Caso compartilhe esta instalação do { -brand-short-name } com outras pessoas, você pode usar perfis para manter separadas as informações de cada usuário. Para fazer isso, cada um deve criar seu próprio perfil.
profile-creation-explanation-3 = Se você é a única pessoa que usa esta instalação do { -brand-short-name }, deve ter pelo menos um perfil. Se quiser, pode criar outros perfis de uso próprio para armazenar diferentes conjuntos de configurações e preferências. Por exemplo, pode ter perfis separados para uso pessoal e profissional.
profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Para começar a criar um perfil, clique em “Continuar”.
       *[other] Para começar a criar um perfil, clique em “Avançar”.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Conclusão
       *[other] Concluindo { create-profile-window.title }
    }
profile-creation-intro = Se você criar vários perfis, pode diferenciar pelo nome. Você pode usar o nome sugerido aqui ou escolher outro.
profile-prompt = Digite o nome do novo perfil:
    .accesskey = F
profile-default-name =
    .value = Usuário padrão
profile-directory-explanation = Suas configurações, preferências e outros dados relacionados ao usuário serão armazenados em:
create-profile-choose-folder =
    .label = Escolher pasta…
    .accesskey = P
create-profile-use-default =
    .label = Usar a pasta padrão
    .accesskey = U
