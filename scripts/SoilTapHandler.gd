extends Node2D

@export var soil_area: Area2D
@export var reaction_scenes: Array[PackedScene] = []
@export var reaction_container: Node2D

func _ready() -> void:
	print("SOIL SCENE: === SOIL TAP HANDLER STARTED ===")
	print("SOIL SCENE: Script running on: ", name)
	
	if not soil_area:
		print("SOIL SCENE: CRITICAL: soil_area export is NOT assigned!")
		return
	
	print("SOIL SCENE: soil_area is assigned → ", soil_area.name)
	soil_area.input_pickable = true
	
	if not soil_area.is_connected("input_event", _on_soil_input_event):
		soil_area.connect("input_event", _on_soil_input_event)
		print("SOIL SCENE: input_event signal connected")
	else:
		print("SOIL SCENE: signal was already connected")

func _on_soil_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#print("🖱️  === INPUT EVENT RECEIVED ON SOIL ===")
	#print("   Event type: ", event.get_class())
	
	if event is InputEventMouseButton:
		#print("   Mouse button event - Pressed: ", event.pressed, " Button: ", event.button_index)
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("SOIL SCENE: LEFT CLICK DETECTED ON SOIL!")
			handle_tap(event.position)
	#else:
		#print("   (Not a mouse button event)")

var last_reaction_index: int = -1

func handle_tap(global_pos: Vector2) -> void:
	print("SOIL SCENE: handle_tap called at position: ", global_pos)
	
	if reaction_scenes.size() < 3:
		print("⚠️ Only ", reaction_scenes.size(), " reactions available. Need at least 3.")
	
	# Pick random, avoid repeating the same one back-to-back
	var index = randi() % reaction_scenes.size()
	
	while index == last_reaction_index and reaction_scenes.size() > 1:
		index = randi() % reaction_scenes.size()
	
	var scene = reaction_scenes[index]
	
	print("SOIL SCENE: Spawning: ", scene.resource_path.get_file())
	
	var reaction = scene.instantiate()
	
	add_child(reaction)
	
	reaction.global_position = global_pos
	reaction.global_position += Vector2(randf_range(-12, 12), randf_range(-8, 8))  # ← Random small offset
	
	reaction.z_index = 20
	reaction.visible = true
	
	last_reaction_index = index
