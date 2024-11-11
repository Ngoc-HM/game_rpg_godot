extends ProgressBar

@export var player: Player  # Drag and drop your player node in the editor

func _ready():
	if player:
		player.healthChanged.connect(update_health_bar)

func update_health_bar(current_health, max_health):
	value = (current_health / max_health) * 100  # Calculate percentage
	self.value = value
 
