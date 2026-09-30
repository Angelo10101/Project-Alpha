extends Node2D

@export var speed: float = 500.0
@export var max_distance: float = 10000.0
@export var collision_mask: int = 1

var distance_travelled := 0.0
var direction: Vector2 = Vector2.RIGHT

var burst_id: int = -1

var current_collision: Dictionary = {}
var needs_collision_check := true

func _exit_tree() -> void:
	if burst_id >= 0:
		EntityManager.unregister_ray(self)

func check_collision(target_position: Vector2) -> Dictionary:
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		target_position,
		collision_mask
	)
	return get_world_2d().direct_space_state.intersect_ray(query)

func _physics_process(delta):
	var movement = speed * delta

	# Only cast a new ray when we dont have a valid one cached (start / after a bounce)
	if needs_collision_check:
		var remaining = max_distance - distance_travelled
		var target_position = global_position + direction * remaining
		current_collision = check_collision(target_position)
		needs_collision_check = false

	if not current_collision.is_empty() \
			and global_position.distance_to(current_collision.position) <= movement:
		# Will reach the collision point this frame so bounce
		var normal = current_collision.get("normal", Vector2.ZERO)
		global_position = current_collision.position + normal * 0.5
		if normal != Vector2.ZERO:
			direction = direction.bounce(normal)
		queue_redraw()
		needs_collision_check = true  # cast fresh ray next frame from new direction
	else:
		global_position += direction * movement

	distance_travelled += movement

	if distance_travelled >= max_distance:
		queue_free()

func _draw():
	var end = -direction * 50

	draw_circle(Vector2.ZERO, 3, Color.WHITE)
