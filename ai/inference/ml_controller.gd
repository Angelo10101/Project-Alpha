extends Node
# ml_controller.gd
#
# Runtime inference controller: loads the exported ONNX model and turns
# an observation vector into a movement/action decision for a mob.
#
# If using godot-rl-agents' Sync/inference nodes, this can wrap or replace
# that node with game-specific glue code (e.g. converting raw sensor data
# from the mob into the observation format the model expects).
#
# TODO:
#   - load model from res://ai/models/mob_behavior_v1.onnx
#   - build_observation(mob) -> PackedFloat32Array
#   - get_action(observation) -> Vector2 (or whatever action space you used)

func get_action(observation: PackedFloat32Array) -> Vector2:
	push_warning("ml_controller.gd: get_action() not yet implemented")
	return Vector2.ZERO
