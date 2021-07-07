# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Confirmar a identidade do contacto
    .buttonlabelaccept = Confirmar

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Confirmar a identidade de { $name }

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Identificador digital para si, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Identificador digital para { $their_name }:

auth-help = A confirmação da identidade de um contacto ajuda a garantir que a conversa seja realmente privada, tornando muito difícil para terceiros escutar ou manipular a conversa.
auth-helpTitle = Ajuda na confirmação

auth-questionReceived = Esta é a pergunta feita pelo seu contacto:

auth-yes =
    .label = Sim

auth-no =
    .label = Não

auth-verified = Eu verifiquei que esta é, de facto, a impressão digital correta.

auth-manualVerification = Verificação manual de impressões digitais
auth-questionAndAnswer = Pergunta e resposta
auth-sharedSecret = Segredo partilhado

auth-manualVerification-label =
    .label = { auth-manualVerification }

auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }

auth-sharedSecret-label =
    .label = { auth-sharedSecret }

auth-manualInstruction = Entre em contacto com o parceiro de conversa pretendido por meio de outro canal autenticado, como um e-mail assinado por OpenPGP ou por telefone. Devem partilhar os respetivos identificadores digitais. (Um identificador digital é uma soma de verificação que identifica uma chave de encriptação.) Se o identificador corresponder, deve indicar na janela abaixo que você verificou o identificador digital.

auth-how = Como gostaria de confirmar a identidade do seu contacto?

auth-qaInstruction = Pense numa pergunta para a qual a resposta seja conhecida apenas por si e o seu contacto. Introduza a pergunta e a resposta e aguarde que o contacto entre. Se as respostas não corresponderem, o canal de comunicação que está a utilizar poderá estar sob vigilância.

auth-secretInstruction = Pense num segredo conhecido apenas por si e pelo seu contacto. Não utilize a mesma ligação à Internet para partilhar o segredo. Introduza o segredo e aguarde que o contacto entre. Se os segredos não coincidirem, o canal de comunicação que está a utilizar poderá estar sob vigilância.

auth-question = Introduza uma pergunta:

auth-answer = Introduza a resposta (diferencia maiúsculas de minúsculas):

auth-secret = Introduza o segredo:
