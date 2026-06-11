# scripts/cloud.gd
extends Area2D

@onready var rain_particles: GPUParticles2D = $RainParticles
@onready var detection_area: Area2D = $CloudDetectionArea

var _dragging := false
var _drag_offset := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and _is_point_inside(event.position):
			_dragging = true
			_drag_offset = global_position - event.position
		else:
			_dragging = false

	elif event is InputEventMouseMotion and _dragging:
		global_position = event.position + _drag_offset

func _is_point_inside(point: Vector2) -> bool:
	var space := get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = point
	query.collide_with_areas = true
	query.collision_mask = collision_layer
	var results := space.intersect_point(query)
	for result in results:
		if result.collider == self:
			return true
	return false

func _ready() -> void:
	rain_particles.emitting = false
	# Connect signals
	detection_area.area_entered.connect(_on_detection_area_entered)
	detection_area.area_exited.connect(_on_detection_area_exited)

func _on_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("tree"):
		rain_particles.emitting = true
		if area.has_method("grow"):   # Safe call
			area.grow()

func _on_detection_area_exited(area: Area2D) -> void:
	if area.is_in_group("tree"):
		rain_particles.emitting = false
