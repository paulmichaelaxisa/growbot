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
	print("👀 Lumi glancing towards soil tap")
	
	var anim_player = get_node_or_null("%AnimationPlayer")  # or $AnimationPlayer
	
	if anim_player:
		if anim_player.has_animation("glance"):
			anim_player.play("glance")
		elif anim_player.has_animation("idle"):
			anim_player.play("idle")      # fallback
		elif anim_player.has_animation("blink"):
			anim_player.play("blink")
	else:
		print("⚠️ No AnimationPlayer found on Lumi")
	
	# Cute little curiosity bounce
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.12, 0.92), 0.12)
	tween.tween_property(self, "scale", Vector2(0.95, 1.08), 0.18)
	tween.tween_property(self, "scale", Vector2.ONE, 0.15)
