extends Node2D

@onready var dylan = $Dylan
@onready var dylan_body = $Dylan/AnimatedSprite2D_body
@onready var dylan_arm = $Dylan/AnimatedSprite2D_arm
var SPEED = 400
var JUMP_VELOCITY = -1600
var dylan_direction := 0
var dylan_jump = false

@onready var talking_container = $Dylan/Talking_Container
@onready var speech_scene = $Dylan/Talking_Container/Speech_bubble/Speech

@onready var black_overlay = $Dylan/Black_Overlay

@onready var butterfly = $Butterfly

@onready var intro_camera = $Dylan/Camera2D

@onready var game_butterfly = $"../game_butterfly"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intro_camera.make_current()
	butterfly.is_idle = true
	butterfly.collision_polygon.scale = Vector2(0.25,0.25)
	butterfly.set_meta("active", false)
	butterfly.sprite_butterfly.play("basic_flapping")
	
	dylan_direction = 1
	await get_tree().create_timer(3).timeout
	var tween_black_overlay = create_tween()
	
	tween_black_overlay.tween_property(black_overlay, "color", Color(0.0, 0.0, 0.0, 0.85), 2.0)
	await get_tree().create_timer(2).timeout
	var tween_talking_container_opacity = create_tween()
	tween_talking_container_opacity.tween_property(talking_container, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)
	await get_tree().create_timer(1).timeout
	speech_scene.text = "[type speed=50]" + dylan_lines[0]
	await get_tree().create_timer(4).timeout
	speech_scene.text = "[type speed=50]" + dylan_lines[1]
	await get_tree().create_timer(5).timeout
	speech_scene.text = "[type speed=50]" + dylan_lines[2]
	await get_tree().create_timer(3).timeout
	
	tween_talking_container_opacity = create_tween()
	tween_talking_container_opacity.tween_property(talking_container, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
	await get_tree().create_timer(0.5).timeout
	tween_black_overlay = create_tween()
	tween_black_overlay.tween_property(black_overlay, "color", Color(0.0, 0.0, 0.0, 0), 2.0)
	
	while dylan.position.x < 8700: 
		await get_tree().process_frame
	
	dylan_direction = 0
	
	var tween_arm_rotation = create_tween()
	tween_arm_rotation.tween_property(dylan_arm, "rotation_degrees", -125, 0.5)
	await get_tree().create_timer(0.75).timeout
	butterfly.visible = false
	tween_arm_rotation = create_tween()
	tween_arm_rotation.tween_property(dylan_arm, "rotation_degrees", 0, 0.5)
	await get_tree().create_timer(1).timeout
	
	dylan_direction = 1
	
	await get_tree().create_timer(1).timeout
	
	tween_black_overlay = create_tween()
	tween_black_overlay.tween_property(black_overlay, "color", Color(0.0, 0.0, 0.0, 1), 3.0)
	await get_tree().create_timer(4).timeout
	self.process_mode = Node.PROCESS_MODE_DISABLED
	game_butterfly.process_mode = Node.AUTO_TRANSLATE_MODE_INHERIT
	game_butterfly.main_camera.make_current()
	game_butterfly.visible = true
	self.visible = false	


	

func _physics_process(delta: float) -> void:
	if not dylan.is_on_floor():
		dylan_body.stop()
		dylan.velocity += dylan.get_gravity() * delta

	# Handle jump.
	if dylan_jump and dylan.is_on_floor():
		dylan.velocity.y = JUMP_VELOCITY

	if dylan_direction:
		dylan_body.play("run")
		if dylan_direction == 1:
			dylan_body.flip_h = true
			dylan_arm.flip_h = true
			dylan_arm.position.x = 4
		else:
			dylan_body.flip_h = false
			dylan_arm.flip_h = false
			dylan_arm.position.x = -4
			
		dylan.velocity.x = dylan_direction * SPEED
	else:
		dylan_body.play("idle")
		dylan_arm.position.y = ARM_RESTING_POSITION
		dylan.velocity.x = move_toward(dylan.velocity.x, 0, SPEED)
		
	dylan.move_and_slide()

const ARM_RESTING_POSITION := -322
const ARM_Y_POSITION_BY_FRAME_WHEN_WALKING := [
	-315,-307,-319,-331, -318, -302, -321, -331
]

func _on_animated_sprite_2d_body_frame_changed() -> void:
	if dylan_body.animation == "run":
		dylan_arm.position.y = ARM_Y_POSITION_BY_FRAME_WHEN_WALKING[dylan_body.frame]	

var dylan_lines = [
	"Bro our anniversary is coming up and i still dont know what to get francia...",
	"Hmm, I always hear people talking about liking having butterflies in their stomach or something...",
	"I know! I could give her some!"
]
