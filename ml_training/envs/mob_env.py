"""
Gym-style environment wrapper for training mob behavior via godot-rl-agents.

This connects to a running instance of the Godot game (in "training mode")
over the godot-rl-agents socket bridge, and exposes it as a standard
Gymnasium environment for use with Stable-Baselines3.

Fill in:
  - observation_space / action_space to match what your AIController node
    in Godot exposes (raycasts, player relative position, health, etc.)
  - reward shaping, if you want to post-process rewards on the Python side
    in addition to (or instead of) the GDScript-side reward function.
"""

# from godot_rl.core.godot_env import GodotEnv

# TODO: define env class here
