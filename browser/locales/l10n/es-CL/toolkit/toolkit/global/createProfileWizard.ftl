# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Asistente para la creación de perfiles
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introducción
       *[other] Bienvenido al { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } guarda información sobre tu configuración y preferencias en tu perfil personal.

profile-creation-explanation-2 = Si compartes esta copia de { -brand-short-name } con otros usuarios, puedes usar perfiles para mantener separada la información de cada usuario. Para ello, cada usuario debe crear su propio perfil.

profile-creation-explanation-3 = Si solamente tu usas esta copia de { -brand-short-name }, debes tener al menos un perfil. Si lo deseas, puedes crear múltiples perfiles con el fin de guardar diferentes conjuntos de configuraciones y preferencias. Por ejemplo, puedes tener perfiles separados para uso personal y uso profesional.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Para comenzar a crear tu perfil, haz clic en Continuar.
       *[other] Para comenzar a crear tu perfil, haz clic en Siguiente.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Conclusión
       *[other] Completando el { create-profile-window.title }
    }

profile-creation-intro = Si creas distintos perfiles puedes distinguirlos por sus nombres. Puedes usar el nombre que te hemos proporcionado o crear uno nuevo por tu cuenta.

profile-prompt = Ingresa un nuevo nombre de perfil:
    .accesskey = i

profile-default-name =
    .value = Usuario predeterminado

profile-directory-explanation = Tus configuraciones, preferencias y otros datos relacionados al usuario serán almacenados en:

create-profile-choose-folder =
    .label = Selecciona carpeta…
    .accesskey = c

create-profile-use-default =
    .label = Usar la Carpeta Predeterminada
    .accesskey = U
