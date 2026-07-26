extends CanvasLayer

@onready var fade_rect: ColorRect = $FadeRect
@onready var subtitle_label: Label = $SubtitleLabel

func _ready() -> void:
	fade_rect.modulate.a = 0.0
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	subtitle_label.modulate.a = 0.0
	subtitle_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

func set_black() -> void:
	fade_rect.modulate.a = 1.0

func fade_to_black(duration: float = 1.0) -> void:
	var tween := create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, duration)
	await tween.finished

func fade_from_black(duration: float = 1.0) -> void:
	var tween := create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, duration)
	await tween.finished

func piscar_acordando() -> void:
	var alphas := [0.9, 0.7, 0.85, 0.5, 0.7, 0.3, 0.5, 0.0]
	for i in alphas.size():
		var duration := 0.9 if i == alphas.size() - 1 else 0.25
		var tween := create_tween()
		tween.tween_property(fade_rect, "modulate:a", alphas[i], duration)
		await tween.finished
		if i < alphas.size() - 1:
			await get_tree().create_timer(0.25).timeout

func mostrar_fala(texto: String, duracao: float = 2.5) -> void:
	subtitle_label.text = texto

	var fade_in := create_tween()
	fade_in.tween_property(subtitle_label, "modulate:a", 1.0, 0.4)
	await fade_in.finished

	await get_tree().create_timer(duracao).timeout

	var fade_out := create_tween()
	fade_out.tween_property(subtitle_label, "modulate:a", 0.0, 0.4)
	await fade_out.finished
