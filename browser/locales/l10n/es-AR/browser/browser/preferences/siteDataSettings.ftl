# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Administrar las cookies y Datos del sitio

site-data-settings-description = Los siguientes sitios web almacenan cookies y datos del sitio en su computadora. { -brand-short-name } conserva los datos de los sitios web con almacenamiento persistente hasta que usted los elimine y, cuando se necesite espacio adicional, elimina los datos de sitios sin almacenamiento persistente.

site-data-search-textbox =
    .placeholder = Buscar sitios Web
    .accesskey = S

site-data-column-host =
    .label = Sitio
site-data-column-cookies =
    .label = Cookies
site-data-column-storage =
    .label = Almacenamiento
site-data-column-last-used =
    .label = Último uso

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (archivo local)

site-data-remove-selected =
    .label = Eliminar seleccionados
    .accesskey = r

site-data-button-cancel =
    .label = Cancelar
    .accesskey = C

site-data-button-save =
    .label = Guardar cambios
    .accesskey = a

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (Persistente)

site-data-remove-all =
    .label = Eliminar todo
    .accesskey = E

site-data-remove-shown =
    .label = Eliminar todo lo mostrado
    .accesskey = E

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Eliminar

site-data-removing-header = Eliminando cookies y datos del sitio

site-data-removing-desc = Eliminar cookies y datos del sitio puede desconectarlo de sitios Web. ¿Está seguro que desea realizar los cambios?

site-data-removing-table = Se eliminarán las cookies y los datos del sitio para los siguientes sitios web
