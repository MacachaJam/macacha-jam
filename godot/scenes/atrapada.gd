extends Node2D

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	SceneSwitcher.change_to_file_with_transition("uid://bo4k0aec7e628", "", Transition.Effect.FADE, Transition.Effect.FADE)
