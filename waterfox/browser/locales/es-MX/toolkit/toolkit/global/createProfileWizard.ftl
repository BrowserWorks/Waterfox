# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Asistente para la creación de perfiles
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introducción
       *[other] Bienvenido a { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } guarda información sobre tu configuración y preferencias en tu perfil personal.

profile-creation-explanation-2 = Si compartes esta copia de { -brand-short-name } con otros usuarios, puedes usar perfiles para mantener separada la información de cada usuario. Para ello, cada usuario debe crear su propio perfil.

profile-creation-explanation-3 = Si eres el único en usar esta copia de { -brand-short-name }, debes tener al menos un perfil. Si lo deseas, puedes crear múltiples perfiles para guardar diferentes configuraciones y preferencias. Por ejemplo, un perfil para el uso personal y otro para el trabajo.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Da clic en Continuar para comenzar a crear tu perfil.
       *[other] Para comenzar a crear tu perfil, haz clic en Siguiente.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Conclusión
       *[other] Completando el { create-profile-window.title }
    }

profile-creation-intro = Si creas varios perfiles puedes distinguirlos por su nombre. Puedes asignarle este nombre o ingresar uno nuevo.

profile-prompt = Ingresa el nombre del nuevo perfil:
    .accesskey = I

profile-default-name =
    .value = Usuario predeterminado

profile-directory-explanation = Tu configuración de usuario, preferencias y otros datos relativos al usuario se guardarán en:

create-profile-choose-folder =
    .label = Elegir carpeta…
    .accesskey = c

create-profile-use-default =
    .label = Usar carpeta predeterminada
    .accesskey = U
