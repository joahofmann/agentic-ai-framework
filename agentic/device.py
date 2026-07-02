import torch

# ============================================================
# 1. DETECT THE COMPUTING DEVICE
# ============================================================

def get_device():
    return "cuda" if torch.cuda.is_available() else "cpu"


def print_device_info():
    device = get_device()
    print(f"PyTorch is currently using: {device.upper()}")

    if torch.cuda.is_available():
        print(f"GPU name: {torch.cuda.get_device_name(0)}")

    return device
