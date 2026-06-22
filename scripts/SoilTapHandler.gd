extends Node2D

@export var soil_area: Area2D
@export var reaction_scenes: Array[PackedScene] = []
@export var reaction_container: Node2D

func _ready() -> void:
	print("🔍 === SOIL TAP HANDLER STARTED ===")
	print("   Script running on: ", name)
	
	if not soil_area:
		print("❌ CRITICAL: soil_area export is NOT assigned!")
		return
	
	print("✅ soil_area is assigned → ", soil_area.name)
	soil_area.input_pickable = true
	
	if not soil_area.is_connected("input_event", _on_soil_input_event):
		soil_area.connect("input_event", _on_soil_input_event)
		print("   input_event signal connected")
	else:
		print("   signal was already connected")

func _on_soil_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	print("🖱️  === INPUT EVENT RECEIVED ON SOIL ===")
	print("   Event type: ", event.get_class())
	
	if event is InputEventMouseButton:
		print("   Mouse button event - Pressed: ", event.pressed, " Button: ", event.button_index)
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("✅ LEFT CLICK DETECTED ON SOIL!")
			handle_tap(event.position)
	else:
		print("   (Not a mouse button event)")

func handle_tap(global_pos: Vector2) -> void:
	print("🌱 handle_tap called at position: ", global_pos)
	
	if reaction_scenes.is_empty():
		print("❌ No reaction scenes assigned!")
		return
	
	var reaction = reaction_scenes[0].instantiate()
	add_child(reaction)
	
	reaction.global_position = global_pos
	reaction.z_index = 20          # ← Make sure it's on top
	reaction.modulate.a = 1.0      # ← Ensure full opacity
	reaction.visible = true        # ← Force visible
	
	print("   Reaction spawned at GLOBAL: ", reaction.global_position, " z=", reaction.z_index)
