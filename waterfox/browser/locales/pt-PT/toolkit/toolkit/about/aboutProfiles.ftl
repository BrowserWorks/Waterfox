# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Acerca dos perfis
profiles-subtitle = Esta página ajuda-lhe a gerir os seus perfis. Cada perfil é um mundo separado que contém histórico, marcadores, definições e extras separados.
profiles-create = Criar um novo perfil
profiles-restart-title = Reiniciar
profiles-restart-in-safe-mode = Reiniciar com os extras desativados…
profiles-restart-normal = Reiniciar normalmente…
profiles-conflict = Outra cópia do { -brand-product-name } fez alterações nos perfis. Deve reiniciar o { -brand-short-name } antes de fazer mais alterações.
profiles-flush-fail-title = Alterações não guardadas
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Um erro inesperado impediu as suas alterações de serem guardadas.
profiles-flush-restart-button = Reiniciar o { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Perfil: { $name }
profiles-is-default = Perfil predefinido
profiles-rootdir = Diretório raiz

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Diretório local
profiles-current-profile = Este é o perfil atual e não pode ser apagado.
profiles-in-use-profile = Este perfil está em utilização por outra aplicação e não pode ser apagado.

profiles-rename = Renomear
profiles-remove = Remover
profiles-set-as-default = Definir como perfil predefinido
profiles-launch-profile = Iniciar perfil num novo navegador

profiles-cannot-set-as-default-title = Não é possível definir predefinição
profiles-cannot-set-as-default-message = O perfil predefinido não pode ser alterado para o { -brand-short-name }.

profiles-yes = sim
profiles-no = não

profiles-rename-profile-title = Renomear perfil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Renomear perfil { $name }

profiles-invalid-profile-name-title = Nome de perfil inválido
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = O nome de perfil “{ $name }” não é permitido.

profiles-delete-profile-title = Apagar perfil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Se apagar um perfil, remove-o da lista de perfis disponíveis e não esta ação não pode ser desfeita.
    Pode também escolher apagar os ficheiros de dados do perfil, incluindo as suas definições, certificados e outros dados relacionados com o utilizador. Esta opção irá apagar a pasta “{ $dir }” e não pode ser desfeita.
    Gostaria de apagar os ficheiros de dados do perfil?
profiles-delete-files = Apagar ficheiros
profiles-dont-delete-files = Não apagar ficheiros

profiles-delete-profile-failed-title = Erro
profiles-delete-profile-failed-message = Ocorreu um erro ao tentar apagar este perfil.


profiles-opendir =
    { PLATFORM() ->
        [macos] Mostrar no Finder
        [windows] Abrir pasta
       *[other] Abrir diretório
    }
