extends Node2D

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	print("DUCK SCENE: Duck spawned at ", global_position)
	scale = Vector2(1.0, 1.0)   # adjust size per creature
	z_index = 15	
	if sprite:
		sprite.play("idle")
		#%AnimationPlayer.play("wiggle")
		print("DUCK SCENE: Playing 'idle' animation")
	else:
		%AnimationPlayer.play("wiggle")
		print("DUCK SCENE: No Sprite child found in Duck!")
	
	# Auto despawn
	await get_tree().create_timer(randf_range(4.0, 8.0)).timeout
	print("DUCK SCENE: Duck despawning")
	queue_free()
