extends CharacterBody2D

@onready var player := $"."
@onready var sprite_body := $AnimatedSprite2D_body

@onready var sprite_arm := $AnimatedSprite2D_arm
@onready var arm_timeout_timer := $AnimatedSprite2D_arm/Timer_arm_timeout
@onready var arm_swing_timer := $AnimatedSprite2D_arm/Timer_arm_swing

var arm_ready := true
var arm_level := 0

const SPEED = 400
const JUMP_VELOCITY = -1600

func _ready() -> void:
	sprite_arm.play("arm_%s" %arm_level)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		sprite_body.stop()
		velocity += get_gravity() * delta

	# Handle jump.
	if (Input.is_action_just_pressed("Space") or Input.is_action_just_pressed("W")) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("A", "D")
	if direction:
		sprite_body.play("run")
		if direction == 1:
			sprite_body.flip_h = true
			sprite_arm.flip_h = true
			sprite_arm.position.x = 4
		else:
			sprite_body.flip_h = false
			sprite_arm.flip_h = false
			sprite_arm.position.x = -4
			
		velocity.x = direction * SPEED
	else:
		sprite_body.play("idle")
		sprite_arm.position.y = ARM_RESTING_POSITION
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("Left Click"):
		do_arm_movement()
	elif arm_level == 3:
		sprite_arm.rotation_degrees = 0

func do_arm_movement() -> void:
	if not arm_ready:
		return
	sprite_arm.play("arm_%s" %arm_level)
	if arm_level == 0 or arm_level == 1:
		sprite_arm.look_at(get_global_mouse_position())
		sprite_arm.rotation_degrees -= 92
	elif arm_level == 2:
		pass
	elif arm_level == 3:
		sprite_arm.look_at(get_global_mouse_position())
		sprite_arm.rotation_degrees -= 92
	
	if arm_level != 3:
		arm_ready = false
		arm_swing_timer.start()
		
func _on_timer_arm_swing_timeout() -> void:
	sprite_arm.rotation_degrees = 0
	arm_timeout_timer.start()

func _on_timer_arm_timeout_timeout() -> void:
	arm_ready = true

const ARM_RESTING_POSITION := -322
const ARM_Y_POSITION_BY_FRAME_WHEN_WALKING := [
	-315,-307,-319,-331, -318, -302, -321, -331
]

func _on_animated_sprite_2d_body_frame_changed() -> void:
	if sprite_body.animation == "run":
		sprite_arm.position.y = ARM_Y_POSITION_BY_FRAME_WHEN_WALKING[sprite_body.frame]	
