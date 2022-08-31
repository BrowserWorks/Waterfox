# This Source Code Form is subject to the terms of the Waterfox Public
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
auth-your-fp-value = Huella digital para ti, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Huella digital de { $their_name }:

auth-help = Verificar la identidad de un contacto ayuda a garantizar que la conversación sea verdaderamente privada, haciendo muy difícil que un tercero pueda escuchar o manipular la conversación.
auth-help-title = Ayuda de verificación

auth-question-received = Esta es la pregunta que hizo tu contacto:

auth-yes =
    .label = Sí

auth-no =
    .label = No

auth-verified = He verificado que esta es de hecho la huella dactilar correcta.

auth-manual-verification = Verificación manual de huellas digitales
auth-question-and-answer = Pregunta y respuesta
auth-shared-secret = Secreto compartido

auth-manual-verification-label =
    .label = { auth-manual-verification }

auth-question-and-answer-label =
    .label = { auth-question-and-answer }

auth-shared-secret-label =
    .label = { auth-shared-secret }

auth-manual-instruction = Contacta con tu interlocutor a través de otro canal autenticado, como el correo electrónico firmado por OpenPGP o a través del teléfono. Deberían decirse sus huellas dactilares. (Una huella digital es una suma de control que identifica una clave de cifrado). Si la huella dactilar coincide, en el cuadro de diálogo que figura más abajo deberá indicarse que has verificado la huella dactilar.

auth-how = ¿Cómo te gustaría verificar la identidad de tu contacto?

auth-qa-instruction = Piensa en una pregunta cuya respuesta solo tú y tu contacto conozcan. Ingresa la pregunta y la respuesta, luego espera a que tu contacto ingrese la respuesta. Si las respuesta no coincide, es posible que el canal de comunicación que está usando esté bajo vigilancia.

auth-secret-instruction = Piensa en un secreto conocido solo para ti y tu contacto. No uses la misma conexión a Internet para intercambiar el secreto. Escribe el secreto y espera a que tu contacto lo ingrese. Si los secretos no coinciden, el canal de comunicación que estás usando estar bajo vigilancia.

auth-question = Ingresa una pregunta:

auth-answer = Ingresa la respuesta (distingue entre mayúsculas y minúsculas):

auth-secret = Ingresa el secreto:
