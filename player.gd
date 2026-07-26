extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@onready var fade_layer: CanvasLayer = get_node("/root/Quarto/FadeLayer")

var mouse_sensitivity := 0.003
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var pode_mover: bool = false

const POSICAO_DE_PE := Vector3(0.0, 1.0, 0.0)
const ROTACAO_Y_DE_PE := 0.0
const ROTACAO_CAMERA_DE_PE := 0.0

const POSICAO_DEITADO := Vector3(-1.5, 0.5, -1.0)
const ROTACAO_Y_DEITADO := -90.0
const ROTACAO_CAMERA_DEITADA_X := -20.0
const ROTACAO_CAMERA_DEITADA_Z := 8.0

func _physics_process(delta: float) -> void:
	if not pode_mover:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _ready() -> void:
	position = POSICAO_DEITADO
	rotation.y = deg_to_rad(ROTACAO_Y_DEITADO)
	camera.rotation.x = deg_to_rad(ROTACAO_CAMERA_DEITADA_X)
	camera.rotation.z = deg_to_rad(ROTACAO_CAMERA_DEITADA_Z)

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await get_tree().process_frame
	fade_layer.set_black()
	iniciar_cutscene_acordando()

func _unhandled_input(event: InputEvent) -> void:
	if not pode_mover:
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5)

func iniciar_cutscene_acordando() -> void:
	await get_tree().create_timer(3.5).timeout

	await fade_layer.piscar_acordando()

	await get_tree().create_timer(3.0).timeout

	await fade_layer.mostrar_fala("...que horas são...", 1.8)
	await fade_layer.mostrar_fala("2:45?", 2.0)
	await fade_layer.mostrar_fala("De novo...", 2.0)
	await fade_layer.mostrar_fala("Não dormi nada essa noite.", 2.5)

	await fade_layer.fade_to_black(1.2)
	position = POSICAO_DE_PE
	rotation.y = deg_to_rad(ROTACAO_Y_DE_PE)
	camera.rotation.x = deg_to_rad(ROTACAO_CAMERA_DE_PE)
	camera.rotation.z = 0.0
	await fade_layer.fade_from_black(1.2)

	pode_mover = true
