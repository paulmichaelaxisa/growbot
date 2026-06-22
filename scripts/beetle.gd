extends Node2D

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	print("🐞 Beetle spawned at ", global_position)
	if sprite:
		sprite.play("idle")
		print("   Playing 'idle' animation")
	else:
		print("❌ No Sprite child found in Beetle!")
	
	# Auto despawn
	await get_tree().create_timer(randf_range(4.0, 8.0)).timeout
	print("🐞 Beetle despawning")
	queue_free()
