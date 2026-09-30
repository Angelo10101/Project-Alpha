extends CharacterBody2D

const SPEED = 300.0
const MAX_HEALTH = 100.0

enum State {IDLE, RUN, ATTACK}

@export var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

@onready var _player_sprite = $AnimatedSprite2D

var _state: State = State.IDLE
var health: float = MAX_HEALTH

@export var ray_scene: PackedScene
@export var ray_count: int = 12
@export var burst_k: int = 10

func spawn_ray_burst() -> void:
	var burst_id := EntityManager.new_burst_id()
	for i in range(ray_count):
		var ray = ray_scene.instantiate()
		ray.direction = Vector2.RIGHT.rotated((TAU / ray_count) * i)
		ray.burst_id = burst_id
		get_tree().current_scene.add_child(ray)
		ray.global_position = global_position
		EntityManager.register_ray(ray)

func _unhandled_input(event):
	if event.is_action_pressed("fire_burst"):
		spawn_ray_burst()

func _ready() -> void:
	_player_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(_delta: float) -> void:
	if _state == State.ATTACK:
		velocity = Vector2.ZERO
	else:
		var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = dir * SPEED

		if Input.is_action_just_pressed("attack"):
			_shoot()
			_set_state(State.ATTACK)
		elif velocity.length() > 0.0:
			_set_state(State.RUN)
		else:
			_set_state(State.IDLE)

	if velocity.x != 0.0:
		_player_sprite.flip_h = velocity.x < 0.0

	move_and_slide()
	
func _shoot() -> void:
	if bullet_scene == null:
		return
	var bullet = bullet_scene.instantiate()
	
	bullet.global_position = global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.target = "mob"
	get_tree().current_scene.add_child(bullet)
	
func _take_damage(amount: float) -> void:
	health -= amount
	if health <= 0.0:
		_death()
		
func _death() -> void:
	# TODO: game has ended screen or just button that restarts for testing 
	queue_free()

func _set_state(new_state: State) -> void:
	if new_state == _state:
		return
	_state = new_state
	match _state:
		State.IDLE:
			_player_sprite.play("idle")
		State.RUN:
			_player_sprite.play("run")
		State.ATTACK:
			_player_sprite.play("attack")

func _on_animation_finished() -> void:
	if _state == State.ATTACK:
		_set_state(State.IDLE)
