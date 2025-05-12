extends CanvasLayer

@onready var main = $"../"

func _on_resume_pressed() -> void:
	main.pause()


func _on_quit_pressed() -> void:
	get_tree().quit()
