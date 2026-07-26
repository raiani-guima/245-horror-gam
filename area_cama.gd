extends Area3D

var player_perto: bool = false
var dormindo: bool = false

@onready var fade_layer: CanvasLayer = get_node("/root/Quarto/FadeLayer")

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_perto = true

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_perto = false

func _unhandled_input(event: InputEvent) -> void:
	if player_perto and not dormindo and event.is_action_pressed("interagir"):
		dormir()

func dormir() -> void:
	dormindo = true
	await fade_layer.fade_to_black(1.5)
	await get_tree().create_timer(1.0).timeout
	await fade_layer.fade_from_black(1.5)
	dormindo = false
