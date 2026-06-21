# scripts/lumi.gd
extends Node2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

var _is_reacting := false

func _ready() -> void:
	add_to_group("lumi")
	%AnimationPlayer.play("idle")

# Call this from the tree when growth finishes
func celebrate() -> void:
	if _is_reacting:
		return
	_is_reacting = true
	
	# Bounce animation
	%AnimationPlayer.play("walk")
	
	# Joyful sound
	if sound:
		sound.play()
	
	# Return to idle after 2-3 seconds
	await get_tree().create_timer(20).timeout
	%AnimationPlayer.play("idle")
	_is_reacting = false

func play_glance() -> void:
	# Simple head turn or idle variation
	%AnimationPlayer.play("idle")  # or a new short glance animation
