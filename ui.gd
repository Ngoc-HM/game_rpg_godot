extends CanvasLayer

@export var player: Player
@export var health_bar: ProgressBar

func _ready():
	if player:
		player.healthChanged.connect(update_health_bar)

func update_health_bar(current_health, max_health):
	if health_bar:
		health_bar.value = (current_health / max_health) * 100
