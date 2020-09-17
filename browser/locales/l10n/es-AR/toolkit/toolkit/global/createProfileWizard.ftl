# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Asistente para crear perfiles
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introducción
       *[other] Bienvenido a { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } guarda información acerca de sus opciones y preferencias en su perfil personal.

profile-creation-explanation-2 = Si está compartiendo { -brand-short-name } con otras personas bajo la misma cuenta de usuario de computadora, puede crear perfiles diferentes para mantener separada la información de cada persona. Para hacer esto, cada quien debería crear su propio perfil.

profile-creation-explanation-3 = Si usted es la única persona que utiliza { -brand-short-name } bajo esta misma cuenta de usuario de computadora, debe tener al menos un perfil. De todas maneras, si así lo desea, puede crear múltiples perfiles para guardar diferentes configuraciones y preferencias. Por ejemplo, quizás le interese tener perfiles separados para uso personal y comercial.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Para comenzar a crear su perfil, haga clic en Continuar.
       *[other] Para comenzar a crear su perfil, haga clic en Siguiente.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Conclusión
       *[other] Completando { create-profile-window.title }
    }

profile-creation-intro = Si desea crear varios perfiles puede separarlos por su nombre. Puede usar el nombre provisto aquí o usar uno propio.

profile-prompt = Ingrese nuevo nombre de perfil:
    .accesskey = e

profile-default-name =
    .value = Usuario por defecto

profile-directory-explanation = Sus opciones de usuario, preferencias, marcadores y otros datos de usuario se guardarán en:

create-profile-choose-folder =
    .label = Seleccionar carpeta…
    .accesskey = c

create-profile-use-default =
    .label = Usar carpeta predeterminada
    .accesskey = U
