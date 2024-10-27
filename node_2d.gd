extends Node2D

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	video_player.play()

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://main_manu.tscn")
