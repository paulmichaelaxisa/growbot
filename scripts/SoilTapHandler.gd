# SoilTapHandler.gd
extends Node2D

@export var soil_area: Area2D
@export var reaction_scenes: Array[PackedScene] = []
@export var reaction_container: Node2D  # Optional dedicated container for reactions

var last_reaction_index: int = -1
var last_tap_grid_pos: Vector2i = Vector2i.ZERO

func _ready() -> void:
	if not soil_area:
		push_warning("SoilTapHandler: soil_area not assigned")
		return
	
	soil_area.input_pickable = true
	soil_area.connect("input_event", _on_soil_input_event)
	
	if not reaction_container:
		reaction_container = self

func _on_soil_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		handle_tap(event.position)

func handle_tap(global_pos: Vector2) -> void:
	var local_pos = to_local(global_pos)
	
	# Gentle grid snapping so reactions feel intentional
	var grid_pos = (local_pos / 24.0).floor()
	
	# Choose reaction (avoid immediate repeat in same area)
	var index = randi() % reaction_scenes.size()
	if index == last_reaction_index and grid_pos == last_tap_grid_pos:
		index = (index + 1) % reaction_scenes.size()
	
	last_reaction_index = index
	last_tap_grid_pos = grid_pos
	
	spawn_reaction(reaction_scenes[index], local_pos)
	trigger_lumi_glance()

func spawn_reaction(scene: PackedScene, pos: Vector2) -> void:
	if not scene:
		return
	
	var reaction = scene.instantiate() as Node2D
	if not reaction:
		return
	
	# Small random offset for natural feel
	reaction.position = pos + Vector2(
		randf_range(-12, 12),
		randf_range(-8, 8)
	)
	reaction.scale = Vector2(0.7, 0.7)
	
	reaction_container.add_child(reaction)
	
	# Auto cleanup
	var timer := Timer.new()
	timer.wait_time = randf_range(4.0, 9.0)
	timer.one_shot = true
	timer.timeout.connect(reaction.queue_free)
	add_child(timer)
	timer.start()
	
	# Optional: tiny dust particle spawn here later

func trigger_lumi_glance() -> void:
	# Call this on your Lumi node (use get_node or signal)
	var lumi = get_tree().get_first_node_in_group("lumi")
	if lumi and lumi.has_method("play_glance"):
		lumi.play_glance()
