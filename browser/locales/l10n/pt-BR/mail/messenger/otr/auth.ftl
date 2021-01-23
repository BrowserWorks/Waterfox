# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Verificar identidade do contato
    .buttonlabelaccept = Verificar

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Verificar a identidade de { $name }

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Impressão digital sua, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Impressão digital de { $their_name }:

auth-help = Verificar a identidade de um contato ajuda a garantir que a conversa seja realmente privativa, tornando muito difícil para terceiros escutar ou manipular a conversa.
auth-helpTitle = Ajuda de verificação

auth-questionReceived = Esta é a pergunta feita pelo seu contato:

auth-yes =
    .label = Sim

auth-no =
    .label = Não

auth-verified = Verifiquei que esta é de fato a impressão digital correta.

auth-manualVerification = Verificação manual de impressão digital
auth-questionAndAnswer = Pergunta e resposta
auth-sharedSecret = Segredo compartilhado

auth-manualVerification-label =
    .label = { auth-manualVerification }

auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }

auth-sharedSecret-label =
    .label = { auth-sharedSecret }

auth-manualInstruction = Entre em contato com a pessoa com quem conversar por meio de outro canal autenticado, como e-mail assinado com OpenPGP ou por telefone. Vocês devem dizer um ao outro suas impressões digitais (uma impressão digital é um código de verificação que identifica uma chave de criptografia). Se a impressão digital combinar, você deve indicar no diálogo abaixo que verificou a impressão digital.

auth-how = Como você quer verificar a identidade do seu contato?

auth-qaInstruction = Pense numa pergunta cuja resposta seja conhecida apenas por você e seu contato. Digite a pergunta e a resposta e aguarde o contato digitar a mesma resposta. Se as respostas não combinarem, o canal de comunicação que você está usando pode estar sob vigilância.

auth-secretInstruction = Pense em um segredo conhecido apenas por você e seu contato. Não use a mesma conexão de internet para trocar o segredo. Digite o segredo e aguarde o contato também digitar. Se os segredos não coincidirem, o canal de comunicação que você está usando pode estar sob vigilância.

auth-question = Digite uma pergunta:

auth-answer = Digite a resposta (diferencia maiúsculas de minúsculas):

auth-secret = Digite o segredo:
