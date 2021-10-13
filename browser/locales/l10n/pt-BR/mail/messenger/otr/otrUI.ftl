# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

start-label = Iniciar uma conversa criptografada
refresh-label = Restaurar a conversa criptografada
auth-label = Verificar a identidade do seu contato
reauth-label = Verificar novamente a identidade do seu contato

auth-cancel = Cancelar
auth-cancel-access-key = C

auth-error = Ocorreu um erro ao verificar a identidade do seu contato.
auth-success = A verificação da identidade do seu contato foi concluída com êxito.
auth-success-them = Seu contato verificou sua identidade com sucesso. Você também pode verificar a identidade dele fazendo sua própria pergunta.
auth-fail = Falha ao verificar a identidade do seu contato.
auth-waiting = Aguardando o contato concluir a verificação…

finger-verify = Verificar
finger-verify-access-key = V

# Do not translate 'OTR' (name of an encryption protocol)
buddycontextmenu-label = Adicionar impressão digital OTR

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-start = Tentando iniciar uma conversa criptografada com { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-refresh = Tentando restaurar a conversa criptografada com { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-gone-insecure = Terminou a conversa criptografada com { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-unseen = A identidade de { $name } ainda não foi verificada. Não é possível escuta ocasional, mas com algum esforço alguém pode estar ouvindo. Impeça a vigilância verificando a identidade desse contato.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-seen = { $name } está entrando em contato com você a partir de um computador não reconhecido. Não é possível escuta ocasional, mas com algum esforço alguém pode estar ouvindo. Impeça a vigilância verificando a identidade desse contato.

state-not-private = A conversa atual não é privativa.

state-generic-not-private = A conversa atual não é privativa.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-unverified = A conversa atual é criptografada, mas não privativa, pois a identidade de { $name } ainda não foi verificada.

state-generic-unverified = A conversa atual é criptografada, mas não privativa, pois algumas identidades ainda não foram verificadas.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-private = A identidade de { $name } foi verificada. A conversa atual é criptografada e privativa.

state-generic-private = A conversa atual é criptografada e privativa.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-finished = { $name } encerrou a conversa criptografada. Você deve fazer o mesmo.

state-not-private-label = Não seguro
state-unverified-label = Não verificada
state-private-label = Privativa
state-finished-label = Concluído

# Variables:
#   $name (String) - the screen name of a chat contact person
verify-request = { $name } solicitou a verificação de sua identidade.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-private = Você verificou a identidade de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-unverified = A identidade de { $name } não foi verificada.

verify-title = Verifique a identidade do seu contato
error-title = Erro
success-title = Criptografia de ponta a ponta
success-them-title = Verificar a identidade do contato
fail-title = Não foi possível verificar
waiting-title = Pedido de verificação enviado

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $error (String) - contains an error message that describes the cause of the failure
otr-genkey-failed = Falha na geração da chave privada OTR: { $error }
