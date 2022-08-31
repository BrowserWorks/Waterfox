# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Añadir una clave OpenPGP personal para { $identity }
key-wizard-button =
    .buttonlabelaccept = Continuar
    .buttonlabelhelp = Atrás
key-wizard-warning = <b>Si ya dispone de una clave personal</b> para esta dirección de correo electrónico, debería importarla. De lo contrario, no podrá acceder a sus archivos de correos electrónicos cifrados ni podrá leer los correos electrónicos cifrados recibidos de personas que aún están utilizando su clave existente.
key-wizard-learn-more = Saber más
radio-create-key =
    .label = Crear una nueva clave OpenPGP
    .accesskey = C
radio-import-key =
    .label = Importar una clave OpenPGP existente
    .accesskey = I
radio-gnupg-key =
    .label = Utilizar su clave externa a través de GnuPG (p. ej., desde una tarjeta inteligente)
    .accesskey = U

## Generate key section

openpgp-generate-key-title = Generar clave OpenPGP
openpgp-generate-key-info = <b>La generación de la clave puede tardar varios minutos en completarse.</b> No salga de la aplicación mientras la generación de la clave esté en proceso. Navegar activamente o realizar operaciones que hagan un uso intensivo de disco repondrá el 'grupo de aleatoriedad' y acelerará el proceso. Se le avisará cuando la generación de la clave se haya completado.
openpgp-keygen-expiry-title = Caducidad de la clave
openpgp-keygen-expiry-description = Establezca la fecha de vencimiento de la clave recién generada. Puede cambiar esta fecha para ampliar el tiempo de caducidad si fuera necesario.
radio-keygen-expiry =
    .label = La clave caduca en
    .accesskey = e
radio-keygen-no-expiry =
    .label = La clave no caduca
    .accesskey = c
openpgp-keygen-days-label =
    .label = días
openpgp-keygen-months-label =
    .label = meses
openpgp-keygen-years-label =
    .label = años
openpgp-keygen-advanced-title = Configuración avanzada
openpgp-keygen-advanced-description = Gestionar la configuración avanzada de su clave OpenPGP.
openpgp-keygen-keytype =
    .value = Tipo de clave:
    .accesskey = t
openpgp-keygen-keysize =
    .value = Tamaño de clave:
    .accesskey = v
openpgp-keygen-type-rsa =
    .label = RSA
openpgp-keygen-type-ecc =
    .label = ECC (curva elíptica)
openpgp-keygen-button = Generar clave
openpgp-keygen-progress-title = Generando la nueva clave OpenPGP…
openpgp-keygen-import-progress-title = Importando sus claves OpenPGP…
openpgp-import-success = ¡Las claves OpenPGP se han importado correctamente!
openpgp-import-success-title = Completar el proceso de importación
openpgp-import-success-description = Para empezar a utilizar su clave OpenPGP importada y cifrar los mensajes de correo electrónico, cierre este cuadro de diálogo y acceda a la configuración de su cuenta para seleccionarla.
openpgp-keygen-confirm =
    .label = Confirmar
openpgp-keygen-dismiss =
    .label = Cancelar
openpgp-keygen-cancel =
    .label = Cancelar el proceso…
openpgp-keygen-import-complete =
    .label = Cerrar
    .accesskey = C
openpgp-keygen-missing-username = No ha especificado un nombre para la cuenta actual. Introduzca un valor en el campo "Su nombre" en la configuración de cuenta.
openpgp-keygen-long-expiry = No puede crear una clave que caduque en más de 100 años.
openpgp-keygen-short-expiry = La clave debe tener una validez de al menos un día.
openpgp-keygen-ongoing = ¡La generación de las claves ya está en marcha!
openpgp-keygen-error-core = No se puede inicializar el servicio principal de OpenPGP
openpgp-keygen-error-failed = La generación de la clave OpenPGP ha fallado de manera inesperada
#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = La clave OpenPGP se ha creado correctamente, pero no se ha podido obtener la revocación de la clave { $key }
openpgp-keygen-abort-title = ¿Desea cancelar la generación de la clave?
openpgp-keygen-abort = La generación de la clave OpenPGP se encuentra actualmente en marcha, ¿está seguro de que desea cancelarla?
#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = ¿Generar la clave pública y secreta para { $identity }?

## Import Key section

openpgp-import-key-title = Importar una clave OpenPGP personal existente
openpgp-import-key-legend = Seleccione un archivo previamente guardado.
openpgp-import-key-description = Puede importar claves personales que se hayan creado con otro programa OpenPGP.
openpgp-import-key-info = Otro programa podría describir una clave personal utilizando términos alternativos como su propia clave, clave secreta, clave privada o par de claves.
#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount-2 =
    { $count ->
        [one] { -brand-short-name } encontró una clave que puede ser importada.
       *[other] { -brand-short-name } encontró { $count } claves que pueden ser importadas.
    }
openpgp-import-key-list-description = Confirme qué claves pueden utilizarse como sus claves personales. Sólo las claves que creó usted mismo y que muestran su propia identidad deberían usarse como claves personales. Puede cambiar esta opción más adelante en el cuadro de diálogo Propiedades de la clave.
openpgp-import-key-list-caption = Las claves marcadas para ser utilizadas como claves personales se enumerarán en la sección Cifrado de extremo a extremo. Las demás estarán disponibles dentro del Administrador de claves.
openpgp-passphrase-prompt-title = Se requiere frase de acceso.
#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Introduzca la frase de acceso para desbloquear la siguiente clave: { $key }
openpgp-import-key-button =
    .label = Seleccionar archivo para importar…
    .accesskey = S
import-key-file = Importar archivo de clave OpenPGP
import-key-personal-checkbox =
    .label = Utilizar esta clave como una clave personal
gnupg-file = Archivos GnuPG
import-error-file-size = <b>¡Error!</b> No se admiten archivos de más de 5MB.
#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>¡Error!</b> No se ha podido importar el archivo. { $error }
#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>¡Error!</b> No se pudieron importar las claves. { $error }
openpgp-import-identity-label = Identidad
openpgp-import-fingerprint-label = Huella digital
openpgp-import-created-label = Creada
openpgp-import-bits-label = Bits
openpgp-import-key-props =
    .label = Propiedades de la clave
    .accesskey = v

## External Key section

openpgp-external-key-title = Clave GnuPG externa
openpgp-external-key-description = Configurar una clave GnuPG externa introduciendo el ID de la clave
openpgp-external-key-info = Además, debe utilizar el Administrador de claves para importar y aceptar la clave pública correspondiente.
openpgp-external-key-warning = <b>Puede configurar sólo una clave GnuPG externa.</b> La entrada anterior será reemplazada.
openpgp-save-external-button = Guardar ID de la clave
openpgp-external-key-label = ID de la clave secreta:
openpgp-external-key-input =
    .placeholder = 123456789341298340
