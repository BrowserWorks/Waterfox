# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

start-label = Iniciar uma conversa encriptada
refresh-label = Renovar a conversa encriptada
auth-label = Confirmar a identidade do seu contacto
reauth-label = Confirmar novamente a identidade do seu contacto

auth-cancel = Cancelar

auth-error = Ocorreu um erro ao confirmar a identidade do seu contacto.
auth-success = A confirmação da identidade do seu contacto foi concluída com sucesso.
auth-fail = Falha ao confirmar a identidade do seu contacto.
auth-waiting = A aguardar que o seu contacto termine a confirmação…

finger-verify = Confirmar

# Do not translate 'OTR' (name of an encryption protocol)
buddycontextmenu-label = Adicionar identificador OTR

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-start = A tentar iniciar uma conversa encriptada com { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-refresh = A tentar renovar uma conversa encriptada com { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-unseen = A identidade de { $name } ainda não foi confirmada. A escuta casual não é possível, mas com algum esforço alguém pode ter acesso à conversa. Impeça a vigilância confirmando a identidade deste contacto.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-seen = { $name } está a contactá-lo a partir de um computador não reconhecido. A escuta casual não é possível, mas com algum esforço alguém pode ter acesso à conversa. Impeça a vigilância confirmando a identidade deste contacto.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-unverified = A conversa atual é encriptada, mas não é privada, pois a identidade de { $name } ainda não foi confirmada.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-private = A identidade de { $name } foi verificada. A conversa atual é encriptada e privada.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-finished = { $name } terminou a conversa encriptada consigo; você deve fazer o mesmo.

state-unverified-label = Não confirmado
state-private-label = Privado
state-finished-label = Concluído

# Variables:
#   $name (String) - the screen name of a chat contact person
verify-request = { $name } solicitou a confirmação da sua identidade.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-private = Você confirmou a identidade de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-unverified = A identidade de { $name } não foi confirmada.

verify-title = Confirmar a identidade do seu contacto
error-title = Erro
success-title = Encriptação ponto a ponto
fail-title = Não foi possível confirmar
waiting-title = Pedido de confirmação enviado

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $error (String) - contains an error message that describes the cause of the failure
otr-genkey-failed = Não foi possível gerar a chave OTR privada: { $error }
