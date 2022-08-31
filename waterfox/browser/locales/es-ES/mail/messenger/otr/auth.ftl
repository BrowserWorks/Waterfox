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
auth-your-fp-value = Huella de usted, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Huella de { $their_name }:

auth-help = Verificar la identidad de un contacto ayuda a asegurar que la conversación es verdaderamente privada, haciendo muy difícil que un tercero se infiltre o manipule la conversación.
auth-help-title = Ayuda para verificación

auth-question-received = Ésta es la pregunta que hace su contacto:

auth-yes =
    .label = Sí

auth-no =
    .label = No

auth-verified = He verificado que esta es realmente la huella correcta.

auth-manual-verification = Verificación manual de huella digital
auth-question-and-answer = Pregunta y respuesta
auth-shared-secret = Secreto compartido

auth-manual-verification-label =
    .label = { auth-manual-verification }

auth-question-and-answer-label =
    .label = { auth-question-and-answer }

auth-shared-secret-label =
    .label = { auth-shared-secret }

auth-manual-instruction = Póngase en contacto con su interlocutor a través de algún otro canal autenticado, como el correo electrónico firmado OpenPGP o por teléfono. Deben comunicarse mutuamente sus huellas digitales. (Una huella digital es una suma de verificación que identifica una clave de cifrado). Si la huella digital coincide, debe indicar en el cuadro de diálogo a continuación que verificó la huella digital.

auth-how = ¿Cómo le gustaría verificar la identidad de su contacto?

auth-qa-instruction = Piense en una pregunta para la que solo usted y su contacto conozcan la respuesta. Escriba la pregunta y la respuesta, luego espere a que su contacto escriba la respuesta. Si las respuestas no coinciden, el canal de comunicación que está utilizando puede estar bajo vigilancia.

auth-secret-instruction = Piense en un secreto conocido solo por usted y su contacto. No use la misma conexión a Internet para intercambiar el secreto. Escriba el secreto, luego espere a que su contacto lo introduzca. Si los secretos no coinciden, el canal de comunicación que está utilizando puede estar bajo vigilancia.

auth-question = Introduzca una pregunta:

auth-answer = Introduzca la respuesta (se distinguen mayúsculas y minúsculas):

auth-secret = Introduzca el secreto:
