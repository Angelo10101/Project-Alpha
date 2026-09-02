extends Area2D

@export var speed: float = 400.0
@export var damage: float = 10.0
@export var target: String = "mob"

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	body_entered.connect(_hitbox_tag)
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _hitbox_tag(body: Node2D) -> void:
	if not body.is_in_group(target):
		return
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
