extends HSlider

@export var property:String = ""
@export var enable_property:String = ""

func _ready():
	value = UserSettings.get_value(property)

func _on_float_range_game_settings_option_value_changed(val):
	UserSettings.set_value(property, val)
	if enable_property:
		UserSettings.set_value(enable_property, val != 0)
