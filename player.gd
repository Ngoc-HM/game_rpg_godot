extends CharacterBody2D

const speed = 100
var current_dir = "none"
var enemy_in_range_toattack = false
var enemy_attack_cooldown = true
var health = 100
var max_health = 100
var player_isalive = true

func _ready():
	$AnimatedSprite2D.play("front_idle")
	get_window().content_scale_factor = 4.0

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()

func player_movement(delta):
	
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
		


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_range_toattack = true
	
func player():
	pass

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_range_toattack = false

func enemy_attack():
	if enemy_in_range_toattack:
			push_error("player - 10 health")
