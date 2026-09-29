# yerel-llm-8gb

Running large open-weight models on a laptop with **8 GB of VRAM**, using llama.cpp. No cloud API, no subscription — two Qwen models (a 35B-class MoE for coding, a 9B model for planning/reasoning) served locally, never at the same time, with every flag chosen for a measured reason.

Content is in Turkish; this README is the map.

## What's here

- **[kurulum.md](kurulum.md)** — the setup: two models, one 8 GB card, where the model files come from, and the llama.cpp flags with the before/after RAM numbers that justified each one.
- **[scripts/](scripts/)** — the Windows `cmd` launchers I actually use: start either model, check which one is running, stop it. They refuse to start a second model while one is already loaded. Paths are overridable with `LLAMA_DIR` and `MODEL`.
- **[olcum/](olcum/2026-09-30-hiz.md)** — tokens/s for both models (`llama-bench`, 5 runs), the exact commands, measurement conditions, and the raw output files. Generation: 54 tok/s (9B) and 46 tok/s (35B); prompt processing is ~2× slower on the 35B.
- **[bulgu-iq2-halusinasyon.md](bulgu-iq2-halusinasyon.md)** — a single observation, not a benchmark: the 35B model at IQ2_M invented a non-existent person and defended it when challenged. The note spells out what this does and doesn't show — model size and quantization are confounded.

## Hardware

| | |
|---|---|
| GPU | NVIDIA RTX 5050 Laptop — 8 GB VRAM |
| CPU | AMD Ryzen 7 250 (8C/16T, Zen4/AVX-512) |
| RAM | 16 GB DDR5-5600, single channel |
| Runtime | llama.cpp (CUDA build) |

The binding constraint turned out to be **RAM**, not VRAM — see kurulum.md.

## Tried it on your machine?

Numbers from one laptop aren't a benchmark. If you ran this setup (or a variant) on your own hardware, [share your numbers](https://github.com/tungarix/yerel-llm-8gb/issues/new?template=olcum.md) — GPU, RAM, flags, tokens/s. English or Turkish, both fine.

## License

MIT — see [LICENSE](LICENSE).
