extends CharacterBody2D

class_name Player
signal healthChanged(current_health, max_health)


const speed = 1000
var current_dir = "none"
var enemy_in_range_toattack = false
var enemy_attack_cooldown = true
@onready var health: int = max_health
@export var max_health = 50
var player_isalive = true
var is_attacking = false  # Thêm biến để kiểm soát trạng thái tấn công
@export var health_fruit = 0

func _ready():
	$AnimatedSprite2D.play("front_idle")
	get_window().content_scale_factor = 1.0
	$AttackCooldownTimer.connect("timeout", Callable(self, "_on_attack_cooldown_timeout"))
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_attack_animation_finished"))
	

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	# Kiểm tra phím T để tấn công
	if Input.is_action_just_pressed("ui_attack") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D.play("back_attack")
		$AttackCooldownTimer.start()  # Bắt đầu bộ đếm thời gian cooldown

func player_movement(delta):
	if is_attacking:  # Khi đang tấn công, không cho phép di chuyển
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

func play_anim(movement):
	var dir = current_dir 
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")
			
func take_damage(amount):
	if health > 0:
		health -= amount
		if health < 0:
			health = 0
		healthChanged.emit(health, max_health)
	
func enemy_attack():
	if enemy_in_range_toattack and enemy_attack_cooldown and player_isalive:
		take_damage(10)
		enemy_attack_cooldown = false
		$AttackCooldownTimer.start()

# Reset trạng thái tấn công sau khi cooldown hoàn thành
func _on_attack_cooldown_timeout():
	is_attacking = false
	enemy_attack_cooldown = true

# Hàm gọi khi hoạt ảnh tấn công kết thúc
func _on_attack_animation_finished():
	if is_attacking and $AnimatedSprite2D.animation == "back_attack":
		is_attacking = false
		play_anim(0)  # Quay về trạng thái idle

func _on_player_hitbox_body_entered(body):
	print("Body entered:", body.name)
	if body.has_method("enemy"):
		enemy_in_range_toattack = true

func _on_player_hitbox_body_exited(body):
	print("Body exited:", body.name)
	if body.has_method("enemy"):
		enemy_in_range_toattack = false

# Handle player death
func _on_player_death():
	print("Player is dead")
	$AnimatedSprite2D.play("front_death")  # Play death animation
	# Any additional death handling like stopping player movement
