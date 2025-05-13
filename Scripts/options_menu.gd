extends CanvasLayer


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)


func _on_mute_button_toggled(toggled_on: bool) -> void:
	$MarginContainer/VBoxContainer/MuteMargin/MuteButton.release_focus()

func _on_background_color_picker_button_color_changed(color: Color) -> void:
	pass # Replace with function body.
