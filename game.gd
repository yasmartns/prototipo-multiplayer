extends Node2D

var peer = ENetMultiplayerPeer.new()
const ADDRESS = "127.0.0.1"
const PORT =  3333
@onready var log = $Log
@onready var ui = $MultiplayerUI
@export var jogador_scene : PackedScene

#Exibir mensagem quando o servidor for criado e exibir mensagens sempre que
#um usuário se conectar
#Esconder menu de Multiplayer ao se conectar ou criar servidor com sucesso

#Na função de join, identificar se o jogador conseguiu se conectar. Se não conseguir
#exibir no log "Falha ao conectar ao servidor"
func _on_botao_join_pressed() -> void:
	var resultado = peer.create_client(ADDRESS, PORT)
	
	if resultado == OK:
		multiplayer.multiplayer_peer = peer
		log.text += "Conectado ao servidor! \n"
		ui.visible = false
	else:
		log.text += "Não foi possivel se conectar! Erro: "+str(resultado)+"\n"


func _on_botao_host_pressed() -> void:
	var resultado = peer.create_server(PORT)
	
	if resultado == OK:
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(player_conectado)
		log.text += "Servidor criado na porta "+str(PORT)+"!\n"
		ui.visible = false
		#criar personagem
		adicionar_jogador(multiplayer.get_unique_id())
	
	else:
		log.text += "Erro ao criar servidor! Código do erro: "+str(resultado) +"\n"
		
	
#Na função player_conectado realizar uma chamada rpc, para a função atualizar_log
#Deve rodar o adicionar_jogador
#Colocar um label no player para exibir o seu número de id
func player_conectado(id_jogador):
	log.text += "Cliente "+str(id_jogador)+" conectado ao servidor!\n"
	#Chamada rpc aqui
	rpc("atualizar_log", log.text)
	adicionar_jogador(id_jogador)
	
func adicionar_jogador(id_jogador):
	var novo_jogador = jogador_scene.instantiate()
	novo_jogador.name = str(id_jogador)
	add_child(novo_jogador)
	
#Criar a função atualizar_log em que recebe o log.text do servidor e modifica o próprio log
@rpc("any_peer", "call_local", "reliable")
func atualizar_log(novo_log):
	log.text = novo_log
