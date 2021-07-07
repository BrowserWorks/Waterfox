# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Verificar identidad del contacto
    .buttonlabelaccept = Verificar

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Verificar la identidad de { $name }

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Huella de usted, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Huella de { $their_name }:

auth-help = Verificar la identidad de un contacto ayuda a asegurar que la conversación es verdaderamente privada, haciendo muy difícil que un tercero se infiltre o manipule la conversación.
auth-helpTitle = Ayuda sobre verificación

auth-questionReceived = Esta es la pregunta realizada por su contacto:

auth-yes =
    .label = Sí

auth-no =
    .label = No

auth-verified = He verificado que esta es realmente la huella correcta.

auth-manualVerification = Verificación manual de huella
auth-questionAndAnswer = Pregunta y respuesta
auth-sharedSecret = Secreto compartido

auth-manualVerification-label =
    .label = { auth-manualVerification }

auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }

auth-sharedSecret-label =
    .label = { auth-sharedSecret }

auth-manualInstruction = Contacte con el compañero de conversación pretendido a través de algún otro canal seguro, tal como un correo firmado con OpenPGP o por teléfono. Deberían comunicarse mutuamente sus huellas (una huella es una suma de comprobación que identifica una clave de cifrado). Si la huella coincide, debe indicar en el diálogo de debajo que ha verificado la huella.

auth-how = ¿Cómo le gustaría verificar la identidad de su contacto?

auth-qaInstruction = Piense en una pregunta cuya respuesta solo sea conocida por usted y su contacto. Introduzca la pregunta y la respuesta, luego espere que su contacto introduzca la respuesta. Si las respuestas no coinciden, el canal de comunicación que está usando puede estar bajo vigilancia.

auth-secretInstruction = Piense en un secreto conocido solo por usted y su contacto. No use la misma conexión de Internet para intercambiar el secreto. Introduzca el secreto, luego espere a que su contacto lo introduzca. Si los secretos no coinciden, el canal de comunicación que están usando puede estar bajo vigilancia.

auth-question = Introduzca una pregunta:

auth-answer = Introduzca la respuesta (se distinguen mayúsculas y minúsculas):

auth-secret = Introduzca el secreto:
