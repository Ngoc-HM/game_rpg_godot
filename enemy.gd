extends CharacterBody2D

var speed = 100  # Tốc độ của enemy
var health = 50  # Sức khỏe của enemy
var attack_damage = 10  # Sát thương gây ra cho player
var player_chase = false
var player = null

func _ready():
	# Kết nối các tín hiệu cho vùng phát hiện và tấn công
	$detection_area.connect("body_entered", Callable(self, "_on_detection_area_body_entered"))
	$detection_area.connect("body_exited", Callable(self, "_on_detection_area_body_exited"))
	$attack_player.connect("body_entered", Callable(self, "_on_attack_player_body_entered"))
	$attack_player.connect("body_exited", Callable(self, "_on_attack_player_body_exited"))



func _physics_process(delta):
	# Enemy sẽ đuổi theo player nếu ở trong phạm vi phát hiện
	if player_chase and player != null:
		position += (player.position - position).normalized() * speed * delta

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		player_chase = false

func _on_attack_player_body_entered(body):
	if body.is_in_group("Player"):
		$AnimatedSprite2D.play("attack")
		body.health -= attack_damage  # Gây sát thương cho player
		if body.health <= 0:
			body.health = 0
			print("Player is dead")  # Thông báo player đã chết
		print("Player health:", body.health)
		print("Enemy health:", health)

func _on_attack_player_body_exited(body):
	if body.is_in_group("Player"):
		$AnimatedSprite2D.play("idle")  # Quay về trạng thái "idle" khi player rời khỏi vùng tấn công
