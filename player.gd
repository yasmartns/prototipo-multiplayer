extends CharacterBody2D

const SPEED = 300.0
@onready var rotulo_nome = $NomeJogador

func _ready() -> void:
	rotulo_nome.text = self.name

func _physics_process(delta: float) -> void:
	var direction_horizontal := Input.get_axis("ui_left", "ui_right")
	if direction_horizontal:
		velocity.x = direction_horizontal * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	var direction_vertical := Input.get_axis("ui_up", "ui_down")
	if direction_vertical:
		velocity.y = direction_vertical * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
