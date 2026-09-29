# yerel-llm-8gb

Running large open-weight models on a laptop with **8 GB of VRAM**, using llama.cpp. No cloud API, no subscription — two Qwen models (a 35B-class MoE for coding, a 9B model for planning/reasoning) served locally, never at the same time, with every flag chosen for a measured reason.

Content is in Turkish; this README is the map.

## What's here

- **[kurulum.md](kurulum.md)** — the setup: two models, one 8 GB card, the exact llama.cpp flags and the before/after RAM/VRAM numbers that justified each one.
- **[bulgu-iq2-halusinasyon.md](bulgu-iq2-halusinasyon.md)** — a finding: at very low bit-quantization (IQ2_M), a model's factual recall breaks down before its coding ability does — including a concrete, reproducible example of confident, invented facts.

## Hardware

| | |
|---|---|
| GPU | NVIDIA RTX 5050 Laptop — 8 GB VRAM |
| CPU | AMD Ryzen 7 250 (8C/16T, Zen4/AVX-512) |
| RAM | 16 GB DDR5-5600, single channel |
| Runtime | llama.cpp (CUDA build) |

The binding constraint turned out to be **RAM**, not VRAM — see kurulum.md.

## License

MIT — see [LICENSE](LICENSE).
