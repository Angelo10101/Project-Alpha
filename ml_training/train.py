"""
Training entrypoint.

Typical flow:
  1. Launch the Godot game in training mode (either headless, or windowed
     for debugging), configured with the godot-rl-agents AIController.
  2. Connect via GodotEnv from mob_env.py.
  3. Train with Stable-Baselines3 (PPO recommended as a first pass).
  4. Save checkpoints periodically to ml_training/checkpoints/.

Example skeleton:

    from stable_baselines3 import PPO
    from envs.mob_env import make_env  # define this

    env = make_env()
    model = PPO("MlpPolicy", env, verbose=1)
    model.learn(total_timesteps=1_000_000)
    model.save("checkpoints/mob_policy")
"""

# TODO: implement training loop
