# ML Mob AI Setup

This scaffold sets up a PyTorch + godot-rl-agents pipeline for training
mob behavior, exported to ONNX for runtime inference in Godot.

## Folders

- `ml_training/` — Python/PyTorch training code. NOT part of the shipped
  game. Kept out of Godot's import tree via `ml_training/.gdignore`.
  - `envs/mob_env.py` — Gym-style wrapper around the Godot scene
  - `models/policy_net.py` — optional custom PyTorch network
  - `train.py` — training entrypoint (Stable-Baselines3 / PPO)
  - `export_onnx.py` — exports trained policy to ONNX
  - `checkpoints/` — training checkpoints (gitignored)
- `ai/` — the Godot-side AI integration. This IS part of the shipped game.
  - `models/` — exported `.onnx` model files
  - `inference/ml_controller.gd` — loads the ONNX model, runs inference
  - `behaviors/mob_behavior_tree.gd` — optional FSM/behavior-tree layer

## Setup steps

1. `pip install -r ml_training/requirements.txt` (use a venv)
2. Install the godot-rl-agents plugin into Godot:
   https://github.com/edbeeching/godot_rl_agents
3. Add an `AIController` node to your mob scene, define observations
   (raycasts, player position, health, etc.) and actions (movement, attack).
4. Write a reward function in GDScript on the mob/controller.
5. Run the Godot game in training mode, then run `ml_training/train.py`.
6. Once trained, run `ml_training/export_onnx.py` to produce
   `ai/models/mob_behavior_v1.onnx`.
7. Wire up `ai/inference/ml_controller.gd` in `scripts/mob.gd` to use the
   trained model at runtime.

## Decision: RL vs Imitation Learning

- **Reinforcement Learning** (default here): needs a reward function,
  trains via trial-and-error against a live Godot instance.
- **Imitation Learning**: record observation -> action pairs from human
  play, train a policy to mimic them (supervised learning, no reward
  function needed). If you'd rather do this, swap `train.py` for a
  standard PyTorch supervised training loop and skip the live-env
  connection in `mob_env.py`.
