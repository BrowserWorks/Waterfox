# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Administrar cookies y datos del sitio

site-data-settings-description = Los siguientes sitios web almacenan cookies y datos del sitio en tu equipo. { -brand-short-name } conserva los datos de los sitios web con almacenamiento persistente hasta que los elimines y cuando se necesite espacio adicional, elimina los datos de sitios sin almacenamiento persistente.

site-data-search-textbox =
    .placeholder = Buscar sitios
    .accesskey = S

site-data-column-host =
    .label = Sitio
site-data-column-cookies =
    .label = Cookies
site-data-column-storage =
    .label = Almacenamiento
site-data-column-last-used =
    .label = Usado por última vez

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (archivo local)

site-data-remove-selected =
    .label = Eliminar seleccionados
    .accesskey = r

site-data-settings-dialog =
    .buttonlabelaccept = Guardar cambios
    .buttonaccesskeyaccept = a

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (Persistente)

site-data-remove-all =
    .label = Eliminar todos
    .accesskey = e

site-data-remove-shown =
    .label = Eliminar todos los mostrados
    .accesskey = e

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Eliminar

site-data-removing-header = Eliminando cookies y datos del sitio

site-data-removing-desc = Eliminar cookies y datos de los sitios puede cerrar tus sesiones activas. ¿Estás seguro que deseas hacer los cambios?

# Variables:
#   $baseDomain (String) - The single domain for which data is being removed
site-data-removing-single-desc = El eliminar cookies y los datos del sitio puede cerrarte las sesiones de los sitios web. ¿En verdad deseas eliminar las cookies y los datos del sitio de <strong>{ $baseDomain }</strong>?

site-data-removing-table = Las cookies y los datos de los siguientes sitios web serán eliminados
