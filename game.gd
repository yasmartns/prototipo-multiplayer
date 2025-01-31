extends Node2D

var peer = ENetMultiplayerPeer.new()
const PORT = 3333
const ADDRESS = "127.0.0.1"
@onready var log = $Log
@onready var ui = $MultiplayerUI
@export var player_scene:PackedScene

func _on_botao_join_pressed() -> void:
	var resultado = peer.create_client(ADDRESS, PORT)
	
	if resultado == OK:
		multiplayer.multiplayer_peer = peer
		log.text += "Conectado ao servidor! \n"
	else:
		log.text += "Nao foi possivel se conectar! Erro: "+str(resultado)+"\n"
	
	

func _on_botao_host_pressed() -> void:
	var resultado = peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(player_conectado)
	if resultado == OK:
		log.text += "Servidor criado na porta "+str(PORT)+"!\n"
	else:
		log.text += "Erro ao criar servidor! Codigo do erro: "+str(resultado)+"\n"
		
func player_conectado(id_jogador):
	log.text += "Cliente "+str(id_jogador)+"conectado ao servidor!\n"
	
@rpc("any_peer", "call_local", "reliable")
func atualizar_log(novo_log):
	log.text + novo_log
