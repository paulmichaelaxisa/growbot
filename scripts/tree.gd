# scripts/tree.gd
extends Area2D

@onready var seed_sprite: Sprite2D = $SeedSprite
@onready var sprout_sprite: Sprite2D = $SproutSprite
##@onready var grow_sound: AudioStreamPlayer2D = $GrowSound

var is_grown := false

func _ready() -> void:
	if sprout_sprite:
		sprout_sprite.scale = Vector2(0.01, 0.01)
		sprout_sprite.visible = false

func grow() -> void:
	if is_grown: return
	is_grown = true
	
	seed_sprite.visible = false
	sprout_sprite.visible = true
	
	var tween = create_tween()
	tween.tween_property(sprout_sprite, "scale", Vector2(0.1, 0.1), 10)
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(sprout_sprite, "position:y", sprout_sprite.position.y - 25, 1.5)	
	await tween.finished
	var lumi = get_tree().get_first_node_in_group("lumi")
	if lumi and lumi.has_method("celebrate"):
		lumi.celebrate()
	
##	if grow_sound:
##		grow_sound.play()
