extends Node2D

var centroids: PackedVector2Array = PackedVector2Array()

func _draw() -> void:
	for c in centroids:
		draw_circle(c, 8, Color.RED)
