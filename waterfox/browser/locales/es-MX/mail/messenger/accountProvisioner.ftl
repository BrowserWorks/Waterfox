# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-provisioner-tab-title = Obtén una nueva dirección de correo electrónico de un proveedor de servicios

provisioner-searching-icon =
    .alt = Buscando…

account-provisioner-title = Crear una nueva dirección de correo electrónico

account-provisioner-description = Usar nuestros socios de confianza para obtener una nueva dirección de correo electrónico privada y segura.

account-provisioner-start-help = Los términos de búsqueda usados se envían a { -vendor-short-name } (<a data-l10n-name="mozilla-privacy-link">Política de privacidad</a>) y a los proveedores de correo electrónico de terceros <strong>mailfence.com</strong> (<a data-l10n-name="mailfence-privacy-link">Política de privacidad</a>, <a data-l10n-name="mailfence-tou-link">Términos de uso</a>) y <strong>gandi.net</strong> (<a data-l10n-name="gandi-privacy-link">Política de privacidad</a>, <a data-l10n-name="gandi-tou-link">Términos de uso</a>) para encontrar direcciones de correo electrónicos disponibles.

account-provisioner-mail-account-title = Comprar una nueva dirección de correo electrónico

account-provisioner-mail-account-description = Thunderbird se asoció con <a data-l10n-name="mailfence-home-link">Mailfence</a> para ofrecerte un nuevo correo electrónico privado y seguro. Creemos que todo el mundo debería tener un correo electrónico seguro.

account-provisioner-domain-title = Comprar un correo electrónico y un dominio propio

account-provisioner-domain-description = Thunderbird se asoció con <a data-l10n-name="gandi-home-link">Gandi</a> para ofrecerte un dominio personalizado. Esto te permite usar cualquier dirección en ese dominio.

## Forms

account-provisioner-mail-input =
    .placeholder = Tu nombre, apodo u otro término de búsqueda

account-provisioner-domain-input =
    .placeholder = Tu nombre, apodo u otro término de búsqueda

account-provisioner-search-button = Buscar

account-provisioner-button-cancel = Cancelar

account-provisioner-button-existing = Usar una cuenta de correo electrónico existente

account-provisioner-button-back = Regresar

## Notifications

account-provisioner-fetching-provisioners = Recuperando proveedores…

account-provisioner-connection-issues = No se puede comunicar con nuestros servidores de registro. Comprueba tu conexión.

account-provisioner-searching-email = Buscando cuentas de correo electrónico disponibles…

account-provisioner-searching-domain = Buscando dominios disponibles…

account-provisioner-searching-error = No se pudo encontrar ninguna dirección para sugerir. Intenta cambiar los términos de búsqueda.

## Illustrations

account-provisioner-step1-image =
    .title = Elige que cuenta crear

## Search results

# Variables:
# $count (Number) - The number of domains found during search.
account-provisioner-results-title =
    { $count ->
        [one] Una dirección disponible encontrada para:
       *[other] { $count } direcciones disponibles encontradas para:
    }

account-provisioner-mail-results-caption = Puedes intentar buscar apodos o algún otro término para encontrar más correos electrónicos.

account-provisioner-domain-results-caption = Puedes intentar buscar apodos o algún otro término para encontrar más dominios.

account-provisioner-free-account = Gratis

account-provision-price-per-year = { $price } al año

account-provisioner-all-results-button = Mostrar todos los resultados

account-provisioner-open-in-tab-img =
    .title = Se abre en una pestaña nueva
