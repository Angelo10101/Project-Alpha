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

func get_action(mob: Node, player_pos: Vector2) -> Dictionary:
	var to_player = player_pos - mob.global_position
	var move_dir = to_player.normalized() if to_player.length() > 60.0 else Vector2.ZERO
	var should_shoot = to_player.length() < 400.0
	return {"move": move_dir, "shoot": should_shoot}
