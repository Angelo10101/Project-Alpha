extends Area2D

@export var speed: float = 400.0
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
