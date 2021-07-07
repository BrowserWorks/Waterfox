# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Sobre os perfis
profiles-subtitle = Esta página ajuda a gerenciar seus perfis. Cada perfil é um mundo separado que contém histórico, favoritos, configurações e extensões separados.
profiles-create = Criar um novo perfil
profiles-restart-title = Reiniciar
profiles-restart-in-safe-mode = Reiniciar com extensões desativadas…
profiles-restart-normal = Reiniciar normalmente…
profiles-conflict = Outra cópia do { -brand-product-name } fez mudanças em perfis. Você deve reiniciar o { -brand-short-name } antes de fazer mais alterações.
profiles-flush-fail-title = As alterações não foram salvas
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Um erro inesperado impediu que suas alterações fossem salvas.
profiles-flush-restart-button = Reiniciar o { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Perfil: { $name }
profiles-is-default = Perfil padrão
profiles-rootdir = Pasta raiz

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Pasta local
profiles-current-profile = Este é o perfil em uso e não pode ser excluído.
profiles-in-use-profile = Este perfil está em uso em outra aplicação e não pode ser excluído.

profiles-rename = Renomear
profiles-remove = Remover
profiles-set-as-default = Definir como perfil padrão
profiles-launch-profile = Iniciar o perfil em um novo navegador

profiles-cannot-set-as-default-title = Não foi possível definir padrão
profiles-cannot-set-as-default-message = O perfil padrão não pode ser alterado no { -brand-short-name }.

profiles-yes = sim
profiles-no = não

profiles-rename-profile-title = Renomear perfil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Renomear o perfil { $name }

profiles-invalid-profile-name-title = Nome de perfil inválido
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = O nome de perfil “{ $name }” não é permitido.

profiles-delete-profile-title = Excluir perfil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Ao excluir um perfil, ele é removido da lista de perfis disponíveis. Isso não pode ser desfeito.
    
    Você também pode optar por excluir os arquivos de dados do perfil, inclusive suas configurações, certificados e outros dados relacionados ao usuário. Esta opção apaga definitivamente a pasta “{ $dir }”.
    
    Quer excluir o perfil e seus arquivos de dados?
profiles-delete-files = Excluir o perfil e seus arquivos
profiles-dont-delete-files = Excluir o perfil, mas manter seus arquivos

profiles-delete-profile-failed-title = Erro
profiles-delete-profile-failed-message = Ocorreu um erro ao tentar excluir esse perfil.


profiles-opendir =
    { PLATFORM() ->
        [macos] Mostrar no Finder
        [windows] Abrir pasta
       *[other] Abrir pasta
    }
