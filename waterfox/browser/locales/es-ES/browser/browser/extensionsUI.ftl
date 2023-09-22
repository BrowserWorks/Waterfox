# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = Saber más
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = { $addonName } desea cambiar su buscador por defecto de { $currentEngine } a { $newEngine }. ¿Es correcto?
webext-default-search-yes =
    .label = Sí
    .accesskey = S
webext-default-search-no =
    .label = No
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = Se ha añadido { $addonName }

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = ¿Ejecutar { $addonName } en sitios restringidos?
webext-quarantine-confirmation-line-1 = Para proteger sus datos, esta extensión no está permitida en este sitio.
webext-quarantine-confirmation-line-2 = Permitir esta extensión si confía en ella para leer y cambiar los datos en sitios restringidos por { -vendor-short-name }.
webext-quarantine-confirmation-allow =
    .label = Permitir
    .accesskey = P
webext-quarantine-confirmation-deny =
    .label = No permitir
    .accesskey = N
