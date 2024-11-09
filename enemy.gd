extends CharacterBody2D

const speed = 100
var current_dir = "none"
var enemy_in_range_toattack = false
var health = 100
var max_health = 100
var player_isalive = true
var is_attacking = false

func _ready():
	$AnimatedSprite2D.play("front_idle")
	get_window().content_scale_factor = 2.0

func _physics_process(delta):
	player_movement(delta)
	if Input.is_action_just_pressed("ui_attack") and enemy_in_range_toattack:
		perform_attack()

func player_movement(delta):
	if is_attacking:
		return

	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0

	move_and_slide()

# Phát hoạt ảnh tấn công và giảm máu enemy
func perform_attack():
	is_attacking = true
	$AnimatedSprite2D.play("attack")  # Giả sử có hoạt ảnh tấn công
	if enemy_in_range_toattack:
		var enemy = get_node("đường_dẫn_đến_enemy")  # Thay "đường_dẫn_đến_enemy" bằng đường dẫn đúng của enemy trong scene
		if enemy and enemy.has_method("reduce_health"):
			enemy.reduce_health(10)  # Giảm 10 máu cho mỗi đòn tấn công
	await $AnimatedSprite2D.animation_finished  # Chờ hoạt ảnh tấn công kết thúc
	is_attacking = false

func play_anim(movement):
	var dir = current_dir 
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	elif dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	elif dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
	elif dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")

# Phát hiện enemy trong vùng va chạm
func _on_player_hitbox_body_entered(body):
	if body.name == "enemy":
		enemy_in_range_toattack = true

# Khi enemy rời khỏi vùng tấn công
func _on_player_hitbox_body_exited(body):
	if body.name == "enemy":
		enemy_in_range_toattack = false
