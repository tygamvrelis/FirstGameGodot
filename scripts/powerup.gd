extends Block

class_name Powerup

enum PowerupType {
	AIR_JUMP
}

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var powerup_sound = $PowerupSound

@onready var player = %Player

@export var powerup_type: PowerupType = PowerupType.AIR_JUMP

var activated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("default")

func activate():
	activated = true
	collision_shape_2d.queue_free()
	animation_player.play("RESET")
	powerup_sound.play()
	
	match powerup_type:
		PowerupType.AIR_JUMP:
			player.powerup_air_jump()

func bump():
	if activated:
		return
	super.bump()
	activate()
