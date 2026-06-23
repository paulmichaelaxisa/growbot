extends Node2D

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	print("WORM SCENE: Worm spawned at ", global_position)
	scale = Vector2(1.0, 1.0)   # adjust size per creature
	z_index = 15
	if sprite:
		sprite.play("idle")
		#%AnimationPlayer.play("wiggle")
		print("WORM SCENE: Playing 'idle' animation")
	else:
		%AnimationPlayer.play("wiggle")
		print("WORM SCENE: No Sprite child found in Worm!")
	
	# Auto despawn
	await get_tree().create_timer(randf_range(4.0, 8.0)).timeout
	print("WORM SCENE: Worm despawning")
	queue_free()
