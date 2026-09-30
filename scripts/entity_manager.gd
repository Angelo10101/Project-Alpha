extends Node

var _active_rays: Array[Node2D] = []
var _bursts: Dictionary = {}  # NEW burst_id -> Array of rays
var _burst_centroids: Dictionary = {}  # NEW burst_id -> PackedVector2Array
var _next_burst_id := 0  # NEW
var last_centroids: PackedVector2Array = PackedVector2Array()

@export var k: int = 10
@export var recompute_interval: int = 10  # frames between k-means runs

var _frame_count := 0

func _process(_delta: float) -> void:
	_frame_count += 1
	if _frame_count < recompute_interval:
		return
	_frame_count = 0

	# one k-means run per burst instead of one global run
	last_centroids = PackedVector2Array()
	for id in _bursts.keys():
		var positions = get_burst_ray_positions(id)
		var n = mini(k, positions.size())
		_burst_centroids[id] = k_means_rays(positions, n, _burst_centroids.get(id, PackedVector2Array()))
		last_centroids.append_array(_burst_centroids[id])

	_marker.centroids = last_centroids
	_marker.queue_redraw()

func new_burst_id() -> int:  # NEW
	_next_burst_id += 1
	return _next_burst_id

func register_ray(ray: Node2D) -> void:
	if not _active_rays.has(ray):
		_active_rays.append(ray)
		if ray.burst_id >= 0:  # NEW
			if not _bursts.has(ray.burst_id):
				_bursts[ray.burst_id] = []
			_bursts[ray.burst_id].append(ray)

func unregister_ray(ray: Node2D) -> void:
	_active_rays.erase(ray)
	var id = ray.burst_id  # NEW
	if _bursts.has(id):
		_bursts[id].erase(ray)
		if _bursts[id].is_empty():
			_bursts.erase(id)
			_burst_centroids.erase(id)

func get_ray_positions() -> PackedVector2Array:
	var ray_positions := PackedVector2Array()
	ray_positions.resize(_active_rays.size())
	for i in range(len(_active_rays)):
		ray_positions[i] = _active_rays[i].global_position
	return ray_positions

func get_burst_ray_positions(burst_id: int) -> PackedVector2Array:  # NEW
	var rays: Array = _bursts.get(burst_id, [])
	var ray_positions := PackedVector2Array()
	ray_positions.resize(rays.size())
	for i in range(rays.size()):
		ray_positions[i] = rays[i].global_position
	return ray_positions

var _marker: Node2D

func _ready() -> void:
	_marker = Node2D.new()
	_marker.set_script(preload("res://scripts/centroid_marker.gd"))
	add_child(_marker)

func k_means_rays(ray_positions: PackedVector2Array, k: int, centroids: PackedVector2Array = PackedVector2Array(), iterations: int = 10) -> PackedVector2Array:
	if centroids.is_empty():
		var indices := range(ray_positions.size())
		indices.shuffle()
		var picked := PackedVector2Array()
		for i in k:
			picked.append(ray_positions[indices[i]])
		centroids = picked
	
	for _iter in iterations:
		var closest_dist_sq := PackedFloat32Array()
		var centroid_group := PackedInt32Array()
		closest_dist_sq.resize(ray_positions.size())
		centroid_group.resize(ray_positions.size())
		closest_dist_sq.fill(-1.0)
		
		for i in ray_positions.size():
			for j in centroids.size():
				var d = ray_positions[i].distance_squared_to(centroids[j])
				if closest_dist_sq[i] == -1.0 or d < closest_dist_sq[i]:
					closest_dist_sq[i] = d
					centroid_group[i] = j
		
		var centroid_mean := PackedVector2Array()
		var centroid_ray_num := PackedInt32Array()
		centroid_mean.resize(centroids.size())
		centroid_ray_num.resize(centroids.size())
		
		for i in ray_positions.size():
			centroid_mean[centroid_group[i]] += ray_positions[i]
			centroid_ray_num[centroid_group[i]] += 1
			
		for i in range(centroid_mean.size()):
			if centroid_ray_num[i] == 0:
				continue
			var new_pos = centroid_mean[i] / centroid_ray_num[i]
			centroids[i] = new_pos
	
	return centroids
