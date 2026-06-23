# scripts/lumi.gd
extends Node2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

var _is_reacting := false

func _ready() -> void:
	add_to_group("lumi")
	%AnimationPlayer.play("idle")
	print("LUMI SCENE: Current lumi annimcation: ", %AnimationPlayer.current_animation)

# Call this from the tree when growth finishes
func celebrate() -> void:
	if _is_reacting:
		return
	_is_reacting = true
	
	# Bounce animation
	%AnimationPlayer.play("walk")
	print("LUMI SCENE: Current lumi annimcation: ", %AnimationPlayer.current_animation)
	
	# Joyful sound
	if sound:
		sound.play()
	
	# Return to idle after 2-3 seconds
	await get_tree().create_timer(10).timeout
	print ("LUMI SCENE: timeout - Return to idle")
	%AnimationPlayer.play("idle")
	print("LUMI SCENE: Current lumi annimcation: ", %AnimationPlayer.current_animation)
	_is_reacting = false

func play_glance() -> void:
	# Simple head turn or idle variation
	%AnimationPlayer.play("hurt")  # or a new short glance animation
