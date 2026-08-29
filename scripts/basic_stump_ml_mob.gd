extends CharacterBody2D

@export var speed: float = 120.0
@export var bullet_scene: PackedScene
@export var fire_cooldown: float = 0.5

var _cooldown_timer: float = 0.0

func _physics_process(delta: float) -> void:
	_cooldown_timer = max(0.0, _cooldown_timer - delta)

	var decision = $"/root/MLController".get_action(self, get_player_position())
	apply_action(decision.move, decision.shoot)

	move_and_slide()

# Called by ml_controller.gd (or later, the AIController) each step.
func apply_action(move_dir: Vector2, want_shoot: bool) -> void:
	velocity = move_dir.normalized() * speed
	if want_shoot and _cooldown_timer <= 0.0:
		_shoot()

func _shoot() -> void:
	_cooldown_timer = fire_cooldown
	if bullet_scene == null:
		return
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.direction = (get_player_position() - global_position).normalized()
	get_tree().current_scene.add_child(bullet)

func get_player_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("player")
	return player.global_position if player else global_position