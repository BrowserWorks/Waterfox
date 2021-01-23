# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webpage-languages-window =
    .title = Ajustes de idioma para la página web
    .style = width: 40em

languages-close-key =
    .key = w

languages-description = Las páginas web a veces se ofrecen en más de un idioma. Seleccione los idiomas para mostrar esas páginas web, en orden de preferencia

languages-customize-spoof-english =
    .label = Pedir versiones en inglés de las páginas web para mejorar la privacidad

languages-customize-moveup =
    .label = Subir
    .accesskey = U

languages-customize-movedown =
    .label = Bajar
    .accesskey = B

languages-customize-remove =
    .label = Eliminar
    .accesskey = r

languages-customize-select-language =
    .placeholder = Seleccione un idioma para agregar...

languages-customize-add =
    .label = Agregar
    .accesskey = A

# The pattern used to generate strings presented to the user in the
# locale selection list.
#
# Example:
#   Icelandic [is]
#   Spanish (Chile) [es-CL]
#
# Variables:
#   $locale (String) - A name of the locale (for example: "Icelandic", "Spanish (Chile)")
#   $code (String) - Locale code of the locale (for example: "is", "es-CL")
languages-code-format =
    .label = { $locale }  [{ $code }]

languages-active-code-format =
    .value = { languages-code-format.label }

browser-languages-window =
    .title = { -brand-short-name } Ajustes de idioma
    .style = width: 40em

browser-languages-description = { -brand-short-name } mostrará el primer idioma como el predeterminado e irá mostrando idiomas alternativos si es necesario en orden que aparecen.

browser-languages-search = Buscar más idiomas…

browser-languages-searching =
    .label = Buscando más idiomas…

browser-languages-downloading =
    .label = Descargando...

browser-languages-select-language =
    .label = Seleccione un idioma para agregar…
    .placeholder = Seleccione un idioma para agregar…

browser-languages-installed-label = Idiomas instalados
browser-languages-available-label = Idiomas disponibles

browser-languages-error = { -brand-short-name } no puede actualizar sus idiomas en este momento. Compruebe que esté conectado a internet o vuelva a intentarlo.
