"""
Export a trained Stable-Baselines3 policy to ONNX so it can run natively
inside Godot at runtime (no Python required in the shipped game).

Example skeleton:

    import torch
    from stable_baselines3 import PPO

    model = PPO.load("checkpoints/mob_policy")

    class OnnxablePolicy(torch.nn.Module):
        def __init__(self, policy):
            super().__init__()
            self.policy = policy

        def forward(self, observation):
            return self.policy(observation, deterministic=True)

    onnxable_model = OnnxablePolicy(model.policy)
    dummy_input = torch.randn(1, OBS_SIZE)  # TODO: set OBS_SIZE

    torch.onnx.export(
        onnxable_model,
        dummy_input,
        "../ai/models/mob_behavior_v1.onnx",
        input_names=["observation"],
        output_names=["action"],
    )
"""

# TODO: implement export
