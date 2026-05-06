from math import gcd

import numpy as np
import soundfile as sf
import torch
from scipy.signal import resample_poly


def load_wav(wav_path: str, sample_rate: int):
    """Load wav file and resample to target sample rate.

    Args:
        wav_path (str): Path to wav file.
        sample_rate (int): Target sample rate.

    Returns:
        torch.Tensor: Waveform tensor with shape (1, T).
    """
    data, sr = sf.read(wav_path, dtype="float32", always_2d=True)

    if sr != sample_rate:
        factor = gcd(sr, sample_rate)
        data = resample_poly(data, sample_rate // factor, sr // factor, axis=0).astype(np.float32)

    # data shape: (T, C) -> (C, T)
    waveform = torch.from_numpy(data.T.copy())

    if waveform.shape[0] > 1:
        waveform = torch.mean(waveform, dim=0, keepdim=True)

    return waveform
