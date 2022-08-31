# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Asistente de creación de perfiles
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introducción
       *[other] Bienvenido a { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } guarda información sobre su configuración y preferencias en su perfil personal.

profile-creation-explanation-2 = Si comparte esta copia de { -brand-short-name } con otros usuarios, puede usar perfiles para mantener separada la información de cada usuario. Para ello, cada usuario debe crear su propio perfil.

profile-creation-explanation-3 = Si es la única persona que usa esta copia de { -brand-short-name }, debe tener al menos un perfil. Si lo desea, puede crear múltiples perfiles con el fin de guardar diferentes conjuntos de configuraciones y preferencias. Por ejemplo, puede querer tener perfiles separados para uso personal y uso profesional.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Para comenzar a crear su perfil, haga clic en Continuar.
       *[other] Para comenzar a crear su perfil, haga clic en Siguiente.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Conclusión
       *[other] Completar { create-profile-window.title }
    }

profile-creation-intro = Si crea distintos perfiles puede distinguirlos por sus nombres. Puede usar el nombre proporcionado aquí o escoger uno usted mismo.

profile-prompt = Introduzca nombre del nuevo perfil:
    .accesskey = E

profile-default-name =
    .value = Usuario predeterminado

profile-directory-explanation = Su configuración de usuario, preferencias y otros datos relativos al usuario se guardarán en:

create-profile-choose-folder =
    .label = Elegir carpeta…
    .accesskey = C

create-profile-use-default =
    .label = Usar carpeta predeterminada
    .accesskey = U
